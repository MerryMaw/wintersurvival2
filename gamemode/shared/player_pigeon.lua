local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("AssignPigeon")
	
	function meta:SpawnPigeon()
		if (IsValid(self.Pigeon)) then return end 
		
		self.Pigeon = ents.Create("ws_pigeon")
		self.Pigeon:SetPos(self:GetPos())
		self.Pigeon:SetPlayer(self)
		self.Pigeon:Spawn()
		self.Pigeon:Activate()
		
		print("Spawned Pigeon: "..self:Nick())
		
		timer.Simple(0.2,function()
		net.Start("AssignPigeon")
			net.WriteEntity(self)
			net.WriteEntity(self.Pigeon)
		net.Broadcast() end)
	end
	
	function meta:UpdatePigeons()
		for k,v in pairs(player.GetAll()) do
			if (IsValid(v.Pigeon)) then
				timer.Simple(math.Rand(0.1,0.2),function()
					net.Start("AssignPigeon")
						net.WriteEntity(v)
						net.WriteEntity(v.Pigeon)
					net.Send(self)
				end)
			end
		end
	end
else
	net.Receive("AssignPigeon",function() net.ReadEntity().Pigeon = net.ReadEntity() end)
end

function meta:GetPigeon()
	return self.Pigeon
end


