modifier_item_ambient_sorcery = class({})
--------------------------------------------------------------------------------

function modifier_item_ambient_sorcery:IsHidden() 
	return false
end

--------------------------------------------------------------------------------

function modifier_item_ambient_sorcery:IsPurgable()
	return false
end

function modifier_item_ambient_sorcery:GetTexture ()
    return "custom/ambient_sorcery"
end

----------------------------------------

function modifier_item_ambient_sorcery:OnCreated( kv )
    self.needupwawe = true
    if self:GetAbility() ~= nil then
        self.bonus_damage_for_wawe = self:GetAbility():GetSpecialValueFor( "bonus_mana_cst_for_wawe" )
    end
	if IsServer() then
        self:OnWaweChange(_G.GAME_ROUND)
    end
end

----------------------------------------

function modifier_item_ambient_sorcery:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}

	return funcs
end

----------------------------------------

function modifier_item_ambient_sorcery:OnWaweChange( wawe )
	if IsServer() then
        self.wave = wawe
        local damag = 0
        if self:GetCaster().lvl_item_ambient_sorcery ~= nil then
            if self:GetCaster().lvl_item_ambient_sorcery >= 20 then
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * 20)
            else
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * self:GetCaster().lvl_item_ambient_sorcery)
            end
            if damag ~= self:GetStackCount() then
                self:SetStackCount(damag)
            end
        else
            self:GetCaster().lvl_item_ambient_sorcery = 1
        end
    end
end

function modifier_item_ambient_sorcery:GetModifierSpellLifesteal( params )
	if IsServer() then
        local damag = 0
        if self:GetCaster().lvl_item_ambient_sorcery ~= nil then
            if self:GetCaster().lvl_item_ambient_sorcery >= 20 then
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * 20)
            else
                damag = math.floor(self.bonus_damage_for_wawe * self.wave * self:GetCaster().lvl_item_ambient_sorcery)
            end
            if damag ~= self:GetStackCount() then
                self:SetStackCount(damag)
            end
        else
            self:GetCaster().lvl_item_ambient_sorcery = 1
        end
    end
    return self:GetStackCount()
end

function modifier_item_ambient_sorcery:OnAbilityExecuted( params )
	if IsServer() then
        if params.unit == self:GetCaster() then
            if not params.ability:IsItem() and not params.ability:IsToggle() then
                for i=0, 6 do
                    local abil = self:GetCaster():GetAbilityByIndex(i)
                    local coold = abil:GetCooldownTimeRemaining()
                    if coold > 0 then
                        if coold - 1 > 0 then
                            abil:EndCooldown()
                            abil:StartCooldown(coold-1)
                        else
                            abil:EndCooldown()
                        end
                    end
                end
            end
        end
    end
	return 0
end