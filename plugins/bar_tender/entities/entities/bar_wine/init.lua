AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/mark2580/gtav/barstuff/plonk_red.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 
function ENT:Use( activator )
    if not IsValid(activator) then return end
    if activator:IsPlayer() then
        --Kill the player on their 4 drink
        if activator.DrinksActive >= 3 then
            activator:notify("You've had too much to drink buddy")
            activator:Kill()
            activator.DrinksActive = 0
            timer.Remove("nut_alcohol_"..activator:SteamID())
            self:Remove()
            return
        end
        local time = CurTime() + 120
        netstream.Start(activator, "nut_wine_bottle", time)
        activator:SetHealth(math.Clamp(activator:Health() + 50, 0, activator:GetMaxHealth() + 100))
        activator:SetArmor(math.Clamp(activator:Armor() + 50, 0, 200))
        activator:notify("You feel numb to pain")
        activator.DrinksActive = activator.DrinksActive + 1 or 1
        timer.Create("nut_alcohol_"..activator:SteamID(), 30, 1, function() activator.DrinksActive = 0 end)
        self:Remove()
    end
end