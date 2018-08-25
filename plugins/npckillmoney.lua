PLUGIN.name = "NPC Money Kill"
PLUGIN.author = "Stan"
PLUGIN.desc = "Allows the player to earn money from killing NPCs"

nut.config.add("NPCKillAmount", 10, "How much money a player gets for killing an NPC", nil, {
	data = {min = 0, max = 1000},
	category = "NPC"
})

function PLUGIN:PlayerInitialSpawn(ply)
    local sid = ply:SteamID()
    ply.SID = ply:UserID()
end


function PLUGIN:OnNPCKilled(victim, ent, weapon)
    -- If something killed the npc
    if not ent then return end

    if ent:IsVehicle() and ent:GetDriver():IsPlayer() then ent = ent:GetDriver() end


    -- If we know by now who killed the NPC, pay them.
    if IsValid(ent) and ent:IsPlayer() and nut.config.get("NPCKillAmount") > 0 then
        local char = ent:getChar()
        char:giveMoney(nut.config.get("NPCKillAmount"))
        char.player:notify("You have recived $"..nut.config.get("NPCKillAmount").." for killing an NPC" )
    end
end