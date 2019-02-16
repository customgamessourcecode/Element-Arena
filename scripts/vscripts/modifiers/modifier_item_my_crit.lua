
modifier_item_my_crit = class({})

--------------------------------------------------------------------------------

function modifier_item_my_crit:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_my_crit:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_my_crit:OnCreated( kv )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.bonus_speed = self:GetAbility():GetSpecialValueFor( "speed" )
	self.bonus_hp = self:GetAbility():GetSpecialValueFor( "hp" )
	self.bonus_regen = self:GetAbility():GetSpecialValueFor( "regen" )
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_c" )
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor( "crit_m" )

	self.bIsCrit = false
end

--------------------------------------------------------------------------------

function modifier_item_my_crit:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_item_my_crit:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end

function modifier_item_my_crit:GetModifierMoveSpeedBonus_Constant( params )
	return self.bonus_speed
end

function modifier_item_my_crit:GetModifierHealthBonus( params )
	return self.bonus_hp
end

function modifier_item_my_crit:GetModifierConstantHealthRegen( params )
	return self.bonus_regen
end

--------------------------------------------------------------------------------

function modifier_item_my_crit:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() then
		local hTarget = params.target
		local hAttacker = params.attacker

		if hTarget and ( hTarget:IsBuilding() == false ) and ( hTarget:IsOther() == false ) and hAttacker and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
            local randint = RandomInt( 0, 100 )
			if randint < self.crit_chance then -- expose RollPseudoRandomPercentage?
				self.bIsCrit = true
				return self.crit_multiplier
			end
		end
	end

	return 0.0
end

--------------------------------------------------------------------------------

function modifier_item_my_crit:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil and self.bIsCrit then
				EmitSoundOn( "DOTA_Item.Daedelus.Crit", self:GetParent() )
				self.bIsCrit = false
			end
		end
	end

	return 0.0
end

--------------------------------------------------------------------------------

