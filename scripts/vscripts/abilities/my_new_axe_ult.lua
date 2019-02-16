my_new_axe_ult = class({})
LinkLuaModifier( "modifier_axe_ult", "modifiers/modifier_axe_ult", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_ult_timer", "modifiers/modifier_axe_ult", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function my_new_axe_ult:OnSpellStart()
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_axe_ult", { duration = self:GetSpecialValueFor( "duration" ) } )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_axe_ult_timer", { duration = 3 } )
end

--------------------------------------------------------------------------------
