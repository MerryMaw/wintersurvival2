
local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("SetHuman")
	
	function meta:SetHuman(bool)
		self.IsHuman 		= bool
		self.Inventory 		= {}
		self.Weapons 		= {}
		
		net.Start("SetHuman")
			net.WriteEntity(self)
			net.WriteBit(self.IsHuman)
		net.Broadcast()
	end
	
	function meta:UpdateHumans()
		for k,v in pairs(player.GetAll()) do
			if (v.IsHuman) then
				timer.Simple(math.Rand(0.1,0.2),function()
					net.Start("SetHuman")
						net.WriteEntity(v) 
						net.WriteBit(true)
					net.Send(self)
				end)
			end
		end
	end
else
	net.Receive("SetHuman",function() 
		local pl = net.ReadEntity()
		
		pl.IsHuman 		= util.tobool(net.ReadBit()) 
		pl.Inventory 	= {}
		pl.Weapons 		= {}
	end)
end

function meta:IsPigeon()
	return !util.tobool(self.IsHuman)
end

function player.GetAllHumans()
	local dat = {}
	
	for k,v in pairs(player.GetAll()) do
		if (!v:IsPigeon()) then
			table.insert(dat,v)
		end
	end
	
	return dat 
end

function player.GetAllHumansAlive()
	local dat = {}
	
	for k,v in pairs(player.GetAll()) do
		if (!v:IsPigeon() and v:Alive()) then
			table.insert(dat,v)
		end
	end
	
	return dat 
end
