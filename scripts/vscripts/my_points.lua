function OnCreated( event )
    local caster = event.caster
    if caster.mytarget == nil then
        local pointents = GameMode:GetPointEnts()
        for i=1,#pointents do
            if pointents[i] ~= caster then
                event.target:RemoveModifierByNameAndCaster("mod_my_points_mod_for_hero",pointents[i])
            end
        end
        caster.point_particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
        caster.point_particle2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
        GameMode:SetPointV(caster:GetBaseDamageMin(),true)
        caster.mytarget = event.target
    end
end

function OnDestroy( event )
    local caster = event.caster
    if caster ~= nil then
        if event.target == caster.mytarget then
            GameMode:SetPointV(caster:GetBaseDamageMin(),false)
            if caster.point_particle ~= nil then
                ParticleManager:DestroyParticle(caster.point_particle,false)
            end
            if caster.point_particle2 ~= nil then
                ParticleManager:DestroyParticle(caster.point_particle2,false)
            end
            caster.mytarget = nil
        end
    end
end