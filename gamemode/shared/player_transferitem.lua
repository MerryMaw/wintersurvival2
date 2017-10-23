
if (SERVER) then	
	util.AddNetworkString("RequestTransfer")
	util.AddNetworkString("RequestTransferFrom")
	
	net.Receive("RequestTransfer",function(siz,pl)
		local item = net.ReadString()
		local quan = net.ReadUInt(32)
		local ent  = net.ReadEntity()
		
		if (!IsValid(ent) or !ent.AddItem) then return end
		
		if (!pl:HasItem(item,quan)) then return end
		
		pl:RemoveItem(item,quan)
		ent:AddItem(item,quan)
	end)
	
	net.Receive("RequestTransferFrom",function(siz,pl)
		local item = net.ReadString()
		local quan = net.ReadUInt(32)
		local ent  = net.ReadEntity()
		
		if (!IsValid(ent) or !ent.TakeItem) then return end
		
		ent:TakeItem(pl,item,quan)
	end)
else
	function TransferItems(item,quantity,to)
		net.Start("RequestTransfer")
			net.WriteString(item)
			net.WriteUInt(quantity,32)
			net.WriteEntity(to)
		net.SendToServer()
	end
	
	function DemandItems(item,quantity,from)
		net.Start("RequestTransferFrom")
			net.WriteString(item)
			net.WriteUInt(quantity,32)
			net.WriteEntity(from)
		net.SendToServer()
	end
end