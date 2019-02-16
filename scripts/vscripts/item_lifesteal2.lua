LinkLuaModifier( "modifier_my_lifesteal2", "item_lifesteal2", LUA_MODIFIER_MOTION_NONE )

function OnCreated(event)
	local caster = event.caster
	local ability = event.ability
    caster:AddNewModifier(caster, ability, "modifier_my_lifesteal2", {})
end

function OnDestroy(event)
	local caster = event.caster
    caster:RemoveModifierByName("modifier_my_lifesteal2")
end

modifier_my_lifesteal2 = class({})
function modifier_my_lifesteal2:IsHidden() return true end
function modifier_my_lifesteal2:IsPurgable() return false end
function modifier_my_lifesteal2:IsDebuff() return false end

function modifier_my_lifesteal2:OnCreated()
    -- Ability properties
    self.ability = self:GetAbility()

    -- Ability specials
    self.lifesteal_pct = self.ability:GetSpecialValueFor("lifesteal_percent2")
end

function modifier_my_lifesteal2:GetModifierLifesteal()
    return self.lifesteal_pct 
end