part_mod = class({})
--------------------------------------------------------------------------------
function part_mod:GetEffectName()
    local partcls = {
    "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf",
    "particles/econ/courier/courier_greevil_orange/courier_greevil_orange_ambient_3.vpcf",
    "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient.vpcf",
    "particles/econ/events/ti8/ti8_hero_effect.vpcf",
    "particles/econ/courier/courier_hermit_crab/hermit_crab_skady_ambient.vpcf",
    "particles/econ/courier/courier_shagbark/courier_shagbark_ambient.vpcf",
    "particles/my_new/courier_roshan_darkmoon.vpcf",
    "particles/econ/events/ti7/ti7_hero_effect.vpcf",
    "particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_hatchling_ice.vpcf",
    "particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_hatchling_fire.vpcf",--др
    --------------------------------------------------------------------------------------------------------------------------------
    "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf",
    "particles/econ/courier/courier_trail_divine/courier_divine_ambient.vpcf",
    "particles/my_new/ambientfx_effigy_wm16_radiant_lvl3.vpcf",
    "particles/econ/courier/courier_axolotl_ambient/courier_axolotl_ambient_lvl4.vpcf",
    "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf",
    "particles/econ/courier/courier_roshan_frost/courier_roshan_frost_ambient.vpcf",
    "particles/econ/courier/courier_roshan_ti8/courier_roshan_ti8_flying.vpcf",
    "particles/econ/items/ember_spirit/ember_spirit_vanishing_flame/ember_spirit_vanishing_flame_ambient.vpcf",
    "particles/econ/courier/courier_greevil_blue/courier_greevil_blue_ambient_3.vpcf",
    "particles/econ/courier/courier_greevil_purple/courier_greevil_purple_ambient_3.vpcf",
    "particles/econ/courier/courier_greevil_red/courier_greevil_red_ambient_3.vpcf",
    "particles/econ/courier/courier_greevil_yellow/courier_greevil_yellow_ambient_3.vpcf",
    "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_2.vpcf",
    "particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_swarm.vpcf",--сталкера
    "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf",--сильная трава
    "particles/econ/courier/courier_golden_doomling/courier_golden_doomling_bloom_ambient.vpcf",--слабые золотые частички
    "particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf",--молнии платиного рошана
    "particles/dev/curlnoise_test.vpcf", -- много частичек
    "particles/econ/courier/courier_axolotl_ambient/courier_axolotl_ambient.vpcf",--розавая дичь
    "particles/econ/items/sniper/sniper_charlie/sniper_shrapnel_charlie_ground.vpcf",--поляна
    "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf",--стан вк х10
    "particles/econ/courier/courier_faceless_rex/cour_rex_ground_a.vpcf",--"шипы" из под земли
    "particles/econ/courier/courier_roshan_desert_sands/baby_roshan_desert_sands_ambient.vpcf",--send roshan
    "particles/econ/items/bane/slumbering_terror/bane_slumbering_terror_ambient_a.vpcf",--штука бейна
    "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf",--инвок
    "particles/econ/courier/courier_crystal_rift/courier_ambient_crystal_rift.vpcf",
    "particles/econ/courier/courier_oculopus/courier_oculopus_ambient.vpcf",
    "particles/econ/items/rubick/rubick_arcana/rubick_arc_ambient_detail.vpcf",
    "",
    ""
    
    --"particles/econ/courier/courier_baekho/courier_baekho_ambient.vpcf",--слабая розавая дичь
    --"particles/econ/courier/courier_jade_horn/courier_jade_horn_ambient.vpcf",--слабый зелёный эффект
    --"particles/econ/courier/courier_red_horn/courier_red_horn_ambient.vpcf",--слабый красный эффект
    --"particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_arcana_ground_ambient.vpcf",--слабые снежинки под ногами
    --"particles/econ/courier/courier_smeevil_flying_carpet/courier_smeevil_flying_carpet_ambient.vpcf",--слабые очень маленикие жёлтые частички
    --"particles/econ/courier/courier_gold_horn/courier_gold_horn_ambient.vpcf",--old др
    }
	return partcls[self:GetStackCount()]
end

function part_mod:IsHidden() 
	return true
end
--------------------------------------------------------------------------------
function part_mod:OnCreated( kv )
    if IsServer() then
        self:SetStackCount(tonumber(kv.part))
    end
end

function part_mod:IsPurgable()
	return false
end

function part_mod:RemoveOnDeath()
    return false
end