

if AbilityMokou == nil then
	AbilityMokou = class({})
end



function OnMokou02damage(keys)
	local caster = keys.caster
	
	local mokouheal = keys.Mokouheal
	
	local targets = keys.target_entities	
	local missingheal = keys.healpermsissing
	
	local totalheal = mokouheal + (((caster:GetMaxHealth()-caster:GetHealth())* missingheal)/100)
	
	--caster:Heal(totalheal,caster) 
	--SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,caster,totalheal,nil)

	local Ability = keys.ability	
	local mokoustack = caster:FindModifierByName("modifier_mokou02_charge_count")
    local mokouattackcount = mokoustack:GetStackCount()
	local vecCaster = caster:GetOrigin()	
	local strmulti = keys.damagemultiply
	
	if(caster.ability_Mokou02_damage_bouns==nil)then
		caster.ability_Mokou02_damage_bouns = 0
	end	
	
	if mokouattackcount <(keys.Maxattacks) then	
	
        caster:SetModifierStackCount("modifier_mokou02_charge_count", caster, mokouattackcount + 1)
		
	end

	if mokouattackcount == (keys.Maxattacks) then
	
	local missingheal = keys.healpermsissing

	local totalheal = mokouheal + (((caster:GetMaxHealth()-caster:GetHealth())* missingheal)/100)

	THDHealTarget(caster,caster,totalheal)
	
	
	for _,v in pairs(targets) do
	
		local deal_damage = keys.Bounsdamage + caster:GetStrength()*keys.damagemultiply + caster.ability_Mokou02_damage_bouns
	
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = deal_damage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)
		local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/mouko/ability_mokou_02_boom.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, Vector(300,0,0))
		ParticleManager:DestroyParticleSystem(effectIndex,false)


		end	
    caster:SetModifierStackCount("modifier_mokou02_charge_count", caster, 1)
    caster:EmitSound("Hero_OgreMagi.Fireblast.Target")	
	end	
	
end

function OnMokou02FirstStack(keys)
	local caster = keys.caster
	local ability = keys.ability
	caster:SetModifierStackCount("modifier_mokou02_charge_count",ability,1)

end


function OnMokou02heal(keys)

	local caster = keys.caster
	
	local mokouheal = keys.Mokouheal
	
	local target = keys.target	
	local missingheal = keys.healpermsissing
	
	local totalheal = mokouheal + (((caster:GetMaxHealth()-caster:GetHealth())* missingheal)/100)
	
	if target:GetClassname()~= "npc_dota_roshan" or target:IsBuilding() == false then
	
--	caster:Heal(totalheal,caster) 
--	SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,caster,totalheal,nil)
	
	THDHealTarget(caster,caster,totalheal)

	
	end
	

end


function OnMokou02atkspeedbuffcount (params)
	local caster = params.caster
	local mokou_stack = caster:FindModifierByName("modifier_mokou02_speed_up")
	local ability = params.ability
	local maxsbuffs = params.Maxbuffs
	local duration = params.Duration

  
	if mokou_stack==nil then 
    
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_mokou02_speed_up",nil)
		caster:SetModifierStackCount("modifier_mokou02_speed_up",ability,1)
		else 
		
		if mokou_stack:GetStackCount() < maxsbuffs then 
			mokou_stack:IncrementStackCount()		
		end
		mokou_stack:SetDuration(duration, true)		
	end
	if 	caster.lastattacktarget == nil then
		caster.lastattacktarget = params.target
	end
	if caster.lastattacktarget ~= nil then	
		if caster.lastattacktarget ~= params.target then
			if mokou_stack~=nil then 	
			
			
				local stacktoset = math.floor(mokou_stack:GetStackCount()/2)	
				caster:SetModifierStackCount("modifier_mokou02_speed_up",ability,stacktoset)
				caster.lastattacktarget = params.target						
			end		
		end
	
	end
	
	
end


function mokou03applydamage (keys)
	local caster = keys.caster
	local ability = keys.ability 
	local attackspeedmulti = keys.attackspeedmulti
	local strmulti = keys.strmulti
	local dealdamage = ability:GetAbilityDamage() + ((caster:GetIncreasedAttackSpeed()*100)*attackspeedmulti/100)+(caster:GetStrength()*strmulti) 
	local target = keys.target 

		
	local ability2 =	caster:FindAbilityByName("ability_thdots_mokou02x")	

	if is_spell_blocked(keys.target) then return end
	
	
	if   ability2 ~= nil then 
		
		local mokou_stack = caster:FindModifierByName("modifier_mokou02_speed_up")
		
		if mokou_stack==nil then 
		
		ability2:ApplyDataDrivenModifier(caster, caster, "modifier_mokou02_speed_up",nil)
	  
		caster:SetModifierStackCount("modifier_mokou02_speed_up", ability2,2)
	  
		else 	

		caster:SetModifierStackCount("modifier_mokou02_speed_up", ability2,caster:GetModifierStackCount("modifier_mokou02_speed_up", caster)+2)	

		local ability2_level = ability2:GetLevel() - 1
		local checkmaxbuffs = ability2:GetLevelSpecialValueFor("max_buffs",ability2_level)
		
		if caster:GetModifierStackCount("modifier_mokou02_speed_up", caster) > checkmaxbuffs then
	  
		caster:SetModifierStackCount("modifier_mokou02_speed_up", ability2,checkmaxbuffs)
	  
		end

	  
		local mokou02duration = mokou_stack:GetDuration()
		mokou_stack:SetDuration(mokou02duration, true)
	  
	  
		end 
  
	end	
		local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/mouko/ability_mokou_02_boom.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, Vector(300,0,0))
		ParticleManager:DestroyParticleSystem(effectIndex,false)
		
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target,dealdamage, nil) 	
		local damage_table = {
				ability = keys.ability,
			    victim = target,
			    attacker = caster,
			    damage = dealdamage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)




		local damage_table = {
				ability = keys.ability,
			    victim = caster,
			    attacker = caster,
			    damage = (dealdamage)/2,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)			
		
		caster:EmitSound("Hero_OgreMagi.Fireblast.Target")
		
	
end