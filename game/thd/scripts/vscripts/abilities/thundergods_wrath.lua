function ThundergodsWrath(keys)
	local caster = keys.caster
	
	local target = keys.target
	local ability = keys.ability
	local sight_radius = ability:GetLevelSpecialValueFor("sight_radius", (ability:GetLevel() -1))
	local sight_duration = ability:GetLevelSpecialValueFor("sight_duration", (ability:GetLevel() -1))
	--local tenshiultimatedamage = ability:GetAbilityDamage()+(caster:GetStrength()*0)
	
	-- If the target is not invisible, we deal damage to it
	
    --ApplyDamage({victim = target, attacker = caster, damage = ability:GetAbilityDamage()+(caster:GetStrength()*1), damage_type = ability:GetAbilityDamageType()})
	
	

	
	-- Gives the caster's team vision around the target
	AddFOWViewer(caster:GetTeam(), target:GetAbsOrigin(), sight_radius, sight_duration, false)
	-- Renders the particle on the target
--	local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, target)
	-- Raise 1000 if you increase the camera height above 1000
--	ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
--	ParticleManager:SetParticleControl(particle, 1, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,1000 ))
--	ParticleManager:SetParticleControl(particle, 2, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	-- Plays the sound on the target
	EmitSoundOn(keys.sound, target)
	
	

	--local particle2 = ParticleManager:CreateParticle(keys.particle, PATTACH_ABSORIGIN_FOLLOW, caster)		
	--local particle2 = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_bolt_parent.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		--ParticleManager:SetParticleControl(particle2, 0, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z))		
		--ParticleManager:SetParticleControl(particle2, 1, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z)) 	
		--ParticleManager:SetParticleControl(particle2, 2, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z)) 	

end

function Tenshi04spelleffect(keys)
	local caster = keys.caster

--local particle2 = ParticleManager:CreateParticle(keys.particle, PATTACH_ABSORIGIN_FOLLOW, caster)		
	local particle2 = ParticleManager:CreateParticle("particles/newthd/tenshi/04test/zeus_arcana_thundergods_wrath_start_bolt_parent.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle2, 0, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z))		
		ParticleManager:SetParticleControl(particle2, 1, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z)) 	
		ParticleManager:SetParticleControl(particle2, 2, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z)) 	

	local particle7 = ParticleManager:CreateParticle("particles/econ/items/lina/lina_ti6/lina_ti6_laguna_blade_startpoint_arcs.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle7, 0, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z))		
		ParticleManager:SetParticleControl(particle7, 1, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z)) 	
		ParticleManager:SetParticleControl(particle7, 2, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z))		
		
		local effectIndex2 = ParticleManager:CreateParticle("particles/newthd/tenshi/fire/tenshi_fire.vpcf", PATTACH_WORLDORIGIN, caster)	
		ParticleManager:SetParticleControl(effectIndex2, 0, caster:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex2, 1, caster:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex2,false)	

	local effectIndex = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_low_egset.vpcf", PATTACH_CUSTOMORIGIN, caster)
	
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, caster:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
		
		
end


function Tenshi04spellprecasteffect(keys)
	local caster = keys.caster

--local particle2 = ParticleManager:CreateParticle(keys.particle, PATTACH_ABSORIGIN_FOLLOW, caster)		
	local particle2 = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle2, 0, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z))		
		ParticleManager:SetParticleControl(particle2, 1, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z+75)) 	
		ParticleManager:SetParticleControl(particle2, 2, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z)) 	
	local particle3 = ParticleManager:CreateParticle("particles/newthd/tenshi/04/tenshiultimate.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle3, 0, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z))		
		ParticleManager:SetParticleControl(particle3, 1, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z)) 	
		ParticleManager:SetParticleControl(particle3, 2, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z)) 

end

function talent(keys)
local castertalent = EntIndexToHScript(keys.caster_entindex)
THDReduceCooldown(keys.ability,-FindTalentValue(castertalent,"special_bonus_unique_earthshaker_2"))
end


function Tenshi04voice(event)
	local caster = event.caster
	
	--if FindTalentValue(caster,"special_bonus_unique_sakuya_1")~=0 then	
	EmitGlobalSound("Hero_Zuus.GodsWrath")
	EmitGlobalSound("Voice_Thdots_Tenshi.AbilityTenshi04EX")	
	
	--end
end


function OnTenshi04SpellStart (keys)
	local caster = keys.caster
	local ability = keys.ability

	local targets = FindUnitsInRadius(
				   caster:GetTeam(),						--caster team
				   caster:GetOrigin(),							--find position
				   nil,										--find entity
				   FIND_UNITS_EVERYWHERE,						--find radius
				   DOTA_UNIT_TARGET_TEAM_ENEMY,
				   DOTA_UNIT_TARGET_HERO,
				   DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0,
				   false
			    )
				
	for _,v in pairs(targets) do

		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_thundergods", nil)
		
		local tenshiultimatedamage = ability:GetAbilityDamage()+(caster:GetStrength()*0)		
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = tenshiultimatedamage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		
		local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, v)
		-- Raise 1000 if you increase the camera height above 1000
		ParticleManager:SetParticleControl(particle, 0, Vector(v:GetAbsOrigin().x,v:GetAbsOrigin().y,v:GetAbsOrigin().z + v:GetBoundingMaxs().z ))
		ParticleManager:SetParticleControl(particle, 1, Vector(v:GetAbsOrigin().x,v:GetAbsOrigin().y,1000 ))
		ParticleManager:SetParticleControl(particle, 2, Vector(v:GetAbsOrigin().x,v:GetAbsOrigin().y,v:GetAbsOrigin().z + v:GetBoundingMaxs().z ))		
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, v, tenshiultimatedamage, nil)			
					
		local effectIndex2 = ParticleManager:CreateParticle("particles/newthd/tenshi/fire/tenshi_fire.vpcf", PATTACH_WORLDORIGIN, caster)	
		ParticleManager:SetParticleControl(effectIndex2, 0, v:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex2, 1, v:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex2,false)
		
		local effectIndex = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_low_egset.vpcf", PATTACH_CUSTOMORIGIN, caster)
	
		ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, v:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)
				
		
		UnitDamageTarget(damage_table)	
		

	end	



end