LinkLuaModifier( "modifier_my_octarine_2", "my_spell_lifesteal_2", LUA_MODIFIER_MOTION_NONE )

function OnCreated(event)
	local caster = event.caster
	local ability = event.ability
    caster:AddNewModifier(caster, ability, "modifier_my_octarine_2", {})
end

function OnDestroy(event)
	local caster = event.caster
    caster:RemoveModifierByName("modifier_my_octarine_2")
end

modifier_my_octarine_2 = class({})
function modifier_my_octarine_2:IsHidden() return true end
function modifier_my_octarine_2:IsDebuff() return false end
function modifier_my_octarine_2:IsPurgable() return false end
function modifier_my_octarine_2:RemoveOnDeath() return false end

function modifier_my_octarine_2:GetModifierSpellLifesteal()
	return self:GetAbility():GetSpecialValueFor("creep_lifesteal")
end

function modifier_my_octarine_2:GetCustomCooldownReductionStacking()
	return self:GetAbility():GetSpecialValueFor("cooldown")
end