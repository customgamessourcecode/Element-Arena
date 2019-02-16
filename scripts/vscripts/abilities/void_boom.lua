function OnSpellStart(event)
    local caster = event.caster
    caster:SetMana(0)
    StartAnimation(caster, {duration=10, activity=ACT_DOTA_TELEPORT_REACT, rate=10})
end

function OnDestroy(event)
    local caster = event.caster
    local prc = caster:GetMana()/caster:GetMaxMana()
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    if #enemies > 0 then
        for i=1,#enemies do
            local damageTable = {
            victim = enemies[i],
            attacker = caster,
            damage = enemies[i]:GetMaxHealth()*prc,
            damage_type = DAMAGE_TYPE_PURE
            }
            ApplyDamage(damageTable)
        end
    end
	local nFXIndex = ParticleManager:CreateParticle( "particles/my_shivas_guard_active.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 2500, 1, 2500 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end

function OnIntervalThink(event)
    local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN, event.caster )
end