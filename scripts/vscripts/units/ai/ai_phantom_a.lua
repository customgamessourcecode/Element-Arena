function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	blinkAbility = thisEntity:FindAbilityByName( "phantom_assassin_phantom_strike_datadriven" )
	thisEntity:SetContextThink( "PAThink", PAThink, 1 )
end

function PAThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
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
    
    if blinkAbility ~= nil and blinkAbility:IsFullyCastable() and unitmaxdist ~= nil and maxdist > 200 then
		return blink(unitmaxdist)
	end
	
	return 0.5
end

function blink( enemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = blinkAbility:entindex(),
        TargetIndex = enemy:entindex(),
		Queue = false,
	})

	return 1
end