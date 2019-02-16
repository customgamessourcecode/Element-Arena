function item_life_greaves_on_spell_start( event )
	local caster = event.caster
	local heal	= event.HealAmount
	local mana	= event.ManaAmount
    
    caster:Purge(false,true,false,false,false)
    local target = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 9999,DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for i=1, #target do
        ParticleManager:CreateParticle("particles/econ/events/ti7/mekanism_recipient_ti7.vpcf", PATTACH_ABSORIGIN_FOLLOW, target[i])
        target[i]:Heal(heal,caster)
        target[i]:GiveMana(mana)
    end
end