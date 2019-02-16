function OnSpellStart(event)
    local ability = event.ability
    local caster = event.caster
    
    local particle = ParticleManager:CreateParticle("particles/units/heroes/heroes_underlord/abbysal_underlord_darkrift_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(particle)
end