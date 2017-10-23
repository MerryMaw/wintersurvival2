
if (SERVER) then
	util.AddNetworkString("LoadEntity_WS")
	
	net.Receive("LoadEntity_WS",function(siz,pl)
		local Ab = net.ReadEntity()
		
		if (Ab:IsPlayer()) then 
			Ab:UpdateSelection(pl) 
			--pl:UpdateStream(Ab)
		end
	end)
else
	local Q = 0
	function GM:NetworkEntityCreated(ent)
		Q=Q+1
		timer.Simple(math.Rand(0.1,0.2)*Q,function()
			net.Start("LoadEntity_WS") net.WriteEntity(ent) net.SendToServer()
			Q=Q-1
		end)
	end
end