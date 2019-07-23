function EFFECT:Init(data)
	if !IsValid(data:GetEntity()) then return end
	self.Pos = data:GetOrigin()
	local Emitter = ParticleEmitter(self.Pos)
	if Emitter == nil then return end

	LocalMagnitude = 100
	--[[if data:GetMagnitude() != nil and data:GetMagnitude() != 0 then
		LocalMagnitude = data:GetMagnitude() else
		LocalMagnitude = 100
	end--]]

	--print(LocalMagnitude)
	
	self:SetParent(data:GetEntity())
	local leadTgt = data:GetEntity():GetVelocity() * 1.1
	
	for i = 1, 4 do //4
		local EffectCode = Emitter:Add("effects/optre/electric_bolt"..math.random(1,4), self.Pos)
		EffectCode:SetVelocity((VectorRand() * (math.Rand(60, 100)) * (LocalMagnitude/500)) + leadTgt)
		EffectCode:SetAirResistance(150)
		EffectCode:SetDieTime(0.3)
		EffectCode:SetStartAlpha(255)
		EffectCode:SetEndAlpha(0)
		EffectCode:SetStartSize(0.01*LocalMagnitude)
		EffectCode:SetEndSize(0.1*LocalMagnitude)
		EffectCode:SetRoll(math.Rand(180, 480))
		EffectCode:SetRollDelta(math.Rand(-4, 4))
		EffectCode:SetColor(205, 255, 255)

	end
	
	
	for i = 1, 20 do
		local EffectCode = Emitter:Add("effects/optre/sparksmol"..math.random(1,4), self.Pos)
		EffectCode:SetVelocity((VectorRand() * (math.Rand(70, 120))*(LocalMagnitude/500)) + leadTgt)
		EffectCode:SetAirResistance(60)
		EffectCode:SetDieTime(0.25)
		EffectCode:SetStartAlpha(255)
		EffectCode:SetEndAlpha(0)
		EffectCode:SetStartSize(0.01*LocalMagnitude)
		EffectCode:SetEndSize(0.2*LocalMagnitude)
		EffectCode:SetRoll(math.Rand(180, 480))
		EffectCode:SetRollDelta(math.Rand(-1, 1))
		EffectCode:SetColor(55, 155, 255)

    end
	for i = 1,4 do //4
		local EffectCode = Emitter:Add("effects/optre/electric_arc"..math.random(1,4), self.Pos)
		EffectCode:SetVelocity((VectorRand() * (math.Rand(80, 140))*(LocalMagnitude/500)) + leadTgt) 
		EffectCode:SetAirResistance(200)
		EffectCode:SetDieTime(0.3)
		EffectCode:SetStartAlpha(255)
		EffectCode:SetEndAlpha(0)
		EffectCode:SetStartSize(0.01*LocalMagnitude)
		EffectCode:SetEndSize(0.2*LocalMagnitude)
		EffectCode:SetRoll(math.Rand(180, 480))
		EffectCode:SetRollDelta(math.Rand(-15, 15))
		EffectCode:SetColor(205, 255, 255)

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