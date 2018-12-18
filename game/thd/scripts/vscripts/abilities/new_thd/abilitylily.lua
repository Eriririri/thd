

function OnLilyInnateToggleon(keys)
	
	
	local caster = keys.caster
	local model = keys.model	
	local ability = keys.ability
	
	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end	
	
	caster:SetOriginalModel(model)	
	
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_lily_black", {})	
	


end


function OnLilyInnateToggleoff(keys)
	local caster = keys.caster
	

	local ability = keys.ability
	local model2 = keys.model2
	
	caster:SetOriginalModel(caster.caster_model)
	caster:RemoveModifierByName("modifier_lily_black")
	
end


function LilyInnatetogglecheck (keys)

	local caster = keys.caster
	local ability = keys.ability
	--local lilycd = ability:GetCooldownTimeRemaining()	
	
	if ability:IsCooldownReady() == false then
	
		ability:SetActivated(false)
		else
		ability:SetActivated(true)
	end




end

function LilyInnatetogglecheck2 (keys)

	local caster = keys.caster
	local ability = keys.ability
	local lilycd = ability:GetCooldownTimeRemaining()	
	
	if lilycd > 0 then
	
		ability:SetActivated(false)
		else
		ability:SetActivated(true)
	end




end




function lily01costcheck (keys)
	local caster = keys.caster
	local spellcost = keys.spellcost
	
	local ability = keys.ability
	
	if caster:HasModifier("modifier_lily_black") == false then
		if caster:GetMana() < spellcost then
			ability:SetActivated(false)
		else
			ability:SetActivated(true)
		end
		
	end	

	if caster:HasModifier("modifier_lily_black") == true then
		if caster:GetHealth() < spellcost then
			ability:SetActivated(false)
		else
			ability:SetActivated(true)
		end
		
	end	

end


function OnLily01SpellStart (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local spellcost = keys.spellcost
	
	if caster:HasModifier("modifier_lily_black") == false then
	caster:SpendMana(spellcost,ability)
	target:EmitSound("lily01healcast")	
	
	if 	target:GetTeam() ~= caster:GetTeam()  then
	
		if is_spell_blocked(target) then return end
	
	
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_lily01buff", {})		

		
	end		
	
	if caster:HasModifier("modifier_lily_black") == true then
		
	target:EmitSound("lily01cursecast")	
		local damage_table = {
				ability = keys.ability,
			    victim = caster,
			    attacker = caster,
			    damage = spellcost,
			    damage_type = DAMAGE_TYPE_PURE, 
	    	    damage_flags = 0
		}	
		UnitDamageTarget(damage_table)		
		
	if 	target:GetTeam() ~= caster:GetTeam()  then
	
		if is_spell_blocked(target) then return end
	
	
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_lily01debuff", {})	
		
	end	



end


function lily01buffhealing(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local baseheal = keys.effective
	local statscale = keys.scale * caster:GetIntellect()
	local healingdone = statscale+baseheal

--	SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,target,healingdone,nil)	
	target:EmitSound("lily01heal")	
	
--	target:Heal(healingdone,caster)	
	THDHealTargetLily(caster,target,healingdone)


end


function lily01debuffdamage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local basedmg = keys.effective
	local statscale = keys.scale * caster:GetIntellect()
	local dmgdone = statscale + basedmg
	target:EmitSound("lily01damage")	
		local damage_table = {
				ability = keys.ability,
			    victim = target,
			    attacker = caster,
			    damage = dmgdone,
			    damage_type = ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}	
		
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, dmgdone, nil)

		UnitDamageTarget(damage_table)



end



function lily02costcheck (keys)
	local caster = keys.caster
	local spellcost = keys.spellcost
	
	local ability = keys.ability
	
	if caster:HasModifier("modifier_lily_black") == false then
		if caster:GetMana() < spellcost then
			ability:SetActivated(false)
		else
			ability:SetActivated(true)
		end
		
	end	

	if caster:HasModifier("modifier_lily_black") == true then
		if caster:GetHealth() < spellcost then
			ability:SetActivated(false)
		else
			ability:SetActivated(true)
		end
		
	end	

end



function OnLily02SpellStart (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local spellcost = keys.spellcost
	local maxheal = target:GetMaxHealth()
	
	
	
	
	if caster:HasModifier("modifier_lily_black") == false then
	
		caster:SpendMana(spellcost,ability)
--		SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,target,maxheal,nil)	
--		target:Heal(maxheal,caster)
	
		THDHealTargetLily(caster,target,maxheal)
	
		ability:ApplyDataDrivenModifier(caster, target, "modifier_lily02buff", {})		

		
	end		
	
	if caster:HasModifier("modifier_lily_black") == true then
	
		local enemies = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, keys.Radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	
		for _,v in pairs(enemies) do	
			ability:ApplyDataDrivenModifier(caster, v, "modifier_lily02debuff_penalty", {})
		end
	
		if target:GetUnitName() == "ability_minamitsu_04_ship" or target:GetUnitName() == "ability_margatroid03_doll" or target:GetUnitName() == "npc_dota_mutation_pocket_roshan" or target:GetUnitName() == "npc_dota_roshan" then
			return
		end	
--		if target:GetClassname() ~= "npc_dota_roshan" then
		target:Kill(caster, caster)
--		end	
		
	
		local damage_table = {
				ability = keys.ability,
			    victim = caster,
			    attacker = caster,
			    damage = spellcost,
			    damage_type = DAMAGE_TYPE_PURE, 
	    	    damage_flags = 0
		}	
		UnitDamageTarget(damage_table)	
		
		
		

		
	end	



end





function lily03costcheck (keys)
	local caster = keys.caster
	local spellcost = keys.spellcost
	
	local ability = keys.ability
	
	if caster:HasModifier("modifier_lily_black") == false then
		if caster:GetMana() < spellcost then
			ability:SetActivated(false)
		else
			ability:SetActivated(true)
		end
		
	end	

	if caster:HasModifier("modifier_lily_black") == true then
		if caster:GetHealth() < spellcost then
			ability:SetActivated(false)
		else
			ability:SetActivated(true)
		end
		
	end	

end


function OnLily03SpellStart(keys)

	local caster = keys.caster
	local ability = keys.ability
	local spellcost = keys.spellcost
	local targetpoint = keys.target_points[1]
	


	if caster:HasModifier("modifier_lily_black") == false then
	caster:SpendMana(spellcost,ability)
	
	ability:ApplyDataDrivenThinker(caster, targetpoint, "modifier_lily_white03_area", {})		

		
	end		
	
	if caster:HasModifier("modifier_lily_black") == true then
	
	ability:ApplyDataDrivenThinker(caster, targetpoint, "modifier_lily_black03_area", {})	
	
		local damage_table = {
				ability = keys.ability,
			    victim = caster,
			    attacker = caster,
			    damage = spellcost,
			    damage_type = DAMAGE_TYPE_PURE, 
	    	    damage_flags = 0
		}	
		UnitDamageTarget(damage_table)	

		
	end	



end



function lilywhite03bufftick (keys)

	local ability = keys.ability

	local caster = keys.caster
	local target = keys.target
	local baseheal = keys.effective
	local statscale = keys.scale * caster:GetIntellect()
	local healingdone = statscale+baseheal 
--	SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,target,healingdone,nil)	
	target:EmitSound("lily03heal")	
--	target:Heal(healingdone,caster)	

	THDHealTargetLily(caster,target,healingdone)	
	if target:HasModifier("modifier_lily_white03_immunity_check") == true then
	
		local stackcount = target:GetModifierStackCount("modifier_lily_white03_immunity_check", caster)
	
		target:SetModifierStackCount("modifier_lily_white03_immunity_check", ability, stackcount+1)
	
	
	
	end	
	
	if target:HasModifier("modifier_lily_white03_immunity_check") == false then
	ability:ApplyDataDrivenModifier(caster, target, "modifier_lily_white03_immunity_check", {})	
	target:SetModifierStackCount("modifier_lily_white03_immunity_check", ability, 1)	
	
	end
	
	if target:HasModifier("modifier_lily_white03_immunity_check") == true and target:GetModifierStackCount("modifier_lily_white03_immunity_check", caster) >= 3 then	
	

		
		ability:ApplyDataDrivenModifier(caster, target, "modifier_lily_white03_immunity", {})
		target:RemoveModifierByName("modifier_lily_white03_immunity_check")
		
			
		

	end

end




function lilyblack03debufftick (keys)

	local ability = keys.ability

	local caster = keys.caster
	local target = keys.target
	local basedamage = keys.effective
	local statscale = keys.scale * caster:GetIntellect()
	local dmgdone = statscale+basedamage
	
	

	
	
	
	if target:HasModifier("modifier_lily_black03_stun_check") == true then
	
		local stackcount = target:GetModifierStackCount("modifier_lily_black03_stun_check", caster)
	
		target:SetModifierStackCount("modifier_lily_black03_stun_check", ability, stackcount+1)
	
	
	
	end	
	
	if target:HasModifier("modifier_lily_black03_stun_check") == false then
	ability:ApplyDataDrivenModifier(caster, target, "modifier_lily_black03_stun_check", {})		
	target:SetModifierStackCount("modifier_lily_black03_stun_check", ability, 1)	
	end
	
	if target:HasModifier("modifier_lily_black03_stun_check") == true and target:GetModifierStackCount("modifier_lily_black03_stun_check", caster) >= 3 then	
	

		
		ability:ApplyDataDrivenModifier(caster, target, "modifier_lily_black03_stun", {})
		target:RemoveModifierByName("modifier_lily_black03_stun_check")
		
			
		

	end
	target:EmitSound("lily03damage")
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, dmgdone, nil)	
	
		local damage_table = {
				ability = keys.ability,
			    victim = target,
			    attacker = caster,
			    damage = dmgdone,
			    damage_type = DAMAGE_TYPE_MAGICAL, 
	    	    damage_flags = 0
		}	
		UnitDamageTarget(damage_table)	
end



function lily04costcheck (keys)
	local caster = keys.caster
	local spellcost = keys.spellcost
	
	local ability = keys.ability
	
	if caster:HasModifier("modifier_lily_black") == false then
		if caster:GetMana() < spellcost then
			ability:SetActivated(false)
		else
			ability:SetActivated(true)
		end
		
	end	

	if caster:HasModifier("modifier_lily_black") == true then
		if caster:GetHealth() < spellcost then
			ability:SetActivated(false)
		else
			ability:SetActivated(true)
		end
		
	end	

end



function OnLily04SpellStart(keys)

	local caster = keys.caster
	local ability = keys.ability
	local spellcost = keys.spellcost
	local targetpoint = keys.target_points[1]
	local Radius = keys.Radius
	local Duration = keys.Duration
	
	THDReduceCooldown(ability,FindTalentValue(caster,"special_bonus_unique_lily_2"))	
	
	

	if caster:HasModifier("modifier_lily_black") == false then
	caster:SpendMana(spellcost,ability)	
	ability:ApplyDataDrivenThinker(caster, targetpoint, "modifier_lily_white04_area", {})		

		
	end		
	
	if caster:HasModifier("modifier_lily_black") == true then
	
	ability:ApplyDataDrivenThinker(caster, targetpoint, "modifier_lily_black04_area", {})	
	
		local damage_table = {
				ability = keys.ability,
			    victim = caster,
			    attacker = caster,
			    damage = spellcost,
			    damage_type = DAMAGE_TYPE_PURE, 
	    	    damage_flags = 0
		}	
		UnitDamageTarget(damage_table)	

		
	end	
	
	local dummy = CreateUnitByName(
		"npc_dummy_unit"
		,caster:GetCursorPosition()
		,false
		,caster
		,caster
		,caster:GetTeam()
	)	
	dummy:AddAbility("night_stalker_darkness") 
		local selfAuraBorderFx = ParticleManager:CreateParticleForTeam("particles/newthd/lily/04ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy, 2)
        ParticleManager:SetParticleControl(selfAuraBorderFx, 0, Vector(Radius,0,0))
        ParticleManager:SetParticleControl(selfAuraBorderFx, 1, Vector(Radius,0,0))
		
		local selfAuraBorderFx2 = ParticleManager:CreateParticleForTeam("particles/newthd/lily/04ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy, 3)
        ParticleManager:SetParticleControl(selfAuraBorderFx2, 0, Vector(Radius,0,0))
        ParticleManager:SetParticleControl(selfAuraBorderFx2, 1, Vector(Radius,0,0))		
		
		
		Timers:CreateTimer(Duration, function()		
		dummy:RemoveSelf()		
		end)	

end


function lilywhite04bufftick (keys)

	local ability = keys.ability

	local caster = keys.caster
	local target = keys.target
	local baseheal = keys.effective
	local statscale = keys.scale * caster:GetIntellect()
	local healingdone = statscale+baseheal 
	
--	SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,target,healingdone,nil)	
	
--	target:Heal(healingdone,caster)	

	THDHealTargetLily(caster,target,healingdone)
	


end

function lilyblack04debufftick (keys)

	local ability = keys.ability

	local caster = keys.caster
	local target = keys.target
	local basedamage = keys.effective
	local statscale = keys.scale * caster:GetIntellect()
	local dmgdone = statscale+basedamage


	SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, dmgdone, nil)	
	
		local damage_table = {
				ability = keys.ability,
			    victim = target,
			    attacker = caster,
			    damage = dmgdone,
			    damage_type = DAMAGE_TYPE_MAGICAL, 
	    	    damage_flags = 0
		}	
		UnitDamageTarget(damage_table)	
end

function lilywhite04startsound (keys)
	local target = keys.target
	
	target:EmitSound("lily04heal")	


end


function lilywhite04stopsound (keys)
	local target = keys.target
	
	target:StopSound("lily04heal")	


end


function lilyblack04startsound (keys)
	local target = keys.target
	
	target:EmitSound("lily04damage")	


end


function lilyblack04stopsound (keys)
	local target = keys.target
	
	target:StopSound("lily04damage")	


end