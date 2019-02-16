my_tinker_boom = class({})
LinkLuaModifier( "my_tinker_boom_in", "abilities/my_tinker_boom", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function my_tinker_boom:OnSpellStart()
	if IsServer() then	
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_omninight_guardian_angel", {} )
        self:GetCaster():AddNewModifier( nil, nil, "my_tinker_boom_in", {} )
        self:GetCaster():StartGesture(ACT_DOTA_TELEPORT_STATUE)
	end
end

-----------------------------------------------------------------------------

function my_tinker_boom:OnChannelThink( flInterval )
	if IsServer() then
        local heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
        if #heroes > 0 then
            local pnt = heroes[RandomInt(1,#heroes)]:GetAbsOrigin() + RandomVector(RandomFloat(0,150))
            local direction = pnt - self:GetCaster():GetAbsOrigin()
            direction.z = 0.0
            direction = direction:Normalized()
            local info = 
            {
                Ability = self,
                EffectName = "particles/my_magnataur_shockwave.vpcf",
                vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
                fDistance = 4000,
                fStartRadius = 64,
                fEndRadius = 64,
                Source = self:GetCaster(),
                bHasFrontalCone = false,
                bReplaceExisting = false,
                iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
                iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                fExpireTime = GameRules:GetGameTime() + 10.0,
                bDeleteOnHit = true,
                vVelocity = direction * 800,
                bProvidesVision = false
            }
            local projectile = ProjectileManager:CreateLinearProjectile(info)
        end
	end
end

function my_tinker_boom:OnProjectileHit( hTarget, vLocation )
    local dmgt = {DAMAGE_TYPE_PURE,DAMAGE_TYPE_MAGICAL,DAMAGE_TYPE_PHYSICAL}
    local damageTable = {
	victim = hTarget,
	attacker = self:GetCaster(),
	damage = 300,
	damage_type = dmgt[RandomInt(1,3)]
    }
    ApplyDamage(damageTable)
end
-----------------------------------------------------------------------------

function my_tinker_boom:OnChannelFinish( bInterrupted )
	if IsServer() then
        self:GetCaster():RemoveModifierByName( "modifier_omninight_guardian_angel" )
        self:GetCaster():RemoveModifierByName( "my_tinker_boom_in" )
        self:GetCaster():RemoveGesture(ACT_DOTA_TELEPORT_STATUE)
	end
end

-----------------------------------------------------------------------------

my_tinker_boom_in = class({})
function my_tinker_boom_in:IsHidden() return false end
function my_tinker_boom_in:IsDebuff() return false end
function my_tinker_boom_in:IsPurgable() return false end

function my_tinker_boom_in:CheckState()
	local state = {}
	--state[MODIFIER_STATE_MAGIC_IMMUNE] = true
	state[MODIFIER_STATE_INVULNERABLE] = true
	--state[MODIFIER_STATE_OUT_OF_GAME] = true
	--state[MODIFIER_STATE_STUNNED] = true
	--state[MODIFIER_STATE_UNSELECTABLE] = true
	--state[MODIFIER_STATE_NO_HEALTH_BAR] = true
	return state
end