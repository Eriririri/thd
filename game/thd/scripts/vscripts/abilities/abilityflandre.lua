if AbilityFlandre == nil then
	AbilityFlandre = class({})
end

function OnFlandreExDealDamage(keys)
	--PrintTable(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if(caster.flandrelock == nil)then
		caster.flandrelock = false
	end

	if(caster.flandrelock == true)then
		return
	end

	caster.flandrelock = true
	
	local damage_table = {
		ability = keys.ability,
		victim = keys.unit,
		attacker = caster,
		damage = keys.DealDamage * keys.IncreaseDamage,
		damage_type = keys.ability:GetAbilityDamageType(), 
		damage_flags = keys.ability:GetAbilityTargetFlags()
	}
	--caster:RemoveModifierByName("passive_flandreEx_damaged")
	UnitDamageTarget(damage_table)
	caster.flandrelock = false
	--keys.ability:ApplyDataDrivenModifier(caster, caster, "passive_flandreEx_damaged", nil)
end

function OnFlandre02SpellStartUnit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
   if not target:IsTower() then
	if(target:GetContext("ability_flandre02_Speed_Decrease")==nil)then
		target:SetContextNum("ability_flandre02_Speed_Decrease",0,0)
	end
	local decreaseSpeedCount = target:GetContext("ability_flandre02_Speed_Decrease")
	decreaseSpeedCount = decreaseSpeedCount + 1
	if(decreaseSpeedCount>(keys.DecreaseMaxSpeed+FindTalentValue(caster,"special_bonus_unique_huskar_3"))) then
		target:RemoveModifierByName("modifier_flandre02_slow")
	else
		target:SetContextNum("ability_flandre02_Speed_Decrease",decreaseSpeedCount,0)
		target:SetThink(
			function()
				target:RemoveModifierByName("modifier_flandre02_slow")
				local decreaseSpeedNow = target:GetContext("ability_flandre02_Speed_Decrease") - 1
				target:SetContextNum("ability_flandre02_Speed_Decrease",decreaseSpeedNow,0)	
			end, 
			DoUniqueString("ability_flandre02_Speed_Decrease_Duration"), 
			keys.Duration
		)	
	end
   end	
end


function OnFlandre04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	keys.ability:SetContextNum("ability_flandre04_multi_count",0,0)
	local count = 1 + FindTalentValue(caster,"special_bonus_unique_lina_1")
	local illusions = FindUnitsInRadius(
		   caster:GetTeam(),		
		   caster:GetOrigin(),		
		   nil,					
		   FIND_UNITS_EVERYWHERE,		
		   DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		   DOTA_UNIT_TARGET_ALL,
		   DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, 
		   FIND_CLOSEST,
		   false
	)
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_huskar_2"))

	for _,v in pairs(illusions) do
		if(v:IsIllusion() and v:GetModelName() == "models/thd2/flandre/flandre_mmd.vmdl")then
			count = count + 1
			v:MoveToPosition(caster:GetOrigin())
			v:SetThink(
				function()
					OnFlandre04illusionsRemove(v,caster)
					return 0.02
				end, 
				DoUniqueString("ability_collection_power"),
			0.02)
		end
	end

	local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_ambient.vpcf", PATTACH_CUSTOMORIGIN, caster) 
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_attack1", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystemTime(effectIndex,keys.Duration)

	keys.ability:SetContextNum("ability_flandre04_multi_count",count,0)
	keys.ability:SetContextNum("ability_flandre04_effectIndex",effectIndex,0)
end

function OnFlandre04SpellRemove(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local count = keys.ability:GetContext("ability_flandre04_multi_count")
	count = count - 1
	keys.ability:SetContextNum("ability_flandre04_multi_count",count,0)
	if(count<=0)then
		caster:RemoveModifierByName("modifier_thdots_flandre_04_multi")
	end
	
	
end

function OnFlandre04EffectRemove(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local effectIndex = keys.ability:GetContext("ability_flandre04_effectIndex")
	ParticleManager:DestroyParticle(effectIndex,true)
end

function OnFlandre04illusionsRemove(target,caster)
	local vecTarget = target:GetOrigin()
	local vecCaster = caster:GetOrigin()
	local speed = 30
	local radForward = GetRadBetweenTwoVec2D(vecTarget,vecCaster)
	local vecForward = Vector(math.cos(radForward) * speed,math.sin(radForward) * speed,1)
	vecTarget = vecTarget + vecForward
	
	target:SetForwardVector(vecForward)
	target:SetOrigin(vecTarget)
	if(GetDistanceBetweenTwoVec2D(vecTarget,vecCaster)<50)then
		local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/flandre/ability_flandre_04_effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, vecCaster)
		ParticleManager:DestroyParticleSystem(effectIndex,false)
		target:RemoveSelf()
	end
end

function OnFlandre03DealDamage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	lifesteal = keys.LifeStealz

	
	--local lifestealheal = (keys.DealDamage * keys.LifeStealz /100)
	
	if target:IsBuilding() == false then
	
	local particle3 = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle3, 0, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z))	
	
--	local digits = string.len( math.floor( lifestealheal ) ) + 1	
--	local particle4 = ParticleManager:CreateParticleForTeam("particles/msg_fx/msg_heal.vpcf", PATTACH_OVERHEAD_FOLLOW, caster, caster:GetTeamNumber())
--	ParticleManager:SetParticleControl( particle4, 1, Vector( 1, lifestealheal, 0 ) )
--   ParticleManager:SetParticleControl( particle4, 2, Vector( 2, digits, 0 ) )	
	
	if caster:HasModifier("active_flandre03_damaged") then
	
	lifesteal = lifesteal + keys.LifeStealActivez
	
	end
	
--	caster:Heal(lifestealheal,caster)
	
--	local msgheal = (caster:GetAverageTrueAttackDamage(caster) * keys.LifeStealz /100)
	
--	SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,caster,msgheal,nil)	

	THDLifestealTarget(caster,target,lifesteal,keys.DealDamage)
	
	end
	

end


function OnFlandre03SpellStartEffect(keys)
	local caster = keys.caster
	

	local effectIndex = ParticleManager:CreateParticle("particles/newthd/flandre/flandre03/flandre032.vpcf", PATTACH_CUSTOMORIGIN, caster) 
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_attack1", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystemTime(effectIndex,keys.Duration)
	
	local effectIndex2 = ParticleManager:CreateParticle("particles/newthd/flandre/flandre03/flandre032.vpcf", PATTACH_CUSTOMORIGIN, caster) 
	ParticleManager:SetParticleControlEnt(effectIndex2 , 0, caster, 5, "attach_attack1", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystemTime(effectIndex2,keys.Duration)	
	
end	

function OnFlandre03ActiveDealDamage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	

	
--	local lifestealheal = (keys.DealDamage * keys.LifeStealActivez /100)
	
	if target:IsBuilding() == false then
	
	
	local particle3 = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle3, 0, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z))		
	
	
--	caster:Heal(lifestealheal,caster) 	
--	SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,caster,lifestealheal*1.5,nil)	

	THDLifestealTarget(caster,target,keys.LifeStealActivez,keys.DealDamage)	
	
	end
	

end

function flandredebugillusion (keys)

	local caster = keys.caster
	
	local attackerx = keys.attacker
	
	local spendgold = (caster:GetLevel()*2)
	
	--local playerid = attackerx:GetPlayerID()
	
	if caster:IsRealHero() == false and attackerx:IsRealHero() == true then
	
	local owner = attackerx:GetPlayerOwner()
	
	local playerid = owner:GetPlayerID()
	PlayerResource:SpendGold(playerid,spendgold,4)
	--PlayerResource:SpendGold(playerid,spendgold,DOTA_ModifyGold_PurchaseItem)
	
	
	end

end