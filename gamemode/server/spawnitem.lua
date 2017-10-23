
function SpawnWSItem(Item,pos)
	local IT = GetItemByName(Item)
		
	local drop = ents.Create("ws_item")
	drop.Item = IT
	drop:SetModel(drop.Item.Model)
	drop:SetPos(pos)
	drop:Spawn()
		
	return drop
end