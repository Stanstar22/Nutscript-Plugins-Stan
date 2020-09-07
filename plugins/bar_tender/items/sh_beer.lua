ITEM.name = "Beer"
ITEM.model = "models/mark2580/gtav/barstuff/beer_bar.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 20
ITEM.category = "Alcohol"
ITEM.desc = "Down in one!"

ITEM.functions.use = { 
	name = "Drink",
	tip = "useTip",
	icon = "icon16/drink.png",
	onRun = function(item)
		local client = item.player
		if not IsValid(client) then return end
		if client:IsPlayer() then
			--Kill the player on their 4 drink
			if client.DrinksActive >= 3 then
				client:notify("You've had too much to drink buddy")
				client:Kill()
				client.DrinksActive = 0
				timer.Remove("nut_alcohol_"..client:SteamID())
				return true
			end
			local time = CurTime() + 120
			netstream.Start(client, "nut_beer_bottle", time)
			client:SetHealth(math.Clamp(client:Health() + 50, 0, client:GetMaxHealth() + 100))
			client:SetArmor(math.Clamp(client:Armor() + 50, 0, 200))
			client:notify("You feel numb to pain")
			client.DrinksActive = client.DrinksActive + 1 or 1
			timer.Create("nut_alcohol_"..client:SteamID(), 30, 1, function() client.DrinksActive = 0 end)
			return true
		end

		return false
	end,
}