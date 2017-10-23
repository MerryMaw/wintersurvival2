
local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("SetFatigue")
	
	local Tick = CurTime()
	
	function meta:SetFatigue(s)
		if (s > 100) then self:TakeDamage(s-100) s = 100 end
		s = math.Clamp(s,0,100)
		
		self.Fatigue = s
		
		net.Start("SetFatigue") 
			net.WriteUInt(s,8)
		net.Send(self)
	end
	
	function meta:AddFatigue(s)
		self:SetHeat(self:GetFatigue()+s)
	end
	
	hook.Add("Tick","Fatigue",function()
		if (Tick < CurTime()) then
			for k,v in pairs(player.GetAllHumans()) do
				local Fat = v.Fatigue or 0
				
				if (Fat > 0) then Fat = Fat-2 end
				Fat = Fat+math.ceil(v:GetVelocity():Length()/100)
				
				v:SetFatigue(Fat)
			end
			
			Tick = CurTime()+0.5
		end
	end)
else
	net.Receive("SetFatigue",function()
		LocalPlayer().Fatigue = net.ReadUInt(8)
	end)
end
	
function meta:GetFatigue()
	return self.Fatigue or 0
end
	