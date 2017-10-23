local Folder  	= GM.Folder:gsub("gamemodes/","").."/gamemode/itemsystem/items"
local insert 	= table.insert

hook.Add("Initialize","LoadItems",function()
	local Items   	= file.Find(Folder.."/*.lua","LUA")
	local BaseItem	= {}
	
	GAMEMODE.Items 		= {}
	GAMEMODE.Recipes	= {}
	
	ITEM = {}
	
	AddCSLuaFile(Folder.."/base.lua")
	include(Folder.."/base.lua")
	
	BaseItem = table.Copy(ITEM)
	
	for k,v in pairs(Items) do
		if (v != "base.lua") then
			AddCSLuaFile(Folder.."/"..v)
			include(Folder.."/"..v)
			
			insert(GAMEMODE.Items,ITEM)
			if (ITEM.Recipe) then insert(GAMEMODE.Recipes,ITEM) end
			
			ITEM = table.Copy(BaseItem)
			
		end
	end
end)

function GetItemByName(name)
	for k,v in pairs( GAMEMODE.Items ) do
		if (v.Name == name) then return v end
	end
	
	return nil
end

function GetRecipeForItem(name)
	for k,v in pairs( GAMEMODE.Recipes ) do
		if (v.Name == name) then return v.Recipe,v end
	end
	
	return nil
end

function GetItemsByClass(class)
	local Dat = {}
	for k,v in pairs( GAMEMODE.Items ) do
		if (v.Class == class) then table.insert(Dat,v) end
	end
	
	return Dat 
end