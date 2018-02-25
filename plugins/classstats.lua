PLUGIN.name = "Class Stats"
PLUGIN.author = "Stan"
PLUGIN.desc = "Allows class stats to be set and applied"

function PLUGIN:PlayerSpawn(client)
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
        else
            timer.Simple(2, function() client:Kill() client:Spawn() end)
    	end
    	if (class.scale) then
            client:SetModelScale( class.scale )
        elseif (class.scale == 0 or class.scale == nil) then
            client:SetModelScale ( 1 )
        else
            client:SetModelScale ( 1 )
        end
    end
end

--[[If you already don't know what this does,
basically it allows you to do things like:
CLASS.health
CLASS.armor
CLASS.scale


Useful for some who wish for separate stats for classes within factions.
--]]