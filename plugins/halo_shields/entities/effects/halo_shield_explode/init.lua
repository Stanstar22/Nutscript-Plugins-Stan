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
		EffectCode:SetStartSize(10) -- Size of the effect
		EffectCode:SetEndSize(10) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
		EffectCode:SetRoll(math.Rand(480,540))
		EffectCode:SetRollDelta(math.Rand(-1,1)) -- How fast it rolls
		EffectCode:SetColor(205, 255, 255) -- The color of the effect
		//EffectCode:SetGravity(Vector(0,0,155)) -- The Gravity
		local EffectCode = Emitter:Add("effects/optre/flash_large",self.Pos + LocalPlayerMagnitude * data:GetNormal())
		//EffectCode:SetAirResistance(200)
		EffectCode:SetDieTime(0.25) -- How much time until it dies
		EffectCode:SetStartAlpha(math.Rand(200,255)) -- Transparency
		EffectCode:SetEndAlpha(0)
		EffectCode:SetStartSize(12) -- Size of the effect
		EffectCode:SetEndSize(12) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
		EffectCode:SetRoll(math.Rand(480,540))
		EffectCode:SetRollDelta(math.Rand(-1,1)) -- How fast it rolls
		EffectCode:SetColor(155, 205, 255) -- The color of the effect
		//EffectCode:SetGravity(Vector(0,0,155)) -- The Gravity
	for i = 1,3 do //4
		local EffectCode = Emitter:Add("effects/optre/spark"..math.random(1,4), self.Pos)
		EffectCode:SetAirResistance(120)
		EffectCode:SetDieTime(0.3)
		EffectCode:SetStartAlpha(255)
		EffectCode:SetEndAlpha(0)
		EffectCode:SetStartSize(2)
		EffectCode:SetEndSize(10)
		EffectCode:SetRoll(math.Rand(180, 480))
		EffectCode:SetRollDelta(math.Rand(-1, 1))
		EffectCode:SetColor(55, 155, 255)

	end
		
	for i = 1,27 do //4
		local EffectCode = Emitter:Add("effects/optre/spark"..math.random(1,4), self.Pos)
		EffectCode:SetVelocity(Vector(math.Rand(-300, 300), math.Rand(-300, 300), 0))
		EffectCode:SetPos(EffectCode:GetPos() + Vector(0, 0, math.Rand(-50, 50)))
		EffectCode:SetAirResistance(240)
		EffectCode:SetDieTime(0.5)
		EffectCode:SetStartAlpha(255)
		EffectCode:SetEndAlpha(0)
		EffectCode:SetStartSize(6)
		EffectCode:SetEndSize(12)
		EffectCode:SetRoll(math.Rand(180, 480))
		EffectCode:SetRollDelta(math.Rand(-1, 1))
		EffectCode:SetColor(155, 255, 255)

	end
	for i = 1, 45 do
		local EffectCode = Emitter:Add("effects/optre/sparkmed"..math.random(1,4), self.Pos)
		EffectCode:SetVelocity(Vector(math.Rand(-180, 180), math.Rand(-180, 180), 0))
		EffectCode:SetPos(EffectCode:GetPos() + Vector(0, 0, math.Rand(-50, 50)))
		EffectCode:SetAirResistance(60)
		EffectCode:SetDieTime(0.75)
		EffectCode:SetStartAlpha(255)
		EffectCode:SetEndAlpha(0)
		EffectCode:SetStartSize(12)
		EffectCode:SetEndSize(12)
		EffectCode:SetRoll(math.Rand(180, 480))
		EffectCode:SetRollDelta(math.Rand(-1, 1))
		EffectCode:SetColor(55, 155, 255)

	end
	for i = 1,36 do //4
		local EffectCode = Emitter:Add("effects/optre/electric_arc"..math.random(1,4), self.Pos)
		EffectCode:SetVelocity(Vector(math.Rand(-160, 160), math.Rand(-160, 160), 0))
		EffectCode:SetPos(EffectCode:GetPos() + Vector(0, 0, math.Rand(-50, 50)))
		EffectCode:SetAirResistance(200)
		EffectCode:SetDieTime(0.5)
		EffectCode:SetStartAlpha(255)
		EffectCode:SetEndAlpha(0)
		EffectCode:SetStartSize(8)
		EffectCode:SetEndSize(12)
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