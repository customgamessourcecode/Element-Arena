function ice_blast_explode( keys )
    local caster = keys.caster
    local sound = keys.sound
    local explosion_particle = keys.explosion_particle
    local ice_blast_tracer_location = caster:GetAbsOrigin()
    
    
    EmitSoundOn(sound, caster)
	local particle = ParticleManager:CreateParticle(explosion_particle, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, ice_blast_tracer_location)
	ParticleManager:SetParticleControl(particle, 3, ice_blast_tracer_location)
	ParticleManager:ReleaseParticleIndex(particle)
end