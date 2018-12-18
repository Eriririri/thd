function OnKoishi01Think(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = FindUnitsInRadius(
				   caster:GetTeam(),		
				   caster:GetOrigin(),		
				   nil,					
				   keys.Radius,		
				   DOTA_UNIT_TARGET_TEAM_BOTH,
				   DOTA_UNIT_TARGET_HERO,
				   0, FIND_CLOSEST,
				   false
	)
	local count = 0
	for k,v in pairs(targets) do
		if v:IsIllusion()==false then
			count = count + 1
		end
	end
	local countTelent = FindTalentValue(caster,"special_bonus_unique_drow_ranger_2")
	if countTelent > 0 then
		caster:SetModifierStackCount("passive_koishi01_bonus_attack", keys.ability, count * countTelent)
	else
		caster:SetModifierStackCount("passive_koishi01_bonus_attack", keys.ability, count)
	end
end

function OnKoishi02AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local manadecrease = keys.DamagePercent * keys.DamageTaken / 100 + keys.BaseDamage

	if target:GetMana() >= manadecrease then
		target:SetMana(target:GetMana() - manadecrease) 
	else
		target:SetMana(0)
	end
	local damage_table = {
		ability = keys.ability,
		victim = target,
		attacker = caster,
		damage = manadecrease,
		damage_type = keys.ability:GetAbilityDamageType(), 
	    damage_flags = keys.ability:GetAbilityTargetFlags()
	}
	UnitDamageTarget(damage_table) 
	local effectIndex = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/am_manaburn_basher_ti_5.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
end

function OnKoishi04PhaseStart(keys)
 	local caster = EntIndexToHScript(keys.caster_entindex)
 	if FindTalentValue(caster,"special_bonus_unique_drow_ranger_3") ~= 0 then
 		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_koishi04_telent_bonus", {})
 	end
end

function OnKoishi04Destroy(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_koishi04_bonus_action_end", nil)
end

function OnKoishi04ActionStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	caster:SetModel("models/thd2/koishi/koishi_w_mmd.vmdl")
	caster:SetOriginalModel("models/thd2/koishi/koishi_w_mmd.vmdl")
end

function OnKoishi04ActionDestroy(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	caster:SetModel("models/thd2/koishi/koishi_transform_mmd.vmdl")
	caster:SetOriginalModel("models/thd2/koishi/koishi_transform_mmd.vmdl")
	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_koishi04_bonus", nil)
	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_koishi04_no_heal", nil)
 	PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), caster)
	caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
	caster:MoveToPosition(caster:GetOrigin())
	keys.ability:StartCooldown(keys.ability:GetCooldown(keys.ability:GetLevel()))
end

function OnKoishi04ActionEndStart(keys)	
	local caster = EntIndexToHScript(keys.caster_entindex)
	caster:SetModel("models/thd2/koishi/koishi_w_mmd.vmdl")
	caster:SetOriginalModel("models/thd2/koishi/koishi_w_mmd.vmdl")
end

function OnKoishi04ActionEndDestroy(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	caster:SetModel("models/thd2/koishi/koishi_mmd.vmdl")
	caster:SetOriginalModel("models/thd2/koishi/koishi_mmd.vmdl")
	PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), nil)
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	caster:MoveToPosition(caster:GetOrigin())
end

function OnKoishi04Think(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = FindUnitsInRadius(
		caster:GetTeam(),	
		caster:GetOrigin(),	
		nil,	
		1000,		
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		keys.ability:GetAbilityTargetType(),
		0, 
		FIND_CLOSEST,
		false
	)
	if targets[1]~=nil and targets[1]:IsInvisible()==false then
		caster:MoveToTargetToAttack(targets[1])
	end
end

function OnKoishi04Kill(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vec = keys.unit:GetOrigin()
	local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, vec)
	ParticleManager:SetParticleControl(effectIndex, 1, vec)
	ParticleManager:SetParticleControl(effectIndex, 2, vec)
	ParticleManager:SetParticleControl(effectIndex, 3, vec)
	ParticleManager:SetParticleControl(effectIndex, 4, vec)
	ParticleManager:SetParticleControl(effectIndex, 8, vec)
end