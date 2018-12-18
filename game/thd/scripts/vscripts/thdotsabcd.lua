if THDOTSGameMode == nil then
	THDOTSGameMode = class({})
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
