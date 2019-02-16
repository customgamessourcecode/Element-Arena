function OnSpellStart(event)
	local caster = event.caster
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    local point = enemies[RandomInt(1,#enemies)]:GetAbsOrigin()
    local nFXIndex1 = ParticleManager:CreateParticle( "particles/econ/events/darkmoon_2017/darkmoon_calldown_marker.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( nFXIndex1, 0, point )
	ParticleManager:SetParticleControl( nFXIndex1, 1, Vector( 300, 1, -300 ) )
	ParticleManager:SetParticleControl( nFXIndex1, 2, Vector( 1, 0, 0 ) )
    ParticleManager:ReleaseParticleIndex( nFXIndex1 )
    Timers:CreateTimer(1.8,function()
        ParticleManager:DestroyParticle(nFXIndex1, true)
        local enemies2 = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
        if #enemies2 > 0 then
            for i=1,#enemies2 do
                local damageTable = {
                victim = enemies2[i],
                attacker = caster,
                damage = 10000,
                damage_type = DAMAGE_TYPE_PHYSICAL
                }
                ApplyDamage(damageTable)
            end
            for i=1,#enemies do
                local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_WORLDORIGIN, enemies2[1])
                ParticleManager:SetParticleControl(lightningBolt,0,Vector(enemies2[1]:GetAbsOrigin().x,enemies2[1]:GetAbsOrigin().y,enemies2[1]:GetAbsOrigin().z + enemies2[1]:GetBoundingMaxs().z ))   
                ParticleManager:SetParticleControl(lightningBolt,1,Vector(enemies[i]:GetAbsOrigin().x,enemies[i]:GetAbsOrigin().y,enemies[i]:GetAbsOrigin().z + enemies[i]:GetBoundingMaxs().z ))
                local damageTable = {
                victim = enemies[i],
                attacker = caster,
                damage = 7500,
                damage_type = DAMAGE_TYPE_MAGICAL
                }
                ApplyDamage(damageTable)
            end
        end
        local nFXIndex2 = ParticleManager:CreateParticle( "particles/my_new/my_lina_spell_light_strike_array_ti7.vpcf", PATTACH_ABSORIGIN, caster )
        ParticleManager:SetParticleControl( nFXIndex2, 0, point )
        ParticleManager:SetParticleControl( nFXIndex2, 1, Vector( 300, 1, 1 ) )
        Timers:CreateTimer(1,function()
            ParticleManager:DestroyParticle(nFXIndex2, false)
        end)
    end)
end