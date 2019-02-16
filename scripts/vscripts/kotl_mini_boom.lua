function OnIntervalThink(event)
    local target = event.target
    local caster = event.caster
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    for i=1,#enemies do
        if enemies[i] == target then
            local damageTable = {
            victim = enemies[i],
            attacker = caster,
            damage = 1000,
            damage_type = DAMAGE_TYPE_MAGICAL
            }
            ApplyDamage(damageTable)
        else
            local damageTable = {
            victim = enemies[i],
            attacker = caster,
            damage = 4000,
            damage_type = DAMAGE_TYPE_MAGICAL
            }
            ApplyDamage(damageTable)
        end
    end
end