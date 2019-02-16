my_cent = class({})

function my_cent:OnAbilityPhaseStart()
	if IsServer() then
        self.radius = self:GetSpecialValueFor( "radius" )
		self.damage = self:GetSpecialValueFor( "damage" )
	end

	return true
end

--------------------------------------------------------------------------------

function my_cent:OnAbilityPhaseInterrupted()
	if IsServer() then
	end 
end

--------------------------------------------------------------------------------

function my_cent:GetPlaybackRateOverride()
	return 0.3
end

--------------------------------------------------------------------------------

function my_cent:OnSpellStart()
	if IsServer() then

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius-200, self.radius-200, self.radius-200 ) )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Hero_Centaur.HoofStomp", self:GetCaster() )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false then
				local damageInfo = 
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self,
				}
				ApplyDamage( damageInfo )
			end
		end
	
	end
end