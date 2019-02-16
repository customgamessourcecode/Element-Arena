function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	stunAbility = thisEntity:FindAbilityByName( "chaos_bolt_datadriven" )
	stormAbility = thisEntity:FindAbilityByName( "abyssal_underlord_firestorm" )
	ultAbility = thisEntity:FindAbilityByName( "my_spectre_haunt" )
	thisEntity:SetContextThink( "ChaosThink", ChaosThink, 1 )
end

function ChaosThink()
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
    
    if stunAbility ~= nil and stunAbility:IsFullyCastable() and enemies[1] ~= nil then
		return stun(enemies[1])
	end
    
    if stormAbility ~= nil and stormAbility:IsFullyCastable() and enemies[1] ~= nil then
		return storm(unitmaxdist)
	end
    
    
	if ultAbility ~= nil and ultAbility:IsFullyCastable() and enemies[1] ~= nil then
		return ult()
	end
	
	return 0.5
end

function stun(enemy)
	
    ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = stunAbility:entindex(),
        TargetIndex = enemy:entindex(),
		Queue = false,
	})
	
	return 1
end

function storm( enemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = stormAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	return 2
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