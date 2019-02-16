spirit_speed = 10
goo = false
start_razgon = false
function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local offorder = false
    
    for i=1, 5 do
        caster.mywisps[i]:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
        caster.mywisps[i]:RemoveModifierByName("modifier_tether_caster_datadriven")
        ability:ApplyDataDrivenModifier( caster.mywisps[i], caster.mywisps[i], "modifier_kotl_3_state_for_wisps", {} )
        caster.mywisps[i]:Stop()
        local rotationAngle = 0 - 45 - (72 * i)
        local relPos = Vector( 0, 300, 0 )
        relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )
        local nPos = GetGroundPosition( relPos + caster:GetAbsOrigin(), caster.mywisps[i] )
        local order = {
            OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
            UnitIndex = caster.mywisps[i]:entindex(),
            Position  = nPos,
            Queue     = false
        }
        ExecuteOrderFromTable( order )
        Timers:CreateTimer(0.1, function()
            local order = {
                OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
                UnitIndex = caster.mywisps[i]:entindex(),
                Position  = nPos,
                Queue     = false
            }
            ExecuteOrderFromTable( order )
            if goo == false then
                return 0.1
            end
        end)
    end
    local y = 1
    Timers:CreateTimer(2.5, function()
        if y < 5 then
            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_ABSORIGIN, caster.mywisps[y] )
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster.mywisps[y], PATTACH_POINT_FOLLOW, "attach_hitloc", caster.mywisps[y]:GetOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true )
            caster.mywisps[y].fx = nFXIndex
            y = y + 1
            return 0.5
        else
            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_ABSORIGIN, caster.mywisps[y] )
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster.mywisps[y], PATTACH_POINT_FOLLOW, "attach_hitloc", caster.mywisps[y]:GetOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true )
            caster.mywisps[y].fx = nFXIndex
            caster:RemoveModifierByName("modifier_kotl_3_state_for_caster")
            ability.spirits_startTime = GameRules:GetGameTime()
            goo = true
        end
    end)
end

function OnIntervalThink(event)
    if goo == true then
        local caster	= event.caster
        local ability	= event.ability
        local casterOrigin	= caster:GetAbsOrigin()
        local elapsedTime	= GameRules:GetGameTime() - ability.spirits_startTime
        --------------------------------------------------------------------------------
        -- Validate the number of spirits summoned
        
        local currentRadius	= 300
        caster.spirits_radius = currentRadius

        --------------------------------------------------------------------------------
        -- Update the spirits' positions
        --
        local currentRotationAngle	= 0
        if start_razgon == false then
            spirit_speed = spirit_speed + 0.3
            if spirit_speed >= 100 then
                spirit_speed = 200
                start_razgon = true
            end
        end
        currentRotationAngle = elapsedTime * spirit_speed

        local numSpiritsAlive = 0

        for k,v in pairs( caster.mywisps ) do

            -- Rotate
            local rotationAngle = currentRotationAngle - (72 * k)
            local relPos = Vector( 0, currentRadius, 0 )
            relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )

            local absPos = GetGroundPosition( relPos + casterOrigin, v )

            v:SetAbsOrigin( absPos )

            -- Update particle
            --ParticleManager:SetParticleControl( v.spirit_pfx, 1, Vector( currentRadius, 0, 0 ) )

        end
    end
end