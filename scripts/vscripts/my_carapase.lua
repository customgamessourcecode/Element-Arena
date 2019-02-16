function attack_func(event)
    if event.attacker ~= event.caster and not event.caster:IsIllusion() then
        local damage_taken = event.Damage
        local otrash_perc = event.Perc / 100
        local return_damage = damage_taken * otrash_perc
        if return_damage ~= 0 then
            ApplyDamage({ victim = event.attacker, attacker = event.caster, damage = return_damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, ability = event.ability})
            
            local nFXIndex = ParticleManager:CreateParticle( "particles/my_new/grimstroke_ink_swell_tick_damage.vpcf", PATTACH_ABSORIGIN, event.caster )
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, event.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", event.attacker:GetOrigin(), true )
        end
    end
end   