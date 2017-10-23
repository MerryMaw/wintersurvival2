
local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("DropItemReq")
	
	function meta:DropItem(item,bAccount)
		if ((!bAccount and !self:HasItem(item)) or (bAccount and !self:HasAccountItem(item))) then return end
		
		if (bAccount) then self:RemoveAccountItem(item,1) return
		else self:RemoveItem(item,1) end
		
		SpawnWSItem(item,self:GetShootPos()+self:GetAimVector()*20)
	end
	
	net.Receive("DropItemReq",function(seq,pl) pl:DropItem(net.ReadString(),util.tobool(net.ReadBit())) end)
else
	function RequestDropItem(item,bAccount)
		net.Start("DropItemReq")
			net.WriteString(item)
			net.WriteBit(bAccount)
		net.SendToServer()
	end
end
		
		