function DestroyAura(event)
    target = event.target
    print(target)
	JumpAbility = target:FindAbilityByName( "my_lone_druid_true_form_datadriven" )
    
    if JumpAbility ~= nil then
        if target:IsAlive() then
    ExecuteOrderFromTable({
		UnitIndex = target:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = JumpAbility:entindex(),
		Queue = false,
	})
    end
    end
end