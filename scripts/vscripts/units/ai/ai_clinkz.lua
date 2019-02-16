function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	strafe = thisEntity:FindAbilityByName( "my_clinkz_strafe" )
	thisEntity:SetContextThink( "clinkzThink", clinkzThink, 1 )
end

function clinkzThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    
	if strafe ~= nil then
		return caststrafe()
	end
	
	return 0.5
end

function caststrafe()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = strafe:entindex(),
		Queue = false,
	})
	
	return 10
end