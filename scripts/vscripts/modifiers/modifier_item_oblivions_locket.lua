
modifier_item_oblivions_locket = class({})
--------------------------------------------------------------------------------

function modifier_item_oblivions_locket:IsHidden() 
	return false
end

--------------------------------------------------------------------------------

function modifier_item_oblivions_locket:IsPurgable()
	return false
end

function modifier_item_oblivions_locket:GetTexture ()
    return "custom/oblivions_locket"
end

----------------------------------------

function modifier_item_oblivions_locket:OnCreated( kv )
    self.needupwawe = true
    if self:GetAbility() ~= nil then
        self.bonus_damage_for_wawe = self:GetAbility():GetSpecialValueFor( "bonus_all_stats_for_wawe" )
    end
	if IsServer() then
        self:OnWaweChange(_G.GAME_ROUND)
    end
end

----------------------------------------

function modifier_item_oblivions_locket:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}

	return funcs
end

----------------------------------------

function modifier_item_oblivions_locket:OnWaweChange( wawe )
	if IsServer() then
        self.wave = wawe
        local damag = 0
        if self:GetCaster().lvl_item_oblivions_locket ~= nil then
            if self:GetCaster().lvl_item_oblivions_locket >= 20 then
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * 20)
            else
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * self:GetCaster().lvl_item_oblivions_locket)
            end
            if damag ~= self:GetStackCount() then
                self:SetStackCount(damag)
            end
        else
            self:GetCaster().lvl_item_oblivions_locket = 1
        end
    end
end

function modifier_item_oblivions_locket:GetModifierBonusStats_Strength( params )
	if IsServer() then
        local damag = 0
        if self:GetCaster().lvl_item_oblivions_locket ~= nil then
            if self:GetCaster().lvl_item_oblivions_locket >= 20 then
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * 20)
            else
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * self:GetCaster().lvl_item_oblivions_locket)
            end
            if damag ~= self:GetStackCount() then
                self:SetStackCount(damag)
            end
        else
            self:GetCaster().lvl_item_oblivions_locket = 1
        end
    end
    return self:GetStackCount()
end

function modifier_item_oblivions_locket:GetModifierBonusStats_Agility( params )
	if IsServer() then
        local damag = 0
        if self:GetCaster().lvl_item_oblivions_locket ~= nil then
            if self:GetCaster().lvl_item_oblivions_locket >= 20 then
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * 20)
            else
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * self:GetCaster().lvl_item_oblivions_locket)
            end
            if damag ~= self:GetStackCount() then
                self:SetStackCount(damag)
            end
        else
            self:GetCaster().lvl_item_oblivions_locket = 1
        end
    end
    return self:GetStackCount()
end

function modifier_item_oblivions_locket:GetModifierBonusStats_Intellect( params )
	if IsServer() then
        local damag = 0
        if self:GetCaster().lvl_item_oblivions_locket ~= nil then
            if self:GetCaster().lvl_item_oblivions_locket >= 20 then
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * 20)
            else
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * self:GetCaster().lvl_item_oblivions_locket)
            end
            if damag ~= self:GetStackCount() then
                self:SetStackCount(damag)
            end
        else
            self:GetCaster().lvl_item_oblivions_locket = 1
        end
    end
    return self:GetStackCount()
end