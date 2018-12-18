

LinkLuaModifier("active_yugi01_hp_bouns", "scripts/vscripts/modifiers/active_yugi01_hp_bouns.lua", LUA_MODIFIER_MOTION_NONE)






if AbilityYugi == nil then
	AbilityYugi = class({})
end



function OnYugi01SpellStart(keys)
	local caster = keys.caster
	

	local ability = keys.ability
	local casterstr = caster:GetStrength()
	
	ability:ApplyDataDrivenModifier(caster, caster, "active_yugi01_bouns", {})	
	caster:SetModifierStackCount("active_yugi01_bouns", ability, casterstr)	
	
	
	local hpstack = casterstr* keys.hpstacks
	
	caster:AddNewModifier(caster, ability, "active_yugi01_hp_bouns",  { Duration = keys.duration} )
	
	--caster:SetModifierStackCount("active_yugi01_hp_bouns", ability, hpstack)		
 
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
	target:EmitSound("Hero_DoomBringer.Doom")
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
	target:StopSound("Hero_DoomBringer.Doom")
end

function OnYugiKill(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local ability = caster:FindAbilityByName("ability_thdots_yugi04")
	if FindTalentValue(caster,"special_bonus_unique_centaur_2") ~= 0 and keys.unit:IsHero()==true and keys.unit:IsIllusion()==false then
		ability:EndCooldown()
	end
end

function YugiEX1(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local Caster=keys.caster
	local level = keys.ability:GetLevel()
    local ability = Caster:FindAbilityByName("ability_thdots_yugi05")
		ability:SetLevel(level)
		
		
	
end

function OnYugi02SpellStart(keys)
	local caster = keys.caster
	
	local target = keys.target
	local ability = keys.ability
	 --ApplyDamage({victim = target, attacker = caster, damage = (caster:GetStrength()*2.1) +  ability:GetAbilityDamage(), damage_type = DAMAGE_TYPE_MAGICAL})
	if FindTalentValue(caster,"special_bonus_unique_yugi_1")~=0 then
		keys.ability:ApplyDataDrivenModifier( caster, target, "modifier_yuugi_talent_slow", {} )
	end	 
end

function OnYugi02SpellDamage(keys)
	local caster = keys.caster
	
	local targets = keys.target_entities
	local ability = keys.ability
	local dealdamage = (caster:GetStrength()*2.1)	
	 --ApplyDamage({victim = target, attacker = caster, damage = (caster:GetStrength()*2.1) +  ability:GetAbilityDamage(), damage_type = DAMAGE_TYPE_MAGICAL})
	for _,v in pairs(targets) do
 
		local damage_table = {
			ability = keys.ability,
			victim = v,
			attacker = caster,
			damage = dealdamage,
			damage_type = keys.ability:GetAbilityDamageType(), 
			damage_flags = keys.ability:GetAbilityTargetFlags()
		}
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, v, dealdamage, nil)
		
		keys.ability:ApplyDataDrivenModifier(caster,v, "modifier_yuugi_stomp", {} )	
		if FindTalentValue(caster,"special_bonus_unique_yugi_1")~=0 then
			keys.ability:ApplyDataDrivenModifier( caster, target, "modifier_yuugi_talent_slow", {} )
		end	 		
		
		
		UnitDamageTarget(damage_table)
 
	end
	 
end



function OnYuugiExTakeDamage(keys)
	local caster = keys.caster
	

	local ability = keys.ability
	local triggerperc = keys.triggerpercenthp
	local triggerhp = caster:GetMaxHealth()*triggerperc/100 
	local currentcooldown = ability:GetCooldownTimeRemaining()
	local abilitycooldown = ability:GetCooldown(ability:GetLevel() - 1)
	
	if caster:GetHealth() < triggerhp and ability:IsCooldownReady() ==true then
	
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_roar_of_anihilation", {})	
	
	ability:StartCooldown(abilitycooldown)	
		
	end
 
end

