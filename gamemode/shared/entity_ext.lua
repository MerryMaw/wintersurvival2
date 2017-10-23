local meta = FindMetaTable("Entity")

function meta:IsTree()
	local model = self:GetModel()
	local class = self:GetClass()
	return ((model:find("tree") or model:find("pine")) and !class:find("ws_"))
end

function meta:IsRock()
	local model = self:GetModel()
	local class = self:GetClass()
	return (model:find("rock") and !class:find("ws_"))
end

function meta:IsPlant()
	local model = self:GetModel()
	local class = self:GetClass()
	return (model:find("antlionhill") and !class:find("ws_"))
end