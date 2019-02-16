LinkLuaModifier( "modifier_my_axe_kdr3", "my_axe_kdr3", LUA_MODIFIER_MOTION_NONE )

function OnCreated(event)
	local caster = event.caster
	local ability = event.ability
    caster:AddNewModifier(caster, ability, "modifier_my_axe_kdr3", {})
end

function OnDestroy(event)
	local caster = event.caster
    caster:RemoveModifierByName("modifier_my_axe_kdr3")
end

modifier_my_axe_kdr3 = class({})
function modifier_my_axe_kdr3:IsHidden() return true end
function modifier_my_axe_kdr3:IsDebuff() return false end
function modifier_my_axe_kdr3:IsPurgable() return false end
function modifier_my_axe_kdr3:RemoveOnDeath() return false end

function modifier_my_axe_kdr3:GetCustomCooldownReductionStacking()
	return self:GetAbility():GetSpecialValueFor("cooldown")
end