PLUGIN.name = "Duel System"
PLUGIN.author = "Stan"
PLUGIN.desc = "Can't damage other players unless duel has been accepted"

if SERVER then
	--Reward function for winning player. Server side hook so you will need to network stuff if you want HUD stuff to happen or anything else clientside.
	--[[function PLUGIN:NutDuelReward(client)
		
	end--]]

	function PLUGIN:PlayerDeath( vic, wep, att )
		if (!IsValid(vic) and !IsValid(att)) then return end
		timer.Simple(0.1, function()
			if IsValid(vic) then
				local winPly = player.GetBySteamID(vic.DuelPly)
				if IsValid(winPly) and winPly:IsPlayer() and vic.DuelAccept then
					hook.Run("NutDuelReward", winPly)
				end
				vic.DuelAccept = false
				vic.DuelPly = nil
			end
			if IsValid(att) then
				att.DuelAccept = false
				att.DuelPly = nil
			end
		end)
		if att:IsPlayer() then
			timer.Remove("autoRemoveAcceptedDuel"..att:SteamID())
		end
		timer.Remove("autoRemoveAcceptedDuel"..vic:SteamID())
	end
	
	function PLUGIN:PlayerShouldTakeDamage( ply,att )
		if (!IsValid(ply) and !IsValid(att)) then return true end
		if !(att:IsPlayer()) then return true end
		if !(ply:IsBot() or att:IsBot()) then
			if ply.DuelAccept and att.DuelAccept then
				if ply.DuelPly == att:SteamID() and att.DuelPly == ply:SteamID() then
					return true
				else
					return false
				end
			else
				return false
			end
		end
		
	end
end

nut.command.add("duel", {
	adminOnly = false,
	syntax = "<string name>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])
		if not target then return end
		if target == client then client:notify("You cannot duel yourself") return end
		
		if target.DuelPly then
			client:notify(target:Name().." is already in a duel/already has a duel request")
			return
		end
		
		if client.DuelPly then
			client:notify("You already have a duel request")
			return
		end
		
		target.DuelPly = client:SteamID()
		client.DuelPly = target:SteamID()
		
		client:notify("Duel request sent to "..target:Name())
		target:notify("Duel request from to "..client:Name())
		target:notify("/duelaccept to accept duel or /dueldeny to deny duel request")
		
		timer.Create("autoRemoveDuel"..client:SteamID(), 30, 1, function()
			target.DuelPly = nil
			client.DuelPly = nil
			target:notify("Duel with "..client:Name().." has timed out.")
			client:notify("Duel with "..target:Name().." has timed out.")
		end)
	end
})

nut.command.add("duelaccept", {
	adminOnly = false,
	syntax = "[none]",
	onRun = function(client, arguments)
		if !(client.DuelPly) then
			client:notify("You don't have a duel request")
			return
		end
		
		local target = player.GetBySteamID(client.DuelPly)
		
		client.DuelAccept = true
		target.DuelAccept = true
		
		client:notify("Duel started with "..target:Name())
		target:notify("Duel started with "..client:Name())
		
		timer.Remove("autoRemoveDuel"..client.DuelPly)
		timer.Create("autoRemoveAcceptedDuel"..client:SteamID(), 120, 1, function()
			if IsValid(client) then
				client:notify("Duel timed out with "..target:Name())
				client.DuelAccept = false
				client.DuelPly = nil
			end
			if IsValid(target) then
				target.DuelAccept = false
				target.DuelPly = nil
				target:notify("Duel timed out with "..client:Name())
			end
		end)
	end
})

nut.command.add("dueldeny", {
	adminOnly = false,
	syntax = "[none]",
	onRun = function(client, arguments)
		if !(client.DuelPly) then
			client:notify("You don't have a duel request")
			return
		end
		
		local target = player.GetBySteamID(client.DuelPly)
		
		client:notify("Duel cancelled with "..target:Name())
		target:notify("Duel cancelled with "..client:Name())
		
		timer.Remove("autoRemoveDuel"..client.DuelPly)
		
		target.DuelPly = nil
		client.DuelPly = nil
	end
})





if CLIENT then
	
	
	--[[-------------------------------------------
	Add some cool stuffs to the help menu
	---------------------------------------------]]

	
	PLUGIN.helps = {
		
		["1. What are duels?"] = 
		[[This is an easy way for players to fight eachother. Duels last for two minutes if accepted and a request will time out after 30 seconds if the person who has been asked to duel does not make their decision.]],
		["2. How do I duel other people?"] = 
		[[To duel others simply use /duel 'name']],
		["3. How do I accept duels?"] = 
		[[To accept a duel you must first have a duel request from another player. You must then use the command /duelaccept to accept this duel. Once this command hsa been input, the players can deal damage to eachother for 2 minutes or until one dies.<br>To deny a duel simply use the command /dueldeny and the request will be timed out.]],
	}
	

	-- This hook adds up some new stuffs in F1 Menu.
	function PLUGIN:BuildHelpMenu(tabs)
		tabs["Dueling"] = function(node)
			local body = ""
			
			for title, text in SortedPairs(self.helps) do
				body = body.."<h2>"..title.."</h2>"..text.."<br /><br />"
			end
			
			return body
		end
	end
	
	
end
