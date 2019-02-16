
modifier_item_guardian_shell = class({})
--------------------------------------------------------------------------------

function modifier_item_guardian_shell:IsHidden() 
	return false
end

--------------------------------------------------------------------------------

function modifier_item_guardian_shell:IsPurgable()
	return false
end

function modifier_item_guardian_shell:GetTexture ()
    return "custom/guardian_shell"
end

----------------------------------------

function modifier_item_guardian_shell:OnCreated( kv )
    self.needupwawe = true
    if self:GetAbility() ~= nil then
        self.bonus_damage_for_wawe = self:GetAbility():GetSpecialValueFor( "bonus_mag_res_for_wawe" )
    end
	if IsServer() then
        self:OnWaweChange(_G.GAME_ROUND)
    end
end

----------------------------------------

function modifier_item_guardian_shell:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}

	return funcs
end

----------------------------------------

function modifier_item_guardian_shell:OnWaweChange( wawe )
	if IsServer() then
        self.wave = wawe
        local damag = 0
        if self:GetCaster().lvl_item_guardian_shell ~= nil then
            if self:GetCaster().lvl_item_guardian_shell >= 20 then
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * 20)
            else
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * self:GetCaster().lvl_item_guardian_shell)
            end
            if damag ~= self:GetStackCount() then
                self:SetStackCount(damag)
            end
        else
            self:GetCaster().lvl_item_guardian_shell = 1
        end
    end
end

function modifier_item_guardian_shell:GetModifierMagicalResistanceBonus( params )
	if IsServer() then
        local damag = 0
        if self:GetCaster().lvl_item_guardian_shell ~= nil then
            if self:GetCaster().lvl_item_guardian_shell >= 20 then
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * 20)
            else
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * self:GetCaster().lvl_item_guardian_shell)
            end
            if damag ~= self:GetStackCount() then
                self:SetStackCount(damag)
            end
        else
            self:GetCaster().lvl_item_guardian_shell = 1
        end
    end
    return self:GetStackCount()
end