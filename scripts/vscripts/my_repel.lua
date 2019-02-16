function attack_func(event)
        for key, unit in pairs(event.target_entities) do
                        local damage_taken = event.Damage
                        local return_damage = damage_taken
                        ApplyDamage({ victim = event.attacker, attacker = event.target, damage = return_damage, damage_type = DAMAGE_TYPE_MAGICAL })
                        print(damage_taken,return_damage, event.attacker, event.target)
        end
end