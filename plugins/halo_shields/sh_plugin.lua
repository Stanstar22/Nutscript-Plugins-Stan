PLUGIN.name = "Halo Shields"
PLUGIN.author = "Stan"
PLUGIN.desc = "Regenerating shields"
--Effects used in this addon are located in the addons/halo_shields
--Sounds and effect textures are from OPTRE VJ SNPCs workshop addon

--Config
HaloShields = HaloShields or {}
HaloShields.Legacy = HaloShields.Legacy or {}

HaloShields.Legacy.Enabled = false --Enable legacy whitelist and shield system. This will make the amount of shields global for all whitelisted groups

HaloShields.RechargeTime = 0.25 --How long till every tick of shields
HaloShields.RechargeAmount = 2 --How much shields every tick
HaloShields.Whitelist = {
	--[[ USAGE
	[TEAM_ENUM] = {Enable shields?, amount of shields. MUST BE AN INTEGER (whole number)},
	--]]
	[TEAM_UNASSIGNED] = {true, 200},
}

HaloShields.Legacy.MaxShields = 150 --Max shields player can have
HaloShields.Legacy.Whitelist = {
	--[[ EXAMPLE
	[FACTION_SPARTAN] = true,
	[FACTION_SPARTANHEAVY] = true,
	[FACTION_SPARTANGRE] = true,
	[FACTION_SPARTANWO] = true,
	[FACTION_MCHIEF] = true,
	EXAMPLE, you can remove this or put your whitelist out of the comment block --]]
	[TEAM_UNASSIGNED] = true,
}

function PLUGIN:getWhiteList(client)
	if HaloShields.Legacy.Enabled then
		return HaloShields.Legacy.Whitelist[client:Team()]
	else
		return HaloShields.Whitelist[client:Team()][1]
	end
end

if SERVER then
	local function StartRecharge( ply )
		timer.Create("halo_shield:Recharge"..ply:SteamID(), HaloShields.RechargeTime, 0, function()
			if ply:IsValid() then
				local plyteam = ply:Team()
				local chargeAmount = ply:GetNWInt("Shield_HP")
				local maxshield = nil
				if HaloShields.Legacy.Enabled then
					maxshield = HaloShields.Legacy.MaxShields
				else
					maxshield = HaloShields.Whitelist[plyteam][2]
				end
				
				if maxshield == nil then return end
				
				ply:SetNWInt("Shield_HP", math.Clamp(chargeAmount+HaloShields.RechargeAmount,0,maxshield))
				timer.Remove("halo_shield:NoShieldEffect"..ply:SteamID())

				local effectdata = EffectData()
				effectdata:SetOrigin(ply:GetPos())
				effectdata:SetEntity(ply)
				util.Effect("halo_shield_regenring", effectdata)

				ply.ShieldShldExplode = true
				
				if HaloShields.Legacy.Enabled then
					if chargeAmount >= HaloShields.Legacy.MaxShields then
						timer.Remove("halo_shield:Recharge"..ply:SteamID())
						--print("Removing recharge timer")
					end
				else
					if chargeAmount >= HaloShields.Whitelist[plyteam][2] then
						timer.Remove("halo_shield:Recharge"..ply:SteamID())
					end
				end
			end
		end)
	end

	function PLUGIN:PlayerSpawn( ply )
		if (PLUGIN:getWhiteList( ply )) then
			--Set the default shield strength
			local shieldVal = nil
			
			if HaloShields.Legacy.Enabled then
				shieldVal = HaloShields.Legacy.MaxShields
			else
				shieldVal = HaloShields.Whitelist[ply:Team()][2]
			end
			
			if shieldVal == nil then return end
			
			ply:SetNWInt( "Shield_HP", shieldVal )
			--Make it so people don't bleed when being shot at with shields active
			ply:SetBloodColor(-1)
			ply.ShieldShldExplode = true
		else
			ply:SetNWInt( "Shield_HP", nil )
			ply:SetBloodColor(0)
			ply.ShieldShldExplode = false
		end
	end

	function PLUGIN:PlayerDeath( ply, inf, att )
		if timer.Exists("halo_shield:RechargeDelay"..ply:SteamID()) then
			timer.Remove("halo_shield:RechargeDelay"..ply:SteamID())
		end
		if timer.Exists("halo_shield:Recharge"..ply:SteamID()) then
			timer.Remove("halo_shield:Recharge"..ply:SteamID())
		end
		if timer.Exists("halo_shield:NoShieldEffect"..ply:SteamID()) then
			timer.Remove("halo_shield:NoShieldEffect"..ply:SteamID())
		end
	end

	function PLUGIN:PlayerHurt( ply, att, healthRem, damTaken )

		if (PLUGIN:getWhiteList( ply )) then
		
			local plyShield = ply:GetNWInt( "Shield_HP" )

			--print("Damage Taken: "..damTaken)
			if plyShield > 0 then
				ply:SetHealth( healthRem + damTaken )
				ply:SetNWInt( "Shield_HP", math.Clamp( plyShield - damTaken, 0, plyShield ) )
				ply:SetBloodColor(-1)
				ply:EmitSound(Sound("shields/hit" .. math.random(1,7) .. ".wav"),80,100)
				--print("Player Shields: "..plyShield )
			else
				ply:SetBloodColor(0)
				timer.Create("halo_shield:NoShieldEffect"..ply:SteamID(), 0.25, 0, function() 
					if ply:IsValid() then
						local ShoulderRPos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"))
						local ShoulderLPos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"))
						local HipPos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Pelvis")) - Vector(0, 0, 20)
						local HeelRPos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Foot"))
						local HeelLPos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_L_Foot"))

						local effectdata = EffectData()
						effectdata:SetEntity(ply)
						--Torso
						effectdata:SetOrigin(ShoulderRPos)
						util.Effect("halo_shield_depleted", effectdata)
						effectdata:SetOrigin(ShoulderLPos)
						util.Effect("halo_shield_depleted", effectdata)
						effectdata:SetOrigin(HipPos)
						util.Effect("halo_shield_depleted", effectdata)
						--Limbs
						effectdata:SetOrigin(HeelRPos)
						util.Effect("halo_shield_depleted", effectdata)
						effectdata:SetOrigin(HeelLPos)
						util.Effect("halo_shield_depleted", effectdata)
					end
				end)

				if ply.ShieldShldExplode == true then
					ply:EmitSound(Sound("shields/pop/pop" .. math.random(1,3) .. ".wav"),80,100)
					local effectdata = EffectData()
					effectdata:SetEntity(ply)
					--Torso
					effectdata:SetOrigin(ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Pelvis")))
					util.Effect("halo_shield_explode", effectdata)
					ply.ShieldShldExplode = false
				end

			end

			if timer.Exists("halo_shield:RechargeDelay"..ply:SteamID()) then
				timer.Remove("halo_shield:RechargeDelay"..ply:SteamID())
			end
			if timer.Exists("halo_shield:Recharge"..ply:SteamID()) then
				timer.Remove("halo_shield:Recharge"..ply:SteamID())
			end

			timer.Create("halo_shield:RechargeDelay"..ply:SteamID(), 7, 1, function() if ply:IsValid() then StartRecharge( ply ) ply:EmitSound(Sound("ambient/energy/whiteflash.wav"),80,115) end end)
		
		end

	end

	function PLUGIN:EntityTakeDamage( target, dmginfo )
		if target:IsPlayer() then
			local ply = target
			if (PLUGIN:getWhiteList( ply )) then
				local shields = ply:GetNWInt( "Shield_HP" )
				if shields > 0 then
					local effectdata = EffectData()
					effectdata:SetOrigin(dmginfo:GetDamagePosition())
					effectdata:SetEntity(ply)
					util.Effect("halo_shield_impact", effectdata)
				end
			end
		end
	end

end

if CLIENT then
	surface.CreateFont( "SimpleHUDFont", {
		font = "Roboto", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 25,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	local armorSmoothing = LocalPlayer():GetNWInt( "Shield_HP" )

	function PLUGIN:HUDPaint()
		if (PLUGIN:getWhiteList( LocalPlayer() )) then
			--Variables
			local width = ScrW()
			local height = ScrH()
			--local frametime = FrameTime()


			local armor = LocalPlayer():GetNWInt( "Shield_HP" )
			--Armour
			--[[draw.RoundedBox(2, 350, height - 70, width - 700, 30, Color(0,0,0,220))
			armorSmoothing = Lerp(5 * frametime, armorSmoothing, armor)
			draw.RoundedBox(2, 355, height - 65, math.Clamp((armorSmoothing*(width/157))/(HaloShields.MaxShields/100),0,width - 710), 20, Color(200,200,200))

			draw.SimpleText( math.floor(math.Clamp(armor,0,armor)) , "SimpleHUDFont", (width/2)-5, height - 56, Color(math.Clamp(255 - armor / HaloShields.MaxShields * 255,0,255),0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)--]]
			
			local maxShields = nil
			
			if HaloShields.Legacy.Enabled then
				maxShields = HaloShields.Legacy.MaxShields
			else
				maxShields = HaloShields.Whitelist[LocalPlayer():Team()][2]
			end
			
			draw.RoundedBox(2, width/3, height - 70, width / 3, 30, Color(0,0,0,220))
			draw.RoundedBox(2, (width/3) + 5, height - 65, math.Clamp(armor/(maxShields/width * 3),0, (width / 3) - 10), 20, Color(200,200,200))

			draw.SimpleText( math.floor(math.Clamp(armor,0,armor)) , "SimpleHUDFont", (width/2), height - 56, Color(math.Clamp(255 - armor / maxShields * 255,0,255),0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

end
