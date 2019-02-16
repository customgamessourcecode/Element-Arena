function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	stompAbility = thisEntity:FindAbilityByName( "elder_titan_echo_stomp" )
	spiritAbility = thisEntity:FindAbilityByName( "elder_titan_ancestral_spirit" )
	splitterAbility = thisEntity:FindAbilityByName( "elder_titan_earth_splitter" )
	thisEntity:SetContextThink( "TitanTankThink", TitanTankThink, 1 )
end

function TitanTankThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    
    if thisEntity:GetAcquisitionRange() < 2000 then
		return 0.5
	end
    
	local nEnemiesRemoved = 0
    local nEnemiesRemovedList = {}
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    local entcol = #enemies
    local oneent = nil
    if entcol == 1 then
        oneent = enemies[1]
    end
    
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
    
    if spiritAbility ~= nil and spiritAbility:IsFullyCastable() and enemies[1] ~= nil then
		return spirit(unitmaxdist)
	end
    
	for i = 1, #enemies do
		local enemy = enemies[i]
		if enemy ~= nil then
			local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist > 600 then
				nEnemiesRemoved = nEnemiesRemoved + 1
                nEnemiesRemovedList[nEnemiesRemoved] = enemy
				table.remove( enemies, i )
			end
		end
	end
    
	if stompAbility ~= nil and stompAbility:IsFullyCastable() then
		return stomp()
	end
    
    if entcol ~= 1 then
        if splitterAbility ~= nil and splitterAbility:IsFullyCastable() and nEnemiesRemoved > 0 then
            return splitter(nEnemiesRemovedList[1])
        end
    else
        if splitterAbility ~= nil and splitterAbility:IsFullyCastable() and oneent ~= nil then
            return splitter(oneent)
        end
    end
	
	return 0.5
end


function stomp()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = stompAbility:entindex(),
		Queue = false,
	})
	
	return 2
end


function spirit( enemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = spiritAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	return 1
end

function splitter(enemy)
	
    ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = splitterAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})
	
	return 2
end