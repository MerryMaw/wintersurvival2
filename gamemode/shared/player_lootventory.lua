local insert = table.insert

if (SERVER) then	
	util.AddNetworkString("OpenLootventory")
	util.AddNetworkString("DemandLootventoryUpdate")
	
	function OpenLootventory(pl,items,entity)
		if (!IsValid(pl) or !items) then return end
		
		net.Start("OpenLootventory")
			net.WriteEntity(entity)
			for k,v in pairs(items) do
				if (v.Name and v.Quantity) then
					net.WriteBit(true)
					net.WriteString(v.Name)
					net.WriteUInt(v.Quantity,32)
				end
			end
		net.Send(pl)
	end
	
	net.Receive("DemandLootventoryUpdate",function(siz,pl)
		local ent = net.ReadEntity()
		
		if (!IsValid(ent) or !ent.GetItems) then return end
		if (pl:GetPos():Distance(ent:GetPos()) > 200) then return end
		
		OpenLootventory(pl,ent:GetItems(),ent)
	end)
else
	net.Receive("OpenLootventory",function()
		local dat = {}
		local ent = net.ReadEntity()
		
		while (util.tobool(net.ReadBit())) do
			local Ab = GetItemByName(net.ReadString())
			local Co = net.ReadUInt(32)
			
			if (Ab and Co > 0) then insert(dat,{Name = Ab.Name, Quantity = Co}) end
		end
		
		MakeLootventory(dat,ent)
		GAMEMODE:OnSpawnMenuOpen()
	end)
	
	function DemandLootventoryUpdate(entity)
		if (!IsLootventoryOpen()) then return end
		
		net.Start("DemandLootventoryUpdate")
			net.WriteEntity(entity)
		net.SendToServer()
	end
end