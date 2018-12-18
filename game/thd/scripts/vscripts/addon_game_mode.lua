-- 这个文件是RPG载入的时候，游戏的主程序最先载入的文件
-- 一般在这里载入各种我们所需要的各种lua文件
-- 除了addon_game_mode以外，其他的部分都需要去掉

G_IsAIMode = false
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
--CAO NI MA
-- 载入项目所有文件
require("constants")
require("util/damage")
require("util/heal")
require("util/mana")
require("util/stun")
require("util/pauseunit")
require("util/silence")
require("util/magic_immune")
require("util/timers")
require("util/util")
require("util/disarmed")
require("util/invulnerable")
require("util/graveunit")
require("util/collision")
require("util/nodamage")
require("util/CheckItemModifies")
require("util/EXPTABLE")
require("addon_init")
require("util/physics")
require("util/global_modifier")
--require("event/event")
--require( "ai/common")


if THDOTSGameMode == nil then
	THDOTSGameMode = {}
end



function Precache( context )
	LinkLuaModifier("modifier_command_restricted", "modifiers/modifier_command_restricted.lua", LUA_MODIFIER_MOTION_NONE )

	PrecacheResource( "model", "models/thd2/point.vmdl", context )--真の点数
	PrecacheResource( "model", "models/thd2/power.vmdl", context )--真のP点
	PrecacheResource( "model", "models/development/invisiblebox.vmdl", context )
	PrecacheResource( "model", "models/thd2/iku/iku_lightning_drill.vmdl", context )
	PrecacheResource( "particle", "particles/items_fx/aegis_respawn_spotlight.vpcf",context )--真のP点
	PrecacheResource( "particle", "particles/units/heroes/hero_mirana/mirana_base_attack.vpcf",context )--永琳弹道
	PrecacheResource( "particle", "particles/items2_fx/hand_of_midas.vpcf",context )--真の点数
	PrecacheResource( "particle_folder", "particles/thd2/heroes/reimu", context )--灵梦and跳台
	PrecacheResource( "particle", "particles/thd2/environment/death/act_hero_die.vpcf",context )--死亡
	PrecacheResource( "particle", "particles/environment/thd_rain.vpcf",context )--雨
	PrecacheResource( "particle", "particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf",context )--雨
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_visage.vsndevts", context )--灵梦and跳台
	PrecacheResource( "soundfile", "soundevents/game_sounds_custom.vsndevts", context )--背景音乐
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_elder_titan.vsndevts", context )
	--PrecacheResource( "particle", "particles/thd2/chen_cast_4.vpcf", context )--激光
	PrecacheResource( "soundfile", "soundevents/thdots_hero_sounds/thdots_komachiex_sounds.vsndevts", context )
	PrecacheResource( "model", "models/thd2/yyy.vmdl", context )--灵梦D
	PrecacheResource( "model", "models/thd2/fantasy_seal.vmdl", context )--灵梦F
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_rubick.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_ogre_magi.vsndevts", context )		
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_antimage.vsndevts", context )	
	PrecacheResource( "soundfile", "soundevents/thdots_hero_sounds/bgm.vsndevts", context )	
	PrecacheResource( "soundfile", "soundevents/chatwheel/chatwheel.vsndevts", context )		
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_vengefulspirit.vsndevts", context )	
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_gyrocopter.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_leshrac.vsndevts", context )
	PrecacheResource( "soundfile", "game_sounds_vo_lich.vsndevts", context )	
	PrecacheResource( "model", "models/thd2/youmu/youmu.vmdl", context )--妖梦R

	PrecacheResource( "model", "models/heroes/lycan/lycan_wolf.vmdl", context )--狗花D

	PrecacheResource( "particle", "particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_low_egset.vpcf", 
	context )--天子F
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context )--天子W
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_zuus", context )--天子W

	PrecacheResource( "model", "models/props_gameplay/rune_haste01.vmdl", context )--魔理沙R
	PrecacheResource( "model", "models/thd2/masterspark.vmdl", context )--魔理沙 魔炮
	
	PrecacheResource( "particle", "particles/dire_fx/tower_bad_face_end_shatter.vpcf", context )--幽幽子F
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_death_prophet", context )--幽幽子D
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_bane", context )--幽幽子F
	PrecacheResource( "model", "models/thd2/yuyuko_fan.vmdl", context )--幽幽子W

	PrecacheResource( "particle_folder", "particles/units/heroes/hero_phoenix", context )--妹红R	
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", context )--妹红R
	PrecacheResource( "model", "models/thd2/firewing.vmdl", context )--妹红W	

	PrecacheResource( "particle", "particles/thd2/heroes/flandre/ability_flandre_04_buff.vpcf", context )--芙兰朵露	
	PrecacheResource( "particle", "particles/thd2/heroes/flandre/ability_flandre_04_effect.vpcf", context )--芙兰朵露

	PrecacheResource( "particle_folder", "particles/units/heroes/hero_brewmaster", context )--红三
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context )--红三

	PrecacheResource( "particle_folder", "particles/units/heroes/hero_tiny", context )--西瓜
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts", context )--西瓜

	PrecacheResource( "soundfile", "soundevents/customeventsound/custom_sound_thdr.vsndevts", context )--西瓜
	
	PrecacheResource( "soundfile", "soundevents/thdots_hero_sounds/thdots_patchouli_sounds.vsndevts", context )--西瓜	
	
	PrecacheResource( "soundfile", "soundevents/thdots_hero_sounds/thdots_patchouli_sounds.vsndevts", context )--西瓜	
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_night_stalker", context )--露米娅
	
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_disruptor", context )--永琳
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_disruptor.vsndevts", context )--永琳

	PrecacheResource( "particle_folder", "particles/units/heroes/hero_night_stalker", context )--NEET

	PrecacheResource( "particle_folder", "particles/units/heroes/hero_doom_bringer", context )--flandre04
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_phantom_assassin", context )--flandre04

	PrecacheResource( "particle_folder", "particles/units/heroes/hero_tiny", context )--suika01


	PrecacheResource( "particle", "particles/thd2/items/item_ballon.vpcf", context )--幽灵气球
	PrecacheResource( "particle", "particles/thd2/items/item_bad_man_card.vpcf", context )--坏人卡
	PrecacheResource( "particle", "particles/thd2/items/item_good_man_card.vpcf", context )--好人卡
	PrecacheResource( "particle", "particles/thd2/items/item_love_man_card.vpcf", context )--爱人卡
	PrecacheResource( "particle", "particles/thd2/items/item_unlucky_man_card.vpcf", context )--衰人卡
	PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_ambient_frost_legs.vpcf", context )--冰青蛙减速
	PrecacheResource( "particle", "particles/thd2/items/item_kafziel.vpcf", context )--镰刀
	PrecacheResource( "particle", "particles/base_attacks/ranged_tower_good_launch.vpcf", context )--绿刀
	PrecacheResource( "particle", "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf", context )--绿坝
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_windwalk.vpcf", context )--碎骨笛
	PrecacheResource( "particle", "particles/units/heroes/hero_medusa/medusa_mana_shield_shell_mod.vpcf", context )--碎骨笛
	PrecacheResource( "particle", "particles/thd2/items/item_camera.vpcf", context )--相机
	PrecacheResource( "particle", "particles/thd2/items/item_tsundere.vpcf", context )--无敌
	PrecacheResource( "particle", "particles/thd2/items/item_rocket.vpcf",context )--火箭
	PrecacheResource( "particle", "particles/thd2/items/item_mr_yang.vpcf",context )--火箭
	PrecacheResource( "particle", "particles/thd2/items/item_donation_gem.vpcf",context )--钱玉
	PrecacheResource( "particle", "particles/thd2/items/item_donation_box.vpcf",context )--钱箱
	PrecacheResource( "particle", "particles/thd2/items/item_phoenix_wing.vpcf",context )--火凤凰之翼
	PrecacheResource( "particle", "particles/thd2/items/item_darkred_umbrella_fog_attach.vpcf",context )--深红的雨伞 单位依附
	PrecacheResource( "particle", "particles/econ/items/sniper/sniper_charlie/sniper_base_attack_explosion_charlie.vpcf",context )--风枪
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf",context )--马王
	PrecacheResource( "particle", "particles/thd2/items/item_yatagarasu.vpcf",context )--八尺乌
	PrecacheResource( "particle", "particles/items2_fx/phase_boots.vpcf",context )--狐狸面具
	PrecacheResource( "particle", "particles/thd2/items/item_pocket_watch.vpcf",context )--秒表
	PrecacheResource( "particle", "particles/thd2/items/item_moon_bow.vpcf",context )--月弓
	PrecacheResource( "particle", "particles/items_fx/ethereal_blade.vpcf",context )--三次元
	PrecacheResource( "particle", "particles/items2_fx/mekanism.vpcf",context )--梅肯
	PrecacheResource( "particle", "particles/items3_fx/warmage_mana.vpcf",context )--秘法
	
	PrecacheResource( "model", "models/thd2/kaguya/kaguya.vmdl",context )

	--MMD

	PrecacheResource( "model", "models/thd2/reisen/reisen.vmdl",context )
	PrecacheResource( "model", "models/thd2/reisen/reisenUnit.vmdl",context )

	PrecacheResource( "model", "models/thd2/hakurei_reimu/hakurei_reimu_mmd.vmdl",context )
	PrecacheResource( "model", "models/thd2/marisa/marisa_mmd.vmdl",context )
	PrecacheResource( "model", "models/aya/aya_mmd.vmdl",context )
	PrecacheResource( "model", "models/thd2/tenshi/tenshi_mmd.vmdl",context )
	PrecacheResource( "model", "models/thd2/flandre/flandre_mmd.vmdl",context )

	PrecacheResource( "model", "models/thd2/hiziri_byakuren/hiziri_byakuren_mmd.vmdl",context )
	PrecacheResource( "model", "models/thd2/mokou/mokou_mmd.vmdl",context )
	PrecacheResource( "model", "models/thd2/yuugi/yuugi_mmd.vmdl",context )
	PrecacheResource( "model", "models/thd2/suika/suika_mmd.vmdl",context )
	PrecacheResource( "model", "models/thd2/rumia/rumia_mmd.vmdl",context )
	PrecacheResource( "model", "models/thd2/iku/iku_mmd.vmdl",context )

	PrecacheResource( "model", "models/thd2/youmu/youmu_mmd.vmdl",context )
	PrecacheResource( "model", "models/thd2/eirin/eirin_mmd.vmdl",context )
	PrecacheResource( "model", "models/thd2/yuyuko/yuyuko_mmd.vmdl",context )
	PrecacheResource( "model", "models/thd2/utsuho/utsuho_mmd.vmdl",context )
	PrecacheResource( "model", "models/thd2/sakuya/sakuya_mmd.vmdl",context )

	PrecacheResource( "model", "models/heroes/death_prophet/death_prophet_ghost.vmdl",context )

	PrecacheResource( "model", "models/thd2/yukkuri/yukkuri.vmdl",context )
	PrecacheResource( "model", "models/thd2/koishi/koishi_transform_mmd.vmdl",context )
	PrecacheResource( "model", "models/thd2/koishi/koishi_w_mmd.vmdl",context )
	PrecacheResource( "model", "models/thd2/yumemi/yumemi_idousen.vmdl",context )

	PrecacheResource( "model", "models/thd2/kanako/kanako_mmd_transform.vmdl",context )
	PrecacheResource( "model", "models/thd2/kanako/kanako_mmd_transforming.vmdl",context )
end

-- Create the game mode when we activate
function Activate()
	GameRules.THDOTSGameMode = THDOTSGameMode
	GameRules.THDOTSGameMode:InitGameMode()
	_G["AddonTemplate"] = THDOTSGameMode
end

-- 这个函数是addon_game_mode里面所写的，会在vlua.cpp执行的时候所执行的内容
function THDOTSGameMode:InitGameMode()
	print('[THDOTS] Starting to load THDots gamemode...')
	local GameMode = GameRules:GetGameModeEntity()
	InitLogFile( "log/dota2x.txt","")
	-- 初始化记录文件
	-- 这个记录文件的路径是 dota 2 beta/dota/log/dota2x.txt
	-- 在有必要的时候，你可以使用  AppendToLogFile("log/dota2x.txt","记录内容")
	-- 来记录一些数据，避免游戏的崩溃了，却无法看到控制台的报错，无法判断是哪里出了问题

	-- 游戏事件监听
	-- 监听的API规则是
	-- ListenToGameEvent(API定义的事件名称或者我们自己程序发出的事件名称,事件触发之后执行的函数,LUA所有者)
	-- 这里所使用的 Dynamic_Wrap(THDOTSGameMode, 'OnEntityKilled') 其实就相当于self:OnEntityKilled
	-- 使用Dynamic_Wrap的好处是可以在控制台输入 developer 1之后，控制台显示一些额外的信息

	ListenToGameEvent('entity_killed', Dynamic_Wrap(THDOTSGameMode, 'OnEntityKilled'), self)  
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(THDOTSGameMode, 'AutoAssignPlayer'), self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(THDOTSGameMode, 'CleanupPlayer'), self)
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(THDOTSGameMode, 'AbilityUsed'), self)
	ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(THDOTSGameMode, 'AbilityLearn'), self)
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(THDOTSGameMode, 'Levelup'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap( THDOTSGameMode, 'OnHeroSpawned' ), self )
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(THDOTSGameMode, 'OnGameRulesStateChange'), self)
	ListenToGameEvent('player_chat', Dynamic_Wrap(THDOTSGameMode, 'OnPlayerSay'), self)	
	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(THDOTSGameMode, 'OnPlayerPickitemup'), self)
--	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(THDOTSGameMode, 'OnPlayerPickitem'), self)

	ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(THDOTSGameMode, 'OnPlayerPurchased'), self)	

	--ListenToGameEvent('dota_hero_random', Dynamic_Wrap(THDOTSGameMode, 'OnPlayerRandomHero'), self)	
	--ListenToGameEvent('dota_item_used', Dynamic_Wrap(THDOTSGameMode, 'OnPlayerItemUsed'), self)	
	
	GameRules:GetGameModeEntity():SetThink( "OnThink", THDOTSGameMode, 0.1 )
	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(Dynamic_Wrap(THDOTSGameMode, "ItemAddedFilter"), self)
	GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(THDOTSGameMode, "GoldFilter2"), self)

	GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(THDOTSGameMode, "ExpFilter"), self)

	
	GameRules:SetPreGameTime(PRE_GAME_TIME)
	GameRules:SetStrategyTime(Strategy_Time)
	GameRules:SetStartingGold(STARTING_GOLD)
	GameRules:SetRuneSpawnTime(120.0)
	GameRules:EnableCustomGameSetupAutoLaunch(true)
	GameRules:GetGameModeEntity():SetFountainPercentageHealthRegen(20)
	GameRules:GetGameModeEntity():SetFountainPercentageManaRegen(30)
	GameRules:GetGameModeEntity():SetFountainConstantManaRegen(0)
	GameRules:SetHeroSelectionTime(Hero_Selection_Time)
	GameRules:SetTreeRegrowTime(6)
	GameRules:GetGameModeEntity():SetSelectionGoldPenaltyEnabled(false)
	GameRules:SetCustomGameSetupAutoLaunchDelay(10)
	--GameRules:LockCustomGameSetupTeamAssignment(true)	
	--GameMode:SetLoseGoldOnDeath(false)
	GameMode:SetCustomBuybackCostEnabled( true )
	GameMode:SetCustomBuybackCooldownEnabled( true )
	--GameMode:SetBuybackEnabled(false)
	GameMode:SetMaximumAttackSpeed(800)
	--GameRules:SetGoldTickTime(0.5)
	--GameRules:SetUseBaseGoldBountyOnHeroes(false)
	--GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(EXPTABLE.XP_PER_LEVEL_TABLE)	
	
	--GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_SPELL_AMP_PERCENT,0)	
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(THDOTSGameMode, 'OnTHDOTSDamageFilter'), self)	
	if GameRules:IsCheatMode() then
		if PlayerResource:GetPlayerCount() < 2 then	
		GameRules:SetStartingGold(STARTING_test_GOLD)
		GameRules:SetPreGameTime(PRE_GAME_TIME_TEST)	
		GameRules:SetGoldTickTime(1000)	
		GameRules:SetStrategyTime(Strategy_Time_TEST)
		GameRules:SetCustomGameSetupAutoLaunchDelay(0)	
		end
		if PlayerResource:GetPlayerCount() > 1 then
			GameRules:SetCustomGameSetupAutoLaunchDelay(5)
		end
	end 
	
	if IsInToolsMode() then
		GameRules:SetStartingGold(STARTING_test_GOLD)
		GameRules:SetPreGameTime(PRE_GAME_TIME_TEST)	
		GameRules:SetGoldTickTime(1000)	
		GameRules:SetGoldPerTick(0)
		GameRules:SetStrategyTime(Strategy_Time_TEST)
		GameRules:SetCustomGameSetupAutoLaunchDelay(0)	
	end 	
	

	--GameRules:SetUseBaseGoldBountyOnHeroes(true)
	-- 以下就是一些推荐使用的Table变量
	self.vUserNames = {}
	self.vUserIds = {}
	self.vSteamIds = {}
	self.vBots = {}
	self.vBroadcasters = {}
	self.vPlayers = {}
	self.vRadiant = {}
	self.vDire = {}
	self.vPlayerHeroData = {}
	self.timers = {}

	-- gamemode vars
	self.backdoor_radius = 1200

	GoodCamera = Entities:FindByName(nil, "dota_goodguys_fort")
	BadCamera = Entities:FindByName(nil, "dota_badguys_fort")

	self.rune_models = {
		"models/props_gameplay/rune_haste01.vmdl",
		"models/props_gameplay/rune_doubledamage01.vmdl",
		"models/props_gameplay/rune_regeneration01.vmdl",
		"models/props_gameplay/rune_arcane.vmdl",
		"models/props_gameplay/rune_invisibility01.vmdl",
		"models/props_gameplay/rune_illusion01.vmdl",
	}
end

Hero_Cloth = 
{
	["npc_dota_hero_templar_assassin"] = 
		{	["cloth00"] = "models/thd2/sakuya/sakuya_mmd.vmdl",
			["cloth01"] = "models/thd2/sakuya_cloth01/sakuya_mmd_cloth01.vmdl"
		},
	["npc_dota_hero_lina"] =
		{	["cloth00"] = "models/reimu/reimu.vmdl",
			["cloth01"] = "models/thd2/hakurei_reimu/hakurei_reimu_mmd.vmdl"
		},
	["npc_dota_hero_mirana"] =
		{	["cloth00"] = "models/reisen/reisen.vmdl",
			["cloth01"] = "models/thd2/reisen/reisen.vmdl"
		},
	["npc_dota_hero_visage"] =
		{	["cloth00"] = "models/alice/alice.vmdl",
			["cloth01"] = "models/alice_cloth01/alice_cloth01.vmdl"
		},
	--["npc_dota_hero_life_stealer"] =
	--	{	["cloth00"] = "models/thd2/rumia/rumia_mmd.vmdl",
	--		["cloth01"] = "models/thd2/rumia_ex/rumia_ex.vmdl"
	--	},
	["npc_dota_hero_vengefulspirit"] =
		{	["cloth00"] = "models/new_thd/hatate/hatatea.vmdl",
			["cloth13"] = "models/new_thd/hatate/hatateb.vmdl"
		}		
}

function THDOTSGameMode:OnPlayerSay( keys )
	local text = keys.text

	if text == "-cloth00" then
		local hero = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()
		if Hero_Cloth[hero:GetClassname()]["cloth00"] ~= nil then
			hero:SetModel(Hero_Cloth[hero:GetClassname()]["cloth00"])
			hero:SetOriginalModel(Hero_Cloth[hero:GetClassname()]["cloth00"])
			return
		end
	elseif text == "-cloth01" then
		local hero = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()
		if Hero_Cloth[hero:GetClassname()]["cloth01"] ~= nil then
			hero:SetModel(Hero_Cloth[hero:GetClassname()]["cloth01"])
			hero:SetOriginalModel(Hero_Cloth[hero:GetClassname()]["cloth01"])
			return
		end
	elseif text == "-cloth13" then
		local hero = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()
		if Hero_Cloth[hero:GetClassname()]["cloth13"] ~= nil then
			hero:SetModel(Hero_Cloth[hero:GetClassname()]["cloth13"])
			hero:SetOriginalModel(Hero_Cloth[hero:GetClassname()]["cloth13"])
			return
		end		
	elseif text == "ruozhitaidao" then
	
	elseif text == "-bot" then
		local GameMode = GameRules:GetGameModeEntity()
		local ply = nil

		for i=0,4 do
			ply = PlayerResource:GetPlayer(i)
			if ply==nil then
				local int = RandomInt(1, 2)
				Tutorial:AddBot(G_Bot_Random_Hero[int],"","hard",true)
				
				table.insert(G_Bot_List,i)
			end
		end

		for i=5,9 do
			ply = PlayerResource:GetPlayer(i)
			if ply==nil then
				local int = RandomInt(3, 4)
				Tutorial:AddBot(G_Bot_Random_Hero[int],"","hard",false)
				
				table.insert(G_Bot_List,i)
			end
		end

		if #G_Bot_List > 0 then
			G_IsAIMode = true
			GameMode:SetBotThinkingEnabled(true)
			--GameMode:SetFixedRespawnTime(10)
		end
	elseif text == "-removebot" then
		GameRules:GetGameModeEntity():SetBotThinkingEnabled(false)
	end
	if text == "-lol1"  then
		local heroz = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()

		if  heroz:GetClassname() ==  "npc_dota_hero_ogre_magi" then
			--heroz:EmitSound("ogre_magi_ogmag_rival_01")
			EmitGlobalSound("ogre_magi_ogmag_rival_02")
		end	
	end

	if text == "-lol2"  then
		local heroz = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()

		if  heroz:GetClassname() ==  "npc_dota_hero_ogre_magi" then
		--heroz:EmitSound("ogre_magi_ogmag_rival_01")
			EmitGlobalSound("ogre_magi_ogmag_happy_02")
		end	
	end	

	if text == "-lol3"  then
		local heroz = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()

		if  heroz:GetClassname() ==  "npc_dota_hero_ogre_magi" then
			--heroz:EmitSound("ogre_magi_ogmag_rival_01")
			EmitGlobalSound("ogre_magi_ogmag_laugh_07")
		end	
	end	

	if text == "-why"  then
		local heroz = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()

		if  heroz:GetClassname() ==  "npc_dota_hero_ogre_magi" then
			--heroz:EmitSound("ogre_magi_ogmag_rival_01")
			EmitGlobalSound("ogre_magi_ogmag_death_04")
		end	
	end		
	
	if text == "-muda"  then
		local heroz = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()

		if  heroz:GetClassname() ==  "npc_dota_hero_ogre_magi" then
			--heroz:EmitSound("ogre_magi_ogmag_rival_01")
			EmitGlobalSound("ogre_magi_ogmag_kill_12")
		end	
	end		
	
	if text == "-fun"  then
	local heroz = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()

	if  heroz:GetClassname() ==  "npc_dota_hero_ogre_magi" then
	--heroz:EmitSound("ogre_magi_ogmag_rival_01")
		EmitGlobalSound("ogre_magi_ogmag_kill_04")
	end	
	end	
	
	if text == "-end"  then
	local heroz = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()

	if  heroz:GetClassname() ==  "npc_dota_hero_ogre_magi" then
	--heroz:EmitSound("ogre_magi_ogmag_rival_01")
		EmitGlobalSound("ogre_magi_ogmag_rival_01")
	end	
	end		
	if text == "-eh"  then
	local heroz = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()

	if  heroz:GetClassname() ==  "npc_dota_hero_ogre_magi" then
	--heroz:EmitSound("ogre_magi_ogmag_rival_01")
		EmitGlobalSound("ogre_magi_ogmag_kill_01")
	end	
	end		
	
	--if --text == "-bgmoff" then
		--ply:StopSound("BGM." .. choice)
	--end

	if text == "-bgmonxx123" then
		EmitGlobalSound("bgm01x")
	end	
	
	if text == "-aye" then
		EmitGlobalSound("ay_ay_ay")
	end		
	if text == "-brutalsavage" then
		EmitGlobalSound("brutalsavage")
	end	
	if text == "-wheelcharge" then
		EmitGlobalSound("wheelcharge")
	end	
	if text == "-disaster11" then
		EmitGlobalSound("itsdisastah")
	end	
	if text == "-etagg" then
		EmitGlobalSound("etagege")
	end	
	if text == "-wanbuliaola" then
		EmitGlobalSound("wanbuliaola")
	end	
	if text == "-waoww" then
		EmitGlobalSound("waoww")
	end	
	if text == "-duiyou_ne" then
		EmitGlobalSound("duiyou_ne")
	end	
	if text == "-ezmoney" then
		EmitGlobalSound("2018_easiest_money")
	end	
	if text == "-nextlevelz" then
		EmitGlobalSound("chat_wheel_2018_next_level")
	end	
	if text == "-youok?" then
		EmitGlobalSound("chat_wheel_2018_ni_qi_bu_qi")
	end	
	if text == "-awww" then
		EmitGlobalSound("chat_wheel_2018_ow")
	end	
	if text == "-oioioi" then
		EmitGlobalSound("chat_wheel_2018_oy_oy_oy")
	end	
	if text == "-ptw" then
		EmitGlobalSound("chat_wheel_2018_playing_to_win")
	end	
	if text == "-wthp" then
		EmitGlobalSound("chat_wheel_2018_what_just_happened")
	end	
	if text == "-damnhero" then
		EmitGlobalSound("chat_wheel_2018_youre_a_hero")
	end	

	if text == "-stopit1" then
		EmitGlobalSound("stopit1")
	end	
	if text == "-tuturu012312332" then
	
		if the_nano[tostring(PlayerResource:GetSteamID(keys.playerid))] then
			local hero = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()
			if PlayerResource:GetUnreliableGold(keys.playerid) > 300 then
			PlayerResource:SpendGold(keys.playerid,300,4)
			end
		end
		
		if PlayerResource:GetUnreliableGold(keys.playerid) < 300 then
		
			return
			
			else
		--	EmitAnnouncerSoundForPlayer("tuturu",keys.playerid)
			EmitSoundOnClient("tuturu",PlayerResource:GetPlayer(keys.playerid))		
		--	EmitGlobalSound("tuturu")
		end
	end		
	
	
	--if text == 
	if text == "-goderi" and GameRules:IsCheatMode()==true
	then
	local herox = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()	
	herox:SetBaseDamageMax(10000)
	end
	
	if text == "-goderi" and GameRules:IsCheatMode()==true
	then
	local herox = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()	
	herox:SetBaseDamageMax(10000)
	end	
	--end
	if text == "-randomhero" then
	
	
		local heroxx = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()
	
		if heroxx == nil then
	
			PlayerResource:GetPlayer(keys.playerid):MakeRandomHeroSelection()


	
		end
	end		
	
	if text == "-checkbasestat" then
		local heroxxx = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()	
		local rumiastat = heroxxx:GetIncreasedAttackSpeed()
	
		print (rumiastat)	
	

	end	

	if text == "-testexrumia" and GameRules:IsCheatMode()==true  then	
	local hero = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()
	if  hero:GetClassname() ==  "npc_dota_hero_life_stealer" then
	
	hero:RemoveAbility("ability_thdots_rumia01")
	hero:RemoveAbility("ability_thdots_rumia02")	
	hero:RemoveAbility("ability_thdots_rumia03")
	hero:RemoveAbility("ability_thdots_rumia04")
	hero:SetModel("models/thd2/rumia_ex/rumia_ex.vmdl")
	hero:SetOriginalModel("models/thd2/rumia_ex/rumia_ex.vmdl")	
	hero:SetPrimaryAttribute(1)
	hero:SetBaseStrength(20)
	hero:SetBaseAgility(30)
	hero:SetBaseIntellect(10)
	--hero:SetBaseMoveSpeed(315)	
	hero:SetBaseDamageMax(30)
	hero:SetBaseDamageMin(30)
	hero:AddAbility("ability_thdots_EXrumia01")
	hero:AddAbility("ability_thdots_EXrumia02")
	hero:AddAbility("ability_thdots_EXrumia03")
	hero:AddAbility("ability_thdots_EXrumia04")
	hero:AddAbility("ability_thdots_EXrumia05"):SetLevel(1)	
	hero:SetAbilityPoints(hero:GetLevel())
--	GameRules:SendCustomMessage('attack2--> '..hero:GetBaseDamageMax(), 0, 0)
	local playername = PlayerResource:GetPlayerName(keys.playerid)
--	GameRules:SendCustomMessage('EXRumia has been randomed by '..playername, 0, 0)	
	GameRules:SendCustomMessage(playername ..' has randomed EXRumia', 0, 0)
	end
	
	end
	
	if text == "-pause" then
		PauseGame(true)	
	
	end
	
	if text == "-resume" then
		PauseGame(false)		
	
	end
	
	if text == "-whattime"
	then
	
	print (GameRules:GetGameTime())	
	
	end	
	if text == "-checkclass" then
	local hero = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()		
	local target =  hero:GetAttackTarget() 
    --local target = hero:GetCursorTarget()	
	--target = self:GetCursorTarget()
	local name = target:GetName()
	local nameclassname = target:GetClassname()
	print(name)
	print(nameclassname)
	
	end	
	
	if text == "-checkallclass" then
	local hero = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()		
	--local findallunits = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin() , nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES , FIND_CLOSEST, false)
	local towers2 = Entities:FindAllByClassname("npc_dota_building")
	for _,v in pairs(towers2) do	
		local allbuffs = v:FindAllModifiers()
		
		print(allbuffs:GetName())
	--	for _, c in pairs(allbuffs) do
	--	local buffsname = c:GetName()
	--	print(buffsname)
			
		
	--	end
		
		
	end
	
	end	
	
	if text == "checksteamid" then
		--local platyerid = PlayerResource:GetPlayer(keys.playerid)
	
		--GetPlayerID()
		local steamid = (PlayerResource:GetSteamID(keys.playerid))	
		print (steamid)
	

	
	end
	if text == "-cnmbao" then
		if eri_and_thegang[tostring(PlayerResource:GetSteamID(keys.playerid))] then
			local hero = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()
			hero:AddItemByName("item_antibao_system")
		
		end		
	end	
	
	if text == "-doit1" then
	
		EmitGlobalSound("doit1")	
	end		
	if text == "-justdoit1" then
	
		EmitGlobalSound("justdoit1")	
	end
	if text == "-justdoit2" then
	
		EmitGlobalSound("justdoit2")	
	end
	if text == "-justgiveup1" then
	
		EmitGlobalSound("justgiveup1")	
	end
	if text == "-justgiveup2" then
	
		EmitGlobalSound("justgiveup2")	
	end
	
	if text == "-addtest" then
	
		if GameRules:IsCheatMode()==true then
			local hero = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()		
			hero:AddAbility("ability_check_class_name"):SetLevel(1)
		end

	
	end

	if text == "-gpmx" then
	--	local networth = PlayerResource:GetTotalEarnedGold(keys.playerid)
		local gpmx = PlayerResource:GetGoldPerMin(keys.playerid)
		print(gpmx)
		local hero = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()
		SendOverheadEventMessage(nil,OVERHEAD_ALERT_GOLD,hero,gpmx, nil)		
	
	end	
	
--	if text == "-testshuffle" then
--		SendToServerConsole("sv_cheats 1")		
	
--	end		

	
end


G_Bot_Random_Hero = 
{	
	"npc_dota_hero_lina",
	"npc_dota_hero_juggernaut",
	"npc_dota_hero_slark",
	"npc_dota_hero_crystal_maiden",
	"npc_dota_hero_axe",
	"npc_dota_hero_dark_seer",
	"npc_dota_hero_drow_ranger",
	"npc_dota_hero_earthshaker",
	"npc_dota_hero_furion",
	"npc_dota_hero_kunkka",
	"npc_dota_hero_life_stealer",
	"npc_dota_hero_lion",
	"npc_dota_hero_mirana",
	"npc_dota_hero_necrolyte",
	"npc_dota_hero_puck",
	"npc_dota_hero_razor",
	"npc_dota_hero_sniper",
	"npc_dota_hero_storm_spirit",
	"npc_dota_hero_tidehunter",
	"npc_dota_hero_tinker",
	"npc_dota_hero_venomancer" ,
	"npc_dota_hero_zuus",
	"npc_dota_hero_warlock",
	"npc_dota_hero_bounty_hunter",
	"npc_dota_hero_silencer",
	"npc_dota_hero_clinkz",
	"npc_dota_hero_obsidian_destroyer",
	"npc_dota_hero_chaos_knight",
	"npc_dota_hero_templar_assassin",
	"npc_dota_hero_naga_siren",
	"npc_dota_hero_visage",
	"npc_dota_hero_centaur"
}

G_Bot_List = {}

-- 这个函数是在有玩家连接到游戏之后，调用的，请查看 THDOTSGameMode:AutoAssignPlayer里面调用这个函数的部分
-- 主要是设置属于游戏模式的相关规则，并且开启循环计时器

-- 以下的这些函数，大多都是把传递的数值Print出来
-- PrintTable和print的东西，都会显示在控制台上
-- PrintTable会显示例如
-- caster:
--        table:0x00ff000
-- caster_entindex:195
-- target:
--        table:0x00ff000
-- 这样的内容，那么我们就可以通过keys.caster_entindex来获取这个caster的Entity序号
-- 再通过
-- EntIndexToHScript(keys.caster_entindex)
-- 就可以获取这个施法者相对应的hScript了

function THDOTSGameMode:AbilityUsed(keys)
  local ply = EntIndexToHScript(keys.PlayerID+1)
  if(ply==nil)then
	return
  end
  local caster = ply:GetAssignedHero()
  if(caster==nil)then
	return
  end
end

--function THDOTSGameMode:AbilityLearn(keys)
	--local ply = EntIndexToHScript(keys.player)
	--if(ply==nil)then
	  --return
	--end
	--local caster = ply:GetAssignedHero()
--end

function THDOTSGameMode:Levelup(keys)
	if G_IsAIMode == true then
		for k,v in pairs(G_Bot_List) do
			if v == keys.player then
				ply = PlayerResource:GetPlayer(v)
				hero = ply:GetAssignedHero()
				if hero:GetLevel()%3 == 0 then
					for i=0,16 do
						local ability = hero:GetAbilityByIndex(i)
						if ability~=nil then
							local level = math.min((ability:GetLevel() + 1),ability:GetMaxLevel())
							ability:SetLevel(level)
						end
					end
				end
			end
		end
	end
end

function THDOTSGameMode:BotUpGradeAbilityCommon(caster)
	-- local unitNameSlot = G_BOT_Ability_list[caster:GetUnitName()]
	-- local abilitySlot = nil
	-- if unitNameSlot~=nil then
	-- 	abilitySlot = unitNameSlot[caster:GetLevel()]
	-- end
	-- if abilitySlot ~= nil then
	-- 	local ability = caster:GetAbilityByIndex(abilitySlot)
	-- 	ability:UpgradeAbility(true)
	-- else
	-- 	for i=0,16 do
	-- 	 	local ability = caster:GetAbilityByIndex(i)
	-- 	 	if ability:CanAbilityBeUpgraded() then
	-- 			ability:UpgradeAbility(true)
	-- 			break
	-- 		end
	-- 	end 
	-- end
	--caster:SetAbilityPoints(0)
end

function THDOTSGameMode:AutoAssignPlayer(keys)
	--PrintTable(keys)
	-- 这里调用CaptureGameMode这个函数，执行游戏模式初始化
	THDOTSGameMode:CaptureGameMode()
  
	-- 这里的index是玩家的index 0-9，但是EntIndexToHScript需要1-10，所以要+1
	local entIndex = keys.index+1
	local ply = EntIndexToHScript(entIndex)

	if(ply~=nil)then
		ply:SetContextThink(DoUniqueString("Thdots_Listen_Select_Hero"),
			function()
				local hero = ply:GetAssignedHero()
				-- 确认已经获取到这个英雄
				if (hero ~= nil) then
          --[[local effectIndex = ParticleManager:CreateParticle("particles/environment/thd_rain.vpcf", PATTACH_CUSTOMORIGIN, hero)
          ParticleManager:SetParticleControl(effectIndex, 0, hero:GetOrigin()+Vector(0,0,500))
          ParticleManager:SetParticleControl(effectIndex, 1, hero:GetOrigin())]]--
					self:PrecacheHeroResource(hero)
          hero.isHeroRemovedItem = FALSE
          hero:SetContextThink(DoUniqueString("OnHeroSpawned"), 
            function()
              CheckItemModifies(hero)
              return 0.1
            end,0.1
          )
          --print(MAX_HERO_ID)
          --AddHeroesWearables(hero)
          --RemoveWearables(hero)
          local model = hero:FirstMoveChild()
          while model ~= nil do
            local modal2 = model:NextMovePeer()
            if model:GetClassname() == "dota_item_wearable" then
                table.insert(hsj_hero_wearables,model)
            end
            model = modal2
          end

          hero:NotifyWearablesOfModelChange(false)

          if hero:GetModelName() == "models/heroes/crystal_maiden/crystal_maiden_arcana.vmdl" then
            hero:SetModel("models/thd2/marisa/marisa_mmd.vmdl")
            hero:SetOriginalModel("models/thd2/marisa/marisa_mmd.vmdl")
          end

          if hero:GetModelName() == "models/heroes/zeus/zeus_arcana.vmdl" then
            hero:SetModel("models/thd2/kanako/kanako_mmd.vmdl")
            hero:SetOriginalModel("models/thd2/kanako/kanako_mmd.vmdl")
          end
          return nil
				end
				return 0.1
			end
		,0.1)
	end

  -- 获取玩家的ID
  local playerID = ply:GetPlayerID()
  
  -- 存入相应变量
  self.vUserIds[keys.userid] = ply
  self.vSteamIds[PlayerResource:GetSteamAccountID(playerID)] = ply
  
  -- 如果玩家的ID是-1的话，也就是还没有分配玩家阵营，那么就分配一下队伍
  if  playerID == -1 then
    -- 如果天辉玩家数量>夜魇玩家数量
    if #self.vRadiant > #self.vDire then
      -- 那么就把这个玩家分配给夜魇
      ply:SetTeam(DOTA_TEAM_BADGUYS)
      --ply:__KeyValueFromInt('teamnumber', DOTA_TEAM_BADGUYS)
      -- 存入对应的table
      table.insert (self.vDire, ply)
    else
      ply:SetTeam(DOTA_TEAM_GOODGUYS)
      --ply:__KeyValueFromInt('teamnumber', DOTA_TEAM_GOODGUYS)
      table.insert (self.vRadiant, ply)
    end
    playerID = ply:GetPlayerID()
  end

  --[[ 自动分配英雄，使用的依然是Timer
  self:CreateTimer('assign_player_'..entIndex,{
    endTime = Time(),
    callback = function(dota2x, args)
    -- 确定游戏已经开始了（有时候也不必要有这个判断，根据实际情况）
      if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME then
      -- 如果这个玩家没有英雄，那么就给他创建一个
        local heroEntity = ply:GetAssignedHero()
        if heroEntity == nil then
          PlayerResource:CreateHeroForPlayer("npc_dota_hero_axe",ply)
        end
        return Time() + 1.0
      end
  end
})]]--
end



function THDOTSGameMode:getItemByName( hero, name )
  for i=0,11 do
	local item = hero:GetItemInSlot( i )
	if item ~= nil then
	  local lname = item:GetAbilityName()
	  if lname == name then
		return item
	  end
	end
  end

  return nil
end

function THDOTSGameMode:PrecacheHeroResource(hero)
	local heroName = hero:GetClassname()
	local context

	local abilityEx
	local modifierRemove

	--DeepPrintTable()
	--motion:
	--motion:EnableMotion()

	if(heroName == "npc_dota_hero_slark")then
		require( 'abilities/abilityAya' )
	--	abilityEx = hero:FindAbilityByName("ability_thdotsr_Aya05")
		abilityEx = hero:FindAbilityByName("ability_thdots_Aya05")		
		abilityEx:SetLevel(1)
	elseif(heroName == "npc_dota_hero_vengefulspirit")then
		abilityEx = hero:FindAbilityByName("ability_thdots_hatateEx")
		abilityEx:SetLevel(1)		
	elseif(heroName == "npc_dota_hero_lina")then
		require( 'abilities/abilityReimu' )
		require( 'abilities/abilityReisen' )
		abilityEx = hero:FindAbilityByName("ability_thdots_reimu05")
		abilityEx:SetLevel(1)
	elseif(heroName == "npc_dota_hero_clinkz")then
		abilityEx = hero:FindAbilityByName("ability_thdots_wriggle04")
		abilityEx:SetLevel(1)		
		
	elseif(heroName == "npc_dota_hero_juggernaut")then
		require( 'abilities/abilityYoumu' )
		abilityEx = hero:FindAbilityByName("ability_thdots_youmu05")
		abilityEx:SetLevel(1)	
	elseif(heroName == "npc_dota_hero_earthshaker")then
		require( 'abilities/abilityTensi' )
	--	abilityEx = hero:FindAbilityByName("ability_thdots_tensi03")
	--	abilityEx:SetLevel(1)
	elseif(heroName == "npc_dota_hero_centaur")then
		abilityEx = hero:FindAbilityByName("ability_thdots_yugi05")
		abilityEx:SetLevel(1)		
	elseif(heroName == "npc_dota_hero_dark_seer")then
		require( 'abilities/abilityByakuren' )
		abilityEx = hero:FindAbilityByName("surge_byakuren")
		abilityEx:SetLevel(1)
		abilityEx = hero:FindAbilityByName("ability_thdots_byakuren04")
		abilityEx:SetLevel(1)
	elseif(heroName == "npc_dota_hero_crystal_maiden")then
		require( 'abilities/abilityMarisa' )
	elseif(heroName == "npc_dota_hero_necrolyte")then
		require( 'abilities/abilityYuyuko' )
		hero:SetContextNum("ability_yuyuko_Ex_deadflag",FALSE,0)
	--	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(THDOTSGameMode, 'OnTHDOTSDamageFilter'), self)
		abilityEx = hero:FindAbilityByName("ability_thdots_yuyukoEx")
		abilityEx:SetLevel(1)
		abilityEx2 = hero:FindAbilityByName("ability_thdotsr_yuyukoEx")
		abilityEx2:SetLevel(1)		
		
	elseif(heroName == "npc_dota_hero_templar_assassin")then
		require( 'abilities/abilitySakuya' )
		abilityEx = hero:FindAbilityByName("ability_thdots_sakuyaEx")
		abilityEx:SetLevel(1)
	elseif(heroName == "npc_dota_hero_naga_siren")then
		require( 'abilities/abilityFlandre' )
		abilityEx = hero:FindAbilityByName("ability_thdots_flandreEx2")
		abilityEx:SetLevel(1)
	elseif(heroName == "npc_dota_hero_ogre_magi")then
		abilityEx = hero:FindAbilityByName("ability_thdots_suwako05")
		abilityEx:SetLevel(1)		
	elseif(heroName == "npc_dota_hero_lion") then
		require( 'abilities/abilitySanae' )
		abilityEx = hero:FindAbilityByName("ability_thdots_sanaeex")
		abilityEx:SetLevel(1)	
	elseif(heroName == "npc_dota_hero_leshrac") then
		abilityEx = hero:FindAbilityByName("ability_thdots_lily05")
		abilityEx:SetLevel(1)		
	elseif(heroName == "npc_dota_hero_chaos_knight")then
		require( 'abilities/abilityMokou' )
		abilityEx = hero:FindAbilityByName("ability_thdots_mokou03")
		abilityEx:SetLevel(1)
		abilityEx2 = hero:FindAbilityByName("ability_thdots_mokou05")
		abilityEx2:SetLevel(3)		
		
	elseif(heroName == "npc_dota_hero_drow_ranger")then
		abilityEx = hero:FindAbilityByName("ability_thdots_koishi05")
		abilityEx:SetLevel(1)
	--	abilityEx2 = hero:FindAbilityByName("nevermore_dark_lord")
	--	abilityEx2:SetLevel(1)
	    hero:SetContextThink("ability_cirno_ex", 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if hero:GetIntellect()~=0 then
					hero:ModifyIntellect(0-hero:GetIntellect())
				end
			  return 0.1
			end, 
		0.1)
	elseif(heroName == "npc_dota_hero_sniper")then
		abilityEx = hero:FindAbilityByName("ability_thdots_Utsuho05")
		abilityEx:SetLevel(1)	
		--hero:EnableMotion()
	------------------------------------------------------	
	elseif(heroName == "npc_dota_hero_mirana")then
		--abilityEx = hero:FindAbilityByName("ability_thdots_reisenEx")
		--abilityEx:SetLevel(1)
		--hero:EnableMotion()
		
		abilityEx = hero:FindAbilityByName("ability_thdotsr_reisenEx")
		abilityEx:SetLevel(1)
		
	--	abilityEx = hero:FindAbilityByName("ability_thdots_reisenOldEx")
	--	abilityEx:SetLevel(1)
	--	abilityEx2 = hero:FindAbilityByName("phantom_lancer_juxtapose")
	--	abilityEx2:SetLevel(4)
	------------------------------------------------------	
	elseif(heroName == "npc_dota_hero_warlock")then
		abilityEx = hero:FindAbilityByName("ability_thdots_remilia05")
		abilityEx:SetLevel(1)	
	elseif(heroName == "npc_dota_hero_silencer")then
		hero.ability_eirinEx_count = 0
		hero:SetContextThink(DoUniqueString("Thdots_eirinEx_passive"),
		  function()
			if GameRules:IsGamePaused() then return 0.03 end
			hero.ability_eirinEx_count = hero.ability_eirinEx_count + 1
			if(hero.ability_eirinEx_count >= 81)then
			  hero.ability_eirinEx_count = 0
			  hero:SetBaseIntellect(hero:GetBaseIntellect()+1)
			end
			if(hero:FindModifierByName("modifier_silencer_int_steal")~=nil)then
			  hero:RemoveModifierByName("modifier_silencer_int_steal")
			end
			return 1.0
		  end
		,1.0)
		abilityEx = hero:FindAbilityByName("disruptor_kinetic_field")
		abilityEx:SetLevel(1)		
		
	elseif(heroName == "npc_dota_hero_bounty_hunter")then
		abilityEx = hero:FindAbilityByName("ability_system_criticalstrike")
		abilityEx:SetLevel(1)
	elseif(heroName == "npc_dota_hero_tinker")then
		abilityEx = hero:FindAbilityByName("ability_thdots_yumemiEx")
		abilityEx:SetLevel(1)
	elseif(heroName == "npc_dota_hero_axe")then
		hero:SetContextThink("ability_cirno_ex", 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if hero:GetIntellect()~=9 then
					hero:ModifyIntellect(9-hero:GetIntellect())
				end
			  return 0.1
			end, 
		0.1)
	elseif(heroName == "npc_dota_hero_kunkka")then
		GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(THDOTSGameMode, 'OnMinamitsu04Order'), self)
		--abilityEx = hero:FindAbilityByName("ability_thdots_minamitsu05talent")
		--abilityEx:SetLevel(1)		
	elseif(heroName == "npc_dota_hero_puck")then
		abilityEx = hero:FindAbilityByName("ability_thdots_RanEx")
		abilityEx:SetLevel(1)
	elseif(heroName == "npc_dota_hero_venomancer")then
	--	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(THDOTSGameMode, 'OnTHDOTSDamageFilter'), self)
		abilityEx = hero:FindAbilityByName("ability_thdots_YuukaEx")
		abilityEx:SetLevel(1)
		abilityEx2 = hero:FindAbilityByName("ability_thdots_yuuka03")
		abilityEx2:SetLevel(1)		
	elseif(heroName == "npc_dota_hero_visage")then
		abilityEx = hero:FindAbilityByName("ability_thdots_MargatroidEx")
		abilityEx:SetLevel(1)

		local doll=CreateUnitByName(
					"ability_margatroidex_doll",
					hero:GetOrigin(),
					false,
					hero,
					hero,
					hero:GetTeam())
		doll:SetModel("models/alice/penglai.vmdl")
		doll:SetOriginalModel("models/alice/penglai.vmdl")
		doll:RemoveSelf()
	elseif(heroName == "npc_dota_hero_phantom_assassin")then
		abilityEx = hero:FindAbilityByName("ability_thdots_nueEx")
		abilityEx:SetLevel(1)
	elseif(heroName == "npc_dota_hero_elder_titan")then
	    abilityEx = hero:FindAbilityByName("ability_thdots_komachi_soul_explode_all")
		abilityEx:SetLevel(1)
	    abilityEx = hero:FindAbilityByName("ability_thdots_komachi05")
		abilityEx:SetLevel(1)		
		--abilityEx = hero:FindAbilityByName("techies_remote_mines")
		--abilityEx:SetLevel(1)
	elseif(heroName == "npc_dota_hero_rubick")then
		abilityEx = hero:FindAbilityByName("ability_thdots_satori05")
		abilityEx:SetLevel(1)
	elseif(heroName == "npc_dota_hero_antimage")then
		abilityEx = hero:FindAbilityByName("ability_thdots_mystia05")
		abilityEx:SetLevel(1)	
	elseif(heroName == "npc_dota_hero_ursa")then
		abilityEx = hero:FindAbilityByName("ability_thdotsr_Nazrin05")
		abilityEx:SetLevel(1)		
		
	end
end

function THDOTSGameMode:OnMinamitsu04Order(keys)
  if keys.units["0"] ~= nil then
	local orderUnit = EntIndexToHScript(keys.units["0"])
	if orderUnit ~= nil then
	  if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
		if orderUnit:GetClassname() == "npc_dota_hero_kunkka" then
		  if keys.entindex_target == orderUnit.ability_minamitsu_ship_index then
			local ship = EntIndexToHScript(orderUnit.ability_minamitsu_ship_index)
			self:OnMinamitsuMoveToShip(orderUnit,ship)
		  end
		elseif orderUnit:GetUnitName() == "ability_minamitsu_04_ship"  then
		  if keys.entindex_target == orderUnit.ability_minamitsu_hero_index then
			local hero = EntIndexToHScript(orderUnit.ability_minamitsu_hero_index)
			self:OnMinamitsuMoveToShip(hero,orderUnit)
			return false
		  end
		end
	  elseif keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		if orderUnit:GetClassname() == "npc_dota_hero_kunkka" then
		  if orderUnit.IsDriving then
			local ship = orderUnit.ability_minamitsu_ship
			if ship ~= nil and ship:IsNull() == false then
			  ship:MoveToPosition(Vector(keys.position_x,keys.position_y,keys.position_z))
			end
		  end
		end
	  end
	end
  end
  return true
end



function THDOTSGameMode:OnTHDOTSDamageFilter(keys)
	if keys.entindex_attacker_const == nil or keys.entindex_victim_const == nil then
		return true
	end
	local unit = EntIndexToHScript(keys.entindex_attacker_const)
	local target = EntIndexToHScript(keys.entindex_victim_const)

	if unit ~= nil and unit:IsNull() == false and target ~= nil and target:IsNull() == false then
		if unit:GetUnitName()=="ability_yuuka_flower" and target:IsBuilding() then
			keys.damage = keys.damage * 0.5
		end
	--	if unit:GetUnitName()=="ability_margatroid_doll" and target:IsBuilding() then
	--		keys.damage = 0
	--	end
	--	if unit:GetUnitName()=="ability_margatroidex_doll" and target:IsBuilding() then
	--		keys.damage = 0
	--	end			
		if target:GetClassname()=="npc_dota_hero_necrolyte" and target:GetContext("ability_yuyuko_Ex_deadflag") == FALSE and target:IsRealHero() == true then
			if keys.damage >= target:GetHealth() then
				local vecCaster = target:GetOrigin()
				local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/yuyuko/ability_yuyuko_04_effect.vpcf", PATTACH_CUSTOMORIGIN, target)
				ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
				ParticleManager:DestroyParticleSystem(effectIndex,false)

				effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/yuyuko/ability_yuyuko_04_effect_a.vpcf", PATTACH_CUSTOMORIGIN, target)
				ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
				ParticleManager:SetParticleControl(effectIndex, 5, target:GetOrigin())
				ParticleManager:DestroyParticleSystem(effectIndex,false)

				target:SetHealth(target:GetMaxHealth())
				UnitDisarmedTarget(target,target,8)
				UnitNoDamageTarget(target,target,8)
				target:SetContextNum("ability_yuyuko_Ex_deadflag",TRUE,0)
				local gameTime = GameRules:GetGameTime()
				target:SetContextThink(DoUniqueString("abilityyuyuko_Ex_undead_timer"), 
					function()
						if GameRules:IsGamePaused() then return 0.03 end
						if GameRules:GetGameTime() - gameTime <= 7.1 then
							if target:IsAlive() == false then
								target:SetContextNum("ability_yuyuko_Ex_deadflag",FALSE,0)
								return nil
							end
							if(GetDistanceBetweenTwoVec2D(target:GetOrigin(),vecCaster)>300)then
								target:SetOrigin(vecCaster)
								SetTargetToTraversable(target)
							end
							return 0.03
						else
							if(target~=nil)then
								target:Kill(keys.ability, unit)
							else
								target:Kill(keys.ability, nil)
							end
							target:SetContextNum("ability_yuyuko_Ex_deadflag",FALSE,0)
							return nil
						end
					end, 
				0.03) 
				return false
			end
		end
	end
	
--    local damage = filterTable["damage"] --Post reduction
 --   local ability = EntIndexToHScript( filterTable["entindex_inflictor_const"] )
  --  local victim = EntIndexToHScript( filterTable["entindex_victim_const"] )
   -- local attacker = EntIndexToHScript( filterTable["entindex_attacker_const"] )
   -- local damagetype = filterTable["damagetype_const"]	
	local damagetypex = keys.damagetype_const
	local attackerx = EntIndexToHScript(keys.entindex_attacker_const)	
	local victimx	= EntIndexToHScript(keys.entindex_victim_const)
--	local ability = EntIndexToHScript(keys.entindex_inflictor_const)
	local damagex  = keys.damage

--	local damagetype = keys.damagetype_const
--	local attacker = keys.entindex_attacker_const	
--	local victim	= keys.entindex_victim_const
--	local ability = keys.entindex_inflictor_const
--	local damage  = keys.damage	
	
	if attackerx:IsHero() then
	
		if damagetypex == 1 then
		
			if attackerx:HasModifier("modifier_item_last_whisper")	 then
				if victimx:GetPhysicalArmorValue() > 0 then
					local damagex  = keys.damage	
					local varmor = victimx:GetPhysicalArmorValue()
					local truedamage = damagex/ (1- (0.052*varmor )/(0.9 + 0.048 * varmor))
					local varmor2 = victimx:GetPhysicalArmorValue()*0.6				

					local damagepen = truedamage * (1- (0.052*varmor2 )/(0.9 + 0.048 * varmor2))	
			--		if EntIndexToHScript(keys.entindex_inflictor_const) then
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, victimx, damagepen, nil)	
			--		end
					keys.damage = damagepen
				--	print(keys.damage)					
					
				end
			end			
		
		end
	
	end
	
	
	return true
end

function CDOTA_BaseNPC:HasAmorPenetration()
    if self:HasItemInInventory("item_horse_red") then
	
	
		return 1
	
	else 
	
		return	0

	end
end

function THDOTSGameMode:OnMinamitsuMoveToShip(hero,ship)
  local ability = hero:FindAbilityByName("ability_thdots_minamitsu04")
  if ability ~= nil then
	hero:SetContextThink("ability_thdots_minamitsu_04_move_to_ship",
		 function ()
			if GameRules:IsGamePaused() then return 0.03 end
			if hero ~= nil and ship ~= nil and ship:IsNull()==false and hero:IsNull() == false then
			  local shipAbility = ship:FindAbilityByName("ability_thdots_minamitsu04_unit_upload")
			  ship:CastAbilityOnTarget(hero,shipAbility, hero:GetPlayerOwnerID())
			else
		  return nil
		end
	  end,
	0.03)
  end
end

print ('[THDOTS] THDOTS Starting..' )

DEBUG = true
GameMode = nil

TRUE = 1
FALSE = 0
ADD_HERO_WEARABLES_LOCK = 0
ADD_HERO_WEARABLES_ILLUSION_LOCK = 0


if THDOTSGameMode == nil then
	THDOTSGameMode = class({})
end

-- Load Stat collection (statcollection should be available from any script scope)
-- require('lib/statcollection')
-- require('lib/loadhelper')
require('lib/keyvalues')
require('lib/illusionmanager')
require('lib/illusionmanagerthd')
require('lib/player_resource')
require('lib/timers')
require('lib/PseudoRNG')

--[[
statcollection.addStats({
	modID = '18a7102085aa084ebcb112a1093c9e02' --GET THIS FROM http://getdotastats.com/#d2mods__my_mods
})
--]]
-- setmetatable是lua面向对象的编程方法~

model_lookup = {}
model_lookup["npc_dota_hero_lina"] = "models/thd2/hakurei_reimu/hakurei_reimu_mmd.vmdl"
model_lookup["npc_dota_hero_crystal_maiden"] = "models/thd2/marisa/marisa_mmd.vmdl"
model_lookup["npc_dota_hero_juggernaut"] = "models/thd2/youmu/youmu_mmd.vmdl"
model_lookup["npc_dota_hero_slark"] = "models/aya/aya_mmd.vmdl"
model_lookup["npc_dota_hero_earthshaker"] = "models/thd2/tenshi/tenshi_mmd.vmdl"
model_lookup["npc_dota_hero_dark_seer"] = "models/thd2/hiziri_byakuren/hiziri_byakuren_mmd.vmdl"
model_lookup["npc_dota_hero_necrolyte"] = "models/thd2/yuyuko/yuyuko_mmd.vmdl"
model_lookup["npc_dota_hero_templar_assassin"] = "models/thd2/sakuya/sakuya_mmd.vmdl"
model_lookup["npc_dota_hero_naga_siren"] = "models/thd2/flandre/flandre_mmd.vmdl"
model_lookup["npc_dota_hero_chaos_knight"] = "models/thd2/mokou/mokou_mmd.vmdl"
model_lookup["npc_dota_hero_centaur"] = "models/thd2/yuugi/yuugi_mmd.vmdl"
model_lookup["npc_dota_hero_tidehunter"] = "models/thd2/suika/suika_mmd.vmdl"
model_lookup["npc_dota_hero_life_stealer"] = "models/thd2/rumia/rumia_mmd.vmdl"
model_lookup["npc_dota_hero_razor"] = "models/thd2/iku/iku_mmd.vmdl"
model_lookup["npc_dota_hero_sniper"] = "models/thd2/utsuho/utsuho_mmd.vmdl"
model_lookup["npc_dota_hero_silencer"] = "models/thd2/eirin/eirin_mmd.vmdl"
model_lookup["npc_dota_hero_furion"] = "models/thd2/kaguya/kaguya.vmdl"
model_lookup["npc_dota_hero_mirana"] = "models/thd2/reisen/reisen.vmdl"

--[[model_lookup["npc_dota_hero_lina"] = "models/heroes/lina/lina.vmdl"
model_lookup["npc_dota_hero_crystal_maiden"] = "models/heroes/crystal_maiden/crystal_maiden.vmdl"
model_lookup["npc_dota_hero_juggernaut"] = "models/heroes/juggernaut/juggernaut.vmdl"
model_lookup["npc_dota_hero_slark"] = "models/heroes/slark/slark.vmdl"
model_lookup["npc_dota_hero_earthshaker"] = "models/heroes/earthshaker/earthshaker.vmdl"
model_lookup["npc_dota_hero_dark_seer"] = "models/heroes/dark_seer/dark_seer.vmdl"
model_lookup["npc_dota_hero_necrolyte"] = "models/heroes/necrolyte/necrolyte.vmdl"
model_lookup["npc_dota_hero_templar_assassin"] = "models/heroes/lanaya/lanaya.vmdl"
model_lookup["npc_dota_hero_naga_siren"] = "models/heroes/siren/siren.vmdl"
model_lookup["npc_dota_hero_chaos_knight"] = "models/heroes/chaos_knight/chaos_knight.vmdl"
model_lookup["npc_dota_hero_centaur"] = "models/heroes/centaur/centaur.vmdl"
model_lookup["npc_dota_hero_tiny"] = "models/heroes/tiny_01/tiny_01.vmdl"
model_lookup["npc_dota_hero_life_stealer"] = "models/heroes/life_stealer/life_stealer.vmdl"
model_lookup["npc_dota_hero_razor"] = "models/heroes/razor/razor.vmdl"
model_lookup["npc_dota_hero_sniper"] = "models/heroes/sniper/sniper.vmdl"
model_lookup["npc_dota_hero_silencer"] = "models/heroes/silencer/silencer.vmdl"
model_lookup["npc_dota_hero_furion"] = "models/heroes/furion/furion.vmdl"
model_lookup["npc_dota_hero_mirana"] = "models/heroes/mirana/mirana.vmdl"]]--



-- 以下的这些函数，大多都是把传递的数值Print出来
-- PrintTable和print的东西，都会显示在控制台上
-- PrintTable会显示例如
-- caster:
--        table:0x00ff000
-- caster_entindex:195
-- target:
--        table:0x00ff000
-- 这样的内容，那么我们就可以通过keys.caster_entindex来获取这个caster的Entity序号
-- 再通过
-- EntIndexToHScript(keys.caster_entindex)
-- 就可以获取这个施法者相对应的hScript了

function THDOTSGameMode:AbilityUsed(keys)
	local ply = EntIndexToHScript(keys.PlayerID+1)
	if(ply==nil)then
		return
	end
	local caster = ply:GetAssignedHero()
	if(caster==nil)then
		return
	end
	local ability = caster:FindAbilityByName(keys.abilityname)
	--mokou
	if(keys.abilityname == 'phoenix_supernova')then
		local mokouAbility1 = caster:FindAbilityByName("ability_thdots_mokou01")
		local mokouAbility = caster:FindAbilityByName("ability_thdots_mokou04")
		if(mokouAbility1 ~= nil or mokouAbility ~= nil)then
			if(mokouAbility:GetLevel()>0)then
				local mokouCooldown = mokouAbility:GetCooldownTimeRemaining()-ability:GetLevel()
				if(mokouCooldown >= 0 and mokouAbility ~= nil)then
					Timer.Wait 'ability_thdots_mokou04_cooldown' (8.1-ability:GetLevel(),
						function()
							mokouAbility:StartCooldown(mokouCooldown-ability:GetLevel())
						end
					)
				end
			end
			if(mokouAbility1:GetLevel()>0)then
				local mokouCooldown1 = mokouAbility1:GetCooldownTimeRemaining()
				if(mokouCooldown1>=0)then
					Timer.Wait 'ability_thdots_mokou04_cooldown' (8.1-ability:GetLevel(),
					function()
						mokouAbility1:StartCooldown(mokouCooldown1-ability:GetLevel())
					end
					)
				end
			end 
		end
	end
	--幻象
	--[[if(keys.abilityname == 'naga_siren_mirror_image')then
		if(ADD_HERO_WEARABLES_ILLUSION_LOCK==TRUE)then
			return
		end
		ADD_HERO_WEARABLES_ILLUSION_LOCK=TRUE
		Timer.Wait 'ability_thdots_flandre_01' (0.5,
				function()
					local illusions = FindUnitsInRadius(
						 caster:GetTeam(),    
						 caster:GetOrigin(),    
						 nil,         
						 3000,    
						 DOTA_UNIT_TARGET_TEAM_FRIENDLY,
						 DOTA_UNIT_TARGET_ALL,
						 DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, 
						 FIND_CLOSEST,
						 false
					)

					for _,v in pairs(illusions) do
						if(v:IsIllusion())then
							AddUnitWearablesByHero(v,caster)
						end
					end
					ADD_HERO_WEARABLES_ILLUSION_LOCK=FALSE
				end
		)
	end]]--
	--[[if(caster:FindModifierByName("modifier_item_nuclear_stick")~=nil)then
		local nuclearCooldown = ability:GetCooldownTimeRemaining()
		ability:StartCooldown(nuclearCooldown * 0.75)
	end]]--
	--PrintTable(keys)
end



function THDOTSGameMode:OnGameRunePickup(keys)
	--[[local ply = EntIndexToHScript(keys.PlayerID+1)
	if(ply==nil)then
		return
	end
	local caster = ply:GetAssignedHero()
	local rune = keys.rune
	if(rune == 2)then
		if(ADD_HERO_WEARABLES_ILLUSION_LOCK==TRUE)then
			return
		end
		ADD_HERO_WEARABLES_ILLUSION_LOCK=TRUE
		Timer.Wait 'ability_thdots_illusion' (0.5,
				function()
					local illusions = FindUnitsInRadius(
						 caster:GetTeam(),    
						 caster:GetOrigin(),    
						 nil,         
						 3000,    
						 DOTA_UNIT_TARGET_TEAM_FRIENDLY,
						 DOTA_UNIT_TARGET_ALL,
						 DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, 
						 FIND_CLOSEST,
						 false
					)

					for _,v in pairs(illusions) do
						if(v:IsIllusion())then
							local model_name
							model_name = model_lookup[ caster:GetName() ]
							v:SetModel( model_name )
							v:SetOriginalModel( model_name )   
							v:MoveToPosition( v:GetAbsOrigin() )
						end
					end
					ADD_HERO_WEARABLES_ILLUSION_LOCK=FALSE
				end
		)
	end ]]--
end

function THDOTSGameMode:AbilityLearn(keys)
	local ply = EntIndexToHScript(keys.player)
	if(ply==nil)then
		return
	end
	local caster = ply:GetAssignedHero()
	
	local ability = caster:FindAbilityByName(keys.abilityname)
	

	--[[PrintTable(weapons)
	for _,v in pairs(weapons) do
		v:DetachFromParent()
		end]]--
		if(keys.abilityname == 'special_bonus_unique_murasa_1')then
		--if ability == caster:FindAbilityByName("special_bonus_unique_murasa_1") then
		
		caster:AddAbility("ability_thdots_minamitsu_talent"):SetLevel(1)
		end

end

function THDOTSGameMode:CleanupPlayer(keys)
	print('[DOTA2X] Player Disconnected ' .. tostring(keys.userid))
end

function THDOTSGameMode:CloseServer()
	-- 发送一个指令到服务器，指令内容为exit，告知服务器退出
	-- 可以在服务器里面尝试打exit，就可以知道这个指令是什么效果了
	SendToServerConsole('exit')
end

function THDOTSGameMode:PlayerConnect(keys)
	--PrintTable(keys)
	self.vUserNames[keys.userid] = keys.name
	if keys.bot == 1 then
		self.vBots[keys.userid] = 1
	end
end

local hook = nil
local attach = 0
local controlPoints = {}
local particleEffect = ""

function THDOTSGameMode:PlayerSay(keys)
	--PrintTable(keys)
	local ply = self.vUserIds[keys.userid]
	if ply == nil then
		return
	end
	-- 获取玩家的ID，0-9
	local plyID = ply:GetPlayerID()
	-- 检验是否有效玩家
	if not PlayerResource:IsValidPlayer(plyID) then
		return
	end
	-- 获取所说内容
	-- text这个key可以在上方通过PrintTable在控制台看到
	local text = keys.text
	-- 如果文本符合 -swap 1 3这样的内容
	local matchA, matchB = string.match(text, "^-swap%s+(%d)%s+(%d)")
	if matchA ~= nil and matchB ~= nil then
		-- 那么就，做点什么
	end

	-- Turns BGM on and off
	if text == "-bgmoff" then
		print("Turning BGM off")
		Timers:RemoveTimer("BGMTimer")
		ply:StopSound("BGM." .. choice)
	end

	if text == "-bgmon" then
		print("Turning BGM on")
		PlayBGM(ply)
	end
	


end

function THDOTSGameMode:AutoAssignPlayer(keys)
	--PrintTable(keys)
	-- 这里调用CaptureGameMode这个函数，执行游戏模式初始化
	THDOTSGameMode:CaptureGameMode()
end

function RemoveWearables( hero )
 Timers:CreateTimer( .3, function()
			-- Setup variables
			
			--local model_name = ""

			-- Check if npc is hero
			if not hero:IsHero() then return end

			-- Getting model name
			--[[if model_lookup[ hero:GetName() ] ~= nil and hero:GetModelName() ~= model_lookup[ hero:GetName() ] then
				model_name = model_lookup[ hero:GetName() ]
			else
				return nil
			end]]--

			-- Never got changed before
			local toRemove = {}
			local wearable = hero:FirstMoveChild()
			while wearable ~= nil do
				if wearable:GetClassname() == "dota_item_wearable" then
					table.insert( toRemove, wearable )
				end
				wearable = wearable:NextMovePeer()
			end

			-- Remove wearables
			for k, v in pairs( toRemove ) do
				v:RemoveSelf()
			end
		
			-- Set model
			--hero:SetModel( model_name )
			--hero:SetOriginalModel( model_name )
			--hero:MoveToPosition( hero:GetAbsOrigin() )

			return nil
		end
	)
end

function AddHeroesWearables(hero)
	Timers:CreateTimer(function()
		--print( "OnHeroSpawned in");
		-- Setup variables
		if(ADD_HERO_WEARABLES_LOCK == TRUE)then
			return 0.1
		end
		ADD_HERO_WEARABLES_LOCK = TRUE
		local model_name = ""

		-- Check if npc is hero
		if not hero:IsHero() then 
			ADD_HERO_WEARABLES_LOCK = FALSE 
			return nil
		end

		if hero.isHeroRemovedItem == TRUE and hero:GetModelName() == model_lookup[ hero:GetName() ] then
			ADD_HERO_WEARABLES_LOCK = FALSE
			return 0.1
		end

		-- Getting model name
		-- and hero:GetModelName() ~= model_lookup[ hero:GetName() ]
		if model_lookup[ hero:GetName() ] ~= nil then
			model_name = model_lookup[ hero:GetName() ]
			hero.isHeroRemovedItem = TRUE
			--print( "Swapping in: " .. model_name )
		else
			--print( "model_lookup: " .. model_lookup[ hero:GetName() ] )
			--print( "GetModelName: " .. hero:GetModelName() )
			ADD_HERO_WEARABLES_LOCK = FALSE
			return 0.1
		end

		-- Check if it's correct format
		if hero:GetModelName() ~= "models/development/invisiblebox.vmdl" then 
			--ADD_HERO_WEARABLES_LOCK = FALSE 
			--return nil 
		end

		-- Never got changed before
		local toRemove = {}
		local wearable = hero:FirstMoveChild()
		print( "wearable: " .. wearable:GetModelName() )
		while wearable ~= nil do
			if wearable:GetClassname() == "dota_item_wearable" then
				--print( "Removing wearable: " .. wearable:GetModelName() )
				table.insert( toRemove, wearable )
			end
			wearable = wearable:NextMovePeer()
		end

		-- Remove wearables
		for k, v in pairs( toRemove ) do
			--v:SetModel( "models/development/invisiblebox.vmdl" )
			v:RemoveSelf()
		end

		-- Set model
		hero:SetModel( model_name )
		hero:SetOriginalModel( model_name )     -- This is needed because when state changes, model will revert back
		hero:MoveToPosition( hero:GetAbsOrigin() )  -- This is needed because when model is spawned, it will be in T-pose
		ADD_HERO_WEARABLES_LOCK = FALSE

		return 0.1
	end)

	if hero:GetUnitName() == "npc_dota_hero_elder_titan" then
		hero:GetAbilityIndex(3):SetLevel(1)
	end
end

function AddUnitWearablesByHero(unit,hero)
	unit:SetContextThink(DoUniqueString("OnUnitSpawned"), 
		function()
			local model_name = ""
			
			-- Check if npc is hero
			if not hero:IsHero() then 
				return nil
			end
			
			-- Getting model name
			if model_lookup[ hero:GetName() ] ~= nil then
				model_name = model_lookup[ hero:GetName() ]
			else
				return 0.1
			end
			
			-- Never got changed before
			local toRemove = {}
			local wearable = unit:FirstMoveChild()
			while wearable ~= nil do
				if wearable:GetClassname() == "dota_item_wearable" then
					-- print( "Removing wearable: " .. wearable:GetModelName() )
					table.insert( toRemove, wearable )
				end
				wearable = wearable:NextMovePeer()
			end
			
			-- Remove wearables
			for k, v in pairs( toRemove ) do
				v:SetModel( "models/development/invisiblebox.vmdl" )
				v:RemoveSelf()
			end
			-- Set model
			unit:SetModel( model_name )
			unit:SetOriginalModel( model_name )     -- This is needed because when state changes, model will revert back
			unit:MoveToPosition( unit:GetAbsOrigin() )  -- This is needed because when model is spawned, it will be in T-pose
			return nil
		end,0.1
	)
end

function THDOTSGameMode:LoopOverPlayers(callback)
	for k, v in pairs(self.vPlayers) do
		-- Validate the player
		if IsValidEntity(v.hero) then
			-- Run the callback
			if callback(v, v.hero:GetPlayerID()) then
				break
			end
		end
	end
end

function THDOTSGameMode:ShopReplacement( keys )
	--PrintTable(keys)

	local plyID = keys.PlayerID
	if not plyID then return end

	local itemName = keys.itemname 
	
	local itemcost = keys.itemcost
end

function THDOTSGameMode:getItemByName( hero, name )
	for i=0,11 do
		local item = hero:GetItemInSlot( i )
		if item ~= nil then
			local lname = item:GetAbilityName()
			if lname == name then
				return item
			end
		end
	end

	return nil
end

function THDOTSGameMode:OnThink()
	-- 游戏模式循环执行的函数体

	-- 如果游戏阶段已经是游戏结束，那么也就没有必要循环执行了，return
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return
	end

	-- 追踪游戏时间，通过GameRules:GetGameTime()来获取，在PreGameTime，获取的就是负值
--	local now = GameRules:GetGameTime()
--	if THDOTSGameMode.t0 == nil then
--		THDOTSGameMode.t0 = now
--	end

--	local dt = now - THDOTSGameMode.t0
--	THDOTSGameMode.t0 = now

	return 1.0
end

function THDOTSGameMode:HandleEventError(name, event, err)
	-- 在控制台显示报错
	print(err)

	-- 指定相关字段
	name = tostring(name or 'unknown')
	event = tostring(event or 'unknown')
	err = tostring(err or 'unknown')

	-- 报出对应错误 - say用来在聊天框显示一段信息，第一个参数指说话者，nil则显示为console
	-- 第二个参数为信息
	-- 第三个为是否队伍聊天，false指代显示给所有人
	Say(nil, name .. ' threw an error on event '..event, false)
	Say(nil, err, false)

	-- 避免同样的一个错误被循环报错
	if not self.errorHandled then
		self.errorHandled = true
	end
end

function THDOTSGameMode:ExampleConsoleCommand()
	print( '******* Example Console Command ***************' )
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer then
		local playerID = cmdPlayer:GetPlayerID()
		if playerID ~= nil and playerID ~= -1 then
			
		end
	end

	print( '*********************************************' )
end

function PlayBGM(player)
	local lastChoice = 0
	local delayInBetween = 3.0

	Timers:CreateTimer(function()
		choice = RandomInt(1,2)
		--if choice == lastChoice then return 0.1 end
		--EmitSoundOnClient(songName, player) 
		--StartSoundEvent("Music_Thdots.BackGround", player)
		--return 844+delayInBetween

		if choice == 1 then 
			EmitSoundOnClient("Music_Thdots.BackGround", player) lastChoice = 1 
			return 844+delayInBetween
		elseif 
			choice == 2 then 
			EmitSoundOnClient("Music_Thdots.BackGround2", player) lastChoice = 2 
			return 2692+delayInBetween 
		end

		--[[elseif choice == 3 then EmitSoundOnClient(songName, player)  lastChoice = 3 return 138+delayInBetween
		elseif choice == 4 then  EmitSoundOnClient(songName, player) lastChoice = 4 return 149+delayInBetween
		elseif choice == 5 then  EmitSoundOnClient(songName, player) lastChoice = 5 return 183+delayInBetween
		elseif choice == 6 then  EmitSoundOnClient(songName, player) lastChoice = 6 return 143+delayInBetween
		elseif choice == 7 then  EmitSoundOnClient(songName, player) lastChoice = 7 return 184+delayInBetween
		else EmitSoundOnClient(songName, player) lastChoice = 8 return 181+delayInBetween end]]--
	end)
end

function THDOTSGameMode:OnMinamitsu04Order(keys)
	if keys.units["0"] ~= nil then
		local orderUnit = EntIndexToHScript(keys.units["0"])
		if orderUnit ~= nil then
			if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
				if orderUnit:GetClassname() == "npc_dota_hero_kunkka" then
					if keys.entindex_target == orderUnit.ability_minamitsu_ship_index then
						local ship = EntIndexToHScript(orderUnit.ability_minamitsu_ship_index)
						self:OnMinamitsuMoveToShip(orderUnit,ship)
					end
				elseif orderUnit:GetUnitName() == "ability_minamitsu_04_ship"  then
					if keys.entindex_target == orderUnit.ability_minamitsu_hero_index then
						local hero = EntIndexToHScript(orderUnit.ability_minamitsu_hero_index)
						self:OnMinamitsuMoveToShip(hero,orderUnit)
						return false
					end
				end
			elseif keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
				if orderUnit:GetClassname() == "npc_dota_hero_kunkka" then
					if orderUnit.IsDriving then
						local ship = orderUnit.ability_minamitsu_ship
						if ship ~= nil and ship:IsNull() == false then
							ship:MoveToPosition(Vector(keys.position_x,keys.position_y,keys.position_z))
						end
					end
				end
			end
		end
	end
	return true
end

function THDOTSGameMode:OnMinamitsuMoveToShip(hero,ship)
	local ability = hero:FindAbilityByName("ability_thdots_minamitsu04")
	if ability ~= nil then
		hero:SetContextThink("ability_thdots_minamitsu_04_move_to_ship",
			function ()
				if hero ~= nil and ship ~= nil and ship:IsNull()==false and hero:IsNull() == false then
					local shipAbility = ship:FindAbilityByName("ability_thdots_minamitsu04_unit_upload")
					ship:CastAbilityOnTarget(hero,shipAbility, hero:GetPlayerOwnerID())
				else
					return nil
				end
			end,
		0.03)
	end
end

-- EVENTS

function THDOTSGameMode:OnGameRulesStateChange(keys)
	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		--	print(GetMapName())
		if GetMapName() == "1_thdots_map" then
			print(GetMapName())
			SendToServerConsole("customgamesetup_shuffle_players")
		end			
		if GetMapName() == "3_thdots_map_shuffle" then
		
			print("Shuffle teams!")
			SendToServerConsole("customgamesetup_shuffle_players")
		end
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
		THDOTSGameMode:InitRunes()
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		THDOTSGameMode:InitTowers()
		THDOTSGameMode:InitShrines()
		THDOTSGameMode:InitBarracks()
		THDOTSGameMode:InitThrones()
		THDOTSGameMode:Setupgoliath()
		THDOTSGameMode:Spawnneutrals()		
		--THDOTSGameMode:InitSiegecreep()
		for i = 0, PlayerResource:GetPlayerCount() - 1 do
			if player ~= nil then
				PlayBGM(PlayerResource:GetPlayer(i))
			end
		end

		Timers:CreateTimer(0.05, function()
			THDOTSGameMode:SpawnRunes()
			return 120.0
		end)
		Timers:CreateTimer(0.05, function()
			THDOTSGameMode:SpawnRunes2()
			return 300.0
		end)		
		Timers:CreateTimer(3000, function()
			THDOTSGameMode:Setupgoliath2()
			return 3000
		end)		
		
	end
end

function THDOTSGameMode:OnEntityKilled( keys )
	-- 储存被击杀的单位
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	-- 储存杀手单位
	local killerEntity = EntIndexToHScript( keys.entindex_attacker )
	
	
	if killedUnit:GetUnitName() == "npc_dota_observer_wards" then
	
		if killerEntity:IsHero() then
		
			local owner = killerEntity:GetPlayerOwner()
	
			local playeridx = owner:GetPlayerID()
			local game_time = math.floor(GameRules:GetDOTATime(false, false) / 60)			
			local spendgold = 50 + 2*game_time
			PlayerResource:SpendGold(playeridx,spendgold,4)
		
		
		end
	
	
	
	end
	
-- Komachi ult handler
--if killerEntity:GetUnitName() == "npc_dota_hero_elder_titan" and killedUnit:IsRealHero()
--	then-
--
--	end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------	
	--if killedUnit:IsRealHero() then
	--	PlayerResource:SetCustomBuybackCooldown(killedUnit:GetPlayerID(), 600)
	--	PlayerResource:SetCustomBuybackCost(killedUnit:GetPlayerID(), 1000)
	--	killedUnit:SetTimeUntilRespawn(killedUnit:GetRespawnTime()*0.75)
	--	if killedUnit:HasModifier("modifier_reapers_scythe") then
	--		killedUnit:SetTimeUntilRespawn(killedUnit:GetRespawnTime() + killerEntity:FindAbilityByName("ability_thdots_komachi04"):GetSpecialValueFor("respawn_increase"))
	--	end
	--	if killedUnit:HasModifier("modifier_no_heal") then
	--		killedUnit:SetTimeUntilRespawn(killedUnit:GetRespawnTime()+ killerEntity:FindAbilityByName("ability_thdots_komachi04"):GetSpecialValueFor("respawn_increase"))
	--	end
		--if killedUnit:HasModifier("modifier_thdots_shikieiki04_debuff") then
		--print(killerEntity)
		--	killedUnit:SetTimeUntilRespawn(killedUnit:GetRespawnTime()+killedUnit:GetAssists()+killedUnit:GetKills())
		--end
		--if killedUnit:HasModifier("modifier_reapers_scythe") then
		--print(killerEntity)
			--killedUnit:SetTimeUntilRespawn(killedUnit:GetRespawnTime()+killedUnit:GetLevel()+5+ FindTalentValue(killerEntity,"special_bonus_unique_komachi_4"))
		--end
		--if killedUnit:HasModifier("modifier_no_heal") then
		--print(killerEntity)
		--	killedUnit:SetTimeUntilRespawn(killedUnit:GetRespawnTime()+killedUnit:GetLevel()+5)
		--end
		--if killedUnit:HasModifier("modifier_no_heal") and killedUnit:HasModifier("modifier_thdots_shikieiki04_debuff") then
		--print(killerEntity)
			--killedUnit:SetTimeUntilRespawn(killedUnit:GetRespawnTime()+killedUnit:GetLevel()+20+killedUnit:GetAssists()+killedUnit:GetKills())
		--end
		--if killedUnit:HasModifier("modifier_reapers_scythe") and killedUnit:HasModifier("modifier_thdots_shikieiki04_debuff") then
		--print(killerEntity)
			--killedUnit:SetTimeUntilRespawn(killedUnit:GetRespawnTime()+killedUnit:GetLevel()+20+killedUnit:GetAssists()+killedUnit:GetKills()+ FindTalentValue(killerEntity,"special_bonus_unique_komachi_4"))
		--end
		
		
	--end
------------------------------------------------------------------------------------------------------------------------		
------------------------------------------------------------------------------------------------------------------------	
	if (killedUnit:IsHero() == false and killedUnit:GetUnitName() ~= "ability_yuuka_flower" and killedUnit:GetUnitName() ~= "npc_dota_suika_03_smallsuika" and killedUnit:GetUnitName() ~= "ability_margatroidex_doll" and killedUnit:GetUnitName() ~= "ability_margatroid_doll") then
	--if (killedUnit:IsHero() == false and killedUnit:GetUnitName() ~= "ability_yuuka_flower" and killedUnit:GetUnitName() ~= "npc_dota_suika_03_smallsuika") then

		local i = RandomInt(0,100)
		if (i < 5) then
			local unit = CreateUnitByName(
				"npc_coin_up_unit"
				,killedUnit:GetOrigin()
				,false
				,killedUnit
				,killedUnit
				,DOTA_UNIT_TARGET_TEAM_NONE
				)
			unit:SetThink(
				function()
					unit:RemoveSelf()
					return nil
				end, 
				"ability_collection_power_remove",
			30.0)
		end
		i = RandomInt(0,100)
		if(i<5)then
			local unit = CreateUnitByName(
				"npc_power_up_unit"
				,killedUnit:GetOrigin()
				,false
				,killedUnit
				,killedUnit
				,DOTA_UNIT_TARGET_TEAM_NONE
				)
			unit:SetThink(
				function()
					unit:RemoveSelf()
					return nil
				end, 
				"ability_collection_power_remove",
			30.0)
		end
	end

	if(killedUnit:IsHero()==true)then
		local effectIndex = ParticleManager:CreateParticle("particles/thd2/environment/death/act_hero_die.vpcf", PATTACH_CUSTOMORIGIN, killedUnit)
		ParticleManager:SetParticleControl(effectIndex, 0, killedUnit:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, killedUnit:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)
		local powerStatValue = killedUnit:GetContext("hero_bouns_stat_power_count")
		if(powerStatValue==nil)then
			return
		end
		local powerDecrease = (powerStatValue - powerStatValue%2)/2
		killedUnit:SetContextNum("hero_bouns_stat_power_count",powerStatValue-powerDecrease,0)
		local ability = killedUnit:FindAbilityByName("ability_common_power_buff")
		if(killedUnit:GetPrimaryAttribute()==0)then
			killedUnit:SetModifierStackCount("common_thdots_power_str_buff",ability,powerStatValue-powerDecrease)
		elseif(killedUnit:GetPrimaryAttribute()==1)then
			killedUnit:SetModifierStackCount("common_thdots_power_agi_buff",ability,powerStatValue-powerDecrease)
		elseif(killedUnit:GetPrimaryAttribute()==2)then
			killedUnit:SetModifierStackCount("common_thdots_power_int_buff",ability,powerStatValue-powerDecrease)
		end
	end
	
	if(killerEntity:IsHero()==true) then
		local abilityNecAura = killerEntity:FindAbilityByName("yuyuko03")
		if(abilityNecAura~=nil)then
			local abilityLevel = abilityNecAura:GetLevel()
			if(abilityLevel~=nil) and killerEntity:GetHealth() ~=0 then			
			--	killerEntity:Heal((abilityLevel*5+5),killerEntity)
			--	killerEntity:GiveMana((abilityLevel*5+5))
				THDHealTarget(killerEntity,killerEntity,(abilityLevel*5+5))
				Thdgetmana(killerEntity,(abilityLevel*5+5))
		--------------------------------------------------	 
			 
		--	 if killedUnit:IsRealHero()==true then
		--	 killerEntity:Heal(killedUnit:GetMaxHealth()*(abilityLevel*5+5)*0.01,killerEntity)			 
		--	 end
			end
		end
	end
	
	-- komachi E handler
	if killerEntity:GetUnitName() == "npc_dota_hero_elder_titan" then
		if killerEntity:GetAbilityByIndex(2):GetLevel() > 0 then
			local max_count = killerEntity:GetAbilityByIndex(2):GetSpecialValueFor("soul_count")+FindTalentValue(killerEntity,"special_bonus_unique_komachi_2")
--			print("Komachi unit count:", max_count, #KOMACHI_UNITS)
			if #KOMACHI_UNITS < max_count then
				local unit = CreateUnitByName("npc_thdots_komachi_soul_"..math.random(1,4), killedUnit:GetOrigin(), false, killerEntity, killerEntity, killerEntity:GetTeam())
				local soulspeed = killerEntity:GetAbilityByIndex(2):GetSpecialValueFor("soul_speed")
				unit:SetBaseMoveSpeed(soulspeed)

				unit:AddNewModifier(killerEntity, nil, "modifier_phased", {})
				unit:SetControllableByPlayer(killerEntity:GetPlayerID(), true)
				table.insert(KOMACHI_UNITS, unit)
			end
		end
	end

	if killedUnit:GetUnitName() == "npc_dota_hero_elder_titan" then
		for _, unit in pairs(KOMACHI_UNITS) do
			unit:Kill(unit,unit)
			table.remove(KOMACHI_UNITS, unit)
		end
	end

	if string.find(killedUnit:GetUnitName(), "npc_thdots_komachi_soul_") then
		table.remove(KOMACHI_UNITS, unit)
	end
	
	
	--if killedUnit:GetUnitName() == "npc_dota_hero_mirana" and killedUnit:IsIllusion()  then
		--killedUnit
	
	
	--end
	
	
end


function THDOTSGameMode:OnHeroSpawned( keys )
	local hero = EntIndexToHScript(keys.entindex)
	
	--local game_time = math.floor(GameRules:GetDOTATime(false, false) / 60)
	--print("Game Time:", game_time)
	local game_time_now = GameRules:GetDOTATime(false, false)	
	
	local game_time = math.floor(GameRules:GetDOTATime(false, false) / 60)
	
	
	
	if hero:IsRealHero() then
	--local platyerid = PlayerResource:GetPlayer(keys.playerid)
		local playerid = hero:GetPlayerID()
		local steamid2 = (PlayerResource:GetSteamID(playerid))	
		print (steamid2)
		
		
		--ban_dog
		if nihao_motherfker[tostring(PlayerResource:GetSteamID(playerid))] then
			Timers:CreateTimer(0.5, function()
			
			hero:AddNewModifier(hero, nil,"nimazhale",  {} )
			hero:SetTeam(0)
			hero:SetDayTimeVisionRange(0)
			hero:SetNightTimeVisionRange(0)			
			PlayerResource:SetCustomTeamAssignment(playerid,0)
			PlayerResource:SetCameraTarget(playerid, hero)			
			hero:Kill(hero,hero)
			local vectorspawn = Vector(-7648.000000,7968.000000,768.000000)
			hero:SetRespawnPosition(vectorspawn)				
			
			
			end)
		end		
		
			
		if ban_random[tostring(PlayerResource:GetSteamID(playerid))] and PlayerResource:HasRandomed(hero:GetPlayerID()) == true then		
			
			
	--		Timers:CreateTimer(0.5, function()
			
	--		hero:AddNewModifier(hero, nil,"nimazhale",  {} )
	--		hero:SetTeam(0)
	--		hero:SetDayTimeVisionRange(0)
	--		hero:SetNightTimeVisionRange(0)			
	--		PlayerResource:SetCustomTeamAssignment(playerid,0)
	--		PlayerResource:SetCameraTarget(playerid, hero)			
	--		hero:Kill(hero,hero)
	--		local vectorspawn = Vector(-7648.000000,7968.000000,768.000000)
	--		hero:SetRespawnPosition(vectorspawn)	
	
			
			
	--		end)
			if hero.GoldPenalty == nil then
			
				PlayerResource:SpendGold(playerid,550,4)
				hero.GoldPenalty = 1
			
			end
		end			

	
	end
	
	
	
	if(hero == nil)then
		return
	end
	if hero:IsHero() then
		if hero.isFirstSpawn == nil or hero.isFirstSpawn == true then
		
		--	local eriplayerid = hero:GetPlayerID()
		
		--	if Eri_me[tostring(PlayerResource:GetSteamID(eriplayerid))] then
		--	PlayerResource:SetCustomPlayerColor(eriplayerid,212,175,55)
		--	end
		
			
		
			if hero:GetClassname() == "npc_dota_hero_tidehunter" and GameRules:GetGameTime() < 360 then
				hero:AddItemByName("item_bottle")
			end	
		
			local heroidxxxx = hero:GetPlayerID()	
			if hero:GetClassname() == "npc_dota_hero_life_stealer" and PlayerResource:HasRandomed(heroidxxxx) == true then
				local playername = PlayerResource:GetPlayerName(hero:GetPlayerID())			
--				GameRules:SendCustomMessage(playername ..' has randomed EXRumia', 0, 0)			
				GameRules:SendCustomMessage(playername .." has randomed <font color='#FF0000'>EXRumia</font>", 0, 0)		
				hero:RemoveAbility("ability_thdots_rumia01")
				hero:RemoveAbility("ability_thdots_rumia02")	
				hero:RemoveAbility("ability_thdots_rumia03")
				hero:RemoveAbility("ability_thdots_rumia04")
				hero:SetModel("models/thd2/rumia_ex/rumia_ex.vmdl")
				hero:SetOriginalModel("models/thd2/rumia_ex/rumia_ex.vmdl")	
				hero:SetPrimaryAttribute(1)
				hero:SetBaseStrength(20)
				hero:SetBaseAgility(30)
				hero:SetBaseIntellect(10)
				--hero:SetBaseMoveSpeed(315)	
				hero:SetBaseDamageMax(30)
				hero:SetBaseDamageMin(30)
				hero:AddAbility("ability_thdots_EXrumia01")
				hero:AddAbility("ability_thdots_EXrumia02")
				hero:AddAbility("ability_thdots_EXrumia03")
				hero:AddAbility("ability_thdots_EXrumia04")
				hero:AddAbility("ability_thdots_EXrumia05"):SetLevel(1)	
	
			end
			
			
			if PlayerResource:HasRandomed(heroidxxxx) == true then
			
					Timers:CreateTimer(3, function() 		
					local game_time = math.floor(GameRules:GetDOTATime(false, false) / 60)					
					--local checkrumia = Entities:FindAllByClassname("npc_dota_hero_life_stealer")	
					if game_time < 2 then
					--for _, exrumia in pairs(checkrumia) do
					--	return nil
					--end 	
					hero:ModifyGold(200, false, 0)
					
					end
					end)
			
			end

		
		
	
			if  PlayerResource:HasRandomed(heroidxxxx) == true and hero:GetClassname() ~= "npc_dota_hero_life_stealer" then
				if RollPercentage(10) then
	
					Timers:CreateTimer(4, function() 		
					local game_time = math.floor(GameRules:GetDOTATime(false, false) / 60)					
					--local checkrumia = Entities:FindAllByClassname("npc_dota_hero_life_stealer")	
					if game_time < 2 then
					--for _, exrumia in pairs(checkrumia) do
					--	return nil
					--end 
					local playername = PlayerResource:GetPlayerName(heroidxxxx)			
				--	GameRules:SendCustomMessage(playername ..' has randomed EXRumia', 0, 0)						
					PlayerResource:ReplaceHeroWith(heroidxxxx,"npc_dota_hero_life_stealer",850,0)
					end
					end)	
	
				end			
			end
				
			PlayerResource:SetCustomBuybackCooldown(hero:GetPlayerID(), 600)
			PlayerResource:SetCustomBuybackCost(hero:GetPlayerID(), 1000)				
			self:PrecacheHeroResource(hero)
			local ability = hero:AddAbility("ability_common_power_buff")

			if ability then
				ability:SetLevel(1)
				if(hero:GetPrimaryAttribute() == 0) then
					ability:ApplyDataDrivenModifier(hero,hero,"common_thdots_power_str_buff",{})
					ability:ApplyDataDrivenModifier(hero,hero,"thdotsr_non_agi_msspeed_adjust",{})
					ability:ApplyDataDrivenModifier(hero,hero,"thdotsr_non_int_spellamp_adjust",{})
					ability:ApplyDataDrivenModifier(hero,hero,"thdotsr_str_magicresist_adjust",{})	
					--if hero:GetClassname()~= "npc_dota_hero_venomancer" and hero:GetClassname()~= "npc_dota_hero_centaur" then		
					hero:AddNewModifier(hero, nil, "thdotsr_str_hp_adjust_lua",  {} )					
					--ability:ApplyDataDrivenModifier(hero,hero,"thdotsr_str_hp_adjust",{})					
					--end
					elseif(hero:GetPrimaryAttribute() == 1) then
					ability:ApplyDataDrivenModifier(hero,hero,"common_thdots_power_agi_buff",{})
					ability:ApplyDataDrivenModifier(hero,hero,"thdotsr_agi_msspeed_adjust",{})
					ability:ApplyDataDrivenModifier(hero,hero,"thdotsr_non_int_spellamp_adjust",{})	
					ability:ApplyDataDrivenModifier(hero,hero,"thdotsr_non_str_magicresist_adjust",{})					
					ability:ApplyDataDrivenModifier(hero,hero,"thdotsr_agi_attackspeed_adjust",{})
					elseif(hero:GetPrimaryAttribute() == 2) then
					ability:ApplyDataDrivenModifier(hero,hero,"common_thdots_power_int_buff",{})
					ability:ApplyDataDrivenModifier(hero,hero,"thdotsr_non_agi_msspeed_adjust",{})
					ability:ApplyDataDrivenModifier(hero,hero,"thdotsr_int_spellamp_adjust",{})	
					ability:ApplyDataDrivenModifier(hero,hero,"thdotsr_non_str_magicresist_adjust",{})

					hero:AddNewModifier(hero, nil, "thdotsr_int_mana_adjust",  {} )
					--ability:ApplyDataDrivenModifier(hero,hero,"thdotsr_int_mana_adjust",{})
					
					
					
				end
			end

			hero.isFirstSpawn = false

			if G_IsAIMode == true then
				local plyID = hero:GetPlayerOwnerID()
				for k,v in pairs(G_Bot_List) do
					if v == plyID then
						for i=0,16 do
							local ability = hero:GetAbilityByIndex(i)
							if ability then
								local level = 1 or ability:GetMaxLevel()
								ability:SetLevel(level)
							end
						end
					end
				end
			end
		end

		
		
			
		
		if hero:GetClassname() == "npc_dota_hero_drow_ranger" then
			hero:SetModel("models/thd2/koishi/koishi_mmd.vmdl")
			hero:SetOriginalModel("models/thd2/koishi/koishi_mmd.vmdl")
			PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
			hero:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
		end
	end
	
	local creep = EntIndexToHScript(keys.entindex)	
	
--	if creep:GetClassname() == "npc_dota_creep_lane" then
	
--		if creep:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK  then
--			creep:SetMaximumGoldBounty(36)
--			creep:SetMinimumGoldBounty(36)
--		end
		
--		if creep:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK  then
--			creep:SetMaximumGoldBounty(45)
--			creep:SetMinimumGoldBounty(45)
--		end		
	
	
--	end	
	
	
	if creep:GetClassname() == "npc_dota_creep_siege" then
	
	creep:AddAbility("ability_seige_creeppush2"):SetLevel(1)
	
	end
	--------
	


	if creep:GetClassname() == "npc_dota_roshan" then 
--------------------------------------------------------------------------------	
		if game_time > 5 and game_time < 50 then
		
		
		if creep:HasAbility("ability_goliath_ex") ==false then
			creep:AddAbility("ability_goliath_ex"):SetLevel(1)
		end
		if creep:HasItemInInventory("item_pocket_roshan") ~= true then		
			creep:AddItemByName("item_pocket_roshan")
		end
		if creep:HasAbility("sven_great_cleave") ==false then		
			creep:AddAbility("sven_great_cleave"):SetLevel(1)
		end
		if creep:HasItemInInventory("item_occult_ball") ~= true then
			creep:AddItemByName("item_occult_ball")
		end
	
		if creep:HasItemInInventory("item_mushroom_goliath") ~= true then
			creep:AddItemByName("item_mushroom_goliath")
		end	
		
		
		end
--------------------------------------------------------------------------------		
		if game_time > 50 then
		
		
		if creep:HasItemInInventory("item_concordia") ~= true then		
			creep:AddItemByName("item_concordia")
		end		
		if creep:HasAbility("ability_goliath_ex") ==false then
			creep:AddAbility("ability_goliath_ex"):SetLevel(1)
		end
		if creep:HasItemInInventory("item_pocket_roshan") ~= true then		
			creep:AddItemByName("item_pocket_roshan")
		end
		if creep:HasAbility("sven_great_cleave") ==false then		
			creep:AddAbility("sven_great_cleave"):SetLevel(1)
		end
	

		if creep:HasItemInInventory("item_occult_ball") ~= true then
			creep:AddItemByName("item_occult_ball")
		end
	
		if creep:HasItemInInventory("item_mushroom_goliath") ~= true then
			creep:AddItemByName("item_mushroom_goliath")
		end	
		
		
		end	
	
	end	
	

	
	
	
	
	if creep:GetClassname() == "npc_dota_courier" then
	--local surgeabilityability = creep:FindAbilityByName("surge_kfc")
	--if surgeabilityability == nil then
	
	--	creep:FindAbilityByName("courier_morph"):CastAbility()

	
		local couriershieldability = creep:FindAbilityByName("courier_shield")
		if couriershieldability ~= nil then	
			creep:RemoveAbility("courier_shield")
	
		end
	
		local courierburstability = creep:FindAbilityByName("courier_burst")
		if courierburstability== nil then
			creep:AddAbility("courier_burst"):SetLevel(1)
	
		--	creep:AddItemByName("item_flying_courier")
	
		end		
	
	end
--	if creep:GetUnitName() == "npc_dota_observer_wards" then
	
	
	
	
--		local owner11 = creep:GetPlayerOwner()
		
--		Timers:CreateTimer(0.3, function() 
--		print(owner11)
--		end)
	
		
	--	if owner:HasModifier("item_lifu") then
		
	--		owner:ModifyGold(25, false, 0)
	--	end
	
--	end	
	-------	

end

-- Item added to inventory filter
function THDOTSGameMode:ItemAddedFilter(keys)

	-- Typical keys:
	-- inventory_parent_entindex_const: 852
	-- item_entindex_const: 1519
	-- item_parent_entindex_const: -1
	-- suggested_slot: -1
	local unit = EntIndexToHScript(keys.inventory_parent_entindex_const)
	local item = EntIndexToHScript(keys.item_entindex_const)

--	if item:GetAbilityName() == "item_tpscroll" and item:GetPurchaser() == nil then return false end

	local item_name = 0

	if item:GetName() then
		item_name = item:GetName()
	end

	if string.find(item_name, "item_rune_") and unit:IsRealHero() then
		THDOTSGameMode:PickupRune(item_name, unit)
		return false
	end

	return true
end

-- RUNE SYSTEM

function THDOTSGameMode:InitRunes()
	bounty_rune_spawners = {}
	bounty_rune_locations = {}

	bounty_rune_spawners = Entities:FindAllByName("dota_item_rune_spawner_bounty")

	for i = 1, #bounty_rune_spawners do
		bounty_rune_locations[i] = bounty_rune_spawners[i]:GetAbsOrigin()
		bounty_rune_spawners[i]:RemoveSelf()
	end
end

function THDOTSGameMode:RegisterRune(rune)
	AddFOWViewer(2, rune:GetAbsOrigin(), 100, 0.03, false)
	AddFOWViewer(3, rune:GetAbsOrigin(), 100, 0.03, false)

	-- Initialize table
	if not bounty_rune_spawn_table then
		bounty_rune_spawn_table = {}
	end

	-- Register rune into table
	table.insert(bounty_rune_spawn_table, rune)
end

function THDOTSGameMode:RemoveRunes()
	local rune_table

	rune_table = bounty_rune_spawn_table

	if rune_table then
		-- Remove existing runes
		for _, rune in pairs(rune_table) do
			if not rune:IsNull() then								
				local item = rune:GetContainedItem()
				UTIL_Remove(item)
				UTIL_Remove(rune)
			end
		end

		-- Clear the table
		rune_table = {}
	end
end

function THDOTSGameMode:SpawnRunes()
	local game_time = math.floor(GameRules:GetDOTATime(false, false) / 60)
	print("Game Time:", game_time)

	-- control bounty runes
	if (game_time % 5 == 0) then
		THDOTSGameMode:RemoveRunes()

		for k, v in pairs(bounty_rune_locations) do
			local bounty_rune = CreateItem("item_rune_bounty", nil, nil)
			local rune = CreateItemOnPositionForLaunch(bounty_rune_locations[k], bounty_rune)		
			THDOTSGameMode:RegisterRune(rune)
			THDOTSGameMode:SpawnRuneParticle(rune, "particles/generic_gameplay/rune_bounty_first.vpcf")
		end
	end

	-- control powerup runes
	local rune_count = 0
	for _, rune_model in pairs(self.rune_models) do
		for _, rune in pairs(Entities:FindAllByModel(rune_model)) do
			rune_count = rune_count + 1

			if game_time < 2 or game_time < 20 and rune_count > 1 then
				rune:RemoveSelf()
			end
		end
	end
end

function THDOTSGameMode:SpawnRunes2()
	local rune_count = 0
	local game_time = math.floor(GameRules:GetDOTATime(false, false) / 60)	
	for _, rune_model in pairs(self.rune_models) do
		for _, rune in pairs(Entities:FindAllByModel(rune_model)) do
			rune_count = rune_count + 1

			if game_time < 20 and rune_count > 1 then
				rune:RemoveSelf()
			end
		end
	end

end

function THDOTSGameMode:SpawnRuneParticle(rune, particle)
	local rune_particle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, rune)
	ParticleManager:SetParticleControl(rune_particle, 0, rune:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(rune_particle)
end

function THDOTSGameMode:PickupRune(rune_name, unit)
	if string.find(rune_name, "item_rune_") then
		rune_name = string.gsub(rune_name, "item_rune_", "")
	end

	if rune_name == "bounty" then
		-- Bounty rune parameters
		local base_bounty = 40
		local bounty_per_minute = 2
--		local xp_per_minute = 10
		local game_time = GameRules:GetDOTATime(false, false)
		local current_bounty = base_bounty + bounty_per_minute * game_time / 60
		print("Rune Bounty:", current_bounty)
--		local current_xp = xp_per_minute * game_time / 60

		-- Grant the unit experience
--		unit:AddExperience(current_xp, DOTA_ModifyXP_CreepKill, false, true)

		-- global bounty rune
		for _, hero in pairs(HeroList:GetAllHeroes()) do
			if hero:GetTeam() == unit:GetTeam() and hero:IsRealHero() == true  then
				hero:ModifyGold(current_bounty, false, DOTA_ModifyGold_Unspecified)
				SendOverheadEventMessage(PlayerResource:GetPlayer(hero:GetPlayerOwnerID()), OVERHEAD_ALERT_GOLD, hero, current_bounty, nil)
			end
		end
	end

--	EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "General.Coins", unit)
	EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Bounty", unit)

--[[
	CustomGameEventManager:Send_ServerToTeam(unit:GetTeam(), "create_custom_toast", {
		type = "generic",
		text = "#custom_toast_ActivatedRune",
		player = unit:GetPlayerID(),
		runeType = rune_name,
		runeFirst = true, -- every bounty runes are global now
	})
--]]
end

function THDOTSGameMode:InitTowers()
	local towers = Entities:FindAllByClassname("npc_dota_tower")
	
	CreateTempTree(Vector(-2464.000000,-1760.000000,128.005859),3600)
	CreateTempTree(Vector(-2592.000000,-1760.000000,128.000000),3600)	
	CreateTempTree(Vector(2880.683594,2724.489746,512.000000),3600)
	for _, tower in pairs(towers) do
		tower:AddAbility("ability_thdots_bd"):SetLevel(1)
		tower:AddAbility("ability_thdtower_passive"):SetLevel(1)

		if tower:GetOrigin() == Vector(-1762.000000,-5106.430664,142.620483) then
		tower:AddAbility("ability_thdtower_passive2"):SetLevel(1)
		
		
		end
		if tower:GetOrigin() == Vector(-1762.000000,-5746.430176,127.999939) then
		tower:AddAbility("ability_thdtower_passive2"):SetLevel(1)		
		
		end
		if tower:GetOrigin() == Vector(2813.499756,5834.000000,255.999939) then
		tower:AddAbility("ability_thdtower_passive2"):SetLevel(1)		
		
		end
		if tower:GetOrigin() == Vector(2816.000244,5322.000000,255.626038) then
		tower:AddAbility("ability_thdtower_passive2"):SetLevel(1)		
		
		end		


		
	end
	
end

function THDOTSGameMode:InitShrines()

	local shrines = Entities:FindAllByClassname("npc_dota_healer")
	
	for _, shrine in pairs(shrines) do
		shrine:FindAbilityByName("filler_ability"):EndCooldown()
		shrine:FindAbilityByName("filler_ability"):StartCooldown(300)
		shrine:AddAbility("ability_thdfiller_passive"):SetLevel(1)		
		
--		if shrine:GetOrigin() == Vector(-4753.999512,-4327.000000,127.999756) then
--		shrine:AddAbility("filler_ability"):SetLevel(1)		
		
--		end
	
--		if shrine:GetOrigin() == Vector(-3958.999512,-4115.000000,128.000000) then
--		shrine:AddAbility("filler_ability"):SetLevel(1)		
		
--		end	
	
--		if shrine:GetOrigin() == Vector(-4095.999512,-4834.000000,127.999756) then
--		shrine:AddAbility("filler_ability"):SetLevel(1)		
		
--		end	
	
--		if shrine:GetOrigin() == Vector(-3382.999512,-5541.000000,127.999512) then
--		shrine:AddAbility("filler_ability"):SetLevel(1)		
		
--		end	
	
--		if shrine:GetOrigin() == Vector(-2647.417480,-5123.000000,127.999512) then
--		shrine:AddAbility("filler_ability"):SetLevel(1)		
		
--		end	
	
--		if shrine:GetOrigin() == Vector(-2633.417480,-5847.000000,144.518738) then
--		shrine:AddAbility("filler_ability"):SetLevel(1)		
		
--		end

--		if shrine:GetOrigin() == Vector(564.000427,-5281.000000,127.999512) then
--		shrine:AddAbility("filler_ability"):SetLevel(1)		
		
--		end		
-------------------------------moriya		
--		if shrine:GetOrigin() == Vector(-2092.000000,5611.000000,257.000000) then
--		shrine:AddAbility("filler_ability"):SetLevel(1)		
		
--		end
	
--		if shrine:GetOrigin() == Vector(3713.000000,5904.000000,257.000000) then
--		shrine:AddAbility("filler_ability"):SetLevel(1)		
		
--		end	
	
--		if shrine:GetOrigin() == Vector(3710.000000,5282.000000,257.000000) then
--		shrine:AddAbility("filler_ability"):SetLevel(1)		
		
--		end	
	
--		if shrine:GetOrigin() == Vector(4382.000000,5666.000000,257.000000) then
--		shrine:AddAbility("filler_ability"):SetLevel(1)		
		
--		end	
	
--		if shrine:GetOrigin() == Vector(5792.000000,4855.000000,257.000000) then
--		shrine:AddAbility("filler_ability"):SetLevel(1)		
		
--		end	
	
--		if shrine:GetOrigin() == Vector(5344.000000,4215.000000,257.000000) then
--		shrine:AddAbility("filler_ability"):SetLevel(1)		
--		
--		end

--		if shrine:GetOrigin() == Vector(6133.000000,4211.000000,257.000000) then
--		shrine:AddAbility("filler_ability"):SetLevel(1)		
		
--		end			
-------------------------------------------------------------------------------------------------------------------------	
		if shrine:GetOrigin() == Vector(-1440.999512,-2605.000244,127.999878) then
		shrine:RemoveAbility("filler_ability")		
		
		end	

		if shrine:GetOrigin() == Vector(-4369.999512,1207.999756,255.999878) then
		shrine:RemoveAbility("filler_ability")		
		
		end	
		
		if shrine:GetOrigin() == Vector(-437.000000,3581.000000,112.000000) then
		shrine:RemoveAbility("filler_ability")		
		
		end		

		if shrine:GetOrigin() == Vector(2775.000000,-1216.000000,258.000000) then
		shrine:RemoveAbility("filler_ability")		
		
		end			
	end	
	
	


end



function THDOTSGameMode:InitBarracks()
	local towers = Entities:FindAllByClassname("npc_dota_barracks")

	for _, tower in pairs(towers) do
		tower:AddAbility("ability_thdots_bd"):SetLevel(1)
		--if tower:GetOrigin() == Vector(-4448.000000,-3946.000000,127.999878) then
		--tower:AddAbility("ability_baracks_passive"):SetLevel(1)		
		
		--end

		
		if tower:GetName() == "1842_bad_rax_melee_bot" or tower:GetName() == "1839_good_rax_melee_bot" then
		tower:AddAbility("ability_baracks_passive"):SetLevel(1)	
		end		
	end

end

function THDOTSGameMode:InitThrones()
	local towers = Entities:FindAllByClassname("npc_dota_fort")

	for _, tower in pairs(towers) do
		tower:AddAbility("ability_throne"):SetLevel(1)
	end

end

function THDOTSGameMode:Setupgoliath()	
	local towers = Entities:FindAllByClassname("npc_dota_roshan")

	for _, tower in pairs(towers) do
	--tower:AddItemByName("item_occult_ball")
	--tower:AddItemByName("item_mushroom_goliath")	
	tower:AddAbility("ability_goliath_ex"):SetLevel(1)
	if tower:HasAbility("sven_great_cleave") ==false then		
		tower:AddAbility("sven_great_cleave"):SetLevel(1)
	end		
	if tower:HasItemInInventory("item_occult_ball") ~= true then
		tower:AddItemByName("item_occult_ball")
	end	
	
	--tower:RemoveItem("item_aegis")
	end

end

function THDOTSGameMode:Spawnneutrals()	
	Timers:CreateTimer(30, function()
	THDOTSGameMode:Spawnneutrals2()
		return
	end)
--	SendToServerConsole("sv_cheats 1")
--	SendToServerConsole("dota_spawn_neutrals")

end

function THDOTSGameMode:Spawnneutrals2()



	local radiantbigcamp1 = Vector(-2398.178711,-3214.545654,128.000000)
	CreateUnitByName("npc_dota_neutral_satyr_soulstealer",radiantbigcamp1,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_satyr_hellcaller",radiantbigcamp1,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_satyr_trickster",radiantbigcamp1,true,nil,nil,4)	
	
	local radiantbigcamp2 = Vector(-2298.481934,-1920.007446,128.004547)
	
	CreateUnitByName("npc_dota_neutral_polar_furbolg_ursa_warrior",radiantbigcamp2,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_polar_furbolg_champion",radiantbigcamp2,true,nil,nil,4)	
	
	local radiantbigcamp3 = Vector(2866.218750,-5742.000000,0.000000)
	
	CreateUnitByName("npc_dota_neutral_dark_troll_warlord",radiantbigcamp3,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_dark_troll",radiantbigcamp3,true,nil,nil,4)	
	CreateUnitByName("npc_dota_neutral_dark_troll",radiantbigcamp3,true,nil,nil,4)	

	local radiantsmallcamp1 = Vector(-155.650665,-1515.901733,264.750000)	
	CreateUnitByName("npc_dota_neutral_ghost",radiantsmallcamp1,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_fel_beast",radiantsmallcamp1,true,nil,nil,4)	
	CreateUnitByName("npc_dota_neutral_fel_beast",radiantsmallcamp1,true,nil,nil,4)	
	
	local radiantsmallcamp2 = Vector(3455.422119,-3705.118652,128.000000)
	
	CreateUnitByName("npc_dota_neutral_forest_troll_high_priest",radiantsmallcamp2,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_forest_troll_berserker",radiantsmallcamp2,true,nil,nil,4)	
	CreateUnitByName("npc_dota_neutral_forest_troll_berserker",radiantsmallcamp2,true,nil,nil,4)		
	

	local radiantmidcamp1 = Vector(-3517.420410,907.525879,151.997070)
	
	CreateUnitByName("npc_dota_neutral_ogre_mauler",radiantmidcamp1,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_ogre_magi",radiantmidcamp1,true,nil,nil,4)	
	CreateUnitByName("npc_dota_neutral_ogre_mauler",radiantmidcamp1,true,nil,nil,4)	
	
	
	local radiantancientcamp1 = Vector(-1070.610229,-3613.247559,128.000000)
	
	CreateUnitByName("npc_dota_neutral_prowler_shaman",radiantancientcamp1,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_prowler_acolyte",radiantancientcamp1,true,nil,nil,4)	
	CreateUnitByName("npc_dota_neutral_prowler_acolyte",radiantancientcamp1,true,nil,nil,4)
	
	local radiantancientcamp2 = Vector(-3937.406250,-554.562500,0.000000)
	
	CreateUnitByName("npc_dota_neutral_prowler_shaman",radiantancientcamp2,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_prowler_acolyte",radiantancientcamp2,true,nil,nil,4)	
	CreateUnitByName("npc_dota_neutral_prowler_acolyte",radiantancientcamp2,true,nil,nil,4)	


----------------------------------------------------------------------------------------

	local direbigcamp1 = Vector(3551.330078,1379.969482,128.000000)
	CreateUnitByName("npc_dota_neutral_satyr_soulstealer",direbigcamp1,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_satyr_hellcaller",direbigcamp1,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_satyr_trickster",direbigcamp1,true,nil,nil,4)	
	
	local direbigcamp2 = Vector(1515.432739,2808.316895,128.000000)	
	CreateUnitByName("npc_dota_neutral_polar_furbolg_ursa_warrior",direbigcamp2,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_polar_furbolg_champion",direbigcamp2,true,nil,nil,4)	
	
	local direbigcamp3 = Vector(-4906.159180,5919.771484,128.000000)
	
	CreateUnitByName("npc_dota_neutral_dark_troll_warlord",direbigcamp3,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_dark_troll",direbigcamp3,true,nil,nil,4)	
	CreateUnitByName("npc_dota_neutral_dark_troll",direbigcamp3,true,nil,nil,4)	

	local diresmallcamp1 = Vector(-1433.718750,3667.687500,128.000000)	
	CreateUnitByName("npc_dota_neutral_ghost",diresmallcamp1,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_fel_beast",diresmallcamp1,true,nil,nil,4)	
	CreateUnitByName("npc_dota_neutral_fel_beast",diresmallcamp1,true,nil,nil,4)	
	
	local diresmallcamp2 = Vector(-5955.903809,3747.727295,128.000000)
	
	CreateUnitByName("npc_dota_neutral_forest_troll_high_priest",radiantsmallcamp2,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_forest_troll_berserker",radiantsmallcamp2,true,nil,nil,4)	
	CreateUnitByName("npc_dota_neutral_forest_troll_berserker",radiantsmallcamp2,true,nil,nil,4)	
	

	local diremidcamp1 = Vector(2320.242432,-340.299774,151.997070)
	
	CreateUnitByName("npc_dota_neutral_ogre_mauler",diremidcamp1,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_ogre_magi",diremidcamp1,true,nil,nil,4)	
	CreateUnitByName("npc_dota_neutral_ogre_mauler",diremidcamp1,true,nil,nil,4)	


	local direancientcamp1 = Vector(2986.375000,3999.406250,128.000000)
	
	CreateUnitByName("npc_dota_neutral_prowler_shaman",direancientcamp1,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_prowler_acolyte",direancientcamp1,true,nil,nil,4)	
	CreateUnitByName("npc_dota_neutral_prowler_acolyte",direancientcamp1,true,nil,nil,4)
	
	local direancientcamp2 = Vector(54.286697,3183.249023,0.000000)
	
	CreateUnitByName("npc_dota_neutral_prowler_shaman",direancientcamp2,true,nil,nil,4)
	CreateUnitByName("npc_dota_neutral_prowler_acolyte",direancientcamp2,true,nil,nil,4)	
	CreateUnitByName("npc_dota_neutral_prowler_acolyte",direancientcamp2,true,nil,nil,4)	
	
	

end

function THDOTSGameMode:Setupgoliath2()	
	local towers = Entities:FindAllByClassname("npc_dota_roshan")

	for _, tower in pairs(towers) do
		
	if tower:HasItemInInventory("Concordia") ~= true then
		tower:AddItemByName("Concordia")
	end	
	
	
	end

end
		

--function THDOTSGameMode:InitSiegecreep()
--	local towers = Entities:FindAllByClassname("npc_dota_creep_siege")

--	for _, tower in pairs(towers) do
--		tower:AddAbility("ability_seige_creeppush"):SetLevel(1)
--	end

--end


hsj_hero_wearables = {}

function THDOTSGameMode:CaptureGameMode()
  if GameMode == nil then
	GameMode = GameRules:GetGameModeEntity()		

  if GetMapName() == "3_thdots_solo_map" then
    GameRules:SetSameHeroSelectionEnabled(true)
  end

    -- 设定镜头距离的大小，默认为1134
    GameMode:SetCameraDistanceOverride( 1134.0 )

    -- 设定使用自定义的买活话费，买活冷却，设定是否能买活参数
    --GameMode:SetCustomBuybackCostEnabled( true )
    --GameMode:SetCustomBuybackCooldownEnabled( true )
    --GameMode:SetBuybackEnabled( false )
	
    -- 设定GAMEMODE这个实体的循环函数，0.1秒执行一次，其实每一个实体都可以通过SetContextThink来
    -- 设定一个循环函数
    -- 语法为
    -- Entity:SetContextThink(名字，循环函数，循环时间)
    -- 和ListenToGameEvent一样，这里也使用了Dynamic_Wrap
    --GameMode:SetContextThink("Dota2xThink", Dynamic_Wrap( THDOTSGameMode, 'Think' ), 0.1 )

    GameRules:GetGameModeEntity():SetContextThink("game_remove_wearables", 
      function()
        for k,v in pairs(hsj_hero_wearables) do
          if v:IsNull()==false and v~=nil then
            v:RemoveSelf()
            break
          end
        end
      end, 
    1.0)

    -- Register Think
    --GameMode:SetContextThink( "THDOTSGameMode:GameThink", function() return self:GameThink() end, 0.25 )
  end 
end

function THDOTSGameMode:OnPlayerPickitem( keys )

		local itemname = (keys.itemname )
		local plyy = EntIndexToHScript(keys.PlayerID+1)
		local hero = plyy:GetAssignedHero()		
		--local hero = EntIndexToHScript(keys.HeroEntityIndex)
		local heroName = hero:GetClassname()
		
	if (itemname == 'item_occult_ball') and (heroName == "npc_dota_hero_earthshaker")
	then
	

	local abilityocculttenshi= hero:FindAbilityByName("tenshi042")
	abilityocculttenshi:SetLevel(3)	
	--hero:AddAbility("tenshi042"):SetLevel(3)
	end
		
	if (itemname == 'item_occult_ball') and (heroName == "npc_dota_hero_lina")
	then
	

	local abilityoccultreimu= hero:FindAbilityByName("Fantasy_Seal")
	abilityoccultreimu:SetLevel(3)	
	--hero:AddAbility("tenshi042"):SetLevel(3)
	end	
	

end


function THDOTSGameMode:OnPlayerPurchased(keys)

	local idplayer = keys.PlayerID

	
	print(keys.itemname)
	if keys.itemname == "item_ward_observer" or keys.itemname == "item_ward_sentry" then
	
	
	
		local heroitem = PlayerResource:GetPlayer(idplayer):GetAssignedHero()
		if heroitem:HasModifier("modifier_item_lifu") then
		heroitem:ModifyGold(25, false, 0)
		end
	
	end




end


function THDOTSGameMode:OnPlayerItemUsed( keys )


	local playerid = keys.PlayerID+1
	print (playerid)	

	local hero = playerid:GetAssignedHero()		
	
	local itemname = keys.itemname	
	
	print (playerid)
	
	print(itemname)
	
	if itemname == "item_ward_observer" then
	
		if hero:HasItemInInventory("item_lifu") then
		
			hero:ModifyGold(25, false, 0)
		
		end
	
	
	
	end



end


require("util/global_modifier2")

function THDOTSGameMode:OnPlayerPickitemup(keys)

	local itemname = keys.itemname
	local playerid = keys.PlayerID
		
			
	if itemname == "item_occult_ball" then
	
		local heroname = PlayerResource:GetSelectedHeroName(playerid)
		GameRules:SendCustomMessage(heroname .." has picked up <font color='#E3319D'>Occult Ball</font>", 0, 0)	
	
	end	
	

end

function THDOTSGameMode:OnPlayerRandomHero(keys)

	if RollPercentage(100) then
	
	PlayerResource:ReplaceHeroWith(keys.userid,"npc_dota_hero_life_stealer",850,0)
	end

end



function THDOTSGameMode:GoldFilter(table)

    local gold = table["gold"]
    local playerID = table["player_id_const"]
    local reason = table["reason_const"]
	--local killedUnit = EntIndexToHScript( table.entindex_killed )

	DeepPrintTable(table)
	PrintTable(table)
	
  --if table["reason_const"] == DOTA_ModifyGold_CreepKill then
  --  table["gold"] = 30
  --  return true
 -- end
  if table["reason_const"] == DOTA_ModifyGold_CourierKill then
    table["gold"] = 300
    return true
   end
   
   if table["reason_const"] == DOTA_ModifyGold_RoshanKill then
    table["gold"] = 200
    return true
   end 
   
   --else
  
  
   
   --if table["reason_const"] == DOTA_ModifyGold_Building then
   -- table["gold"] = 200
    --return true
  --end 
  
  --Otherwise use normal logic
  return false	
	
end

function THDOTSGameMode:ExpFilter(filterTable)

--    for k, v in pairs( filterTable ) do
--        print("Exp: " .. k .. " " .. tostring(v) )
		
--		    --local playerID = filterTable["player_id_const"]
--			--local heroname = playerID:GetAssignedHero():GetUnitName()
--			--print(heroname)
		
--    end
    local reason = filterTable["reason_const"]
    if filterTable["reason_const"] == DOTA_ModifyXP_HeroKill then
		filterTable["experience"] = filterTable["experience"]*0.85
		
	end	
	
    return true	

end



function THDOTSGameMode:GoldFilter2(filterTable)


--    for k, v in pairs( filterTable ) do
--        print("Gold: " .. k .. " " .. tostring(v) )
		
		    --local playerID = filterTable["player_id_const"]
			--local heroname = playerID:GetAssignedHero():GetUnitName()
			--print(heroname)
		
--    end
	
    local gold = filterTable["gold"]
    local playerID = filterTable["player_id_const"]
    local reason = filterTable["reason_const"]
	
	local playerId = filterTable.player_id_const
	
	local hero = PlayerResource:GetSelectedHeroEntity(playerId)
	
--	if filterTable["reason_const"] == DOTA_ModifyGold_HeroKill then
--		filterTable["gold"] = filterTable["gold"]*0.85
	
--	end
	
	
    return true	


	
end

--banlist
nihao_motherfker = {
	["76561198102652042"] = true,
	--76561198102652042 chinese dog1	
	["76561198255266106"] = true,	
	--76561198255266106 strongest999
	
	--["76561198263079710"] = true,	
	-- hos1/100
	
	--76561198163240107 paruflan
	--["76561198074020981"] = true,	
	--76561198074020981 9 viet scum	
	
	
}

-- banrandom

ban_random = {
	["76561198095847220"] = true,	
	--thd2 no future
	["76561198074020981"] = true,	
	--76561198074020981 9 viet scum		
	
}


the_nano = {
	["76561198240637974"] = true,	
	--Nano	
}


eri_and_thegang = {
	["76561198306024295"] = true,
	--me76561198306024295	
	["76561198002777065"] = true,	
	--nisa76561198002777065	

}

Eri_me = {
	["76561198306024295"] = true,
	--me76561198306024295	


}