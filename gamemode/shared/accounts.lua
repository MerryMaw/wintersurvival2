
--Not sure if i should make this MySQLoo, textbased or SQLites

local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("UpdatePlayerDB")
	
	concommand.Add("ws_printallaccounts",function(pl)
		if (!IsValid(pl) or !pl:IsAdmin()) then return end
		
		local dat = sql.Query("SELECT * FROM WS2Accounts")
		
		pl:ChatPrint(table.Count(dat) .. " accounts registered!")
	end)
	
	concommand.Add("ws_setrank",function(pl,com,arg)
		if (!IsValid(pl) or !pl:IsAdmin()) then return end
		if (!arg[2]) then return end
		
		local name = arg[1]:lower()
		local rank = tonumber(arg[2])
		
		for k,v in pairs(player.GetAll()) do
			if (v:Nick():lower():find(name)) then
				v.Rank = rank
				v:ChatPrint("Your rank has been set to "..rank)
				
				if (rank == 1) then v:SetUserGroup("admin") end
				
				MsgN("Player "..v:Nick().." has been set to "..rank)
				break
			end
		end
	end)
		
		
	hook.Add("Initialize","InitSQLiteDB",function()
		if (!sql.TableExists("WS2Accounts")) then
			local Dat = {
				"id INT UNSIGNED NOT NULL PRIMARY KEY",
				"inventory MEDIUMTEXT",
				"equipped MEDIUMTEXT",
				"rank TINYINT",
				"timespent INT UNSIGNED",
			}
			
			Msg("Table not found. Creating new table for accounts!\n")
			sql.Query("CREATE TABLE IF NOT EXISTS WS2Accounts ("..table.concat(Dat,",")..");")
		end
	end)
	
	hook.Add("PlayerAuthed","InitSQLitePlayer",function(pl) 
		pl:LoadPlayer()
	end)
	
	hook.Add("EntityRemoved","UpdatePlayer",function(ent)
		if (ent:IsPlayer()) then 
			local f,err = pcall(ent.UpdateSQLite,ent)
		end
	end)
	
	hook.Add("Tick","UpdatePlayerDB",function()
		for k,v in pairs(player.GetAll()) do
			if (v.UpdateTime and v.UpdateTime < CurTime()) then
				v.UpdateTime = CurTime()+30
				v:UpdateSQLite()
			end
		end
	end)
	
	function meta:LoadPlayer()
		local ID   = self:SteamID64()
		
		if (!ID) then 
			Msg("Retrying loading player "..self:Nick().."\n")
			timer.Simple(1,function() if (IsValid(self)) then self:LoadPlayer() end end) 
			return 
		end
		
		local data = sql.Query("SELECT * FROM WS2Accounts WHERE id="..ID)
		
		self.UpdateTime = CurTime()+30
		self.LastJoined = CurTime()
		self.AccountInv = {}
		self.Equipped   = {}
		self.Rank		= 0
		
		self.StoredID   = ID
		
		if (!data) then
			Msg("Player "..self:Nick().." was not found. Creating new account!\n")
			
			local dat = {
				self.StoredID,
				"''",
				"''",
				0,
				0,
			}
			
			sql.Query("INSERT INTO WS2Accounts(id,inventory,equipped,rank,timespent) VALUES ("..table.concat(dat,",")..");")
		else
			self.LastJoined = CurTime()-tonumber(data[1].timespent)
			self.Rank 		= tonumber(data[1].rank)
			
			for k,v in pairs(string.Explode("\n",data[1].inventory)) do
				local Ab = string.Explode("æ",v)
				if (Ab[2]) then self:AddAccountItem(Ab[1],tonumber(Ab[2])) end
			end
			
			if (self.Rank == 1) then self:SetUserGroup("admin") self:ChatPrint("You are an admin on this server!") end
			
			net.Start("UpdatePlayerDB")
				net.WriteUInt(tonumber(data[1].timespent),32)
				net.WriteUInt(self.Rank,4)
			net.Send(self)
		end
	end
	
	function meta:UpdateSQLite()
		if (!self.StoredID) then self:Kick("Your ID seems to be invailed. Reconnect please!") return end
		
		local Inventory		= ""
		
		for k,v in pairs(self:GetAccountInventory()) do
			Inventory = Inventory..v.Name.."æ"..v.Quantity.."\n"
		end
		
		local dat = {
			"timespent="..math.ceil(CurTime()-self.LastJoined),
			"rank="..self.Rank,
			"inventory="..SQLStr(Inventory)
		}
		
		sql.Query("UPDATE WS2Accounts SET "..table.concat(dat,",").." WHERE id="..self.StoredID..";")
	end
else
	net.Receive("UpdatePlayerDB",function()
		local pl = LocalPlayer()
		
		pl.LastJoined = CurTime()-net.ReadUInt(32)
		pl.Rank = net.ReadUInt(4)
	end)
end

function meta:GetRank()
	return self.Rank or 0
end

function meta:GetTimeSpent()
	return ((self.LastJoined and CurTime() - self.LastJoined) or 0)
end