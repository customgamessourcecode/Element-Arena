--The class name, the file name is consistent with
my_str_debuff = class ({})
--return modifier's texture name returns the Buff icon resource name (here with Abaddon first skill icon)
function my_str_debuff:GetTexture ()
    return "undying_decay"
end

function my_str_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
 
	return funcs
end

function my_str_debuff:IsDebuff()
	return true
end

function my_str_debuff:GetModifierBonusStats_Strength( params )
	return 0-self:GetStackCount()
end