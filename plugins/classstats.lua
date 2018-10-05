PLUGIN.name = "Class Stats"
PLUGIN.author = "Stan"
PLUGIN.desc = "Allows class stats to be set and applied"

function doLoadout(client)
    local char = client:getChar()
    if (char) then
    	local charClass = char:getClass()
    	local class = nut.class.list[charClass]
        if (class.health) then
            client:SetMaxHealth( class.health )
            client:SetHealth( class.health )
        else
            client:SetMaxHealth( 100 )
            client:SetHealth( 100 )
        end
        
        if (class.armor) then
            client:SetArmor( class.armor )
        else
            client:SetArmor( 0 ) 
        end
    
        if (class.scale) then
            
            local scaleViewFix = class.scale
            local scaleViewFixOffset = Vector(0, 0, 64)
            local scaleViewFixOffsetDuck = Vector(0, 0, 28)
            
            client:SetViewOffset(scaleViewFixOffset * class.scale)
            client:SetViewOffsetDucked(scaleViewFixOffsetDuck * class.scale)
            
            client:SetModelScale( class.scale )
        else
	    client:SetViewOffset(Vector(0, 0, 64))
	    client:SetViewOffsetDucked(Vector(0, 0, 28))
            client:SetModelScale ( 1 )
        end
        
        if (class.color) then
            client:SetPlayerColor(class.color)
        else
            local col = client:GetInfo( "cl_playercolor" )
            client:SetColor(Color(255, 255, 255, 255))
            client:SetPlayerColor( Vector( col ) )
        end
		
        --If you can be bothered to fix the red X's when being shot by this be my guest, but I don't use it. Blood enums here https://wiki.garrysmod.com/page/Enums/BLOOD_COLOR
        --[[if (class.bloodcolor) then
            client:SetBloodColor(class.bloodcolor)
        else 
            client:SetBloodColor( BLOOD_COLOR_RED ) --This is the index for regular red blood
        end--]]
                    
    end
end

function PLUGIN:PlayerSpawn(client)
	--Run short timer to give var to read correctly when change character, probably unneeded now but I left it in just to be sure
    timer.Simple(0.1,function()
        if (client:Team() != 0) then
            local classLoaded = client:GetVar("playerClassPluginLoaded", false)
            if classLoaded == true then
            	doLoadout(client)
            else
                timer.Simple(0.5, function() doLoadout(client) end)
            end
        end
    end)
end

if SERVER then
    function PLUGIN:PlayerInitialSpawn(ply)
        ply:SetVar("playerClassPluginLoaded", false)
    end
    function PLUGIN:PlayerLoadedChar(client)
        client:SetVar("playerClassPluginLoaded", false)
    end
    
    function PLUGIN:CharacterLoaded(id)
        local character = nut.char.loaded[id]
        if (character) then
	        local client = character:getPlayer()
	        if (IsValid(client)) then
                timer.Simple(1, function()client:SetVar("playerClassPluginLoaded", true) end)
            end
        end
    end
	--Respawn player when they change class, you may disable this by commenting it out
    function PLUGIN:OnPlayerJoinClass(client)
        client:KillSilent()
        timer.Simple(0.2, function() client:Spawn() end) --Timer done to avoid bugs with viewmodel camera
    end
end

--[[If you already don't know what this does,
basically it allows you to do things like:
CLASS.health = 200
CLASS.armor = 100
CLASS.scale = 1.2
CLASS.color = Vector(255 / 255, 255 / 255, 255 / 255)

The colour one works strange if you don't know how to use it, it uses vector colour and will only work on colourable playermodels
like on default models where you can change the t-shirt colour though the context menu and click on playermodel and then colours.
Basically if you want to force colours you must format it like this:

Vector(255 / 255, 255 / 255, 255 / 255)
Change the first 255 in each table part, do not change the second 255 after the slash, this works as the way this is done is 255 in rgb is 1 in vector colour,
this divides it down to shorter values.
Basically just replace the first 255's before the slash as your RGB number but do not change the second 255.
If you wish to outright disable players choosing their own colours, simply replace the:

local col = client:GetInfo( "cl_playercolor" )
client:SetPlayerColor( Vector( col ) )

with this but using the same rules as above:

Vector(255 / 255, 255 / 255, 255 / 255)

If you're still confused by the colour, perhaps the wiki page will help you more https://wiki.garrysmod.com/page/Player/SetPlayerColor

CLASS.bloodcolor
^This one if you are bothered to fix it but I don't use it
--]]
