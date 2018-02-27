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
                else
                	client:SetMaxHealth( 100 )
                    client:SetHealth( 100 )
                end
                
                if (class.armor == 0 or class.armor == nil) then
                    client:SetArmor( 0 )
                elseif (class.armor) then
                    client:SetArmor( class.armor )
                else
                    client:SetArmor( 0 ) 
                end
            
            	if (class.scale) then
                    client:SetModelScale( class.scale )
                elseif (class.scale == 0 or class.scale == nil) then
                    client:SetModelScale ( 1 )
                else
                    client:SetModelScale ( 1 )
                end
                
                if (class.color) then
                    client:SetPlayerColor(class.color)
                elseif (class.color == 0 or class.color == nil) then
                    local col = client:GetInfo( "cl_playercolor" )
                    client:SetColor(Color(255, 255, 255, 255))
                    client:SetPlayerColor( Vector( col ) )
                else
                    local col = client:GetInfo( "cl_playercolor" )
                    client:SetColor(Color(255, 255, 255, 255))
                    client:SetPlayerColor( Vector( col ) )
                end
                
				--If you can be bothered to fix the red X's when being shot by this be my guest, but I don't use it. Blood enums here https://wiki.garrysmod.com/page/Enums/BLOOD_COLOR
                --[[if (class.bloodcolor) then
                    client:SetBloodColor(class.bloodcolor)
                elseif (class.bloodcolor == 0 or class.bloodcolor == nil) then
                    client:SetBloodColor( BLOOD_COLOR_RED ) --This is the index for regular red blood
                else 
                    client:SetBloodColor( BLOOD_COLOR_RED ) --This is the index for regular red blood
                end--]]
                
            end
        else
			--Respawns the target on first load to make sure that they are bugged
			--If you use spawn saver, you will need to change the timer that it uses on line 19 and change the 0 to 2.1
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