LinkLuaModifier( "modifier_item_lifesteal_mewup", "item_lifesteal_mewup", LUA_MODIFIER_MOTION_NONE )

function OnCreated(event)
    DeepPrintTable(event)
	local target = event.target
	local ability = event.ability
    target:AddNewModifier(target, ability, "modifier_item_lifesteal_mewup", {})
end

function OnDestroy(event)
	local target = event.target
    target:RemoveModifierByName("modifier_item_lifesteal_mewup")
end

modifier_item_lifesteal_mewup = class({})
function modifier_item_lifesteal_mewup:IsHidden() return true end
function modifier_item_lifesteal_mewup:IsPurgable() return false end
function modifier_item_lifesteal_mewup:IsDebuff() return false end

function modifier_item_lifesteal_mewup:OnCreated()
    -- Ability properties
    self.ability = self:GetAbility()

    -- Ability specials
    self.lifesteal_pct = self.ability:GetSpecialValueFor("lifesteal_percent")
end

function modifier_item_lifesteal_mewup:GetModifierLifesteal()
    return self.lifesteal_pct 
end