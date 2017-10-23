concommand.Add("giveitem",function(pl,com,args)
	if (!IsValid(pl)) then return end
	if (!pl:IsAdmin()) then return end
	if (!args[1]) then return end
	
	pl:AddItem(args[1],tonumber(args[2] or 1))
end)

concommand.Add("revive",function(pl,com,args)
	if (IsValid(pl) and !pl:IsAdmin()) then return end
	if (!args[1]) then return end
	
	for k,v in pairs(player.GetAll()) do
		if (v:Nick():lower():find(args[1]) and v:IsPigeon()) then
			v:ChatPrint("You have been resurrected from the dead by an admin!")
			v:SetHuman(true)
			v:KillSilent()
			v:EmitSound("wintersurvival2/ritual/wololo.mp3")
		end
	end
end)

concommand.Add("TestNPC",function(pl,com,arg)
	if (!pl:IsAdmin()) then return end
	
	local ab = ents.Create("ws_npc_antlion")
	ab:SetPos(pl:GetEyeTrace().HitPos)
	ab:Spawn()
	ab:Activate()
end)