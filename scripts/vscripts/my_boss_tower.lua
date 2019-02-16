towers = {}
triggered = false

function CastTowers( event )
	local caster	= event.caster
	local ability	= event.ability

	ability.spirits_startTime		= GameRules:GetGameTime()
	caster.spirits_radius			= 500

	local casterOrigin	= caster:GetAbsOrigin()
    
    local wow = 0
    
	while wow < 4 do
		-- Spawn a new spirit
		local newSpirit = CreateUnitByName( "npc_dota_custom_creep_10_2", casterOrigin, false, caster, caster, caster:GetTeam() )

		-- Apply the spirit modifier
		ability:ApplyDataDrivenModifier( caster, newSpirit, "modifier_omninight_guardian_angel", {} )
		ability:ApplyDataDrivenModifier( caster, newSpirit, "modifier_boss_tower", {} )
		ability:ApplyDataDrivenModifier( caster, newSpirit, "mod_tower_aura", {} )
        Timers:CreateTimer(1, function()
        if triggered == false then
		ability:ApplyDataDrivenModifier( caster, newSpirit, "mod_tower_trigger", {} )
        end
        end)
        -- Rotate
		local rotationAngle = 0 - 45 - (90 * wow)
		local relPos = Vector( 0, 500, 0 )
		relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )

		local absPos = GetGroundPosition( relPos + casterOrigin, newSpirit )
        --newSpirit:StartGesture(ACT_DOTA_CAPTURE)
		newSpirit:SetAbsOrigin( absPos )
        wow = wow + 1
        towers[wow] = newSpirit
	end
end

function Triggered( event )
    if triggered == false then
	local caster	= event.caster
    caster:SetAcquisitionRange(9999)
    caster:RemoveModifierByName("modifier_boss_towers")
    local wow = 1
	while wow < 5 do
        towers[wow]:RemoveModifierByName("modifier_omninight_guardian_angel")
        towers[wow]:RemoveModifierByName("modifier_boss_tower")
        towers[wow]:RemoveModifierByName("mod_tower_trigger")
        wow = wow + 1
	end
    triggered = true
    end
end

function DestroyTowers( event )
	local target = event.target
    if target:GetUnitLabel() == "npc_dota_custom_creep_10_1" then
        target:RemoveModifierByName("modifier_omninight_guardian_angel")
        target:RemoveModifierByName("modifier_boss_tower")
    end
end