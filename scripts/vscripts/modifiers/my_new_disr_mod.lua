my_new_disr_mod = class({})

function my_new_disr_mod:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function my_new_disr_mod:IsPurgable()
	return false
end

function my_new_disr_mod:OnCreated( kv )
    self.units = {nil,nil,nil,nil,nil}
end

----------------------------------------

function my_new_disr_mod:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end

function my_new_disr_mod:OnAbilityExecuted( params )
	if IsServer() then
        if params.unit == self:GetCaster() then
            if params.ability:GetAbilityName() == "shadow_demon_shadow_poison" then
                self.damage = self:GetAbility():GetLevelSpecialValueFor( "damage",self:GetAbility():GetLevel() - 1 )
                self.health = self:GetAbility():GetLevelSpecialValueFor( "health",self:GetAbility():GetLevel() - 1 )
                self.max_units = self:GetAbility():GetLevelSpecialValueFor( "max_units",self:GetAbility():GetLevel() - 1 )
                local unit = CreateUnitByName( "npc_my_dalon", self:GetCaster():GetAbsOrigin() + RandomVector( RandomFloat( 100, 200 ) ), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
                unit:SetControllableByPlayer(self:GetCaster():GetPlayerID(),true)
                unit:SetBaseDamageMax(self.damage)
                unit:SetBaseDamageMin(self.damage)
                unit:SetBaseMaxHealth(self.health)
                unit:SetMaxHealth(self.health)
                unit:SetHealth(self.health)
                if self.units[self.max_units] ~= nil then
                    if not self.units[self.max_units]:IsNull() then
                        if self.units[self.max_units]:IsAlive() then
                            self.units[self.max_units]:ForceKill(false)
                        end
                    end
                end
                for i=1,self.max_units-1 do
                    if self.units[self.max_units-i] ~= nil then
                        if not self.units[self.max_units-i]:IsNull() then
                            if self.units[self.max_units-i]:IsAlive() then
                                self.units[self.max_units+1-i] = self.units[self.max_units-i]
                            else
                                self.units[self.max_units+1-i] = nil
                            end
                        else
                            self.units[self.max_units+1-i] = nil
                        end
                    end
                end
                self.units[1] = unit
            end
        end
    end
	return 0
end