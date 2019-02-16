my_new_disr = class ({})
----------------------------------------
LinkLuaModifier( "my_new_disr_mod", "modifiers/my_new_disr_mod", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function my_new_disr:GetIntrinsicModifierName()
	return "my_new_disr_mod"
end