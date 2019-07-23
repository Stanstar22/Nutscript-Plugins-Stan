function EFFECT:Init(data)
	if !IsValid(data:GetEntity()) then return end
	self.Pos = self:GetTracerShootPos(data:GetOrigin(),data:GetEntity(),data:GetAttachment())
	local Emitter = ParticleEmitter(self.Pos)
	if Emitter == nil then return end

	LocalPlayerMagnitude = 0
	if IsValid(data:GetEntity()) && IsValid(data:GetEntity():GetOwner()) && data:GetEntity():GetOwner():IsPlayer() && data:GetEntity().Owner == LocalPlayer() then
		LocalPlayerMagnitude = data:GetMagnitude() else
		LocalPlayerMagnitude = 0
	end

	//local effectdata = EffectData()
	//effectdata:SetEntity(self.Weapon) 
	//effectdata:SetOrigin(self.Pos)
	//effectdata:SetNormal( Vector(0,0,0) )
	//util.Effect("RifleShellEject",effectdata,true,true)

	-- Muzzle Flash


		local EffectCode = Emitter:Add("effects/optre/flash_large",self.Pos + LocalPlayerMagnitude * data:GetNormal())
		//EffectCode:SetAirResistance(200)
		EffectCode:SetDieTime(0.35) -- How much time until it dies
		EffectCode:SetStartAlpha(math.Rand(200,255)) -- Transparency
		EffectCode:SetEndAlpha(0)
		EffectCode:SetStartSize(6) -- Size of the effect
		EffectCode:SetEndSize(6) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
		EffectCode:SetRoll(math.Rand(480,540))
		EffectCode:SetRollDelta(math.Rand(-1,1)) -- How fast it rolls
		EffectCode:SetColor(205, 255, 255) -- The color of the effect
		//EffectCode:SetGravity(Vector(0,0,155)) -- The Gravity
		local EffectCode = Emitter:Add("effects/optre/flash_large",self.Pos + LocalPlayerMagnitude * data:GetNormal())
		//EffectCode:SetAirResistance(200)
		EffectCode:SetDieTime(0.1) -- How much time until it dies
		EffectCode:SetStartAlpha(math.Rand(200,255)) -- Transparency
		EffectCode:SetEndAlpha(0)
		EffectCode:SetStartSize(3) -- Size of the effect
		EffectCode:SetEndSize(3) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
		EffectCode:SetRoll(math.Rand(480,540))
		EffectCode:SetRollDelta(math.Rand(-1,1)) -- How fast it rolls
		EffectCode:SetColor(155, 205, 255) -- The color of the effect
		//EffectCode:SetGravity(Vector(0,0,155)) -- The Gravity
	for i = 1,3 do //4
		local EffectCode = Emitter:Add("effects/optre/spark"..math.random(1,4), self.Pos)
		EffectCode:SetAirResistance(120)
		EffectCode:SetDieTime(0.05)
		EffectCode:SetStartAlpha(255)
		EffectCode:SetEndAlpha(0)
		EffectCode:SetStartSize(2)
		EffectCode:SetEndSize(10)
		EffectCode:SetRoll(math.Rand(180, 480))
		EffectCode:SetRollDelta(math.Rand(-1, 1))
		EffectCode:SetColor(55, 155, 255)

	end
		
	for i = 1,9 do //4
		local EffectCode = Emitter:Add("effects/optre/spark"..math.random(1,4), self.Pos)
		EffectCode:SetVelocity(VectorRand() * (math.Rand(40, 90)))
		EffectCode:SetAirResistance(240)
		EffectCode:SetDieTime(0.2)
		EffectCode:SetStartAlpha(255)
		EffectCode:SetEndAlpha(0)
		EffectCode:SetStartSize(2)
		EffectCode:SetEndSize(10)
		EffectCode:SetRoll(math.Rand(180, 480))
		EffectCode:SetRollDelta(math.Rand(-1, 1))
		EffectCode:SetColor(155, 255, 255)

	end
	for i = 1, 15 do
		local EffectCode = Emitter:Add("effects/optre/sparkmed"..math.random(1,4), self.Pos)
		EffectCode:SetVelocity(VectorRand() * (math.Rand(20, 30)))
		EffectCode:SetAirResistance(60)
		EffectCode:SetDieTime(1)
		EffectCode:SetStartAlpha(255)
		EffectCode:SetEndAlpha(0)
		EffectCode:SetStartSize(4)
		EffectCode:SetEndSize(4)
		EffectCode:SetRoll(math.Rand(180, 480))
		EffectCode:SetRollDelta(math.Rand(-1, 1))
		EffectCode:SetColor(55, 155, 255)

	end
	for i = 1,12 do //4
		local EffectCode = Emitter:Add("effects/optre/electric_arc"..math.random(1,4), self.Pos)
		EffectCode:SetVelocity(VectorRand() * (math.Rand(40, 90)))
		EffectCode:SetAirResistance(200)
		EffectCode:SetDieTime(0.3)
		EffectCode:SetStartAlpha(255)
		EffectCode:SetEndAlpha(0)
		EffectCode:SetStartSize(2)
		EffectCode:SetEndSize(10)
		EffectCode:SetRoll(math.Rand(180, 480))
		EffectCode:SetRollDelta(math.Rand(-35, 35))
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
