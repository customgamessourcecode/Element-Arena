
item_my_crit = class({})
LinkLuaModifier( "modifier_item_my_crit", "modifiers/modifier_item_my_crit", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_my_crit:GetIntrinsicModifierName()
	return "modifier_item_my_crit"
end