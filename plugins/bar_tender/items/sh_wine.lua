ITEM.name = "Wine"
ITEM.model = "models/mark2580/gtav/barstuff/plonk_red.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 20
ITEM.category = "Alcohol"
ITEM.desc = "Down in one!"

ITEM.functions.use = { 
	name = "Use",
	tip = "useTip",
	icon = "icon16/drive.png",
	onRun = function(item)
		local client = item.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*28
			data.filter = client
		local trace = util.TraceLine(data)

		if (trace.HitPos) then
			local wep = ents.Create("bar_wine")
			wep:SetPos(trace.HitPos + trace.HitNormal * 10)
			wep:Spawn()
			return true
		end

		return false
	end,
}