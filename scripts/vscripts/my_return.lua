function OnCreated( event )
    local ability = event.ability
    local caster = event.caster
    ability:StartCooldown(5)
    caster.pos = caster:GetAbsOrigin()
end

function OnAttack( event )
    local ability = event.ability
    ability:StartCooldown(5)
end

function OnTakeDamage( event )
    local ability = event.ability
    ability:StartCooldown(5)
end

function OnIntervalThink( event )
    local caster = event.caster
    local ability = event.ability
    
    if (caster:GetAbsOrigin() - caster.pos):Length2D() > 50 then
        ability:StartCooldown(5)
    end
    
    caster.pos = caster:GetAbsOrigin()
    
    if ability:IsCooldownReady() then
        caster:SetOrigin(Entities:FindByName( nil, "spawner"):GetAbsOrigin() + RandomVector( RandomFloat( 0, 200 )))
        ability:StartCooldown(5)
    end
end