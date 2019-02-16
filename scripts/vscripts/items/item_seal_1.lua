item_seal_1 = class({})
LinkLuaModifier( "mod_seal_1", "modifiers/mod_seal_1", LUA_MODIFIER_MOTION_NONE )

function item_seal_1:OnSpellStart()
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

function item_seal_1:OnChannelFinish( bInterrupted )
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_ghost_state" )
	end
end
--------------------------------------------------------------------------------

function item_seal_1:GetIntrinsicModifierName()
	return "mod_seal_1"
end