function OnCreated(event)
    Timers:CreateTimer(0.1, function()
        local caster = event.target
        if caster ~= nil then
            if not caster:IsIllusion() then
                CustomGameEventManager:Send_ServerToAllClients( "createhp", {name="hp_bar",text = "#HPBar", svalue = caster:GetHealth(),evalue=caster:GetMaxHealth()})
                CustomGameEventManager:Send_ServerToAllClients( "refreshhpdata", {name="hp_bar",text = "#HPBar", svalue = caster:GetHealth(),evalue=caster:GetMaxHealth()})
            end
        end
    end)
end

function OnDestroy(event)
    local caster = event.target
    if caster ~= nil then
        if not caster:IsIllusion() then
            CustomGameEventManager:Send_ServerToAllClients( "removehppui", {name="hp_bar"})
        end
    end
end

function OnIntervalThink(event)
    local caster = event.target
    if caster ~= nil then
        if not caster:IsIllusion() then
            CustomGameEventManager:Send_ServerToAllClients( "refreshhpdata", {name="hp_bar",text = "#HPBar", svalue = caster:GetHealth(),evalue=caster:GetMaxHealth()})
        end
    end
end