item_seal_5 = class({})
LinkLuaModifier( "mod_seal_5", "modifiers/mod_seal_5", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function item_seal_5:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "DOTA_Item.GhostScepter.Activate", self:GetCaster() )

		local kv =
		{
			duration = -1,
			extra_spell_damage_percent = self:GetSpecialValueFor( "extra_spell_damage_percent" ),
		}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ghost_state", kv )
	end
end

--------------------------------------------------------------------------------

function item_seal_5:OnChannelFinish( bInterrupted )
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_ghost_state" )
	end
end

function item_seal_5:GetIntrinsicModifierName()
	return "mod_seal_5"
end