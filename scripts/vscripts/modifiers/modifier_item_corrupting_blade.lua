
modifier_item_corrupting_blade = class({})
--------------------------------------------------------------------------------
col_ud = 0
function modifier_item_corrupting_blade:IsHidden() 
	return false
end

--------------------------------------------------------------------------------

function modifier_item_corrupting_blade:IsPurgable()
	return false
end

function modifier_item_corrupting_blade:GetTexture ()
    return "custom/corrupting_blade"
end

----------------------------------------

function modifier_item_corrupting_blade:OnCreated( kv )
        self.needupwawe = true
        if self:GetAbility() ~= nil then
            self.bonus_damage_for_wawe = self:GetAbility():GetSpecialValueFor( "bonus_damage_for_wawe" )
        end
	if IsServer() then
        self:OnWaweChange(_G.GAME_ROUND)
    end
end

----------------------------------------

function modifier_item_corrupting_blade:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

----------------------------------------

function modifier_item_corrupting_blade:OnWaweChange( wawe )
	if IsServer() then
        self.wave = wawe
        local damag = 0
        if self:GetCaster().lvl_item_corrupting_blade ~= nil then
            if self:GetCaster().lvl_item_corrupting_blade >= 20 then
                damag = math.ceil(self.bonus_damage_for_wawe * self.wave * 20)
            else
                damag = math.ceil(self.bonus_damage_for_wawe * self.wave * self:GetCaster().lvl_item_corrupting_blade)
            end
            if damag ~= self:GetStackCount() then
                self:SetStackCount(damag)
            end
        else
            self:GetCaster().lvl_item_corrupting_blade = 1
        end
    end
end

function modifier_item_corrupting_blade:GetModifierPreAttack_BonusDamage( params )
	if IsServer() then
        local damag = 0
        if self:GetCaster().lvl_item_corrupting_blade ~= nil then
            if self:GetCaster().lvl_item_corrupting_blade >= 20 then
                damag = math.ceil(self.bonus_damage_for_wawe * self.wave * 20)
            else
                damag = math.ceil(self.bonus_damage_for_wawe * self.wave * self:GetCaster().lvl_item_corrupting_blade)
            end
            if damag ~= self:GetStackCount() then
                self:SetStackCount(damag)
            end
        else
            self:GetCaster().lvl_item_corrupting_blade = 1
        end
    end
    return self:GetStackCount()
end

function modifier_item_corrupting_blade:OnAttackLanded( params )
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