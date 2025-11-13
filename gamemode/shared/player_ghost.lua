local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("Ghost")
	util.AddNetworkString("GhostRemove")
	
	function meta:GhostStructure(item)
		item = GetItemByName(item)
		
		if (!item or !item.Ghost) then return end
		if (!self.StructurePlace) then self.StructurePlace = true end
		
		net.Start("Ghost")
			net.WriteString(item.Name)
		net.Send(self)
	end
	
	function meta:GhostRemove()
		self.StructurePlace = false
		net.Start("GhostRemove") net.Send(self)
	end
else
	local Zero = Vector(0,0,0)
	local gr   = Color(0,255,0,100)
	local Box  = Vector(8,8,8)
	
	net.Receive("Ghost",function()
		local pl = LocalPlayer()
		local It = GetItemByName(net.ReadString())
		
		if (!It) then return end
		if (!IsValid(pl.Ghost)) then pl.Ghost = ClientsideModel("error.mdl") pl.Ghost:SetNoDraw(true) end
		
		pl.GhostItem = It
		pl.StructurePlace = true
	end)
	
	net.Receive("GhostRemove",function() LocalPlayer().StructurePlace = false end)

	hook.Add("PostDrawTranslucentRenderables","GhostStructure",function()
		local pl  	= LocalPlayer()
		
		if (pl:IsPigeon() or !pl.GhostItem or !pl.GhostItem.Ghost or !IsValid(pl.Ghost) or !pl.StructurePlace) then return end
		
		local Ghost = pl.Ghost
		local Aim	= Angle(0,pl:GetAimVector():Angle().y+90,0)
		local Pos   = util.TraceHull({
			start 	= pl:GetShootPos(),
			endpos 	= pl:GetShootPos()+pl:GetAimVector()*pl.GhostItem.Range,
			filter 	= pl,
			mins 	= Box*-1,
			maxs	= Box,
		})
		
		local CanP  = pl:CanPlaceStructure(Pos)
		Pos = Pos.HitPos
		
		for k,v in pairs(pl.GhostItem.Ghost) do
			local OffPos = v.Pos*1
			OffPos:Rotate(Aim)
			
			Ghost:SetModel(v.Model)
			Ghost:SetRenderOrigin(Pos+OffPos)
			Ghost:SetRenderAngles(v.Ang+Aim)
			
			local mat 	= Matrix()
			mat:Scale( v.Size or Zero )
			
			Ghost:EnableMatrix( "RenderMultiply", mat )
			Ghost:SetupBones()
			
			if (CanP) then render.SetColorModulation(0,10,0)
			else render.SetColorModulation(10,0,0) end
			
			render.SetBlend(0.7)
				Ghost:DrawModel()
			render.SetColorModulation(1,1,1)
			render.SetBlend(1)
		end
		
		Ghost:SetRenderOrigin(Pos)
	end)
end

function meta:CanPlaceStructure(Tr)
	if (Tr and Tr.HitPos) then
		local A 	= util.PointContents( Tr.HitPos )
		local Ang 	= Tr.HitNormal:Angle();
        Ang:Normalize();
		
		if (A == CONTENTS_WATER or A == CONTENTS_WATER+CONTENTS_TRANSLUCENT ) then return false end
		if (Ang.p < -120 or Ang.p > -60) then return false end
		
		if (!Tr.HitWorld) then return false end
	end
	
	return self.StructurePlace
end