function OnIntervalThink( event )
    local ability = event.ability
    local caster = event.caster
    local damage = 10000

    if ability.pfx == nil then
        ability.pfx = ParticleManager:CreateParticle("particles/econ/items/underlord/underlord_ti8_immortal_weapon/underlord_crimson_ti8_immortal_pitofmalice.vpcf",PATTACH_ABSORIGIN,caster)
        ParticleManager:SetParticleControl( ability.pfx, 0, Vector(0,0,0) )
        ParticleManager:SetParticleControl( ability.pfx, 1, Vector(400,10,0) )
        ParticleManager:SetParticleControl( ability.pfx, 2, Vector(9999,0,0) )
    end
    
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), Vector(0,0,0), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    if #enemies > 0 then
        if caster:GetHealth()/caster:GetMaxHealth() < 0.5 then
            damage = 2500
        end
        for i=1, #enemies do
            if enemies[i] ~= nil and enemies[i]:FindModifierByName("mod_od_poliana_debuff") == nil then
                ability:ApplyDataDrivenModifier(caster, enemies[i], "mod_od_poliana_debuff", {duration = 5})
                local damageInfo = 
				{
					victim = enemies[i],
					attacker = caster,
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL
				}
				ApplyDamage( damageInfo )
            end
        end
    end
end