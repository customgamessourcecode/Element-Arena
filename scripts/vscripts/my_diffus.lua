function OnAttackLanded( event )
    local target = event.target
    local caster = event.caster
    local ability = event.ability
    local mana_break = ability:GetSpecialValueFor( "mana_break" )
    local prc = ability:GetSpecialValueFor( "prc" )
    
    local tmana = target:GetMana()
    if tmana > 0 then
        if tmana > mana_break then
            target:ReduceMana(mana_break)
            local damageTable = {
            victim = target,
            attacker = caster,
            damage = mana_break * prc,
            damage_type = DAMAGE_TYPE_PHYSICAL
            }
            ApplyDamage(damageTable)
        else
            target:ReduceMana(tmana)
            local damageTable = {
            victim = target,
            attacker = caster,
            damage = tmana * prc,
            damage_type = DAMAGE_TYPE_PHYSICAL
            }
            ApplyDamage(damageTable)
            
        end
    end
end