if AbilityKaguya == nil then
	AbilityKaguya = class({})
end

function OnKaguya01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	THDReduceCooldown(keys.ability,FindTalentValue(caster,"special_bonus_unique_furion"))
	--设置计数器，控制旋转角度
	keys.ability:SetContextNum("ability_kaguya01_spell_count", 0, 0)
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
end

function OnKaguya01SpellThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local forwardVector = caster:GetForwardVector()
	local count = keys.ability:GetContext("ability_kaguya01_spell_count")
	local rollRad = count*math.pi*2/7
	local forwardCos = forwardVector.x
	local forwardSin = forwardVector.y
	local damageVector =  Vector(math.cos(rollRad)*forwardCos - math.sin(rollRad)*forwardSin,
								 forwardSin*math.cos(rollRad) + forwardCos*math.sin(rollRad),
								 0) * 350 + vecCaster
	local effectIndex
	if(count%3==0)then
		effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/kaguya/ability_kaguya01_light.vpcf", PATTACH_CUSTOMORIGIN, nil)
	elseif(count%3==1)then
		effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/kaguya/ability_kaguya01_light_green.vpcf", PATTACH_CUSTOMORIGIN, nil)
	elseif(count%3==2)then
		effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/kaguya/ability_kaguya01_light_red.vpcf", PATTACH_CUSTOMORIGIN, nil)
	end		
	count = count + 1
	keys.ability:SetContextNum("ability_kaguya01_spell_count", count, 0)
	
	ParticleManager:SetParticleControl(effectIndex, 0, damageVector)
	ParticleManager:SetParticleControl(effectIndex, 1, damageVector)
	ParticleManager:DestroyParticleSystem(effectIndex,false)
	caster:StartGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
	

	local targets = FindUnitsInRadius(
				   caster:GetTeam(),						--caster team
				   damageVector,							--find position
				   nil,										--find entity
				   keys.DamageRadius,						--find radius
				   DOTA_UNIT_TARGET_TEAM_ENEMY,
				   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				   0, FIND_CLOSEST,
				   false
			    )
	for _,v in pairs(targets) do
		local dealdamage = keys.ability:GetAbilityDamage() + FindTalentValue(caster,"special_bonus_unique_lina_2")+(caster:GetIntellect()*keys.intscale)	
		if v:IsNeutralUnitType() then
			dealdamage = dealdamage*keys.ampcreep
		end
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = dealdamage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)
	end
	

	local damage_table_caster = {
			ability = keys.ability,
			victim = caster,
			attacker = caster,
			damage = keys.HealthCost * caster:GetMaxHealth(),
			damage_type = keys.ability:GetAbilityDamageType(), 
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS
	}
	UnitDamageTarget(damage_table_caster)
	
	
end

function OnKaguyaSwapAbility(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if(keys.ability:GetContext("ability_kaguya02_swap_ability")==nil)then
		keys.ability:SetContextNum("ability_kaguya02_swap_ability",0,0)
	end
	local abilityNumber = keys.ability:GetContext("ability_kaguya02_swap_ability")
	if(abilityNumber==0)then
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_thdots_kaguya02_Brilliant_Dragon_Bullet", nil)
		caster:RemoveModifierByName("modifier_thdots_kaguya02_Life_Spring_Infinity") 
		keys.ability:SetContextNum("ability_kaguya02_swap_ability",1,0)
	elseif(abilityNumber==1)then
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_thdots_kaguya02_Buddhist_Diamond", nil)
		caster:RemoveModifierByName("modifier_thdots_kaguya02_Brilliant_Dragon_Bullet") 
		keys.ability:SetContextNum("ability_kaguya02_swap_ability",2,0)
	elseif(abilityNumber==2)then
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_thdots_kaguya02_Salamander_Shield", nil)
		caster:RemoveModifierByName("modifier_thdots_kaguya02_Buddhist_Diamond") 
		keys.ability:SetContextNum("ability_kaguya02_swap_ability",3,0)
	elseif(abilityNumber==3)then
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_thdots_kaguya02_Life_Spring_Infinity", nil)
		caster:RemoveModifierByName("modifier_thdots_kaguya02_Salamander_Shield") 
		keys.ability:SetContextNum("ability_kaguya02_swap_ability",0,0)
	end
end

function OnKaguya02SpellDamage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = keys.target_entities
	for _,v in pairs(targets) do
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = keys.AbilityDamage/5,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = DOTA_DAMAGE_FLAG_HPLOSS
		}
		--UnitDamageTarget(damage_table)
		ApplyDamage(damage_table)
	end
end

function OnKaguya03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local dummy = CreateUnitByName(
		"npc_dummy_unit"
		,caster:GetOrigin()
		,false
		,caster
		,caster
		,caster:GetTeam()
	)
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_kaguya_1"))	
	local ability_dummy_unit = dummy:FindAbilityByName("ability_dummy_unit")
	ability_dummy_unit:SetLevel(1)
	
	dummy:AddAbility("night_stalker_darkness") 
	local darkness = dummy:FindAbilityByName("night_stalker_darkness")
	darkness:SetLevel(3)
	dummy:CastAbilityImmediately(darkness, caster:GetPlayerOwnerID())
	dummy:RemoveSelf()
end






function OnKaguya03ManaRegen(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if(GameRules:IsDaytime()==false)then
		local bonusMana = (keys.ManaRegen + keys.BonusRegen * GameRules:GetGameTime()/keys.increaseTime)/10
		caster:SetMana(caster:GetMana()+bonusMana)
	end
end

function OnKaguya04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	caster.ability_kaguya_04_point = keys.target_points[1]
	caster.effectIndex = ParticleManager:CreateParticle("particles/heroes/kaguya/ability_kaguya04_effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(caster.effectIndex, 0, keys.target_points[1])
	ParticleManager:SetParticleControl(caster.effectIndex, 1, keys.target_points[1])
	ParticleManager:SetParticleControl(caster.effectIndex, 3, keys.target_points[1])
	ParticleManager:DestroyParticleSystem(caster.effectIndex,false)
	caster:EmitSound("Hero_Phoenix.SuperNova.Cast")
end

function OnKaguya04Passive(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local lostHp = caster:GetMaxHealth() - caster:GetHealth()
	if(caster.ability_kaguya_04_mana_store==nil)then
		caster.ability_kaguya_04_mana_store = 0
	end
	if(lostHp>0)then
		if(lostHp <= keys.HpRegen)then
			if(caster:GetMana()>=lostHp*keys.CostMana)then
			--	caster:SetHealth(caster:GetHealth() + lostHp)
				THDHealTarget2(caster,caster,lostHp)
				caster:SetMana(caster:GetMana() - lostHp*keys.CostMana)
				caster.ability_kaguya_04_mana_store = caster.ability_kaguya_04_mana_store + lostHp*keys.CostMana
			end
		else
			if(caster:GetMana()>=keys.HpRegen*keys.CostMana)then
			--	caster:SetHealth(caster:GetHealth() + keys.HpRegen)
				THDHealTarget2(caster,caster,keys.HpRegen)				
				
				caster:SetMana(caster:GetMana() - keys.HpRegen*keys.CostMana)
				caster.ability_kaguya_04_mana_store = caster.ability_kaguya_04_mana_store + keys.HpRegen*keys.CostMana
			end
		end
	else
		if(caster.ability_kaguya_04_mana_store~=nil)then
			if(caster.ability_kaguya_04_mana_store>=0)then
				caster.ability_kaguya_04_mana_store = caster.ability_kaguya_04_mana_store - caster:GetMaxMana() * keys.Decrease_speed
				if(caster.ability_kaguya_04_mana_store<0)then
					caster.ability_kaguya_04_mana_store =0
				end
			end
		end
	end
end

function OnKaguya04Think(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if(caster.ability_kaguya_04_mana_store == nil)then
		caster.ability_kaguya_04_mana_store = 0
	end
	if(caster.ability_kaguya_04_radius==nil)then
		caster.ability_kaguya_04_radius = 100
	end
	if(caster.ability_kaguya_04_mana_store>=700)then
		caster.ability_kaguya_04_mana_store = 700
	end
	if(caster.ability_kaguya_04_radius<=300+caster.ability_kaguya_04_mana_store)then
		caster.ability_kaguya_04_radius = caster.ability_kaguya_04_radius + keys.IncreaseRadius
	else
		caster.ability_kaguya_04_radius = 100
		caster.ability_kaguya_04_mana_store =0
		if(caster.effectIndex~=nil)then
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/kaguya/ability_kaguya04_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, caster.ability_kaguya_04_point)
			ParticleManager:SetParticleControl(effectIndex, 3, caster.ability_kaguya_04_point)
			ParticleManager:DestroyParticleSystemTime(effectIndex,1.0)
			ParticleManager:DestroyParticleSystemTime(caster.effectIndex,0)
		end
		caster:StopSound("Hero_Phoenix.SuperNova.Cast")
		caster:EmitSound("Hero_Abaddon.AphoticShield.Destroy")
		caster:RemoveModifierByName("modifier_thdots_kaguya04_think")
	end
	local targets = FindUnitsInRadius(
				   caster:GetTeam(),						--caster team
				   caster.ability_kaguya_04_point,			--find position
				   nil,										--find entity
				   caster.ability_kaguya_04_radius,			--find radius
				   DOTA_UNIT_TARGET_TEAM_ENEMY,
				   keys.ability:GetAbilityTargetType(),
				   0, FIND_CLOSEST,
				   false
			    )
	for _,v in pairs(targets) do
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = keys.ability:GetAbilityDamage(),
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = keys.ability:GetAbilityTargetFlags()
		}
		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_thdots_kaguya04_frozen", nil)		
		UnitDamageTarget(damage_table)
		UtilStun:UnitStunTarget( caster,v,keys.StunDuration)
	end
	--caster:EmitSound("Hero_Phoenix.FireSpirits.Target")
	caster:EmitSound("Hero_Abaddon.DeathCoil.Target")
	
end

function Kaguya01animation(event)

	local caster = event.caster

	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
end

function Kaguya01animationend(event)

	local caster = event.caster

	caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
end

function OnKaguya03xSpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local dummy = CreateUnitByName(
		"npc_dummy_unit"
		,caster:GetOrigin()
		,false
		,caster
		,caster
		,caster:GetTeam()
	)
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_kaguya_1"))	
	local ability_dummy_unit = dummy:FindAbilityByName("ability_dummy_unit")
	ability_dummy_unit:SetLevel(1)
	
	dummy:AddAbility("night_stalker_darkness_datadriven") 
	local darkness = dummy:FindAbilityByName("night_stalker_darkness_datadriven")
	darkness:SetLevel(3)
	dummy:CastAbilityImmediately(darkness, caster:GetPlayerOwnerID())
	dummy:RemoveSelf()
end



function Darkness( keys )
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))

	-- Time variables
	local time_flow = 0.0020833333
	local time_elapsed = 0
	-- Calculating what time of the day will it be after Darkness ends
	local start_time_of_day = GameRules:GetTimeOfDay()
	local end_time_of_day = start_time_of_day + duration * time_flow

	if end_time_of_day >= 1 then end_time_of_day = end_time_of_day - 1 end

	-- Setting it to the middle of the night
	GameRules:SetTimeOfDay(0)

	-- Using a timer to keep the time as middle of the night and once Darkness is over, normal day resumes
	Timers:CreateTimer(1, function()
		if time_elapsed < duration then
			GameRules:SetTimeOfDay(0)
			time_elapsed = time_elapsed + 1
			return 1
		else
			GameRules:SetTimeOfDay(end_time_of_day)
			return nil
		end
	end)
end

--[[Author: Pizzalol
	Date: 11.01.2015.
	Saves the original vision of the target and then reduces it]]
function ReduceVision( keys )
	local target = keys.target
	local ability = keys.ability
	local blind_percentage = ability:GetLevelSpecialValueFor("blind_percentage", (ability:GetLevel() - 1)) / -100

	target.original_vision = target:GetBaseNightTimeVisionRange()

	target:SetNightTimeVisionRange(target.original_vision * (1 - blind_percentage))
end

--[[Author: Pizzalol
	Date: 11.01.2015.
	Reverts the vision back to what it was]]
function RevertVision( keys )
	local target = keys.target

	target:SetNightTimeVisionRange(target.original_vision)
end