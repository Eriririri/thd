

function OnNazrin01SpellStart (keys)


	local target = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1	

	target:Stop()
	local caster = keys.caster

	caster.forced_direction = caster:GetForwardVector()
	ability.forced_distance = ability:GetLevelSpecialValueFor("push_length", ability_level)
	ability.forced_speed = ability:GetLevelSpecialValueFor("push_speed", ability_level) * 1/30	-- * 1/30 gives a duration of ~0.4 second push time (which is what the gamepedia-site says it should be)
	ability.forced_traveled = 0

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_OnNazrin01_active", {})
	
	if FindTalentValue(caster,"special_bonus_unique_nazrin_3") ~=0 then
	
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_OnNazrin01_active_talent", {})	
	
	end


end


function OnNazrin01controlmotion (keys)


	local target = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1	

	local caster = keys.caster
	
	
	caster.forced_direction = caster:GetForwardVector()



end

function Nazrin01Horizontal( keys )

	local target = keys.caster
	local ability = keys.ability
	local caster = keys.caster
		

	if ability.forced_traveled < ability.forced_distance then
		target:SetAbsOrigin(target:GetAbsOrigin() + caster.forced_direction * ability.forced_speed)
		ability.forced_traveled = ability.forced_traveled + (caster.forced_direction * ability.forced_speed):Length2D()
	else
		target:InterruptMotionControllers(true)
	end

end




function OnNazrin03Attacklanded (keys)


	local caster = keys.caster
	local target = keys.caster	
	local ability = keys.ability
	
	local totalchance = keys.basechance + FindTalentValue(caster,"special_bonus_unique_nazrin_2")
	
	if RollPercentage(totalchance) then	

	ability:ApplyDataDrivenModifier(caster, caster, "passive_nazrin03_attack_double", {})
	--caster:PerformAttack(target,true,false,true,false,true,false,true)
	end
end

function OnNazrin03Attackdouble (keys)


	local caster = keys.caster
	local target = keys.caster	
	local ability = keys.ability

	caster:RemoveModifierByName("passive_nazrin03_attack_double")
	--caster:PerformAttack(target,true,false,true,false,true,false,true)
end


function OnNazrin04SpellStart(keys)

	local caster = keys.caster
	local target = keys.target	
	local ability = keys.ability


	ability:ApplyDataDrivenModifier(caster, target, "modifier_nazrin04takedamage", {})	
	
	
end	


function OnNazrin04Attacked(keys)

	local attacker = keys.attacker

	local caster = keys.caster
	local target = keys.target		
	local ability = keys.ability
	local nazrin04dealdamage = keys.basenazrindamage + (keys.bonusnazrindamage*caster:GetAgility() )
	
	
	
	
	if attacker:IsRealHero() then
	
		if attacker:HasModifier("modifier_nazrin04_check") then
			return

		end
		
		
		local damage_table = {
				ability = keys.ability,
			    victim = target,
			    attacker = caster,
			    damage = nazrin04dealdamage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		target:EmitSound("Nazrin04")
		target:EmitSound("Nazrin04_"..math.random(1,6))
		local effectIndex = ParticleManager:CreateParticle("particles/generic_gameplay/lasthit_coins.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
--		ParticleManager:SetParticleControl(effectIndex, 1, Vector(300,0,0))
		
		ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)		
		
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_nazrin04_check", {})	
		ability:ApplyDataDrivenModifier(caster, target, "modifier_nazrin04_stun", {})			
		UnitDamageTarget(damage_table)		
	
	
	end



end

function OnNazrin04bounty (keys)

	local caster = keys.caster
--	local target = keys.target		
	local ability = keys.ability

	local targets = FindUnitsInRadius(
				   caster:GetTeam(),						--caster team
				   caster:GetOrigin(),							--find position
				   nil,										--find entity
				   FIND_UNITS_EVERYWHERE,						--find radius
				   DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				   DOTA_UNIT_TARGET_HERO,
				   DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0,
				   false
			    )
					
	EmitGlobalSound("Nazrin04_4")	
	
	for _,v in pairs(targets) do
		
	local totalgoldget = keys.GiveGoldAmount+FindTalentValue(caster,"special_bonus_unique_nazrin_4")
	
		if v:HasModifier("modifier_nazrin04_check")	 then
			local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_tnt_rain_coins.vpcf", PATTACH_CUSTOMORIGIN, caster)		
			ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex, 1, v:GetOrigin())
			ParticleManager:DestroyParticleSystem(effectIndex,false)
		--	target:EmitSound("Nazrin04_4")				
	
			v:ModifyGold(totalgoldget, false, 0)
			v:RemoveModifierByName("modifier_nazrin04_check")			
		end
	
	end

end

function OnNazrin04deatheffect ( keys )
	local ability = keys.ability
	--local target = ability:GetParent()
	local target = keys.Target
	local caster = keys.caster
	if target:GetHealth() == 0 then
	
		local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_tnt_rain_coins.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
--		ParticleManager:SetParticleControl(effectIndex, 1, Vector(300,0,0))
		
		ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)	
		target:EmitSound("Nazrin04_4")	
	
	
	end




end

function OnNazrin02spellstart ( keys )
	local caster = keys.caster
	
	local ability = keys.ability
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_nazrin_1"))

end

function OnNazrin02spelldamage ( keys )

	local caster = keys.caster
	
	local target = keys.target
	
	local Radius = keys.Radius
	
	local totaldealdamage = (keys.basedealdamage + caster:GetAgility()*keys.abilitymulti)*keys.intervals
	
	local targets = FindUnitsInRadius(
				   caster:GetTeam(),						--caster team
				   target:GetOrigin(),							--find position
				   nil,										--find entity
				   Radius,						--find radius
				   DOTA_UNIT_TARGET_TEAM_ENEMY,
				   DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
				   DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0,
				   false
			    )	
				
	for _,v in pairs(targets) do
		
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = totaldealdamage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}	
		UnitDamageTarget(damage_table)	

	
	end				



end
