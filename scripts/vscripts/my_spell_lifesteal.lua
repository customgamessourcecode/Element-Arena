LinkLuaModifier( "modifier_my_octarine", "my_spell_lifesteal", LUA_MODIFIER_MOTION_NONE )

function OnCreated(event)
	local caster = event.caster
	local ability = event.ability
    caster:AddNewModifier(caster, ability, "modifier_my_octarine", {})
end

function OnDestroy(event)
	local caster = event.caster
    caster:RemoveModifierByName("modifier_my_octarine")
end

modifier_my_octarine = class({})
function modifier_my_octarine:IsHidden() return true end
function modifier_my_octarine:IsDebuff() return false end
function modifier_my_octarine:IsPurgable() return false end
function modifier_my_octarine:RemoveOnDeath() return false end

function modifier_my_octarine:GetModifierSpellLifesteal()
	return self:GetAbility():GetSpecialValueFor("creep_lifesteal")
end

function modifier_my_octarine:GetCustomCooldownReductionStacking()
	return self:GetAbility():GetSpecialValueFor("cooldown")
end