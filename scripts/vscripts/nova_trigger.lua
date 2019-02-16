function Triggered (event)
    caster = event.caster
    
    if caster:GetHealth() < 3 then
        caster:SetHealth(50000)
        local novaAbility = caster:FindAbilityByName( "phoenix_supernova_datadriven" )
        novaAbility:StartCooldown(9999)
        caster:RemoveModifierByName("nova_trigger")
    end
end