
local meta = FindMetaTable("Player")

if (CLIENT) then
	local Num = 0
	local STi = CurTime()

	hook.Add("PlayerBindPress","SwapWeapons",function(pl,bind,pressed)
		if (LocalPlayer():IsPigeon()) then 
			if (bind:find("invprev")) then return true
			elseif (bind:find("invnext")) then return true end
		end
		
		if (pressed) then
			local Wep = pl:GetActiveWeapon()
			
			if (bind:find("invprev")) then 
				Num = Num+1
				STi = CurTime()
				
				if (Num > 9) then Num = 0 end
				
				net.Start("Select") net.WriteUInt(Num,4) net.SendToServer()
				
				surface.PlaySound("wintersurvival2/hud/itemequip.wav")
				
				if (IsValid(Wep)) then
					if (pl.Weapons and pl.Weapons[Num]) then Wep:SetWeaponHoldType(pl.Weapons[Num].Item.HoldType) 
					else Wep:SetWeaponHoldType("normal") end
				end
				
				return true
			elseif (bind:find("invnext")) then 
				Num = Num-1
				STi = CurTime()
				
				if (Num < 0) then Num = 9 end
				
				net.Start("Select") net.WriteUInt(Num,4) net.SendToServer()
				
				surface.PlaySound("wintersurvival2/hud/itemequip.wav")
				
				if (IsValid(Wep)) then
					if (pl.Weapons and pl.Weapons[Num]) then Wep:SetWeaponHoldType(pl.Weapons[Num].Item.HoldType) 
					else Wep:SetWeaponHoldType("normal") end
				end
				
				return true
			end
		end
	end)

	function GetWeaponSlot()
		return Num
	end

	function GetRecentSwapTime()
		return STi
	end
	
	net.Receive("ReceiveSelect",function() 
		local pl = net.ReadEntity()
		if (!IsValid(pl)) then return end
		
		pl.Select = net.ReadUInt(4) 
		local wep = pl:GetActiveWeapon()
		
		if (!IsValid(wep)) then return end
		
		if (pl.Weapons and pl.Weapons[pl.Select]) then wep:SetWeaponHoldType(pl.Weapons[pl.Select].Item.HoldType)
		else wep:SetWeaponHoldType("normal") end
	end)
	
	net.Receive("SetSlot",function() 
		local pl = net.ReadEntity()
		
		if (!IsValid(pl)) then return end
		if (!pl.Weapons) then pl.Weapons = {} end
		
		local id = net.ReadUInt(5)
		local na = net.ReadString()
		local A = GetItemByName(na)
		
		if (A) then pl.Weapons[id] = {Name = na,Item = A}
		else pl.Weapons[id] = nil end
		
		pl:EmitSound("wintersurvival2/hud/itemequip.wav")
	end)
	
	function RequestEquip(id,item)
		net.Start("SetSlotReq")
			net.WriteUInt(id,5)
			net.WriteString(item)
		net.SendToServer()
	end
	
	function RequestUnEquip(id)
		net.Start("SetSlotReqUn")
			net.WriteUInt(id,5)
		net.SendToServer()
	end
	
	function EraseSlot(id)
		net.Start("EraseSlot")
			net.WriteUInt(id,5)
		net.SendToServer()
	end
else
	util.AddNetworkString("Select")
	util.AddNetworkString("ReceiveSelect")
	util.AddNetworkString("SetSlot")
	util.AddNetworkString("SetSlotReq")
	util.AddNetworkString("SetSlotReqUn")
	util.AddNetworkString("EraseSlot")
	
	net.Receive("Select",function(siz,pl) pl.Select = net.ReadUInt(4) pl:UpdateSelection() end)
	net.Receive("SetSlotReq",function(siz,pl) pl:SetWeaponSlot(net.ReadUInt(5),net.ReadString()) end)
	net.Receive("SetSlotReqUn",function(siz,pl) pl:UnEquipWeaponSlot(net.ReadUInt(5)) end)
	net.Receive("EraseSlot",function(siz,pl) pl:UnEquipWeaponSlot(net.ReadUInt(5),true) end)
	
	function meta:UpdateSelection(pl)
		if (self.Select) then 
			net.Start("ReceiveSelect") 
				net.WriteEntity(self)
				net.WriteUInt(self.Select,4)
			if (IsValid(pl)) then net.Send(pl)
			else net.Broadcast() end
		end
		
		if (self:CanPlaceStructure()) then self:GhostRemove() end
	end
	
	function meta:SetWeaponSlot(id,item)
		if (!self:HasItem(item)) then return end
		if (!self.Weapons) then self.Weapons = {} end
		
		self:RemoveItem(item,1)
		
		local A = GetItemByName(item)
		
		if (self.Weapons[id]) then self:AddItem(self.Weapons[id].Name,1) end
		
		self.Weapons[id] = {Name = item,Item = A}
		
		net.Start("SetSlot")
			net.WriteEntity(self)
			net.WriteUInt(id,5)
			net.WriteString(item)
		net.Broadcast()
	end
	
	function meta:UnEquipWeaponSlot(id,bErase)
		if (!self.Weapons or !self.Weapons[id]) then return end
		
		if (!bErase) then self:AddItem(self.Weapons[id].Name,1) end
		
		self.Weapons[id] = nil
		
		net.Start("SetSlot")
			net.WriteEntity(self)
			net.WriteUInt(id,5)
		net.Broadcast()
	end
end

function meta:GetSelectedWeapon()
	return self.Select or 0
end