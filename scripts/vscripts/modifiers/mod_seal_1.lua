LinkLuaModifier( "modifier_my_relic_armor", "modifiers/mod_seal_1", LUA_MODIFIER_MOTION_NONE )

mod_seal_1 = class({})
--------------------------------------------------------------------------------

--function mod_seal_1:GetEffectName()
--	return "particles/my_doom_bringer_doom_ring.vpcf"
--end

function mod_seal_1:IsHidden() 
	return false
end

function mod_seal_1:GetTexture()
    return self.ico
end

--------------------------------------------------------------------------------

function mod_seal_1:IsPurgable()
	return false
end

----------------------------------------
function mod_seal_1:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}

	return funcs
end
----------------------------------------

function mod_seal_1:OnCreated( kv )
    self.needupwawe = true
    self.col_ud = 0
    self.bonus_mana_cst_for_wawe = self:GetAbility():GetSpecialValueFor( "bonus_mana_cst_for_wawe" )
    self.bonus_damage_for_wawe = self:GetAbility():GetSpecialValueFor( "bonus_damage_for_wawe" )
    self.bonus_attack_speed_for_wawe = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed_for_wawe" )
    self.bonus_armor_for_wawe = self:GetAbility():GetSpecialValueFor( "bonus_armor_for_wawe" )
    self.bonus_mag_res_for_wawe = self:GetAbility():GetSpecialValueFor( "bonus_mag_res_for_wawe" )
    self.bonus_all_stats_for_wawe = self:GetAbility():GetSpecialValueFor( "bonus_all_stats_for_wawe" )
    self.bonus_spell_amp_for_wawe = self:GetAbility():GetSpecialValueFor( "bonus_spell_amp_for_wawe" )
    
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/my_doom_bringer_doom_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        local colorlist = {
            Vector(128,0,188),
            Vector(87, 188, 255),
            Vector(255, 153, 0),
            Vector(34, 34, 255),
            Vector(0, 255, 255),
            Vector(102, 72, 38),
            Vector(0, 255, 0),
            Vector(65, 0, 102),
            Vector(240, 240, 240),
            Vector(238, 255, 0),
            Vector(34, 34, 34)
        }
        ParticleManager:SetParticleControl(nFXIndex,5,colorlist[self:GetCaster().sealcolor])
        self.sealpfx = nFXIndex
        if self:GetCaster().sealpart ~= true and not self:GetCaster():IsIllusion() then
            local nFXIndex = ParticleManager:CreateParticle( "particles/my_sf_fire_arcana_shadowraze.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
            ParticleManager:ReleaseParticleIndex( nFXIndex )
            self:GetCaster().sealpart = true
        end

        self:SetStackCount(self:GetCaster():GetPlayerID())
        --Timers:CreateTimer(0.1,function()
        --    if self:GetCaster():GetItemInSlot(15) == nil then
        --        local thisslot = -1
        --        for i = 0, 5 do
        --            print("test")
        --            print(self:GetCaster():GetItemInSlot(i))
        --            print(self:GetAbility())
        --            if self:GetCaster():GetItemInSlot(i) == self:GetAbility() then
        --                thisslot = i
        --                break
        --            end
        --        end
        --        if thisslot ~= -1 then
        --            self:GetCaster():SwapItems(thisslot,15)
        --        end
        --    end
        --end)

        self:StartIntervalThink( 0.1 )
    end
    
    if IsClient() then
        if self:GetAbility():GetName() == "item_seal_1" then
            self.ico = "custom/item_seal_1"
        else
            self.ico = "custom/item_seal_5"
        end
    end
    self:OnWaweChange(0)
end


function mod_seal_1:OnIntervalThink()
    if IsServer() then
        local colorlist = {
            Vector(128,0,188),
            Vector(87, 188, 255),
            Vector(255, 153, 0),
            Vector(0, 0, 255),
            Vector(0, 255, 255),
            Vector(102, 72, 38),
            Vector(0, 255, 0),
            Vector(65, 0, 102),
            Vector(255, 255, 255),
            Vector(238, 255, 0),
            Vector(0, 0, 0)
        }
        ParticleManager:SetParticleControl(self.sealpfx,5,colorlist[self:GetCaster().sealcolor])
    end
end

----------------------------------------
function mod_seal_1:OnWaweChange(wave)
    self:GetModifierSpellLifesteal({})
    self:GetModifierPreAttack_BonusDamage({})
    self:GetModifierAttackSpeedBonus_Constant({})
    self:GetModifierPhysicalArmorBonus({})
    self:GetModifierMagicalResistanceBonus({})
    self:GetModifierBonusStats_Strength({})
    self:GetModifierBonusStats_Agility({})
    self:GetModifierBonusStats_Intellect({})
    self:GetModifierSpellAmplify_Percentage({})
end
----------------------------------------

function mod_seal_1:GetModifierSpellLifesteal( params )
    if IsServer() then
        if not self:GetCaster():IsIllusion() then
            local damag = 0
            if self:GetCaster().lvl_item_ambient_sorcery ~= nil then
                if self:GetCaster().lvl_item_ambient_sorcery >= 20 then
                    damag = math.floor((self.bonus_mana_cst_for_wawe+_G.bonuses[6][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * 20)
                else
                    damag = math.floor((self.bonus_mana_cst_for_wawe+_G.bonuses[6][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * self:GetCaster().lvl_item_ambient_sorcery)
                end
                CustomNetTables:SetTableValue("RelicStats_Tabel",tostring(self:GetCaster():GetPlayerID()).."0",{param = damag})
                return damag
            else
                self:GetCaster().lvl_item_ambient_sorcery = 1
            end
        end
    end
    local atr = CustomNetTables:GetTableValue("RelicStats_Tabel",tostring(self:GetStackCount()).."0")
    if atr ~= nil then
        return atr.param
    end
    return 0
end

function mod_seal_1:GetModifierPreAttack_BonusDamage( params )
	if IsServer() then
        if not self:GetCaster():IsIllusion() then
            local damag = 0
            if self:GetCaster().lvl_item_corrupting_blade ~= nil then
                if self:GetCaster().lvl_item_corrupting_blade >= 20 then
                    damag = math.ceil((self.bonus_damage_for_wawe+_G.bonuses[1][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * 20)
                else
                    damag = math.ceil((self.bonus_damage_for_wawe+_G.bonuses[1][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * self:GetCaster().lvl_item_corrupting_blade)
                end
                CustomNetTables:SetTableValue("RelicStats_Tabel",tostring(self:GetCaster():GetPlayerID()).."1",{param = damag})
                return damag
            else
                self:GetCaster().lvl_item_corrupting_blade = 1
            end
        end
    end
    local atr = CustomNetTables:GetTableValue("RelicStats_Tabel",tostring(self:GetStackCount()).."1")
    if atr ~= nil then
        return atr.param
    end
    return 0
end

function mod_seal_1:GetModifierAttackSpeedBonus_Constant( params )
	if IsServer() then
        if not self:GetCaster():IsIllusion() then
            local damag = 0
            if self:GetCaster().lvl_item_dredged_trident ~= nil then
                if self:GetCaster().lvl_item_dredged_trident >= 20 then
                    damag = math.floor((self.bonus_attack_speed_for_wawe+_G.bonuses[4][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * 20)
                else
                    damag = math.floor((self.bonus_attack_speed_for_wawe+_G.bonuses[4][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * self:GetCaster().lvl_item_dredged_trident)
                end
                CustomNetTables:SetTableValue("RelicStats_Tabel",tostring(self:GetCaster():GetPlayerID()).."2",{param = damag})
                return damag
            else
                self:GetCaster().lvl_item_dredged_trident = 1
            end
        end
    end
    local atr = CustomNetTables:GetTableValue("RelicStats_Tabel",tostring(self:GetStackCount()).."2")
    if atr ~= nil then
        return atr.param
    end
    return 0
end

function mod_seal_1:GetModifierPhysicalArmorBonus( params )
	if IsServer() then
        if not self:GetCaster():IsIllusion() then
            local damag = 0
            if self:GetCaster().lvl_item_glimmerdark_shield ~= nil then
                if self:GetCaster().lvl_item_glimmerdark_shield >= 20 then
                    damag = math.floor((self.bonus_armor_for_wawe+_G.bonuses[2][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * 20)
                else
                    damag = math.floor((self.bonus_armor_for_wawe+_G.bonuses[2][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * self:GetCaster().lvl_item_glimmerdark_shield)
                end
                CustomNetTables:SetTableValue("RelicStats_Tabel",tostring(self:GetCaster():GetPlayerID()).."3",{param = damag})
                return damag
            else
                self:GetCaster().lvl_item_glimmerdark_shield = 1
            end
        end
    end
    local atr = CustomNetTables:GetTableValue("RelicStats_Tabel",tostring(self:GetStackCount()).."3")
    if atr ~= nil then
        return atr.param
    end
    return 0
end

function mod_seal_1:GetModifierMagicalResistanceBonus( params )
	if IsServer() then
        if not self:GetCaster():IsIllusion() then
            local damag = 0
            if self:GetCaster().lvl_item_guardian_shell ~= nil then
                if self:GetCaster().lvl_item_guardian_shell >= 20 then
                    damag = math.floor((self.bonus_mag_res_for_wawe+_G.bonuses[3][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * 20)
                else
                    damag = math.floor((self.bonus_mag_res_for_wawe+_G.bonuses[3][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * self:GetCaster().lvl_item_guardian_shell)
                end
                CustomNetTables:SetTableValue("RelicStats_Tabel",tostring(self:GetCaster():GetPlayerID()).."4",{param = damag})
                return damag
            else
                self:GetCaster().lvl_item_guardian_shell = 1
            end
        end
    end
    local atr = CustomNetTables:GetTableValue("RelicStats_Tabel",tostring(self:GetStackCount()).."4")
    if atr ~= nil then
        return atr.param
    end
    return 0
end

function mod_seal_1:GetModifierBonusStats_Strength( params )
	if IsServer() then
        if not self:GetCaster():IsIllusion() then
            local damag = 0
            if self:GetCaster().lvl_item_oblivions_locket ~= nil then
                if self:GetCaster().lvl_item_oblivions_locket >= 20 then
                    damag = math.floor((self.bonus_all_stats_for_wawe+_G.bonuses[5][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * 20)
                else
                    damag = math.floor((self.bonus_all_stats_for_wawe+_G.bonuses[5][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * self:GetCaster().lvl_item_oblivions_locket)
                end
                CustomNetTables:SetTableValue("RelicStats_Tabel",tostring(self:GetCaster():GetPlayerID()).."5",{param = damag})
                return damag
            else
                self:GetCaster().lvl_item_oblivions_locket = 1
            end
        end
    end
    local atr = CustomNetTables:GetTableValue("RelicStats_Tabel",tostring(self:GetStackCount()).."5")
    if atr ~= nil then
        return atr.param
    end
    return 0
end

function mod_seal_1:GetModifierBonusStats_Agility( params )
	if IsServer() then
        if not self:GetCaster():IsIllusion() then
            local damag = 0
            if self:GetCaster().lvl_item_oblivions_locket ~= nil then
                if self:GetCaster().lvl_item_oblivions_locket >= 20 then
                    damag = math.floor((self.bonus_all_stats_for_wawe+_G.bonuses[5][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * 20)
                else
                    damag = math.floor((self.bonus_all_stats_for_wawe+_G.bonuses[5][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * self:GetCaster().lvl_item_oblivions_locket)
                end
                CustomNetTables:SetTableValue("RelicStats_Tabel",tostring(self:GetCaster():GetPlayerID()).."6",{param = damag})
                return damag
            else
                self:GetCaster().lvl_item_oblivions_locket = 1
            end
        end
    end
    local atr = CustomNetTables:GetTableValue("RelicStats_Tabel",tostring(self:GetStackCount()).."6")
    if atr ~= nil then
        return atr.param
    end
    return 0
end

function mod_seal_1:GetModifierBonusStats_Intellect( params )
	if IsServer() then
        if not self:GetCaster():IsIllusion() then
            local damag = 0
            if self:GetCaster().lvl_item_oblivions_locket ~= nil then
                if self:GetCaster().lvl_item_oblivions_locket >= 20 then
                    damag = math.floor((self.bonus_all_stats_for_wawe+_G.bonuses[5][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * 20)
                else
                    damag = math.floor((self.bonus_all_stats_for_wawe+_G.bonuses[5][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * self:GetCaster().lvl_item_oblivions_locket)
                end
                CustomNetTables:SetTableValue("RelicStats_Tabel",tostring(self:GetCaster():GetPlayerID()).."7",{param = damag})
                return damag
            else
                self:GetCaster().lvl_item_oblivions_locket = 1
            end
        end
    end
    local atr = CustomNetTables:GetTableValue("RelicStats_Tabel",tostring(self:GetStackCount()).."7")
    if atr ~= nil then
        return atr.param
    end
    return 0
end

function mod_seal_1:GetModifierSpellAmplify_Percentage( params )
	if IsServer() then
        if not self:GetCaster():IsIllusion() then
            local damag = 0
            if self:GetCaster().lvl_item_wand_of_the_brine ~= nil then
                if self:GetCaster().lvl_item_wand_of_the_brine >= 20 then
                    damag = math.floor((self.bonus_spell_amp_for_wawe+_G.bonuses[7][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * 20)
                else
                    damag = math.floor((self.bonus_spell_amp_for_wawe+_G.bonuses[7][self:GetCaster():GetPlayerID()]) * _G.GAME_ROUND * self:GetCaster().lvl_item_wand_of_the_brine)
                end
                CustomNetTables:SetTableValue("RelicStats_Tabel",tostring(self:GetCaster():GetPlayerID()).."8",{param = damag})
                return damag
            else
                self:GetCaster().lvl_item_wand_of_the_brine = 1
            end
        end
    end
    local atr = CustomNetTables:GetTableValue("RelicStats_Tabel",tostring(self:GetStackCount()).."8")
    if atr ~= nil then
        return atr.param
    end
    return 0
end

---------------------------------------------------
function mod_seal_1:OnTooltip(params)
    local atr = CustomNetTables:GetTableValue("RelicStats_Tabel",tostring(self:GetStackCount()).."0")
    if atr ~= nil then
        return atr.param
    end
    return 0
end

function mod_seal_1:OnAbilityExecuted( params )
	if IsServer() then
        if not self:GetCaster():IsIllusion() then
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
    end
	return 0
end

function mod_seal_1:OnAttackLanded( params )
	if IsServer() then
        if not self:GetCaster():IsIllusion() then
            if self:GetCaster() == params.attacker then
                self.col_ud = self.col_ud + 1
                if self.col_ud >= 3 then
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
                    self.col_ud = 0
                end
            end
        end
    end
end

function mod_seal_1:OnTakeDamage( params )
	if IsServer() then
        if not self:GetCaster():IsIllusion() and self:GetCaster():GetHealth() > 0 then
            if params.unit == self:GetParent() then
                if self.taken_damage == nil then
                    self.taken_damage = 0
                end
                self.taken_damage = self.taken_damage + params.damage
                local maax = self:GetParent():GetMaxHealth()/10
                if self.taken_damage >= maax and ( not self:GetParent():IsIllusion() ) then
                    self.taken_damage = 0
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
	end

	return 0
end

function mod_seal_1:OnDestroy()
    if IsServer() then
        ParticleManager:DestroyParticle(self.sealpfx, false)
    end
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
	return 3
end