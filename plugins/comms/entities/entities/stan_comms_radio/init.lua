AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

ENT.DeleteTime = 0
ENT.Comms = {}
ENT.GainedComms = false
 
function ENT:Initialize()
 
	self:SetModel( self:GetModel() )
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
	local newComms = caller.CommsAccess
	for k,v in ipairs(self.Comms) do
		if !(table.HasValue(caller.CommsAccess, v)) then
			table.insert(newComms, v)
			caller:ChatPrint("You have gained access to [".. string.upper(v).."] comms.")
			self.GainedComms = true
		end
	end

	if !self.GainedComms then
		caller:ChatPrint("There are no new comms channels to gain off this radio.")
		return
	end
	
	caller.CommsAccess = newComms
	self:Remove()
end
 
function ENT:Think()
	if CurTime() >= self.DeleteTime then
		self:Remove()
	end
	self:NextThink(self.DeleteTime)
	return true
end