AddCSLuaFile("autolua.lua")
include("autolua.lua")

addLuaCSFolder("hud")
addLuaCSFolder("client")

addLuaSHFolder("shared")
addLuaSHFolder("itemsystem")

addLuaSVFolder("server")

GM.Name 		= "Winter Survival 2 - v1.3"
GM.Author 		= "The Maw"
GM.Email 		= "cjbremer@gmail.com"
GM.Website 		= "www.devinity2.com"

local Zero = Vector(0,0,0)

function GM:Move(ply,mv)
	if (ply:IsPigeon() or !ply:Alive()) then mv:SetVelocity(-ply:GetVelocity()) return mv end
end

