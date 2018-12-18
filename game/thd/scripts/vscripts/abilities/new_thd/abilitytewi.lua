--[[Author: Pizzalol
	Date: 24.03.2015.
	Creates the land mine and keeps track of it]]
function LandMinesPlant( keys )
	local caster = keys.caster
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Initialize the count and table
	caster.land_mine_count = caster.land_mine_count or 0
	caster.land_mine_table = caster.land_mine_table or {}

	-- Modifiers
	local modifier_land_mine = keys.modifier_land_mine
	local modifier_tracker = keys.modifier_tracker
	local modifier_caster = keys.modifier_caster
	local modifier_land_mine_invisibility = keys.modifier_land_mine_invisibility

	-- Ability variables
	local activation_time = ability:GetLevelSpecialValueFor("activation_time", ability_level) 
	local max_mines = ability:GetLevelSpecialValueFor("max_mines", ability_level) 
	local fade_time = ability:GetLevelSpecialValueFor("fade_time", ability_level)

	-- Create the land mine and apply the land mine modifier
	local land_mine = CreateUnitByName("npc_tewi_bomb_"..math.random(1,2), target_point, false, nil, nil, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, land_mine, modifier_land_mine, {})

	
	land_mine:StartGesture(ACT_DOTA_IDLE)	
	-- Update the count and table
	caster.land_mine_count = caster.land_mine_count + 1
	table.insert(caster.land_mine_table, land_mine)

	-- If we exceeded the maximum number of mines then kill the oldest one
	if caster.land_mine_count > max_mines then
		caster.land_mine_table[1]:ForceKill(true)
	end

	-- Increase caster stack count of the caster modifier and add it to the caster if it doesnt exist
	if not caster:HasModifier(modifier_caster) then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})
	end

	caster:SetModifierStackCount(modifier_caster, ability, caster.land_mine_count)

	-- Apply the tracker after the activation time
	Timers:CreateTimer(activation_time, function()
		ability:ApplyDataDrivenModifier(caster, land_mine, modifier_tracker, {})
	end)

	-- Apply the invisibility after the fade time
	Timers:CreateTimer(fade_time, function()
		ability:ApplyDataDrivenModifier(caster, land_mine, modifier_land_mine_invisibility, {})
	end)
end

--[[Author: Pizzalol
	Date: 24.03.2015.
	Stop tracking the mine and create vision on the mine area]]
function LandMinesDeath( keys )
	local caster = keys.caster
	local unit = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local modifier_caster = keys.modifier_caster
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level) 
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)

	-- Find the mine and remove it from the table
	for i = 1, #caster.land_mine_table do
		if caster.land_mine_table[i] == unit then
			table.remove(caster.land_mine_table, i)
			caster.land_mine_count = caster.land_mine_count - 1
			break
		end
	end

	-- Create vision on the mine position
	ability:CreateVisibilityNode(unit:GetAbsOrigin(), vision_radius, vision_duration)

	-- Update the stack count
	caster:SetModifierStackCount(modifier_caster, ability, caster.land_mine_count)
	if caster.land_mine_count < 1 then
		caster:RemoveModifierByNameAndCaster(modifier_caster, caster) 
	end
end

--[[Author: Pizzalol
	Date: 24.03.2015.
	Tracks if any enemy units are within the mine radius]]
function LandMinesTracker( keys )
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local trigger_radius = ability:GetLevelSpecialValueFor("small_radius", ability_level) 
	local explode_delay = ability:GetLevelSpecialValueFor("explode_delay", ability_level) 

	-- Target variables
	local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
	local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES

	-- Find the valid units in the trigger radius
	local units = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, trigger_radius, target_team, target_types, target_flags, FIND_CLOSEST, false) 

	-- If there is a valid unit in range then explode the mine
--	if #units > 0 then
--		Timers:CreateTimer(explode_delay, function()
--			if target:IsAlive() then
--				target:ForceKill(true) 
--			end
--		end)
--	end

	for _,v in pairs(units) do	
		if v:GetUnitName()~="npc_coin_up_unit" or v:GetUnitName()~="npc_power_up_unit" then
			Timers:CreateTimer(explode_delay, function()
				if target:IsAlive() then
					target:ForceKill(true) 
				end
			end)
		end
	end	
	
end


function LandMinesExplodedamage(keys)

	local caster = keys.caster
	local targets = keys.target_entities
	local bombdamage = keys.bombdamage
	local ability = keys.ability
	local abilitymulti = keys.AbilityMulti
	local deal_damage =	bombdamage + abilitymulti*caster:GetIntellect()
	
		for _,v in pairs(targets) do
		if v:IsHero() == false and v:IsBuilding() == false then
					local damage_table = {
						ability = ability,
						victim = v,
						attacker = caster,
						damage = deal_damage*2,
						damage_type = keys.ability:GetAbilityDamageType(), 
						damage_flags = 0
					}
					UnitDamageTarget(damage_table)	
		ability:ApplyDataDrivenModifier(caster, v, "modifier_tewi01_stun",nil)
			if v:GetClassname() == "npc_dota_courier" then
			
			v:Kill(ability,caster)
			end
		end	
		
		if v:IsHero() == true  then
					local damage_table = {
						ability = ability,
						victim = v,
						attacker = caster,
						damage = deal_damage,
						damage_type = keys.ability:GetAbilityDamageType(), 
						damage_flags = 0
					}
					UnitDamageTarget(damage_table)	
		ability:ApplyDataDrivenModifier(caster, v, "modifier_tewi01_stun",nil)
			if v:GetClassname() == "npc_dota_courier" then
			
			v:Kill(ability,caster)
			end
		end			
		
		if v:IsBuilding() == true then
		
					local damage_table = {
						ability = ability,
						victim = v,
						attacker = caster,
						damage = deal_damage/2,
						damage_type = keys.ability:GetAbilityDamageType(), 
						damage_flags = 0
					}
					UnitDamageTarget(damage_table)		
		
		end
		end


end



function tewi01exploding(keys)
	--local attackerx = keys.attacker
	local caster = keys.caster
	local ability = keys.ability
	local abilitymulti = keys.AbilityMulti	
	local bombdamage = keys.bombdamage	
	local deal_damage =	bombdamage + abilitymulti*caster:GetIntellect()	
	local targets = keys.target_entities	
	
	local casterHP = caster:GetHealth()	
	if casterHP == 0  and caster:IsIllusion() == false then 
		for _,v in pairs(targets) do	
					local damage_table = {
						ability = ability,
						victim = v,
						attacker = caster,
						damage = deal_damage*2,
						damage_type = keys.ability:GetAbilityDamageType(), 
						damage_flags = 0
					}
					UnitDamageTarget(damage_table)	
		ability:ApplyDataDrivenModifier(caster, v, "modifier_tewi01_stun2",nil)	
	
	end
	
	end

end

function OnTewi02Manacost (keys)
	local caster = keys.caster
	local manacost = keys.manacost
	local ability = keys.ability
	if caster:GetMana() < manacost then
	
		return 
	
	else
	
		caster:SpendMana(manacost,ability)
	end

end



function CheckBackstab(params)
	
	local ability = params.ability
	--local agility_damage_multiplier = ability:GetLevelSpecialValueFor("agility_damage", ability:GetLevel() - 1) / 100

	-- The y value of the angles vector contains the angle we actually want: where units are directionally facing in the world.
	local victim_angle = params.target:GetAnglesAsVector().y
	local origin_difference = params.target:GetAbsOrigin() - params.attacker:GetAbsOrigin()

	-- Get the radian of the origin difference between the attacker and Riki. We use this to figure out at what angle the victim is at relative to Riki.
	local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)
	
	-- Convert the radian to degrees.
	origin_difference_radian = origin_difference_radian * 180
	local attacker_angle = origin_difference_radian / math.pi
	-- Makes angle "0 to 360 degrees" as opposed to "-180 to 180 degrees" aka standard dota angles.
	attacker_angle = attacker_angle + 180.0
	
	-- Finally, get the angle at which the victim is facing Riki.
	local result_angle = attacker_angle - victim_angle
	result_angle = math.abs(result_angle)
	

	local manacost = params.manacost
	if params.attacker:GetMana() < manacost then
	
		return 
	
	else	
	
	
	
	-- Check for the backstab angle.
	if result_angle >= (180 - (ability:GetSpecialValueFor("backstab_angle") / 2)) and result_angle <= (180 + (ability:GetSpecialValueFor("backstab_angle") / 2)) then 
		-- Play the sound on the victim.
		EmitSoundOn(params.sound, params.target)
		-- Create the back particle effect.
		local particle = ParticleManager:CreateParticle(params.particle, PATTACH_ABSORIGIN_FOLLOW, params.target) 
		-- Set Control Point 1 for the backstab particle; this controls where it's positioned in the world. In this case, it should be positioned on the victim.
		ParticleManager:SetParticleControlEnt(particle, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true) 
		-- Apply extra backstab damage based on Riki's agility
					local backstabdamage = params.backstabdamage
					local deal_damage = params.target:GetMaxHealth()*backstabdamage/50
					local damage_table = {
						ability = params.ability,
						victim = params.target,
						attacker = params.attacker,
						damage = deal_damage,
						damage_type = params.ability:GetAbilityDamageType(), 
						damage_flags = 0
					}
					UnitDamageTarget(damage_table)
					local backchance = params.backchance
					if RollPercentage(backchance) then	
					
					params.ability:ApplyDataDrivenModifier(params.attacker, params.target, "modifier_tewi02stun",nil)	
					

					end
		
	else

					local backstabdamage = params.backstabdamage
					local deal_damage = params.target:GetMaxHealth()*backstabdamage/100
					local damage_table = {
						ability = params.ability,
						victim = params.target,
						attacker = params.attacker,
						damage = deal_damage,
						damage_type = params.ability:GetAbilityDamageType(), 
						damage_flags = 0
					}
					UnitDamageTarget(damage_table)	
					local frontchance = params.frontchance
					if RollPercentage(frontchance) then	
					
					params.ability:ApplyDataDrivenModifier(params.attacker, params.target, "modifier_tewi02stun",nil)	
					

					end					
	
	end
	
	end
end

function OnTewi04AttackDamage(keys)
	local caster = keys.caster
 	local attacker = keys.attacker
	local target = keys.target
	local extradamage = keys.extradamage
	
	local totalextradamage = attacker:GetAttackDamage()*extradamage/100
	
local damageTable = {
	victim = target,
	attacker = attacker,
	damage = totalextradamage,
	damage_type = DAMAGE_TYPE_PHYSICAL,
	damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	ability = keys.ability, --Optional.
}
		
		if RollPercentage(40) then	
		ApplyDamage(damageTable)		
		end
		

	
	

end


function OnTewi03attacklanded (keys)

	local caster = keys.caster
	local target = keys.target

	local ability = keys.ability
	
		ability:ApplyDataDrivenModifier(caster, target, "modifier_tewi03armordebuff",nil)	
	
	

end



function ForceStaff (keys)

	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1	
	local caster = keys.caster
	--caster:Stop()
	local pushrange = keys.pushlength
	
	local calcualtepushrange = CalcDistanceBetweenEntityOBB(target,caster)
	print(calcualtepushrange)
	local pushrange = pushrange - calcualtepushrange
	ability.forced_direction = caster:GetForwardVector()*(-1)
	ability.forced_distance = pushrange
	ability.forced_speed = ability:GetLevelSpecialValueFor("push_speed", ability_level) * 1/30	-- * 1/30 gives a duration of ~0.4 second push time (which is what the gamepedia-site says it should be)
	ability.forced_traveled = 0

end

function ForceHorizontal( keys )

	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability

	if ability.forced_traveled < ability.forced_distance then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.forced_direction * ability.forced_speed)
		ability.forced_traveled = ability.forced_traveled + (ability.forced_direction * ability.forced_speed):Length2D()
	else
		caster:InterruptMotionControllers(true)
	end

end

function remotesExplodedamage (keys)

	local caster = keys.caster
	local targets = keys.target_entities
	local bombdamage = keys.bombdamage
	local ability = keys.ability
	local abilitymulti = keys.AbilityMulti
	local deal_damage =	bombdamage + abilitymulti*caster:GetIntellect()
	local attacker = keys.attacker

	
	if attacker == caster or attacker:GetUnitName() == "npc_tewi_remote_bomb_1" then
		for _,v in pairs(targets) do
			if v:IsBuilding() == true then
					local damage_table = {
						ability = ability,
						victim = v,
						attacker = caster,
						damage = deal_damage,
						damage_type = keys.ability:GetAbilityDamageType(), 
						damage_flags = 0
					}
					UnitDamageTarget(damage_table)	
			end	
			if v:IsBuilding() == false then
					local damage_table = {
						ability = ability,
						victim = v,
						attacker = caster,
						damage = deal_damage,
						damage_type = keys.ability:GetAbilityDamageType(), 
						damage_flags = 0
					}
					UnitDamageTarget(damage_table)	
			end				
			
		end
	end	

end

function TewiEX(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local Caster=keys.caster
	local level = keys.ability:GetLevel()
    local ability = Caster:FindAbilityByName("techies_remote_mines_datadriven")
		ability:SetLevel(level)
		
		
	
end