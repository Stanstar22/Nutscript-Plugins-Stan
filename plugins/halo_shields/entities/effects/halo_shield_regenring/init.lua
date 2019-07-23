function EFFECT:Init(data)
	if !IsValid(data:GetEntity()) then return end
	self.Pos = data:GetOrigin()
	local Emitter = ParticleEmitter(self.Pos, false)
	if Emitter == nil then return end
	
	
	--[[
	for i = 0, 4 do //4
		local EffectCode = Emitter:Add("effects/optre/flash_halo", data:GetEntity():GetPos())
		EffectCode:SetVelocity(Vector(0, 0, (i*40) + math.rand(20, 100)))
		EffectCode:SetAirResistance(0)
		EffectCode:SetDieTime(1)
		EffectCode:SetStartAlpha(255)
		EffectCode:SetEndAlpha(255)
		EffectCode:SetStartSize(15)
		EffectCode:SetEndSize(15)
		EffectCode:SetAngles(Angle(0, 0, 90))
		--EffectCode:SetRoll(270)
		--EffectCode:SetRollDelta(math.Rand(-4, 4))
		EffectCode:SetColor(255, 255, 255)

	end]]
	self:SetParent(data:GetEntity())
	local leadTgt = data:GetEntity():GetVelocity() * 1.5
		for k = -1, 2 do
			local offset = Vector(15, 0, 0)
			for i = 1, 18 do //4
				local EffectCode = Emitter:Add("effects/optre/electric_bolt"..math.random(1,4), self.Pos)
				EffectCode:SetVelocity(Vector(0, 0, (k*40) + math.Rand(55, 75)) + leadTgt)
				EffectCode:SetPos(EffectCode:GetPos() + offset)
				EffectCode:SetAirResistance(40)
				EffectCode:SetDieTime(1)
				EffectCode:SetStartAlpha(255)
				EffectCode:SetEndAlpha(0)
				EffectCode:SetStartSize(4)
				EffectCode:SetEndSize(12)
				EffectCode:SetRoll(math.Rand(180, 480))
				EffectCode:SetRollDelta(math.Rand(-15, 15))
				EffectCode:SetColor(205, 255, 255)
				
				local EffectCode = Emitter:Add("effects/optre/electric_arc"..math.random(1,4), self.Pos)
				EffectCode:SetVelocity(Vector(0, 0, math.Rand(150, 180)) + leadTgt)
				EffectCode:SetPos(EffectCode:GetPos() + (offset * 0.5))
				EffectCode:SetAirResistance(100)
				EffectCode:SetDieTime(1)
				EffectCode:SetStartAlpha(255)
				EffectCode:SetEndAlpha(0)
				EffectCode:SetStartSize(4)
				EffectCode:SetEndSize(12)
				EffectCode:SetRoll(math.Rand(180, 480))
				EffectCode:SetRollDelta(math.Rand(-15, 15))
				EffectCode:SetColor(55, 105, 255)
				
				offset:Rotate(Angle(0, 20, 0))

			end

			for i = 1, 16 do //4
				local EffectCode = Emitter:Add("effects/optre/electric_arc"..math.random(1,4), self.Pos)
				EffectCode:SetVelocity(Vector(0, 0, (k*40) + math.Rand(55, 75)) + leadTgt)
				EffectCode:SetPos( EffectCode:GetPos() + Vector(math.Rand(-15, 15), math.Rand(-15, 15), math.Rand(-15, 15)))
				EffectCode:SetAirResistance(100)
				EffectCode:SetDieTime(1)
				EffectCode:SetStartAlpha(255)
				EffectCode:SetEndAlpha(0)
				EffectCode:SetStartSize(4)
				EffectCode:SetEndSize(12)
				EffectCode:SetRoll(math.Rand(180, 480))
				EffectCode:SetRollDelta(math.Rand(-15, 15))
				EffectCode:SetColor(55, 105, 255)
				
			end
		end
	
	Emitter:Finish()
end

---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()
end
