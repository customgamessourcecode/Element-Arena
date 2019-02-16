times = 0
function OnSpellStart(event)
    times = times + 1
    if times > 10 then
        times = 10
    end
    local caster = event.caster
    local nowtimes = 0
    local dmgt = {DAMAGE_TYPE_MAGICAL,DAMAGE_TYPE_PHYSICAL}
    Timers:CreateTimer(0.1,function()
        local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
        for i=1,#enemies do
            local point = enemies[i]:GetAbsOrigin()
            local nFXIndex1 = ParticleManager:CreateParticle( "particles/econ/events/darkmoon_2017/darkmoon_calldown_marker.vpcf", PATTACH_ABSORIGIN, caster )
            ParticleManager:SetParticleControl( nFXIndex1, 0, point )
            ParticleManager:SetParticleControl( nFXIndex1, 1, Vector( 200, 1, -200 ) )
            ParticleManager:SetParticleControl( nFXIndex1, 2, Vector( 1, 0, 0 ) )
            ParticleManager:ReleaseParticleIndex( nFXIndex1 )
            Timers:CreateTimer(1.1,function()
                ParticleManager:DestroyParticle(nFXIndex1, true)
                local nFXIndex = ParticleManager:CreateParticle( "particles/my_new/light_strike_array_pre_ti7.vpcf", PATTACH_WORLDORIGIN, nil )
                ParticleManager:SetParticleControl( nFXIndex, 0, point )
                ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 200, 1, 1 ) )
                ParticleManager:ReleaseParticleIndex( nFXIndex )
                Timers:CreateTimer(0.3,function()
                    local enemies2 = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
                    if #enemies2 > 0 then
                        for y=1,#enemies2 do
                            local beamnFXIndex = ParticleManager:CreateParticle( "particles/econ/items/luna/luna_lucent_ti5/luna_lucent_beam_impact_shared_ti_5.vpcf", PATTACH_WORLDORIGIN, nil )
                            ParticleManager:SetParticleControl( beamnFXIndex, 1, enemies2[y]:GetAbsOrigin() )
                            ParticleManager:ReleaseParticleIndex( beamnFXIndex )
                            local damageTable = {
                            victim = enemies2[y],
                            attacker = caster,
                            damage = 15000,
                            damage_type = dmgt[RandomInt(1,#dmgt)]
                            }
                            ApplyDamage(damageTable)
                        end
                    end
                end)
            end)
        end
        nowtimes = nowtimes + 1
        if times/2 > nowtimes then
            return 0.3
        end
    end)
end