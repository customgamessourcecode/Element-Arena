my_lava_boom = class({})
LinkLuaModifier( "modifier_temple_guardian_wrath_thinker", "modifiers/modifier_temple_guardian_wrath_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
bil_neu = true
towers = {}

function my_lava_boom:OnAbilityPhaseStart()
	if IsServer() then
		self.channel_duration = self:GetSpecialValueFor( "channel_duration" )
		local fImmuneDuration = self.channel_duration + self:GetCastPoint()
        
        self.nPreviewFX = ParticleManager:CreateParticle( "particles/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 250, 250, 250 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 176, 224, 230 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function my_lava_boom:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

-----------------------------------------------------------------------------

function my_lava_boom:OnSpellStart()
	if IsServer() then	
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		self.effect_radius = self:GetSpecialValueFor( "effect_radius" )
		self.interval = self:GetSpecialValueFor( "interval" )
		self:GetCaster().castult = true
		self.flNextCast = 0.0

		EmitSoundOn( "TempleGuardian.Wrath.Cast", self:GetCaster() )
        
        towers = Entities:FindAllByModel("models/props_structures/tower_upgrade/tower_upgrade.vmdl")
        if #towers > 0 then
        local wow = 1
        while wow < #towers + 1 do
            local abil = self:GetCaster():FindAbilityByName( "my_boss_towers" )
            towers[wow]:AddNewModifier( towers[wow], self, "modifier_omninight_guardian_angel", {} )
            abil:ApplyDataDrivenModifier( self:GetCaster(), towers[wow], "mod_2_etap", {} )
            wow = wow + 1
        end
        end
        
        if self:GetCaster():FindModifierByName("modifier_boss_tower") == nil then
        local abil = self:GetCaster():FindAbilityByName( "my_boss_towers" )
        abil:ApplyDataDrivenModifier( self:GetCaster(), self:GetCaster(), "mod_2_etap", {} )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_omninight_guardian_angel", {} )
        bil_neu = false
        end
        
		--local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
		--ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.effect_radius, self.channel_duration, 0.0 ) )
		--ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

-----------------------------------------------------------------------------

function my_lava_boom:OnChannelThink( flInterval )
	if IsServer() then
		self.flNextCast = self.flNextCast + flInterval
		if self.flNextCast >= self.interval  then

			-- Try not to overlap wrath_thinker locations, but use the last position attempted if we spend too long in the loop
			local nMaxAttempts = 7
			local nAttempts = 0
			local vPos = nil

			repeat
				vPos = self:GetCaster():GetOrigin() + RandomVector( RandomInt( 50, self.effect_radius ) )
				local hThinkersNearby = Entities:FindAllByClassnameWithin( "npc_dota_thinker", vPos, 600 )
				local hOverlappingWrathThinkers = {}

				for _, hThinker in pairs( hThinkersNearby ) do
					if ( hThinker:HasModifier( "modifier_temple_guardian_wrath_thinker" ) ) then
						table.insert( hOverlappingWrathThinkers, hThinker )
					end
				end
				nAttempts = nAttempts + 1
				if nAttempts >= nMaxAttempts then
					break
				end
			until ( #hOverlappingWrathThinkers == 0 )

			CreateModifierThinker( self:GetCaster(), self, "modifier_temple_guardian_wrath_thinker", {}, vPos, self:GetCaster():GetTeamNumber(), false )
			self.flNextCast = self.flNextCast - self.interval
		end
		
	end
end

-----------------------------------------------------------------------------

function my_lava_boom:OnChannelFinish( bInterrupted )
	if IsServer() then
		self:GetCaster().castult = false
        if bil_neu == false then
		self:GetCaster():RemoveModifierByName( "modifier_omninight_guardian_angel" )
        self:GetCaster():RemoveModifierByName("mod_2_etap")
        end
        if #towers > 0 then
        local wow = 1
        while wow < #towers + 1 do
            if not towers[wow]:IsNull() then
            towers[wow]:RemoveModifierByName("modifier_omninight_guardian_angel")
            towers[wow]:RemoveModifierByName("mod_2_etap")
            end
            wow = wow + 1
        end
        end
	end
end

-----------------------------------------------------------------------------