LinkLuaModifier( "modifier_my_lifesteal", "item_lifesteal", LUA_MODIFIER_MOTION_NONE )

function OnCreated(event)
	local target = event.target
	local ability = event.ability
    target:AddNewModifier(target, ability, "modifier_my_lifesteal", {})
end

function OnDestroy(event)
	local target = event.target
    target:RemoveModifierByName("modifier_my_lifesteal")
end

modifier_my_lifesteal = class({})
function modifier_my_lifesteal:IsHidden() return true end
function modifier_my_lifesteal:IsPurgable() return false end
function modifier_my_lifesteal:IsDebuff() return false end

function modifier_my_lifesteal:OnCreated()
    -- Ability properties
    self.ability = self:GetAbility()

    -- Ability specials
    self.lifesteal_pct = self.ability:GetSpecialValueFor("lifesteal_percent")
end

function modifier_my_lifesteal:GetModifierLifesteal()
    return self.lifesteal_pct 
end