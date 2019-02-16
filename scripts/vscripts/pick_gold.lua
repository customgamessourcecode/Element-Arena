function CheckToPickGold(keys)
    local target	= keys.target
	local ability	= keys.ability
	if target:IsRealHero() then
		local drop_items=Entities:FindAllByClassnameWithin("dota_item_drop",target:GetAbsOrigin(),175)
		for _, drop_item in pairs(drop_items) do     
	      local containedItem = drop_item:GetContainedItem()
	      if containedItem and containedItem:GetName()=="item_25gold" then
            if GameRules:GetGameTime() - drop_item:GetCreationTime() > 0.5 then
              local plc = PlayerResource:GetPlayerCount()
	          local value= 280 / (plc + 2)
         	  for nPlayerID = 0, plc-1 do
				 if PlayerResource:IsValidPlayer( nPlayerID ) then
					if PlayerResource:HasSelectedHero( nPlayerID ) then
						local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
                        SendOverheadEventMessage( hero, OVERHEAD_ALERT_GOLD, hero, value, nil )
                        PlayerResource:ModifyGold(nPlayerID,value,true,DOTA_ModifyGold_Unspecified)
				    end
				 end
			   end
			   UTIL_Remove(containedItem)              
	           UTIL_Remove( drop_item )
            end
	      end
	    end
	end
end

function CheckToPickAllGold(keys)
	local caster	= keys.caster
    local drop_items=Entities:FindAllByClassnameWithin("dota_item_drop",caster:GetAbsOrigin(),99999)
	for _, drop_item in pairs(drop_items) do     
	    local containedItem = drop_item:GetContainedItem()
	    if containedItem then
            if containedItem:GetName()=="item_25gold" then
                if GameRules:GetGameTime() - drop_item:GetCreationTime() > 10 then
                    if drop_item:GetOrigin().z > caster:GetAbsOrigin().z then
                        local plc = PlayerResource:GetPlayerCount()
                        local value= (280 / (plc + 2))
                        for nPlayerID = 0, plc-1 do
                            if PlayerResource:IsValidPlayer( nPlayerID ) then
                                if PlayerResource:HasSelectedHero( nPlayerID ) then
                                local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
                                SendOverheadEventMessage( hero, OVERHEAD_ALERT_GOLD, hero, value, nil )
                                PlayerResource:ModifyGold(nPlayerID,value,true,DOTA_ModifyGold_Unspecified)
                                end
                            end
                        end
                        UTIL_Remove(containedItem)
                        UTIL_Remove( drop_item )
                    end
                end
            --else
            --    if containedItem:GetPurchaser() ~= nil then
            --        local rlcs = {
            --        "item_corrupting_blade",
            --        "item_glimmerdark_shield",
            --        "item_guardian_shell",
            --        "item_dredged_trident",
            --        "item_oblivions_locket",
            --        "item_ambient_sorcery",
            --        "item_wand_of_the_brine",
            --        "item_seal_0",
            --        "item_seal_1",
            --        "item_seal_2",
            --        "item_seal_3",
            --        "item_seal_4",
            --        "item_seal_5",
            --        "item_seal_act",
            --        "item_seal_act_r"
            --        }
            --        local est = false
            --        for k, v in pairs(rlcs) do
            --            if v == containedItem:GetName() then
            --                est = true
            --            end
            --        end
            --        if containedItem:GetName() ~= "item_tombstone" and est == false then
            --            local poin = drop_item:GetAbsOrigin()
            --            caster:AddItem(containedItem)
            --            containedItem:SetPurchaser(nil)
            --            UTIL_Remove(drop_item)
            --            --drop_item:SetContainedItem(containedItem)
            --            caster:DropItemAtPositionImmediate( containedItem, poin )
            --        end
            --    end
            end
	    end
	end
end

function CheckElements(keys)
	local caster	= keys.caster
    local drop_items=Entities:FindAllByClassnameWithin("dota_item_drop",caster:GetAbsOrigin(),99999)
	for _, drop_item in pairs(drop_items) do     
	    local containedItem = drop_item:GetContainedItem()
	    if containedItem then
            if GameRules:GetGameTime() - drop_item:GetCreationTime() > 5 then
                local est = false
                local elid = 0
                local allelements = {
                    "item_ice",
                    "item_fire",
                    "item_water",
                    "item_energy",
                    "item_earth",
                    "item_life",
                    "item_void",
                    "item_air",
                    "item_light",
                    "item_shadow"
                }
                for y=1, #allelements do
                    if containedItem:GetName()==allelements[y] then
                        est = true
                        elid = y
                        break
                    end
                end
                if est then
                    local partlist = {
                    "particles/my_new/elements/ice/doom_bringer_devour.vpcf",
                    "particles/my_new/elements/fire/doom_bringer_devour.vpcf",
                    "particles/my_new/elements/water/doom_bringer_devour.vpcf",
                    "particles/my_new/elements/energy/doom_bringer_devour.vpcf",
                    "particles/my_new/elements/earth/doom_bringer_devour.vpcf",
                    "particles/my_new/elements/life/doom_bringer_devour.vpcf",
                    "particles/my_new/elements/void/doom_bringer_devour.vpcf",
                    "particles/my_new/elements/air/doom_bringer_devour.vpcf",
                    "particles/my_new/elements/light/doom_bringer_devour.vpcf",
                    "particles/my_new/elements/shadow/doom_bringer_devour.vpcf"
                    }
                    
                    local nFXIndex = ParticleManager:CreateParticle( partlist[elid], PATTACH_ABSORIGIN, drop_item )
                    --ParticleManager:SetParticleControl( nFXIndex, 0, drop_item:GetAbsOrigin() )
                    --ParticleManager:SetParticleControl( nFXIndex, 1, containedItem:GetPurchaser():GetAbsOrigin() )
                    ParticleManager:SetParticleControlEnt( nFXIndex, 1, containedItem:GetPurchaser(), PATTACH_POINT_FOLLOW, "attach_attack1", containedItem:GetPurchaser():GetOrigin(), true )
                    ParticleManager:ReleaseParticleIndex( nFXIndex )
                    
                    local id = containedItem:GetPurchaser():GetPlayerID()
                    local myTable = CustomNetTables:GetTableValue("Elements_Tabel",tostring(id))
                    myTable[tostring(elid)] = myTable[tostring(elid)] + 1
                    CustomNetTables:SetTableValue("Elements_Tabel",tostring(id),myTable)
                    UTIL_Remove(containedItem)
                    UTIL_Remove( drop_item )
                end
            end
	    end
	end
end