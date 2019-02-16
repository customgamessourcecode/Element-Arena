disab = class({})

function disab:CheckState()
	local state = {}
	state[MODIFIER_STATE_STUNNED] = true
    state[MODIFIER_STATE_FLYING] = true
	return state
end

function disab:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}

	return decFuncs
end

function disab:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function disab:IsPurgable() return false end
function disab:IsHidden() return true end