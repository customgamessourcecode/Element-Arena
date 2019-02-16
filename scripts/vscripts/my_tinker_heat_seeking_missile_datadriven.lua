function OnSpellStart(event)
	local caster = event.caster
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    local point = enemies[RandomInt(1,#enemies)]:GetAbsOrigin()
    local nFXIndex1 = ParticleManager:CreateParticle( "particles/econ/events/darkmoon_2017/darkmoon_calldown_marker.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( nFXIndex1, 0, point )
	ParticleManager:SetParticleControl( nFXIndex1, 1, Vector( 170, 1, -170 ) )
	ParticleManager:SetParticleControl( nFXIndex1, 2, Vector( 1, 0, 0 ) )
    ParticleManager:ReleaseParticleIndex( nFXIndex1 )
    Timers:CreateTimer(1,function()
        ParticleManager:DestroyParticle(nFXIndex1, true)
        local enemies2 = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, 85, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
        if #enemies2 > 0 then
            for i=1,#enemies2 do
                local damageTable = {
                victim = enemies2[i],
                attacker = caster,
                damage = 7000,
                damage_type = DAMAGE_TYPE_MAGICAL
                }
                ApplyDamage(damageTable)
            end
        end
        local nFXIndex1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_magnetic.vpcf", PATTACH_ABSORIGIN, caster )
        ParticleManager:SetParticleControl( nFXIndex1, 0, point )
        ParticleManager:SetParticleControl( nFXIndex1, 1, Vector( 170, 170, 170 ) )
        Timers:CreateTimer(0.2,function()
            ParticleManager:DestroyParticle(nFXIndex1, false)
        end)
    end)
end