function OnUtsuho01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	THDReduceCooldown(keys.ability,FindTalentValue(caster,"special_bonus_unique_sniper_2"))
	if is_spell_blocked(keys.target) then return end
	local vecCaster = caster:GetOrigin()
	local target = keys.target
	local dealdamage = keys.ability:GetAbilityDamage()

	local damage_target = {
		victim = keys.target,
		attacker = caster,
		damage = dealdamage+(caster:GetStrength()*1)+(caster:GetIntellect()*1)+FindTalentValue(caster,"special_bonus_unique_sniper_3"),
		damage_type = keys.ability:GetAbilityDamageType(), 
	    damage_flags = 0
	}
	UnitDamageTarget(damage_target)
	
	keys.ability:ApplyDataDrivenModifier(caster,target,keys.DebuffName,{})
end

function OnUtsuho01FireDamage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targets = keys.target_entities
	for _,v in pairs(targets) do
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = keys.AbilityDamage+(caster:GetStrength()*0.3)+(caster:GetIntellect()*0.7)/2 + FindTalentValue(caster,"special_bonus_unique_sniper_1"),
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)
	end
end

function OnUtsuho02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targets = keys.target_entities
	for _,v in pairs(targets) do
		local damage_table = {
			    victim = v,
			    attacker = caster,
			    damage = keys.AbilityDamage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)
	end
end

function OnUtsuho03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targets = keys.target_entities
	for _,v in pairs(targets) do
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = keys.AbilityDamage+(caster:GetStrength()*3)+(caster:GetIntellect()*2),
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)
	end
end

function OnUtsuho04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	keys.ability.ability_utsuho04_point_x = targetPoint.x
	keys.ability.ability_utsuho04_point_y = targetPoint.y
	keys.ability.ability_utsuho04_point_z = targetPoint.z
	keys.ability.ability_utsuho04_timer_count = 0
	local dummy = CreateUnitByName("npc_dummy_unit", 
	    	                        targetPoint, 
									false, 
								    caster, 
									caster, 
									caster:GetTeamNumber()
									)
	caster.ability_utsuho_04_dummy = dummy
	dummy:SetContextThink("ability_utsuho04_effect_release",
		function ()
			if GameRules:IsGamePaused() then return 0.03 end
			dummy:RemoveSelf() 
		end,
	7.5)
	local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/utsuho/ability_utsuho04_effect.vpcf", PATTACH_CUSTOMORIGIN, dummy)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:SetParticleControl(effectIndex, 1, targetPoint)
	ParticleManager:SetParticleControl(effectIndex, 3, targetPoint)
	keys.ability.ability_utsuho04_effect_index = effectIndex
end

function OnUtsuho04SpellThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local tx = keys.ability.ability_utsuho04_point_x
	local ty = keys.ability.ability_utsuho04_point_y
	local tz = keys.ability.ability_utsuho04_point_z
	local targetPoint = Vector(tx,ty,tz)
	local targets = FindUnitsInRadius(
		   caster:GetTeam(),		--caster team
		   targetPoint,				--find position
		   nil,						--find entity
		   keys.Radius,				--find radius
		   DOTA_UNIT_TARGET_TEAM_ENEMY,
		   keys.ability:GetAbilityTargetType(),
		   0, FIND_CLOSEST,
		   false
	)
	
	local count = keys.ability.ability_utsuho04_timer_count
	keys.ability.ability_utsuho04_timer_count = count+0.1

	for _,v in pairs(targets) do
		local dis = GetDistanceBetweenTwoVec2D(targetPoint,v:GetOrigin())
		if(dis<keys.DamageRadius and (v:GetClassname()~="npc_dota_roshan"))then
			local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = keys.Damage/10+(caster:GetStrength()*3)/10+(caster:GetIntellect()*3)/10,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
			}
			UnitDamageTarget(damage_table)
		end
		local rad = GetRadBetweenTwoVec2D(targetPoint,v:GetOrigin())
		if(dis>=(keys.Gravity/10))then
			v:SetOrigin(v:GetOrigin() - keys.Gravity/10 * Vector(math.cos(rad),math.sin(rad),0))
			SetTargetToTraversable(v)
		end
	end
end


function OnUtsuho04SpellRemove(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = keys.target_entities
	local count = keys.ability.ability_utsuho04_timer_count
	local effectIndex = keys.ability.ability_utsuho04_effect_index 
	local tx = keys.ability.ability_utsuho04_point_x
	local ty = keys.ability.ability_utsuho04_point_y
	local tz = keys.ability.ability_utsuho04_point_z
	local targetPoint = Vector(tx,ty,tz)
	ParticleManager:DestroyParticleSystem(effectIndex,true)
	if(caster.ability_utsuho_04_dummy~=nil)then
		effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/utsuho/ability_utsuho04_end.vpcf", PATTACH_CUSTOMORIGIN, caster.ability_utsuho_04_dummy)
	else
		effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/utsuho/ability_utsuho04_end.vpcf", PATTACH_CUSTOMORIGIN, caster)
	end

	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:SetParticleControl(effectIndex, 1, targetPoint)
	ParticleManager:SetParticleControl(effectIndex, 3, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)
	caster.ability_utsuho_04_dummy:SetContextThink("ability_utsuho04_effect_remove",
		function ()
			if GameRules:IsGamePaused() then return 0.03 end
			caster.ability_utsuho_04_dummy:RemoveSelf() 
		end,
	1.0)
	for _,v in pairs(targets) do
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = keys.ability:GetAbilityDamage() * (count/6.5),
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)
		SetTargetToTraversable(v)
	end
end