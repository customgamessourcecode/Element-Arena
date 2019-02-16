function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	spiritsAbility = thisEntity:FindAbilityByName( "phoenix_fire_spirits_datadriven" )
	launchAbility = thisEntity:FindAbilityByName( "phoenix_launch_fire_spirit_datadriven" )
	rayAbility = thisEntity:FindAbilityByName( "phoenix_sun_ray_datadriven" )
	novaAbility = thisEntity:FindAbilityByName( "phoenix_supernova_datadriven" )
	thisEntity:SetContextThink( "PhoenixThink", PhoenixThink, 1 )
end

i = 1

function PhoenixThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    
    if thisEntity:GetAcquisitionRange() < 2000 then
		return 0.5
	end
    
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    
    if spiritsAbility ~= nil and spiritsAbility:IsFullyCastable() and enemies[1] ~= nil then
		return spirits()
	end
    
    if novaAbility:IsFullyCastable() then
    if launchAbility ~= nil and launchAbility:IsFullyCastable() and enemies[1] ~= nil and not launchAbility:IsHidden() then
		return launch(enemies[1])
	end
    else
    if i < #enemies then
	if launchAbility ~= nil and launchAbility:IsFullyCastable() and enemies[1] ~= nil and not launchAbility:IsHidden() then
        i = i + 1
		return launch(enemies[i-1])
	end
    else
    if launchAbility ~= nil and launchAbility:IsFullyCastable() and enemies[1] ~= nil and not launchAbility:IsHidden() then
        i = 1
		return launch(enemies[#enemies])
	end
    end
    end
    
    if rayAbility ~= nil and rayAbility:IsFullyCastable() and enemies[1] ~= nil then
		return ray(enemies[1])
	end
	
	return 0.5
end


function spirits()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = spiritsAbility:entindex(),
		Queue = false,
	})
	
	return 0.5
end


function launch( enemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = launchAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})
    
    if i == 1 then
        launchAbility:StartCooldown(3)
    end
    
    return 0.1
end

function ray(enemy)
	
    ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = rayAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})
	
	return 1
end