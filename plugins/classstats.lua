PLUGIN.name = "Class Stats"
PLUGIN.author = "Stan"
PLUGIN.desc = "Allows class stats to be set and applied"

function PLUGIN:PlayerSpawn(client)
    if (client:Team() != 0) then
        local classLoaded = client:GetNWBool("playerClassPluginLoaded")
        if classLoaded == true then
        	local char = client:getChar()
            if (char) then
            	local charClass = char:getClass()
            	local class = nut.class.list[charClass]
                if (class.health) then
                	client:SetMaxHealth( class.health )
                    client:SetHealth( class.health )
                    if (class.armor == 0 or class.armor == nil) then
                        client:SetArmor( 0 )
                    elseif (class.armor) then
                        client:SetArmor( class.armor )
                    else
                       client:SetArmor( 0 ) 
                    end
                end
            	if (class.scale) then
                    client:SetModelScale( class.scale )
                elseif (class.scale == 0 or class.scale == nil) then
                    client:SetModelScale ( 1 )
                else
                    client:SetModelScale ( 1 )
                end
            end
        else
			--Kills the target and instantly respawns them after two seconds of spawning in for first time char load in that play session
            timer.Simple(2, function()client:Kill() client:Spawn() end)
        end
    end
end
--Only way I could get bug to fix really
if SERVER then
	--Finds when player first spawns and sets their var to false
    function PLUGIN:PlayerInitialSpawn(ply)
        ply:SetNWBool("playerClassPluginLoaded", false)
    end
    --Function finds if player character has loaded
    function PLUGIN:CharacterLoaded(id)
        local character = nut.char.loaded[id]
        if (character) then
			--find the owner of the character
	        local client = character:getPlayer()
	        if (IsValid(client)) then
				--starts a one second timer to set the var to true, allows for first time spawn to be killed and respawned to fix the bug of not being able to move or interact with anything
                timer.Simple(1, function()client:SetNWBool("playerClassPluginLoaded", true) end)
            end
        end
    end
end

--[[If you already don't know what this does,
basically it allows you to do things like:
CLASS.health
CLASS.armor
CLASS.scale


Useful for some who wish for separate stats for classes within factions.
All things than can be done through this is here https://wiki.garrysmod.com/page/Category:Entity
You can make your own if the lua exists so maybe for example you wanted to make a color one stick it below 30 and do
if (class.color) then
	client:SetColor(r,g,b,a)
else
	client:SetColor(0,0,0,255)
end

Read more on this here https://wiki.garrysmod.com/page/Entity/SetColor
--]]