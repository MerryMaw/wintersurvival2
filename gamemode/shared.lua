AddCSLuaFile("autolua.lua")
include("autolua.lua")

addLuaCSFolder("hud")
addLuaCSFolder("hud/vgui")
addLuaCSFolder("client")

addLuaSHFolder("shared")
addLuaSHFolder("itemsystem")

addLuaSVFolder("server")

GM.Name 		= "Winter Survival 2 - v2.0.0b"
GM.Author 		= "The Maw"
GM.Email 		= "cjbremer@gmail.com"
GM.Website 		= "www.devinity2.com"

function GM:Move(ply,mv)
	if (ply:IsPigeon() or not ply:Alive()) then mv:SetVelocity(-ply:GetVelocity()) return mv end
end

