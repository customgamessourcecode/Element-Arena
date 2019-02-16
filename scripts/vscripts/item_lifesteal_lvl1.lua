LinkLuaModifier( "modifier_my_lifesteal_lvl1", "item_lifesteal_lvl1", LUA_MODIFIER_MOTION_NONE )

function OnCreated(event)
    DeepPrintTable(event)
	local target = event.target
	local ability = event.ability
    target:AddNewModifier(target, ability, "modifier_my_lifesteal_lvl1", {})
end

function OnDestroy(event)
	local target = event.target
    target:RemoveModifierByName("modifier_my_lifesteal_lvl1")
end

modifier_my_lifesteal_lvl1 = class({})
function modifier_my_lifesteal_lvl1:IsHidden() return true end
function modifier_my_lifesteal_lvl1:IsPurgable() return false end
function modifier_my_lifesteal_lvl1:IsDebuff() return false end

function modifier_my_lifesteal_lvl1:OnCreated()
    -- Ability properties
    self.ability = self:GetAbility()

    -- Ability specials
    self.lifesteal_pct = self.ability:GetSpecialValueFor("lifesteal_percent")
end

function modifier_my_lifesteal_lvl1:GetModifierLifesteal()
    return self.lifesteal_pct 
end