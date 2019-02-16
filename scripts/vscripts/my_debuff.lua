function OnCreatedDebuff( event )
    local target = event.target
    target:SetModelScale(0.5)
end

function OnDestroyDebuff( event )
    local target = event.target
    target:SetModelScale(0.9)
end