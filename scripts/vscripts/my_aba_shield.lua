
function Shield( event )
	-- Variables
	local caster = event.caster
    caster.ShieldRemaining = 1000
	local shield_size = 75 -- could be adjusted to model scale
    
	local RemovePositiveBuffs = false
	local RemoveDebuffs = true
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = true
	local RemoveExceptions = false
    caster:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
    
    if caster.ShieldParticle == nil then
        Timers:CreateTimer(0.01, function() 
            caster.ShieldParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
            ParticleManager:SetParticleControl(caster.ShieldParticle, 1, Vector(shield_size,0,shield_size))
            ParticleManager:SetParticleControl(caster.ShieldParticle, 2, Vector(shield_size,0,shield_size))
            ParticleManager:SetParticleControl(caster.ShieldParticle, 4, Vector(shield_size,0,shield_size))
            ParticleManager:SetParticleControl(caster.ShieldParticle, 5, Vector(shield_size,0,0))

            -- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
            ParticleManager:SetParticleControlEnt(caster.ShieldParticle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        end)
    end
end

function ShieldAbsorb( event )
	-- Variables
	local damage = event.DamageTaken
	if damage > 0 then
		local ability = event.ability
		local caster = event.caster

        -- If the damage is bigger than what the shield can absorb, heal a portion
        if damage > caster.ShieldRemaining then
            local newHealth = caster.OldHealth - damage + caster.ShieldRemaining
            caster:SetHealth(newHealth)
        else
            local newHealth = caster.OldHealth			
            caster:SetHealth(newHealth)
        end

        -- Reduce the shield remaining and remove
        caster.ShieldRemaining = caster.ShieldRemaining-damage
        if caster.ShieldRemaining <= 0 then
            caster.ShieldRemaining = nil
            caster:RemoveModifierByName("modifier_aba_shield_buff")
        end
	end
end

-- Destroys the particle when the modifier is destroyed. Also plays the sound
function EndShieldParticle( event )
	local caster = event.caster
    caster.ShieldRemaining = 0
	caster:EmitSound("Hero_Abaddon.AphoticShield.Destroy")
    ParticleManager:DestroyParticle(caster.ShieldParticle,false)
    caster.ShieldParticle = nil
end


-- Keeps track of the targets health
function ShieldHealth( event )
	local caster = event.caster
	caster.OldHealth = caster:GetHealth()
end