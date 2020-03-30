local PLUGIN = PLUGIN


nut.command.add("dropweapon", {
    onRun = function(client, arguments)
        
        local actWep = client:GetActiveWeapon()
        if not IsValid(actWep) then client:notify("Not holding a valid weapon") return end
        
        local wepClass = actWep:GetClass()
        if PLUGIN.Blacklist[actWep:GetClass()] then client:notify("You can't drop this weapon") return end
        
        client:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_DROP)
        
        timer.Simple(1, function() 
            if not IsValid(client) then return end
            if not client:HasWeapon( wepClass ) then return end
            client:StripWeapon(wepClass)
            -- Get the entity 30 units infront of the player.
            local data = {}
                data.start = client:GetShootPos()
                data.endpos = data.start + client:GetAimVector()*30
                data.filter = client
            local trace = util.TraceLine(data)
            local endPos = trace.HitPos
            
            local wep = ents.Create( "nut_dropped_weapon" )
            if ( !IsValid( wep ) ) then return end
            wep.model = PLUGIN.ModelOverwrite[wepClass] or actWep:GetModel() or PLUGIN.CallbackModel 
            wep:SetPos( endPos )
            --set the comms channels on that box
            wep.wep = wepClass
            wep:Spawn()
            
            timer.Simple(5, function()
                if IsValid(wep) then
                    local phys = wep:GetPhysicsObject()
                    if (phys:IsValid()) then
                        phys:Sleep()
                    end
                end
            end)
        end)
        
    end
})