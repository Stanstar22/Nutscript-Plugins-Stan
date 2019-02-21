PLUGIN.name = "NPC Item Drop"
PLUGIN.author = "Stan"
PLUGIN.desc = "NPCs will drop items when they die."

PLUGIN.scrapItem = true
PLUGIN.scrapItemID = "metalscrap"

PLUGIN.randomItems = {
	"item1",
	"item2",
	"item3",}
    
PLUGIN.randomItemsRare = {
	"item4",
	"item5",
	"item6",}
    
PLUGIN.randomItemsVeryRare = {
	"item7",
	"item8",
	"item9",}

function PLUGIN:OnNPCKilled(victim, ent, weapon)
	--Gets random number from numbers 1 to 1000
	local itemChance = math.random(1,1000)
	--If the number is higher than 975 then continue, item is given
	if itemChance > 975 then
		--Get another number between 1 and 100
		local rareItemChance = math.random(1,100)
		--If number is 100, then drop very rare item on NPC body
		if rareItemChance > 99 then
			nut.item.spawn(self.randomItemsVeryRare[math.random( 1, #self.randomItemsVeryRare )], victim:GetPos() + Vector(math.random(50,-50) , math.random(50,-50), 50))
		--If number is above 85 and below or equal to 99 then drop rare item on NPC dead body
		elseif rareItemChance > 85 and rareItemChance <= 99 then
			nut.item.spawn(self.randomItemsRare[math.random( 1, #self.randomItemsRare )], victim:GetPos() + Vector(math.random(50,-50) , math.random(50,-50), 50))
		--If number is above 11 or below or equal to 85 then drop item part on NPC body
		elseif rareItemChance > 11 and rareItemChance <= 85 then
			nut.item.spawn(self.randomItems[math.random( 1, #self.randomItems )], victim:GetPos() + Vector(math.random(50,-50) , math.random(50,-50), 50))
			--If any other number, drop a global scrap peice. Useful as a base item for crafting systems. You can disable this by setting the true value to false
		else
			if self.scrapItem then
				nut.item.spawn(self.scrapItemID, victim:GetPos() + Vector(math.random(50,-50) , math.random(50,-50), 50))
			else
				--If the scrap item is disabled, simply drop a regular item on the ground
				nut.item.spawn(self.randomItems[math.random( 1, #self.randomItems )], victim:GetPos() + Vector(math.random(50,-50) , math.random(50,-50), 50))
			end
		end
	end
end
