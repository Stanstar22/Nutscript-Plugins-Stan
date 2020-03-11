PLUGIN.name = "Class Whitelist"
PLUGIN.author = "Stan"
PLUGIN.desc = "Adds whitelist to class functions"

--[[function PLUGIN:CanPlayerJoinClass( client, nclass, classData )
    
    local char = client:getChar()
    local wl = char:getData("whitelists", {})
    
    
    if !(table.HasValue(wl, classData.name)) then
        return false
    end
    
end--]]




/* IMPORTANT */

/* TO MAKE THIS SCRIPT WORK, YOU HAVE TO ADD THIS TO THE CLASSES YOU WANT TO WHITELIST

function CLASS:onCanBe(client)
    local char = client:getChar()
    local wl = char:getData("whitelists", {})
    
    return table.HasValue(wl, self.name)
end


I HAVE NO IDEA WHY THE HOOK DOSNT WORK BUT OH WELL
*/


nut.command.add("classwhitelist", {
	syntax = "<string name> <string class>",
	onRun = function(client, arguments)
        local target = nut.command.findPlayer(client, arguments[1])
		local class = table.concat(arguments, " ", 2)
		local char = target:getChar()
		local classwl = char:getData("whitelists", {})

		if (IsValid(target) and char) then
			local num = isnumber(tonumber(class)) and tonumber(class) or -1
			
			if (nut.class.list[num]) then
				local v = nut.class.list[num]

                if target:Team() != v.faction then client:notify("Cannot whitelist the ".. v.name .." class outside of faction") return end
                if table.HasValue(classwl, v.name) then client:notify(target:Name().." is already class whitelisted to ".. v.name) return end

				table.insert(classwl, v.name)

                char:setData("whitelists", classwl)
                client:notify("Class whitelisted ".. target:Name().. " to class ".. v.name)
                target:notify("Class whitelisted to "..v.name)
                return

			else
				for k, v in ipairs(nut.class.list) do
					if (nut.util.stringMatches(v.uniqueID, class) or nut.util.stringMatches(L(v.name, client), class)) then
					    
                        if target:Team() != v.faction then client:notify("Cannot whitelist the ".. v.name .." class outside of faction") return end
                        if table.HasValue(classwl, v.name) then client:notify(target:Name().." is already class whitelisted to ".. v.name) return end
                        
                        table.insert(classwl, v.name)
                        
                        char:setData("whitelists", classwl)
                        client:notify("Class whitelisted ".. target:Name().. " to class ".. v.name)
                        target:notify("Class whitelisted to "..v.name)
                        return
					end
				end
			end
			
			client:notifyLocalized("invalid", L("class", client))
		else
			client:notifyLocalized("illegalAccess")
		end
	end
})


nut.command.add("classunwhitelist", {
	syntax = "<string name> <string class>",
	onRun = function(client, arguments)
        local target = nut.command.findPlayer(client, arguments[1])
		local class = table.concat(arguments, " ", 2)
		local char = target:getChar()
		local classwl = char:getData("whitelists", {})

		if (IsValid(target) and char) then
			local num = isnumber(tonumber(class)) and tonumber(class) or -1
			
			if (nut.class.list[num]) then
				local v = nut.class.list[num]

                if target:Team() != v.faction then client:notify("Cannot unwhitelist the ".. v.name .." class outside of faction") return end
                if table.HasValue(classwl, v.name) then
                    
                    table.RemoveByValue(classwl, v.name)
                    client:notify("Unwhitelisted ".. target:Name().. " from class " .. v.name)
                    target:notify("You have been unwhitelisted from class " .. v.name)
                    char:setData("whitelists", classwl)
                    return
                else
                    client:notify(target:Name().." is not whitelisted to this class")
                    return
                end

			else
				for k, v in ipairs(nut.class.list) do
					if (nut.util.stringMatches(v.uniqueID, class) or nut.util.stringMatches(L(v.name, client), class)) then
					    
                        if target:Team() != v.faction then client:notify("Cannot whitelist the ".. v.name .." class outside of faction") return end
                        if table.HasValue(classwl, v.name) then
                            
                            table.RemoveByValue(classwl, v.name)
                            client:notify("Unwhitelisted ".. target:Name().. " from class " .. v.name)
                            target:notify("You have been unwhitelisted from class " .. v.name)
                            char:setData("whitelists", classwl)
                            return
                        else
                            client:notify(target:Name().." is not whitelisted to this class")
                            return
                        end
					end
				end
			end
			
			client:notifyLocalized("invalid", L("class", client))
		else
			client:notifyLocalized("illegalAccess")
		end
	end
})
