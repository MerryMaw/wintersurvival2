
local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("CreateRecipe")
	util.AddNetworkString("ResetRecipes")
	
	function meta:CreateRecipe(item)
		if (!self:CanCreateItem(item)) then return end
		
		local Rec,Item = GetRecipeForItem(item)
	
		if (!Rec) then return false end
		
		for a,b in pairs(Rec.Resources) do
			self:RemoveItem(a,b)
		end
		
		self:AddItem(item,1)
	end
	
	function meta:ResetKnownRecipes()
		net.Start("ResetRecipes") net.Send(self)
	end
	
	net.Receive("CreateRecipe",function(siz,pl) pl:CreateRecipe(net.ReadString()) end)
else
	function RequestCreateRecipe(item)
		net.Start("CreateRecipe")
			net.WriteString(item)
		net.SendToServer()
	end
	
	function DiscoverItems(Combinations)
		local Dat = {}
		
		for k,v in pairs(GAMEMODE.Recipes) do
			local Ab 	= v.Recipe.Resources
			local Tools = v.Recipe.Tools
			local PA	= table.Count(Ab)
			
			if (PA == table.Count(Combinations)) then
				local Check = 0
				
				for e,c in pairs(Combinations) do
					for a,b in pairs(Ab) do
						if (c.Name == a and c.Quantity == b) then Check = Check+1 break end
					end
				end
				
				if (Check == PA) then table.insert(Dat,v) end
			end
		end
		
		if (table.Count(Dat) > 0) then 
			for e,c in pairs(GAMEMODE.KnownRecipes) do
				for k,v in pairs(Dat) do
					if (v.Name == c.Name) then table.remove(Dat,k) break end
				end
			end
			
			if (table.Count(Dat) > 0) then
				for k,v in pairs(Dat) do
					LocalPlayer():AddNote("You discovered the recipe for "..v.Name)
				end
				
				table.Add(GAMEMODE.KnownRecipes,Dat) 
				
				ReloadRecipes()
			end
		end
	end
	
	net.Receive("ResetRecipes",function()
		GAMEMODE.KnownRecipes = {
			GetItemByName("Axe"),
			GetItemByName("Campfire"),
			GetItemByName("Pickaxe"),
		}
		
		ReloadRecipes()
	end)
end

function meta:CanCreateItem(name)
	local Rec,Item = GetRecipeForItem(name)
	
	if (!Rec) then return false end
	
	for k,v in pairs(Rec) do
		for a,b in pairs(v) do
			if (!self:HasItem(a,b)) then return false end
		end
	end
	
	return true
end