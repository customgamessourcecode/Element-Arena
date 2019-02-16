function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	odKupolAbility = thisEntity:FindAbilityByName( "arc_warden_magnetic_field" )
	odTreeBreakerAbility = thisEntity:FindAbilityByName( "od_tree_breaker" )
	odMFAbility = thisEntity:FindAbilityByName( "od_mf" )
	odUltAbility = thisEntity:FindAbilityByName( "od_ult" )
	Shivas = thisEntity:FindItemInInventory( "item_shivas_shield" )
	thisEntity:SetContextThink( "ODThink", ODThink, 1 )
    thisEntity.state3 = false
    thisEntity.state2 = false
end

function ODThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    
    if thisEntity:GetAcquisitionRange() < 2000 then
		return 0.5
	end

    local prcng = thisEntity:GetHealth()/thisEntity:GetMaxHealth()
    if prcng < 0.5 then
		if odUltAbility ~= nil and odUltAbility:IsFullyCastable() then
			ult()
		end
    end
    
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false )
	
	if odMFAbility ~= nil and odMFAbility:IsFullyCastable() and enemies[1] ~= nil then
		MF()
	end

	if odTreeBreakerAbility ~= nil and odTreeBreakerAbility:IsFullyCastable() and enemies[1] ~= nil then
		TreeBreaker()
	end

	if odKupolAbility ~= nil and odKupolAbility:IsFullyCastable() and enemies[1] ~= nil then
		Kupol()
	end
    
	if Shivas ~= nil and Shivas:IsFullyCastable() then
		return castShivas()
	else
		if Shivas == nil then
			Shivas = thisEntity:FindItemInInventory( "item_shivas_shield" )
		end
    end
    
	return 0.5
end

function ult()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = odUltAbility:entindex(),
		Queue = false,
	})
	
	return 0.5
end

function MF()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = odMFAbility:entindex(),
		Queue = false,
	})
	
	return 0.5
end

function TreeBreaker()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = odTreeBreakerAbility:entindex(),
		Queue = false,
	})
	
	return 0.5
end

function Kupol( )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = odKupolAbility:entindex(),
		Position = thisEntity:GetOrigin(),
		Queue = false,
	})

	return 1
end

function castShivas()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = Shivas:entindex(),
		Queue = false,
	})
	
	return 0.5
end