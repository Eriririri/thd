function OnByakuren01SpellStart(keys)
	if is_spell_blocked(keys.target) then return end
	
	
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targets = keys.target_entities
	local dealdamage = keys.ability:GetAbilityDamage() - keys.AOEDamage
	local damage_target = {
		victim = keys.target,
		attacker = caster,
		damage = dealdamage,
		damage_type = keys.ability:GetAbilityDamageType(), 
	    damage_flags = 0
	}
	UnitDamageTarget(damage_target)
	for _,v in pairs(targets) do
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = keys.AOEDamage + FindTalentValue(caster,"special_bonus_unique_arc_warden")+(caster:GetIntellect()*1),
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)
		UtilStun:UnitStunTarget(caster,v,keys.StunDuration)
	end
	local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, keys.target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 5, keys.target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnByakuren02SpellStart(keys)
	if is_spell_blocked(keys.target) then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local manaCost = keys.ManaCost * caster:GetMaxMana()
	if(manaCost>caster:GetMana())then
		keys.ability:EndCooldown()
		return
	end
	
	caster:SetMana(caster:GetMana()-manaCost)
	local vecCaster = caster:GetOrigin()
	local target = keys.target
	local dealdamage = keys.AbilityMulti*manaCost
	local damage_target = {
		victim = keys.target,
		attacker = caster,
		damage = dealdamage,
		damage_type = keys.ability:GetAbilityDamageType(), 
	    damage_flags = 0
	}
	UnitDamageTarget(damage_target)
	
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/byakuren/ability_byakuren_02.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 2, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
	ParticleManager:ReleaseParticleIndex(effectIndex)
end

function OnByakuren03SpellStart(keys)
	if keys.caster:GetTeam()~=keys.target:GetTeam() and is_spell_blocked(keys.target) then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local target = keys.target
	local vecTarget = target:GetOrigin()
	
	if(target:GetTeam()==caster:GetTeam())then
		local vecMove = vecCaster + caster:GetForwardVector() * 60
		target:SetOrigin(vecMove)
		local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_pulse_nova_h.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, vecTarget)
		ParticleManager:SetParticleControl(effectIndex, 1, vecTarget)
		ParticleManager:SetParticleControl(effectIndex, 2, vecTarget)
		ParticleManager:DestroyParticleSystem(effectIndex,false)
		ParticleManager:ReleaseParticleIndex(effectIndex)
		SetTargetToTraversable(target)
		target:EmitSound("Hero_Weaver.TimeLapse")
	else
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/byakuren/ability_byakuren_03.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, vecTarget)
		target:SetThink(
				function()
					target:SetOrigin(vecTarget)
					target:EmitSound("Hero_Weaver.TimeLapse")
					SetTargetToTraversable(target)
					ParticleManager:DestroyParticleSystem(effectIndex,true)
					return nil
				end, 
		"ability_byakuren_03_return",
		3.0)
	end
end

function OnByakuren04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targets = keys.target_entities
	local dealdamage = keys.ability:GetAbilityDamage() + keys.AbilityMulti * ( caster:GetMaxHealth() - caster:GetHealth())
	local damage_target = {
		ability = keys.ability,
		victim = keys.target,
		attacker = caster,
		damage = dealdamage/2,
		damage_type = keys.ability:GetAbilityDamageType(), 
	    damage_flags = 0
	}
	UnitDamageTarget(damage_target)
	
	
	
	for _,v in pairs(targets) do
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = dealdamage/2,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/byakuren/ability_byakuren_04_attack.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)
		UnitDamageTarget(damage_table)
	end
	caster:SetHealth(caster:GetHealth()+dealdamage)
end

function OnByakuren04SpellThinkStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	
	if(caster.ability_byakuren04_health_old==nil)then
		caster.ability_byakuren04_health_old = 0
		--local effectIndex = ParticleManager:CreateParticle("particles/heroes/byakuren/ability_byakuren_04.vpcf", PATTACH_CUSTOMORIGIN, caster)
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/byakuren/ability_byakuren_04_circle.vpcf", PATTACH_CUSTOMORIGIN, caster)
		caster.effectIndex = effectIndex
		caster.isReborn = true
		ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
		--ParticleManager:SetParticleControlEnt(effectIndex , 1, caster, 5, "follow_origin", Vector(0,0,0), true)
		caster:SetContextThink("ability_byakuren04_think", 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			OnByakuren04SpellThink(keys)
			return 0.05
		end, 
		0.05)
	end
end


function OnByakuren04SpellThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local ability = keys.ability
	local increaseHealth = caster:GetMaxMana() * keys.BounsHealth * ability:GetLevel()
	local effectIndex
	caster:SetModifierStackCount("passive_byakuren04_bonus_health", ability, increaseHealth)
	if(caster:GetHealth()<1 and caster.isReborn == true)then
		print("destory!")
		ParticleManager:DestroyParticleSystem(caster.effectIndex,true)
		caster.isReborn = false
	else
		if(caster:GetHealth()>=1 and caster.isReborn == false)then
			print("restart!")
			--effectIndex = ParticleManager:CreateParticle("particles/heroes/byakuren/ability_byakuren_04.vpcf", PATTACH_CUSTOMORIGIN, caster)
			effectIndex = ParticleManager:CreateParticle("particles/heroes/byakuren/ability_byakuren_04_circle.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
			--ParticleManager:SetParticleControlEnt(effectIndex , 1, caster, 5, "follow_origin", Vector(0,0,0), true)
			caster.effectIndex = effectIndex
			caster.isReborn = true
		end
	end
	--ParticleManager:SetParticleControlEnt(caster.effectIndex , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
	--ParticleManager:SetParticleControlEnt(caster.effectIndex , 1, caster, 5, "follow_origin", Vector(0,0,0), true)
end
function Blink(keys)
    local point = keys.target_points[1]
	local caster = keys.caster
	local castertalent = EntIndexToHScript(keys.caster_entindex)
	local casterPos = caster:GetAbsOrigin()
	local pid = caster:GetPlayerID()
	local difference = point - casterPos
	local ability = keys.ability
	local range = keys.Range
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, keys.caster)

	if difference:Length2D() > range then
		point = casterPos + (point - casterPos):Normalized() * range
	end

	FindClearSpaceForUnit(caster, point, false)
	ProjectileManager:ProjectileDodge(caster)
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, keys.caster)
	THDReduceCooldown(keys.ability,-FindTalentValue(castertalent,"special_bonus_unique_dark_seer"))
	
	
end
function MaxSpeed(keys)
local caster = keys.caster
local ability = keys.ability
caster:AddNewModifier(caster, ability, "modifier_movespeed_cap",  { Duration = keys.duration} )
end