print ('[BAREBONES] barebones.lua' )

-- GameRules Variables
ENABLE_HERO_RESPAWN = false              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = true             -- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = false        -- Should we let people select the same hero as each other

HERO_SELECTION_TIME = 30.0              -- How long should we let people select their hero?
PRE_GAME_TIME = 10.0                    -- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0                   -- How long should we let people look at the scoreboard before closing the server automatically?
TREE_REGROW_TIME = 30.0                 -- How long should it take individual trees to respawn after being cut down/destroyed?

GOLD_PER_TICK = 0                       -- How much gold should players get per tick?
GOLD_TICK_TIME = 999999.0                      -- How long should we wait in seconds between gold ticks?

RECOMMENDED_BUILDS_DISABLED = false     -- Should we disable the recommened builds for heroes (Note: this is not working currently I believe)
CAMERA_DISTANCE_OVERRIDE = 1134.0        -- How far out should we allow the camera to go?  1134 is the default in Dota

MINIMAP_ICON_SIZE = 1                   -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1              -- What icon size should we use for runes?

RUNE_SPAWN_TIME = 120                    -- How long in seconds should we wait between rune spawns?
CUSTOM_BUYBACK_COST_ENABLED = true      -- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = true  -- Should we use a custom buyback time?
BUYBACK_ENABLED = false                 -- Should we allow people to buyback when they die?

DISABLE_FOG_OF_WAR_ENTIRELY = true      -- Should we disable fog of war entirely for both teams?
USE_STANDARD_HERO_GOLD_BOUNTY = false    -- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?

USE_CUSTOM_TOP_BAR_VALUES = true        -- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = true             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = false  -- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = true       -- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players get gold?

END_GAME_ON_KILLS = false                -- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 50         -- How many kills for a team should signify an end of game?

USE_CUSTOM_HERO_LEVELS = true           -- Should we allow heroes to have custom levels?
MAX_LEVEL = 200                          -- What level should we let heroes get to?
USE_CUSTOM_XP_VALUES = true             -- Should we use custom XP values to level up heroes, or the default Dota numbers?

ELEMENTS_CREATED = false

PlaysMaxList = {}
WinsMaxList = {}
PlaysList = {}
WinsList = {}
MyProfileArray = {}
_G.bonuses = {}
_G.bonuses[1] = {}
_G.bonuses[2] = {}
_G.bonuses[3] = {}
_G.bonuses[4] = {}
_G.bonuses[5] = {}
_G.bonuses[6] = {}
_G.bonuses[7] = {}
_G.defaultpart = {}

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {}
for i=1,MAX_LEVEL do
	XP_PER_LEVEL_TABLE[i] = i * 100
end

-- Generated from template
if GameMode == nil then
	print ( '[BAREBONES] creating barebones game mode' )
	GameMode = class({})
end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
	GameMode = self
	print('[BAREBONES] Starting to load Barebones gamemode...')

	-- Setup rules
	GameRules:SetShowcaseTime( 0.0 )
    GameRules:GetGameModeEntity():SetAnnouncerDisabled( false )
 	GameRules:GetGameModeEntity():DisableHudFlip( true )
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
	GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
	GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
	GameRules:SetPreGameTime( PRE_GAME_TIME)
	GameRules:SetPostGameTime( POST_GAME_TIME )
	GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
	GameRules:SetUseCustomHeroXPValues ( USE_CUSTOM_XP_VALUES )
	GameRules:SetGoldPerTick(GOLD_PER_TICK)
	GameRules:SetGoldTickTime(GOLD_TICK_TIME)
	GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
	GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
	GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
	GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
	GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )
    --GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 6 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
	GameRules:GetGameModeEntity():SetSelectionGoldPenaltyEnabled( false )
	GameRules:EnableCustomGameSetupAutoLaunch(true)
	GameRules:SetCustomGameSetupAutoLaunchDelay(0)
    
	print('[BAREBONES] GameRules set')

	-- Listeners - Event Hooks
	-- All of these events can potentially be fired by the game, though only the uncommented ones have had
	-- Functions supplied for them.
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GameMode, 'OnPlayerLevelUp'), self)
	ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(GameMode, 'OnAbilityChannelFinished'), self)
	ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(GameMode, 'OnPlayerLearnedAbility'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(GameMode, 'OnConnectFull'), self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(GameMode, 'OnDisconnect'), self)
	ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(GameMode, 'OnItemPurchased'), self)
	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(GameMode, 'OnItemPickedUp'), self)
	ListenToGameEvent('last_hit', Dynamic_Wrap(GameMode, 'OnLastHit'), self)
	ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(GameMode, 'OnNonPlayerUsedAbility'), self)
	ListenToGameEvent('player_changename', Dynamic_Wrap(GameMode, 'OnPlayerChangedName'), self)
	ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(GameMode, 'OnRuneActivated'), self)
	ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(GameMode, 'OnPlayerTakeTowerDamage'), self)
	ListenToGameEvent('tree_cut', Dynamic_Wrap(GameMode, 'OnTreeCut'), self)
	ListenToGameEvent('entity_hurt', Dynamic_Wrap(GameMode, 'OnEntityHurt'), self)
	ListenToGameEvent('player_connect', Dynamic_Wrap(GameMode, 'PlayerConnect'), self)
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(GameMode, 'OnAbilityUsed'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameMode, 'OnGameRulesStateChange'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, 'OnNPCSpawned'), self)
	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(GameMode, 'OnPlayerPickHero'), self)
	ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(GameMode, 'OnTeamKillCredit'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, 'OnPlayerReconnect'), self)
    
	CustomGameEventManager:RegisterListener("Vote_Round", Dynamic_Wrap(GameMode, 'Vote_Round'))
	CustomGameEventManager:RegisterListener("Buy_Relic", Dynamic_Wrap(GameMode, 'Buy_Relic'))
	CustomGameEventManager:RegisterListener("UpdateTops", Dynamic_Wrap(GameMode, 'UpdateTops'))
	CustomGameEventManager:RegisterListener("Levels", Dynamic_Wrap(GameMode, 'Levels'))
	CustomGameEventManager:RegisterListener("SelectPart", Dynamic_Wrap(GameMode, 'SelectPart'))
	CustomGameEventManager:RegisterListener("ToggleAutoVote", Dynamic_Wrap(GameMode, 'ToggleAutoVote'))
	CustomGameEventManager:RegisterListener("RefreshRelics", Dynamic_Wrap(GameMode, 'LoadRelics'))
	CustomGameEventManager:RegisterListener("Buy_Element", Dynamic_Wrap(GameMode, 'Buy_Element'))
	CustomGameEventManager:RegisterListener("UpdateProfiles", Dynamic_Wrap(GameMode, 'UpdateProfiles'))
	CustomGameEventManager:RegisterListener("SniatRS", Dynamic_Wrap(GameMode, 'SniatRS'))
	CustomGameEventManager:RegisterListener("EqipRS", Dynamic_Wrap(GameMode, 'EqipRS'))
	CustomGameEventManager:RegisterListener("PureRS", Dynamic_Wrap(GameMode, 'PureRS'))
	CustomGameEventManager:RegisterListener("SetDefaultPart", Dynamic_Wrap(GameMode, 'SetDefaultPart'))
	CustomGameEventManager:RegisterListener("SaveSet", Dynamic_Wrap(GameMode, 'SaveSet'))
	CustomGameEventManager:RegisterListener("LoadSet", Dynamic_Wrap(GameMode, 'LoadSet'))
	CustomGameEventManager:RegisterListener("SetColor", Dynamic_Wrap(GameMode, 'SetColor'))
	CustomGameEventManager:RegisterListener("UpgradeRS", Dynamic_Wrap(GameMode, 'UpgradeRS'))
    
    --GameRules:GetGameModeEntity():SetCustomTerrainWeatherEffect( "particles/rain_fx/econ_snow.vpcf" )
    GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter( Dynamic_Wrap( GameMode, "ItemAddedToInventoryFilter" ), self )
    GameRules:GetGameModeEntity():SetHudCombatEventsDisabled(true)
    
	-- Change random seed
	local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
	math.randomseed(tonumber(timeTxt))
    GameMode:GetNum("http://")
    CustomNetTables:SetTableValue("Hero_Stats","wave",{0})
    for i=0,4 do
        local tbl = {
            tdmg = 0,
            heal = 0,
            last = 0,
            ddmg = 0
        }
        CustomNetTables:SetTableValue("Hero_Stats",tostring(i),tbl)
    end

	-- Initialized tables for tracking state
	self.vUserIds = {}
	self.vSteamIds = {}
	self.vBots = {}
	self.vBroadcasters = {}

	self.vPlayers = {}
	self.vRadiant = {}
	self.vDire = {}

	self.nRadiantKills = 0
	self.nDireKills = 0

	self.bSeenWaitForPlayers = false
    
    GameRules.DropTable = LoadKeyValues("scripts/kv/item_drops.kv")
    
	-- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
	Convars:RegisterCommand( "test_command", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", 0 )
	Convars:RegisterCommand( "vote", Dynamic_Wrap(GameMode, 'MyConsVote'), "A console command example", 0 )
	Convars:RegisterCommand( "disitems", Dynamic_Wrap(GameMode, 'DisNoobsItems'), "A console command example", 0 )
	Convars:RegisterCommand( "getrelicstones", Dynamic_Wrap(GameMode, 'GetRelicStones'), "A console command example", 0 )
	Convars:RegisterCommand( "getfullrelic", Dynamic_Wrap(GameMode, 'GetFullRelic'), "A console command example", 0 )
    
    GameRules:GetGameModeEntity():SetThink( "OnThink", self, 0.25 )
    GameRules:GetGameModeEntity():SetThink( "RSThink", self, 4 )
    
	print('[BAREBONES] Done loading Barebones gamemode!\n\n')
end

function GameMode:ToggleAutoVote(event)
    PlayerResource:GetSelectedHeroEntity(event.id).autovote = event.state
end

function GameMode:Buy_Relic(event)
    if event.num == 0 then
        local hero = PlayerResource:GetSelectedHeroEntity(event.id)
        local item_list = {
            "item_corrupting_blade",
            "item_glimmerdark_shield",
            "item_guardian_shell",
            "item_dredged_trident",
            "item_oblivions_locket",
            "item_ambient_sorcery",
            "item_wand_of_the_brine",
            "item_seal_0"
        }
        if hero.relicboolarr ~= nil then
            for i=1,8 do
                if hero.relicboolarr[i] == true then
                    local itemname = item_list[i]
                    if itemname == "item_seal_0" then
                        if hero.actseal == true then
                            itemname = "item_seal_act_r"
                        end
                    end
                    local item = CreateItem(itemname, hero, hero)
                    item:SetPurchaseTime(0)
                    item:SetPurchaser( hero )
                    item.bIsRelic = true
                    hero:AddItem(item)
                    hero.relicboolarr[i] = false
                end
            end
        end
    else
        local hero = PlayerResource:GetSelectedHeroEntity(event.id)
        if hero.relicboolarr[event.num] == true then
            local itemname = event.item
            if itemname == "item_seal_0" then
                if hero.actseal == true then
                    itemname = "item_seal_act_r"
                end
            end
            local item = CreateItem(itemname, hero, hero)
            item:SetPurchaseTime(0)
            item:SetPurchaser( hero )
            item.bIsRelic = true
            EmitSoundOn( "General.Buy", hero )
            hero:AddItem(item)
            hero.relicboolarr[event.num] = false
        end
    end
end

function GameMode:Buy_Element(event)
    local myTable = CustomNetTables:GetTableValue("Elements_Tabel",tostring(event.id))
    local hero = PlayerResource:GetSelectedHeroEntity(event.id)
    local estmesto = false
    for i=0,14 do
        if hero:GetItemInSlot(i) == nil then
            estmesto = true
            break
        end
    end
    if myTable[tostring(event.num)] > 0 and estmesto == true then
        myTable[tostring(event.num)] = myTable[tostring(event.num)] - 1
        CustomNetTables:SetTableValue("Elements_Tabel",tostring(event.id),myTable)
        local itemname = allelements[event.num]
        local item = CreateItem(itemname, hero, hero)
        item:SetPurchaseTime(0)
        item:SetPurchaser( hero )
        EmitSoundOn( "General.Buy", hero )
        hero:AddItem(item)
    end
end

function GameMode:SniatRS(event)
    local hero = PlayerResource:GetSelectedHeroEntity(event.id)
    hero.rsslots[event.slotid] = ""
    local data = {}
    data.id = event.id
    GameMode:UpdateRS(event.id)
    GameMode:Levels(data)
end

function GameMode:EqipRS(event)
    local hero = PlayerResource:GetSelectedHeroEntity(event.id)
    local eqiped = false
    for i=1,8 do
        if hero.rsslots[i] == event.rsid then
            eqiped = true
            break
        end
    end
    if eqiped == false then
        local find = false
        if hero.seal == true then
            for i=1,4 do
                if hero.rsslots[i] == "" then
                    hero.rsslots[i] = event.rsid
                    find = true
                    break
                end
            end
            if find == false then
                if hero.actseal == true then
                    for i=5,8 do
                        if hero.rsslots[i] == "" then
                            hero.rsslots[i] = event.rsid
                            print(hero.rsslots[i])
                            find = true
                            break
                        end
                    end
                end
            end
        end
        --if find == true then
        --    GameMode:Levels(event)
        --end
    end
    GameMode:UpdateRS(event.id)
    GameMode:Levels(event)
end

puretimerok = true
function GameMode:PureRS(event)
    if puretimerok == true then
        puretimerok = false
        Timers:CreateTimer(30, function()
            puretimerok = true
            CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(event.id), "PureButtonReady", {})
        end)
        local hero = PlayerResource:GetSelectedHeroEntity(event.id)
        local pureok = false
        local inslot = false
        local newlist = {}
        local rspure = 0
        for k,v in pairs(event.rs) do
            for i=1,8 do
                if hero.rsslots[i] == v then
                    inslot = true
                    break
                end
            end
            for i=1,#hero.rsinv do
                if hero.rsinv[i] == v then
                    if inslot == false then
                        table.remove(hero.rsinv,i)
                        pureok = true
                    end
                    break
                end
            end
            if pureok then
                table.insert(newlist,v)
                local fchr = string.sub(v, 1, 1)
                if fchr == "1" then
                    rspure = rspure + 1
                elseif fchr == "2" then
                    rspure = rspure + 3
                elseif fchr == "3" then
                    rspure = rspure + 15
                elseif fchr == "4" then
                    rspure = rspure + 60
                end
            end
        end
        hero.rsp = hero.rsp + rspure
        if #newlist > 0 then
            local rstr = ""
            for i=1,#newlist do
                if rstr == "" then
                    rstr = rstr .. newlist[i]
                else
                    rstr = rstr .. "|" .. newlist[i]
                end
            end
            print(rstr)
            local otv = ""
            local req = CreateHTTPRequestScriptVM( "GET", GameMode.gjfll .. "000webhostapp.com/relicstones1.php")
            req:SetHTTPRequestGetOrPostParameter("id", tostring(PlayerResource:GetSteamID(event.id)))
            req:SetHTTPRequestGetOrPostParameter("rsids", rstr)
            req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKey("1"))
            req:Send(function(result)
                otv = result.Body
            end)
        end
        GameMode:UpdateRS(event.id)
        GameMode:Levels(event)
    end
end

parttimerok = true
function GameMode:SetDefaultPart(event)
    print(event.part)
    if parttimerok == true then
        parttimerok = false
        Timers:CreateTimer(30, function()
            parttimerok = true
            CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(event.id), "DefaultButtonReady", {})
        end)
        local otv = ""
        local req = CreateHTTPRequestScriptVM( "GET", GameMode.gjflk .. "000webhostapp.com/particles1.php")
        req:SetHTTPRequestGetOrPostParameter("inid", tostring(PlayerResource:GetSteamID(event.id)))
        req:SetHTTPRequestGetOrPostParameter("part", "defaults")
        req:SetHTTPRequestGetOrPostParameter("reson", tostring(event.part))
        req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKey("1"))
        req:Send(function(result)
            otv = result.Body
        end)
    end
end

sevesettimerok = true
function GameMode:SaveSet(event)
    if sevesettimerok == true then
        sevesettimerok = false
        Timers:CreateTimer(30, function()
            sevesettimerok = true
            CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(event.id), "ReadySetButton", {})
        end)
        local hero = PlayerResource:GetSelectedHeroEntity(event.id)
        local rstr = ""
        for i=1,8 do
            if i ~= 8 then
                rstr = rstr .. hero.rsslots[i] .. "|"
            else
                rstr = rstr .. hero.rsslots[i]
            end
        end
        hero.rssaves[tonumber(event.num)] = rstr
        local req = CreateHTTPRequestScriptVM( "GET", GameMode.gjfll .. "000webhostapp.com/relicstones1.php")
        req:SetHTTPRequestGetOrPostParameter("id", tostring(PlayerResource:GetSteamID(event.id)))
        req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKey("1"))
        req:SetHTTPRequestGetOrPostParameter("savenum", tostring(event.num))
        req:SetHTTPRequestGetOrPostParameter("slots", rstr)
        req:Send(function(result)
            print(result.Body)
        end)
        GameMode:UpdateRS(event.id)
        GameMode:Levels(event)
    end
end

function GameMode:UpgradeRS(event)
    local hero = PlayerResource:GetSelectedHeroEntity(event.id)
    for i=1,#hero.rsinv do
        if hero.rsinv[i] == event.rs then
            local rares = string.sub(event.rs, 1, 1)
            local qual = string.sub(event.rs, 8, 8)
            if qual ~= "5" and rares == "4" then
                local cost = 0
                if     qual == "0" then cost = 40
                elseif qual == "1" then cost = 80
                elseif qual == "2" then cost = 160
                elseif qual == "3" then cost = 320
                elseif qual == "4" then cost = 640
                end
                if hero.rsp >= cost then
                    hero.rsinv[i] = string.sub(event.rs, 1, 7) .. tonumber(qual)+1 .. string.sub(event.rs, 9)
                    hero.rsp = hero.rsp - cost
                    local otv = ""
                    local req = CreateHTTPRequestScriptVM( "GET", GameMode.gjfll .. "000webhostapp.com/relicstones1.php")
                    req:SetHTTPRequestGetOrPostParameter("id", tostring(PlayerResource:GetSteamID(event.id)))
                    req:SetHTTPRequestGetOrPostParameter("uprsid", event.rs)
                    req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKey("1"))
                    req:Send(function(result)
                        otv = result.Body
                        --print(otv)
                    end)
                end
            end
            GameMode:Levels(event)
            break
        end
    end
end

function GameMode:SetColor(event)
    local hero = PlayerResource:GetSelectedHeroEntity(event.id)
        if event.colorid ~= 1 then
        for i=1,#hero.sealcolors do
            if hero.sealcolors[i] == event.colorid then
                hero.sealcolor = event.colorid
                break
            end
        end
    else
        hero.sealcolor = event.colorid
    end
    print(hero.sealcolor)
end

function GameMode:LoadSet(event)
    local hero = PlayerResource:GetSelectedHeroEntity(event.id)
    local thisslots = {}
    hero.rsslots = {"","","","","","","",""}
    for token in string.gmatch(hero.rssaves[tonumber(event.num)].."|", "([^|]*)|") do
        local moshnoadd = true
        local estininv = false
        for i=1,#hero.rsinv do
            if hero.rsinv[i] == token then
                estininv = true
                break
            end
        end
        for i=1,8 do
            if hero.rsslots[i] == token then
                moshnoadd = false
                break
            end
        end
        if moshnoadd == true and estininv == true then
            table.insert(thisslots,token)
        else
            table.insert(thisslots,"")
        end
    end
    if #thisslots == 8 then
        hero.rsslots = thisslots
    end
    GameMode:UpdateRS(event.id)
    GameMode:Levels(event)
end

for i=1,6 do
    if i<10 then
        LinkLuaModifier( "immortal_mod_0" .. i, "modifiers/immortal_mods", LUA_MODIFIER_MOTION_NONE )
    else
        LinkLuaModifier( "immortal_mod_" .. i, "modifiers/immortal_mods", LUA_MODIFIER_MOTION_NONE )
    end
end

function GameMode:UpdateRS(id)
    local hero = PlayerResource:GetSelectedHeroEntity(id)
    _G.bonuses[1][id] = 0
    _G.bonuses[2][id] = 0
    _G.bonuses[3][id] = 0
    _G.bonuses[4][id] = 0
    _G.bonuses[5][id] = 0
    _G.bonuses[6][id] = 0
    _G.bonuses[7][id] = 0
    local colors = {}
    print("StartLoad")
    for i=1,8 do
        if hero.immortalbuffs[i] ~= nil then
            hero:RemoveModifierByName(hero.immortalbuffs[i])
            hero.immortalbuffs[i] = nil
        end
        if hero.rsslots[i] ~= "" then
            table.insert(colors,tonumber(string.sub(hero.rsslots[i], 2, 2))+2)
            local lclarr = {
                {0.005,0.0015,0.001,0.0025,0.0015,0.0015,0.0025},
                {0.01,0.0025,0.0015,0.005,0.0025,0.0025,0.005},
                {0.01,0.0025,0.0015,0.005,0.0025,0.0025,0.005},
                {
                    {0.01,0.0025,0.0015,0.005,0.0025,0.0025,0.005},
                    {0.012,0.003,0.0018,0.006,0.003,0.003,0.006},
                    {0.014,0.0035,0.0021,0.007,0.0035,0.0035,0.007},
                    {0.016,0.004,0.0024,0.008,0.004,0.004,0.008},
                    {0.018,0.0045,0.0027,0.009,0.0045,0.0045,0.009},
                    {0.02,0.005,0.003,0.01,0.005,0.005,0.01}}
            }
            if string.sub(hero.rsslots[i], 4, 4) ~= "0" then
                local relicid = tonumber(string.sub(hero.rsslots[i], 4, 4))
                if relicid ~= 0 then
                    if string.sub(hero.rsslots[i], 1, 1) == "4" then
                        _G.bonuses[relicid][id] = _G.bonuses[relicid][id] + lclarr[tonumber(string.sub(hero.rsslots[i], 1, 1))][tonumber(string.sub(hero.rsslots[i], 8, 8))+1][relicid]
                    else
                        _G.bonuses[relicid][id] = _G.bonuses[relicid][id] + lclarr[tonumber(string.sub(hero.rsslots[i], 1, 1))][relicid]
                    end
                end
            end
            if string.sub(hero.rsslots[i], 5, 5) ~= "0" then
                local relicid = tonumber(string.sub(hero.rsslots[i], 5, 5))
                if relicid ~= 0 then
                    if string.sub(hero.rsslots[i], 1, 1) == "4" then
                        _G.bonuses[relicid][id] = _G.bonuses[relicid][id] + lclarr[tonumber(string.sub(hero.rsslots[i], 1, 1))][tonumber(string.sub(hero.rsslots[i], 8, 8))+1][relicid]
                    else
                        _G.bonuses[relicid][id] = _G.bonuses[relicid][id] + lclarr[tonumber(string.sub(hero.rsslots[i], 1, 1))][relicid]
                    end
                end
            end
            if string.sub(hero.rsslots[i], 6, 7) ~= "00" then
                print("immortal_mod_" .. string.sub(hero.rsslots[i], 6, 7))
                hero:AddNewModifier(hero, nil, "immortal_mod_" .. string.sub(hero.rsslots[i], 6, 7), {})
                hero.immortalbuffs[i] = "immortal_mod_" .. string.sub(hero.rsslots[i], 6, 7)
            end
        end
    end
    local estcolor = false
    for i=1,#colors do
        if colors[i] == hero.sealcolor then
            estcolor = true
        end
    end
    if estcolor == false then
        hero.sealcolor = 1
    end
    hero.sealcolors = colors
    local modifs = hero:FindAllModifiers()
    for b=1, #modifs do
        if modifs[b]:GetAbility() ~= nil then
            if modifs[b].needupwawe then
                modifs[b]:OnWaweChange(_G.GAME_ROUND)
            end
        end
    end
end

function GameMode:RSThink()
    CustomGameEventManager:Send_ServerToAllClients( "RSUIInterval", {})
   return 4
end

 function GameMode:OnThink()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        
        --for i=0, PlayerResource:GetPlayerCount()-1 do
        --    local cinstt = PlayerResource:GetConnectionState(i)
        --    if cinstt ~= connecting[i] then
        --        if cinstt == 2 then
        --            Timers:RemoveTimer("disconnected" .. tostring(i))
        --        else
        --            Timers:CreateTimer("disconnected" .. tostring(i), {
        --            useGameTime = true,
        --            endTime = 300,
        --            callback = function()
        --                local hero = PlayerResource:GetSelectedHeroEntity(i)
        --                for y=0, 14, 1 do
        --                    local current_item = hero:GetItemInSlot(y)
        --                    if current_item ~= nil then
        --                        hero:DropItemAtPositionImmediate( current_item, hero:GetAbsOrigin() )
        --                    end
        --                end
        --            end})
        --        end
        --        connecting[i] = cinstt
        --    end
        --end
        
		self:_CheckForDefeat()
        if self._currentRound ~= nil then
			self._currentRound:Think()
			if self._currentRound:IsFinished() then
				self._currentRound:End()
				self._currentRound = nil
				-- Heal all players
				self:_RefreshPlayers()

				self._nRoundNumber = self._nRoundNumber + 1
				if self._nRoundNumber > #self._vRounds then
					self._nRoundNumber = 1
				else
					self._flPrepTimeEnd = GameRules:GetGameTime() + self._flPrepTimeBetweenRounds
				end
			end
		end
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then		-- Safe guard catching any state that may exist beyond DOTA_GAMERULES_STATE_POST_GAME
		return nil
	end
	return 1
 end

 function GameMode:_RefreshPlayers()
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if not hero:IsAlive() then
                    hero:SetRespawnPosition(heroes[i]:GetOrigin())
                    hero:RespawnHero( false, false )
				end
				hero:SetHealth( hero:GetMaxHealth() )
				hero:SetMana( hero:GetMaxMana() )
			end
		end
	end
end

function GameMode:_CheckForDefeat()
	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		return
	end

	local bAllPlayersDead = true
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hero and hero:IsAlive() then
					bAllPlayersDead = false
				end
			end
		end
	end

	if bAllPlayersDead then
        local plc = PlayerResource:GetPlayerCount()
        for i=0,plc-1 do
            local sch = PlayerResource:GetSelectedHeroEntity(i).damage_schetchik
            if sch == nil then
                sch = 0
            end
            local tbl = {
                tdmg = PlayerResource:GetCreepDamageTaken(i,true),
                heal = PlayerResource:GetHealing(i),
                last = PlayerResource:GetLastHits(i),
                ddmg = math.ceil(sch)
            }
            CustomNetTables:SetTableValue("Hero_Stats",tostring(i),tbl)
        end
        GameMode:_Stats(nil)
		GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
		return
	end
end

mode = nil

-- This function is called 1 to 2 times as the player connects initially but before they
-- have completely connected
function GameMode:PlayerConnect(keys)
	print('[BAREBONES] PlayerConnect')
	DeepPrintTable(keys)

	if keys.bot == 1 then
		-- This user is a Bot, so add it to the bots table
		self.vBots[keys.userid] = 1
	end
    
    --Timers:RemoveTimer("disconnected" .. tostring(keys.userid))
    
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
	print ('[BAREBONES] OnConnectFull')
	DeepPrintTable(keys)
	GameMode:CaptureGameMode()

	local entIndex = keys.index+1
	-- The Player entity of the joining user
	local ply = EntIndexToHScript(entIndex)

	-- The Player ID of the joining player
	local playerID = ply:GetPlayerID()

	-- Update the user ID table with this user
	self.vUserIds[keys.userid] = ply

	-- Update the Steam ID table
	self.vSteamIds[PlayerResource:GetSteamAccountID(playerID)] = ply

	-- If the player is a broadcaster flag it in the Broadcasters table
	if PlayerResource:IsBroadcaster(playerID) then
		self.vBroadcasters[keys.userid] = 1
		return
	end
end

-- This function is called as the first player loads and sets up the GameMode parameters
function GameMode:CaptureGameMode()
	if mode == nil then
		-- Set GameMode parameters
		mode = GameRules:GetGameModeEntity()
		mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
		mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
		mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
		mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
		mode:SetBuybackEnabled( BUYBACK_ENABLED )
		mode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
		mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
		mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
		mode:SetCustomHeroMaxLevel ( MAX_LEVEL )
		mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

		--mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
		mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

		mode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
		mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
		mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )
        mode:SetLoseGoldOnDeath( false )
        
        mode:SetHUDVisible(1,true)
        mode:SetHUDVisible(4,false)
        mode:SetHUDVisible(9, false)
        
		self:OnFirstPlayerLoaded()
	end
end

-- This is an example console command
function GameMode:ExampleConsoleCommand(srt , int)
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
        if srt ~= nil and int ~= nil then
            local item = CreateItem(srt, nil, nil)
            item:SetPurchaseTime(0)
            local pos = PlayerResource:GetSelectedHeroEntity(cmdPlayer:GetPlayerID()):GetAbsOrigin()
            local drop = CreateItemOnPositionSync( pos, item )
            item:SetPurchaser( PlayerResource:GetSelectedHeroEntity(tonumber(int)) )
        end
	end
end

function GameMode:GetRelicStones(id , int)
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
        if id ~= nil and int ~= nil then
            
        end
	end
end

function GameMode:GetFullRelic(strid)
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
        if strid ~= nil then
            local id = tonumber(strid)
            local hero = PlayerResource:GetSelectedHeroEntity(id)
            hero.lvl_item_corrupting_blade = 20
            hero.lvl_item_glimmerdark_shield = 20
            hero.lvl_item_guardian_shell = 20
            hero.lvl_item_dredged_trident = 20
            hero.lvl_item_oblivions_locket = 20
            hero.lvl_item_ambient_sorcery = 20
            hero.lvl_item_wand_of_the_brine = 20
            hero.lvl_item_seal_0 = 1
            hero.rsinv = ""
            hero.rsp = 0
            hero.rsslots = ""
            hero.rssaves = ""
            
            local relicboolarr = {
                true,
                true,
                true,
                true,
                true,
                true,
                true,
                true
            }
            hero.seal = true
            hero.actseal = true
            hero.relicboolarr = relicboolarr
            local data = {}
            data.id = id
            GameMode:Levels(data)
        end
	end
end

LinkLuaModifier( "disab", "modifiers/disab", LUA_MODIFIER_MOTION_NONE )
function GameMode:DisNoobsItems(int)
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
        if int ~= nil then
            local hero = PlayerResource:GetSelectedHeroEntity(tonumber(int))
            hero:AddNewModifier(hero, nil, "disab", {duration = 10})
            for i=0, 14, 1 do
                local current_item = hero:GetItemInSlot(i)
                if current_item ~= nil then
                    hero:DropItemAtPositionImmediate( current_item, hero:GetAbsOrigin() )
                end
            end
        end
	end
end

function GameMode:MyConsVote(int)
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
        if int ~= nil then
            local eve = {
            hero = PlayerResource:GetSelectedHeroEntity(tonumber(int)):GetName()
            }
            GameMode:Vote_Round(eve)
        end
	end
end

--[[
  This function should be used to set up Async precache calls at the beginning of the game.  The Precache() function 
  in addon_game_mode.lua used to and may still sometimes have issues with client's appropriately precaching stuff.
  If this occurs it causes the client to never precache things configured in that block.
  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.
  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).
]]
function GameMode:PostLoadPrecache()
	print("[BAREBONES] Performing Post-Load precache")

end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
	print("[BAREBONES] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
	print("[BAREBONES] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.
  The hero parameter is the hero entity that just spawned in.
]]
function GameMode:OnHeroInGame(hero)
	print("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

	-- Store a reference to the player handle inside this hero handle.
	hero.player = PlayerResource:GetPlayer(hero:GetPlayerID())
	-- Store the player's name inside this hero handle.
	hero.playerName = PlayerResource:GetPlayerName(hero:GetPlayerID())
	-- Store this hero handle in this table.
	table.insert(self.vPlayers, hero)

	-- This line for example will set the starting gold of every hero to 500 unreliable gold
	hero:SetGold(475, false)
end

--[[
	This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
	gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
	is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgressF()
	print("[BAREBONES] The game has officially begun")
end

-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
	print('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
	DeepPrintTable(keys)
    
	local name = keys.name
	local networkid = keys.networkid
	local reason = keys.reason
	local userid = keys.userid
    
    --[[
    Timers:CreateTimer("disconnected" .. tostring(userid), {
	useGameTime = true,
    endTime = 30,
    callback = function()
        local hero = PlayerResource:GetSelectedHeroEntity(userid-1)
        for i=0, 14, 1 do
            local current_item = hero:GetItemInSlot(i)
            if current_item ~= nil then
                hero:DropItemAtPositionImmediate( current_item, hero:GetAbsOrigin() )
            end
        end
    end})
    ]]
    
end

-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
	print("[BAREBONES] GameRules State Changed")
	DeepPrintTable(keys)

	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		for i = 0, PlayerResource:GetPlayerCount()-1 do
			PlayerResource:SetCustomTeamAssignment(i, DOTA_TEAM_GOODGUYS)
		end
	elseif newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
		self.bSeenWaitForPlayers = true
	elseif newState == DOTA_GAMERULES_STATE_INIT then
		Timers:RemoveTimer("alljointimer")
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		local et = 6
		if self.bSeenWaitForPlayers then
			et = .01
		end
		Timers:CreateTimer("alljointimer", {
			useGameTime = true,
			endTime = et,
			callback = function()
				if PlayerResource:HaveAllPlayersJoined() then
					GameMode:PostLoadPrecache()
					GameMode:OnAllPlayersLoaded()
					return
				end
				return 1
			end})
            
--###########################################################################################################################################################
        
        local req12 = CreateHTTPRequestScriptVM( "GET", GameMode.gjflk .. "000webhostapp.com/maxwins1.php")
        req12:Send(function(result)
            local otvwins = result.Body
            print(otvwins)
            if otvwins ~= "" then
                if otvwins ~= "none" then
                    local locstr = ""
                    local arrstr = {}
                    for n=1, string.len(otvwins) do
                        if string.char(string.byte(otvwins, n)) ~= nil then
                            if string.char(string.byte(otvwins, n)) == " " then
                                table.insert(arrstr, locstr)
                                locstr = ""
                            else
                                locstr = locstr .. string.char(string.byte(otvwins, n))
                            end
                        end
                    end
                    if locstr ~= "" then
                        table.insert(arrstr, locstr)
                        locstr = ""
                    end
                    local value = arrstr
                    print("Wins Loaded")
                    GameMode:OnWinsLoad(value)
                end
            end
        end)
        local req22 = CreateHTTPRequestScriptVM( "GET", GameMode.gjflk .. "000webhostapp.com/maxplays1.php")
        req22:Send(function(result)
            local otvplays = result.Body
            print(otvplays)
            if otvplays ~= "" then
                if otvplays ~= "none" then
                    local locstr = ""
                    local arrstr = {}
                    for n=1, string.len(otvplays) do
                        if string.char(string.byte(otvplays, n)) ~= nil then
                            if string.char(string.byte(otvplays, n)) == " " then
                                table.insert(arrstr, locstr)
                                locstr = ""
                            else
                                locstr = locstr .. string.char(string.byte(otvplays, n))
                            end
                        end
                    end
                    if locstr ~= "" then
                        table.insert(arrstr, locstr)
                        locstr = ""
                    end
                    local value = arrstr
                    print("Plays Loaded")
                    GameMode:OnPlaysLoad(value)
                end
            end
        end)
        
--###########################################################################################################################################################
        
    local pplc = PlayerResource:GetPlayerCount()
    for i=0,pplc-1 do
        print("Steam" .. i .. " " .. tostring(PlayerResource:GetSteamID(i)))
        local req = CreateHTTPRequestScriptVM( "GET", GameMode.gjflk .. "000webhostapp.com/particles1.php")
        req:SetHTTPRequestGetOrPostParameter("id", tostring(PlayerResource:GetSteamID(i)))
        req:SetHTTPRequestGetOrPostParameter("v", "1")
        req:Send(function(result)
            local potv = result.Body
            if potv ~= "" then
                print(potv)
                    local locstr = ""
                    local arrstr = {}
                    for n=1, string.len(potv) do
                        if string.char(string.byte(potv, n)) ~= nil then
                            if string.char(string.byte(potv, n)) == "|" then
                                table.insert(arrstr, locstr)
                                locstr = ""
                            else
                                locstr = locstr .. string.char(string.byte(potv, n))
                            end
                        end
                    end
                    if locstr ~= "" then
                        table.insert(arrstr, locstr)
                        locstr = ""
                    end
                    if arrstr[#arrstr] == "allok" then
                        arrstr[#arrstr] = nil
                        _G.defaultpart[i] = arrstr[#arrstr]
                        arrstr[#arrstr] = nil
                        local value = arrstr
                        CustomNetTables:SetTableValue("Particles_Tabel",tostring(i),value)
                    end
            end
        end)
        local req2 = CreateHTTPRequestScriptVM( "GET", GameMode.gjflk .. "000webhostapp.com/getprofile1.php")
        req2:SetHTTPRequestGetOrPostParameter("id", tostring(PlayerResource:GetSteamID(i)))
        req2:Send(function(result)
            local potv = result.Body
            if potv ~= "" then
                print(potv)
                    local locstr = ""
                    local arrstr = {i}
                    for n=1, string.len(potv) do
                        if string.char(string.byte(potv, n)) ~= nil then
                            if string.char(string.byte(potv, n)) == "|" then
                                table.insert(arrstr, locstr)
                                locstr = ""
                            else
                                locstr = locstr .. string.char(string.byte(potv, n))
                            end
                        end
                    end
                    if locstr ~= "" then
                        table.insert(arrstr, locstr)
                        locstr = ""
                    end
                    if arrstr[#arrstr] == "allok" then
                        arrstr[#arrstr] = nil
                        local value = arrstr
                        MyProfileArray[i] = value;
                        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(i), "MyProfileInfo", value)
                    end
            end
        end)
    end
           
--###########################################################################################################################################################
           
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		GameMode:OnGameInProgress()
        local pplc = PlayerResource:GetPlayerCount()
        for i=0,pplc-1 do
            if _G.defaultpart[i] ~= nil and _G.defaultpart[i] ~= "" and PlayerResource:GetConnectionState(i) == 2 then
                if PlayerResource:GetSelectedHeroEntity(i):FindModifierByName("part_mod") == nil then
                    local parts = CustomNetTables:GetTableValue("Particles_Tabel",tostring(i))
                    if parts[_G.defaultpart[i]] ~= "nill" then
                        --Say(nil,"text here", false)
                        --GameRules:SendCustomMessage("<font color='#58ACFA'> использовал эффект </font>"..info.name.."#partnote".." test", 0, 0)
                        local arr = {
                            i,
                            PlayerResource:GetPlayerName(i),
                            _G.defaultpart[i],
                            PlayerResource:GetSelectedHeroName(i)
                        }
                
                        CustomGameEventManager:Send_ServerToAllClients( "UpdateParticlesUI", arr)
                        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(i), "SetSelectedParticles", arr)
                        PlayerResource:GetSelectedHeroEntity(i):AddNewModifier(PlayerResource:GetSelectedHeroEntity(i), PlayerResource:GetSelectedHeroEntity(i), "part_mod", {part = _G.defaultpart[i]})
                    end
                end
            end
        end
	end
    
    if newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
        local point = Entities:FindByName( nil, "spawner"):GetAbsOrigin()
        local unit = CreateUnitByName( "npc_dota_gold_spirit", point, true, nil, nil, DOTA_TEAM_GOODGUYS )
        for i=0, DOTA_MAX_TEAM_PLAYERS do
            if PlayerResource:IsValidPlayer(i) then
                if PlayerResource:HasSelectedHero(i) == false then

                    local player = PlayerResource:GetPlayer(i)
                    player:MakeRandomHeroSelection()

                    local hero_name = PlayerResource:GetSelectedHeroName(i)
                end
            end
        end
    end
end

function GameMode:NeedSteamIds(data)
    local result = {}
    for i=0,PlayerResource:GetPlayerCount()-1 do
        local arr = {
            PlayerResource:GetSteamID(i),
            PlayerResource:GetSelectedHeroName(i)
        }
        result[i] = arr;
    end
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(data.id), "SteamIds", result)
end

LinkLuaModifier( "modifier_imba_generic_talents_handler", "modifier/generic_talents/modifier_imba_generic_talents_handler", LUA_MODIFIER_MOTION_NONE )
-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
	print("[BAREBONES] NPC Spawned")
	DeepPrintTable(keys)
	local npc = EntIndexToHScript(keys.entindex)
    
	if npc:IsRealHero() and npc.bFirstSpawned == nil then
        npc.bFirstSpawned = true
        npc.immortalbuffs = {}
        npc:AddExperience(100,1,false,false)
		npc:AddNewModifier(npc, nil, "modifier_imba_generic_talents_handler", {})
        GameMode:CheckWearables(npc)
		GameMode:OnHeroInGame(npc)
        local id = npc:GetPlayerID()
        _G.bonuses[1][id] = 0
        _G.bonuses[2][id] = 0
        _G.bonuses[3][id] = 0
        _G.bonuses[4][id] = 0
        _G.bonuses[5][id] = 0
        _G.bonuses[6][id] = 0
        _G.bonuses[7][id] = 0
        npc.sealcolor = 1
        Timers:CreateTimer(1, function()
            local info = {}
            info.id = id
            GameMode:LoadRelics(info)
        end)
        value = {}
        value[1] = 1
        value[2] = 1
        value[3] = 1
        value[4] = 1
        value[5] = 1
        value[6] = 1
        value[7] = 1
        value[8] = 1
        value[9] = 1
        value[10] = 1
        CustomNetTables:SetTableValue("Elements_Tabel",tostring(id),value)
	end
end

function GameMode:LoadRelics(info)
    local needrefresh = true
        print("Start Load")
        local i = info.id
        print("Steam" .. i .. " " .. tostring(PlayerResource:GetSteamID(i)))
        local req = CreateHTTPRequestScriptVM( "GET", GameMode.gjfll .. "000webhostapp.com/lol21.php")
        req:SetHTTPRequestGetOrPostParameter("id", tostring(PlayerResource:GetSteamID(i)))
        req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKey("1"))
        req:Send(function(result)
            local otv = result.Body
            if otv ~= "" then
                if otv ~= "none" then
                    local locstr = ""
                    local arrstr = {}
                    print(i .. " = " .. otv)
                    for n=1, string.len(otv) do
                        if string.char(string.byte(otv, n)) ~= nil then
                            if string.char(string.byte(otv, n)) == " " then
                                table.insert(arrstr, locstr)
                                locstr = ""
                            else
                                locstr = locstr .. string.char(string.byte(otv, n))
                            end
                        end
                    end
                    if locstr ~= "" then
                        table.insert(arrstr, locstr)
                        locstr = ""
                    end
                    if arrstr[#arrstr] == "allok" then
                        needrefresh = false
                        arrstr[#arrstr] = nil
                        local value = arrstr

                        local seal = true
                        local actseal = true
                        local relicboolarr = {
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false
                        }
                        --####################################
                        local selectheroo = PlayerResource:GetSelectedHeroEntity(i)
                        if tonumber(value[1]) > 0 then
                            selectheroo.lvl_item_corrupting_blade = tonumber(value[1])
                            relicboolarr[1] = true
                            if tonumber(value[1]) < 20 then
                                actseal = false
                            end
                        else
                            seal = false
                            actseal = false
                            value[1] = nil
                        end
                        if tonumber(value[2]) > 0 then
                            selectheroo.lvl_item_glimmerdark_shield = tonumber(value[2])
                            relicboolarr[2] = true
                            if tonumber(value[2]) < 20 then
                                actseal = false
                            end
                        else
                            seal = false
                            actseal = false
                            value[2] = nil
                        end
                        if tonumber(value[3]) > 0 then
                            selectheroo.lvl_item_guardian_shell = tonumber(value[3])
                            relicboolarr[3] = true
                            if tonumber(value[3]) < 20 then
                                actseal = false
                            end
                        else
                            seal = false
                            actseal = false
                            value[3] = nil
                        end
                        if tonumber(value[4]) > 0 then
                            selectheroo.lvl_item_dredged_trident = tonumber(value[4])
                            relicboolarr[4] = true
                            if tonumber(value[4]) < 20 then
                                actseal = false
                            end
                        else
                            seal = false
                            actseal = false
                            value[4] = nil
                        end
                        if tonumber(value[5]) > 0 then
                            selectheroo.lvl_item_oblivions_locket = tonumber(value[5])
                            relicboolarr[5] = true
                            if tonumber(value[5]) < 20 then
                                actseal = false
                            end
                        else
                            seal = false
                            actseal = false
                            value[5] = nil
                        end
                        if tonumber(value[6]) > 0 then
                            selectheroo.lvl_item_ambient_sorcery = tonumber(value[6])
                            relicboolarr[6] = true
                            if tonumber(value[6]) < 20 then
                                actseal = false
                            end
                        else
                            seal = false
                            actseal = false
                            value[6] = nil
                        end
                        if tonumber(value[7]) > 0 then
                            selectheroo.lvl_item_wand_of_the_brine = tonumber(value[7])
                            relicboolarr[7] = true
                            if tonumber(value[7]) < 20 then
                                actseal = false
                            end
                        else
                            seal = false
                            actseal = false
                            value[7] = nil
                        end
                        if tonumber(value[8]) > 0 then
                            selectheroo.lvl_item_seal_0 = tonumber(value[8])
                            relicboolarr[8] = true
                        else
                            seal = false
                            actseal = false
                            value[8] = nil
                        end
                        --####################################
                        selectheroo.seal = seal
                        selectheroo.actseal = actseal
                        selectheroo.relicboolarr = relicboolarr
                        selectheroo.sealcolors = {}
                        local arrstr2 = {}
                        for n=1, string.len(value[18]) do
                            if string.char(string.byte(value[18], n)) ~= nil then
                                if string.char(string.byte(value[18], n)) == "|" then
                                    table.insert(arrstr2, locstr)
                                    locstr = ""
                                else
                                    locstr = locstr .. string.char(string.byte(value[18], n))
                                end
                            end
                        end
                        if locstr ~= "" then
                            table.insert(arrstr2, locstr)
                            locstr = ""
                        end
                        selectheroo.rsinv = arrstr2
                        selectheroo.rsp = tonumber(value[9])
                        selectheroo.rsslots = {"","","","","","","",""}
                        selectheroo.rssaves = {value[10],value[11],value[12],value[13],value[14],value[15],value[16],value[17]}
                        local data = {}
                        data.id = i
                        data.num = 1
                        GameMode:LoadSet(data)
                        if selectheroo.rsslots[1] ~= "" then
                            selectheroo.sealcolor = tonumber(string.sub(selectheroo.rsslots[1], 2, 2))+2
                        else
                            selectheroo.sealcolor = 1
                        end
                        GameMode:Levels(data)
                    end
                else
                    needrefresh = false
                    local selectheroo = PlayerResource:GetSelectedHeroEntity(i)
                    selectheroo.nullrelics = true
                end
            end
        end)
        
    Timers:CreateTimer(10, function()
        if needrefresh then
            CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(i), "NeedRefresh", {})
        end
    end)
end
-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
	--print("[BAREBONES] Entity Hurt")
	--DeepPrintTable(keys)
	local entCause = EntIndexToHScript(keys.entindex_attacker)
	local entVictim = EntIndexToHScript(keys.entindex_killed)
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
	print ( '[BAREBONES] OnItemPurchased' )
	DeepPrintTable(keys)

	local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local itemname = keys.itemname
    
    if itemname == "item_25gold" then
		local plc = PlayerResource:GetPlayerCount()
        local value = (280 / (plc + 2))
        for nPlayerID = 0, plc-1 do
            if PlayerResource:IsValidPlayer( nPlayerID ) then
				if PlayerResource:HasSelectedHero( nPlayerID ) then
					local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
                    SendOverheadEventMessage( hero, OVERHEAD_ALERT_GOLD, hero, value, nil )
                    PlayerResource:ModifyGold(nPlayerID,value,true,DOTA_ModifyGold_Unspecified)
				end
            end
		end
        if not itemEntity:IsNull() then
            itemEntity:Destroy()
        end
    else
        GameMode:Check()
    end
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)
	print ( '[BAREBONES] OnPlayerReconnect' )
	DeepPrintTable(keys)
    local ttime = GameMode:GetTimeToWave()
    if ttime > 1 then
        if ttime < 60 then
            local heroes = GameMode:GetAllRealHeroes()
            if #heroes == 1 then
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetSelectedHeroEntity(keys.PlayerID), "Display_RoundVote", {hero1=heroes[1]:GetName(),hero2="",hero3="",hero4="",hero5=""})
            elseif #heroes == 2 then
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetSelectedHeroEntity(keys.PlayerID), "Display_RoundVote", {hero1=heroes[1]:GetName(),hero2=heroes[2]:GetName(),hero3="",hero4="",hero5=""})
            elseif #heroes == 3 then
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetSelectedHeroEntity(keys.PlayerID), "Display_RoundVote", {hero1=heroes[1]:GetName(),hero2=heroes[2]:GetName(),hero3=heroes[3]:GetName(),hero4="",hero5=""})
            elseif #heroes == 4 then
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetSelectedHeroEntity(keys.PlayerID), "Display_RoundVote", {hero1=heroes[1]:GetName(),hero2=heroes[2]:GetName(),hero3=heroes[3]:GetName(),hero4=heroes[4]:GetName(),hero5=""})
            elseif #heroes >= 5 then
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetSelectedHeroEntity(keys.PlayerID), "Display_RoundVote", {hero1=heroes[1]:GetName(),hero2=heroes[2]:GetName(),hero3=heroes[3]:GetName(),hero4=heroes[4]:GetName(),hero5=heroes[5]:GetName()})
            end
        end
    end
end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
	print ( '[BAREBONES] OnItemPurchased' )
	DeepPrintTable(keys)

	-- The playerID of the hero who is buying something
	local plyID = keys.PlayerID
	if not plyID then return end

	-- The name of the item purchased
	local itemName = keys.itemname

	-- The cost of the item purchased
	local itemcost = keys.itemcost

end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
	print('[BAREBONES] AbilityUsed')
	DeepPrintTable(keys)

	local player = EntIndexToHScript(keys.PlayerID)
	local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
	print('[BAREBONES] OnNonPlayerUsedAbility')
	DeepPrintTable(keys)

	local abilityname=  keys.abilityname
    
    if abilityname == "elder_titan_echo_stomp" then
        local caster = EntIndexToHScript(keys.caster_entindex)
        local bkb_abil = caster:FindAbilityByName( "my_bkb" )
        
		bkb_abil:ApplyDataDrivenModifier( caster, caster, "my_black_king_bar", {duration = 1.8} )
    elseif abilityname == "phoenix_sun_ray_datadriven" then
        local caster = EntIndexToHScript(keys.caster_entindex)
        local bkb_abil = caster:FindAbilityByName( "my_bkb" )
        
		bkb_abil:ApplyDataDrivenModifier( caster, caster, "my_black_king_bar", {duration = 6.1} )
    end
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
	print('[BAREBONES] OnPlayerChangedName')
	DeepPrintTable(keys)

	local newName = keys.newname
	local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility( keys)
	print ('[BAREBONES] OnPlayerLearnedAbility')
	DeepPrintTable(keys)

	local player = EntIndexToHScript(keys.player)
	local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
	print ('[BAREBONES] OnAbilityChannelFinished')
	DeepPrintTable(keys)

	local abilityname = keys.abilityname
	local interrupted = keys.interrupted == 1
end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)
	print ('[BAREBONES] OnPlayerLevelUp')
	DeepPrintTable(keys)

	local player = EntIndexToHScript(keys.player)
	local level = keys.level
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
	print ('[BAREBONES] OnLastHit')
	DeepPrintTable(keys)

	--local isFirstBlood = keys.FirstBlood == 1
	--local isHeroKill = keys.HeroKill == 1
	--local isTowerKill = keys.TowerKill == 1
	--local player = PlayerResource:GetPlayer(keys.PlayerID)
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
	print ('[BAREBONES] OnTreeCut')
	DeepPrintTable(keys)

	local treeX = keys.tree_x
	local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated (keys)
	print ('[BAREBONES] OnRuneActivated')
	DeepPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local rune = keys.rune

end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
	print ('[BAREBONES] OnPlayerTakeTowerDamage')
	DeepPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local damage = keys.damage
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)
	print ('[BAREBONES] OnPlayerPickHero')
	DeepPrintTable(keys)

	local heroClass = keys.hero
	local heroEntity = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
    if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        for i=0, 8, 1 do
            local current_item = heroEntity:GetItemInSlot(i)
            if current_item ~= nil then
                heroEntity:RemoveItem(current_item)
            end
        end
    end
    local current_item = heroEntity:GetItemInSlot(15)
    if current_item ~= nil then
        if current_item:GetName() == "item_tpscroll" then
            heroEntity:RemoveItem(current_item)
        end
    end
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
	print ('[BAREBONES] OnTeamKillCredit')
	DeepPrintTable(keys)

	--local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
	--local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
	--local numKills = keys.herokills

	--local killerTeamNumber = keys.teamnumber
end

-- An entity died
function GameMode:OnEntityKilled( keys )
	print( '[BAREBONES] OnEntityKilled Called' )
	DeepPrintTable( keys )

	-- The Unit that was Killed
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
    
    local plc = PlayerResource:GetPlayerCount()
    --if killedUnit:GetUnitLabel() == "npc_dota_custom_creep_35_1" and plc < 5 then
    --    GameMode:_Stats("")
        --Timers:CreateTimer(0.1, function()
        --    GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
        --end)
    --end
    
    if killedUnit:GetUnitLabel() == "npc_dota_custom_creep_50_1" then
        GameMode:_Stats("1")
        for i=0,plc-1 do
            local sch = PlayerResource:GetSelectedHeroEntity(i).damage_schetchik
            if sch == nil then
                sch = 0
            end
            local tbl = {
                tdmg = PlayerResource:GetCreepDamageTaken(i,true),
                heal = PlayerResource:GetHealing(i),
                last = PlayerResource:GetLastHits(i),
                ddmg = math.ceil(sch)
            }
            CustomNetTables:SetTableValue("Hero_Stats",tostring(i),tbl)
        end
        Timers:CreateTimer(0.1, function()
            GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
        end)
    end
    
	-- The Killing entity
	local killerEntity = nil

	if keys.entindex_attacker ~= nil then
		killerEntity = EntIndexToHScript( keys.entindex_attacker )
	end
    
	if killedUnit and killedUnit:IsRealHero() then
		local newItem = CreateItem( "item_tombstone", killedUnit, killedUnit )
		newItem:SetPurchaseTime( 0 )
		newItem:SetPurchaser( killedUnit )
		local tombstone = SpawnEntityFromTableSynchronous( "dota_item_tombstone_drop", {} )
		tombstone:SetContainedItem( newItem )
		tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )
		FindClearSpaceForUnit( tombstone, killedUnit:GetAbsOrigin(), true )	
	end
    
    if killedUnit:GetTeam() == 3 and killedUnit:GetName() == "npc_dota_creature" then
        local test1 = Entities:FindAllByName("npc_dota_creature")
        local nextwave = true
        if #test1 ~= nil and #test1 ~= 0 then
            for b=1,#test1 do
                if test1[b]:GetTeam() == 3 and test1[b]:IsAlive() == true then
                    nextwave = false
                end
            end
        end
        Timers:CreateTimer(0.01, function()
        local test1 = Entities:FindAllByName("npc_dota_creature")
        if #test1 ~= nil and #test1 ~= 0 then
            for b=1,#test1 do
                if test1[b]:GetTeam() == 3 and test1[b]:IsAlive() == true then
                    nextwave = false
                end
            end
        end
        if nextwave == true then
            GameMode:OnGameInProgress()
        end
        end)
        if not killedUnit:IsIllusion() then
            getxp = killedUnit:GetBaseDayTimeVisionRange()
            if getxp > 0 then
                local heroes = GameMode:GetAllRealHeroes()
                for i=1, #heroes do
                    heroes[i]:AddExperience((getxp / #heroes)*(1-(0.05*(5 - #heroes))),false,false)
                end
            end
        end
    end

    if killedUnit:IsCreature() then
        RollDrops(killedUnit)
        if not GameRules:IsCheatMode() then
            if killedUnit:GetUnitLabel() == "npc_dota_custom_creep_5_1" then
                for i=0,plc-1 do
                    local pl = PlayerResource:GetSelectedHeroEntity(i)
                    if pl.nullrelics == true then
                        local rlcsfd = {
                            "item_corrupting_blade",
                            "item_glimmerdark_shield",
                            "item_guardian_shell",
                            "item_dredged_trident",
                            "item_oblivions_locket",
                            "item_ambient_sorcery",
                            "item_wand_of_the_brine"
                        }
                        local item_name = rlcsfd[RandomInt(1, #rlcsfd)]
                        local item = CreateItem(item_name, nil, nil)
                        item:SetPurchaseTime(0)
                        local pos = killedUnit:GetAbsOrigin()
                        local drop = CreateItemOnPositionSync( pos, item )
                        local pos_launch = pos+RandomVector(RandomFloat(100,125))
                        item:LaunchLoot(false, 200, 0.75, pos_launch)
                        item.bIsRelic = true
                        local itemKV = item:GetAbilityKeyValues()
                        item:SetPurchaser( pl )
                        local otv = ""
                        local req = CreateHTTPRequestScriptVM( "GET", GameMode.gjfll .. "000webhostapp.com/lol21.php")
                        req:SetHTTPRequestGetOrPostParameter("id", tostring(PlayerResource:GetSteamID(pl)))
                        req:SetHTTPRequestGetOrPostParameter("name", item_name)
                        req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKey("1"))
                        req:Send(function(result)
                            otv = result.Body
                        end)
                    end
                end
            end
        end
    end
	-- Put code here to handle when an entity gets killed
end


allelements = {
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
needdropel = {}

function RollDrops(unit)
    local DropInfo = GameRules.DropTable[unit:GetUnitName()]
    if DropInfo then
        for k,ItemTable in pairs(DropInfo) do
            local chance = ItemTable.Chance or 100
            local max_drops = ItemTable.Multiple or 1
            local item_name = ItemTable.Item
            local item_relict = ItemTable.Relict
            for i=1,max_drops do
                if item_name ~= "item_25gold" then
                    if item_relict == 1 then
                        if not GameRules:IsCheatMode() then
                            if RollPercentage(chance*PlayerResource:GetPlayerCount()) then
                                local item = CreateItem(item_name, nil, nil)
                                item:SetPurchaseTime(0)
                                local pos = unit:GetAbsOrigin()
                                local drop = CreateItemOnPositionSync( pos, item )
                                local pos_launch = pos+RandomVector(RandomFloat(100,125))
                                item:LaunchLoot(false, 200, 0.75, pos_launch)
                                item.bIsRelic = true
                                local itemKV = item:GetAbilityKeyValues()
                                local PlayerIDs = {}
                                print( "CDungeon:OnRelicSpawned - New Relic " .. item:GetAbilityName() .. " created." )
                                local Heroes = HeroList:GetAllHeroes()
                                for _,Hero in pairs ( Heroes ) do
                                    if Hero ~= nil and Hero:IsRealHero() and Hero:HasOwnerAbandoned() == false and PlayerResource:GetConnectionState(Hero:GetPlayerID()) == 2 then
                                        print( "CDungeon:OnRelicSpawned - PlayerID " .. Hero:GetPlayerID() .. " does not own item, adding to grant list." )
                                        table.insert( PlayerIDs, Hero:GetPlayerID() )
                                    end
                                end

                                local WinningPlayerID = -1
                                if #PlayerIDs == 1 then
                                    WinningPlayerID = PlayerIDs[1]
                                else
                                    WinningPlayerID = PlayerIDs[ RandomInt( 1, #PlayerIDs ) ]
                                    print( "CDungeon:OnRelicSpawned - " .. #PlayerIDs .. " players have not yet found an artifact, winner is player ID " .. WinningPlayerID )
                                end

                                if WinningPlayerID == -1 or WinningPlayerID == nil then
                                    print( "CDungeon:OnRelicSpawned - ERROR - WinningPlayerID is invalid." )
                                    return
                                end
                                
                                local WinningHero = PlayerResource:GetSelectedHeroEntity( WinningPlayerID )
                                local WinningSteamID = PlayerResource:GetSteamID( WinningPlayerID )

                                print( "CDungeon:OnRelicSpawned - Relic " .. item:GetAbilityName() .. " has been bound to " .. WinningPlayerID )
                                item:SetPurchaser( WinningHero )
                                
                                if item_name == "item_corrupting_blade" then
                                    if WinningHero.lvl_item_corrupting_blade ~= nil then
                                        WinningHero.lvl_item_corrupting_blade = WinningHero.lvl_item_corrupting_blade + 1
                                    else
                                        WinningHero.lvl_item_corrupting_blade = 1
                                    end
                                end
                                if item_name == "item_glimmerdark_shield" then
                                    if WinningHero.lvl_item_glimmerdark_shield ~= nil then
                                        WinningHero.lvl_item_glimmerdark_shield = WinningHero.lvl_item_glimmerdark_shield + 1
                                    else
                                        WinningHero.lvl_item_glimmerdark_shield = 1
                                    end
                                end
                                if item_name == "item_guardian_shell" then
                                    if WinningHero.lvl_item_guardian_shell ~= nil then
                                        WinningHero.lvl_item_guardian_shell = WinningHero.lvl_item_guardian_shell + 1
                                    else
                                        WinningHero.lvl_item_guardian_shell = 1
                                    end
                                end
                                if item_name == "item_dredged_trident" then
                                    if WinningHero.lvl_item_dredged_trident ~= nil then
                                        WinningHero.lvl_item_dredged_trident = WinningHero.lvl_item_dredged_trident + 1
                                    else
                                        WinningHero.lvl_item_dredged_trident = 1
                                    end
                                end
                                if item_name == "item_oblivions_locket" then
                                    if WinningHero.lvl_item_oblivions_locket ~= nil then
                                        WinningHero.lvl_item_oblivions_locket = WinningHero.lvl_item_oblivions_locket + 1
                                    else
                                        WinningHero.lvl_item_oblivions_locket = 1
                                    end
                                end
                                if item_name == "item_ambient_sorcery" then
                                    if WinningHero.lvl_item_ambient_sorcery ~= nil then
                                    WinningHero.lvl_item_ambient_sorcery = WinningHero.lvl_item_ambient_sorcery + 1
                                    else
                                        WinningHero.lvl_item_ambient_sorcery = 1
                                    end
                                end
                                if item_name == "item_wand_of_the_brine" then
                                    if WinningHero.lvl_item_wand_of_the_brine ~= nil then
                                        WinningHero.lvl_item_wand_of_the_brine = WinningHero.lvl_item_wand_of_the_brine + 1
                                    else
                                        WinningHero.lvl_item_wand_of_the_brine = 1
                                    end
                                end
                                
                                --EmitSoundOn( "Hero_LegionCommander.Duel.Victory", WinningHero )
                                --local Relic = {}
                                --Relic["DungeonItemDef"] = itemKV["DungeonItemDef"]
                                --Relic["DungeonAction"] = itemKV["DungeonAction"]
                                --Relic["SteamID"] = WinningSteamID
                                --Relic["PlayerID"] = WinningPlayerID
                                --table.insert( self.RelicsFound, Relic )
                                local otv = ""
                                local req = CreateHTTPRequestScriptVM( "GET", GameMode.gjfll .. "000webhostapp.com/lol21.php")
                                req:SetHTTPRequestGetOrPostParameter("id", tostring(WinningSteamID))
                                req:SetHTTPRequestGetOrPostParameter("name", item_name)
                                req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKey("1"))
                                req:Send(function(result)
                                    otv = result.Body
                                end)
                            end
                        end
                    else
                        if item_name == "RS" then
                            if not GameRules:IsCheatMode() then
                                if RollPercentage(chance*PlayerResource:GetPlayerCount()) then
                                    local PlayerIDs = {}
                                    local Heroes = HeroList:GetAllHeroes()
                                    for _,Hero in pairs ( Heroes ) do
                                        if Hero ~= nil and Hero:IsRealHero() and Hero:HasOwnerAbandoned() == false and PlayerResource:GetConnectionState(Hero:GetPlayerID()) == 2 then
                                            table.insert( PlayerIDs, Hero:GetPlayerID() )
                                        end
                                    end
    
                                    local WinningPlayerID = -1
                                    if #PlayerIDs == 1 then
                                        WinningPlayerID = PlayerIDs[1]
                                    else
                                        WinningPlayerID = PlayerIDs[ RandomInt( 1, #PlayerIDs ) ]
                                    end
                                    if WinningPlayerID == -1 or WinningPlayerID == nil then
                                        print( "CDungeon:OnRelicSpawned - ERROR - WinningPlayerID is invalid." )
                                        return
                                    end
                                    
                                    local WinningHero = PlayerResource:GetSelectedHeroEntity( WinningPlayerID )
                                    local WinningSteamID = PlayerResource:GetSteamID( WinningPlayerID )
                                    local ininvid = ""
                                    if WinningHero.rsinv ~= nil then
                                        if #WinningHero.rsinv > 99 then
                                            ininvid = tostring(#WinningHero.rsinv)
                                        elseif #WinningHero.rsinv > 9 then
                                            ininvid = "0"..tostring(#WinningHero.rsinv)
                                        elseif #WinningHero.rsinv > -1 then
                                            ininvid = "00"..tostring(#WinningHero.rsinv)
                                        end
                                    else
                                        ininvid = "001"
                                    end


                                    local rares = ItemTable.Rares
                                    if rares == 0 then
                                        local rsid = "1"..RandomInt(0,9)..RandomInt(1,3)..RandomInt(1,7).."0000"..ininvid
                                        if WinningHero.rsinv ~= nil then
                                            table.insert(WinningHero.rsinv,rsid)
                                        else
                                            WinningHero.rsinv = {rsid}
                                        end
                                        CustomGameEventManager:Send_ServerToAllClients( "AddRSUI", {rsid = rsid,hero = WinningHero:GetName()})
                                        local otv = ""
                                        local req = CreateHTTPRequestScriptVM( "GET", GameMode.gjfll .. "000webhostapp.com/relicstones1.php")
                                        req:SetHTTPRequestGetOrPostParameter("id", tostring(WinningSteamID))
                                        req:SetHTTPRequestGetOrPostParameter("rsid", rsid)
                                        req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKey("1"))
                                        req:Send(function(result)
                                            otv = result.Body
                                        end)
                                    elseif rares == 1 then
                                        local rsid = RandomInt(1,2)..RandomInt(0,9)..RandomInt(1,3)..RandomInt(1,7).."0000"..ininvid
                                        if WinningHero.rsinv ~= nil then
                                            table.insert(WinningHero.rsinv,rsid)
                                        else
                                            WinningHero.rsinv = {rsid}
                                        end
                                        CustomGameEventManager:Send_ServerToAllClients( "AddRSUI", {rsid = rsid,hero = WinningHero:GetName()})
                                        local otv = ""
                                        local req = CreateHTTPRequestScriptVM( "GET", GameMode.gjfll .. "000webhostapp.com/relicstones1.php")
                                        req:SetHTTPRequestGetOrPostParameter("id", tostring(WinningSteamID))
                                        req:SetHTTPRequestGetOrPostParameter("rsid", rsid)
                                        req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKey("1"))
                                        req:Send(function(result)
                                            otv = result.Body
                                        end)
                                    elseif rares == 2 then
                                        local rsid = "2"..RandomInt(0,9)..RandomInt(1,3)..RandomInt(1,7).."0000"..ininvid
                                        if WinningHero.rsinv ~= nil then
                                            table.insert(WinningHero.rsinv,rsid)
                                        else
                                            WinningHero.rsinv = {rsid}
                                        end
                                        CustomGameEventManager:Send_ServerToAllClients( "AddRSUI", {rsid = rsid,hero = WinningHero:GetName()})
                                        local otv = ""
                                        local req = CreateHTTPRequestScriptVM( "GET", GameMode.gjfll .. "000webhostapp.com/relicstones1.php")
                                        req:SetHTTPRequestGetOrPostParameter("id", tostring(WinningSteamID))
                                        req:SetHTTPRequestGetOrPostParameter("rsid", rsid)
                                        req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKey("1"))
                                        req:Send(function(result)
                                            otv = result.Body
                                        end)
                                    elseif rares == 3 then
                                        local rrr = RandomInt(1,3)
                                        local secstat = 0
                                        if rrr == 3 then
                                            secstat = RandomInt(1,7)
                                        end
                                        local rsid = rrr..RandomInt(0,9)..RandomInt(1,3)..RandomInt(1,7)..secstat.."000"..ininvid
                                        if WinningHero.rsinv ~= nil then
                                            table.insert(WinningHero.rsinv,rsid)
                                        else
                                            WinningHero.rsinv = {rsid}
                                        end
                                        CustomGameEventManager:Send_ServerToAllClients( "AddRSUI", {rsid = rsid,hero = WinningHero:GetName()})
                                        local otv = ""
                                        local req = CreateHTTPRequestScriptVM( "GET", GameMode.gjfll .. "000webhostapp.com/relicstones1.php")
                                        req:SetHTTPRequestGetOrPostParameter("id", tostring(WinningSteamID))
                                        req:SetHTTPRequestGetOrPostParameter("rsid", rsid)
                                        req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKey("1"))
                                        req:Send(function(result)
                                            otv = result.Body
                                        end)
                                    elseif rares == 4 then
                                        local rrr = RandomInt(2,3)
                                        local secstat = 0
                                        if rrr == 3 then
                                            secstat = RandomInt(1,7)
                                        end
                                        local rsid = rrr..RandomInt(0,9)..RandomInt(1,3)..RandomInt(1,7)..secstat.."000"..ininvid
                                        if WinningHero.rsinv ~= nil then
                                            table.insert(WinningHero.rsinv,rsid)
                                        else
                                            WinningHero.rsinv = {rsid}
                                        end
                                        CustomGameEventManager:Send_ServerToAllClients( "AddRSUI", {rsid = rsid,hero = WinningHero:GetName()})
                                        local otv = ""
                                        local req = CreateHTTPRequestScriptVM( "GET", GameMode.gjfll .. "000webhostapp.com/relicstones1.php")
                                        req:SetHTTPRequestGetOrPostParameter("id", tostring(WinningSteamID))
                                        req:SetHTTPRequestGetOrPostParameter("rsid", rsid)
                                        req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKey("1"))
                                        req:Send(function(result)
                                            otv = result.Body
                                        end)
                                    elseif rares == 5 then
                                        local rsid = "3"..RandomInt(0,9)..RandomInt(1,3)..RandomInt(1,7)..RandomInt(1,7).."000"..ininvid
                                        if WinningHero.rsinv ~= nil then
                                            table.insert(WinningHero.rsinv,rsid)
                                        else
                                            WinningHero.rsinv = {rsid}
                                        end
                                        CustomGameEventManager:Send_ServerToAllClients( "AddRSUI", {rsid = rsid,hero = WinningHero:GetName()})
                                        local otv = ""
                                        local req = CreateHTTPRequestScriptVM( "GET", GameMode.gjfll .. "000webhostapp.com/relicstones1.php")
                                        req:SetHTTPRequestGetOrPostParameter("id", tostring(WinningSteamID))
                                        req:SetHTTPRequestGetOrPostParameter("rsid", rsid)
                                        req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKey("1"))
                                        req:Send(function(result)
                                            otv = result.Body
                                        end)
                                    elseif rares == 6 then

                                    elseif rares == 7 then

                                    elseif rares == 8 then

                                    elseif rares == 9 then
                                        local stat1 = RandomInt(1,7)
                                        local stat2 = RandomInt(1,6)
                                        if stat2 > stat1 then
                                            stat2 = stat2 + 1
                                        end
                                        local modid = RandomInt(1,5)
                                        if modid < 10 then
                                            modid = "0" .. modid
                                        end
                                        local rsid = "4"..RandomInt(0,9)..RandomInt(1,3)..stat1..stat2..modid..RandomInt(0,2)..ininvid
                                        if WinningHero.rsinv ~= nil then
                                            table.insert(WinningHero.rsinv,rsid)
                                        else
                                            WinningHero.rsinv = {rsid}
                                        end
                                        CustomGameEventManager:Send_ServerToAllClients( "AddRSUI", {rsid = rsid,hero = WinningHero:GetName()})
                                        local otv = ""
                                        local req = CreateHTTPRequestScriptVM( "GET", GameMode.gjfll .. "000webhostapp.com/relicstones1.php")
                                        req:SetHTTPRequestGetOrPostParameter("id", tostring(WinningSteamID))
                                        req:SetHTTPRequestGetOrPostParameter("rsid", rsid)
                                        req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKey("1"))
                                        req:Send(function(result)
                                            otv = result.Body
                                        end)
                                    end
                                end
                            end
                        elseif item_name == "all_elements" then
                            for z=0, PlayerResource:GetPlayerCount()-1 do
                                local myTable = CustomNetTables:GetTableValue("Elements_Tabel",tostring(z))
                                for y=1, 10 do
                                    myTable[tostring(y)] = myTable[tostring(y)] + 1
                                    --local item = CreateItem(allelements[y], nil, nil)
                                    --item:SetPurchaseTime(0)
                                    --local rotationAngle = 0 - 45 - (36 * y)
                                    --local relPos = Vector( 0, 300, 0 )
                                    --relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )
                                    --local absPos = GetGroundPosition( relPos + casterOrigin, newSpirit )
                                    --newSpirit:SetAbsOrigin( absPos )
                                    --local pos = unit:GetAbsOrigin()
                                    --CreateItemOnPositionSync( relPos, item )
                                end
                                CustomNetTables:SetTableValue("Elements_Tabel",tostring(z),myTable)
                            end
                        else
                            local randomel = true
                            if randomel == true then
                                if #needdropel == 0 then
                                    for y=1,#allelements do
                                        table.insert(needdropel, allelements[y])
                                    end
                                end
                                local rand = RandomInt( 1, #needdropel )
                                item_name = needdropel[rand]
                                table.remove(needdropel, rand)
                            end
                            for z=0, PlayerResource:GetPlayerCount()-1 do
                                local myTable = CustomNetTables:GetTableValue("Elements_Tabel",tostring(z))
                                for y=1, #allelements do
                                    if allelements[y] == item_name then
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
                                        
                                        local nFXIndex = ParticleManager:CreateParticle( partlist[y], PATTACH_ABSORIGIN, unit )
                                        --ParticleManager:SetParticleControl( nFXIndex, 0, drop_item:GetAbsOrigin() )
                                        --ParticleManager:SetParticleControl( nFXIndex, 1, containedItem:GetPurchaser():GetAbsOrigin() )
                                        ParticleManager:SetParticleControlEnt( nFXIndex, 1, PlayerResource:GetSelectedHeroEntity(z), PATTACH_POINT_FOLLOW, "attach_attack1", PlayerResource:GetSelectedHeroEntity(z):GetOrigin(), true )
                                        ParticleManager:ReleaseParticleIndex( nFXIndex )
                                        
                                        myTable[tostring(y)] = myTable[tostring(y)] + 1
                                        CustomNetTables:SetTableValue("Elements_Tabel",tostring(z),myTable)
                                        break
                                    end
                                end
                            end
                                --local item = CreateItem(item_name, nil, nil)
                                --item:SetPurchaseTime(0)
                                --local pos = unit:GetAbsOrigin()
                                --local drop = CreateItemOnPositionSync( pos, item )
                                --local pos_launch = pos+RandomVector(RandomFloat(150,200))
                                --item:LaunchLoot(false, 0, 0, pos_launch)
                        end
                    end
                else
                    if RollPercentage(chance) then
                        local item = CreateItem(item_name, nil, nil)
                        item:SetPurchaseTime(0)
                        local pos = unit:GetAbsOrigin()
                        local drop = CreateItemOnPositionSync( pos, item )
                        local pos_launch = pos+RandomVector(RandomFloat(150,200))
                        item:LaunchLoot(false, 200, 0.75, pos_launch)
                    end
                end
            end
        end
    end
end

function GameMode:GetElementCol( hero )
    local elements = {
    item_ice = 1,
    item_fire = 1,
    item_water = 1,
    item_energy = 1,
    item_earth = 1,
    item_life = 1,
    item_void = 1,
    item_air = 1,
    item_light = 1,
    item_shadow = 1
    }
    local elementcol = 0
    
    for y=0, 14, 1 do
        local current_item = hero:GetItemInSlot(y)
        if current_item ~= nil then
            if elements[current_item:GetName()] == 1 then
                elementcol = elementcol + 1
            end
        end
    end
        
    print(elementcol)
    return elementcol
end

function GameMode:ItemAddedToInventoryFilter( filterTable )
	if filterTable["item_entindex_const"] == nil then 
		return true
	end

 	if filterTable["inventory_parent_entindex_const"] == nil then
		return true
	end

	local hItem = EntIndexToHScript( filterTable["item_entindex_const"] )
	local hInventoryParent = EntIndexToHScript( filterTable["inventory_parent_entindex_const"] )
    
    --[[
    local elements = {
    item_ice = 1,
    item_fire = 1,
    item_water = 1,
    item_energy = 1,
    item_earth = 1,
    item_life = 1,
    item_void = 1,
    item_air = 1,
    item_light = 1,
    item_shadow = 1
    }
    
    if PlayerResource:GetPlayerCount() > 1 then
        Timers:CreateTimer(0.1,function()
            local elementcol = GameMode:GetElementCol( hInventoryParent )
            if elementcol > 0 then
                Timers:CreateTimer(11 - elementcol,function()
                    local nowelementcol = GameMode:GetElementCol( hInventoryParent )
                    if elementcol >= nowelementcol then
                        for y=0, 14, 1 do
                            local current_item = hInventoryParent:GetItemInSlot(y)
                            if current_item ~= nil then
                                if elements[current_item:GetName()] == 1 then
                                    hInventoryParent:DropItemAtPositionImmediate( current_item, hInventoryParent:GetAbsOrigin() )
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
    ]]
	if hItem ~= nil and hInventoryParent ~= nil and hItem:GetAbilityName() ~= "item_tombstone" and hInventoryParent:IsRealHero() then
        local rlcs = {
        "item_corrupting_blade",
        "item_glimmerdark_shield",
        "item_guardian_shell",
        "item_dredged_trident",
        "item_oblivions_locket",
        "item_ambient_sorcery",
        "item_wand_of_the_brine",
        "item_seal_0",
        "item_seal_1",
        "item_seal_2",
        "item_seal_3",
        "item_seal_4",
        "item_seal_5",
        "item_seal_act",
        "item_seal_act_r"
        }
        local est = false
        for k, v in pairs(rlcs) do
            if v == hItem:GetAbilityName() then
                est = true
            end
        end
        if est == false then
            local notforall = {
            "item_ice",
            "item_fire",
            "item_water",
            "item_energy",
            "item_earth",
            "item_life",
            "item_void",
            "item_air",
            "item_light",
            "item_shadow",
            "item_ice_essence",
            "item_fire_essence",
            "item_water_essence",
            "item_energy_essence",
            "item_earth_essence",
            "item_life_essence",
            "item_void_essence",
            "item_air_essence",
            "item_light_essence",
            "item_shadow_essence",
            "item_ice_dummy",
            "item_fire_dummy",
            "item_water_dummy",
            "item_energy_dummy",
            "item_earth_dummy",
            "item_life_dummy",
            "item_void_dummy",
            "item_air_dummy",
            "item_light_dummy",
            "item_shadow_dummy",
            "item_upgraded_mjollnir",
            "item_upgraded_heart",
            "item_upgraded_greater_crit",
            "item_upgraded_satanic",
            "item_upgraded_pipe",
            "item_upgraded_desolator",
            "item_upgraded_diffusal_blade",
            "item_upgraded_sange_and_yasha",
            "item_upgraded_butterfly",
            "item_upgraded_monkey_king_bar",
            "item_light_fire_earth",
            "item_light_life_ice",
            "item_air_earth_shadow",
            "item_air_life_void",
            "item_air_fire_life",
            "item_energy_fire_void",
            "item_energy_shadow_water",
            "item_energy_earth_water",
            "item_energy_void_ice",
            "item_energy_light_air",
            "item_energy_life_fire",
            "item_fire_earth_water",
            "item_water_life_shadow",
            "item_light_water_void",
            "item_ice_air_water",
            "item_light_life_earth",
            "item_shadow_light_ice",
            "item_ice_shadow_air",
            "item_void_fire_shadow",
            "item_void_ice_earth",
            "item_air_void_water",
            "item_air_fire_light",
            "item_air_earth_energy",
            "item_void_shadow_water",
            "item_water_ice_fire",
            "item_void_light_life",
            "item_earth_shadow_life",
            "item_shadow_energy_light",
            "item_ice_fire_earth",
            "item_ice_life_energy",
            "item_light_fire_earth_2",
            "item_light_life_ice_2",
            "item_air_earth_shadow_2",
            "item_air_life_void_2",
            "item_air_fire_life_2",
            "item_energy_fire_void_2",
            "item_energy_shadow_water_2",
            "item_energy_earth_water_2",
            "item_energy_void_ice_2",
            "item_energy_light_air_2",
            "item_energy_life_fire_2",
            "item_fire_earth_water_2",
            "item_water_life_shadow_2",
            "item_light_water_void_2",
            "item_ice_air_water_2",
            "item_light_life_earth_2",
            "item_shadow_light_ice_2",
            "item_ice_shadow_air_2",
            "item_void_fire_shadow_2",
            "item_void_ice_earth_2",
            "item_air_void_water_2",
            "item_air_fire_light_2",
            "item_air_earth_energy_2",
            "item_void_shadow_water_2",
            "item_water_ice_fire_2",
            "item_void_light_life_2",
            "item_earth_shadow_life_2",
            "item_shadow_energy_light_2",
            "item_ice_fire_earth_2",
            "item_ice_life_energy_2",
            "item_light_fire_earth_3",
            "item_light_life_ice_3",
            "item_air_earth_shadow_3",
            "item_air_life_void_3",
            "item_air_fire_life_3",
            "item_energy_fire_void_3",
            "item_energy_shadow_water_3",
            "item_energy_earth_water_3",
            "item_energy_void_ice_3",
            "item_energy_light_air_3",
            "item_energy_life_fire_3",
            "item_fire_earth_water_3",
            "item_water_life_shadow_3",
            "item_light_water_void_3",
            "item_ice_air_water_3",
            "item_light_life_earth_3",
            "item_shadow_light_ice_3",
            "item_ice_shadow_air_3",
            "item_void_fire_shadow_3",
            "item_void_ice_earth_3",
            "item_air_void_water_3",
            "item_air_fire_light_3",
            "item_air_earth_energy_3",
            "item_void_shadow_water_3",
            "item_water_ice_fire_3",
            "item_void_light_life_3",
            "item_earth_shadow_life_3",
            "item_shadow_energy_light_3",
            "item_ice_fire_earth_3",
            "item_ice_life_energy_3",
            "item_power_dagon",
            "item_fire_radiance",
            "item_life_greaves",
            "item_fire_desol",
            "item_water_butterfly",
            "item_shivas_shield",
            "item_energy_sphere",
            "item_water_blades",
            "item_energy_core",
            "item_power_satanic",
            "item_heart_of_light",
            "item_earth_cuirass",
            "item_dragon_staff",
            "item_earth_s_and_y",
            "item_ice_pipe",
            "item_fire_core",
            "item_solar_crest_of_void",
            "item_talisman_of_atos",
            "item_urn_of_life",
            "item_skadi_bow",
            "item_monkey_king_bow",
            "item_mystery_cyclone",
            "item_kingsbane",
            "item_energy_veil",
            "item_vampire_robe",
            "item_mana_blade",
            "item_ice_aluneth",
            "item_my_crit",
            "item_cuirass_of_life",
            "item_hammer_of_god"
            }
            local est2 = false
            for k, v in pairs(notforall) do
                if v == hItem:GetAbilityName() then
                    est2 = true
                end
            end
            if est2 == false then
                hItem:SetPurchaser( hInventoryParent )
            else
                if hItem:GetPurchaser() ~= hInventoryParent then
                    Timers:CreateTimer(0.01,function()
                        hInventoryParent:DropItemAtPositionImmediate( hItem, hInventoryParent:GetAbsOrigin() )
                    end)
                end
            end
        else
            if hItem:GetPurchaser() ~= hInventoryParent then
                Timers:CreateTimer(0.01,function()
                    hInventoryParent:DropItemAtPositionImmediate( hItem, hInventoryParent:GetAbsOrigin() )
                end)
            else
                if hItem:GetAbilityName() == "item_seal_1" or hItem:GetAbilityName() == "item_seal_act" then
                    local rlcsfd = {
                    "item_corrupting_blade",
                    "item_glimmerdark_shield",
                    "item_guardian_shell",
                    "item_dredged_trident",
                    "item_oblivions_locket",
                    "item_ambient_sorcery",
                    "item_wand_of_the_brine",
                    "item_seal_0",
                    "item_seal_act_r",
                    "item_seal_1",
                    "item_seal_act"
                    }
                    for i=0, 8, 1 do
                        local current_item = hInventoryParent:GetItemInSlot(i)
                        if current_item ~= nil then
                            local ono = false
                            for k, v in pairs(rlcsfd) do
                                if v == current_item:GetAbilityName() then
                                    ono = true
                                    break
                                end
                            end
                            if ono == true then
                                hInventoryParent:RemoveItem(current_item)
                            end
                        end
                    end
                else
                    local estseal = false
                    for i=0, 8, 1 do
                        local current_item = hInventoryParent:GetItemInSlot(i)
                        if current_item ~= nil then
                            if current_item:GetAbilityName() == "item_seal_1" or current_item:GetAbilityName() == "item_seal_act" then
                                estseal = true
                            end
                        end
                    end
                    if estseal == true then
                        Timers:CreateTimer(0.01,function()
                            hInventoryParent:RemoveItem(hItem)
                            local sealmod = hInventoryParent:FindModifierByName("mod_seal_1")
                            if sealmod ~= nil then
                                sealmod:RefreshMods()
                            end
                        end)
                    else
                        for i=0, 8, 1 do
                            local current_item = hInventoryParent:GetItemInSlot(i)
                            if current_item ~= nil then
                                if current_item:GetAbilityName() == hItem:GetAbilityName() then
                                    hInventoryParent:RemoveItem(current_item)
                                end
                            end
                        end
                    end
                end
            end
        end
	end
	return true
end

----------------------------------------------------------------
-- "Custom" modifier value fetching
----------------------------------------------------------------

-- Spell lifesteal
function CDOTA_BaseNPC:GetSpellLifesteal()
	local lifesteal = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierSpellLifesteal then
			lifesteal = lifesteal + parent_modifier:GetModifierSpellLifesteal()
		end
	end
	return lifesteal
end

-- Autoattack lifesteal
function CDOTA_BaseNPC:GetLifesteal()
	local lifesteal = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierLifesteal then
			lifesteal = lifesteal + parent_modifier:GetModifierLifesteal()
		end
	end
	return lifesteal
end

-- Health regeneration % amplification
function CDOTA_BaseNPC:GetHealthRegenAmp()
	local regen_increase = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierHealthRegenAmp then
			regen_increase = regen_increase + parent_modifier:GetModifierHealthRegenAmp()
		end
	end
	return regen_increase
end

-- Spell power
function CDOTA_BaseNPC:GetSpellPower()

	-- If this is not a hero, do nothing
	if not self:IsHero() then
		return 0
	end

	-- Adjust base spell power based on current intelligence
	local spell_power = self:GetIntellect() / 14

	-- Mega Treads increase spell power from intelligence by 30%
	if self:HasModifier("modifier_imba_mega_treads_stat_multiplier_02") then
		spell_power = self:GetIntellect() * 0.093
	end

	-- Fetch spell power from modifiers
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierSpellAmplify_Percentage then
			spell_power = spell_power + parent_modifier:GetModifierSpellAmplify_Percentage()
		end
	end

	-- Return current spell power
	return spell_power
end

-- Cooldown reduction
function CDOTA_BaseNPC:GetCooldownReduction()

	-- If this is not a hero, do nothing
	if not self:IsRealHero() then
		return 0
	end

	-- Fetch cooldown reduction from modifiers
	local cooldown_reduction = 0
	local nonstacking_reduction = 0
	local stacking_reduction = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do

		-- Nonstacking reduction
		if parent_modifier.GetCustomCooldownReduction then
			nonstacking_reduction = math.max(nonstacking_reduction, parent_modifier:GetCustomCooldownReduction())
		end

		-- Stacking reduction
		if parent_modifier.GetCustomCooldownReductionStacking then
			stacking_reduction = 100 - (100 - stacking_reduction) * (100 - parent_modifier:GetCustomCooldownReductionStacking()) * 0.01
		end
	end

	-- Calculate actual cooldown reduction
	cooldown_reduction = 100 - (100 - nonstacking_reduction) * (100 - stacking_reduction) * 0.01

	-- Frantic mode adjustment (70% CDR)
	if IMBA_FRANTIC_MODE_ON then
		cooldown_reduction = 100 - (100 - cooldown_reduction) * 30 * 0.01
	end

	-- Return current cooldown reduction
	return cooldown_reduction
end

-- Calculate physical damage post reduction
function CDOTA_BaseNPC:GetPhysicalArmorReduction()
	local armornpc = self:GetPhysicalArmorValue()
	local armor_reduction = 1 - (0.06 * armornpc) / (1 + (0.06 * math.abs(armornpc)))
	armor_reduction = 100 - (armor_reduction * 100)
	return armor_reduction
end

function GetReductionFromArmor(armor)
	local m = 0.06 * armor
	return 100 * (1 - m/(1+math.abs(m)))
end

function CalculateReductionFromArmor_Percentage(armorOffset, armor)
	return -GetReductionFromArmor(armor) + GetReductionFromArmor(armorOffset)
end

-- Physical damage block
function CDOTA_BaseNPC:GetDamageBlock()

	-- Fetch damage block from custom modifiers
	local damage_block = 0
	local unique_damage_block = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do

		-- Vanguard-based damage block does not stack
		if parent_modifier.GetCustomDamageBlockUnique then
			unique_damage_block = math.max(unique_damage_block, parent_modifier:GetCustomDamageBlockUnique())
		end

		-- Stack all other sources of damage block
		if parent_modifier.GetCustomDamageBlock then
			damage_block = damage_block + parent_modifier:GetCustomDamageBlock()
		end
	end

	-- Calculate total damage block
	damage_block = damage_block + unique_damage_block

	-- Ranged attackers only benefit from part of the damage block
	if self:IsRangedAttacker() then
		return 0.6 * damage_block
	else
		return damage_block
	end
end

function GameMode:OnWinsLoad(list)
    WinsMaxList = {}
    WinsList = {}
    if list[1] ~= nil then
        if list[#list] ~= "|" then
            local fin = false
            for i=1,#list do
                if list[i] ~= "|" then
                    if fin == false then
                        local id = ""
                        local col = ""
                        local locstr = ""
                        for n=1,string.len(list[i]) do
                            if string.char(string.byte(list[i], n)) ~= nil then
                                if string.char(string.byte(list[i], n)) == "-" then
                                    id = locstr
                                    locstr = ""
                                else
                                    locstr = locstr .. string.char(string.byte(list[i], n))
                                end
                            end
                        end
                        col = locstr
                        local kv =
                        {
                            id = id,
                            col = col
                        }
                        table.insert(WinsMaxList,kv)
                    else
                        local id = ""
                        local col = ""
                        local locstr = ""
                        for n=1,string.len(list[i]) do
                            if string.char(string.byte(list[i], n)) ~= nil then
                                if string.char(string.byte(list[i], n)) == "-" then
                                    id = locstr
                                    locstr = ""
                                else
                                    locstr = locstr .. string.char(string.byte(list[i], n))
                                end
                            end
                        end
                        col = locstr
                        local kv =
                        {
                            id = id,
                            col = col
                        }
                        table.insert(WinsList,kv)
                    end
                else
                    fin = true
                end
            end
        end
    end
    GameMode:UpdateTops()
end

function GameMode:OnPlaysLoad(list)
    PlaysMaxList = {}
    PlaysList = {}
    if list[1] ~= nil then
        if list[#list] ~= "|" then
            local fin = false
            for i=1,#list do
                if list[i] ~= "|" then
                    if fin == false then
                        local id = ""
                        local col = ""
                        local locstr = ""
                        for n=1,string.len(list[i]) do
                            if string.char(string.byte(list[i], n)) ~= nil then
                                if string.char(string.byte(list[i], n)) == "-" then
                                    id = locstr
                                    locstr = ""
                                else
                                    locstr = locstr .. string.char(string.byte(list[i], n))
                                end
                            end
                        end
                        col = locstr
                        local kv =
                        {
                            id = id,
                            col = col
                        }
                        table.insert(PlaysMaxList,kv)
                    else
                        local id = ""
                        local col = ""
                        local locstr = ""
                        for n=1,string.len(list[i]) do
                            if string.char(string.byte(list[i], n)) ~= nil then
                                if string.char(string.byte(list[i], n)) == "-" then
                                    id = locstr
                                    locstr = ""
                                else
                                    locstr = locstr .. string.char(string.byte(list[i], n))
                                end
                            end
                        end
                        col = locstr
                        local kv =
                        {
                            id = id,
                            col = col
                        }
                        table.insert(PlaysList,kv)
                    end
                else
                    fin = true
                end
            end
        end
    end
    GameMode:UpdateTops()
end

function GameMode:UpdateProfiles(data)
    GameMode:Levels(data)
    GameMode:NeedSteamIds(data)
    local pplc = PlayerResource:GetPlayerCount()
    for i=0,pplc-1 do
        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(data.id), "MyProfileInfo", MyProfileArray[i])
    end
end

function GameMode:UpdateTops()
    print("UpdateTops")
    local kvwins = 
    {
        top1=WinsMaxList[1],
        top2=WinsMaxList[2],
        top3=WinsMaxList[3],
        top4=WinsMaxList[4],
        top5=WinsMaxList[5],
        top6=WinsMaxList[6],
        top7=WinsMaxList[7],
        top8=WinsMaxList[8],
        top9=WinsMaxList[9],
        norm1=WinsList[1],
        norm2=WinsList[2],
        norm3=WinsList[3],
        norm4=WinsList[4],
        norm5=WinsList[5],
        norm6=WinsList[6],
        norm7=WinsList[7],
        norm8=WinsList[8],
        norm9=WinsList[9],
        norm10=WinsList[10]
    }
    local kvplays = 
    {
        top1=PlaysMaxList[1],
        top2=PlaysMaxList[2],
        top3=PlaysMaxList[3],
        top4=PlaysMaxList[4],
        top5=PlaysMaxList[5],
        top6=PlaysMaxList[6],
        top7=PlaysMaxList[7],
        top8=PlaysMaxList[8],
        top9=PlaysMaxList[9],
        norm1=PlaysList[1],
        norm2=PlaysList[2],
        norm3=PlaysList[3],
        norm4=PlaysList[4],
        norm5=PlaysList[5],
        norm6=PlaysList[6],
        norm7=PlaysList[7],
        norm8=PlaysList[8],
        norm9=PlaysList[9],
        norm10=PlaysList[10]
    }
    CustomGameEventManager:Send_ServerToAllClients( "UpdateTopWins", kvwins)
    CustomGameEventManager:Send_ServerToAllClients( "UpdateTopPlays", kvplays)
end

function GameMode:Levels(data)
    local hero = PlayerResource:GetSelectedHeroEntity(data.id)
    local lvl_item_corrupting_blade = 0
    local lvl_item_glimmerdark_shield = 0
    local lvl_item_guardian_shell = 0
    local lvl_item_dredged_trident = 0
    local lvl_item_oblivions_locket = 0
    local lvl_item_ambient_sorcery = 0
    local lvl_item_wand_of_the_brine = 0
    local lvl_item_seal_0 = 0
    if hero then
        if hero.lvl_item_corrupting_blade ~= nil then
            lvl_item_corrupting_blade = hero.lvl_item_corrupting_blade
        end
        if hero.lvl_item_glimmerdark_shield ~= nil then
            lvl_item_glimmerdark_shield = hero.lvl_item_glimmerdark_shield
        end
        if hero.lvl_item_guardian_shell ~= nil then
            lvl_item_guardian_shell = hero.lvl_item_guardian_shell
        end
        if hero.lvl_item_dredged_trident ~= nil then
            lvl_item_dredged_trident = hero.lvl_item_dredged_trident
        end
        if hero.lvl_item_oblivions_locket ~= nil then
            lvl_item_oblivions_locket = hero.lvl_item_oblivions_locket
        end
        if hero.lvl_item_ambient_sorcery ~= nil then
            lvl_item_ambient_sorcery = hero.lvl_item_ambient_sorcery
        end
        if hero.lvl_item_wand_of_the_brine ~= nil then
            lvl_item_wand_of_the_brine = hero.lvl_item_wand_of_the_brine
        end
        if hero.lvl_item_wand_of_the_brine ~= nil then
            lvl_item_seal_0 = hero.lvl_item_seal_0
        end
        local myvalue = {
            data.id,
            lvl_item_corrupting_blade,
            lvl_item_glimmerdark_shield,
            lvl_item_guardian_shell,
            lvl_item_dredged_trident,
            lvl_item_oblivions_locket,
            lvl_item_ambient_sorcery,
            lvl_item_wand_of_the_brine,
            lvl_item_seal_0,
            hero.rsinv,
            hero.rsp,
            hero.rsslots,
            hero.rssaves,
            hero.sealcolor,
            hero.sealcolors
        }
        CustomGameEventManager:Send_ServerToAllClients( "My_lvl", myvalue)
    end
    CustomGameEventManager:Send_ServerToAllClients( "My_lvl", myvalue)
end

pointvtbl = {
false,
false,
false,
false,
false
}
function GameMode:SetPointV(num, pointv)
    pointvtbl[num] = pointv
    local allok = true
    for i=1,5 do
        if pointvtbl[i] == false then
            allok = false
        end
    end
    if allok == true and PlayerResource:GetPlayerCount() == 5 then
        local heroes = GameMode:GetAllRealHeroes()
        local unit = nil
        local entts = Entities:FindAllByName("npc_dota_creature")
        for i=1, #entts do
            if entts[i]:GetUnitLabel() == "npc_dota_gold_spirit" then
                unit = entts[i]
            end
        end
        for i=1, #heroes do
            local info = {
                Target = unit,
                Source = heroes[i],
                Ability = nil,
                EffectName = "particles/units/heroes/hero_dark_willow/dark_willow_base_attack.vpcf",
                iMoveSpeed = 1600,
            }
            ProjectileManager:CreateTrackingProjectile( info )
        end
        Timers:CreateTimer(1.25, function()
            GameMode:StartEndRounds()
            pointvtbl = {
            false,
            false,
            false,
            false,
            false
            }
            local pointents = GameMode:GetPointEnts()
            for i=1,#pointents do
                if pointents[i] ~= caster then
                    pointents[i]:RemoveSelf()
                end
            end
        end)
    end
end

LinkLuaModifier( "part_mod", "modifiers/parts/part_mod", LUA_MODIFIER_MOTION_NONE )

function GameMode:SelectPart(info)
    if info.offp == 0 then
        
        --Say(nil,"text here", false)
        --GameRules:SendCustomMessage("<font color='#58ACFA'> использовал эффект </font>"..info.name.."#partnote".." test", 0, 0)
        local arr = {
            info.id,
            PlayerResource:GetPlayerName(info.id),
            info.part,
            PlayerResource:GetSelectedHeroName(info.id)
        }

        CustomGameEventManager:Send_ServerToAllClients( "UpdateParticlesUI", arr)
        PlayerResource:GetSelectedHeroEntity(info.id):RemoveModifierByName("part_mod")
        PlayerResource:GetSelectedHeroEntity(info.id):AddNewModifier(PlayerResource:GetSelectedHeroEntity(info.id), PlayerResource:GetSelectedHeroEntity(info.id), "part_mod", {part = info.part})
    else
        PlayerResource:GetSelectedHeroEntity(info.id):RemoveModifierByName("part_mod")
    end
end