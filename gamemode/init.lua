
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

hook.Remove("Initialize","LoadGearFox")

local models = {
	"models/player/Group03/female_01.mdl",
	"models/player/Group03/female_02.mdl",
	"models/player/Group03/female_03.mdl",
	"models/player/Group03/female_04.mdl",
	"models/player/Group03/male_01.mdl",
	"models/player/Group03/male_02.mdl",
	"models/player/Group03/male_03.mdl",
	"models/player/Group03/male_04.mdl",
	"models/player/Group03/male_05.mdl",
	"models/player/Group03/male_06.mdl",
	"models/player/Group03/male_07.mdl",
	"models/player/Group03/male_08.mdl",
	"models/player/Group03/male_09.mdl",
}
	
function GM:Initialize()
	resource.AddDir("sound/wintersurvival2")
	resource.AddDir("materials/wintersurvival2")
	resource.AddDir("materials/settlement")
	resource.AddDir("materials/mixerman3d")
	resource.AddDir("materials/lam")
	
	resource.AddDir("models/mixerman3d")
	
	resource.AddDir("materials/gearfox") 
	resource.AddDir("materials/mawbase") 
	resource.AddDir("models/gearfox") 
	resource.AddDir("sound/mawbase") 
	
	resource.AddFile("models/weapons/w_archersword/w_archersword.mdl")
	resource.AddFile("materials/models/weapons/archersword.vmt")
end

function GM:PlayerAuthed(pl)
	pl:UpdateHumans()
	pl:UpdatePigeons()
	pl:UpdateRoundTimer()
end

function GM:PlayerInitialSpawn(pl)
	if (!self.CountDown and #player.GetAll() > 1) then self:StartCountDown() end
	pl:SetHuman(false)
end
 
function GM:PlayerSpawn(pl)
	pl:SetHeat(0)
	pl:SetHunger(0)
	pl:SetFatigue(0)
	pl:SetWater(0)
	
	if (pl:IsPigeon()) then
		pl:SetNoDraw(true)
		pl:SetNotSolid(true)
		pl:SetMoveType(MOVETYPE_NONE)
		
		pl:SpawnPigeon()
	else
		--hook.Call("PlayerSetModel",self,pl)
		
		pl:SetModel(Model(models[math.random(#models)]))
		pl:Give("hands")
		pl:SelectWeapon("hands")
	end
end

function GM:PlayerCanHearPlayersVoice()
	return true
end

function GM:Think()
end

local Up = Vector(0,0,20)

function GM:DoPlayerDeath( pl, attacker, dmginfo )
	if (!pl:IsPigeon()) then 
		if (#player.GetAllHumans() > 1) then
			local a = ents.Create("ws_grave")
			a:SetPos(pl:GetPos()+Up)
			a:SetAngles(Angle(0,math.random(0,360),0))
			a:Spawn()
			a:Activate()
			a:AddItem("Meat",math.random(8,10))
			
			for k,v in pairs(pl:GetInventory()) do
				a:AddItem(v.Name,v.Quantity)
			end
		end
		
		pl:CreateRagdoll() 
		pl:SetHuman(false) 
		pl:ResetKnownRecipes()
	end
	
end

function GM:PlayerDeathSound()
	return true
end

function GM:PlayerShouldTakeDamage( pl, inf )
	if (inf:IsPlayer() and pl:IsPlayer() and !pl:IsPigeon()) then
		if (self.CountDown > CurTime()-MAIN_PVPTIMER) then
			return false
		end
	end
	
	return true
end
 

