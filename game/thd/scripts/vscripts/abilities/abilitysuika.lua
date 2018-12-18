if AbilitySuika == nil then
	AbilitySuika = class({})
end

--LinkLuaModifier("modifier_suika_castrange", "modifiers/modifier_suika_castrange", LUA_MODIFIER_MOTION_NONE)


function OnSuika02Start(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targets = keys.target_entities
	for _,v in pairs(targets) do
		local deal_damage = keys.ability:GetAbilityDamage()
		local damage_table = {
			    victim = v,
			    attacker = caster,
			    damage = deal_damage+(caster:GetStrength()*1),
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)
	end
end

function OnSuika02ULTStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targets = keys.target_entities
	local abilityLevel = caster:GetContext("ability_thdots_suika02_level") 
	for _,v in pairs(targets) do
		local deal_damage = 150 + (abilityLevel - 1) * 50
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = deal_damage+(caster:GetStrength()*1),
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)
	end
end

function OnSuika03Spawn(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local unit = CreateUnitByName(
		"npc_dota_suika_03_smallsuika"
		,caster:GetOrigin() - caster:GetForwardVector() * 100
		,false
		,caster
		,caster
		,caster:GetTeam()
		)
	unit:SetContextThink("npc_dota_suika_03_smallsuika_timer",
		function ()
			if GameRules:IsGamePaused() then return 0.03 end
			unit:ForceKill(false)
			return nil
		end, 5.0)
    unit:SetBaseDamageMax(keys.MaxDamage)
	unit:SetBaseDamageMin(keys.MinDamage)
	keys.ability:ApplyDataDrivenModifier( caster, unit, "modifier_thdots_suika03_small_states", {} )	
end

function OnSuika04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if FindTalentValue(caster,"special_bonus_unique_tidehunter")~=0 then
		keys.ability:ApplyDataDrivenModifier( caster, caster, "modifier_thdots_Suika_04_telent", {} )
	end
	--keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_suika_range", {8.5})
 	--GetModifierCastRangeBonus 
	caster:SetModelScale(0.5+keys.ability:GetLevel())
	local SuikaAbility1 = caster:FindAbilityByName("suika_toss")
	local SuikaCooldown1 = SuikaAbility1:GetCooldownTimeRemaining()
	if  SuikaCooldown1 >0 
	 then
	 SuikaAbility1:EndCooldown()
	end
	local SuikaAbility2 = caster:FindAbilityByName("tiny_toss")
	local SuikaCooldown2 = SuikaAbility2:GetCooldownTimeRemaining()
	if  SuikaCooldown2 >0 
	 then
	 SuikaAbility2:EndCooldown()
	end	
	--caster:AddNewModifier(caster, keys.ability, "modifier_suika_castrange", { Duration = keys.ability:GetSpecialValueFor("duration")})
	
	
end

function OnSuika04vision(keys)
	local caster = keys.caster
	
AddFOWViewer(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster:GetCurrentVisionRange(), 0.051, false)

end

function OnSuika04SpellEnd(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	caster:SetModelScale(1.0)
end

function OnSuika042Start(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targets = keys.target_entities
	for _,v in pairs(targets) do
		local deal_damage = keys.ability:GetAbilityDamage()
		local damage_table = {
			    victim = v,
			    attacker = caster,
			    damage = deal_damage+(caster:GetStrength()*1),
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)
	end
end

function OnSuika03small(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	
	if caster:HasModifier("modifier_thdots_Suika_04") then
		return
	end	

	caster:SetModelScale(0.3)
end

function OnSuika03smallend(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	
	if caster:HasModifier("modifier_thdots_Suika_04") then
		return
	end	

	caster:SetModelScale(1)
end



function OnSuika02xStart(keys)
		local caster = keys.caster
		local procchance = keys.procchance
		local targets = keys.target_entities	
		
		if caster:HasModifier("modifier_thdots_Suika_04") ~= true then
		

		if RollPercentage(procchance) then		
		caster:EmitSound("Hero_Brewmaster.ThunderClap")		
		for _,v in pairs(targets) do
		
		local strscale = keys.strscale
		local deal_damage = keys.ability:GetAbilityDamage()+(caster:GetStrength()*strscale)
		local damage_table = {
			    victim = v,
			    attacker = caster,
			    damage = deal_damage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)
		
		keys.ability:ApplyDataDrivenModifier( caster, v, "modifier_suika02x_slow", {} )
		
		--local effectsuikaIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_pulverize.vpcf", PATTACH_WORLDORIGIN, v )
		--ParticleManager:SetParticleControl( effectsuikaIndex, 1, v:GetOrigin() )
		--ParticleManager:SetParticleControl( effectsuikaIndex, 2, v:GetOrigin() )
		

		end		

		
		
		end

		end
		
		
		if caster:HasModifier("modifier_thdots_Suika_04") then	
		
		
		local ability4 = caster:FindAbilityByName("ability_thdots_suika04")			
		local ability4_level = ability4:GetLevel() - 1		
		
		local ultimateprocchance = ability4:GetLevelSpecialValueFor("ultimate_ability_chance_base",ability4_level)		
		if RollPercentage(ultimateprocchance) then			
				caster:EmitSound("Hero_Brewmaster.ThunderClap")		
				for _,v in pairs(targets) do
		
		local strscale = keys.strscale
		local deal_damage = keys.ability:GetAbilityDamage()+(caster:GetStrength()*strscale)
		local damage_table = {
			    victim = v,
			    attacker = caster,
			    damage = deal_damage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)
		
		keys.ability:ApplyDataDrivenModifier( caster, v, "modifier_suika02x_slow", {} )
		
		--local effectsuikaIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_pulverize.vpcf", PATTACH_WORLDORIGIN, v )
		--ParticleManager:SetParticleControl( effectsuikaIndex, 1, v:GetOrigin() )
		--ParticleManager:SetParticleControl( effectsuikaIndex, 2, v:GetOrigin() )
		

				end		

			end
		end		
		

		


end

function OnSuika03Modelstart(keys)

	local caster = keys.caster
	if caster:HasModifier("modifier_thdots_Suika_04") then
		return
	end
	
	caster:SetModelScale(0.3)	



end