LinkLuaModifier("my_str_debuff","modifiers/my_str_debuff", LUA_MODIFIER_MOTION_NONE)

function OnAttack( event )
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    
    if target:FindModifierByName("my_str_debuff") == nil then
        target:AddNewModifier(target,ability,"my_str_debuff",{duration = 30})
        local modif = target:FindModifierByName("my_str_debuff")
        modif:IncrementStackCount()
    else
        local modif = target:FindModifierByName("my_str_debuff")
        modif:SetDuration(30,true)
        modif:IncrementStackCount()
    end
    
end