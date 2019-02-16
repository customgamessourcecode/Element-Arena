LinkLuaModifier( "my_new_shield_mod", "my_new_shield", LUA_MODIFIER_MOTION_NONE )

function OnCreated(event)
	local caster = event.caster
	local ability = event.ability
    caster:AddNewModifier(caster, ability, "my_new_shield_mod", {})
end

function OnDestroy(event)
	local caster = event.caster
    caster:RemoveModifierByName("my_new_shield_mod")
end

my_new_shield_mod = class({})
function my_new_shield_mod:IsHidden() return true end
function my_new_shield_mod:IsDebuff() return false end
function my_new_shield_mod:IsPurgable() return false end
function my_new_shield_mod:RemoveOnDeath() return false end

function my_new_shield_mod:GetCustomDamageBlock()
	return self:GetAbility():GetSpecialValueFor("block")
end