LinkLuaModifier( "od_tree_mod", "abilities/od_tree_breaker.lua", LUA_MODIFIER_MOTION_NONE )
od_tree_breaker = class({})

function od_tree_breaker:OnSpellStart( event )
    self.projectls = {}
    local caster = self:GetCaster()
    local trees = GridNav:GetAllTreesAroundPoint(caster:GetAbsOrigin(), 9999, true)
    local starttimes = 10
    if caster:FindModifierByName("mod_od_ult") then
        starttimes = 20
    end
    for i=1, starttimes do
        local delectedtree = trees[RandomInt(1,#trees)]
        local newSpirit = CreateUnitByName( "npc_dota_my_od_tree", delectedtree:GetAbsOrigin(), false, caster, caster, caster:GetTeam() )
        delectedtree:CutDown(0)
        pfx1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_tiny/tiny_tree_linear_proj.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit )
        pfx2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_matter_buff.vpcf", PATTACH_OVERHEAD_FOLLOW, newSpirit )
        newSpirit:AddNewModifier(caster, self, "od_tree_mod", {})
        newSpirit:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
        Timers:CreateTimer(i+1.5, function()
            ParticleManager:DestroyParticle(pfx1,false)
            ParticleManager:DestroyParticle(pfx2,false)
            local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )    
            local point = enemies[1]:GetAbsOrigin()
            local vDirection = point - newSpirit:GetOrigin()
            vDirection.z = 0.0
            vDirection = vDirection:Normalized()
            local extr = {}
            extr.num = i
            local info = {
                EffectName = "particles/units/heroes/hero_rubick/rubick_tree_linear_proj.vpcf",
                Ability = self,
                vSpawnOrigin = newSpirit:GetOrigin(), 
                fStartRadius = 150,
                fEndRadius = 150,
                vVelocity = vDirection * 800,
                fDistance = (newSpirit:GetAbsOrigin()-point):Length2D()+200,
                Source = caster,
                bProvidesVision = false,
                iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
                ExtraData = extr
                --bDeleteOnHit = true,
                --bHasFrontalCone = false,
                --bReplaceExisting = false,
            }
            newSpirit:Destroy()
            self.projectls[i] = ProjectileManager:CreateLinearProjectile( info )
        end)
    end
end

function od_tree_breaker:OnProjectileHit_ExtraData(target, vLocation, extraData)
    print(extraData.num)
    if target ~= nil then
        ProjectileManager:DestroyLinearProjectile( self.projectls[extraData.num] )
        local knockbackModifierTable =  {
            should_stun = 0.25,
            knockback_duration = 0.25,
            duration = 0.25,
            knockback_distance = 250,
            knockback_height = 50,
            center_x = vLocation.x,
            center_y = vLocation.y,
            center_z = vLocation.z
        }
        target:AddNewModifier( nil, nil, "modifier_knockback", knockbackModifierTable )
        local damageTable = {victim=target, attacker=self:GetCaster(), damage=10000, damage_type = DAMAGE_TYPE_PHYSICAL}
        ApplyDamage(damageTable)
    end
end

od_tree_mod = class({})

function od_tree_mod:CheckState()
	local state = {}
	state[MODIFIER_STATE_INVULNERABLE] = true
    state[MODIFIER_STATE_ATTACK_IMMUNE] = true
    state[MODIFIER_STATE_MAGIC_IMMUNE] = true
    state[MODIFIER_STATE_UNSELECTABLE] = true
    state[MODIFIER_STATE_NO_HEALTH_BAR] = true
    state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	return state
end