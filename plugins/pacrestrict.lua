PLUGIN.name = "PAC Restrict"
PLUGIN.author = "Stan"
PLUGIN.desc = "Disallows PAC usage to those who do not have a flag"
if (SERVER) then
    function PLUGIN:PlayerInitialSpawn(ply)
        ply:SetVar("playerHasPac", false)
    end
    
    hook.Add("PrePACConfigApply", "PACRankRestrict", function(ply)
        local pluginPlayerHasPac = ply:GetVar("playerHasPac", false)
        if (pluginPlayerHasPac != false) then
            if not ply:getChar():hasFlags("o") then
                return false,"Insufficient rank to use PAC."
            end
        else
            return false,"Autowear detected, retrying wear"
        end
    end)
    function PLUGIN:CharacterLoaded(id)
        local character = nut.char.loaded[id]
        if (character) then
            local client = character:getPlayer()
            if (IsValid(client)) then
                client:SetVar("playerHasPac", true)
                timer.Simple(1,
                    function() if client:getChar():hasFlags("o") || client:IsUserGroup("trialmod") || client:IsUserGroup("mod") || client:IsAdmin() then
                        client:ConCommand( "pac_wear_parts" )
                    end
                end)
            end
        end
    end
end
