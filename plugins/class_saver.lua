PLUGIN.name = "Class Saver"
PLUGIN.author = "Stan"
PLUGIN.desc = "Remembers the last class you played on when you rejoin that character."

-- Called right before the character has its information save.
function PLUGIN:CharacterPreSave(character)
	-- Get the player from the character.
	local client = character:getPlayer()

	-- Check to see if we can get the player's position.
	if (IsValid(client)) then
		-- Store the last class in the character's data.
		character:setData("lastClass", character:getClass())
	end
end

-- Called after the player's loadout has been set.
function PLUGIN:PlayerLoadedChar(client, character, lastChar)
	timer.Simple(0.2, function()
		if (IsValid(client)) then
			-- Get the saved last class from the character data.
			local lastClass = character:getData("lastClass")

			-- Check if the class was set.
			if (lastClass) then
				character:joinClass(lastClass)
			end
		end
	end)
end
