--[[
	Author: Ractidous, with help from Noya
	Date: 03.02.2015.
	Initialize the slowed units list, and let the caster latch.
	We also need to track the health/mana, in order to grab amount gained of health/mana in the future.
]]
function CastTether( event )
	-- Variables
	local caster	= event.caster
	local target	= event.target
	local ability	= event.ability

	-- Store the ally unit
	ability.tether_ally = target

    local friends = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, target:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_FARTHEST, false )
    ability.tether_target = friends[1]
    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_ABSORIGIN, target )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, ability.tether_target, PATTACH_POINT_FOLLOW, "attach_hitloc", ability.tether_target:GetOrigin(), true )
	--ParticleManager:ReleaseParticleIndex( nFXIndex )
    ability.fx = nFXIndex
	ability:ApplyDataDrivenModifier( caster, ability.tether_target, "modifier_tether_ally_datadriven", {} )
end

--[[
	Author: Ractidous
	Date: 04.02.2015.
	Check for tether break distance.
]]
function CheckDistance( event )
	local caster = event.caster
	local ability = event.ability

	local distance = ( ability.tether_ally:GetAbsOrigin() - ability.tether_target:GetAbsOrigin() ):Length2D()
    print(distance)
	if distance <= event.radius then
		return
	end
	-- Break tether
    local kill1 = ability.tether_ally
    local kill2 = ability.tether_target
    kill1:ForceKill(false)
    kill2:ForceKill(false)
end

--[[
	Author: Ractidous
	Date: 03.02.2015.
	Remove tether from the ally, then swap the abilities back to the original states.
]]
function EndTether( event )
	local ability = event.ability

    ParticleManager:DestroyParticle(ability.fx, false)
	ability.tether_target:RemoveModifierByName( event.ally_modifier )
	ability.tether_target = nil
	ability.tether_ally = nil
end
function EndTether2( event )
	local ability = event.ability
	ability.tether_ally:RemoveModifierByName( event.ally_modifier )
end

--[[
	Author: Ractidous
	Date: 03.02.2015.
	Pull the caster to the tethered ally.
]]
function Latch( event )
	-- Variables
	local caster	= event.caster
	local ability	= event.ability
	local target 	= ability.tether_ally

	local tickInterval	= event.tick_interval
	local latchSpeed	= event.latch_speed
	local latchDistance	= event.latch_distance_to_target

	local casterOrigin	= caster:GetAbsOrigin()
	local targetOrigin	= target:GetAbsOrigin()

	-- Calculate the distance
	local casterDir = casterOrigin - targetOrigin
	local distToAlly = casterDir:Length2D()
	casterDir = casterDir:Normalized()

	if distToAlly > latchDistance then

		-- Leap to the target
		distToAlly = distToAlly - latchSpeed * tickInterval
		distToAlly = math.max( distToAlly, latchDistance )	-- Clamp this value

		local pos = targetOrigin + casterDir * distToAlly
		pos = GetGroundPosition( pos, caster )

		caster:SetAbsOrigin( pos )

	end
end

--[[
	Author: Ractidous
	Date: 29.01.2015.
	Stop a sound.
]]
function StopSound( event )
	StopSoundEvent( event.sound_name, event.caster )
end
