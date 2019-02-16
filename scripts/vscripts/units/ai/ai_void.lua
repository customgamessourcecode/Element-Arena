function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	kupolAbility = thisEntity:FindAbilityByName( "void_my_kupol" )
	boomAbility = thisEntity:FindAbilityByName( "void_boom" )
	miniboomAbility = thisEntity:FindAbilityByName( "void_mini_boom" )
	thisEntity:SetContextThink( "TitanTankThink", VoidThink, 1 )
end

function VoidThink()
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
    
    local prcng = thisEntity:GetHealth()/thisEntity:GetMaxHealth()
    print(prcng)
    if prcng > 0.67 then
        if miniboomAbility ~= nil and miniboomAbility:IsFullyCastable() and enemies[1] ~= nil then
            return miniboom()
        end
	else
        if miniboomAbility ~= nil and miniboomAbility:IsFullyCastable() and enemies[1] ~= nil then
            return miniboom()
        end
        
        if kupolAbility ~= nil and kupolAbility:IsFullyCastable() and enemies[1] ~= nil then
            return kupol()
        end
        
        if boomAbility ~= nil and boomAbility:IsFullyCastable() and enemies[1] ~= nil then
            return boom()
        end
    end
	return 0.5
end


function kupol()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = kupolAbility:entindex(),
		Queue = false,
	})
	
	return 1
end

function miniboom()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = miniboomAbility:entindex(),
		Queue = false,
	})
	
	return 1
end

function boom()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = boomAbility:entindex(),
		Queue = false,
	})
	
	return 11
end