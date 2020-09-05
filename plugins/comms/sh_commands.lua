local PLUGIN = PLUGIN
nut.command.add("setradiochannels", {
	onCheckAccess = function(client)
		return client:IsAdmin()
	end,
	onRun = function(client, arguments)
		local commAdd = {}
		--we only want to add valid commas channels so check all valid ones here with the arguments of the command
		for k,v in pairs(PLUGIN.ActiveComms) do
			if table.HasValue(arguments, v) then
				table.insert(commAdd,v)
			end
		end
		-- Get the entity 96 units infront of the player.
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*96
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity

		-- Check if the entity is a valid radio replen.
		if (IsValid(entity) and entity:isRadioReplen()) then
			--entity.ActiveComms = commAdd
			--Use data table instead because premaprops is better than the default NS save
			entity:SetActiveComms(table.concat(commAdd, " "))
			if table.IsEmpty(commAdd) then commAdd = {"none"} end
			client:notify("Comm replenish station set to: " .. table.concat(commAdd, " & "))
		else
			-- Tell the player the replenisher isn't valid.
			client:notify("That is not a valid radio replenisher")
		end		
	end
})

nut.command.add("stripcomms", {
	onRun = function(client, arguments)
		if not PLUGIN.CommsStripable then client:notify("Stripping comms is disabled") return end
		-- Get the entity 50 units infront of the player.
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*50
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity

		-- Check if the entity is a valid player
		if (IsValid(entity) and entity:IsPlayer()) then
			--check against the config
			if PLUGIN.CuffedToBeStripped then
				if entity:GetActiveWeapon():GetClass() == PLUGIN.CuffsWeapon then
					client:StripComms(entity)
				else
					client:notify("You cannot strip comms of an uncuffed player")
				end
			else
				client:StripComms(entity)
			end
		else
			-- Tell the player the thing theyre looking at is not valid
			client:notify("Not looking at a valid player")
		end		
	end
})

nut.command.add("dropcomms", {
	onRun = function(client, arguments)
		local commAdd = {}
		--we only want to add valid commas channels so check all valid ones here with the arguments of the command
		for k,v in pairs(PLUGIN.ActiveComms) do
			--check against the arguments we provided and if the player actually has that comms channel
			if table.HasValue(arguments, v) and table.HasValue(client.CommsAccess, v) then
				client:notify("You have dropped [".. string.upper(v) .."] comms")
				table.insert(commAdd,v)
				table.RemoveByValue(client.CommsAccess, v)
			end
		end
		if table.IsEmpty(commAdd) then client:notify("You did not provide a comms channel you have access to") return end
		
		client:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_DROP)
		
		timer.Simple(1, function() 
			if not IsValid(client) then return end
			-- Get the entity 96 units infront of the player.
			local data = {}
				data.start = client:GetShootPos()
				data.endpos = data.start + client:GetAimVector()*96
				data.filter = client
			local trace = util.TraceLine(data)
			local endPos = trace.HitPos
			
			local radio = ents.Create( "stan_comms_radio" )
			if ( !IsValid( radio ) ) then return end
			radio:SetModel( PLUGIN.RadioModel )
			radio:SetPos( endPos )
			--set the comms channels on that box
			radio.Comms = commAdd
			--set the delete time of the box
			radio.DeleteTime = CurTime() + PLUGIN.RadioDeleteTime
			radio:Spawn()
			
			timer.Simple(5, function()
				--rest the radios after nothing is going on to save some performance if there are lots of dropped radios
				if IsValid(radio) then
					local phys = radio:GetPhysicsObject()
					if (phys:IsValid()) then
						phys:Sleep()
					end
				end
			end)
		end)
		
	end
})

nut.command.add("togglecomms", {
	onRun = function(client, arguments)
		--we only want to add valid commas channels so check all valid ones here with the arguments of the command
		for k,v in pairs(PLUGIN.ActiveComms) do
			--check against the arguments we provided and if the player actually has that comms channel
			if table.HasValue(arguments, v) then
				if not table.HasValue(client.CommsAccess, v) then client:notify("You do not have access to [".. string.upper(v) .."] comms") return end
				client:notify("You have toggled [".. string.upper(v) .."] comms")
				if not table.HasValue(client.NotListenComms, v) then
					table.insert(client.NotListenComms, v)
				else
					table.RemoveByValue(client.NotListenComms, v)
				end
			end
		end
	end
})