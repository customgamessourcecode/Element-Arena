function Phantasm( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local unit_name = caster:GetUnitName()
	local duration = ability:GetLevelSpecialValueFor( "duration", ability_level )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "illusion_damage_outgoing", ability_level )
	local incomingDamage = ability:GetLevelSpecialValueFor( "illusion_damage_incoming", ability_level )
	local casterOrigin = caster:GetAbsOrigin()
	local casterAngles = caster:GetAngles()

	-- Stop any actions of the caster otherwise its obvious which unit is real
	caster:Stop()

	-- Initialize the illusion table to keep track of the units created by the spell
	if not caster.phantasm_illusions then
		caster.phantasm_illusions = {}
	end

	-- Kill the old images
	for k,v in pairs(caster.phantasm_illusions) do
		if v and IsValidEntity(v) then 
			v:ForceKill(false)
		end
	end

	-- Start a clean illusion table
	caster.phantasm_illusions = {}
    
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    
	-- Spawn illusions
	for i=1, #enemies do

		local origin = enemies[i]:GetAbsOrigin()

		-- handle_UnitOwner needs to be nil, else it will crash the game.
		local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())

		-- Set the skill points to 0 and learn the skills of the caster
		for abilitySlot=0,15 do
			local ability = caster:GetAbilityByIndex(abilitySlot)
			if ability ~= nil then 
				local abilityLevel = ability:GetLevel()
				local abilityName = ability:GetAbilityName()
				local illusionAbility = illusion:FindAbilityByName(abilityName)
				illusionAbility:SetLevel(abilityLevel)
			end
		end
        
		-- Set the unit as an illusion
		-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
		illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
		
		-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
		illusion:MakeIllusion()
		-- Set the illusion hp to be the same as the caster
		--illusion:SetHealth(caster:GetHealth())
		-- Add the illusion created to a table within the caster handle, to remove the illusions on the next cast if necessary
		table.insert(caster.phantasm_illusions, illusion)
        
        local order =
        {
            UnitIndex = illusion:entindex(),
            OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
            TargetIndex = enemies[i]:entindex(),
            Queue = true
        }

        ExecuteOrderFromTable(order)
	end
end

function HideCaster( event )
	event.caster:AddNoDraw()
end

function ShowCaster( event )
	event.caster:RemoveNoDraw()
end