modifier_item_wand_of_the_brine = class({})
--------------------------------------------------------------------------------

function modifier_item_wand_of_the_brine:IsHidden() 
	return false
end

--------------------------------------------------------------------------------

function modifier_item_wand_of_the_brine:IsPurgable()
	return false
end

function modifier_item_wand_of_the_brine:GetTexture ()
    return "custom/wand_of_the_brine"
end

----------------------------------------

function modifier_item_wand_of_the_brine:OnCreated( kv )
    self.needupwawe = true
    if self:GetAbility() ~= nil then
        self.bonus_damage_for_wawe = self:GetAbility():GetSpecialValueFor( "bonus_spell_amp_for_wawe" )
    end
	if IsServer() then
        self:OnWaweChange(_G.GAME_ROUND)
    end
end

----------------------------------------

function modifier_item_wand_of_the_brine:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end

----------------------------------------

function modifier_item_wand_of_the_brine:OnWaweChange( wawe )
	if IsServer() then
        self.wave = wawe
        local damag = 0
        if self:GetCaster().lvl_item_wand_of_the_brine ~= nil then
            if self:GetCaster().lvl_item_wand_of_the_brine >= 20 then
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * 20)
            else
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * self:GetCaster().lvl_item_wand_of_the_brine)
            end
            if damag ~= self:GetStackCount() then
                self:SetStackCount(damag)
            end
        else
            self:GetCaster().lvl_item_wand_of_the_brine = 1
        end
    end
end

function modifier_item_wand_of_the_brine:GetModifierSpellAmplify_Percentage( params )
	if IsServer() then
        local damag = 0
        if self:GetCaster().lvl_item_wand_of_the_brine ~= nil then
            if self:GetCaster().lvl_item_wand_of_the_brine >= 20 then
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * 20)
            else
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * self:GetCaster().lvl_item_wand_of_the_brine)
            end
            if damag ~= self:GetStackCount() then
                self:SetStackCount(damag)
            end
        else
            self:GetCaster().lvl_item_wand_of_the_brine = 1
        end
    end
    return self:GetStackCount()
end