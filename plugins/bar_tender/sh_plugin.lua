PLUGIN.name = "Bar Drinks"
PLUGIN.author = "Stan"
PLUGIN.desc = "Adds alcoholic beverages that players can drink"

if CLIENT then
	
	netstream.Hook("nut_alcohol_setup", function()
		LocalPlayer().BeerTime = nil
		LocalPlayer().VodkaTime = nil
		LocalPlayer().WhiskeyTime = nil
		LocalPlayer().WineTime = nil
	end)
	
	function PLUGIN:RenderScreenspaceEffects()
		local client = LocalPlayer()
		local time = CurTime()
		if client.BeerTime then
			if client.BeerTime >= time then
				DrawMotionBlur(0.4, 10, 0.01)
				DrawSharpen(1.5,1.5)
				DrawMaterialOverlay( "effects/alcohol_drunk/bombinomicon_distortion", 0.01 )
			else
				client.BeerTime = nil
			end
		end
		
		if client.WineTime then
			if client.WineTime >= time then
				DrawMotionBlur(0.4, 15, 0.01)
				DrawSharpen(2,2)
				DrawMaterialOverlay( "effects/alcohol_drunk/bombinomicon_distortion", 0 )
			else
				client.WineTime = nil
			end
		end
		
		if client.VodkaTime then
			if client.VodkaTime >= time then
				DrawMotionBlur(0.5, 20, 0.01)
				DrawSharpen(2,2)
				DrawMaterialOverlay( "effects/alcohol_drunk/bombinomicon_distortion", 0.02 )
			else
				client.VodkaTime = nil
			end
		end
		
		if client.WhiskeyTime then
			if client.WhiskeyTime >= time then
				DrawMotionBlur(0.5, 30, 0.01)
				DrawSharpen(3,3)
				DrawMaterialOverlay( "effects/alcohol_drunk/bombinomicon_distortion", -0.01 )
			else
				client.WhiskeyTime = nil
			end
		end
	
	end

	netstream.Hook("nut_beer_bottle", function(time)
		LocalPlayer().BeerTime = time
	end)

	netstream.Hook("nut_vodka_bottle", function(time)
		LocalPlayer().VodkaTime = time
	end)

	netstream.Hook("nut_whiskey_bottle", function(time)
		LocalPlayer().WhiskeyTime = time
	end)

	netstream.Hook("nut_wine_bottle", function(time)
		LocalPlayer().WineTime = time
	end)
else
	function PLUGIN:PlayerSpawn( client )
		netstream.Start(client, "nut_alcohol_setup")
		client.DrinksActive = 0
	end
	function PLUGIN:PlayerLoadedChar( client )
		netstream.Start(client, "nut_alcohol_setup")
		client.DrinksActive = 0
	end
end