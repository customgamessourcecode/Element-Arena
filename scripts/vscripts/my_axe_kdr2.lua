LinkLuaModifier( "modifier_my_axe_kdr2", "my_axe_kdr2", LUA_MODIFIER_MOTION_NONE )

function OnCreated(event)
	local caster = event.caster
	local ability = event.ability
    caster:AddNewModifier(caster, ability, "modifier_my_axe_kdr2", {})
end

function OnDestroy(event)
	local caster = event.caster
    caster:RemoveModifierByName("modifier_my_axe_kdr2")
end

modifier_my_axe_kdr2 = class({})
function modifier_my_axe_kdr2:IsHidden() return true end
function modifier_my_axe_kdr2:IsDebuff() return false end
function modifier_my_axe_kdr2:IsPurgable() return false end
function modifier_my_axe_kdr2:RemoveOnDeath() return false end

function modifier_my_axe_kdr2:GetCustomCooldownReductionStacking()
	return self:GetAbility():GetSpecialValueFor("cooldown")
end