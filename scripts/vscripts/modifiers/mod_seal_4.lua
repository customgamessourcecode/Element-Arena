LinkLuaModifier( "modifier_my_relic_armor", "modifiers/mod_seal_4", LUA_MODIFIER_MOTION_NONE )
mod_seal_4 = class({})
--------------------------------------------------------------------------------
col_ud = 0

function mod_seal_4:GetEffectName()
	return "particles/my_doom_bringer_doom_ring.vpcf"
end

function mod_seal_4:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function mod_seal_4:IsPurgable()
	return false
end

----------------------------------------

function mod_seal_4:OnCreated( kv )
    self.needupwawe = true
    self.bonus_damage_for_wawe = self:GetAbility():GetSpecialValueFor( "bonus_damage_for_wawe" )
    self.bonus_armor_for_wawe = self:GetAbility():GetSpecialValueFor( "bonus_armor_for_wawe" )
    self.bonus_mag_res_for_wawe = self:GetAbility():GetSpecialValueFor( "bonus_mag_res_for_wawe" )
    self.bonus_attack_speed_for_wawe = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed_for_wawe" )
	if IsServer() then
        self:SetStackCount(self:GetCaster():FindModifierByName("modifier_my_pick_gold"):GetStackCount())
    end
end

----------------------------------------

function mod_seal_4:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

----------------------------------------

function mod_seal_4:OnWaweChange( wawe )
    self:SetStackCount(wawe)
end

function mod_seal_4:GetModifierPreAttack_BonusDamage( params )
	--if IsServer() then
        local damag = self.bonus_damage_for_wawe * self:GetStackCount()
        return damag
    --end
end

function mod_seal_4:GetModifierPhysicalArmorBonus( params )
	--if IsServer() then
        local damag2 = self.bonus_armor_for_wawe * self:GetStackCount()
        return damag2
    --end
end

function mod_seal_4:GetModifierMagicalResistanceBonus( params )
	--if IsServer() then
        local damag3 = self.bonus_mag_res_for_wawe * self:GetStackCount()
        return damag3
    --end
end

function mod_seal_4:GetModifierAttackSpeedBonus_Constant( params )
	--if IsServer() then
        local damag4 = self.bonus_attack_speed_for_wawe * self:GetStackCount()
        return damag4
    --end
end

function mod_seal_4:OnAbilityExecuted( params )
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

function mod_seal_4:OnAttackLanded( params )
	if IsServer() then
        if self:GetCaster() == params.attacker then
            col_ud = col_ud + 1
            if col_ud >= 3 then
                local unts = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
                if #unts > 0 then
                    local rand = math.random(1,#unts)
                    local lightningBolt = ParticleManager:CreateParticle("particles/my_zuus_arc_lightning_.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
                    ParticleManager:SetParticleControl(lightningBolt,0,Vector(self:GetCaster():GetAbsOrigin().x,self:GetCaster():GetAbsOrigin().y,self:GetCaster():GetAbsOrigin().z + self:GetCaster():GetBoundingMaxs().z ))   
                    ParticleManager:SetParticleControl(lightningBolt,1,Vector(unts[rand]:GetAbsOrigin().x,unts[rand]:GetAbsOrigin().y,unts[rand]:GetAbsOrigin().z + unts[rand]:GetBoundingMaxs().z ))
                    local damageTable = {
                        victim = unts[rand],
                        attacker = self:GetCaster(),
                        damage = self:GetCaster():GetAttackDamage() * 1.5,
                        damage_type = DAMAGE_TYPE_MAGICAL,
                    }
                    ApplyDamage(damageTable)
                end
                col_ud = 0
            end
        end
    end
end

function mod_seal_4:OnTakeDamage( params )
	if IsServer() then
        if params.unit == self:GetParent() then
            if self.taken_damage == nil then
                self.taken_damage = 0
            end
            self.taken_damage = self.taken_damage + params.damage
            local maax = self:GetParent():GetMaxHealth()/10
            if self.taken_damage >= maax and ( not self:GetParent():IsIllusion() ) then
                self.taken_damage = self.taken_damage - maax
                local heroes = HeroList:GetAllHeroes()
                local list = {}
                for i=1, #heroes do
                    if heroes[i]:IsAlive() then
                        table.insert( list, heroes[i] )
                    end
                end
                list[RandomInt( 1, #list )]:AddNewModifier(self:GetCaster(), nil, "modifier_my_relic_armor", {duration = 5})
            end
        end
	end

	return 0
end

modifier_my_relic_armor = class({})
function modifier_my_relic_armor:IsHidden() return false end
function modifier_my_relic_armor:IsDebuff() return false end
function modifier_my_relic_armor:IsPurgable() return false end
function modifier_my_relic_armor:RemoveOnDeath() return false end
function modifier_my_relic_armor:GetEffectName()
	return "particles/units/heroes/hero_dazzle/dazzle_armor_friend_shield.vpcf"
end
function modifier_my_relic_armor:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_my_relic_armor:GetTexture ()
    return "custom/glimmerdark_shield"
end

function modifier_my_relic_armor:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_my_relic_armor:GetModifierPhysicalArmorBonus()
	return 5
end