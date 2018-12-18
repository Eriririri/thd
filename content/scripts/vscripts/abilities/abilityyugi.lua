if AbilityYugi == nil then
	AbilityYugi = class({})
end

function OnYugi03Damage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	if(target:IsBuilding())then
		return
	end

	local telentDamage = FindTalentValue(caster,"special_bonus_unique_centaur_1") * caster:GetStrength()

	local dealdamage = keys.BounsDamage + telentDamage
	local damage_table = {
			ability = keys.ability,
			victim = target,
			attacker = caster,
			damage = dealdamage,
			damage_type = keys.ability:GetAbilityDamageType(),
	    	damage_flags = 0
	}
	UnitDamageTarget(damage_table)
	UtilStun:UnitStunTarget( caster,target,1.0)
end

function OnYugi04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local vecTarget = target:GetOrigin()
	target:SetContextNum("ability_yugi04_point_x",vecTarget.x,0)
	target:SetContextNum("ability_yugi04_point_y",vecTarget.y,0)
end

function OnYugi04SpellThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	if(target:GetClassname()=="npc_dota_roshan")then
		return
	end
	local vecPoint = Vector(target:GetContext("ability_yugi04_point_x"),target:GetContext("ability_yugi04_point_y"),0)
	local dis = GetDistanceBetweenTwoVec2D(target:GetOrigin(),vecPoint)

	if(dis>keys.AbilityRadius)then
		--[[local damage_table = {
			victim = target,
			attacker = caster,
			damage = 99999,
			damage_type = keys.ability:GetAbilityDamageType(),
	    	damage_flags = DOTA_UNIT_TARGET_FLAG_INVULNERABLE
		}
		UnitDamageTarget(damage_table)]]--
		if(caster~=nil)then
			target:Kill(keys.ability, caster)
		else
			target:Kill(keys.ability, nil)
		end
		
		target:EmitSound("Ability.SandKing_CausticFinale")
		local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start_fallback_mid.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)
	end
end

function OnYugi04SpellEnd(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local dealdamage = target:GetMaxHealth() * keys.DamagePercent / 100
	local damage_table = {
		ability = keys.ability,
		victim = target,
		attacker = caster,
		damage = dealdamage,
		damage_type = keys.ability:GetAbilityDamageType(),
	    damage_flags = DOTA_UNIT_TARGET_FLAG_INVULNERABLE
	}
	UnitDamageTarget(damage_table)
	target:EmitSound("Ability.SandKing_CausticFinale")
	local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start_fallback_mid.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnYugiKill(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local ability = caster:FindAbilityByName("ability_thdots_yugi04")
	if FindTalentValue(caster,"special_bonus_unique_centaur_2") ~= 0 and keys.unit:IsHero()==true and keys.unit:IsIllusion()==false then
		ability:EndCooldown()
	end
end