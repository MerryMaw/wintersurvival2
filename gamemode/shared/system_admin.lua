

local meta    	= FindMetaTable("Player")
local Banlist 	= {}

local insert    = table.insert

if (SERVER) then
	hook.Add("InitPostEntity","InitBanlist",function()
		if (!sql.TableExists("Banlist")) then
			local Dat = {
				"id INTEGER PRIMARY KEY",
				"steamid TEXT",
				"time INT",
				"name TEXT",
				"reason TEXT",
			}
			
			Msg("No banlist was found.\nCreating new banlist!\n")
			sql.Query("CREATE TABLE IF NOT EXISTS Banlist ("..table.concat(Dat,",")..");")
		else
			local dat = sql.Query("SELECT * FROM Banlist")
			
			if (dat) then
				for k,v in pairs(dat) do insert(Banlist,v.steamid) end
			end
		end
	end)
	/*
	hook.Add("CheckPassword","BlockBannedPlayers",function(SteamID64,NetworkID,ServerPassword,Password,Name)
		if (table.HasValue(Banlist,util.SteamIDFrom64(SteamID64))) then
			print(Name.." attempted to join, but was found in the banlist. Blocking access!")
			
			return false, "You are banned from this server!"
		end
	end)*/
	
	concommand.Add("mas_bansteamid",function(pl,com,arg)
		if (!IsValid(pl) or !pl:IsAdmin()) then return end
		if (!arg[3]) then return end
		
		local steamid = arg[1]
		local time = tonumber(arg[2] or 0)
		local reason = table.concat(arg," ",3)
		
		local dat = sql.Query("SELECT * FROM Banlist WHERE steamid="..SQLStr(steamid))
				
		if (!dat) then 
			sql.Query("INSERT INTO Banlist(steamid,time,name,reason) VALUES ("..SQLStr(steamid)..","..time..",'Unknown',"..SQLStr(reason)..")")
			insert(Banlist,steamid)
			
			for k,v in pairs(player.GetAll()) do
				if (v:SteamID() == steamid) then
					v:Kick("Banned from server: "..reason)
				end
				
				v:ChatPrint(pl:Nick().." has banned "..steamid)
			end
			
			MsgN(pl:Nick().." has banned "..steamid)
		else
			MsgN(steamid.." was already located in the database.")
		end
	end)
	
	concommand.Add("mas_unbansteamid",function(pl,com,arg)
		if (!IsValid(pl) or !pl:IsAdmin()) then return end
		if (!arg[1]) then return end
		local dat = sql.Query("DELETE * FROM Banlist WHERE steamid="..SQLStr(arg[1]))
		local dat2 = sql.Query("SELECT * FROM Banlist")
		
		print(dat)
		PrintTable(dat2)
		if (dat) then
			MsgN(pl:Nick().." has unbanned "..arg[1])
			
			for k,v in pairs(Banlist) do
				if (v == arg[1]) then
					table.remove(Banlist,k)
					break
				end
			end
		end
	end)
	
	concommand.Add("mas_printbannedplayers",function(pl,com,arg)
		if (!IsValid(pl) or !pl:IsAdmin()) then return end
		
		local dat = sql.Query("SELECT * FROM Banlist")
		
		if (dat) then
			for k,v in pairs(dat) do
				pl:ChatPrint(v.steamid.." - "..v.name)
			end
		end
	end)
		
	concommand.Add("mas_banplayer",function(pl,com,arg)
		if (!IsValid(pl) or !pl:IsAdmin()) then return end
		if (!arg[3]) then return end
		
		local name = arg[1]
		local time = tonumber(arg[2] or 0)
		local reason = table.concat(arg," ",3)
		
		for k,v in pairs(player.GetAll()) do
			if (v:Nick():lower():find(name:lower())) then
				local dat = sql.Query("SELECT * FROM Banlist WHERE steamid="..SQLStr(v:SteamID()))
				
				if (!dat) then 
					sql.Query("INSERT INTO Banlist(steamid,time,name,reason) VALUES ("..SQLStr(v:SteamID())..","..time..","..SQLStr(v:Nick())..","..SQLStr(reason)..")")
					insert(Banlist,v:SteamID())
					v:Kick("Banned from server: "..reason)
					break
				end
			end
		end
	end)
else
end