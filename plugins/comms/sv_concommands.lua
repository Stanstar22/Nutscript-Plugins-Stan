local saveData = {}
	
if not file.Exists("text_comms", "DATA") then
	file.CreateDir("text_comms")
end

if not file.Exists("text_comms/data.txt", "DATA") then
	file.Write("text_comms/data.txt", "")
end
local function LoadData()
	saveData = util.JSONToTable( file.Read("text_comms/data.txt", "DATA") ) or {}
end

LoadData()

local function SaveData()
	file.Write( "text_comms/data.txt", util.TableToJSON( saveData ) )
end

local function SaveReplens()
	saveData.replens = {}

	local replens = ents.FindByClass("stan_comms_radio_replen")

	for k,rep in ipairs( replens ) do
		table.insert( saveData.replens, { pos = rep:GetPos(), ang = rep:GetAngles(), map = game.GetMap(), comms = rep:GetActiveComms() } )
	end

	SaveData()
	LoadData()
end

local function LoadReplens()
	if saveData.replens then
		if saveData.replens ~= {} then
			-- remove old replen stations
			for k,v in ipairs( ents.FindByClass( "stan_comms_radio_replen" ) ) do
				v:Remove()
			end
			for k,v in ipairs( saveData.replens ) do
				if v.map == game.GetMap() then
					local ent = ents.Create("stan_comms_radio_replen")
					ent:SetPos( v.pos )
					ent:SetAngles( v.ang )
					ent:SetActiveComms(v.comms)
					ent:Initialize()
					ent:Activate()
					ent:Spawn()
					ent:GetPhysicsObject():EnableMotion( false )
				end
			end
		end
	end
end

concommand.Add("textcomms_savereplens", function(ply, cmd, args)
	if ply:IsSuperAdmin() then
		SaveReplens()
		ply:ChatPrint("Saving comms replen staions")
		local name = "SERVER"
		if IsValid( ply ) then name = ply:Nick() end
	end
end)

concommand.Add("textcomms_loadreplens", function(ply, cmd, args)
	if ply:IsSuperAdmin() then
		LoadReplens()
		ply:ChatPrint("Loading comms replen stations")
		local name = "SERVER"
		if IsValid( ply ) then name = ply:Nick() end
	end
end)
hook.Add("InitPostEntity", "TEXT_COMMS_Load_Replens", function() LoadReplens() end)