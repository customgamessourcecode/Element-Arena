function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	kotl2stateAbility = thisEntity:FindAbilityByName( "kotl_2_state" )
	kotl3stateAbility = thisEntity:FindAbilityByName( "kotl_3_state" )
	tetherAbility = thisEntity:FindAbilityByName( "kotl_tether" )
	miniboomAbility = thisEntity:FindAbilityByName( "kotl_mini_boom" )
	healAbility = thisEntity:FindAbilityByName( "kotl_heal" )
	boomAbility = thisEntity:FindAbilityByName( "kotl_boom" )
	repelAbility = thisEntity:FindAbilityByName( "kotl_repel" )
	Shivas = thisEntity:FindItemInInventory( "item_shivas_shield" )
	thisEntity:SetContextThink( "KotlThink", KotlThink, 1 )
    thisEntity.state3 = false
    thisEntity.state2 = false
end

function KotlThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    
    if thisEntity:GetAcquisitionRange() < 2000 then
		return 0.5
	end
    
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false )
    
    local prcng = thisEntity:GetHealth()/thisEntity:GetMaxHealth()
    if prcng > 0.67 and thisEntity.state3 == false then
        --1
        for i=1, #enemies do
            if tetherAbility ~= nil and tetherAbility:IsFullyCastable() then
                if enemies[i]:IsRealHero() then
                    local frt = FindUnitsInRadius( thisEntity:GetTeamNumber(), enemies[i]:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
                    if #frt > 1 then
                        return tether(enemies[i])
                    end
                end
            end
        end
        if boomAbility ~= nil and boomAbility:IsFullyCastable() and enemies[1] ~= nil then
            return boom()
        end
        if miniboomAbility ~= nil and miniboomAbility:IsFullyCastable() and enemies[1] ~= nil then
            return miniboom(enemies[1])
        end
	else
        --2 3
        local modif = thisEntity:FindModifierByName("modifier_kotl_2_state")
        if prcng > 0.33 and thisEntity.state3 == false then
            --2
            if modif ~= nil or thisEntity.state2 == true then
                --2
            else
                --1->2
                thisEntity.state2 = true
                local nFXIndex = ParticleManager:CreateParticle( "particles/my_new/light_strike_array_pre_ti7.vpcf", PATTACH_WORLDORIGIN, nil )
                ParticleManager:SetParticleControl( nFXIndex, 0, thisEntity:GetOrigin() )
                ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 500, 1, 1 ) )
                ParticleManager:ReleaseParticleIndex( nFXIndex )
                Timers:CreateTimer(0.2, function()
                    nFXIndex = ParticleManager:CreateParticle( "particles/my_new/light_strike_array_pre_ti7.vpcf", PATTACH_WORLDORIGIN, nil )
                    ParticleManager:SetParticleControl( nFXIndex, 0, thisEntity:GetOrigin() )
                    ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 400, 1, 1 ) )
                    ParticleManager:ReleaseParticleIndex( nFXIndex )
                end)
                Timers:CreateTimer(0.4, function()
                    nFXIndex = ParticleManager:CreateParticle( "particles/my_new/light_strike_array_pre_ti7.vpcf", PATTACH_WORLDORIGIN, nil )
                    ParticleManager:SetParticleControl( nFXIndex, 0, thisEntity:GetOrigin() )
                    ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 300, 1, 1 ) )
                    ParticleManager:ReleaseParticleIndex( nFXIndex )
                end)
                Timers:CreateTimer(0.6, function()
                    nFXIndex = ParticleManager:CreateParticle( "particles/my_new/light_strike_array_pre_ti7.vpcf", PATTACH_WORLDORIGIN, nil )
                    ParticleManager:SetParticleControl( nFXIndex, 0, thisEntity:GetOrigin() )
                    ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 200, 1, 1 ) )
                    ParticleManager:ReleaseParticleIndex( nFXIndex )
                    kotl2stateAbility:ApplyDataDrivenModifier( thisEntity, thisEntity, "modifier_kotl_2_state", {} )
                    thisEntity.mywisps = {}
                    for i=1, 5 do
                        local newSpirit = CreateUnitByName( "npc_dota_custom_creep_45_2", thisEntity:GetAbsOrigin(), false, thisEntity, thisEntity, thisEntity:GetTeam() )
                        newSpirit.kotl = thisEntity
                        thisEntity.mywisps[i] = newSpirit
                        local rotationAngle = 0 - 45 - (72 * i)
                        local relPos = Vector( 0, 300, 0 )
                        relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )
                        --local nPos = GetGroundPosition( relPos + thisEntity:GetAbsOrigin(), newSpirit )
                        local order = {
                            OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
                            UnitIndex = newSpirit:entindex(),
                            Position  = relPos,
                            Queue     = false
                        }
                        Timers:CreateTimer(0.4, function()
                            ExecuteOrderFromTable( order )
                        end)
                    end
                end)
                return 2
            end
        else
            --3
            if modif ~= nil then
                --2->3
                thisEntity:RemoveModifierByName("modifier_kotl_2_state")
                kotl3stateAbility:ApplyDataDrivenModifier( thisEntity, thisEntity, "modifier_kotl_3_state", {} )
                kotl3stateAbility:ApplyDataDrivenModifier( thisEntity, thisEntity, "modifier_kotl_3_state_for_caster", {} )
                thisEntity.state3 = true
                --for i=1, 5 do
                    --kotl2stateAbility:ApplyDataDrivenModifier( thisEntity.mywisps[i], thisEntity.mywisps[i], "modifier_kotl_2_state", {} )
                    --thisEntity.mywisps[i]:ForceKill(true)
                --end
            else
                --3
                for i=1, #enemies do
                    if tetherAbility ~= nil and tetherAbility:IsFullyCastable() then
                        if enemies[i]:IsRealHero() then
                            local frt = FindUnitsInRadius( thisEntity:GetTeamNumber(), enemies[i]:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
                            if #frt > 1 then
                                return tether(enemies[i])
                            end
                        end
                    end
                end
                if boomAbility ~= nil and boomAbility:IsFullyCastable() and enemies[1] ~= nil then
                    return boom()
                end
                if miniboomAbility ~= nil and miniboomAbility:IsFullyCastable() and enemies[1] ~= nil then
                    return miniboom(enemies[1])
                end
                if healAbility ~= nil and healAbility:IsFullyCastable() then
                    return heal()
                end
                if repelAbility ~= nil and repelAbility:IsFullyCastable() then
                    return repel()
                end
            end
        end
    end
    
	if Shivas ~= nil and Shivas:IsFullyCastable() then
		return castShivas()
	else
		if Shivas == nil then
			Shivas = thisEntity:FindItemInInventory( "item_shivas_shield" )
		end
    end
    
	return 0.5
end


function tether(enemy)
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = tetherAbility:entindex(),
        TargetIndex = enemy:entindex(),
		Queue = false,
	})
	
	return 0.5
end

function miniboom(enemy)
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = miniboomAbility:entindex(),
        TargetIndex = enemy:entindex(),
		Queue = false,
	})
	
	return 0.5
end

function heal()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = healAbility:entindex(),
		Queue = false,
	})
	
	return 0.5
end

function boom()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = boomAbility:entindex(),
		Queue = false,
	})
	
	return 1
end

function repel()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = repelAbility:entindex(),
		Queue = false,
	})
	
	return 0.5
end

function castShivas()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = Shivas:entindex(),
		Queue = false,
	})
	
	return 0.5
end