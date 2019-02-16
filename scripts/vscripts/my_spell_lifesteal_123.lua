LinkLuaModifier( "modifier_my_spell_lifesteal", "my_spell_lifesteal_123", LUA_MODIFIER_MOTION_NONE )

function OnCreated(event)
	local caster = event.caster
	local ability = event.ability
    caster:AddNewModifier(caster, ability, "modifier_my_spell_lifesteal", {})
end

function OnDestroy(event)
	local caster = event.caster
    caster:RemoveModifierByName("modifier_my_spell_lifesteal")
end

modifier_my_spell_lifesteal = class({})
function modifier_my_spell_lifesteal:IsHidden() return true end
function modifier_my_spell_lifesteal:IsDebuff() return false end
function modifier_my_spell_lifesteal:IsPurgable() return false end
function modifier_my_spell_lifesteal:RemoveOnDeath() return false end

function modifier_my_spell_lifesteal:GetModifierSpellLifesteal()
	return self:GetAbility():GetSpecialValueFor("spell_lifesteal")
end