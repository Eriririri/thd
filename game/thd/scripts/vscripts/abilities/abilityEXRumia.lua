


        


function OnExrumia01damage(keys)

	local caster = keys.caster

	local target = keys.target
	local ability = keys.ability
	
	if is_spell_blocked(keys.target) then return end	
	
	
	local victim_angle = target:GetAnglesAsVector()
	local victim_forward_vector = target:GetForwardVector()
	
	-- Angle and positioning variables
	local victim_angle_rad = victim_angle.y*math.pi/180
	local victim_position = target:GetAbsOrigin()
	local attacker_new = Vector(victim_position.x - 100 * math.cos(victim_angle_rad), victim_position.y - 100 * math.sin(victim_angle_rad), 0)	
	
	caster:SetAbsOrigin(attacker_new)
	FindClearSpaceForUnit(caster, attacker_new, true)
	caster:SetForwardVector(victim_forward_vector)
	--caster:SetAttacking(target)	
	keys.ability:ApplyDataDrivenModifier( caster,keys.target, "modifier_EXrumia01_slow", {} )	
	

		local damage_table = {
				ability = keys.ability,
			    victim = target,
			    attacker = caster,
			    damage = ability:GetAbilityDamage()+ (caster:GetAgility()*1),
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)


end

function OnEXRumia03Think(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local ability = keys.ability

	if caster:IsAlive() then

		if GameRules:IsDaytime()==false then
		
		if caster:HasModifier("modifier_EXrumia_03_night") == false then
		
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_EXrumia_03_night", {})
		
		end
		
		end

		if GameRules:IsDaytime()==true then
		
			if caster:HasModifier("modifier_EXrumia_03_night") == true	then
				caster:RemoveModifierByName("modifier_EXrumia_03_night")			
			end		
		
		
		
		end

		

	end
end

function OnEXrumia04attacklanded(event)

	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local basechance = event.Basechance
	
	
	local targetmaxhp = target:GetMaxHealth() 
	
	local targethp = target:GetHealth()
	
	local missinghp = targetmaxhp - targethp
	
	local chance = ((missinghp*100)/targetmaxhp)*basechance
	
	if target:IsBuilding() == false then	
	if (missinghp*100)/targetmaxhp > 0 then	
		
		if RollPercentage(chance) then
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target,99999, nil)	
		target:Kill(ability, caster)		
		--caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
		--Timers:CreateTimer(0.34, function() 
			--	caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_4)
		--end)	
		if target:IsRealHero()==true then
		EmitGlobalSound("thd_maim")
		end
		end
		--end
	end
	
	
	if (missinghp*100)/targetmaxhp == 0 then	
		
		if RollPercentage(basechance) then
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target,99999, nil)
		target:Kill(ability, caster)		
		--caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
		--Timers:CreateTimer(0.34, function() 
		--		caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_4)
		--end)		
		if target:IsRealHero()==true then
		EmitGlobalSound("abilityrumia04success")
		end		
		end
		--end
	end	
		
	end
	
end


function OnRumia01SpellEffectStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local unit = CreateUnitByName(
		"npc_dummy_unit"
		,caster:GetOrigin()
		,false
		,caster
		,caster
		,caster:GetTeam()
	)
	local ability_dummy_unit = unit:FindAbilityByName("ability_dummy_unit")
	ability_dummy_unit:SetLevel(1)
	
	local nEffectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/rumia/ability_rumia01_effect.vpcf",PATTACH_CUSTOMORIGIN,unit)
	ParticleManager:SetParticleControl( nEffectIndex, 0, caster:GetOrigin())
	ParticleManager:SetParticleControl( nEffectIndex, 1, caster:GetOrigin())
	keys.ability:SetContextNum("ability_rumia01_effect",nEffectIndex,0)
	caster.ability_rumia_01_unit = unit
	unit:SetContextThink("ability_rumia01_effect_timer", 
		function ()
			if GameRules:IsGamePaused() then return 0.03 end
			unit:RemoveSelf()
			return nil
		end, 
		keys.Duration+0.1)
end

function OnRumia01SpellEffectThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local nEffectIndex = keys.ability:GetContext("ability_rumia01_effect")
	ParticleManager:SetParticleControl( nEffectIndex, 0, caster:GetOrigin())
	ParticleManager:SetParticleControl( nEffectIndex, 1, caster:GetOrigin())
	if caster.ability_rumia_01_unit~=nil and caster.ability_rumia_01_unit:IsNull() == false then
		caster.ability_rumia_01_unit:SetOrigin(caster:GetOrigin())
	end
	
	local healamountx = keys.healamount
	local EXRumiaheal = ((caster:GetMaxHealth()*healamountx)/100)*0.1
	caster:Heal(EXRumiaheal,caster)
	
end

function exrumiainnate(keys)

	local caster=keys.caster
	local ability = keys.ability
    caster:SetModifierStackCount("exrumia_innate_stat", ability, caster:GetLevel())	

end

function exrumiainnatesound(keys)

	local caster=keys.caster
	local ability = keys.ability
    caster:EmitSound("exrumiaattacksound")

end



function exrumiaillusionadjust(keys)

	local caster = keys.caster
	Timers:CreateTimer(0.3, function()
	if caster:IsRealHero() == false then
	
		caster:SetModel("models/thd2/rumia_ex/rumia_ex.vmdl")
		caster:SetOriginalModel("models/thd2/rumia_ex/rumia_ex.vmdl")

	end				
	end)

end