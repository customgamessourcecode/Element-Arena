function OnCreated(event)
    if event.caster:GetHealth() < event.caster:GetMaxHealth() then
        ExecuteOrderFromTable({
            UnitIndex = event.caster:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
            AbilityIndex = event.ability:entindex(),
            Queue = false,
        })
    end
end