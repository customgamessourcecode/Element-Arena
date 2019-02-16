function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	rocetsAbility = thisEntity:FindAbilityByName( "tinker_heat_seeking_missile_datadriven" )
	laserAbility = thisEntity:FindAbilityByName( "tinker_laser" )
	ultAbility = thisEntity:FindAbilityByName( "exorcism_datadriven" )
	ult2Ability = thisEntity:FindAbilityByName( "my_tinker_boom" )
	thisEntity:SetContextThink( "TinkerThink", TinkerThink, 1 )
end

function TinkerThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true or thisEntity:FindModifierByName("my_tinker_boom_in") ~= nil then
		return 1
	end
    
    if thisEntity:GetAcquisitionRange() < 2000 then
		return 0.5
	end
    
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    
    if laserAbility ~= nil and laserAbility:IsFullyCastable() and enemies[1] ~= nil then
		return laser(enemies[1])
	end
    
	if rocetsAbility ~= nil and rocetsAbility:IsFullyCastable() and enemies[1] ~= nil  then
		return rocets()
	end
    
    if ultAbility ~= nil and ultAbility:IsFullyCastable() and enemies[1] ~= nil then
		return ult()
	end
    
    if ult2Ability ~= nil and ult2Ability:IsFullyCastable() and enemies[1] ~= nil then
		return ult2()
	end
	
	return 0.5
end


function rocets()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = rocetsAbility:entindex(),
		Queue = false,
	})
	
	return 0.5
end


function laser( enemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = laserAbility:entindex(),
		TargetIndex = enemy:entindex(),
		Queue = false,
	})

	return 1
end

function ult()
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = ultAbility:entindex(),
		Queue = false,
	})
	
	return 1
end

function ult2()
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = ult2Ability:entindex(),
		Queue = false,
	})
	
	return 8
end