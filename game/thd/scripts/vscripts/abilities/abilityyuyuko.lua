if AbilityYuyuko == nil then
	AbilityYuyuko = class({})
end

function OnYuyuko04PhaseStart(keys)
end

function OnYuyuko04SpellStart(keys)
    local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_necrophos_4"))
	--AddFOWViewer(2, caster:GetAbsOrigin(), 300, 0.3, false)
	--AddFOWViewer(3, caster:GetAbsOrigin(), 300, 0.3, false)		
	
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local vecForward = caster:GetForwardVector() 
	local unit = CreateUnitByName(
		"npc_dota2x_unit_yuyuko_04"
		,caster:GetOrigin() - vecForward * 100
		,false
		,caster
		,caster
		,caster:GetTeam()
	)
	local ability_dummy_unit = unit:FindAbilityByName("ability_dummy_unit")
	ability_dummy_unit:SetLevel(1)
	
	unit:StartGesture(ACT_DOTA_IDLE)
	local forwardRad = GetRadBetweenTwoVec2D(caster:GetOrigin(),unit:GetOrigin())
	unit:SetForwardVector(Vector(math.cos(forwardRad+math.pi/2),math.sin(forwardRad+math.pi/2),0))

	local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/yuyuko/ability_yuyuko_04_effect_d.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex2, 0, caster:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex2,false)

	unit:SetContextThink("ability_yuyuko_04_unit_remove", 
		function () 
			if GameRules:IsGamePaused() then return 0.03 end
			unit:RemoveSelf()
			return nil
		end, 
		2.0)

	keys.ability:SetContextNum("ability_yuyuko_04_time_count", keys.DamageCount, 0) 
	
		caster.selfAuraBorderFxx = ParticleManager:CreateParticleForTeam("particles/heroes/thtd_yuyuko/ability_yuyuko_04.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster, 2)
        ParticleManager:SetParticleControl(caster.selfAuraBorderFxx, 0, Vector(keys.Radius,0,0))
        ParticleManager:SetParticleControl(caster.selfAuraBorderFxx, 1, Vector(keys.Radius,0,0))				
		caster.selfAuraBorderFxxx = ParticleManager:CreateParticleForTeam("particles/heroes/thtd_yuyuko/ability_yuyuko_04.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster, 3)
        ParticleManager:SetParticleControl(caster.selfAuraBorderFxxx, 0, Vector(keys.Radius,0,0))
        ParticleManager:SetParticleControl(caster.selfAuraBorderFxxx, 1, Vector(keys.Radius,0,0))


		
		local aimeffect = 650
		caster.selfAuraBorderFx = ParticleManager:CreateParticleForTeam("particles/newthd/ring/jtr_invis_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster, 2)
        ParticleManager:SetParticleControl(caster.selfAuraBorderFx, 0, Vector(aimeffect,0,0))
        ParticleManager:SetParticleControl(caster.selfAuraBorderFx, 1, Vector(aimeffect,0,0))
		
		caster.selfAuraBorderFx2 = ParticleManager:CreateParticleForTeam("particles/newthd/ring/jtr_invis_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster, 3)
        ParticleManager:SetParticleControl(caster.selfAuraBorderFx2, 0, Vector(aimeffect,0,0))
        ParticleManager:SetParticleControl(caster.selfAuraBorderFx2, 1, Vector(aimeffect,0,0))		
		

		Timers:CreateTimer(3, function() 
			ParticleManager:DestroyParticle(caster.selfAuraBorderFxx, false)
			
		end)		
		Timers:CreateTimer(3, function() 
			ParticleManager:DestroyParticle(caster.selfAuraBorderFxxx, false)
			
		end)
		Timers:CreateTimer(3, function() 
			ParticleManager:DestroyParticle(caster.selfAuraBorderFx, false)
			
		end)
		Timers:CreateTimer(3, function() 
			ParticleManager:DestroyParticle(caster.selfAuraBorderFx2, false)
			
		end)		
end

function OnYuyuko04SpellRemove(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	
end

function OnYuyuko04SpellThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = keys.target_entities

	local timecount = keys.ability:GetContext("ability_yuyuko_04_time_count")
	

	
	if(timecount>=0)then
		timecount = timecount - 0.5
		keys.ability:SetContextNum("ability_yuyuko_04_time_count", timecount, 0) 
		for _,v in pairs(targets) do    
			if((v:GetTeam()~=caster:GetTeam()) and (v:IsInvulnerable() == false) and (v:IsBuilding() == false) and (v:IsAlive() == true) and (v:GetClassname()~="npc_dota_roshan"))then
				local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/yuyuko/ability_yuyuko_04_effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
				ParticleManager:DestroyParticleSystem(effectIndex,false)

				effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/yuyuko/ability_yuyuko_04_effect_a.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
				ParticleManager:SetParticleControl(effectIndex, 5, v:GetOrigin())
				ParticleManager:DestroyParticleSystem(effectIndex,false)

				local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/yuyuko/ability_yuyuko_04_effect_d.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex2, 0, v:GetOrigin())
				ParticleManager:DestroyParticleSystem(effectIndex2,false)
				
				local selfAuraBorderFx2 = ParticleManager:CreateParticleForTeam("particles/heroes/yuyuko/ability_yuyuko_04_effect_d.vpcf", PATTACH_ABSORIGIN_FOLLOW, v, 2)
				ParticleManager:SetParticleControl(selfAuraBorderFx2, 0, v:GetOrigin())
				ParticleManager:SetParticleControl(selfAuraBorderFx2, 1, v:GetOrigin())	
				
				local selfAuraBorderFx = ParticleManager:CreateParticleForTeam("particles/heroes/yuyuko/ability_yuyuko_04_effect_d.vpcf", PATTACH_ABSORIGIN_FOLLOW, v, 3)
				ParticleManager:SetParticleControl(selfAuraBorderFx, 0, v:GetOrigin())
				ParticleManager:SetParticleControl(selfAuraBorderFx, 1, v:GetOrigin())	

				local selfAuraBorderFx3 = ParticleManager:CreateParticleForTeam("particles/thd2/heroes/yuyuko/ability_yuyuko_04_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, v, 2)
				ParticleManager:SetParticleControl(selfAuraBorderFx3, 0, v:GetOrigin())
				ParticleManager:SetParticleControl(selfAuraBorderFx3, 1, v:GetOrigin())	
				
				local selfAuraBorderFx4 = ParticleManager:CreateParticleForTeam("particles/thd2/heroes/yuyuko/ability_yuyuko_04_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, v, 3)
				ParticleManager:SetParticleControl(selfAuraBorderFx4, 0, v:GetOrigin())
				ParticleManager:SetParticleControl(selfAuraBorderFx4, 1, v:GetOrigin())					

			


				local vecV = v:GetOrigin()
				local deal_damage = (v:GetMaxHealth() - v:GetHealth())*keys.DamageMulti + (v:GetMaxHealth() - v:GetHealth())*FindTalentValue(caster,"special_bonus_unique_pugna_6")*keys.DamageMulti
				local boolDamage
				if((v:GetHealth()<=deal_damage) or (v:IsHero()==false))then
					boolDamage = true
				else
					boolDamage = false
				end

				if(v:IsHero()==false)then
					v:Kill(keys.ability,caster)
				else
					local damage_table = {
						ability = keys.ability,
						victim = v,
						attacker = caster,
						damage = deal_damage,
						damage_type = keys.ability:GetAbilityDamageType(), 
						damage_flags = 0
					}
					UnitDamageTarget(damage_table)
				end

				if(boolDamage)then
					local DamageTargets = FindUnitsInRadius(
					   caster:GetTeam(),		--caster team
					   vecV,					--find position
					   nil,						--find entity
					   keys.DamageRadius,		--find radius
					   DOTA_UNIT_TARGET_TEAM_ENEMY,
					   keys.ability:GetAbilityTargetType(),
					   0, FIND_CLOSEST,
					   false
				    )
					for _,v in pairs(DamageTargets) do
					    local damage_table_death = {
					    	ability = keys.ability,
							victim = v,
							attacker = caster,
							damage = keys.ability:GetAbilityDamage(),
							damage_type = keys.ability:GetAbilityDamageType(), 
							damage_flags = 0
						}
					    UnitDamageTarget(damage_table_death)
					end
				end

				

				return
			end
		end
	else
		caster:RemoveModifierByName("modifier_thdots_yuyuko04_think_interval") 
	end
end

function OnYuyuko01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	
	local target = keys.target
	local ability = keys.ability
	
	--ApplyDamage({victim = target, attacker = caster, damage = ability:GetAbilityDamage()+(caster:GetIntellect()*2.16), damage_type = DAMAGE_TYPE_MAGICAL})
				local leveltoscale = keys.intscale	 
				local damage_table = {
					ability = keys.ability,
					victim = target,
					attacker = caster,
					damage = ability:GetAbilityDamage()+(caster:GetIntellect()*leveltoscale)+FindTalentValue(caster,"special_bonus_unique_yuyuko_1"),
					damage_type = keys.ability:GetAbilityDamageType(), 
					damage_flags = keys.ability:GetAbilityTargetFlags()
				}
				
				UnitDamageTarget(damage_table)	

	
	 
end

function Yuyuko04voice(event)
	local caster = event.caster
	

	EmitGlobalSound("Voice_Thdots_Yuyuko.AbilityYuyuko04xx")

end
