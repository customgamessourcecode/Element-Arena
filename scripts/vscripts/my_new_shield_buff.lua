LinkLuaModifier( "my_new_shield_buff_mod", "my_new_shield_buff", LUA_MODIFIER_MOTION_NONE )

function OnCreated(event)
	local target = event.target
	local ability = event.ability
    target:AddNewModifier(target, ability, "my_new_shield_buff_mod", {})
	pfx = ParticleManager:CreateParticle( "particles/my_new/vanguard_active.vpcf", PATTACH_CUSTOMORIGIN, target )
    --ParticleManager:SetParticleControl( pfx, 0, Vector( 0, 0, 0 ) )
    ParticleManager:SetParticleControl( pfx, 0, Vector(target:GetAbsOrigin().x+300, target:GetAbsOrigin().y, target:GetAbsOrigin().z) )
    --ParticleManager:SetParticleControlEnt( pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(caster:GetAbsOrigin().x+200, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z), true )
    --ParticleManager:SetParticleControlEnt( pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true )
    --ParticleManager:SetParticleControlForward( pfx, 0, Vector( 300, 0, 0 ) )
    ParticleManager:SetParticleControlEnt( pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true )
    --ParticleManager:SetParticleControl( pfx, 4, Vector( 1, 1, 1 ) )
    --ParticleManager:SetParticleControlEnt( pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(caster:GetAbsOrigin().x+100, caster:GetAbsOrigin().y+100, caster:GetAbsOrigin().z+100), true )
    --ParticleManager:SetParticleControlEnt( pfx, 3, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetOrigin(), true )
    --ParticleManager:SetParticleControlEnt( pfx, 5, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetOrigin(), true )
    --ParticleManager:ReleaseParticleIndex(pfx)
    target.colpfx = pfx
end

function OnDestroy(event)
	local target = event.target
    target:RemoveModifierByName("my_new_shield_buff_mod")
	ParticleManager:DestroyParticle( target.colpfx, false )
end

my_new_shield_buff_mod = class({})
function my_new_shield_buff_mod:IsHidden() return true end
function my_new_shield_buff_mod:IsDebuff() return false end
function my_new_shield_buff_mod:IsPurgable() return false end
function my_new_shield_buff_mod:RemoveOnDeath() return false end

function my_new_shield_buff_mod:GetCustomDamageBlock()
	return self:GetAbility():GetSpecialValueFor("bonus_block")
end