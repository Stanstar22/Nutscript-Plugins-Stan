AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

ENT.DeleteTime = CurTime() + 300
ENT.model = "models/props_junk/watermelon01.mdl"
ENT.wep = "nut_hands"
 
function ENT:Initialize()
 
	self:SetModel( self.model )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 
function ENT:Use( activator, caller )
    if not IsValid(activator) then return end
    if not activator:IsPlayer() then return end
    activator:Give(self.wep, true)
    self:Remove()
end
 
function ENT:Think()
    if CurTime() >= self.DeleteTime then
        self:Remove()
    end
    self:NextThink(self.DeleteTime)
    return true
end