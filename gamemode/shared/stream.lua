local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("STREAM")
	util.AddNetworkString("ENDSTREAM")
	
	concommand.Add("StreamURL",function(pl,com,args)
		if (!IsValid(pl)) then return end
		
		pl:StreamSong(table.concat(args," "))
	end)
	
	concommand.Add("EndStream",function(pl,com,args)
		if (!IsValid(pl)) then return end
		
		pl:EndStream()
	end)
	
	function meta:StreamSong(URL)
		if (!self:IsAdmin()) then return end
		
		self.URL = URL
		
		net.Start("STREAM")
			net.WriteEntity(self)
			net.WriteString(URL)
		net.Broadcast()
	end
	
	function meta:EndStream()
		if (!self:IsAdmin()) then return end
		
		self.URL = nil
		
		net.Start("ENDSTREAM")
			net.WriteEntity(self)
		net.Broadcast()
	end
	
	function meta:UpdateStream(v)
		if (IsValid(v) and v.URL) then
			net.Start("STREAM")
				net.WriteEntity(v)
				net.WriteString(v.URL)
			net.Send(self)
		end
	end
else
	local Emitter 	= ParticleEmitter( Vector(0,0,0) )
	local Up		= Vector(0,0,20)
	local Retries	= 0
	local Streams 	= {}
	
	function TryURL(url,pl)
		if (!IsValid(pl)) then return end
		
		local ID = pl:UniqueID()
		if (Streams[ID]) then Streams[ID]:Stop() Streams[ID] = nil end
		
		if (Retries < 4) then
			sound.PlayURL( url, "3d mono noplay", function( chan )
				if (!chan) then TryURL(url,pl) Retries = Retries+1
				elseif (IsValid(pl)) then Streams[ID] = chan chan:Play() Retries = 0 end
			end)
		else
			Retries = 0
			Msg("Couldn't play "..url.." \n")
		end
	end
	
	net.Receive("STREAM",function()
		local pl = net.ReadEntity()
		local URL = net.ReadString()
		
		if (!IsValid(pl)) then return end
		
		TryURL(URL,pl)
	end)
	
	net.Receive("ENDSTREAM",function()
		local pl = net.ReadEntity()
		
		if (!IsValid(pl)) then return end
		
		local ID = pl:UniqueID()
		if (Streams[ID]) then Streams[ID]:Stop() Streams[ID] = nil end
	end)
		
	hook.Add("Think","Streamer",function()
		for k,st in pairs(Streams) do
			if (!st) then table.remove(Streams,k)
			else
				local v = player.GetByUniqueID(k)
				
				if (!IsValid(v)) then 
					st:Stop() 
					table.remove(Streams,k)
				else
					local pig = v:GetPigeon()
					local Pos = v:GetPos()
					
					if (IsValid(pig)) then Pos = pig:GetPos() end
					
					if (!v.PTime or v.PTime < CurTime()) then
						local particle = Emitter:Add( "lam/musicnotes/note"..math.random(1,2), Pos + VectorRand()*15)
						particle:SetDieTime( 1 )
						particle:SetVelocity( Up )
						
						particle:SetStartAlpha( 250 )
						particle:SetEndAlpha( 0 )
						
						particle:SetStartSize( 10 )
						particle:SetEndSize( 10 )
						
						particle:SetColor( math.random( 0, 250 ), math.random( 0, 250 ), math.random( 0, 250 ) )
						
						v.PTime = CurTime()+0.1
					end
					
					st:SetPos(Pos)
				end
			end
		end
	end)
end