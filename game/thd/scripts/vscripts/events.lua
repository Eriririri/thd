function THDOTSGameMode:OnGameRulesStateChange(keys)
	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		if GetMapName() == "thdots_map_shuffle" then
			print("Shuffle teams!")
			SendToServerConsole("customgamesetup_shuffle_players")
		end
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
		THDOTSGameMode:InitRunes()
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		THDOTSGameMode:InitTowers()

		for i = 0, PlayerResource:GetPlayerCount() - 1 do
			if player ~= nil then
				PlayBGM(PlayerResource:GetPlayer(i))
			end
		end

		Timers:CreateTimer(0.1, function()
			THDOTSGameMode:SpawnRunes()
			return 120.0
		end)
	end
end

function THDOTSGameMode:OnEntityKilled( keys )
	-- 储存被击杀的单位
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	-- 储存杀手单位
	local killerEntity = EntIndexToHScript( keys.entindex_attacker )

	-- Komachi ult handler
	if killedUnit:IsRealHero() then
		if killedUnit:HasModifier("modifier_reapers_scythe") then
			killedUnit:SetTimeUntilRespawn(killedUnit:GetRespawnTime() + killerEntity:FindAbilityByName("ability_thdots_komachi04"):GetSpecialValueFor("respawn_increase") + killerEntity:FindTalentValue("special_bonus_unique_komachi_4"))
		end
	end

	if (killedUnit:IsHero() == false and killedUnit:GetUnitName() ~= "ability_yuuka_flower") then
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
	
	if(killerEntity:IsHero()==true)then
		local abilityNecAura = killerEntity:FindAbilityByName("necrolyte_heartstopper_aura")
		if(abilityNecAura~=nil)then
			local abilityLevel = abilityNecAura:GetLevel()
			if(abilityLevel~=nil)then
			 killerEntity:SetMana(killerEntity:GetMana()+(abilityLevel*5+5))
			end
		end
	end

	-- komachi E handler
	if killerEntity:GetUnitName() == "npc_dota_hero_elder_titan" then
		if killerEntity:GetAbilityByIndex(2):GetLevel() > 0 then
			local max_count = killerEntity:GetAbilityByIndex(2):GetSpecialValueFor("soul_count") + killerEntity:FindTalentValue("special_bonus_unique_komachi_2")
--			print("Komachi unit count:", max_count, #KOMACHI_UNITS)
			if #KOMACHI_UNITS < max_count then
				local unit = CreateUnitByName("npc_thdots_komachi_soul_"..killerEntity:GetAbilityByIndex(2):GetLevel(), killedUnit:GetOrigin(), false, killerEntity, killerEntity, killerEntity:GetTeam())
				unit:AddNewModifier(killerEntity, nil, "modifier_phased", {})
				unit:SetControllableByPlayer(killerEntity:GetPlayerID(), true)
				table.insert(KOMACHI_UNITS, unit)
			end
		end
	end

	if killedUnit:GetUnitName() == "npc_dota_hero_elder_titan" then
		for _, unit in pairs(KOMACHI_UNITS) do
			unit:Kill()
			table.remove(KOMACHI_UNITS, unit)
		end
	end

	if string.find(killedUnit:GetUnitName(), "npc_thdots_komachi_soul_") then
		table.remove(KOMACHI_UNITS, unit)
	end
end

function THDOTSGameMode:OnHeroSpawned( keys )
	local hero = EntIndexToHScript(keys.entindex)
	if(hero == nil)then
		return
	end

	if hero:IsHero() then
		if hero.isFirstSpawn == nil or hero.isFirstSpawn == true then
			self:PrecacheHeroResource(hero)
			local ability = hero:AddAbility("ability_common_power_buff")

			if ability then
				ability:SetLevel(1)
				if(hero:GetPrimaryAttribute() == 0) then
					ability:ApplyDataDrivenModifier(hero,hero,"common_thdots_power_str_buff",{})
				elseif(hero:GetPrimaryAttribute() == 1) then
					ability:ApplyDataDrivenModifier(hero,hero,"common_thdots_power_agi_buff",{})
				elseif(hero:GetPrimaryAttribute() == 2) then
					ability:ApplyDataDrivenModifier(hero,hero,"common_thdots_power_int_buff",{})
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
