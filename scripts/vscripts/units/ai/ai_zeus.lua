function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	arcAbility = thisEntity:FindAbilityByName( "arc_lightning_datadriven" )
	boltAbility = thisEntity:FindAbilityByName( "lightning_bolt_datadriven" )
	thisEntity:SetContextThink( "ZeusThink", ZeusThink, 1 )
end

function ZeusThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    
    if arcAbility ~= nil and arcAbility:IsFullyCastable() and enemies[1] ~= nil then
		return arc(enemies[1])
	end
    
    if boltAbility ~= nil and boltAbility:IsFullyCastable() and enemies[1] ~= nil then
		return bolt(enemies[1])
	end
	
	return 0.5
end

function arc( enemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = arcAbility:entindex(),
        TargetIndex = enemy:entindex(),
		Queue = false,
	})

	return 1
end

function bolt( enemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = boltAbility:entindex(),
        TargetIndex = enemy:entindex(),
		Queue = false,
	})

	return 1
end