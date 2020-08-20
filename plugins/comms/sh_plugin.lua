PLUGIN.name = "Comms"
PLUGIN.author = "Stan"
PLUGIN.desc = "Comms system for each faction or class."
--dont fucking touch this unless you know what you're doing
PLUGIN.ActiveComms = {}
local entMeta = FindMetaTable("Entity")
--dont fucking touch this unless you know what you're doing


/****************************************************
   _____             __ _       
  / ____|           / _(_)      
 | |     ___  _ __ | |_ _  __ _ 
 | |    / _ \| '_ \|  _| |/ _` |
 | |___| (_) | | | | | | | (_| |
  \_____\___/|_| |_|_| |_|\__, |
                           __/ |
                          |___/ 
****************************************************/


--Will you drop the comms you have on your character when you die?
PLUGIN.DropOnDeath = true
--If players drop radios when they die, place the path of the model you want dropped when player dies
PLUGIN.RadioModel = "models/valk/h3/unsc/props/crates/radio.mdl"
--How much time in seconds till radio is removed from the world
PLUGIN.RadioDeleteTime = 30
--The model of the radio replenish device
PLUGIN.RadioReplenModel = "models/valk/h4/unsc/props/terminal/terminal_small.mdl"
--Are comms physically removeable off players?
PLUGIN.CommsStripable = true
--This plugin uses a feature which is only on the beta branch, disable this feature if you are not using the beta branch
--This feature is only to strip comms in a different way
PLUGIN.UsingBetaBranch = true
--If you want to allow people to be stripped by just standing around, set this to false.
--I recommend you leave this true by all means, as if players can strip no matter the state of the target, they will be chaos
PLUGIN.CuffedToBeStripped = true
--By default this supports this script https://www.gmodstore.com/market/view/910, if you have a different cuffs system that uses cuffs as a weapon. Place the class of the cuffed weapon here
PLUGIN.CuffsWeapon = "weapon_handcuffed"

PLUGIN.CommsChannels = {
    ["unsc"] = {
        /* String used to display the notification when not having access */
        name = "UNSC",
        /* String used to check if player has access to comms channel. Make sure this one is the same when setting up the CommsFunction table below otherwise your comms will not work */
        shortName = "unsc",
        /* Colour to use in the chat for the prefix */
        color = Color(64, 189, 19),
        /* Only use if you want to override the function that determines if a player is able to say anything in that comms channel */
        --onCanSay = function( speaker, text ) end,
        /* What will be used by players to access the command, you can have multiple prefixes if you wish */
        prefix = {"/unsc","/u"},
    },
    ["insurrection"] = {
        name = "Insurrection",
        shortName = "innie",
        color = Color(143,0,0),
        prefix = {"/innie","/i"},
    },
    ["oni"] = {
        name = "ONI",
        shortName = "oni",
        color = Color(150,150,150),
        prefix = {"/oni","/o"},
    },
    ["civilian"] = {
        name = "Civilian",
        shortName = "civ",
        color = Color(204,204,204),
        prefix = {"/ad", "/c", "/advert", "/civ"},
    },
    ["metro"] = {
        name = "Metro",
        shortName = "met",
        color = Color(255, 153, 0),
        prefix = {"/met", "/mp", "/metro"},
    },
}

/*

Copy and paste the functions you want here.
Put the TEAM code in the square brackets. Make sure they are full caps.
Change the string to whatever you made the shortName value of your comms

*/
PLUGIN.CommsFactions = {
    [FACTION_UNSC] = function(client) table.insert(client.CommsAccess, "unsc") end,
    [FACTION_MP] = function(client) table.insert(client.CommsAccess, "unsc") table.insert(client.CommsAccess, "civ") table.insert(client.CommsAccess, "met") end,
    [FACTION_INNIE] = function(client) table.insert(client.CommsAccess, "innie") table.insert(client.CommsAccess, "civ") end,
    [FACTION_CIVILIAN] = function(client) table.insert(client.CommsAccess, "civ") end,
}

/*

Put any class setups here if you want certain classes to have access to comms channels

*/
PLUGIN.CommsClasses = {
    [CLASS_ONIENS] = function(client) table.insert(client.CommsAccess, "oni") end,
    [CLASS_ONILTJG] = function(client) table.insert(client.CommsAccess, "oni") end,
    [CLASS_ONILT] = function(client) table.insert(client.CommsAccess, "oni") end,
    [CLASS_ONILCDR] = function(client) table.insert(client.CommsAccess, "oni") end,
    [CLASS_ONICDR] = function(client) table.insert(client.CommsAccess, "oni") end,
    [CLASS_ONICPTN] = function(client) table.insert(client.CommsAccess, "oni") end,
    [CLASS_ONIRDML] = function(client) table.insert(client.CommsAccess, "oni") end,
    [CLASS_ONIRADM] = function(client) table.insert(client.CommsAccess, "oni") end,
    [CLASS_ONIVADM] = function(client) table.insert(client.CommsAccess, "oni") end,
    [CLASS_ONIADM] = function(client) table.insert(client.CommsAccess, "oni") end,
    [CLASS_ONIFADM] = function(client) table.insert(client.CommsAccess, "oni") end,
    [CLASS_CIVILIANGOV] = function(client) table.insert(client.CommsAccess, "met") table.insert(client.CommsAccess, "unsc") end,
}



/****************************************************
   _____             __ _                        _ 
  / ____|           / _(_)                      | |
 | |     ___  _ __ | |_ _  __ _    ___ _ __   __| |
 | |    / _ \| '_ \|  _| |/ _` |  / _ \ '_ \ / _` |
 | |___| (_) | | | | | | | (_| | |  __/ | | | (_| |
  \_____\___/|_| |_|_| |_|\__, |  \___|_| |_|\__,_|
                           __/ |                   
                          |___/                    
****************************************************/

function PLUGIN:PostPlayerLoadout(client)
    --Default remove any comms access on spawn
    client.CommsAccess = {}
    --Reset the listen comms on spawn
    client.NotListenComms = {}
    --Give comms access via the config functions for each faction
    if self.CommsFactions[client:Team()] then
        self.CommsFactions[client:Team()](client)
    end
    --Give comms access via the config functions for each class
    local char = client:getChar()
    if not char then return end
    if self.CommsClasses[char:getClass()] then
        self.CommsClasses[char:getClass()](client)
    end
    
end

function PLUGIN:PlayerDeath(client)
    --if config is set to not drop radios when die, dont do this
    if !self.DropOnDeath then return end
    --if the player has no comms, dont do this
    if !table.IsEmpty(client.CommsAccess) then
        --create the entity and give it some values
        local radio = ents.Create( "stan_comms_radio" )
        if ( !IsValid( radio ) ) then return end
        radio:SetModel( self.RadioModel )
        radio:SetPos( client:GetPos() + Vector(0,0,50) )
        --set the comms channels on that box
        radio.Comms = client.CommsAccess
        --set the delete time of the box
        radio.DeleteTime = CurTime() + self.RadioDeleteTime
        radio:Spawn()
        
        timer.Simple(5, function()
            --rest the radios after nothing is going on to save some performance if there are lots of dropped radios
            if IsValid(radio) then
                local phys = radio:GetPhysicsObject()
                if (phys:IsValid()) then
                    phys:Sleep()
                end
            end
        end)
        
    end
    
end

local cuffedStrip = PLUGIN.CuffedToBeStripped
local cuffsWeapon = PLUGIN.CuffsWeapon

if CLIENT then
    --this is a nutscript 1.1-beta function only. So we will only use this if the user sets their config to using the beta branch
    if PLUGIN.CommsStripable and PLUGIN.UsingBetaBranch then
        -- Add interaction function, hold (+use) on player to see the list of options come up
        nut.playerInteract.addFunc("stripcomms", {
        name = "Strip comms",
        --the function that is called when pressing the button on the list
        callback = function(target)
            netstream.Start("commStrip", target)
        end,
        canSee = function(target)
            --check if we want to allow players without cuffs to be stripped
            if cuffedStrip then
                --if they dont have this weapon quiped, then dont show it in the list
                return target:GetActiveWeapon():GetClass() == cuffsWeapon
            else
                return true
            end
        end})
    end
else
    --recieve nethook (i know it says avoid un-need nets but this is a base nutscript 1.1-beta function so its out of my control how this task is performed)
    netstream.Hook("commStrip", function(client, target)
        print("comm strip net recieved")
        client:StripComms(target)
    end)
    --make player meta function to strip comms of the target of a player
    local plyMeta = FindMetaTable("Player")
    function plyMeta:StripComms(target)
        if cuffedStrip then
            if !(target:GetActiveWeapon():GetClass() == cuffsWeapon) then
                self:notify("Something went wrong stripping cuffs. Aborting") return
            end
        end
        if target:GetPos():DistToSqr(self:GetPos()) > 100000 then return end
        
        target.CommsAccess = {}
        self:notify("Comms stripped off player")
        target:notify("Your comms have been stripped")
    end
    
end
--just because its easier to have this function for multiple use than writing that out over and over
function entMeta:isRadioReplen()
    return self:GetClass() == "stan_comms_radio_replen"
end
--create all the comms channels provided in the config list. dont finish making the comms if there are ant errors and tell the user what the error is
for k,v in pairs(PLUGIN.CommsChannels) do
    
    local onCSay = v.onCanSay or nil
    local comName = k or nil
    local notifName = v.name or nil
    local srtName = v.shortName or nil
    local clr = v.color or nil
    local pfx = v.prefix or nil
    
    if comName == nil then print("[ABORTING] YOU NEED A COMMAND NAME FOR "..k) continue end
    if notifName == nil then print("[ABORTING] YOU NEED A NOTIFIY NAME FOR "..k) continue end
    if srtName == nil then print("[ABORTING] YOU NEED A SHORT NAME FOR "..k) continue end
    if clr == nil then print("[ABORTING] YOU NEED A COLOR FOR "..k) continue end
    if pfx == nil then print("[ABORTING] YOU NEED A PREFIX FOR "..k) continue end
    
    if onCSay == nil then
        onCSay = function(speaker, text)
            if table.HasValue(speaker.CommsAccess, srtName) then
                if table.HasValue(speaker.NotListenComms, srtName) then
                    speaker:notify("You have toggled [".. string.upper(srtName) .."] comms off")
                    return false
                end
                return true
            else
                speaker:notify("You do not have access to ".. notifName .." comms")
                return false
            end
        end
    end
    --create the actual command with all the data so players can speak in chat with it
    nut.chat.register(comName, {
        onCanSay = onCSay,
        onCanHear = function( speaker, listener )
            return table.HasValue(listener.CommsAccess, srtName) and not table.HasValue(listener.NotListenComms, srtName)
        end,
        onChatAdd = function(speaker, text)
            chat.AddText(clr , "[".. string.upper(srtName) .."] " ..speaker:Name()..": ", Color(255,255,0), text)
        end,
        prefix = pfx
    })
    --insert it to the comms table so entities know what comms exist and also so we can store what the player has comms access to
    table.insert(PLUGIN.ActiveComms, srtName)
    print(comName.." command created.")
end
--include the commands file
nut.util.include("sh_commands.lua")

if SERVER then
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
end