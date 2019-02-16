function CratePilon( event )
    local caster = event.caster
    if caster:GetHealth() < caster:GetMaxHealth() then
        local ability = event.ability
        local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )    
        local point = enemies[RandomInt(1,#enemies)]:GetAbsOrigin()
        local pilon = CreateUnitByName("npc_dota_od_pilon", point, true, caster, nil, caster:GetTeam())
        pilon:SetOwner(caster)
        pilon:SetMaterialGroup("radiant_level6")
        pilon:StartGesture(ACT_DOTA_CAPTURE)
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf", PATTACH_ABSORIGIN_FOLLOW, pilon) 
        pilon.pfx = particle
        if caster:GetHealth()/caster:GetMaxHealth() >= 0.5 then
            pilon.hp = 10
            ability:ApplyDataDrivenModifier(caster, pilon, "mod_od_pilon_thin", {})
        else
            ability:ApplyDataDrivenModifier(caster, pilon, "mod_od_pilon_thin_stt2", {})
        end
    end
end

function PilonThink( event )
    local caster = event.caster
	local target = event.target
    local enemies = FindUnitsInRadius( target:GetTeamNumber(), target:GetOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	for _,enemy in pairs( enemies ) do
		if enemy ~= nil and enemy:IsInvulnerable() == false then
			local damageInfo = 
			{
				victim = enemy,
				attacker = target,
				damage = 10000,
				damage_type = DAMAGE_TYPE_MAGICAL
			}
			ApplyDamage( damageInfo )
		end
	end
end

function PilonThink2( event )
    local caster = event.caster
	local target = event.target
    local enemies = FindUnitsInRadius( target:GetTeamNumber(), target:GetOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	for _,enemy in pairs( enemies ) do
		if enemy ~= nil and enemy:IsInvulnerable() == false then
            if enemy:FindModifierByName("mod_od_poliana_debuff") ~= nil then
                enemy:RemoveModifierByName("mod_od_poliana_debuff")
                ParticleManager:DestroyParticle(target.pfx,false)
                target:ForceKill(false)
                target:Destroy()
            else
                local damageInfo = 
                {
                    victim = enemy,
                    attacker = target,
                    damage = 10000,
                    damage_type = DAMAGE_TYPE_MAGICAL
                }
                ApplyDamage( damageInfo )
            end
		end
	end
end

function OnTakeDamage( event )
	local unit = event.unit
    local hp = unit.hp
    unit:SetHealth(hp)
end

function OnAttacked( event )
	local target = event.target
    local hp = target.hp
    hp = hp - 1
	
    if hp <= 0 then
        ParticleManager:DestroyParticle(target.pfx,false)
        target:ForceKill(false)
        target:Destroy()
    else
        target.hp = hp
        target:SetHealth(hp)
	end
end