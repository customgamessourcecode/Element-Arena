function OnIntervalThinkCreater(event)
    local caster = event.caster
    if caster ~= nil then
        if caster:GetHealth() < caster:GetMaxHealth() then
            local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
            local point = enemies[RandomInt(1,#enemies)]:GetAbsOrigin()
            local nFXIndex1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf", PATTACH_ABSORIGIN, caster )
            ParticleManager:SetParticleControl( nFXIndex1, 0, point )
            ParticleManager:SetParticleControl( nFXIndex1, 1, Vector( 170, 170, 170 ) )
            if caster.nfxarray == nil then
                caster.nfxarray = {}
            end
            if caster.pointarray == nil then
                caster.pointarray = {}
            end
            table.insert(caster.nfxarray, nFXIndex1)
            table.insert(caster.pointarray, point)
        end
    end
end

--function OnDestroy(event)
--    local caster = event.target
--    if caster ~= nil and caster.nfxarray ~= nil then
--        for _,nfx in caster.nfxarray do
--            ParticleManager:DestroyParticle(nfx, false)
--        end
--    end
--end

function OnIntervalThink(event)
    local caster = event.target
    if caster ~= nil and caster.pointarray ~= nil then
        if #caster.pointarray > 0 then
            for u=1,#caster.pointarray do
                local point = caster.pointarray[u]
                local enemies2 = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, 85, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
                if #enemies2 > 0 then
                    for i=1,#enemies2 do
                        local damageTable = {
                        victim = enemies2[i],
                        attacker = caster,
                        damage = 200,
                        damage_type = DAMAGE_TYPE_PURE
                        }
                        ApplyDamage(damageTable)
                    end
                end
            end
        end
    end
end