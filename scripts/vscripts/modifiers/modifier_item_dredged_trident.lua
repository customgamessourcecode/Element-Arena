
modifier_item_dredged_trident = class({})
--------------------------------------------------------------------------------

function modifier_item_dredged_trident:IsHidden() 
	return false
end

--------------------------------------------------------------------------------

function modifier_item_dredged_trident:IsPurgable()
	return false
end

function modifier_item_dredged_trident:GetTexture ()
    return "custom/dredged_trident"
end

----------------------------------------

function modifier_item_dredged_trident:OnCreated( kv )
    self.needupwawe = true
    if self:GetAbility() ~= nil then
        self.bonus_damage_for_wawe = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed_for_wawe" )
    end
	if IsServer() then
        self:OnWaweChange(_G.GAME_ROUND)
    end
end

----------------------------------------

function modifier_item_dredged_trident:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

----------------------------------------

function modifier_item_dredged_trident:OnWaweChange( wawe )
	if IsServer() then
        self.wave = wawe
        local damag = 0
        if self:GetCaster().lvl_item_dredged_trident ~= nil then
            if self:GetCaster().lvl_item_dredged_trident >= 20 then
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * 20)
            else
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * self:GetCaster().lvl_item_dredged_trident)
            end
            if damag ~= self:GetStackCount() then
                self:SetStackCount(damag)
            end
        else
            self:GetCaster().lvl_item_dredged_trident = 1
        end
    end
end

function modifier_item_dredged_trident:GetModifierAttackSpeedBonus_Constant( params )
	if IsServer() then
        local damag = 0
        if self:GetCaster().lvl_item_dredged_trident ~= nil then
            if self:GetCaster().lvl_item_dredged_trident >= 20 then
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * 20)
            else
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * self:GetCaster().lvl_item_dredged_trident)
            end
            if damag ~= self:GetStackCount() then
                self:SetStackCount(damag)
            end
        else
            self:GetCaster().lvl_item_dredged_trident = 1
        end
    end
    return self:GetStackCount()
end