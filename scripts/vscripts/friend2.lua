function OnSpellStart( event )
	local caster	= event.caster
	local ability	= event.ability
    
    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_death_model.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
    
     if ability.spirit1 ~= nil then
        if not ability.spirit1:IsNull() then
            ability:ApplyDataDrivenModifier( ability.spirit1, ability.spirit1, "modifier_spirit_attack_speed", {duration = 5} )
            Timers:CreateTimer(0.1, function()
                ability.speed = 4
            end)
            Timers:CreateTimer(0.2, function()
                ability.speed = 6
            end)
            Timers:CreateTimer(0.3, function()
                ability.speed = 8
            end)
            Timers:CreateTimer(0.4, function()
                ability.speed = 10
            end)
            Timers:CreateTimer(5, function()
                ability.speed = 8
            end)
            Timers:CreateTimer(5.1, function()
                ability.speed = 6
            end)
            Timers:CreateTimer(5.2, function()
                ability.speed = 4
            end)
            Timers:CreateTimer(5.3, function()
                ability.speed = 2
            end)
        end
    end
    if ability.spirit2 ~= nil then
        if not ability.spirit2:IsNull() then
            ability:ApplyDataDrivenModifier( ability.spirit2, ability.spirit2, "modifier_spirit_attack_speed", {duration = 5} )
        end
    end
end
function CastSpirits( event )
	local caster	= event.caster
	local ability	= event.ability
    ability.rot = 0
    ability.speed = 2
	ability.spirits_startTime		= GameRules:GetGameTime()
    if caster:IsRangedAttacker() then
    if caster:IsRealHero() or event.caster:GetUnitLabel() == "npc_dota_custom_creep_45_2" then
    if ability.spirit1 ~= nil then
        if not ability.spirit1:IsNull() then
            ability.spirit1:ForceKill( true )
            ability.spirit1 = nil
        end
    end
    if ability.spirit2 ~= nil then
        if not ability.spirit2:IsNull() then
            ability.spirit2:ForceKill( true )
            ability.spirit2 = nil
        end
    end
    
	local casterOrigin	= caster:GetAbsOrigin()
    
    -- Spawn a new spirit1
		local newSpirit = CreateUnitByName( "npc_dota_spirit", casterOrigin, false, caster, caster, caster:GetTeam() )
		-- Create particle FX
		pfx1 = ParticleManager:CreateParticle( event.spirit_particle_name, PATTACH_ABSORIGIN_FOLLOW, newSpirit )
        newSpirit.pfx = pfx1
		ability.spirit1 = newSpirit
		-- Apply the spirit modifier
		ability:ApplyDataDrivenModifier( caster, newSpirit, event.spirit_modifier, {} )
        
    -- Spawn a new spirit2
		newSpirit = CreateUnitByName( "npc_dota_spirit", casterOrigin, false, caster, caster, caster:GetTeam() )
		-- Create particle FX
		pfx2 = ParticleManager:CreateParticle( event.spirit_particle_name, PATTACH_ABSORIGIN_FOLLOW, newSpirit )
        newSpirit.pfx = pfx2
		ability.spirit2 = newSpirit
		-- Apply the spirit modifier
		ability:ApplyDataDrivenModifier( caster, newSpirit, event.spirit_modifier, {} )
        
    end
    end
end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Update spirits.
]]
function ThinkSpirits( event )
	
	local caster	= event.caster
	local ability	= event.ability
	local spiritModifier	= event.spirit_modifier
	local casterOrigin	= caster:GetAbsOrigin()
    
    if caster:IsRangedAttacker() then
        if caster:IsRealHero() or event.caster:GetUnitLabel() == "npc_dota_custom_creep_45_2" then
            local currentRadius = 100
            if ability.spirit1 ~= nil then
                local elapsedTime	= GameRules:GetGameTime() - ability.spirits_startTime
                local rotationAngle = ability.rot - 270
                
                local relPos = Vector( 0, currentRadius, 0 )
                relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )
                
                local absPos = GetGroundPosition( relPos + casterOrigin, ability.spirit1 )

                ability.spirit1:SetAbsOrigin( absPos )
                ability.spirit1:SetBaseDamageMin(caster:GetAttackDamage())
                ability.spirit1:SetBaseDamageMax(caster:GetAttackDamage())

                -- Update particle
                ParticleManager:SetParticleControl( ability.spirit1.pfx, 1, Vector( currentRadius, 0, 0 ) )
            else
            -- Spawn a new spirit1
                local newSpirit = CreateUnitByName( "npc_dota_spirit", casterOrigin, false, caster, caster, caster:GetTeam() )
                -- Create particle FX
                pfx1 = ParticleManager:CreateParticle( event.spirit_particle_name, PATTACH_ABSORIGIN_FOLLOW, newSpirit )
                newSpirit.pfx =pfx1
                ability.spirit1 = newSpirit
                -- Apply the spirit modifier
                ability:ApplyDataDrivenModifier( caster, newSpirit, event.spirit_modifier, {} )
            end
            if ability.spirit2 ~= nil then
                local elapsedTime	= GameRules:GetGameTime() - ability.spirits_startTime
                local rotationAngle = ability.rot - 90
                
                local relPos = Vector( 0, currentRadius, 0 )
                relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )
                
                local absPos = GetGroundPosition( relPos + casterOrigin, ability.spirit2 )

                ability.spirit2:SetAbsOrigin( absPos )
                ability.spirit2:SetBaseDamageMin(caster:GetAttackDamage())
                ability.spirit2:SetBaseDamageMax(caster:GetAttackDamage())

                -- Update particle
                ParticleManager:SetParticleControl( ability.spirit2.pfx, 1, Vector( currentRadius, 0, 0 ) )
            else
            -- Spawn a new spirit2
                newSpirit = CreateUnitByName( "npc_dota_spirit", casterOrigin, false, caster, caster, caster:GetTeam() )
                -- Create particle FX
                pfx2 = ParticleManager:CreateParticle( event.spirit_particle_name, PATTACH_ABSORIGIN_FOLLOW, newSpirit )
                newSpirit.pfx =pfx2
                ability.spirit2 = newSpirit
                -- Apply the spirit modifier
                ability:ApplyDataDrivenModifier( caster, newSpirit, event.spirit_modifier, {} )
            end
            ability.rot = ability.rot + ability.speed
        end
    else
        if ability.spirit1 ~= nil then
            if not ability.spirit1:IsNull() then
                ability.spirit1:RemoveModifierByName( spiritModifier )
            end
        end
        if ability.spirit2 ~= nil then
            if not ability.spirit2:IsNull() then
                ability.spirit2:RemoveModifierByName( spiritModifier )
            end
        end
    end
end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Destroy all spirits and swap the abilities back to the original states.
]]
function EndSpirits( event )
	local caster	= event.caster
	local ability	= event.ability
	local spiritModifier	= event.spirit_modifier
    
    if ability.spirit1 ~= nil then
        if not ability.spirit1:IsNull() then
            ability.spirit1:RemoveModifierByName( spiritModifier )
        end
    end
    
    if ability.spirit2 ~= nil then
        if not ability.spirit2:IsNull() then
            ability.spirit2:RemoveModifierByName( spiritModifier )
        end
    end
end
--[[
	Author: Ractidous
	Date: 09.02.2015.
	Apply a modifier which detects collision with a hero.
]]
function OnCreatedSpirit( event )
	
	local spiritt = event.target
	local ability = event.ability
    
    if event.caster:IsRangedAttacker() then
    if event.caster:IsRealHero() or event.caster:GetUnitLabel() == "npc_dota_custom_creep_45_2" then
	-- Set the spirit to caster
	    ability:ApplyDataDrivenModifier( spiritt, spiritt, event.additionalModifier, {} )
    end
    end
end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Destroy a spirit.
]]
function OnDestroySpirit( event )
	local ability	= event.ability
	local caster	= event.caster

	-- Kill
    if ability.spirit1 ~= nil then
	    ParticleManager:DestroyParticle( ability.spirit1.pfx, false )
        if not ability.spirit1:IsNull() then
            ability.spirit1:ForceKill( true )
            ability.spirit1 = nil
        end
    end
    
    if ability.spirit2 ~= nil then
	    ParticleManager:DestroyParticle( ability.spirit2.pfx, false )
        if not ability.spirit2:IsNull() then
            ability.spirit2:ForceKill( true )
            ability.spirit2 = nil
        end
    end
end