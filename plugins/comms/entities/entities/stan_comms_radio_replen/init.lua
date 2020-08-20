AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

ENT.ActiveComms = {}
 
function ENT:Initialize()
    --Gets the global table of the plugins and finds the RadioReplenModel option in ths comms plugin.
    --This means changing the plugin folder name will break this. DONT CHANGE THE PLUGIN FOLDER NAME
	self:SetModel( nut.plugin.list.comms.RadioReplenModel )
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
    --compatibility saving for permaprops, some people prefer it
    self.ActiveComms = string.Explode(" ", self:GetActiveComms())
    for k,v in pairs(self.ActiveComms) do
        if !(table.HasValue(caller.CommsAccess, v)) then
            table.insert(caller.CommsAccess, v)
            caller:notify("You have gained access to [".. string.upper(v).."] comms.")
        else
            caller:notify("You already have access to [" .. string.upper(v) .. "] comms.")
        end
    end
end