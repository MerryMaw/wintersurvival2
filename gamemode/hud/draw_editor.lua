
local Icons = {}
local Folders = {
	"wintersurvival2/hud/ws2_icons",
	"wintersurvival2/hud/ws1_icons",
	"settlement",
}

local insert = table.insert
local cos 	 = math.cos
local sin 	 = math.sin

local Editor = nil
local x,y	 = ScrW()/2,ScrH()/2
local MCO	 = Color(0,0,0,150)
local BCO 	 = Color(0,50,100,150)
local GCO 	 = Color(0,100,0,150)
local HCO 	 = Color(30,30,30,150)

local LimitS = 60
local LimitScale = 5

local ValidBones = {
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_L_Hand",
}

local ValidModels = {
	"models/props_junk/Rock001a.mdl",
	"models/props_debris/wood_board02a.mdl",
	"models/props_combine/breenlight.mdl",
}

local ValidHoldTypes = {
	"normal",
	"melee",
	"melee2",
	"fist",
	"knife",
	"smg",
	"ar2",
	"pistol",
	"rpg",
	"physgun",
	"grenade",
	"shotgun",
	"crossbow",
	"slam",
	"passive",
}


hook.Add("Initialize","AddEditorIcons",function()
	for k,v in pairs(Folders) do
		local F = file.Find("materials/"..v.."/*","GAME")
		
		for a,icon in pairs(F) do
			if (!icon:find(".vtf")) then
				if (icon:find(".vmt")) then icon = icon:gsub(".vmt","") end
				
				local IM,loadtime = Material(v.."/"..icon)
				insert(Icons,{Icon = IM,Path = v.."/"..icon,})
			end
		end
	end
end)

function GetItemIcons()
	return Icons
end



--Now the actual HUD

local Offset = Vector(0,0,50)
local Zero   = Vector(0,0,0)
local AngZ   = Angle(0,0,0)
local OneV   = Vector(1,1,1)

local function ReloadIcons()
	if (!Editor or !Editor:IsVisible()) then return end
	Editor.List:Clear()
	
	for k,v in pairs(Icons) do
		local a = Editor.List:Add("MBButton")
		a:SetSize(64,64)
		a.Paint = function(s,w,h)
			if (s.Pressed) then DrawRect(0,0,w,h,BCO)
			elseif (s.Hover) then DrawRect(0,0,w,h,HCO)
			else DrawRect(0,0,w,h,MCO) end
			
			DrawMaterialRect(0,0,w,h,MAIN_WHITECOLOR,v.Icon)
		end
		a.DoClick = function(s)
			Editor.Icon = v.Path
			Editor.IconEntry:SetText("Icon: "..Editor.Icon)
		end
	end
end

local function ReloadModelList()
	if (!Editor or !Editor:IsVisible()) then return end
	Editor.ModelList:Clear()
	
	for k,v in pairs(Editor.ModelManager.Items) do
		local a = Editor.ModelList:Add("MBButton")
		a:SetText("Model "..k)
		a:SetSize(Editor.ModelList:GetWide()-5,23)
		a.Paint = function(s,w,h)
			if (s.Pressed) then DrawRect(0,0,w,h,BCO)
			elseif (s.Hover) then DrawRect(0,0,w,h,HCO)
			else DrawRect(0,0,w,h,MCO) end
			
			DrawText(s.Text,"Trebuchet18",w/2,h/2,MAIN_TEXTCOLOR,1)
		end
		a.DoClick = function(s) 
			local X,Y  = gui.MousePos()
			local menu = DermaMenu()
			menu.Paint = function(s,w,h) DrawRect(0,0,w,h,MCO) end
			
			local Bones,op = menu:AddSubMenu( "Set bone" )
			op:SetColor(MAIN_TEXTCOLOR)
			Bones.Paint = function(s,w,h) DrawRect(0,0,w,h,MCO) end
			
			for d,b in pairs(ValidBones) do
				Bones:AddOption( b, function() if (v.Bone) then v.Bone = b end end ):SetColor(MAIN_TEXTCOLOR)
			end
			
			local Bones,op = menu:AddSubMenu( "Set model" )
			op:SetColor(MAIN_TEXTCOLOR)
			Bones.Paint = function(s,w,h) DrawRect(0,0,w,h,MCO) end
			
			for d,b in pairs(ValidModels) do
				Bones:AddOption( b, function() if (v.Model) then v.Model = b end end ):SetColor(MAIN_TEXTCOLOR)
			end
			
			menu:AddOption( "Select", function() 
				if (v.Bone) then
					Editor.ModelManager.Selected = k 
					
					Editor.SliderX:SetSlideX(0.5+v.Pos.x/LimitS)
					Editor.SliderX:TranslateValues(0.5+v.Pos.x/LimitS)
					
					Editor.SliderY:SetSlideX(0.5+v.Pos.y/LimitS)
					Editor.SliderY:TranslateValues(0.5+v.Pos.y/LimitS)
					
					Editor.SliderZ:SetSlideX(0.5+v.Pos.z/LimitS)
					Editor.SliderZ:TranslateValues(0.5+v.Pos.z/LimitS)
					
					Editor.SliderPitch:SetSlideX(0.5+v.Ang.p/360)
					Editor.SliderPitch:TranslateValues(0.5+v.Ang.p/360)
					
					Editor.SliderYaw:SetSlideX(0.5+v.Ang.y/360)
					Editor.SliderYaw:TranslateValues(0.5+v.Ang.y/360)
					
					Editor.SliderRoll:SetSlideX(0.5+v.Ang.r/360)
					Editor.SliderRoll:TranslateValues(0.5+v.Ang.r/360)
					
					Editor.SliderXScale:SetSlideX(v.Size.x/LimitScale)
					Editor.SliderXScale:TranslateValues(v.Size.x/LimitScale)
					
					Editor.SliderYScale:SetSlideX(v.Size.y/LimitScale)
					Editor.SliderYScale:TranslateValues(v.Size.y/LimitScale)
					
					Editor.SliderZScale:SetSlideX(v.Size.z/LimitScale)
					Editor.SliderZScale:TranslateValues(v.Size.z/LimitScale)
				end
			end):SetColor(MAIN_TEXTCOLOR)
			
			menu:AddOption( "Delete", function() if (v.Model) then table.remove(Editor.ModelManager.Items,k) ReloadModelList() end end ):SetColor(MAIN_TEXTCOLOR)
			
			menu:Open()
			menu:SetPos(X,Y)
		end
	end
end

function OpenEditor()
	if (!Editor) then 
		Editor = vgui.Create("MBFrame")
		Editor:SetPos(x-400,y-300)
		Editor:SetSize(800,600)
		Editor:SetTitle("Editor")
		Editor:SetDeleteOnClose(false)
		Editor:MakePopup()
		Editor.Paint = function(s,w,h) DrawRect(0,0,w,h,MCO) DrawRect(0,0,w,20,MCO) end
		Editor.OnClose = function(s) surface.PlaySound("wintersurvival2/hud/itemequip.wav") end
		Editor.Icon	= "wintersurvival2/hud/ws1_icons/icon_axe"
		
		--Icon list
		local Pane = vgui.Create( "DScrollPanel", Editor )
		Pane:SetPos(600,25)
		Pane:SetSize(195,390)
		Pane.Paint = function(s,w,h) DrawRect(0,0,w,h,MCO) end
		
		local l = vgui.Create("DIconLayout",Pane)
		l:SetSize(Pane:GetWide()-10,Pane:GetTall()-10)
		l:SetPos(5,5)
		l:SetSpaceY(5)
		l:SetSpaceX(5)

		Editor.List = l
		--End
		
		
		--Model list
		local Pane = vgui.Create( "DScrollPanel", Editor )
		Pane:SetPos(5,25)
		Pane:SetSize(195,390)
		Pane.Paint = function(s,w,h) DrawRect(0,0,w,h,MCO) end
		
		local l = vgui.Create("DListLayout",Pane)
		l:SetSize(Pane:GetWide()-10,Pane:GetTall()-10)
		l:SetPos(5,5)

		Editor.ModelList = l
		--End
		
		
		--Model manager
		local l = vgui.Create("DPanel",Editor)
		l:SetPos(205,25)
		l:SetSize(390,390)
		
		l.Entity = ClientsideModel("models/player/Group03/male_07.mdl")
		l.Entity:SetNoDraw(true)
		
		l.EntityItem = ClientsideModel("models/player/Group03/male_07.mdl")
		l.EntityItem:SetNoDraw(true)
		
		l.Items = {}
		
		l.CamDis = 200
		l.CamPos = Vector(l.CamDis,0,0)
		l.Origin = Offset
		
		l.Selected = 0
		
		l.Paint = function(s,w,h) 
			DrawRect(0,0,w,h,MCO) 
			
			local x, y = s:LocalToScreen( 0, 0 )
			
			cam.Start3D( s.Origin+s.CamPos, (-s.CamPos):Angle(), 90, x, y, w, h, 1, 4096 )
			cam.IgnoreZ( true )
				render.SuppressEngineLighting( true )
					s.Entity:DrawModel()
					
					local Mod = s.Entity:GetModel()
					local Time = CurTime()*10
					
					for k,v in pairs(s.Items) do
						if (v.Bone and v.Model and v.Pos and v.Ang and v.Size) then
							local ind = s.Entity:LookupBone(v.Bone)
							local Pos,Ang = s.Entity:GetBonePosition(ind)
							
							if (Pos and Ang) then
								s.EntityItem:SetModel(v.Model)
								
								local Rop = v.Pos*1
								local Roa = Ang*1
								
								Roa:RotateAroundAxis(Ang:Right(),v.Ang.p)
								Roa:RotateAroundAxis(Ang:Forward(),v.Ang.r)
								Roa:RotateAroundAxis(Ang:Up(),v.Ang.y)
								
								Rop:Rotate(Ang)
								
								local Org  = Pos+Rop
								local PAng = Roa
								
								local mat 	= Matrix()
								mat:Scale( v.Size or Zero )
								
								s.EntityItem:EnableMatrix( "RenderMultiply", mat )
								s.EntityItem:SetRenderOrigin(Org)
								s.EntityItem:SetRenderAngles(PAng)
								s.EntityItem:SetupBones()
								
								if (s.Selected == k) then
									local A = cos(Time)+2
									render.SetColorModulation(A,A,A)
										s.EntityItem:DrawModel()
									render.SetColorModulation(1,1,1)
									
									render.DrawLine( Org, Org+PAng:Forward()*20, MAIN_BLUECOLOR, false )
									render.DrawLine( Org, Org+PAng:Right()*20, MAIN_REDCOLOR, false )
									render.DrawLine( Org, Org+PAng:Up()*20, MAIN_GREENCOLOR, false )
									
									s.Origin = Org
								else
									s.EntityItem:DrawModel()
								end
							end
						end
					end
					
				render.SuppressEngineLighting( false )
			cam.IgnoreZ( false )
			cam.End3D()
		end
		
		l.Think = function(s)
			if (s.LastCamDis) then
				local mx,my = gui.MousePos()
				local dx,dy = mx-s.LastClickPos.x,my-s.LastClickPos.y
				
				s.CamDis = math.Clamp(s.LastCamDis + dy,10,200)
				s.CamPos = s.CamPos:GetNormal()*s.CamDis
			elseif (s.LastCamPos) then
				local mx,my = gui.MousePos()
				local dx,dy = mx-s.LastClickPos.x,my-s.LastClickPos.y
				
				local Ab = s.LastCamPos:Angle()
				Ab = Ab + Angle(-dy,-dx,0)
				
				s.CamPos = Ab:Forward()*s.CamDis
			end
		end
		
		l.OnMousePressed = function(s,m)
			if (m == MOUSE_RIGHT) then
				if (!s.LastClickPos) then 
					local x,y = gui.MousePos()
					s.LastClickPos = {x=x,y=y}
					s.LastCamDis = s.CamDis*1
				end
			elseif (m == MOUSE_LEFT) then
				if (!s.LastClickPos) then 
					local x,y = gui.MousePos()
					s.LastClickPos = {x=x,y=y}
					s.LastCamPos = s.CamPos*1
				end
			end
		end
		
		l.OnMouseReleased = function(s,m)
			if (s.LastClickPos) then
				s.LastClickPos = nil
				s.LastCamPos = nil
				s.LastCamDis = nil
			end
		end
		
		Editor.ModelManager = l
		--End
		
		--EditorPanels
		local l = vgui.Create("DPanel",Editor)
		l:SetPos(5,420)
		l:SetSize(790,175)
		l.Paint = function(s,w,h) DrawRect(0,0,w,h,MCO) end
		
		local a = vgui.Create("MBButton",l)
		a:SetText("Add Model")
		a:SetPos(5,5)
		a:SetSize(185,20)
		a.Paint = function(s,w,h)
			if (s.Pressed) then DrawRect(0,0,w,h,BCO)
			elseif (s.Hover) then DrawRect(0,0,w,h,HCO)
			else DrawRect(0,0,w,h,MCO) end
			
			DrawText(s.Text,"Trebuchet18",w/2,h/2,MAIN_TEXTCOLOR,1)
		end
		a.DoClick = function(s)
			local id = insert(Editor.ModelManager.Items,{
				Bone="ValveBiped.Bip01_R_Hand",
				Model="models/props_debris/wood_board02a.mdl",
				Size=Vector(1,1,1),
				Pos=Vector(0,0,0),
				Ang=Angle(0,0,0),
			})
			
			Editor.ModelManager.Selected = id
			
			Editor.SliderX:SetSlideX(0.5)
			Editor.SliderX:TranslateValues(0.5)
			
			Editor.SliderY:SetSlideX(0.5)
			Editor.SliderY:TranslateValues(0.5)
			
			Editor.SliderZ:SetSlideX(0.5)
			Editor.SliderZ:TranslateValues(0.5)
			
			Editor.SliderPitch:SetSlideX(0.5)
			Editor.SliderPitch:TranslateValues(0.5)
			
			Editor.SliderYaw:SetSlideX(0.5)
			Editor.SliderYaw:TranslateValues(0.5)
			
			Editor.SliderRoll:SetSlideX(0.5)
			Editor.SliderRoll:TranslateValues(0.5)
			
			local S = 1/LimitScale
			
			Editor.SliderXScale:SetSlideX(S)
			Editor.SliderXScale:TranslateValues(S)
			
			Editor.SliderYScale:SetSlideX(S)
			Editor.SliderYScale:TranslateValues(S)
			
			Editor.SliderZScale:SetSlideX(S)
			Editor.SliderZScale:TranslateValues(S)
			
			ReloadModelList()
		end
		
		local Title = vgui.Create("DTextEntry",l)
		Title:SetText("Item Name")
		Title:SetPos(5,55)
		Title:SetSize(185,20)
		
		local Icon = vgui.Create("DTextEntry",l)
		Icon:SetText("Icon: "..Editor.Icon)
		Icon:SetPos(205,145)
		Icon:SetSize(380,20)
		Icon:SetEditable(false)
		
		local Desc = vgui.Create("DTextEntry",l)
		Desc:SetText("Description")
		Desc:SetPos(5,80)
		Desc:SetSize(185,60)
		Desc:SetMultiline(true)
		
		local ModelP = vgui.Create("DComboBox",l)
		ModelP:SetPos(5,145)
		ModelP:SetSize(185,20)
		
		for k,v in pairs(ValidModels) do 
			if (k==1) then ModelP:AddChoice(v,nil,true)
			else ModelP:AddChoice(v) end
		end
		
		local HoldType = vgui.Create("DComboBox",l)
		HoldType:SetPos(600,145)
		HoldType:SetSize(185,20)
		
		for k,v in pairs(ValidHoldTypes) do 
			if (k==1) then HoldType:AddChoice(v,nil,true)
			else HoldType:AddChoice(v) end
		end
		
		Editor.IconEntry = Icon 
		
		--OffsetSliders... Gawd why does VGUI has to be so LOOONG!!!!
			--SlideX
			local B = vgui.Create("DLabel",l)
			B:SetPos(405,5)
			B:SetText("x offset")
			
			local B2 = vgui.Create("DLabel",l)
			B2:SetPos(490,5)
			B2:SetText("0")
			
			local SlideOffset = vgui.Create("DSlider",l)
			SlideOffset:SetPos(410,25)
			SlideOffset:SetSize(170,20)
			SlideOffset.Label = B2
			SlideOffset.Paint = function(s,w,h) DrawRect(0,h/2-2,w,2,MCO) end
			SlideOffset.TranslateValues = function(s, x, y )
				local V = math.ceil((x*LimitS-LimitS/2)*100)/100
				B2:SetText(tostring(V))
				
				if (Editor.ModelManager.Items[Editor.ModelManager.Selected]) then
					Editor.ModelManager.Items[Editor.ModelManager.Selected].Pos.x = V
				end
				return x, y
			end
			
			Editor.SliderX = SlideOffset
			--End
			
			--SlideY
			local B = vgui.Create("DLabel",l)
			B:SetPos(405,50)
			B:SetText("y offset")
			
			local B2 = vgui.Create("DLabel",l)
			B2:SetPos(490,50)
			B2:SetText("0")
			
			local SlideOffset = vgui.Create("DSlider",l)
			SlideOffset:SetPos(410,70)
			SlideOffset:SetSize(170,20)
			SlideOffset.Label = B2
			SlideOffset.Paint = function(s,w,h) DrawRect(0,h/2-2,w,2,MCO) end
			SlideOffset.TranslateValues = function(s, x, y )
				local V = math.ceil((x*LimitS-LimitS/2)*100)/100
				B2:SetText(tostring(V))
				
				if (Editor.ModelManager.Items[Editor.ModelManager.Selected]) then
					Editor.ModelManager.Items[Editor.ModelManager.Selected].Pos.y = V
				end
				return x, y
			end
			
			Editor.SliderY = SlideOffset
			--End
			
			--SlideZ
			local B = vgui.Create("DLabel",l)
			B:SetPos(405,95)
			B:SetText("z offset")
			
			local B2 = vgui.Create("DLabel",l)
			B2:SetPos(490,95)
			B2:SetText("0")
			
			local SlideOffset = vgui.Create("DSlider",l)
			SlideOffset:SetPos(410,115)
			SlideOffset:SetSize(170,20)
			SlideOffset.Label = B2
			SlideOffset.Paint = function(s,w,h) DrawRect(0,h/2-2,w,2,MCO) end
			SlideOffset.TranslateValues = function(s, x, y )
				local V = math.ceil((x*LimitS-LimitS/2)*100)/100
				B2:SetText(tostring(V))
				
				if (Editor.ModelManager.Items[Editor.ModelManager.Selected]) then
					Editor.ModelManager.Items[Editor.ModelManager.Selected].Pos.z = V
				end
				return x, y
			end
			
			Editor.SliderZ = SlideOffset
			--End
		--End
		
		--OffsetSliders Angles
			--SlidePitch
			local B = vgui.Create("DLabel",l)
			B:SetPos(605,5)
			B:SetText("Pitch")
			
			local B2 = vgui.Create("DLabel",l)
			B2:SetPos(690,5)
			B2:SetText("0")
			
			local SlideOffset = vgui.Create("DSlider",l)
			SlideOffset:SetPos(610,25)
			SlideOffset:SetSize(170,20)
			SlideOffset.Label = B2
			SlideOffset.Paint = function(s,w,h) DrawRect(0,h/2-2,w,2,MCO) end
			SlideOffset.TranslateValues = function(s, x, y )
				local V = math.ceil((x*360-180)*100)/100
				B2:SetText(tostring(V))
				
				if (Editor.ModelManager.Items[Editor.ModelManager.Selected]) then
					Editor.ModelManager.Items[Editor.ModelManager.Selected].Ang.p = V
				end
				return x, y
			end
			
			Editor.SliderPitch = SlideOffset
			--End
			
			--SlideYaw
			local B = vgui.Create("DLabel",l)
			B:SetPos(605,50)
			B:SetText("Yaw")
			
			local B2 = vgui.Create("DLabel",l)
			B2:SetPos(690,50)
			B2:SetText("0")
			
			local SlideOffset = vgui.Create("DSlider",l)
			SlideOffset:SetPos(610,70)
			SlideOffset:SetSize(170,20)
			SlideOffset.Label = B2
			SlideOffset.Paint = function(s,w,h) DrawRect(0,h/2-2,w,2,MCO) end
			SlideOffset.TranslateValues = function(s, x, y )
				local V = math.ceil((x*360-180)*100)/100
				B2:SetText(tostring(V))
				
				if (Editor.ModelManager.Items[Editor.ModelManager.Selected]) then
					Editor.ModelManager.Items[Editor.ModelManager.Selected].Ang.y = V
				end
				return x, y
			end
			
			Editor.SliderYaw = SlideOffset
			--End
			
			--SlideRoll
			local B = vgui.Create("DLabel",l)
			B:SetPos(605,95)
			B:SetText("Roll")
			
			local B2 = vgui.Create("DLabel",l)
			B2:SetPos(690,95)
			B2:SetText("0")
			
			local SlideOffset = vgui.Create("DSlider",l)
			SlideOffset:SetPos(610,115)
			SlideOffset:SetSize(170,20)
			SlideOffset.Label = B2
			SlideOffset.Paint = function(s,w,h) DrawRect(0,h/2-2,w,2,MCO) end
			SlideOffset.TranslateValues = function(s, x, y )
				local V = math.ceil((x*360-180)*100)/100
				B2:SetText(tostring(V))
				
				if (Editor.ModelManager.Items[Editor.ModelManager.Selected]) then
					Editor.ModelManager.Items[Editor.ModelManager.Selected].Ang.r = V
				end
				return x, y
			end
			
			Editor.SliderRoll = SlideOffset
			--End
		--End
		
		--OffsetScale
			--SlideX
			local B = vgui.Create("DLabel",l)
			B:SetPos(205,5)
			B:SetText("x offset")
			
			local B2 = vgui.Create("DLabel",l)
			B2:SetPos(290,5)
			B2:SetText("0")
			
			local SlideOffset = vgui.Create("DSlider",l)
			SlideOffset:SetPos(210,25)
			SlideOffset:SetSize(170,20)
			SlideOffset.Label = B2
			SlideOffset.Paint = function(s,w,h) DrawRect(0,h/2-2,w,2,MCO) end
			SlideOffset.TranslateValues = function(s, x, y )
				local V = math.ceil(math.max(0.01,x*LimitScale)*100)/100
				B2:SetText(tostring(V))
				
				if (Editor.ModelManager.Items[Editor.ModelManager.Selected]) then
					Editor.ModelManager.Items[Editor.ModelManager.Selected].Size.x = V
				end
				return x, y
			end
			
			Editor.SliderXScale = SlideOffset
			--End
			
			--SlideY
			local B = vgui.Create("DLabel",l)
			B:SetPos(205,50)
			B:SetText("y offset")
			
			local B2 = vgui.Create("DLabel",l)
			B2:SetPos(290,50)
			B2:SetText("0")
			
			local SlideOffset = vgui.Create("DSlider",l)
			SlideOffset:SetPos(210,70)
			SlideOffset:SetSize(170,20)
			SlideOffset.Label = B2
			SlideOffset.Paint = function(s,w,h) DrawRect(0,h/2-2,w,2,MCO) end
			SlideOffset.TranslateValues = function(s, x, y )
				local V = math.ceil(math.max(0.01,x*LimitScale)*100)/100
				B2:SetText(tostring(V))
				
				if (Editor.ModelManager.Items[Editor.ModelManager.Selected]) then
					Editor.ModelManager.Items[Editor.ModelManager.Selected].Size.y = V
				end
				return x, y
			end
			
			Editor.SliderYScale = SlideOffset
			--End
			
			--SlideZ
			local B = vgui.Create("DLabel",l)
			B:SetPos(205,95)
			B:SetText("z offset")
			
			local B2 = vgui.Create("DLabel",l)
			B2:SetPos(290,95)
			B2:SetText("0")
			
			local SlideOffset = vgui.Create("DSlider",l)
			SlideOffset:SetPos(210,115)
			SlideOffset:SetSize(170,20)
			SlideOffset.Label = B2
			SlideOffset.Paint = function(s,w,h) DrawRect(0,h/2-2,w,2,MCO) end
			SlideOffset.TranslateValues = function(s, x, y )
				local V = math.ceil(math.max(0.01,x*LimitScale)*100)/100
				B2:SetText(tostring(V))
				
				if (Editor.ModelManager.Items[Editor.ModelManager.Selected]) then
					Editor.ModelManager.Items[Editor.ModelManager.Selected].Size.z = V
				end
				return x, y
			end
			
			Editor.SliderZScale = SlideOffset
			--End
		--End
		
		local Compile = vgui.Create("MBButton",l)
		Compile:SetText("Compile")
		Compile:SetPos(5,30)
		Compile:SetSize(185,20)
		Compile.Paint = function(s,w,h)
			if (s.Pressed) then DrawRect(0,0,w,h,BCO)
			elseif (s.Hover) then DrawRect(0,0,w,h,HCO)
			else DrawRect(0,0,w,h,MCO) end
			
			DrawText(s.Text,"Trebuchet18",w/2,h/2,MAIN_TEXTCOLOR,1)
		end
		Compile.DoClick = function(s)
			local Text = ""
		
			Text = Text.."ITEM.Name\t= [["..Title:GetValue().."]]\n"
			Text = Text.."ITEM.Desc\t= [["..Desc:GetValue().."]]\n"
			Text = Text.."ITEM.Model\t= [["..ModelP:GetValue().."]]\n"
			Text = Text.."ITEM.Icon\t= Material([["..Editor.Icon.."]])\n"
			Text = Text.."ITEM.HoldType\t= [["..HoldType:GetValue().."]]\n"
			Text = Text.."ITEM.Structure\t= {\n"
			
			for k,v in pairs(Editor.ModelManager.Items) do
				Text = Text.."\t{\n"
				Text = Text.."\t\tBone\t= \""..v.Bone.."\",\n"
				Text = Text.."\t\tModel\t= \""..v.Model.."\",\n"
				Text = Text.."\t\tSize\t= Vector("..v.Size.x..","..v.Size.y..","..v.Size.z.."),\n"
				Text = Text.."\t\tPos \t= Vector("..v.Pos.x..","..v.Pos.y..","..v.Pos.z.."),\n"
				Text = Text.."\t\tAng \t= Angle("..v.Ang.p..","..v.Ang.y..","..v.Ang.r.."),\n"
				Text = Text.."\t},\n"
			end
			
			Text = Text.."}\n"
			
			if (!file.Exists("wsitems","DATA")) then file.CreateDir("wsitems") end
			file.Write("wsitems/"..Title:GetValue()..".txt",Text)
			
			print("Item has been compiled and is located in garrysmod/data/wsitems folder.")
		end
		--End 
	end
	
	Editor.ModelManager.CamDis = 200
	Editor.ModelManager.CamPos = Vector(200,0,0)
		
	Editor:SetVisible(true)
	
	ReloadIcons()
end



concommand.Add("ws_openeditor",function(pl,com,arg) OpenEditor() end)




