function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	impaleAbility = thisEntity:FindAbilityByName( "nyx_assassin_impale" )
	carapaceAbility = thisEntity:FindAbilityByName( "nyx_assassin_spiked_carapace" )
	vendettaAbility = thisEntity:FindAbilityByName( "nyx_assassin_vendetta" )
	Dagon = thisEntity:FindItemInInventory( "item_power_dagon" )
	Shivas = thisEntity:FindItemInInventory( "item_shivas_shield" )
	thisEntity:SetContextThink( "NyxThink", NyxThink, 1 )
end

function NyxThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    
    if thisEntity:GetAcquisitionRange() < 2000 then
		return 0.5
	end
    
    if carapaceAbility ~= nil and carapaceAbility:IsFullyCastable() then
		return carapace()
	end
    
	if Shivas ~= nil and Shivas:IsFullyCastable() then
		return castShivas()
	else
		if Shivas == nil then
			Shivas = thisEntity:FindItemInInventory( "item_shivas_shield" )
		end
    end
    
	local nEnemiesRemoved = 0
    local nEnemiesRemovedList = {}
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    
    local maxdist = 0
    local unitmaxdist = nil
    for i = 1, #enemies do
		local enemy = enemies[i]
		if enemy ~= nil then
			local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist > maxdist then
                maxdist = flDist
                unitmaxdist = enemy
			end
		end
	end
    
    if impaleAbility ~= nil and impaleAbility:IsFullyCastable() and unitmaxdist ~= nil then
		return impale(unitmaxdist)
	end
    
    if vendettaAbility ~= nil and vendettaAbility:IsFullyCastable() and unitmaxdist ~= nil then
		return vendetta(unitmaxdist)
	end
    
    if Dagon ~= nil and Dagon:IsFullyCastable() and enemies[1] ~= nil then
		return castDagon(enemies[1])
	else
		if Dagon == nil then
			Dagon = thisEntity:FindItemInInventory( "item_power_dagon" )
		end
    end
	
	return 0.5
end

function castShivas()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = Shivas:entindex(),
		Queue = false,
	})
	
	return 1
end

function carapace()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = carapaceAbility:entindex(),
		Queue = false,
	})
	
	return 1
end


function impale( enemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = impaleAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	return 1
end

function vendetta(enemy)
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = vendettaAbility:entindex(),
		Queue = false,
	})
	
    ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
        TargetIndex = enemy:entindex(),
		Queue = false,
	})
    
	return 1
end

function castDagon( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = Dagon:entindex(),
	})
	return 1
end