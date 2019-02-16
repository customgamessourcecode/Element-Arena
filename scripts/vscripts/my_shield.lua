--[[
	Author: Noya
	Date: 9.1.2015.
	Absorbs damage up to the max absorb, substracting from the shield until removed.
]]
ShieldRemaining = 0
function Shield( event )
	-- Variables
	local target = event.target
	local max_damage_absorb = event.ability:GetLevelSpecialValueFor("damage_absorb", event.ability:GetLevel() - 1 )
	local shield_size = 75 -- could be adjusted to model scale
    
	-- Reset the shield
	ShieldRemaining = max_damage_absorb
end

function ShieldAbsorb( event )
	-- Variables
	local damage = event.DamageTaken
	if damage > 0 then
		local unit = event.unit
		local ability = event.ability
		local caster = event.caster

		-- Check if the unit has the borrowed time modifier
		if not unit:HasModifier("modifier_borrowed_time") then
			-- If the damage is bigger than what the shield can absorb, heal a portion
			if damage > ShieldRemaining then
				local newHealth = caster.OldHealth - damage + ShieldRemaining
				unit:SetHealth(newHealth)
			else
				local newHealth = caster.OldHealth			
				unit:SetHealth(newHealth)
			end

			-- Reduce the shield remaining and remove
			ShieldRemaining = ShieldRemaining-damage
			if ShieldRemaining <= 0 then
				ShieldRemaining = nil
				unit:RemoveModifierByName("modifier_item_energy_earth_water_shield")
			end
		end
	end
end

-- Destroys the particle when the modifier is destroyed. Also plays the sound
function EndShieldParticle( event )
    ShieldRemaining = 0
end


-- Keeps track of the targets health
function ShieldHealth( event )
	local caster = event.caster

	caster.OldHealth = caster:GetHealth()
end