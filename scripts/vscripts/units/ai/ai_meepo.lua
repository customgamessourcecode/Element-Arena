function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	poofAbility = thisEntity:FindAbilityByName( "meepo_poof" )
	thisEntity:SetContextThink( "MeepoThink", MeepoThink, 1 )
end

function MeepoThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    
    if poofAbility ~= nil and poofAbility:IsFullyCastable() and enemies[1] ~= nil then
		return cast()
	end
    
	return 0.5
end

function cast( )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = thisEntity:GetOrigin(),
		AbilityIndex = poofAbility:entindex(),
		Queue = false,
	})

	return 2
end