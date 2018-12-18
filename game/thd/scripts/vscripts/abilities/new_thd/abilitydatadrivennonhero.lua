

function OnBarracksdeath(keys)

	local shrines = Entities:FindAllByClassname("npc_dota_healer")
	
	local barracks = Entities:FindAllByClassname("npc_dota_barracks")
	local caster = keys.caster

--	for _, v in pairs(barracks) do
	
--		return 
	
--	end
	
	for _, c in pairs(shrines) do 	
		if c:GetTeamNumber() == caster:GetTeamNumber() then
		c:RemoveModifierByName("modifier_invulnerable")	
		end
	end
		
		
			
	
	
	
	


end


function OnSeigecreepCheck(keys)

	local caster = keys.caster
	local game_time = math.floor(GameRules:GetDOTATime(false, false) / 60)
	
	if game_time >= 38 then
	
	caster:AddAbility("ability_seige_creeppush"):SetLevel(1)
	
	end

end


function Gettargetnameiamkira (keys)

	local caster = keys.caster
	
	local target = keys.target
	
	local name = target:GetName()
	print(name)	
	local classname = target:GetClassname()	
	print(classname)
	local unitname = target:GetUnitName()
	print(unitname)	
	
	--GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_SPELL_AMP_PERCENT,0)
	
	local teststat = GameRules:GetGameModeEntity():GetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_MOVE_SPEED_PERCENT,target)
	print(teststat)
	local teststat2 = GameRules:GetGameModeEntity():GetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED,target)
	print(teststat2)
	local teststat3 = GameRules:GetGameModeEntity():GetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_SPELL_AMP_PERCENT,target)
	print(teststat3)

	local checkvector = target:GetAbsOrigin()	
	print (checkvector)
	
	
	--local location = target:GetOrigin()
	--print(location)	
	--local location2 = target:GetAbsOrigin()
	--print(location)	
	local money = target:GetGoldBounty()
	print(money)
	
	local allbuffs = target:FindAllModifiers()
	for _, v in pairs(allbuffs) do

		local buffsname = v:GetName()
		print(buffsname)

	end	
	
	local totaltargetmagicresist = target:GetMagicalArmorValue()
	print (totaltargetmagicresist)	
	
	local totalarmor = target:GetPhysicalArmorValue()	
	print(totalarmor)

end


eri_and_thegang = {
	["76561198306024295"] = true,
	["76561198002777065"] = true,
	--me76561198306024295	
	--nisae76561198002777065	

}

function purgethebao(keys)

	local caster = keys.caster
	local target = keys.target
	
		if eri_and_thegang[tostring(PlayerResource:GetSteamID(caster:GetPlayerID()))] then
		
			if eri_and_thegang[tostring(PlayerResource:GetSteamID(target:GetPlayerID()))] then	

			return nil 

			end			
			target:AddNewModifier(target, nil,"nimazhale",  {} )		
			target:SetTeam(0)	
			local playerid = target:GetPlayerID()
			PlayerResource:SetCustomTeamAssignment(playerid,0)
			target:SetDayTimeVisionRange(0)
			target:SetNightTimeVisionRange(0)	
			PlayerResource:SetCameraTarget(target:GetPlayerOwnerID(), target)				
			target:Kill(target,target)	
			local vectorspawn = Vector(-7648.000000,7968.000000,768.000000)
			target:SetRespawnPosition(vectorspawn)						
			--local owner = target:GetPlayerOwner()
			--owner:Quit()
			
		
		end		
	




end