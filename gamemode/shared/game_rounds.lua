local meta = FindMetaTable("Player")
local Time = 10

if (SERVER) then
	util.AddNetworkString("RoundStart")
	
	function GM:StartCountDown()
		self.CountDown = CurTime()+Time+1
		
		--Cleanup the battleground before we start.
		for k,v in pairs(ents.FindByClass("ws_item")) 		do v:Remove() end
		for k,v in pairs(ents.FindByClass("ws_campfire")) 	do v:Remove() end
		for k,v in pairs(ents.FindByClass("ws_prop")) 		do v:Remove() end
		for k,v in pairs(ents.FindByClass("ws_barrel")) 	do v:Remove() end
		for k,v in pairs(ents.FindByClass("ws_alter")) 		do v:Remove() end
		for k,v in pairs(ents.FindByClass("ws_arrow")) 		do v:Remove() end
		for k,v in pairs(ents.FindByClass("ws_grave")) 		do v:Remove() end
		for k,v in pairs(ents.FindByClass("ws_shop")) 		do v:Remove() end
		
		--Generate a completly new rain of props :D
		self:GeneratePropRain()
		
		net.Start("RoundStart")
			net.WriteUInt(Time,8)
		net.Broadcast()
	end
	
	function meta:UpdateRoundTimer()
		if (!self.CountDown or self.CountDown<CurTime()) then return end
		
		net.Start("RoundStart")
			net.WriteUInt(math.floor(self.CountDown-CurTime()),8)
		net.Send(self)
	end
	
	hook.Add("Tick","CountDowner",function()
		if (GAMEMODE.GameOn) then
			if (#player.GetAll() < 2) then
				--TODO: Less than 2 players in the server
				GAMEMODE.CountDown = nil
				GAMEMODE.GameOn = false
				return
			elseif (#player.GetAllHumans() < 2) then
				GAMEMODE.CountDown = nil
				GAMEMODE.GameOn = false
				
				for k,v in pairs(player.GetAllHumans()) do
					v:AddAccountItem(table.Random(GetItemsByClass("account")).Name,1)
				end
				
				timer.Simple(Time,function() for k,v in pairs(player.GetAllHumans()) do v:Kill() end end)
				
				GAMEMODE:StartCountDown()
				return
			end
		end
		
		if (GAMEMODE.GameOn or !GAMEMODE.CountDown) then return end
		
		if (GAMEMODE.CountDown < CurTime()) then
			if (#player.GetAll() < 2) then
				GAMEMODE.CountDown = CurTime()+Time+1
				return
			end
			
			for k,v in pairs(player.GetAll()) do 
				if (v:IsPigeon()) then
					if (IsValid(v.Pigeon)) then v.Pigeon:Remove() end
					v:SetHuman(true)
					v:KillSilent()
					
					timer.Simple(1,function() if (IsValid(v) and !v:Alive()) then v:Spawn() end end)
				end
			end
			
			GAMEMODE.GameOn = true
		end
	end)
else
	net.Receive("RoundStart",function() GAMEMODE.CountDown = CurTime()+net.ReadUInt(8) end)
end

function GetCountDown()
	return GAMEMODE.CountDown
end





