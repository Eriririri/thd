--keys.caster --施法者
--keys.target_entities -- 目标表
--keys.ability --技能

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
end

function OnRumia02BloodDamage( keys )
	if keys.target ~= nil then
		local caster = EntIndexToHScript(keys.caster_entindex)
		local target = keys.target
		--[[local al = keys.ability:GetLevel() - 1
		damage = keys.ability:GetLevelSpecialValueFor("damage", al)]]--
	    local DamageTable = {
	    						ability = keys.ability,
							    victim = target, 
							    attacker = caster, 
							    damage = keys.dv,
							    damage_type = keys.ability:GetAbilityDamageType(),
							    damage_flags = 0
							}
	    UnitDamageTarget(DamageTable)
	  end
end

function OnRumia02Blood(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	if keys.target ~= nil then
		if not target:IsAncient() then
			Timer.Loop 'Rumia_Blood' (keys.ti,keys.dc,
								    function(i)

							            local DamageTable = {
							            						ability = keys.ability,
											                    victim = target, 
											                    attacker = caster, 
											                    damage = keys.dv, 
											                    damage_type = keys.ability:GetAbilityDamageType(),
											                    damage_flags = 0
															}
					    				UnitDamageTarget(DamageTable)
					                    if i == keys.dc then
					                    	--以下的语句为继续执行
					                    	--return true
										end
					                    --伤害次数
										--[[local count = v:GetContext("Reimu04_Effect_Damage_Count")
										count = count - 1
										--每次减一
										if (count<=0) then
											v:SetContextNum("Reimu04_Effect_Damage_Count" , 0, 0)
											return nil
											--小于0清0滚粗返空解除
										else
										    if(v~=nil)then
												v:SetContextNum("Reimu04_Effect_Damage_Count" , count, 0)
											end
											--大于0继续
										end]]--
								    end
							        )
		end
	end
end
function OnRumia04Start(keys)
	if keys.target ~= nil then
		local caster = EntIndexToHScript(keys.caster_entindex)
		local target = keys.target

		if(caster:GetContext("Rumia04_Strength_Up")==nil)then
				caster:SetContextNum("Rumia04_Strength_Up",0,0)
		end
		local Rumia_Strength_Up = caster:GetContext("Rumia04_Strength_Up")
		local DamageTable= {
								ability = keys.ability,
								victim = target,
								attacker = caster,
								damage = keys.ability:GetAbilityDamage(),
								damage_type = DAMAGE_TYPE_PURE,
							}
		if target:IsHero() ==false and (target:GetClassname()~="npc_dota_roshan") then
			DamageTable.damage = 99999
		end


	    if (caster:GetTeam() ~= target:GetTeam())then
	    	if target:GetHealth() <= DamageTable.damage  then
	    		local strength = 0
	    		if target:IsHero() then
	    			if not target:IsIllusion()	then
	    				Rumia_Strength_Up = Rumia_Strength_Up + 5 + 5*FindTalentValue(caster,"special_bonus_unique_lifestealer") 
	    				strength = 5 + 5*FindTalentValue(caster,"special_bonus_unique_lifestealer") 
	    			end
	    		else
	    			Rumia_Strength_Up = Rumia_Strength_Up + 1 + 1*FindTalentValue(caster,"special_bonus_unique_lifestealer") 
	    			strength = 1 + 1*FindTalentValue(caster,"special_bonus_unique_lifestealer") 
	    		end
				
			--	caster:SetHealth(caster:GetHealth() + target:GetHealth()*keys.StealHealth)
			
	    		THDHealTarget(caster,caster,target:GetHealth()*keys.StealHealth)
	    		caster:ModifyGold(70, false, 0)
			
			
	    		caster:SetContextNum("Rumia04_Strength_Up",Rumia_Strength_Up,0)
	    		caster:SetBaseStrength(caster:GetBaseStrength() + strength)
	    	else
	    		caster:SetHealth(caster:GetHealth() + keys.ability:GetAbilityDamage()*keys.StealHealth)
	    	end
	    	UnitDamageTarget(DamageTable)
	    end
	end
end

function OnRumiaDead(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if caster ~= nil then
		local Rumia_Strength_Up = caster:GetContext("Rumia04_Strength_Up")
		if Rumia_Strength_Up == nil then return end	
		if Rumia_Strength_Up <= 0 then return end	

		local strengthDown = Rumia_Strength_Up*keys.LostStrength
		Rumia_Strength_Up = Rumia_Strength_Up - strengthDown
		caster:SetContextNum("Rumia04_Strength_Up",Rumia_Strength_Up,0)
		caster:SetBaseStrength(caster:GetBaseStrength() - strengthDown)
	end
end

function OnRumia03Think(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local ability = keys.ability

	if caster:IsAlive() then
		if caster:HasModifier("modifier_rumia_03_day") == false and caster:HasModifier("modifier_rumia_03_night") == false then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_rumia_03_day", {})
		end

		if GameRules:IsDaytime() then
			if caster:HasModifier("modifier_rumia_03_day") == false and caster:HasModifier("modifier_rumia_03_night") == true then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_rumia_03_day", {})
				caster:RemoveModifierByName("modifier_rumia_03_night")
			end
		else
			if caster:HasModifier("modifier_rumia_03_day") == true and caster:HasModifier("modifier_rumia_03_night") == false then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_rumia_03_night", {})
				caster:RemoveModifierByName("modifier_rumia_03_day")
			end
		end
	end
end
