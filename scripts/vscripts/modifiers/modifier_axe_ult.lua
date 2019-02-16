modifier_axe_ult = class({})

function modifier_axe_ult:OnCreated( kv )
    self.bonus_armor = self:GetAbility():GetLevelSpecialValueFor( "bonus_armor",self:GetAbility():GetLevel() - 1 )
    self.bonus_str = self:GetAbility():GetLevelSpecialValueFor( "bonus_str",self:GetAbility():GetLevel() - 1 )
end

function modifier_axe_ult:IsPurgable()
	return false
end

function modifier_axe_ult:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}

	return funcs
end

function modifier_axe_ult:GetModifierPhysicalArmorBonus( params )
	--if IsServer() then
        local damag = self.bonus_armor * self:GetStackCount()
        return damag
    --end
end

function modifier_axe_ult:GetModifierBonusStats_Strength( params )
	--if IsServer() then
        local damag2 = self.bonus_str * self:GetStackCount()
        return damag2
    --end
end


modifier_axe_ult_timer = class({})

function modifier_axe_ult_timer:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_axe_ult_timer:IsHidden() 
	return true
end

function modifier_axe_ult_timer:IsPurgable()
	return false
end

function modifier_axe_ult_timer:OnWaweChange( wawe )
    self:SetStackCount(wawe)
end

function modifier_axe_ult_timer:OnTakeDamage( params )
	if IsServer() then
        if params.unit == self:GetParent() then
            self:GetCaster():SetModifierStackCount("modifier_axe_ult",self:GetCaster(),self:GetCaster():GetModifierStackCount("modifier_axe_ult",self:GetCaster()) + params.damage)
        end
	end

	return 0
end