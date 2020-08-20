ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Radio Replenish"
ENT.Author			= "Stan"
ENT.Contact			= "Don't"
ENT.Purpose			= "Use to get comms access"
ENT.Instructions	= "Don't shove it up your ass"
ENT.Spawnable       = true

function ENT:SetupDataTables()
    
    self:NetworkVar("String", 0, "ActiveComms")
    
    if SERVER then
        self:SetActiveComms("")
    end
    
end