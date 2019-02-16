
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
    
	thisEntity:SetContextThink( "MyKThink", MyKThink, 0.2 )
end

--------------------------------------------------------------------------------

function MyKThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end
	
    if thisEntity:FindAbilityByName( "my_kunkka_tidebringer" ):GetAutoCastState() then
        return -1
    else
        thisEntity:FindAbilityByName( "my_kunkka_tidebringer" ):ToggleAutoCast()
    end

	return 0.3
end