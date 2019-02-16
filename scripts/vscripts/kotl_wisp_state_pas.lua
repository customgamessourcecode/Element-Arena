function OnTakeDamage(event)
    if event.caster.kotl.state3 == false then
        local health = event.caster.kotl:GetHealth()-(event.DamageTaken*0.3)
        if health < 1 then
            health = 1
        end
        event.caster.kotl:SetHealth(health)
        event.caster:SetHealth(event.caster:GetMaxHealth())
    end
end