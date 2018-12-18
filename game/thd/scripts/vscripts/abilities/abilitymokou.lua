if AbilityMokou == nil then
	AbilityMokou = class({})
end

function OnMokou01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	local Mokou01rad = GetRadBetweenTwoVec2D(caster:GetOrigin(),targetPoint)
	local Mokou01Distance = GetDistanceBetweenTwoVec2D(caster:GetOrigin(),targetPoint)
	keys.ability.ability_Mokou01_Rad = Mokou01rad
	keys.ability.ability_Mokou01_Distance = Mokou01Distance 
	
	
	AbilityMokou:Mokou01addstacks(keys)	
	
end

function OnMokou01SpellMove(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targets = keys.target_entities
	local selfdamage = keys.selfdamage
	local strmulti = keys.damagemulti
	
	
	local Mokou01enemydamage = 0
	local Mokou01selfdamage = 0
	
	Mokou01enemydamage = keys.ability:GetAbilityDamage()+(caster:GetStrength()*strmulti)	
	
	Mokou01selfdamage = selfdamage+(caster:GetStrength()*strmulti)
	
	if caster:HasModifier("modifier_thdots_Mokou_04") then
	
		Mokou01enemydamage = Mokou01enemydamage*1	
		Mokou01selfdamage = Mokou01selfdamage*1
	
	end

	if(keys.ability.ability_Mokou01_Distance<30)then
		for _,v in pairs(targets) do
			local damage_table = {
				ability = keys.ability,
				victim = v,
				attacker = caster,
				damage = Mokou01enemydamage,
				damage_type = keys.ability:GetAbilityDamageType(), 
				damage_flags = keys.ability:GetAbilityTargetFlags()
			}
			UnitDamageTarget(damage_table)
			if v:IsHero()==true then 
			caster:EmitSound("Mokou01_"..math.random(1,3))
			end			

		end	
		
		local damage_table = {
			ability = keys.ability,
			victim = caster,
			attacker = caster,
			--damage = keys.ability:GetAbilityDamage()*0.75+(caster:GetStrength()*1.6)*0.75+caster:GetMaxHealth()*0.25*0.75,
			damage = Mokou01selfdamage,
			damage_type = keys.ability:GetAbilityDamageType(), 
			--damage_flags = keys.ability:GetAbilityTargetFlags() + DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR
			damage_flags = keys.ability:GetAbilityTargetFlags()
			}
		UnitDamageTarget(damage_table)
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/mouko/ability_mokou_01_boom.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, caster:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 3, caster:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)
		
		SetTargetToTraversable(caster)
		vecCaster = caster:GetOrigin()

		caster:RemoveModifierByName("modifier_thdots_Mokou01_think_interval")
		keys.ability.ability_Mokou01_Distance = 120
		caster:EmitSound("Hero_Phoenix.SuperNova.Explode") 
	else
		local distance = keys.ability.ability_Mokou01_Distance
		distance = distance - keys.MoveSpeed/50
		keys.ability.ability_Mokou01_Distance = distance
	end
	local Mokou01rad = keys.ability.ability_Mokou01_Rad
	local vec = Vector(vecCaster.x+math.cos(Mokou01rad)*keys.MoveSpeed/50,vecCaster.y+math.sin(Mokou01rad)*keys.MoveSpeed/50,GetGroundPosition(vecCaster, nil).z)
	caster:SetOrigin(vec)
end


function OnMokou02SpellStartUnit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if(target.ability_Mokou02_speed_increase==nil)then
		target.ability_Mokou02_speed_increase = 0
	end
	local increaseSpeedCount = target.ability_Mokou02_speed_increase
	increaseSpeedCount = increaseSpeedCount + keys.IncreaseSpeed
	if(increaseSpeedCount>keys.IncreaseMaxSpeed)then
		target:RemoveModifierByName("modifier_mokou02_speed_up")
	else
		target.ability_Mokou02_speed_increase = increaseSpeedCount
		target:SetThink(
			function()
				target:RemoveModifierByName("modifier_flandre02_slow")
				local decreaseSpeedNow = target.ability_Mokou02_speed_increase - keys.IncreaseSpeed
				target.ability_Mokou02_speed_increase = decreaseSpeedNow	
			end, 
			DoUniqueString("ability_flandre02_speed_increase_duration"), 
			keys.Duration
		)	
	end
end

function OnMokou02DamageStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targets = keys.target_entities

	if(caster.ability_Mokou02_damage_bouns==nil)then
		caster.ability_Mokou02_damage_bouns = 0
	end

	local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/mouko/ability_mokou_02_boom.vpcf", PATTACH_CUSTOMORIGIN, caster)
	if(targets[1]~=nil)then
		ParticleManager:SetParticleControl(effectIndex, 0, targets[1]:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, Vector(300,0,0))
		ParticleManager:DestroyParticleSystem(effectIndex,false)
	end

	for _,v in pairs(targets) do
		local dealdamage = keys.BounsDamage + caster.ability_Mokou02_damage_bouns
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
end

function OnMokou04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local dealdamage = caster:GetHealth() * keys.CostHp
	local damage_table = {
				ability = keys.ability,
			    victim = caster,
			    attacker = caster,
			    damage = dealdamage,
			    damage_type = keys.ability:GetAbilityDamageType(),
	    	    damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY
	}
	if FindTalentValue(caster,"special_bonus_unique_chaos_knight") == 0 then
		UnitDamageTarget(damage_table)
	end
	
	local mokouAbility1 = caster:FindAbilityByName("ability_thdots_mokou01")
	local mokouCooldown1 = mokouAbility1:GetCooldownTimeRemaining()
	if  mokouCooldown1 >0 then
	--	mokouAbility1:EndCooldown()
	end
	
	local mokouAbility3 = caster:FindAbilityByName("ability_thdots_mokou03")
	
	local mokouCooldown3 = mokouAbility3:GetCooldownTimeRemaining()
	if  mokouCooldown3 >0 then
		mokouAbility3:EndCooldown()
	end
	
	if FindTalentValue(caster,"special_bonus_unique_chaos_knight") ~=0 then	
	caster:Heal(caster:GetMaxHealth()*0.4,caster)
	end
	if FindTalentValue(caster,"special_bonus_unique_mokou_1")~=0 then
		keys.ability:ApplyDataDrivenModifier( caster, caster, "modifier_thdots_Mokou_04_talent", {} )
	end

	--[[local unit = CreateUnitByName(
		"npc_dota2x_unit_mokou_04"
		,caster:GetOrigin() - caster:GetForwardVector() * 15 + Vector(0,0,170)
		,false
		,caster
		,caster
		,caster:GetTeam()
	)
	unit:SetForwardVector(caster:GetForwardVector())]]

	caster.ability_Mokou02_damage_bouns = keys.BounsDamage
	Timer.Wait 'ability_Mokou02_damage_bouns_timer' (20,
		function()
			caster.ability_Mokou02_damage_bouns = 0
		end
	)

	local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/mouko/ability_mokou_04_wing.vpcf", PATTACH_CUSTOMORIGIN, caster) 
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
		
		
--		Timers:CreateTimer(0.3, function()
	--ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
--
	--	end)

	
	
	Timer.Wait 'ability_mokou_04_wing_destory' (20,
			function()
				ParticleManager:DestroyParticle(effectIndex,true)				
			end
		)
		

	--[[Timer.Loop 'ability_Mokou04_wing_timer' (0.1, 200,
		function(i)
			unit:SetOrigin(caster:GetOrigin() - caster:GetForwardVector() * 15 + Vector(0,0,170))
			unit:SetForwardVector(caster:GetForwardVector())
			if(caster:IsAlive()==false)then
				unit:RemoveSelf()
				return nil
			end
		end
	)
	unit:SetContextThink('ability_Mokou04_wing_unit_timer',
		function()
			unit:RemoveSelf()
			return nil
		end, 
	20.5)]]

end

function MokouEX(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local Caster=keys.caster
	local level = keys.ability:GetLevel()
    local ability = Caster:FindAbilityByName("ability_thdots_mokou05")
		ability:SetLevel(level)
		
		
	
end


--[[
	Author: Ractidous
	Date: 29.01.2015.
	Deal damage to the egg.
]]
function OnAttackedEgg( event )
	local egg			= event.target
	local attacker		= event.attacker
	local caster = event.caster
	local maxAttacks	= event.max_hero_attacks +FindTalentValue(caster,"special_bonus_unique_phoenix_1")

	-- Only real heroes can deal damage to the egg.
	if not attacker:IsRealHero() then
		return
	end

	local numAttacked = egg.supernova_numAttacked or 0
	numAttacked = numAttacked + 1
	egg.supernova_numAttacked = numAttacked

	local health = 100 * ( maxAttacks - numAttacked ) / maxAttacks
	egg:SetHealth( health )

	if numAttacked >= maxAttacks then
		-- Now the egg has been killed.
		egg.supernova_lastAttacker = attacker
		event.caster:RemoveModifierByName( "modifier_supernova_sun_form_caster_datadriven" )
		egg:RemoveModifierByName( "modifier_supernova_sun_form_egg_datadriven" )
	end
end

--[[
	Author: Ractidous
	Date: 29.01.2015.
	Kill the bird if the egg has been killed; Refresh him and stun around enemies otherwise.
]]
function OnDestroyEgg( event )
	local egg		= event.target
	local hero		= event.caster
	local ability	= event.ability

	local isDead = egg:GetHealth() == 0

	if isDead then

		hero:Kill( ability, egg.supernova_lastAttacker )
		
	local abilityex2 = hero:FindAbilityByName("ability_thdots_mokou03")	
	local Mokouex2Cooldown =abilityex2:GetCooldownTimeRemaining()	
		
		if Mokouex2Cooldown ~= 0 then
		local respawnTimeFormula = hero:GetLevel() * 4	
		--hero:SetTimeUntilRespawn(respawnTimeFormula)	
		
		end
		
		

	else

		hero:SetHealth( hero:GetMaxHealth() )
		hero:SetMana( hero:GetMaxMana() )

		-- Strong despel
		local RemovePositiveBuffs = true
		local RemoveDebuffs = true
		local BuffsCreatedThisFrameOnly = false
		local RemoveStuns = true
		local RemoveExceptions = true
		hero:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions )

		-- Stun nearby enemies
		ability:ApplyDataDrivenModifier( hero, egg, "modifier_supernova_egg_explode_datadriven", {} )
		hero:RemoveModifierByName( "modifier_supernova_egg_explode_datadriven" )

	end

	-- Play sound effect
	local soundName = "Hero_Phoenix.SuperNova." .. ( isDead and "Death" or "Explode" )
	StartSoundEvent( soundName, hero )

	-- Create particle effect
	local pfxName = "particles/units/heroes/hero_phoenix/phoenix_supernova_" .. ( isDead and "death" or "reborn" ) .. ".vpcf"
	local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_ABSORIGIN, egg )
	ParticleManager:SetParticleControlEnt( pfx, 0, egg, PATTACH_POINT_FOLLOW, "follow_origin", egg:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( pfx, 1, egg, PATTACH_POINT_FOLLOW, "attach_hitloc", egg:GetAbsOrigin(), true )

	-- Remove the egg
	egg:ForceKill( false )
	egg:AddNoDraw()
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/mouko/ability_mokou_01_boom.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, hero:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, hero:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 3, hero:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end


--[[
	Author: Ractidous
	Date: 29.01.2015.
	Hide caster's model.
]]
function HideCaster( event )
	event.caster:AddNoDraw()
end

--[[
	Author: Ractidous
	Date: 29.01.2015.
	Show caster's model.
]]
function ShowCaster( event )
	event.caster:RemoveNoDraw()
	local caster = event.caster
	local mokouAbility1 = caster:FindAbilityByName("ability_thdots_mokou01")
	local mokouCooldown1 = mokouAbility1:GetCooldownTimeRemaining()
	if  mokouCooldown1 >0 
	 then
	 mokouAbility1:EndCooldown()
	end
	
end

function Reincarnation( event )
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local cooldown = ability:GetCooldown(ability:GetLevel() - 1)
	local casterHP = caster:GetHealth()
	local casterMana = caster:GetMana()
	local abilityManaCost = ability:GetManaCost( ability:GetLevel() - 1 )
	-- Change it to your game needs
	local respawnTimeFormula = caster:GetLevel() * 4
	
	if casterHP == 0  then
	
	if caster:HasModifier("modifier_thdots_Mokou_04") and ability:IsCooldownReady() and casterMana >= abilityManaCost and caster:IsRealHero() and caster:HasItemInInventory("item_aegis") ~= true then
		print("Reincarnate")
		-- Variables for Reincarnation
		caster:EmitSound("Mokou05_"..math.random(1,2))
		local mokouAbility1 = caster:FindAbilityByName("ability_thdots_mokou01")
		local mokouCooldown1 = mokouAbility1:GetCooldownTimeRemaining()
		if  mokouCooldown1 >0 
		then
		mokouAbility1:EndCooldown()
		end
		local reincarnate_time = ability:GetLevelSpecialValueFor( "reincarnate_time", ability:GetLevel() - 1 )
		local slow_radius = ability:GetLevelSpecialValueFor( "slow_radius", ability:GetLevel() - 1 )
		local casterGold = caster:GetGold()
		local respawnPosition = caster:GetAbsOrigin()
		local GameMode = GameRules:GetGameModeEntity()	




	--	local mokouAbility4 = caster:FindAbilityByName("ability_thdots_mokou04")
	--	local cooldown2 = mokouAbility4:GetCooldownTimeRemaining() 
		if caster:HasModifier("modifier_thdots_Mokou_04") then	
		local mokou4duration = caster:FindModifierByName("modifier_thdots_Mokou_04"):GetRemainingTime()
		ability:StartCooldown(mokou4duration)
		else
		ability:StartCooldown(20)
		end		
		
		-- Start cooldown on the passive
	--	ability:StartCooldown(cooldown)

		-- Kill, counts as death for the player but doesn't count the kill for the killer unit
		caster:SetHealth(1)
		GameMode:SetLoseGoldOnDeath(false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_reincarnation_sethp",nil)		
		caster:Kill(caster, caster)
		GameMode:SetLoseGoldOnDeath(true)
		--Timers:CreateTimer(0.01, function() 
		--GameMode:SetLoseGoldOnDeath(true)
		--end)
		--caster:SetGold(caster,casterGold, false)		

		-- Set the short respawn time and respawn position
		caster:SetTimeUntilRespawn(reincarnate_time) 
		caster:SetRespawnPosition(respawnPosition)
		caster:SetBuyBackDisabledByReapersScythe(true)		

		-- Particle
		local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
		caster.ReincarnateParticle = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl(caster.ReincarnateParticle, 0, respawnPosition)
		ParticleManager:SetParticleControl(caster.ReincarnateParticle, 1, Vector(slow_radius,0,0))

		-- End Particle after reincarnating
		Timers:CreateTimer(reincarnate_time, function() 
			ParticleManager:DestroyParticle(caster.ReincarnateParticle, false)
			caster:SetBuybackEnabled(true)
		end)

		-- Grave and rock particles
		-- The parent "particles/units/heroes/hero_skeletonking/skeleton_king_death.vpcf" misses the grave model
		local model = "models/props_gameplay/tombstoneb01.vmdl"
		local grave = Entities:CreateByClassname("prop_dynamic")
    	grave:SetModel(model)
    	grave:SetAbsOrigin(respawnPosition)

    	local particleName = "particles/units/heroes/hero_skeletonking/skeleton_king_death_bits.vpcf"
		local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl(particle1, 0, respawnPosition)

		local particleName = "particles/units/heroes/hero_skeletonking/skeleton_king_death_dust.vpcf"
		local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl(particle2, 0, respawnPosition)

		local particleName = "particles/units/heroes/hero_skeletonking/skeleton_king_death_dust_reincarnate.vpcf"
		local particle3 = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl(particle3 , 0, respawnPosition)

    	-- End grave after reincarnating
    	Timers:CreateTimer(reincarnate_time, function() grave:RemoveSelf() end)		
    	--caster:SetGold(caster,caster:GetGold()+caster:GetGoldLostToDeath(),nil)
		-- Sounds
		caster:EmitSound("Hero_SkeletonKing.Reincarnate")
		caster:EmitSound("Hero_SkeletonKing.Death")
		Timers:CreateTimer(reincarnate_time, function()
			caster:EmitSound("Hero_SkeletonKing.Reincarnate.Stinger")
		end)
		-- Slow
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), respawnPosition, nil, slow_radius, 
									DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
									DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
		for _,unit in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_reincarnation_slow", nil)
		end	

	elseif casterHP == 0 and caster:HasItemInInventory("item_aegis") ~= true then
		-- On Death without reincarnation, set the respawn time to the respawn time formula
		caster:SetTimeUntilRespawn(respawnTimeFormula)
	end	

	end	

end
function OnMokou04SpellEnd(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local mokouAbility1 = caster:FindAbilityByName("ability_thdots_mokou01")
	local mokouCooldown1 = mokouAbility1:GetCooldownTimeRemaining()
	if  mokouCooldown1 >0 
	 then
	 mokouAbility1:EndCooldown()
	end
	local mokouAbility3 = caster:FindAbilityByName("ability_thdots_mokou03")
	local mokouCooldown3 = mokouAbility3:GetCooldownTimeRemaining()
	if  mokouCooldown3 >0 
	 then
	 mokouAbility3:EndCooldown()
	end
end

function Reincarnationsethp(event)

	local caster = event.caster



	caster:SetHealth(caster:GetMaxHealth()*event.reincarnatehp)

		
end


function AbilityMokou:Mokou01addstacks(keys)

  local caster = keys.caster

  local ability2 =	caster:FindAbilityByName("ability_thdots_mokou02x")	

	if   ability2 ~= nil then 
		
		local mokou_stack = caster:FindModifierByName("modifier_mokou02_speed_up")
		
    if mokou_stack==nil then 
    
	  ability2:ApplyDataDrivenModifier(caster, caster, "modifier_mokou02_speed_up",nil)
	  
	  caster:SetModifierStackCount("modifier_mokou02_speed_up", ability2,1)
	  
	else 	

	  caster:SetModifierStackCount("modifier_mokou02_speed_up", ability2,caster:GetModifierStackCount("modifier_mokou02_speed_up", caster)+1)	

	  local ability2_level = ability2:GetLevel() - 1
	  local checkmaxbuffs = ability2:GetLevelSpecialValueFor("max_buffs",ability2_level)
	  
	  if caster:GetModifierStackCount("modifier_mokou02_speed_up", caster) > checkmaxbuffs then
	  
	  caster:SetModifierStackCount("modifier_mokou02_speed_up", ability2,checkmaxbuffs)
	  
	  end

	  
	  local mokou02duration = mokou_stack:GetDuration()
	  mokou_stack:SetDuration(mokou02duration, true)
	  
	  
	end 
	end
end