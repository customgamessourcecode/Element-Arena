my_schetchik = class({})
LinkLuaModifier( "mod_schetchik", "schetchik", LUA_MODIFIER_MOTION_NONE )

function my_schetchik:GetIntrinsicModifierName()
	return "mod_schetchik"
end

----------------------------------------------------------------------

mod_schetchik = class({})

function mod_schetchik:IsHidden() 
	return true
end

function mod_schetchik:IsPurgable()
	return false
end

function mod_schetchik:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function mod_schetchik:OnTakeDamage(event)
    if event.attacker:IsRealHero() then
        if event.attacker ~= event.unit and not event.unit:IsIllusion() and event.attacker ~= nil then
            if event.attacker.damage_schetchik == nil then
                event.attacker.damage_schetchik = 0
            end
            event.attacker.damage_schetchik = event.attacker.damage_schetchik + event.damage
        end
    else
        local own = event.attacker:GetPlayerOwnerID()
        if own ~= nil then
            local atthero = PlayerResource:GetSelectedHeroEntity(own)
            if atthero ~= nil then
                if atthero ~= event.unit and not event.unit:IsIllusion() then
                    if atthero.damage_schetchik == nil then
                        atthero.damage_schetchik = 0
                    end
                    atthero.damage_schetchik = atthero.damage_schetchik + event.damage
                end
            end
        end
    end
end