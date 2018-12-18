








function OnMystia01SpellStart(keys)
	local caster = keys.caster
	
	local target = keys.target
	local ability = keys.ability
	local scale = keys.damagemulti
	local mystia01damage = (caster:GetAgility()*scale) +  ability:GetAbilityDamage()	
	if target:IsHero()==true  then
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, mystia01damage, nil)	

	caster:EmitSound("Mystia01")	 
	end
	
	local damage_table = {
				ability = keys.ability,
			    victim = target,
			    attacker = caster,
			    damage = mystia01damage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}	
	if target:IsBuilding() == false then
	UnitDamageTarget(damage_table)	
	end
end
--

--function RestoreMana( keys )
	
--	local target = keys.unit
--	local ability = keys.ability
--	local restore_amount = ability:GetLevelSpecialValueFor("restore_amount", (ability:GetLevel() -1))
	

	
-- if target:GetClassname() ~= "npc_dota_hero_furion" and target:GetClassname() ~= "npc_dota_hero_gyrocopter" then


--	target:SetMana(target:GetMana()+restore_amount)
	
	
--end	
	

--end


function OnMystia04SpellStart(keys)
	local caster = keys.caster
	
	local target = keys.target
	local ability = keys.ability
	local scale = keys.damagemulti
	local mystiaultimatedamage = (caster:GetAgility()*scale) +  ability:GetAbilityDamage()
	if target:IsHero() ==true then

		local damage_table = {
				ability = keys.ability,
			    victim = target,
			    attacker = caster,
			    damage = mystiaultimatedamage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}	
		UnitDamageTarget(damage_table)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, mystiaultimatedamage, nil)	

		--ApplyDamage({victim = target, attacker = caster, damage = , damage_type = DAMAGE_TYPE_MAGICAL})


	end
	local modifier_day = keys.modifier_day
	local modifier_night = keys.modifier_night
	local modifier_hero_night = keys.modifier_hero_night
	if GameRules:IsDaytime() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_day, {})
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier_night, {})
		ability:ApplyDataDrivenModifier(caster, caster, modifier_hero_night, {})	
	    if FindTalentValue(caster,"special_bonus_unique_mystia_1")~=0 then
	    keys.ability:ApplyDataDrivenModifier( caster,keys.target, "modifier_mystia_talent", {} )
	    end			
	end	 
	
	
	
	
	
	
end


function CripplingFear( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	local modifier_day = keys.modifier_day
	local modifier_night = keys.modifier_night

	if GameRules:IsDaytime() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_day, {})
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier_night, {})
	end
end

function mystiainnatevision(keys)
	local caster = keys.caster
	
AddFOWViewer(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster:GetCurrentVisionRange(), 0.051, false)

end
function MystiaEX(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local Caster=keys.caster
	local level = keys.ability:GetLevel()
    local ability = Caster:FindAbilityByName("ability_thdots_mystia05")
		ability:SetLevel(level)
		
		
	
end