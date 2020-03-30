PLUGIN.name = "Drop Weapon"
PLUGIN.author = "Stan"
PLUGIN.desc = "Drop your weapons"

--Any weapons you don't want people to drop
PLUGIN.Blacklist = {
    ["nut_hands"] = true,
    ["nut_keys"] = true,
    ["gmod_tool"] = true,
    ["weapon_physgun"] = true,
    ["weapon_biofoaminjector"] = true,
    ["stungun"] = true,
    ["realistic_hook"] = true,
    ["seal6-c4"] = true,
    ["weapon_cuff_elastic"] = true,
    ["weapon_handcuffed"] = true,
}

--["weapon_class"] = "model path replacement"
PLUGIN.ModelOverwrite = {
    ["tfa_h3_ar_swep"] = "models/ar.mdl",
    ["tfa_h3_shotgun"] = "models/shotty.mdl",
    ["h3_energy_sword"] = "models/eblade.mdl",
    ["tfa_h3_beam_rifle_swep"] = "models/h3beamrifle.mdl",
    ["tfa_h3_be_swep"] = "models/br.mdl",
    ["tfa_h3_bruteshot"] = "models/brute_shot.mdl",
    ["tfa_h3_magnum_swep"] = "models/magnum.mdl",
    ["tfa_h3_odst_socom"] = "models/automag.mdl",
    ["tfa_h3_rocket_launcher"] = "models/rocket.mdl",
    ["tfa_h3_smg_swep"] = "models/smg.mdl",
    ["tfa_h3_smg_swep_odst"] = "models/halo_3/smg_sil_w.mdl",
    ["tfa_h3_spiker_swep"] = "models/spiker.mdl",
    ["tfa_h3_sr_swep"] = "models/sniper.mdl",
    ["tfa_hr_swep_dmr"] = "models/haloreach/weapons/dmr.mdl",
    ["tfa_hr_swep_concussion_rifle"] = "models/haloreach/weapons/covenant/concussionrifle.mdl",
    ["tfa_hr_swep_magnum"] = "models/haloreach/m6g_magnum/magnum.mdl",
    ["tfa_hr_swep_needle_rifle"] = "models/covenant/needlerrifle.mdl",
    ["tfa_hr_swep_needler"] = "models/covenant/needler.mdl",
    ["tfa_hr_swep_plasma_rifle"] = "models/weapons/prifle.mdl",
    ["tfa_hr_swep_shotgun"] = "models/weapons/m45_tactical_shotgun.mdl",
    ["tfa_hr_swep_spartan_laser"] = "models/spartanlasero.mdl",
    ["tfa_hr_swep_spiker"] = "models/models/hr_w_spiker.mdl",
    ["tfa_hr_swep_srs99"] = "models/haloreach/srs99/srs99.mdl",
}

--The model of the weapon we use incase anything goes horribly wrong in getting the weapons model
PLUGIN.CallbackModel = "models/props_junk/watermelon01.mdl"

--include the commands file
nut.util.include("sh_commands.lua")