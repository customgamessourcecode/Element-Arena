
--[[ units/ai/ai_exploding_burrower.lua ]]

----------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	hExplosionAbility = thisEntity:FindAbilityByName( "burrower_explosion" )

	thisEntity:SetContextThink( "ExplodingNyxThink", ExplodingNyxThink, 0.5 )
end

----------------------------------------------------------------------------------------------

function ExplodingNyxThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	-- Is the assigned target our parent gave us dead?
	if thisEntity.hParentImpaleTarget and ( ( not thisEntity.hParentImpaleTarget:IsAlive() ) or thisEntity.hParentImpaleTarget:IsNull() ) then
		thisEntity.hParentImpaleTarget = nil
	end

	-- Is the assigned target our parent gave us an old assignment?
	if thisEntity.timeTargetAssigned and ( GameRules:GetGameTime() > ( thisEntity.timeTargetAssigned + 10 ) ) then
		thisEntity.hParentImpaleTarget = nil
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

	local hExplosionTarget = nil
	local hApproachTarget = nil

	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsAlive() then
			local flDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
				if flDist <= 150 then
					hExplosionTarget = hEnemy
				end
				if flDist > 150 then
					hApproachTarget = hEnemy
				end
		end
	end

	if hExplosionTarget and hExplosionAbility and hExplosionAbility:IsCooldownReady() then
		return CastExplosion()
	end

	if hExplosionTarget then
		thisEntity:FaceTowards( hExplosionTarget:GetOrigin() )
	end

	return 0.5
end

----------------------------------------------------------------------------------------------

function CastExplosion()
	--print( "ExplodingBurrower - CastExplosion()" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hExplosionAbility:entindex(),
		Queue = false,
	})
	return 1
end