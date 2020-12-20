PLUGIN.name = "Class Whitelist"
PLUGIN.author = "Stan"
PLUGIN.desc = "Adds whitelist to class functions"

function PLUGIN:CanPlayerJoinClass( client, nclass, classData )

	--If the class is default we do not need a whitelist
	if classData.isDefault then return end
	
	local char = client:getChar()
	local wl = char:getData("whitelists", {})
	
	
	if !(table.HasValue(wl, classData.name)) then
		return false
	end
	
end




--[[

/* This is for legacy versions of NutScript before my change to how the hook works was pushed to the beta branch on 15/12/2020
For future versions please just don't touch anything here and the hook should make this plugin work with no extra steps.

function CLASS:onCanBe(client)
	local char = client:getChar()
	local wl = char:getData("whitelists", {})
	
	return table.HasValue(wl, self.name)
end



--]]


nut.command.add("classwhitelist", {
	adminOnly = true,
	syntax = "<string name> <string class>",
	onRun = function(client, arguments)
	local target = nut.command.findPlayer(client, arguments[1])
	if target == nil then
		client:notify("Could not find target")
		return
	end
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
	adminOnly = true,
	syntax = "<string name> <string class>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])
		if target == nil then
			client:notify("Could not find target")
			return
		end
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
