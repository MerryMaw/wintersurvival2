
local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("UpdateAccountInventory")
	
	function meta:UpdateAccountSlot(id)
		if (!self.AccountInv[id]) then return end
		
		net.Start("UpdateAccountInventory")
			net.WriteUInt(id,5)
			net.WriteString(self.AccountInv[id].Name)
			net.WriteUInt(self.AccountInv[id].Quantity,32)
		net.Send(self)
	end
	
	function meta:AddAccountItem(item,quantity)
		local Item = GetItemByName(item)
		
		if (!Item) then return end
		if (!self.AccountInv) then self.AccountInv = {} end
		
		--First search for existing items
		for i = 1,MAIN_MAX_SLOTS do 
			if (self.AccountInv[i] and self.AccountInv[i].Name == item) then
				self.AccountInv[i].Quantity = self.AccountInv[i].Quantity+quantity
				self:UpdateAccountSlot(i)
				return
			end
		end
		
		--If it hasnt found any existing item, find an empty spot
		for i = 1,MAIN_MAX_SLOTS do 
			if (!self.AccountInv[i]) then
				self.AccountInv[i] = {Name = item,Quantity = quantity}
				self:UpdateAccountSlot(i)
				return
			end
		end
	end
	
	function meta:RemoveAccountItem(item,quantity)
		for i = 1,MAIN_MAX_SLOTS do 
			if (self.AccountInv[i] and self.AccountInv[i].Name == item) then
				if (self.AccountInv[i].Quantity > quantity) then
					self.AccountInv[i].Quantity = self.AccountInv[i].Quantity-quantity
					self:UpdateAccountSlot(i)
					return
				else
					quantity = quantity - self.AccountInv[i].Quantity
					
					self.AccountInv[i].Quantity = 0
					
					self:UpdateAccountSlot(i)
					
					self.AccountInv[i] = nil
					
					if (quantity > 0) then self:RemoveAccountItem(item,quantity) return end
				end
			end
		end
	end
else
	net.Receive("UpdateAccountInventory",function()
		local pl = LocalPlayer()
		
		if (!pl.AccountInv) then pl.AccountInv = {} end
		
		local ID = net.ReadUInt(5)
		pl.AccountInv[ID] = {Name = net.ReadString(),Quantity = net.ReadUInt(32)}
		
		if (pl.AccountInv[ID].Quantity <= 0) then pl.AccountInv[ID] = nil end
		
		ReloadAccountMenu()
	end)
end

function meta:GetAccountInventory()
	return self.AccountInv or {}
end

function meta:HasAccountItem(name,quantity)
	if (!self.AccountInv) then return end
	
	quantity = quantity or 1
	
	for k,v in pairs(self.AccountInv) do
		if (v.Name == name and v.Quantity >= quantity) then
			return k
		end
	end
	
	return false
end

function meta:GetAccountSlot(id)
	return (self.AccountInv and self.AccountInv[id]) or nil
end