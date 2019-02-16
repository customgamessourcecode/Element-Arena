function OnIntervalThink(event)
    local caster = event.target
    if caster ~= nil then
        if caster:GetHealth()/caster:GetMaxHealth() < 0.34 then
            local point = caster:GetAbsOrigin()
            local enemies2 = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
            if #enemies2 > 0 then
                local target = enemies2[RandomInt(1,#enemies2)]
                local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_WORLDORIGIN, caster)
                ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
                ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
                local damageTable = {
                    victim = target,
                    attacker = caster,
                    damage = 1000,
                    damage_type = DAMAGE_TYPE_MAGICAL
                }
                ApplyDamage(damageTable)
            end
        end
    end
end