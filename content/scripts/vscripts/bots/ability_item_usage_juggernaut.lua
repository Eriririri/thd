
----------------------------------------------------------------------------------------------------

cast01Desire = 0;
cast02Desire = 0;
cast03Desire = 0;
cast04Desire = 0;

function AbilityUsageThink()

	local npcBot = GetBot();

	-- Check if we're already using an ability
	if ( npcBot:IsUsingAbility() ) then return end;

	ability01 = npcBot:GetAbilityByName( "ability_thdots_youmu01" );
	ability03 = npcBot:GetAbilityByName( "ability_thdots_youmu03" );
	ability04 = npcBot:GetAbilityByName( "ability_thdots_youmu04" );

	-- Consider using each ability
	cast01Desire, cast01Location = ConsiderAbilityYoumu01();
	cast03Desire = ConsiderAbilityYoumu03();
	cast04Desire, cast03Target = ConsiderAbilityYoumu04();

	if ( cast01Desire > 0 ) 
	then
		npcBot:Action_UseAbilityOnLocation( ability01, cast01Location );
		return;
	end

	if ( cast03Desire > 0 ) 
	then
		npcBot:Action_UseAbility( ability03 );
		return;
	end

	if ( cast04Desire > 0 ) 
	then
		npcBot:Action_UseAbilityOnEntity( ability04 , cast04Target);
		return;
	end

end

----------------------------------------------------------------------------------------------------

function CanCastYoumu01OnTarget( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsInvulnerable();
end

function CanCastYoumu03OnTarget( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

function CanCastYoumu04OnTarget( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end
----------------------------------------------------------------------------------------------------

function ConsiderAbilityYoumu01()

	local npcBot = GetBot();

	-- Make sure it's castable
	if ( not ability01:IsFullyCastable() ) 
	then 
		return BOT_ACTION_DESIRE_NONE, 0;
	end;

	-- Get some of its values
	local nRadius = ability01:GetSpecialValueInt( "radius" );
	local nCastRange = ability01:GetCastRange();
	local nDamage = ability01:GetAbilityDamage();

	--------------------------------------
	-- Mode based usage
	--------------------------------------

	-- If we're farming and can kill 3+ creeps with LSA
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM ) then
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), nCastRange, nRadius, 0, nDamage );

		if ( locationAoE.count >= 3 ) then
			return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc;
		end
	end

	-- If we're pushing or defending a lane and can hit 4+ creeps, go for it
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOTTOM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOTTOM ) 
	then
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), nCastRange, nRadius, 0, 0 );

		if ( locationAoE.count >= 4 ) 
		then
			return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc;
		end
	end

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nCastRange + nRadius + 200, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCastYoumu01OnTarget( npcEnemy ) ) 
				then
					return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetLocation();
				end
			end
		end
	end

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_GANK or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY ) 
	then
		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil ) 
		then
			if ( CanCastYoumu01OnTarget( npcTarget ) )
			then
				return BOT_ACTION_DESIRE_HIGH, npcTarget:GetLocation();
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
end

----------------------------------------------------------------------------------------------------

function ConsiderAbilityYoumu03()

	local npcBot = GetBot();

	-- Make sure it's castable
	if ( not ability03:IsFullyCastable() ) 
	then 
		return BOT_ACTION_DESIRE_NONE;
	end;

	-- Get some of its values
	local nRadius = 400;
	local nCastRange = 0;
	local nDamage = ability03:GetAbilityDamage()*4;

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nCastRange + nRadius + 200, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCastYoumu03OnTarget( npcEnemy ) ) 
				then
					return BOT_ACTION_DESIRE_MODERATE;
				end
			end
		end
	end

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_GANK or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY ) 
	then
		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil ) 
		then
			if ( CanCastYoumu03OnTarget( npcTarget ) )
			then
				return BOT_ACTION_DESIRE_HIGH;
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;

end

----------------------------------------------------------------------------------------------------

function ConsiderAbilityYoumu04()

	local npcBot = GetBot();

	-- Make sure it's castable
	if ( not ability04:IsFullyCastable() ) 
	then 
		return BOT_ACTION_DESIRE_NONE,nil;
	end;

	-- Get some of its values
	local nCastRange = ability04:GetCastRange();

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nCastRange , true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCastYoumu04OnTarget( npcEnemy ) ) 
				then
					return BOT_ACTION_DESIRE_MODERATE,npcEnemy;
				end
			end
		end
	end

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_GANK or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY ) 
	then
		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil ) 
		then
			if ( CanCastYoumu04OnTarget( npcTarget ) )
			then
				return BOT_ACTION_DESIRE_HIGH,npcTarget;
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;

end

