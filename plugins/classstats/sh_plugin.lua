PLUGIN.name = "Class Stats"
PLUGIN.author = "Stan"
PLUGIN.desc = "Allows class stats to be set and applied"

nut.util.include("sv_autoloadout.lua")

--[[If you already don't know what this does,
basically it allows you to do things like:
CLASS.health = 200
CLASS.armor = 100
CLASS.scale = 1.2
CLASS.color = Vector(255 / 255, 255 / 255, 255 / 255)

With multiplier true, it will take the default speed set in the NutScipt config and multiply by the amount given.
If this value is false then it will set that value to the number given in "runSpeed"/"walkSpeed".
Leaving these inputs out of a class will simply set the run and walk speeds of the NutScript config.
CLASS.runSpeed = 1.2
CLASS.runSpeedMultiplier = true
CLASS.walkSpeed = 150
CLASS.walkSpeedMultiplier = false

CLASS.jumpPower is same as how run and walk speed work

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
Use ENUMs found on wiki
--]]
