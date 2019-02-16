if item_ice_aluneth == nil then item_ice_aluneth = class({}) end
LinkLuaModifier( "modifier_item_ice_aluneth", "items/item_ice_aluneth.lua", LUA_MODIFIER_MOTION_NONE )

--function item_ice_aluneth:GetAbilityTextureName()
--	return "item_kaya"
--end

function item_ice_aluneth:GetIntrinsicModifierName()
	return "modifier_item_ice_aluneth"
end

-----------------------------------------------------------------------------------------------------------
--	kaya passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_ice_aluneth == nil then modifier_item_ice_aluneth = class({}) end
function modifier_item_ice_aluneth:IsHidden() return true end
function modifier_item_ice_aluneth:IsDebuff() return false end
function modifier_item_ice_aluneth:IsPurgable() return false end
function modifier_item_ice_aluneth:IsPermanent() return true end

-- Declare modifier events/properties
function modifier_item_ice_aluneth:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
	return funcs
end

function modifier_item_ice_aluneth:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_ice_aluneth:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_ice_aluneth:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_ice_aluneth:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("spell_amp")
end

function modifier_item_ice_aluneth:GetModifierPercentageManacost()
	return self:GetAbility():GetSpecialValueFor("bonus_cdr")
end

function modifier_item_ice_aluneth:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("mana_regen")
end

function modifier_item_ice_aluneth:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function modifier_item_ice_aluneth:GetModifierCastRangeBonusStacking()
	return self:GetAbility():GetSpecialValueFor("cast_range")
end

function modifier_item_ice_aluneth:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("regen")
end