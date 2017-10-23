
local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("UseItem")
	util.AddNetworkString("UseItemReq")
	
	function meta:UseItem(item,bAccount)
		if ((!bAccount and !self:HasItem(item)) or (bAccount and !self:HasAccountItem(item))) then return end
		
		local IT = GetItemByName(item)
		
		if (IT.OnUse) then
			IT:OnUse(self)
			
			net.Start("UseItem")
				net.WriteEntity(self)
				net.WriteString(item)
			net.Broadcast()
		end
	end
	
	net.Receive("UseItemReq",function(seq,pl) pl:UseItem(net.ReadString(),util.tobool(net.ReadBit())) end)
else
	net.Receive("UseItem",function()
		local pl = net.ReadEntity()
		local it = GetItemByName(net.ReadString())
		
		if (it.OnUse) then it:OnUse(pl) end
	end)
	
	function RequestUseItem(item,bAccount)
		net.Start("UseItemReq")
			net.WriteString(item)
			net.WriteBit(bAccount)
		net.SendToServer()
	end
end
		
		