
local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("UpdateInventory")
	
	function meta:UpdateSlot(id)
		if (!self.Inventory[id]) then return end
		
		net.Start("UpdateInventory")
			net.WriteUInt(id,5)
			net.WriteString(self.Inventory[id].Name)
			net.WriteUInt(self.Inventory[id].Quantity,32)
		net.Send(self)
	end
	
	function meta:AddItem(item,quantity)
		local Item = GetItemByName(item)
		
		if (!Item) then return end
		if (!self.Inventory) then self.Inventory = {} end
		
		--First search for existing items
		for i = 1,MAIN_MAX_SLOTS do 
			if (self.Inventory[i] and self.Inventory[i].Name == item) then
				self.Inventory[i].Quantity = self.Inventory[i].Quantity+quantity
				self:UpdateSlot(i)
				return
			end
		end
		
		--If it hasnt found any existing item, find an empty spot
		for i = 1,MAIN_MAX_SLOTS do 
			if (!self.Inventory[i]) then
				self.Inventory[i] = {Name = item,Quantity = quantity}
				self:UpdateSlot(i)
				return
			end
		end
	end
	
	function meta:RemoveItem(item,quantity)
		for i = 1,MAIN_MAX_SLOTS do 
			if (self.Inventory[i] and self.Inventory[i].Name == item) then
				if (self.Inventory[i].Quantity > quantity) then
					self.Inventory[i].Quantity = self.Inventory[i].Quantity-quantity
					self:UpdateSlot(i)
					return
				else
					quantity = quantity - self.Inventory[i].Quantity
					
					self.Inventory[i].Quantity = 0
					
					self:UpdateSlot(i)
					
					self.Inventory[i] = nil
					
					if (quantity > 0) then self:RemoveItem(item,quantity) return end
				end
			end
		end
	end
else
	net.Receive("UpdateInventory",function()
		local pl = LocalPlayer()
		
		if (!pl.Inventory) then pl.Inventory = {} end
		
		local ID = net.ReadUInt(5)
		pl.Inventory[ID] = {Name = net.ReadString(),Quantity = net.ReadUInt(32)}
		
		if (pl.Inventory[ID].Quantity <= 0) then pl.Inventory[ID] = nil end
		
		ReloadInventory()
	end)
end


function meta:GetInventory()
	return self.Inventory or {}
end

function meta:HasItem(name,quantity)
	if (!self.Inventory) then return end
	
	quantity = quantity or 1
	
	for k,v in pairs(self.Inventory) do
		if (v.Name == name and v.Quantity >= quantity) then
			return k
		end
	end
	
	return false
end

function meta:GetSlot(id)
	return (self.Inventory and self.Inventory[id]) or nil
end