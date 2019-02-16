function OnSpellStart(event)
    local caster = event.caster
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    for i=1,#enemies do
        local dmgtimer = true
        local ticks = 0
        local point = enemies[i]:GetAbsOrigin()
        local nFXIndex1 = ParticleManager:CreateParticle( "particles/econ/events/darkmoon_2017/darkmoon_calldown_marker.vpcf", PATTACH_ABSORIGIN, caster )
        ParticleManager:SetParticleControl( nFXIndex1, 0, point )
        ParticleManager:SetParticleControl( nFXIndex1, 1, Vector( 200, 1, -200 ) )
        ParticleManager:SetParticleControl( nFXIndex1, 2, Vector( 1, 0, 0 ) )
        ParticleManager:ReleaseParticleIndex( nFXIndex1 )
        local dur = 5
        if caster:FindModifierByName("mod_od_ult") then
            dur = 10
        end
        Timers:CreateTimer(1.0,function()
            ParticleManager:DestroyParticle(nFXIndex1, true)
            local nFXIndex = ParticleManager:CreateParticle( "particles/my_new/rbck_arc_skywrath_mage_mystic_flare_ambient.vpcf", PATTACH_WORLDORIGIN, nil )
            ParticleManager:SetParticleControl( nFXIndex, 0, point )
            ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 200, dur, 0.1 ) )
            ParticleManager:ReleaseParticleIndex( nFXIndex )
            Timers:CreateTimer(0.099,function()
                local enemies2 = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
                if #enemies2 > 0 then
                    for y=1,#enemies2 do
                        local damageTable = {
                        victim = enemies2[y],
                        attacker = caster,
                        damage = 200 + 10 * ticks,
                        damage_type = DAMAGE_TYPE_MAGICAL
                        }
                        ApplyDamage(damageTable)
                    end
                end
                ticks = ticks + 1
                if dmgtimer then
                    return 0.099
                end
            end)
            Timers:CreateTimer(dur,function()
                dmgtimer = false
           end)
        end)
    end
end