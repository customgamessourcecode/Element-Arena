function Attack( event )
	local target = event.target
	local caster = event.caster
	local ability	= event.ability
    if not caster:IsIllusion() then
        if caster.att_target ~= nil then
            if not caster.att_target:IsNull() then
                if caster.att_target:IsAlive() then
                    caster.att_target:RemoveModifierByName("modifier_item_void_fire_damage")
                end
            end
        end
        ability:ApplyDataDrivenModifier( caster, target, "modifier_item_void_fire_damage", {} )
        caster.att_target = target
    end
    
    if ability:IsCooldownReady() and caster:GetAttackCapability() == 1 then
        ability:ApplyDataDrivenModifier( caster, caster, "modifier_item_kingsbane_attack_speed", {} )
        ability:ApplyDataDrivenModifier( caster, target, "modifier_item_kingsbane_slow", {} )
        ability:StartCooldown(5)
    end
end

-- Keeps track of the targets health
function OnTakeDamage( event )
	local damage = event.Damage
	local caster = event.caster
	local ability	= event.ability
    
    if not caster:IsIllusion() then
    if caster:GetAttackCapability() == 1 then
    if caster.att_target ~= nil then
    if caster.att_target ~= caster then
    if damage * (event.Perc / 100) > 1 then
	local nFXIndex = ParticleManager:CreateParticle( "particles/my_wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN, caster.att_target )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetOrigin(), true )
	local damageTable = {
	victim = caster.att_target,
	attacker = caster,
	damage = damage * (event.Perc / 100),
	damage_type = DAMAGE_TYPE_PURE,
	damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
	ability = ability --Optional.
    }
    ApplyDamage(damageTable)
    end
    end
    end
    end
    end
end