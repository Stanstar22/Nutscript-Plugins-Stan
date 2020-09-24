local playerMeta = FindMetaTable("Player")

function playerMeta:resetClassStatDefaults()
	if not self:IsValid() then return end
	if not self:IsPlayer() then return end
	local char = self:getChar()
	if (char) then
		local charClass = char:getClass()
		local class = nut.class.list[charClass]
		if (class.health) then
			self:SetMaxHealth( class.health )
			self:SetHealth( class.health )
		else
			self:SetMaxHealth( 100 )
			self:SetHealth( 100 )
		end

		if (class.armor) then
			self:SetArmor( class.armor )
		else
			self:SetArmor( 0 ) 
		end

		if (class.scale) then

			local scaleViewFix = class.scale
			local scaleViewFixOffset = Vector(0, 0, 64)
			local scaleViewFixOffsetDuck = Vector(0, 0, 28)

			self:SetViewOffset(scaleViewFixOffset * class.scale)
			self:SetViewOffsetDucked(scaleViewFixOffsetDuck * class.scale)

			self:SetModelScale( scaleViewFix )
		else
			self:SetViewOffset(Vector(0, 0, 64))
			self:SetViewOffsetDucked(Vector(0, 0, 28))
			self:SetModelScale ( 1 )
		end

		if (class.color) then
			self:SetPlayerColor(class.color)
		else
			local col = self:GetInfo( "cl_playercolor" )
			self:SetColor(Color(255, 255, 255, 255))
			self:SetPlayerColor( Vector( col ) )
		end

		if (class.runSpeed) then
			if (class.runSpeedMultiplier) then
				self:SetRunSpeed( math.Round(nut.config.get("runSpeed") * class.runSpeed) )
			else
				self:SetRunSpeed( class.runSpeed )
			end
		else
			self:SetRunSpeed( nut.config.get("runSpeed") )
		end

		if (class.walkSpeed) then
			if (class.walkSpeedMultiplier) then
				self:SetWalkSpeed( math.Round(nut.config.get("walkSpeed") * class.walkSpeed) )
			else
				self:SetWalkSpeed( class.walkSpeed )
			end
		else
			self:SetWalkSpeed( nut.config.get("walkSpeed") )
		end
		
		if (class.jumpPower) then
			if (class.jumpPowerMultiplier) then
				self:SetJumpPower( math.Round(160 * class.jumpPower) )
			else
				self:SetJumpPower( class.jumpPower )
			end
		else
			self:SetJumpPower( 160 )
		end
		--Blood enums here https://wiki.garrysmod.com/page/Enums/BLOOD_COLOR
		if (class.bloodcolor) then
			self:SetBloodColor(class.bloodcolor)
		else 
			self:SetBloodColor( BLOOD_COLOR_RED ) --This is the index for regular red blood
		end

	end
end


--Honestly all of this is a mess, and I don't know why it's all here now that I look back on it. All I remember is that it never worked properly and all this made it work...somehow, so it will stay.
function PLUGIN:PlayerSpawn(client)
	--Run short timer to give var to read correctly when change character, probably unneeded now but I left it in just to be sure
	timer.Simple(0.1,function()
		if (client:Team() != 0) then
		local classLoaded = client:GetVar("playerClassPluginLoaded", false)
			if classLoaded == true then
				client:resetClassStatDefaults()
			else
				timer.Simple(0.5, function() client:resetClassStatDefaults() end)
			end
		end
	end)
end

function PLUGIN:PlayerInitialSpawn(client)
	client:SetVar("playerClassPluginLoaded", false)
end
function PLUGIN:PlayerLoadedChar(client)
	client:SetVar("playerClassPluginLoaded", false)
end
   
function PLUGIN:CharacterLoaded(id)
	local character = nut.char.loaded[id]
	if (character) then
		local client = character:getPlayer()
		if (IsValid(client)) then
			timer.Simple(1, function()client:SetVar("playerClassPluginLoaded", true) end)
		end
	end
end
--Respawn player when they change class, you may disable this by commenting it out
function PLUGIN:OnPlayerJoinClass(client)
	client:KillSilent()
	timer.Simple(0.2, function() client:Spawn() end) --Timer done to avoid bugs with viewmodel camera
end