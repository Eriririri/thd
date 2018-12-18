




function Patchouliultimate1(keys)
	local caster = keys.caster
	
	caster:AddAbility("ability_thdotsr_patchouli_royal_flare"):SetLevel(1)
	caster:RemoveAbility("ability_thdotsr_patchouli_ultimate2")
	caster:RemoveAbility("ability_thdotsr_patchouli_ultimate1")	
--	caster:SetAbilityPoints(caster:GetAbilityPoints()+1)

end



function Patchouliultimate2(keys)
	local caster = keys.caster
	
	caster:AddAbility("ability_thdotsr_patchouli_silent_selene"):SetLevel(1)
	caster:RemoveAbility("ability_thdotsr_patchouli_ultimate2")
	caster:RemoveAbility("ability_thdotsr_patchouli_ultimate1")	
--	caster:SetAbilityPoints(caster:GetAbilityPoints()+1)	

end

function OnPatchouliRoyalFlareStart (keys)

	local caster = keys.caster
	
	local ability = keys.ability
	
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_patchouli_2"))	
	
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_patchouli_royal_flare",nil)	
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_patchouli_royal_flare_animation",nil)		
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/patchouli/ability_patchouli_01.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 3, caster:GetOrigin())
	
--	EmitGlobalSound("Patchouli_ultimate_start")	
--	caster:EmitSound("Patchouli_ultimate_start")	
	EmitGlobalSound("Patchouli_ultimate_start_"..math.random(1,5))
	caster:EmitSound("Patchouli_royal_flare_start")	
	
--	Timers:CreateTimer(keys.EffectDuration-1, function() 
--	ParticleManager:DestroyParticleSystem(effectIndex,false)
	ParticleManager:DestroyParticleSystemTime(effectIndex,keys.EffectDuration)	
--	end)	
	
	






end

function OnPatchouliRoyalFlareStartStun (keys)

	local caster = keys.caster
	
	local ability = keys.ability
--	local totaldamage = keys.startdamage + caster:GetIntellect()*keys.intscale
	
	local totaldamage = keys.startdamage	


	
	local targets = FindUnitsInRadius(
				   caster:GetTeam(),						--caster team
				   caster:GetOrigin(),							--find position
				   nil,										--find entity
				   keys.Radius,						--find radius
				   DOTA_UNIT_TARGET_TEAM_ENEMY,
				   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				   0, FIND_ANY_ORDER,
				   false
			    )
	for _,v in pairs(targets) do


		ability:ApplyDataDrivenModifier(caster, v, "modifier_patchouli_royal_flare_stun",nil)	
	
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, v, totaldamage, nil)
		local damage_table = {
			ability = keys.ability,
			victim = v,
			attacker = caster,
			damage = totaldamage,
			damage_type = DAMAGE_TYPE_MAGICAL, 
			damage_flags = 0
		}	
		UnitDamageTarget(damage_table)	



	end


end

function OnPatchouliRoyalFlareDamage (keys)

	local caster = keys.caster
	
	local ability = keys.ability
	local totaldamage = ((keys.Basedamage + caster:GetIntellect()*keys.intscale + FindTalentValue(caster,"special_bonus_unique_patchouli_1") ) * keys.intervals)/keys.totalduration

	
	local targets = FindUnitsInRadius(
				   caster:GetTeam(),						--caster team
				   caster:GetOrigin(),							--find position
				   nil,										--find entity
				   keys.Radius,						--find radius
				   DOTA_UNIT_TARGET_TEAM_ENEMY,
				   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				   0, FIND_ANY_ORDER,
				   false
			    )
	for _,v in pairs(targets) do


		ability:ApplyDataDrivenModifier(caster, v, "modifier_patchouli_royal_flare_stun",nil)	

		
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, v, totaldamage, nil)
		local damage_table = {
			ability = keys.ability,
			victim = v,
			attacker = caster,
			damage = totaldamage,
			damage_type = DAMAGE_TYPE_MAGICAL, 
			damage_flags = 0
		}	
		UnitDamageTarget(damage_table)	



	end






end


function OnPatchouliRoyalFlareAnimationStart(keys)

	local caster = keys.caster
	
	
	local ability = keys.ability
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
	local timerdelay = 0.36
	Timers:CreateTimer(timerdelay, function() 
	ability:ApplyDataDrivenModifier(caster,caster, "modifier_patchouli_royal_flare_pause_animation",{duration = keys.Durationx - timerdelay})		
	end)


end

function OnPatchouliRoyalFlareAnimation(keys)

	local caster = keys.caster
	
	local effectIndex = ParticleManager:CreateParticle("particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, Vector(keys.Radius,0,0))		
	
	caster:EmitSound("Patchouli_royal_flare_damage")		
--	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)



end

function OnPatchouliRoyalFlareAnimationEnd(keys)

	local caster = keys.caster
	
	
	
	caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2)



end

function OnPatchouliMoonReturnmana(keys)
	local caster = keys.caster
	
	local currentspell = caster:GetCurrentActiveAbility()
	local manacost = currentspell:GetManaCost(currentspell:GetLevel())
	
	Thdgetmana(caster,manacost*keys.Returnmana*0.01)

end

function OnPatchouliSilentSeleneStart(keys)

	local caster = keys.caster
	local ability = keys.ability
	local targetpoint = keys.target_points[1]
	
	EmitGlobalSound("Patchouli_ultimate_start_"..math.random(1,5))
	EmitGlobalSound("Patchouli_Silent_Selene_start")	
--	
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_patchouli_2"))	
	
	ability:ApplyDataDrivenThinker(caster, targetpoint, "modifier_patchouli_silent_selene", {})		


end

function OnPatchouliSilentSeleneTick (keys)

	local ability = keys.ability

	local caster = keys.caster
	local target = keys.target
	local totaldamage = ((keys.Basedamage + caster:GetIntellect()*keys.intscale + FindTalentValue(caster,"special_bonus_unique_patchouli_1")) * keys.intervals)/keys.totalduration
	local beam = ParticleManager:CreateParticle("particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_impact_moonfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(beam, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", caster:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt(beam, 1, target, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", target:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt(beam, 5, target, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", target:GetAbsOrigin(), true )
	target:EmitSound("Patchouli_Silent_Selene_Beam")		
	
	
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, totaldamage, nil)
		local damage_table = {
			ability = keys.ability,
			victim = target,
			attacker = caster,
			damage = totaldamage,
			damage_type = DAMAGE_TYPE_MAGICAL, 
			damage_flags = 0
		}	
		UnitDamageTarget(damage_table)		
	
end


function OnPatchouliWaterFireStart(keys)


	local ability = keys.ability

	local caster = keys.caster
	local target = keys.target
	target:EmitSound("Patchouli_water_fire_start")
	if is_spell_blocked(keys.target) then return end	
	
	
	ability:ApplyDataDrivenModifier(caster,target, "modifier_patchouli_water_fire_debuff",nil)	


end


function OnPatchouliWaterFireTick(keys)


	local ability = keys.ability

	local caster = keys.caster
	local target = keys.target
	
		local totaldamage = ((keys.Basedamage + caster:GetIntellect()*keys.intscale) * keys.intervals)/keys.totalduration
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, totaldamage, nil)
		local damage_table = {
			ability = keys.ability,
			victim = target,
			attacker = caster,
			damage = totaldamage,
			damage_type = DAMAGE_TYPE_MAGICAL, 
			damage_flags = 0
		}	
		UnitDamageTarget(damage_table)

end


function OnPatchouliWaterEarthStart(keys)
	keys.caster:EmitSound("Hero_Invoker.IceWall.Cast")
	local caster = keys.caster

	local caster_point = keys.caster:GetAbsOrigin()
	local direction_to_target_point = keys.caster:GetForwardVector()
	
	
	local targetpoint = keys.target_points[1]
	
	
--	local distance = CalcDistanceBetweenEntityOBB(caster_point,targetpoint)
	
--	target_point = caster_point + (direction_to_target_point * keys.WallPlaceDistance)
	
	
	target_point = targetpoint
	local direction_to_target_point_normal = Vector(-direction_to_target_point.y, direction_to_target_point.x, direction_to_target_point.z)
	local vector_distance_from_center = (direction_to_target_point_normal * (keys.NumWallElements * keys.WallElementSpacing)) / 2
	local one_end_point = target_point - vector_distance_from_center
	
	--Display the Ice Wall particles in a line.
--	local ice_wall_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall.vpcf", PATTACH_ABSORIGIN, keys.caster)
	local ice_wall_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall.vpcf", PATTACH_WORLDORIGIN, keys.caster)
	ParticleManager:SetParticleControl(ice_wall_particle_effect, 0, target_point - vector_distance_from_center)
	ParticleManager:SetParticleControl(ice_wall_particle_effect, 1, target_point + vector_distance_from_center)
	
--	local ice_wall_particle_effect_b = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall_b.vpcf", PATTACH_ABSORIGIN, keys.caster)
	local ice_wall_particle_effect_b = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall_b.vpcf", PATTACH_WORLDORIGIN, keys.caster)	
	ParticleManager:SetParticleControl(ice_wall_particle_effect_b, 0, target_point - vector_distance_from_center)
	ParticleManager:SetParticleControl(ice_wall_particle_effect_b, 1, target_point + vector_distance_from_center)
	
	--Ice Wall's duration is dependent on the level of Quas.
	local quas_ability = keys.caster:FindAbilityByName("ability_thdotsr_patchouli_water_earth")
	local ice_wall_duration = 0
	local quas_level = 1
	if quas_ability ~= nil then
		quas_level = quas_ability:GetLevel()
		ice_wall_duration = keys.ability:GetLevelSpecialValueFor("duration", quas_level - 1)
	end
	
	--Ice Wall's damage per second is dependent on the level of Exort.
	local exort_ability = keys.caster:FindAbilityByName("ability_thdotsr_patchouli_water_earth")
	local exort_level = 1
	local ice_wall_damage_per_second = 0
	if exort_ability ~= nil then
		exort_level = exort_ability:GetLevel()
		
		ice_wall_damage_per_second = keys.ability:GetLevelSpecialValueFor("damage_per_second", exort_level - 1)
	end
	
	--Remove the Ice Wall particles after the duration ends.
	Timers:CreateTimer({
		endTime = ice_wall_duration,
		callback = function()
			ParticleManager:DestroyParticle(ice_wall_particle_effect, false)
			ParticleManager:DestroyParticle(ice_wall_particle_effect_b, false)
		end
	})
	
	--Create dummy units in a line that slow nearby enemies with their aura.
	for i=0, keys.NumWallElements, 1 do
		local ice_wall_unit = CreateUnitByName("npc_dummy_unit", one_end_point + direction_to_target_point_normal * (keys.WallElementSpacing * i), false, nil, nil, keys.caster:GetTeam())
		
		--We give the ice wall dummy unit its own instance of Ice Wall both to more easily make it apply the correct intensity of slow (based on Quas' level)
		--and because if Invoker uninvokes Ice Wall and the spell is removed from his toolbar, existing modifiers originating from that ability can start to error out.
		ice_wall_unit:AddAbility("ability_thdotsr_patchouli_water_earth")
		local ice_wall_unit_ability = ice_wall_unit:FindAbilityByName("ability_thdotsr_patchouli_water_earth")
		if ice_wall_unit_ability ~= nil then
			ice_wall_unit_ability:SetLevel(quas_level) --This ensures the correct slow intensity is applied.
			ice_wall_unit_ability:ApplyDataDrivenModifier(ice_wall_unit, ice_wall_unit, "modifier_invoker_ice_wall_datadriven_unit_ability", {duration = -1})
			ice_wall_unit_ability:ApplyDataDrivenModifier(ice_wall_unit, ice_wall_unit, "modifier_invoker_ice_wall_datadriven_unit_ability_aura_emitter_slow", {duration = -1})
			ice_wall_unit_ability:ApplyDataDrivenModifier(ice_wall_unit, ice_wall_unit, "modifier_invoker_ice_wall_datadriven_unit_ability_aura_emitter_damage", {duration = -1})
		end
		
		--Store the damage per second to deal.  This value is locked depending on Exort's level at the time Ice Wall was cast.
		ice_wall_unit.damage_per_second = ice_wall_damage_per_second
		ice_wall_unit.parent_caster = keys.caster  --Store the reference to the Invoker that spawned this Ice Wall unit.
		
		--Remove the Ice Wall auras after the duration ends, and the dummy units themselves after their aura slow modifiers will have all expired.
		Timers:CreateTimer({
			endTime = ice_wall_duration,
			callback = function()
				ice_wall_unit:RemoveModifierByName("modifier_invoker_ice_wall_datadriven_unit_ability_aura_emitter_slow")
				ice_wall_unit:RemoveModifierByName("modifier_invoker_ice_wall_datadriven_unit_ability_aura_emitter_damage")
				
				Timers:CreateTimer({
					endTime = keys.SlowDuration + 2,
					callback = function()
						ice_wall_unit:RemoveSelf()
					end
				})
			end
		})
	end
end

function modifier_invoker_ice_wall_datadriven_unit_ability_aura_damage_on_interval_think(keys)
	if keys.caster.damage_per_second ~= nil and keys.caster.parent_caster ~= nil then
		local totaldamage =  keys.caster.damage_per_second + keys.caster.parent_caster:GetIntellect()*0.5
		
	--	ApplyDamage({victim = keys.target, attacker = keys.caster.parent_caster, damage = keys.caster.damage_per_second * keys.DamageInterval, damage_type = DAMAGE_TYPE_MAGICAL,})

		local damage_table = {
			ability = keys.ability,
			victim = keys.target,
			attacker = keys.caster.parent_caster,
			damage = totaldamage * keys.DamageInterval,
			damage_type = DAMAGE_TYPE_MAGICAL, 
			damage_flags = 0
		}	
		UnitDamageTarget(damage_table)		
	end
end

function OnPatchouliLavaCromlechStart(keys)

	local caster = keys.caster
	local ability = keys.ability
	local targetpoint = keys.target_points[1]
	
	local effectIndex = ParticleManager:CreateParticle("particles/newthd/patchouli/fire_earth/patchouli_lava_rock.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(effectIndex, 0, targetpoint)
	ParticleManager:SetParticleControl(effectIndex, 1, Vector(keys.Radius,0,0))		
		
	
	local targets = FindUnitsInRadius(
				   caster:GetTeam(),						--caster team
				   targetpoint,							--find position
				   nil,										--find entity
				   keys.Radius,						--find radius
				   DOTA_UNIT_TARGET_TEAM_ENEMY,
				   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				   0, FIND_ANY_ORDER,
				   false
			    )	
	
	caster:EmitSound("Patchouli_Lava_Cromlech_Impact")	
	local totaldamage = keys.basedamage + caster:GetIntellect()*keys.intscale

	for _,v in pairs(targets) do


		ability:ApplyDataDrivenModifier(caster, v, "modifier_patchouli_lava_stun",nil)	
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, v, totaldamage, nil)
		local damage_table = {
			ability = keys.ability,
			victim = v,
			attacker = caster,
			damage = totaldamage,
			damage_type = DAMAGE_TYPE_MAGICAL, 
			damage_flags = 0
		}	
		UnitDamageTarget(damage_table)	



	end	
	
	


end



function OnPatchouliElementalHarvesterStart( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	ability.arrow_vision_radius = ability:GetLevelSpecialValueFor("arrow_vision", ability_level)
	ability.arrow_vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)
	ability.arrow_speed = ability:GetLevelSpecialValueFor("arrow_speed", ability_level)
	ability.arrow_start = caster_location
	ability.arrow_start_time = GameRules:GetGameTime()
	ability.arrow_direction = (target_point - caster_location):Normalized()
end

--[[Calculates the distance traveled by the arrow, then applies damage and stun according to calculations]]
function HarvesterHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local totaldamage = keys.damagexx + caster:GetIntellect()*keys.intscale
	
		local damage_table = {
			ability = keys.ability,
			victim = target,
			attacker = caster,
			damage = totaldamage,
			damage_type = DAMAGE_TYPE_MAGICAL, 
			damage_flags = 0
		}	
		UnitDamageTarget(damage_table)	
	if target:IsNull() ~= true and target:IsHero() and target:IsAlive() then
	
		if target:GetHealth() < target:GetMaxHealth()*keys.KillHP*0.01 then
			target:Kill(ability,caster)		
		
		end


	end	
		
end

--[[Calculates arrow location using available data and then creates a vision point]]
function HarvesterVision( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Calculate the arrow location using the data we saved at launch
	local vision_location = ability.arrow_start + ability.arrow_direction * ability.arrow_speed * (GameRules:GetGameTime() - ability.arrow_start_time)

	-- Create the vision point
	AddFOWViewer(caster:GetTeamNumber(), vision_location, ability.arrow_vision_radius, ability.arrow_vision_duration, false)
end

function OnPatchouliWaterElfStart(keys)

	local caster = keys.caster
	local ability = keys.ability

	local targets = FindUnitsInRadius(
				   caster:GetTeam(),						--caster team
				   caster:GetOrigin(),							--find position
				   nil,										--find entity
				   keys.Radius,						--find radius
				   DOTA_UNIT_TARGET_TEAM_ENEMY,
				   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				   0, FIND_ANY_ORDER,
				   false
			    )
	local totaldamage = keys.basedamage + caster:GetIntellect()*keys.intscale
	
	THDHealTarget(caster,caster,totaldamage)	
	
	for _,v in pairs(targets) do


		ability:ApplyDataDrivenModifier(caster, v, "modifier_patchouli_water_elf_push",nil)	
	
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, v, totaldamage, nil)

		
		
		

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		local damage_table = {
			ability = keys.ability,
			victim = v,
			attacker = caster,
			damage = totaldamage,
			damage_type = DAMAGE_TYPE_MAGICAL, 
			damage_flags = 0
		}	
		UnitDamageTarget(damage_table)	



	end


end

function OnPatchouliWaterElfStart2(keys)
	local shivas_guard_particle = ParticleManager:CreateParticle("particles/econ/events/ti7/shivas_guard_active_ti7.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(shivas_guard_particle, 1, Vector(keys.BlastFinalRadius, keys.BlastFinalRadius / keys.BlastSpeedPerSecond, keys.BlastSpeedPerSecond))
	local caster = keys.caster
	local ability = keys.ability
	keys.caster:EmitSound("DOTA_Item.ShivasGuard.Activate")
	keys.caster.shivas_guard_current_blast_radius = 0
	
	local totaldamage = keys.basedamage + caster:GetIntellect()*keys.intscale
	
	THDHealTarget(caster,caster,totaldamage)
	
	Timers:CreateTimer({
		endTime = .03, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		callback = function()
			keys.ability:CreateVisibilityNode(keys.caster:GetAbsOrigin(), keys.BlastVisionRadius, keys.BlastVisionDuration)  --Shiva's Guard's active provides 800 flying vision around the caster, which persists for 2 seconds.
		
			keys.caster.shivas_guard_current_blast_radius = keys.caster.shivas_guard_current_blast_radius + (keys.BlastSpeedPerSecond * .03)
			local nearby_enemy_units = FindUnitsInRadius(keys.caster:GetTeam(), keys.caster:GetAbsOrigin(), nil, keys.caster.shivas_guard_current_blast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

			for i, individual_unit in ipairs(nearby_enemy_units) do
				if not individual_unit:HasModifier("modifier_patchouli_water_elf_push_check") then

					local damage_table = {
					ability = keys.ability,
					victim = individual_unit,
					attacker = caster,
					damage = totaldamage,
					damage_type = DAMAGE_TYPE_MAGICAL, 
					damage_flags = 0
					}	
					UnitDamageTarget(damage_table)	
					
					--This impact particle effect should radiate away from the caster of Shiva's Guard.
					local shivas_guard_impact_particle = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, individual_unit)
					local target_point = individual_unit:GetAbsOrigin()
					local caster_point = individual_unit:GetAbsOrigin()
					ParticleManager:SetParticleControl(shivas_guard_impact_particle, 1, target_point + (target_point - caster_point) * 30)
					
					keys.ability:ApplyDataDrivenModifier(keys.caster, individual_unit, "modifier_patchouli_water_elf_push", nil)
					keys.ability:ApplyDataDrivenModifier(keys.caster, individual_unit, "modifier_patchouli_water_elf_push_check", nil)					
				end
			end
			
			if keys.caster.shivas_guard_current_blast_radius < keys.BlastFinalRadius then  --If the blast should still be expanding.
				return .03
			else  --The blast has reached or exceeded its intended final radius.
				keys.caster.shivas_guard_current_blast_radius = 0
				return nil
			end
		end
	})	
	
end

function deafening_blast_knockback_start( keys )
	local caster = keys.caster -- Dummy
	local caster_owner = caster:GetOwner() -- Hero
	local caster_location = caster:GetAbsOrigin() 
	local target = keys.target
	local target_location = target:GetAbsOrigin()

	target.deafening_direction = (target_location - caster_location):Normalized()
	target.deafening_caster = caster_owner
end

--[[Author: Pizzalol
	Date: 21.04.2015.
	Triggers on an interval in the knockback modifier, moves the target]]
function deafening_blast_knockback( keys )
	local target = keys.target
	local target_location = target:GetAbsOrigin() 
	local caster = keys.caster
	local calcualtepushrange = CalcDistanceBetweenEntityOBB(target,caster)	
	local knockbackrange = keys.pushradius - calcualtepushrange
	local knockback_speed = (knockbackrange/keys.durationz)*keys.intervals
--	local knockback_speed = 6

	local new_location = target_location + target.deafening_direction * knockback_speed
	target:SetAbsOrigin(GetGroundPosition(new_location, target))
end

function PatchouliFreePathing(keys)

	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	
	ability:ApplyDataDrivenModifier(caster,target, "modifier_patchouli_water_elf_free_path",nil)	


end

function MercuryPoisonSound( event )
	local target = event.target
	local ability = event.ability
	local duration = event.Durationx

	target:EmitSound("Hero_Alchemist.AcidSpray")

	-- Stops the sound after the duration, a bit early to ensure the thinker still exists
	Timers:CreateTimer(duration-0.1, function() 
		target:StopSound("Hero_Alchemist.AcidSpray") 
	end)

end

function OnPatchouliMercuryPoisonTick(keys)

	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local totaldamage = (keys.Basedamage + caster:GetIntellect()*keys.intscale)*keys.intervals
	
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, totaldamage, nil)
		local damage_table = {
			ability = keys.ability,
			victim = target,
			attacker = caster,
			damage = totaldamage,
			damage_type = DAMAGE_TYPE_MAGICAL, 
			damage_flags = 0
		}	
		UnitDamageTarget(damage_table)		

end

function OnPatchouliMercuryPoisonTickEnd(keys)

	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	
	ability:ApplyDataDrivenModifier(caster,target, "modifier_patchouli_mercury_poison_end",nil)	



end


