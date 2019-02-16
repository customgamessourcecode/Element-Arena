function CreateWisp(event)
    local caster = event.caster
    local ability = event.ability
    local trees = GridNav:GetAllTreesAroundPoint(caster:GetAbsOrigin(), 9999, true)
    local newSpirit = CreateUnitByName( "npc_dota_my_heal_spirit", trees[RandomInt(1,#trees)]:GetAbsOrigin(), false, caster, caster, caster:GetTeam() )
	pfx1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_wisp/wisp_guardian_.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit )
    newSpirit.spirit_pfx = pfx1
	ability:ApplyDataDrivenModifier( caster, newSpirit, "modifier_kotl_heal_wisp", {} )
    newSpirit:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
    Timers:CreateTimer(0.1, function()
        newSpirit:MoveToNPC(caster)
    --    local order = {
    --        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
    --        UnitIndex = newSpirit:entindex(),
    --        Position  = caster:GetAbsOrigin(),
    --        Queue     = false
    --    }
    --    ExecuteOrderFromTable( order )
    end)
end

function OnCreatedAuraEffect(event)
    local modif = event.target:FindModifierByName("modifier_kotl_heal_wisp")
    if modif ~= nil then
        OnDestroyWisp(event)
        event.caster:Heal(200, event.target)
        event.target:ForceKill(false)
    end
end

function OnDestroyWisp(event)
    ParticleManager:CreateParticle( "particles/units/heroes/hero_wisp/wisp_guardian_explosion.vpcf", PATTACH_ABSORIGIN, event.target )
    ParticleManager:DestroyParticle( event.target.spirit_pfx, false )
end

function OnDestroyCaster(event)
    local friends = FindUnitsInRadius( event.caster:GetTeamNumber(), event.caster:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    print(#friends)
    for i=1,#friends do
        local modif = friends[i]:FindModifierByName("modifier_kotl_heal_wisp")
        if modif ~= nil then
            local myeve = {}
            myeve.target = friends[i]
            OnDestroyWisp(myeve)
            friends[i]:ForceKill(false)
        end
    end
    for i=1,5 do
        ParticleManager:DestroyParticle(event.caster.mywisps[i].fx, false )
        event.caster.mywisps[i]:ForceKill(false)
    end
end