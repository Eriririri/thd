function CDOTA_PlayerResource:GetAllTeamPlayerIDs()
--  local player_id_table = {}

--  for i = 0, self:GetPlayerCount() -1 do
--      table.insert(player_id_table, i)
--  end

--  return player_id_table

	-- wait for chris to tell where range is defined
	return filter(partial(self.IsValidPlayerID, self), range(0, self:GetPlayerCount()))
end

function CDOTA_PlayerResource:GetConnectedTeamPlayerIDs()
	return filter(partial(self.IsBotOrPlayerConnected, self), self:GetAllTeamPlayerIDs())
end

function CDOTA_PlayerResource:GetPlayerIDsForTeam(team)
	return filter(function(id) return self:GetTeam(id) == team end, range(0, self:GetPlayerCount()))
end

function CDOTA_PlayerResource:GetConnectedTeamPlayerIDsForTeam(team)
	return filter(partial(self.IsBotOrPlayerConnected, self), self:GetPlayerIDsForTeam(team))
end

function CDOTA_PlayerResource:RandomHeroForPlayersWithoutHero()
	function HasNotSelectedHero(playerID)
		return not self:HasSelectedHero(playerID)
	end

	function ForceRandomHero(playerID)
		self:GetPlayer(playerID):MakeRandomHeroSelection()
	end

	local playerIDsWithoutHero = filter(HasNotSelectedHero, self:GetConnectedTeamPlayerIDs())
	foreach(ForceRandomHero, playerIDsWithoutHero)
end

function CDOTA_PlayerResource:IsBotOrPlayerConnected(id)
	local connectionState = self:GetConnectionState(id)
	return connectionState == 2 or connectionState == 1
end

function RestrictAndHideHero(hero)
	if not hero:HasModifier("modifier_command_restricted") then
		hero:AddNewModifier(hero, nil, "modifier_command_restricted", {})
		hero:AddNewModifier(hero, nil, "modifier_phased", {})
		hero:AddEffects(EF_NODRAW)
		hero:SetDayTimeVisionRange(0)
		hero:SetNightTimeVisionRange(0)

--		if hero:GetTeamNumber() == 2 then
--			PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), GoodCamera)
--		else
--			PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), BadCamera)
--		end

		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), hero)
	end
end