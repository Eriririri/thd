function mana_burn_function( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local current_mana = target:GetMana()
	local current_int = caster:GetIntellect()
	local multiplier = keys.ability:GetLevelSpecialValueFor( "float_multiplier", keys.ability:GetLevel() - 1 )
	local number_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf"
	local burn_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf"
	local damageType = keys.ability:GetAbilityDamageType()
	
	-- Calculation
	local mana_to_burn = math.min( current_mana, current_int * multiplier*target:GetMaxMana()*0.01+15*target:GetMaxMana()*0.01 )
	local HP_to_burn = ( current_int * multiplier*target:GetMaxHealth()*0.01+15*target:GetMaxHealth()*0.01 )+ caster:GetIntellect()*2
	local life_time = 2.0
	local digits = string.len( math.floor( mana_to_burn ) ) + 1
	if is_spell_blocked(keys.target) then return end
	-- Fail check
	if target:IsMagicImmune() then
		mana_to_burn = 0
	end
	
	-- Apply effect of ability
	target:ReduceMana( mana_to_burn )
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = HP_to_burn,
		damage_type = damageType
	}
	ApplyDamage( damageTable )
	
	-- Show VFX
	local numberIndex = ParticleManager:CreateParticle( number_particle_name, PATTACH_OVERHEAD_FOLLOW, target )
	ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, mana_to_burn, 0 ) )
    ParticleManager:SetParticleControl( numberIndex, 2, Vector( life_time, digits, 0 ) )
	local burnIndex = ParticleManager:CreateParticle( burn_particle_name, PATTACH_ABSORIGIN, target )
	
	-- Create timer to properly destroy particles
	Timers:CreateTimer( life_time, function()
			ParticleManager:DestroyParticle( numberIndex, false )
			ParticleManager:DestroyParticle( burnIndex, false)
			return nil
		end
	)
end

function NightmareDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	local target_health = target:GetHealth()
	local damage = ability:GetAbilityDamage()

	-- Check if the damage would be lethal
	-- If it is lethal then deal pure damage
	if target_health < damage + 1 then
		local damage_table = {}

		damage_table.attacker = caster
		damage_table.victim = target
		damage_table.ability = ability
		damage_table.damage_type = ability:GetAbilityDamageType()
		damage_table.damage = damage

		ApplyDamage(damage_table)
	else
		-- Otherwise just set the health to be lower
		target:SetHealth(target_health - damage)
	end
end

--[[Author: Pizzalol, chrislotix
	Date: 12.02.2015.
	Checks if the target thats about to be attacked has the Nightmare debuff
	If it does then we transfer the debuff and stop both units from taking any action]]
function NightmareBreak( keys )
	local caster = keys.caster
	local target = keys.target
	local attacker = keys.attacker -- need to test local attacker(works) and local caster(not needed)
	local ability = keys.ability
	local nightmare_modifier = keys.nightmare_modifier

	-- Check if it has the Nightmare debuff
	if target:HasModifier(nightmare_modifier) then
		
		-- If it does then remove the modifier from the target and apply it to the attacker
		target:RemoveModifierByName(nightmare_modifier)
		ability:ApplyDataDrivenModifier(caster, attacker, nightmare_modifier, {})

		-- Stop any action on both units after transfering the debuff to prevent
		-- it from chaining endlessly
		Timers:CreateTimer(0.03, function()
			local order_target = 
			{
				UnitIndex = target:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = target:GetAbsOrigin()
			}
			local order_attacker = 
			{
				UnitIndex = attacker:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = attacker:GetAbsOrigin()
			}

			ExecuteOrderFromTable(order_attacker)
			ExecuteOrderFromTable(order_target)		
		end)
	end
end

--[[Author: Pizzalol
	Date: 12.02.2015.
	Acts as an aura which applies a debuff on the target
	the debuff does the NightmareBreak function calls]]
function NightmareAura( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier

	local aura_radius = ability:GetLevelSpecialValueFor("aura_radius", ability:GetLevel() - 1)

	local units = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, aura_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType(), 0, 0, false)

	for _,v in pairs(units) do
		if v ~= target then
			ability:ApplyDataDrivenModifier(caster, v, modifier, {duration = 0.5})
		end
	end
end

--[[Author: Pizzalol
	Date: 12.02.2015.
	Stops the sound from playing]]
function NightmareStopSound( keys )
	local target = keys.target
	local sound = keys.sound

	StopSoundEvent(sound, target)
end

--[[Author: Pizzalol
	Date: 12.02.2015.
	Checks if the target that we applied the Nightmare debuff on is the caster
	if it is the caster then we give him the ability to break the Nightmare and on calls
	where the Nightmare ends then it reverts the abilities]]
function NightmareCasterCheck( keys )
	local target = keys.target
	local caster = keys.caster
	local check_ability = keys.check_ability

	-- If it is the caster then swap abilities
	if target == caster then
		-- Swap sub_ability
		local sub_ability_name = keys.sub_ability_name
		local main_ability_name = keys.main_ability_name

		caster:SwapAbilities(main_ability_name, sub_ability_name, false, true)

		-- Sets the level of the ability that we swapped 
		if main_ability_name == check_ability then
			local level_ability = caster:FindAbilityByName(sub_ability_name)
			level_ability:SetLevel(1)
		end
	end
end

--[[Author: Pizzalol
	Date: 12.02.2015.
	Turns of the toggle of the ability]]
function NightmareCasterEnd( keys )
	local caster = keys.caster
	local ability = keys.ability

	ability:ToggleAbility()
end


--[[Author: 3glol
	Date: 26.08.2018.]]
function OnSatori04SpellStart(keys)
	local caster = keys.caster
	local wakeupdurationx = keys.wakeupduration2
	local target = keys.target
	local ability = keys.ability
	local wakedamage = keys.wakeupdamage
--	if FindTalentValue(caster,"special_bonus_unique_satori_3")~=0 then
--	ApplyDamage({victim = target, attacker = caster, damage = ((caster:GetIntellect()*2.6) + wakedamage + 200)/wakeupdurationx, damage_type = DAMAGE_TYPE_PURE})
--	else
--	ApplyDamage({victim = target, attacker = caster, damage = ((caster:GetIntellect()*2.6) + wakedamage)/wakeupdurationx, damage_type = DAMAGE_TYPE_PURE})
--	end 
	if FindTalentValue(caster,"special_bonus_unique_satori_3")~=0 then	
		UnitDamageTarget{
			ability = keys.ability,
			victim = target,
			attacker = caster,
			damage = ((caster:GetIntellect()*2.6) + wakedamage + 200)/wakeupdurationx,
			damage_type = DAMAGE_TYPE_MAGICAL
		}
	else
		UnitDamageTarget{
			ability = keys.ability,
			victim = target,
			attacker = caster,
			damage = ((caster:GetIntellect()*2.6) + wakedamage)/wakeupdurationx,
			damage_type = DAMAGE_TYPE_MAGICAL
		}
	end	
	
	
	
end

function OnSatori01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	
	local target = keys.target
	local ability = keys.ability
	if is_spell_blocked(keys.target) then return end
	
	 ApplyDamage({victim = target, attacker = caster, damage = ability:GetAbilityDamage()+(caster:GetIntellect()*1.55), damage_type = DAMAGE_TYPE_MAGICAL})
	 
end
function Satori01_Charge(keys)
	local Ability = keys.ability
	local Caster = keys.caster
	local Target = keys.unit
	--if Caster:IsRealHero() then
	if Caster:GetTeam()~=Target:GetTeam() and Caster:CanEntityBeSeenByMyTeam(Target) then
	
		if (Caster:GetModifierStackCount("modifier_satori01_charge", Caster)<(keys.MaxCharges)) then
			Caster:SetModifierStackCount("modifier_satori01_charge", ability, Caster:GetModifierStackCount("modifier_satori01_charge", Caster)+1)
		end	
	--end
	end
end

function Satori01_OnProjectileHit(keys)
	if is_spell_blocked(keys.target) then return end
	local Ability=keys.ability
	local Caster = EntIndexToHScript(keys.caster_entindex)
	local Target=keys.target
	local casterx = keys.caster
	local Damage=keys.DamageDealt
	if (Caster:GetModifierStackCount("modifier_satori01_charge", Caster)==keys.MaxCharges) then
		UnitDamageTarget{
			ability = keys.ability,
			victim = Target,
			attacker = Caster,
			damage = 200 + ((Damage+(casterx:GetIntellect()*0.4)) * (Caster:GetModifierStackCount("modifier_satori01_charge", Caster)+1)),
			damage_type = Ability:GetAbilityDamageType()
		}
	else
		UnitDamageTarget{
			ability = keys.ability,
			victim = Target,
			attacker = Caster,
			damage = (Damage+(casterx:GetIntellect()*0.4)) * (Caster:GetModifierStackCount("modifier_satori01_charge", Caster)+1),
			damage_type = Ability:GetAbilityDamageType()
		}
	end
	UtilStun:UnitStunTarget(Caster,Target,keys.StunDuration)
	keys.ability:ApplyDataDrivenModifier(Caster,Target,keys.VisionName,{})
	Caster:SetModifierStackCount("modifier_satori01_charge", ability, 0)
end

function Satori01_Charge_count(keys)
	local Caster = EntIndexToHScript(keys.caster_entindex)
	local ability = keys.ability
	
	local satoristack = Caster:FindModifierByName("modifier_satori01_charge")
    local stackcount = modifier:GetStackCount()
	
	caster:SetModifierStackCount("modifier_satori01_charge_count", ability,stackcount )

end

function OnSatori02SpellStart( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local current_mana = target:GetMana()
	local current_int = caster:GetIntellect()
	local multiplier = keys.ability:GetLevelSpecialValueFor( "float_multiplier", keys.ability:GetLevel() - 1 )
	local number_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf"
	local burn_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf"
	local damageType = keys.ability:GetAbilityDamageType()
	
	-- Calculation
	local mana_to_burn = math.min( current_mana, current_int * multiplier*target:GetMaxMana()*0.01+15*target:GetMaxMana()*0.01 )
	local HP_to_burn = ( current_int * multiplier*target:GetMaxHealth()*0.01+15*target:GetMaxHealth()*0.01 )+ caster:GetIntellect()*2
	local life_time = 2.0
	local digits = string.len( math.floor( mana_to_burn ) ) + 1
	--if is_spell_blocked(keys.target) then return end
	-- Fail check
	if target:IsMagicImmune() then
		mana_to_burn = 0
	end
	
	-- Apply effect of ability
	target:ReduceMana( mana_to_burn )
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = HP_to_burn,
		damage_type = damageType
	}
	ApplyDamage( damageTable )
	
	
	
	-- Show VFX
	local numberIndex = ParticleManager:CreateParticle( number_particle_name, PATTACH_OVERHEAD_FOLLOW, target )
	ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, mana_to_burn, 0 ) )
    ParticleManager:SetParticleControl( numberIndex, 2, Vector( life_time, digits, 0 ) )
	local burnIndex = ParticleManager:CreateParticle( burn_particle_name, PATTACH_ABSORIGIN, target )
	
	-- Create timer to properly destroy particles
	Timers:CreateTimer( life_time, function()
			ParticleManager:DestroyParticle( numberIndex, false )
			ParticleManager:DestroyParticle( burnIndex, false)
			return nil
		end
	)
end
function satoriEX(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local Caster=keys.caster
	local level = keys.ability:GetLevel()
    local ability = Caster:FindAbilityByName("ability_thdots_satori05")
		ability:SetLevel(level+1)
		
		
	
end

function OnsatoriExSpellOnDamage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local level = keys.ability:GetLevel()
--	if caster:GetHealth() > caster:GetMaxHealth()*0.01
--		then
--	caster:SetMana(caster:GetMana()+(keys.DamageTaken*level*0.1))
	Thdgetmana(caster,keys.DamageTaken*level*0.1)	
--	end
	if FindTalentValue(caster,"special_bonus_unique_satori_1")~=0 then
		keys.ability:ApplyDataDrivenModifier( caster, caster, "satori_talent_passive", {} )
	end
	
end



function Satori01x_Create(keys)
    local caster = EntIndexToHScript(keys.caster_entindex)
    caster:SetModifierStackCount("modifier_satori01_charge_count", caster, 0)
end





function Satori01x_Charge(keys)
	local Ability = keys.ability
	local Caster = keys.caster
	local Target = keys.unit
	--if Caster:IsRealHero() then
	--if Caster:GetTeam()~=Target:GetTeam() and Caster:CanEntityBeSeenByMyTeam(Target) then
	--local Ability = keys.ability	
	local satoristack = Caster:FindModifierByName("modifier_satori01_charge_count")
    local stackcount = satoristack:GetStackCount()
	--local Target2 = keys.Target
	
	
	if Caster:GetTeam()~=Target:GetTeam() and Caster:CanEntityBeSeenByMyTeam(Target) and FindTalentValue(Caster,"special_bonus_unique_satori_2")~=0
	
	and stackcount <(keys.MaxCharges+3)
	
	and 5 <stackcount
	
	then	
	
    Caster:SetModifierStackCount("modifier_satori01_charge_count", caster, stackcount + 1)

	
	end
	
	
	if Caster:GetTeam()~=Target:GetTeam() and Caster:CanEntityBeSeenByMyTeam(Target) 

	and stackcount <(keys.MaxCharges)
	 
	then	
	
    Caster:SetModifierStackCount("modifier_satori01_charge_count", caster, stackcount + 1)
	end
	
--	print (Ability:GetAbilityName())
	
--	local CurrentActiveAbility = Target:GetCurrentActiveAbility()
--	print(CurrentActiveAbility:GetAbilityName())	
end
		
	--end

function Satori01x_OnProjectileHit(keys)

	local Ability=keys.ability
	local Caster = EntIndexToHScript(keys.caster_entindex)
	local Target=keys.target
	local casterx = keys.caster
	local Damage=keys.DamageDealt
	local bonusdmg = keys.Bonusdmg
	if is_spell_blocked(keys.target) then Caster:SetModifierStackCount("modifier_satori01_charge_count", ability, 0) return end	
	if (Caster:GetModifierStackCount("modifier_satori01_charge_count", Caster)>=keys.MaxCharges) then
		UnitDamageTarget{
			ability = keys.ability,
			victim = Target,
			attacker = Caster,
			damage = bonusdmg + ((Damage+(casterx:GetIntellect()*keys.intscale)+FindTalentValue(Caster,"special_bonus_unique_satori_4")) * (Caster:GetModifierStackCount("modifier_satori01_charge_count", Caster)+1)),
			damage_type = Ability:GetAbilityDamageType()
		}
	else
		UnitDamageTarget{
			ability = keys.ability,
			victim = Target,
			attacker = Caster,
			damage = (Damage+(casterx:GetIntellect()*keys.intscale)+FindTalentValue(Caster,"special_bonus_unique_satori_4")) * (Caster:GetModifierStackCount("modifier_satori01_charge_count", Caster)+1),
			damage_type = Ability:GetAbilityDamageType()
		}
	end
	UtilStun:UnitStunTarget(Caster,Target,keys.StunDuration)
	keys.ability:ApplyDataDrivenModifier(Caster,Target,keys.VisionName,{})
	Caster:SetModifierStackCount("modifier_satori01_charge_count", ability, 0)
end


function OnSatori02zSpellEffects (keys)

	local caster = keys.caster

	local point = keys.target_points[1]
	local aoeradius = keys.AoeRadius
	
	 local effectIndex2 = ParticleManager:CreateParticle( "particles/newthd/satori/02/satori02light.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex2, 0, point)
	ParticleManager:SetParticleControl(effectIndex2, 1, point)

	
	
	
	--ParticleManager:SetParticleControl(effectIndex2, 2, point)	
		
	ParticleManager:DestroyParticleSystem(effectIndex2,false)		
		
end


function OnSatori02zSpellStart( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	
	local targets = keys.target_entities
	

	
	if caster.satori02target == nil then
	caster.satori02target = 0
	end

	
		for _,v in pairs(targets) do
			
	local caster = keys.caster
	local target = v
	local current_mana = target:GetMana()
	local current_int = caster:GetIntellect()
	local percdamage = keys.percentdamage	
	
	local multiplierx = keys.ability:GetLevelSpecialValueFor( "int_scale", keys.ability:GetLevel() - 1 )	
	
	local multiplier = (multiplierx * 0.01)
	
	--print(multiplier)
	
	local number_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf"
	local burn_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf"
	local damageType = keys.ability:GetAbilityDamageType()
	
	-- Calculation
	local mana_to_burn = math.min( current_mana, current_int * multiplier*target:GetMaxMana()*0.01 + percdamage*target:GetMaxMana()*0.01 )
	
	--print(mana_to_burn)	
	
	local HP_to_burn = ( current_int * multiplier*target:GetMaxHealth()*0.01+percdamage*target:GetMaxHealth()*0.01 )+ caster:GetIntellect()*keys.hpscaleint
	
	--print(HP_to_burn)		
	--local HP_to_burn2 = (current_int * multiplier*target:GetMaxMana()*0.01 + 15*target:GetMaxMana()*0.01 ) + caster:GetIntellect()*2
	
	local life_time = 2.0
	local digits = string.len( math.floor( mana_to_burn ) ) + 1
	--if is_spell_blocked(keys.target) then return end
	-- Fail check
	if target:IsMagicImmune() then
		mana_to_burn = 0
	end
	
	-- Apply effect of ability
	target:ReduceMana( mana_to_burn )
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = HP_to_burn,
		damage_type = damageType
	}
	--ApplyDamage( damageTable )
	
	local effectIndex2 = ParticleManager:CreateParticle( "particles/newthd/satori/02/satori02light.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex2, 0, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex2, 1, target:GetOrigin())	
	
	-- Show VFX
	local numberIndex = ParticleManager:CreateParticle( number_particle_name, PATTACH_OVERHEAD_FOLLOW, target )
	ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, mana_to_burn, 0 ) )
    ParticleManager:SetParticleControl( numberIndex, 2, Vector( life_time, digits, 0 ) )
	local burnIndex = ParticleManager:CreateParticle( burn_particle_name, PATTACH_ABSORIGIN, target )
	
	-- Create timer to properly destroy particles
	Timers:CreateTimer( life_time, function()
			ParticleManager:DestroyParticle( numberIndex, false )
			ParticleManager:DestroyParticle( burnIndex, false)
			return nil
		end
	)
	
	caster.satori02target = 1
	
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target,HP_to_burn, nil)		
	
	ApplyDamage( damageTable )	
	
	end
	
	
	if caster.satori02target ~= 0 then
		caster:EmitSound("ability_satori02")
		caster.satori02target = 0
	end	
	

end



function OnSatori03Cooldown(keys)

	local caster = EntIndexToHScript(keys.caster_entindex)
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_terrorblade_2"))

end


function Reflection( event )
	print("Reflection Start")

	----- Conjure Image  of the target -----
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local unit_name = target:GetUnitName()
	local origin = target:GetAbsOrigin() + RandomVector(100)
	local duration = ability:GetLevelSpecialValueFor( "illusion_duration", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "illusion_outgoing_damage", ability:GetLevel() - 1 )
	
	if is_spell_blocked(target) then return end	
	
	
--	if target:HasAbility("ability_thdots_EXrumia01") then return end		
	
	

	-- handle_UnitOwner needs to be nil, else it will crash the game.
	local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
	illusion:SetPlayerID(caster:GetPlayerID())
	
	-- Level Up the unit to the targets level
	local targetLevel = target:GetLevel()
	for i=1,targetLevel-1 do
		illusion:HeroLevelUp(false)
	end

	-- Set the skill points to 0 and learn the skills of the target
	illusion:SetAbilityPoints(0)
	if target:HasAbility("ability_thdots_EXrumia01") then 
	
	
				illusion:RemoveAbility("ability_thdots_rumia01")
				illusion:RemoveAbility("ability_thdots_rumia02")	
				illusion:RemoveAbility("ability_thdots_rumia03")
				illusion:RemoveAbility("ability_thdots_rumia04")
				illusion:SetModel("models/thd2/rumia_ex/rumia_ex.vmdl")
				illusion:SetOriginalModel("models/thd2/rumia_ex/rumia_ex.vmdl")	
				illusion:SetPrimaryAttribute(1)
				
				illusion:SetBaseStrength(target:GetBaseStrength())
				illusion:SetBaseAgility(target:GetBaseAgility())
				illusion:SetBaseIntellect(target:GetIntellect())	
				illusion:SetBaseDamageMax(30)
				illusion:SetBaseDamageMin(30)
				illusion:AddAbility("ability_thdots_EXrumia01")
				illusion:AddAbility("ability_thdots_EXrumia02")
				illusion:AddAbility("ability_thdots_EXrumia03")
				illusion:AddAbility("ability_thdots_EXrumia04")
				illusion:AddAbility("ability_thdots_EXrumia05"):SetLevel(1)		
	

	end		
	
--	if target:GetUnitName() ~= "npc_dota_hero_lich" then

	if target:HasAbility("ability_thdotsr_patchouli_water_fire_earth")	then
		return
	
	end
	
	for abilitySlot2=0,15 do
		local ability = illusion:GetAbilityByIndex(abilitySlot2)
		if ability ~= nil then 
		illusion:RemoveAbility(ability:GetName())
		end
	end							
	
	for abilitySlot=0,15 do
			
		local ability = target:GetAbilityByIndex(abilitySlot)
		if ability ~= nil then 
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			illusion:AddAbility(abilityName)
			local illusionAbility = illusion:FindAbilityByName(abilityName)
			illusionAbility:SetLevel(abilityLevel)
		end
	end
	
--	end
	

	-- Recreate the items of the target
	for itemSlot=0,8 do
	
		local wipe_item_index = illusion:GetItemInSlot(itemSlot)
		if wipe_item_index then
			illusion:RemoveItem(wipe_item_index)
		end	
	
		local item = target:GetItemInSlot(itemSlot)
		
		if item ~= nil then
			local itemName = item:GetName()
			local newItem = CreateItem(itemName, illusion, illusion)
			illusion:AddItem(newItem)
			newItem:SetPurchaser(nil)
		end
	end

	-- Set the unit as an illusion
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
	illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = 0 })
	
	-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
	illusion:MakeIllusion()

	-- Apply Invulnerability modifier
	ability:ApplyDataDrivenModifier(caster, illusion, "modifier_reflection_invulnerability", nil)

	-- Force Illusion to attack Target
	illusion:SetForceAttackTarget(target)

	-- Emit the sound, so the destroy sound is played after it dies
	illusion:EmitSound("Hero_Terrorblade.Reflection")

end

--[[Author: Noya
	Date: 11.01.2015.
	Shows the Cast Particle, which for TB is originated between each weapon, in here both bodies are linked because not every hero has 2 weapon attach points
]]
function ReflectionCast( event )

	local caster = event.caster
	local target = event.target
	local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_reflection_cast.vpcf"

	local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )
	ParticleManager:SetParticleControl(particle, 3, Vector(1,0,0))
	
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
end



