LinkLuaModifier( "modifier_my_axe_kdr1", "my_axe_kdr1", LUA_MODIFIER_MOTION_NONE )

function OnCreated(event)
	local caster = event.caster
	local ability = event.ability
    caster:AddNewModifier(caster, ability, "modifier_my_axe_kdr1", {})
end

function OnDestroy(event)
	local caster = event.caster
    caster:RemoveModifierByName("modifier_my_axe_kdr1")
end

modifier_my_axe_kdr1 = class({})
function modifier_my_axe_kdr1:IsHidden() return true end
function modifier_my_axe_kdr1:IsDebuff() return false end
function modifier_my_axe_kdr1:IsPurgable() return false end
function modifier_my_axe_kdr1:RemoveOnDeath() return false end

function modifier_my_axe_kdr1:GetCustomCooldownReductionStacking()
	return self:GetAbility():GetSpecialValueFor("cooldown")
end