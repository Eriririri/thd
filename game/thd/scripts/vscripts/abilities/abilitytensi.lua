if AbilityTensi == nil then
	AbilityTensi = class({})
end

function OnTensi02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local ability = caster:FindAbilityByName("ability_thdots_tensi02")
	if(keys.ability:GetContext("ability_tensi_02_reset")==nil)then
		keys.ability:SetContextNum("ability_tensi_02_reset",TRUE,0)
	end
	if(keys.ability:GetContext("ability_tensi_02_reset")==TRUE)then
		keys.ability:SetContextNum("ability_tensi_02_reset",FALSE,0)
		local resetTime = keys.AbilityMulti/(caster:GetPrimaryStatValue())
		Timer.Wait 'ability_tensi_02_reset_timer' (resetTime,
			function()
				keys.ability:SetContextNum("ability_tensi_02_reset",TRUE,0)
			end
		)
	else
		return
	end
	local telentdamage = FindTalentValue(caster,"special_bonus_unique_earthshaker") * caster:GetStrength()
	local vecCaster = caster:GetOrigin()
	local targets = keys.target_entities
	for _,v in pairs(targets) do
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = keys.BounsDamage + telentdamage +(caster:GetStrength()*1),
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)
		UtilStun:UnitStunTarget(caster,v,keys.Duration)	
	keys.ability:ApplyDataDrivenModifier(caster, caster, "ability_tensi_02_timer", {duration = 360/caster:GetStrength()})	
	ability:StartCooldown(360/caster:GetStrength())	
	end
	if (targets[1] == nil) then
		return
	end
	local effectIndex = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_low_egset.vpcf", PATTACH_CUSTOMORIGIN, caster)
	
	ParticleManager:SetParticleControl(effectIndex, 0, targets[1]:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, targets[1]:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
	local effectIndex2 = ParticleManager:CreateParticle("particles/newthd/tenshi/fire/tenshi_fire.vpcf", PATTACH_WORLDORIGIN, caster)	
	ParticleManager:SetParticleControl(effectIndex2, 0, targets[1]:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex2, 1, targets[1]:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex2,false)
	targets[1]:EmitSound("Hero_EarthShaker.Totem.Attack")
end

function OnTensi03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if
	  caster:GetHealth() > caster:GetMaxHealth()*0.01
	  then
	--caster:SetHealth(caster:GetHealth()+keys.BounsHealth+FindTalentValue(caster,"special_bonus_unique_earthshaker_3")+FindTalentValue(caster,"special_bonus_unique_tenshi_2"))

	  local totalheal = keys.BounsHealth+FindTalentValue(caster,"special_bonus_unique_tenshi_3")+FindTalentValue(caster,"special_bonus_unique_tenshi_2")
--	caster:Heal(keys.BounsHealth+FindTalentValue(caster,"special_bonus_unique_tenshi_3")+FindTalentValue(caster,"special_bonus_unique_tenshi_2"),caster)
	
	THDHealTarget2(caster,caster,totalheal)	
	
	caster:GiveMana(keys.BounsMana+FindTalentValue(caster,"special_bonus_unique_tenshi_3")+FindTalentValue(caster,"special_bonus_unique_tenshi_2"))
	
	
	--caster:SetMana(caster:GetMana()+keys.BounsMana+FindTalentValue(caster,"special_bonus_unique_earthshaker_3")+FindTalentValue(caster,"special_bonus_unique_tenshi_2"))
	end
end



function OnTensi042SpellStart(keys)
	local caster = keys.caster
	
	local target = keys.target
	local ability = keys.ability
	caster:EmitSound("Voice_Thdots_Tenshi.AbilityTenshi042EX_"..math.random(1,3))
	--ApplyDamage({victim = target, attacker = caster, damage = (caster:GetStrength()*1) +  ability:GetAbilityDamage(), damage_type = DAMAGE_TYPE_PURE})
	--ApplyDamage({victim = target, attacker = caster, damage = (caster:GetStrength()*1) +  ability:GetAbilityDamage(), damage_type = DAMAGE_TYPE_PURE})
	local dealdamage = (caster:GetStrength()*1) +  ability:GetAbilityDamage()
		local damage_table = {
				ability = keys.ability,
			    victim = target,
			    attacker = caster,
			    damage = dealdamage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}	
		UnitDamageTarget(damage_table)	
end

function talent(keys)
local castertalent = EntIndexToHScript(keys.caster_entindex)
THDReduceCooldown(keys.ability,-FindTalentValue(castertalent,"special_bonus_unique_earthshaker_2"))
end

function TenshiEX1(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local Caster=keys.caster
	local level = keys.ability:GetLevel()
    local ability = Caster:FindAbilityByName("tenshi042")
		ability:SetLevel(level)
		
		
	
end