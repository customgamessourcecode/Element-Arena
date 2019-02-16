function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	bmail = thisEntity:FindItemInInventory( "item_blade_mail" )
	thisEntity:SetContextThink( "DarkThink", DarkThink, 1 )
end

function DarkThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    
    if thisEntity:GetHealth() > thisEntity:GetMaxHealth()-100 then
		return 0.5
	end
    bmail = thisEntity:FindItemInInventory( "item_blade_mail" )
	if bmail ~= nil then
		return castbmail()
	end
	
	return 0.5
end

function castbmail()
    print("test3")
    bmail:EndCooldown()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = bmail:entindex(),
		Queue = false,
	})
	
	return 4
end