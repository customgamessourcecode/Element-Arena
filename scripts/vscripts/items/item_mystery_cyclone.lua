item_mystery_cyclone = class({})

LinkLuaModifier("modifier_item_mystery_cyclone", "items/item_mystery_cyclone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mystery_cyclone_active", "items/item_mystery_cyclone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mystery_cyclone_active_debuff", "items/item_mystery_cyclone", LUA_MODIFIER_MOTION_NONE)

function item_mystery_cyclone:GetIntrinsicModifierName()
	return "modifier_item_mystery_cyclone"
end

modifier_item_mystery_cyclone = class({})

function modifier_item_mystery_cyclone:IsHidden() return true end
function modifier_item_mystery_cyclone:IsPurgable() return false end
function modifier_item_mystery_cyclone:IsDebuff() return false end
function modifier_item_mystery_cyclone:RemoveOnDeath() return false end
function modifier_item_mystery_cyclone:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_mystery_cyclone:DeclareFunctions()
	local funcs = {
					MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
                    MODIFIER_PROPERTY_MANA_BONUS
					}
	return funcs
end

function modifier_item_mystery_cyclone:GetModifierConstantManaRegen()	return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end
function modifier_item_mystery_cyclone:GetModifierBonusStats_Intellect()	return self:GetAbility():GetSpecialValueFor("bonus_intellect") end
function modifier_item_mystery_cyclone:GetModifierMoveSpeedBonus_Constant()	return self:GetAbility():GetSpecialValueFor("bonus_movement_speed") end
function modifier_item_mystery_cyclone:GetModifierManaBonus()	return self:GetAbility():GetSpecialValueFor("bonus_mana") end
function modifier_item_mystery_cyclone:GetModifierCastRangeBonusStacking()  return self:GetAbility():GetSpecialValueFor("cast_range") end

function item_mystery_cyclone:CastFilterResultTarget(hTarget)
	if not IsServer() then return end
	local caster = self:GetCaster()
	if caster:GetTeamNumber() == hTarget:GetTeamNumber() and caster ~= hTarget then
		return UF_FAIL_FRIENDLY
	end
	if caster ~= hTarget and hTarget:IsMagicImmune() then
		return UF_FAIL_MAGIC_IMMUNE_ENEMY
	end
end

function item_mystery_cyclone:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
    local friends = FindUnitsInRadius( caster:GetTeamNumber(), pos, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
    for i=1,#friends do
		friends[i]:Purge(false, true, false, false, false)
		friends[i]:AddNewModifier(caster, self, "modifier_item_mystery_cyclone_active", {duration = self:GetSpecialValueFor("cyclone_duration")})
    end
end

function item_mystery_cyclone:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

modifier_item_mystery_cyclone_active = class({})

function modifier_item_mystery_cyclone_active:IsDebuff() return false end
function modifier_item_mystery_cyclone_active:IsHidden() return false end
function modifier_item_mystery_cyclone_active:IsPurgable() return true end
function modifier_item_mystery_cyclone_active:IsStunDebuff() return true end
function modifier_item_mystery_cyclone_active:IsMotionController()  return true end
function modifier_item_mystery_cyclone_active:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_item_mystery_cyclone_active:OnCreated()
	self:StartIntervalThink(FrameTime())
	EmitSoundOn("DOTA_Item.Cyclone.Activate", self:GetParent())
	if IsServer() then
		self:GetParent():StartGesture(ACT_DOTA_FLAIL)
		self.angle = self:GetParent():GetAngles()
		self.abs = self:GetParent():GetAbsOrigin()
		self.cyc_pos = self:GetParent():GetAbsOrigin()

		self.pfx_name = "particles/items_fx/cyclone.vpcf"
		self.pfx = ParticleManager:CreateParticle(self.pfx_name, PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self.abs)
	end
end

function modifier_item_mystery_cyclone_active:OnIntervalThink()
	-- Remove force if conflicting
	--if not self:CheckMotionControllers() then
	--	self:Destroy()
	--	return
	--end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_mystery_cyclone_active:HorizontalMotion(unit, time)
	if not IsServer() then return end
	-- Change the Face Angle
	local angle = self:GetParent():GetAngles()
	local new_angle = RotateOrientation(angle, QAngle(0,20,0))
	self:GetParent():SetAngles(new_angle[1], new_angle[2], new_angle[3])
	-- Change the height at the first and last 0.3 sec
	if self:GetElapsedTime() <= 0.3 then
		self.cyc_pos.z = self.cyc_pos.z + 50
		self:GetParent():SetAbsOrigin(self.cyc_pos)
	elseif self:GetDuration() - self:GetElapsedTime() < 0.3 then
		self.step = self.step or (self.cyc_pos.z - self.abs.z) / ((self:GetDuration() - self:GetElapsedTime()) / FrameTime())
		self.cyc_pos.z = self.cyc_pos.z - self.step
		self:GetParent():SetAbsOrigin(self.cyc_pos)
	else -- Random move
		local pos = self:GetRandomPosition2D(self:GetParent():GetAbsOrigin(),15)
		while ((pos - self.abs):Length2D() > 50) do
			pos = self:GetRandomPosition2D(self:GetParent():GetAbsOrigin(),15)
		end
		self:GetParent():SetAbsOrigin(pos)
	end
end

function modifier_item_mystery_cyclone_active:GetRandomPosition2D(vPosition, fRadius)
	local newPos = vPosition + Vector(1,0,0) * math.random(0-fRadius, fRadius)
	return RotatePosition(vPosition, QAngle(0,math.random(-360,360),0), newPos)
end

function modifier_item_mystery_cyclone_active:OnDestroy()
	StopSoundOn("DOTA_Item.Cyclone.Activate", self:GetParent())
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)

	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	self:GetParent():SetAbsOrigin(self.abs)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
	self:GetParent():SetAngles(self.angle[1], self.angle[2], self.angle[3])
end

function modifier_item_mystery_cyclone_active:CheckState()
	local state =
		{
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		}
	return state
end