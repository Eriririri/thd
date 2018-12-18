


function OnsuwakoexSpellStart(keys)

local caster = keys.caster
local target = keys.target
local ability = keys.ability
local suwakointscale = keys.intscale
local dealdamagesuwako = ((caster:GetIntellect()*suwakointscale) +  ability:GetAbilityDamage())
	--caster:EmitSound("suwako_innate_"..math.random(1,3))	 
	 
	 --ApplyDamage({victim = target, attacker = caster, damage = dealdamagesuwako, damage_type = keys.ability:GetAbilityDamageType()})
	 
	 
	 		local damage_table = {
				ability = keys.ability,
			    victim = target,
			    attacker = caster,
			    damage = dealdamagesuwako,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}	
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, dealdamagesuwako, nil)		
		UnitDamageTarget(damage_table)
	
	 local effectIndex = ParticleManager:CreateParticle( "particles/econ/items/storm_spirit/strom_spirit_ti8/gold_storm_sprit_ti8_overload_discharge.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 2, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 5, target:GetOrigin())
		caster:EmitSound("Hero_VengefulSpirit.MagicMissileImpact")
		
	 local ability3 = caster:FindAbilityByName("ability_thdots_suwako03z")	
	 local ability3lv = ability3:GetLevel()
	 
	 if ability3lv == 1 then
	 
	 caster:GiveMana((dealdamagesuwako)*0.06 )	 
	 end
	 if ability3lv == 2 then
	 
	 caster:GiveMana((dealdamagesuwako)*0.08 )	 
	 end	 


	 if ability3lv == 3 then
	 
	 caster:GiveMana((dealdamagesuwako)*0.1 )	 
	 end

	 if ability3lv == 4 then
	 
	 caster:GiveMana((dealdamagesuwako)*0.12 )	 
	 end	 
	
end





function suwako01soundeffect(keys)
local caster = keys.caster


	 

	caster:EmitSound("suwako01effectvoice_"..math.random(1,3))	 
	
end


function suwakoexvoice(keys)
local caster = keys.caster


	caster:EmitSound("suwako_innate_"..math.random(1,3))	 
	
end


function OnSuwako01SpellStart(keys)
	local caster = keys.caster
	
	local target = keys.target
	local ability = keys.ability
	 --ApplyDamage({victim = target, attacker = caster, damage = (caster:GetIntellect()*1.4) +  ability:GetAbilityDamage(), damage_type = keys.ability:GetAbilityDamageType()})
	local intscale = keys.intscale 
	 local suwako01dealdamage = (caster:GetIntellect()*intscale) + ability:GetAbilityDamage() +FindTalentValue(caster,"special_bonus_unique_suwako_1")
	 
	
		--UnitDamageTarget(damage_table)	 
	 
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, suwako01dealdamage, nil)
	 	local damage_table = {
				ability = keys.ability,
			    victim = target,
			    attacker = caster,
			    damage = suwako01dealdamage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)	
	 
	 
	 local ability3 = caster:FindAbilityByName("ability_thdots_suwako03z")	
	 local ability3lv = ability3:GetLevel()
	 
	 if ability3lv == 1 then
	 
	 caster:GiveMana(((caster:GetIntellect()*1.4) +  ability:GetAbilityDamage())*0.06 )	 
	 end
	 if ability3lv == 2 then
	 
	 caster:GiveMana(((caster:GetIntellect()*1.4) +  ability:GetAbilityDamage())*0.08 )	 
	 end	 


	 if ability3lv == 3 then
	 
	 caster:GiveMana(((caster:GetIntellect()*1.4) +  ability:GetAbilityDamage())*0.1 )	 
	 end

	 if ability3lv == 4 then
	 
	 caster:GiveMana(((caster:GetIntellect()*1.4) +  ability:GetAbilityDamage())*0.12 )	 
	 end
	 

	--	ParticleManager:DestroyParticleSystem(effectIndex2,false)	 
	 caster:EmitSound("suwako01effect")			 
end



function OnSuwako01SpellEnd(keys)
	local caster = keys.caster
	
	local target = keys.target
	local ability = keys.ability

	 
		
	 
end

function Suwako02cooldown(keys)
	local caster = keys.caster
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_suwako_2"))	

end


function OnSuwako02SpellStart(keys)
	local caster = keys.caster
	
	--local target = keys.target
	local ability = keys.ability
	local model = keys.model


	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end	
	
	caster:SetOriginalModel(model)
	--caster:SetModel(model)	
	caster:EmitSound("suwako02_1")	
end


function suwako02modelcheck(keys)
	local caster = keys.caster
	
	--local target = keys.target
	local ability = keys.ability
	local model = keys.model
	caster:SetModel(model)	
	--caster:EmitSound("suwako02_1")	

end

function suwako02effectcheck(keys)
	local caster = keys.caster
	local radius = keys.radius
		local effectIndex4 = ParticleManager:CreateParticle( "particles/econ/events/ti7/shivas_guard_active_ti7.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	
		ParticleManager:SetParticleControl(effectIndex4, 0, caster:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex4, 1, Vector(radius-300, 0, radius-300))
		--ParticleManager:ReleaseParticleIndex(effectIndex4)		
	caster:EmitSound("suwako_02") 		
end		

function OnSuwako02SpellEnd(keys)
	local caster = keys.caster
	
	--local target = keys.target
	local ability = keys.ability
	local model2 = keys.model2
	
	caster:SetOriginalModel(caster.caster_model)
	--caster:SetModel(model2)	
end

function suwako02damage(keys)
	local caster = keys.caster
	
	local target = keys.target
	local ability = keys.ability
	
	local suwako02dealdamage = ((caster:GetIntellect()*0.5) +  ability:GetAbilityDamage())*0.5
	 --ApplyDamage({victim = target, attacker = caster, damage = ((caster:GetIntellect()*0.5) +  ability:GetAbilityDamage())*0.5, damage_type = keys.ability:GetAbilityDamageType()})
	
	 
	 
	 
	caster:EmitSound("suwako_02") 
	
		 local effectIndex = ParticleManager:CreateParticle( "particles/econ/events/ti7/shivas_guard_impact_ti7.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())

		
	
		
	 local ability3 = caster:FindAbilityByName("ability_thdots_suwako03z")	
	 local ability3lv = ability3:GetLevel()
	 
	 if ability3lv == 1 then
	 
	 caster:GiveMana(((caster:GetIntellect()*0.5) +  ability:GetAbilityDamage())*0.06 )	 
	 end
	 if ability3lv == 2 then
	 
	 caster:GiveMana(((caster:GetIntellect()*0.5) +  ability:GetAbilityDamage())*0.08 )	 
	 end	 


	 if ability3lv == 3 then
	 
	 caster:GiveMana(((caster:GetIntellect()*0.5) +  ability:GetAbilityDamage())*0.1 )	 
	 end

	 if ability3lv == 4 then
	 
	 caster:GiveMana(((caster:GetIntellect()*0.5) +  ability:GetAbilityDamage())*0.12 )	 
	 end	

 	keys.ability:ApplyDataDrivenModifier(caster,target,"modifier_suwako02_slow",{})
		local damage_table = {
				ability = keys.ability,
			    victim = target,
			    attacker = caster,
			    damage = suwako02dealdamage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}	
		UnitDamageTarget(damage_table)	
 	--keys.ability:ApplyDataDrivenModifier(caster,target,"modifier_suwako02_ministun",{})
end

function suwako03manacost (keys)
	local caster = keys.caster
	local manacost = keys.manacost
	local manatospend = ((caster:GetMaxMana()*manacost)/100)
	local ability = keys.ability
	caster:SpendMana(manatospend,ability)




end

function suwako03check(keys)


	local caster = keys.caster
	local manacost = keys.manacost
	
	local ability = keys.ability
	
	if caster:GetMana() < ((caster:GetMaxMana()*manacost)/100) then
	
		ability:SetActivated(false)
	else
		ability:SetActivated(true)	
	
	
	end
	






end













function Onsuwako04check(event)


	local caster = event.caster
	
	local target = event.target
	local ability = event.ability
	
	--local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin() , nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	
	local teammates = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin() , nil, 1600, DOTA_UNIT_TARGET_TEAM_FRIENDLY ,DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

	--if target:CanEntityBeSeenByMyTeam(caster) == true  then
  	--for _,enemy in pairs(enemies) do
	--if enemy:CanEntityBeSeenByMyTeam(caster) == true then
	--ability:ApplyDataDrivenModifier( caster, enemy, "modifier_suwako04", {} )
	
	--end
	--end
  	for _,teammate in pairs(teammates) do
	if target:CanEntityBeSeenByMyTeam(teammate) == true then
	ability:ApplyDataDrivenModifier( caster, target, "modifier_suwako04", {} )
	end
	end		
	
end



function Onsuwako04start(keys)
	local caster = keys.caster
	
	local target = keys.target
	local ability = keys.ability
	 --ApplyDamage({victim = target, attacker = caster, damage = (caster:GetIntellect()*0.6) +  ability:GetAbilityDamage(), damage_type = keys.ability:GetAbilityDamageType()})
	
	local suwako04dealdamage = (caster:GetIntellect()*0.6) +  ability:GetAbilityDamage() +FindTalentValue(caster,"special_bonus_unique_suwako_4")

	
		local damage_table = {
				ability = keys.ability,
			    victim = target,
			    attacker = caster,
			    damage = suwako04dealdamage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}	
		UnitDamageTarget(damage_table)	
		
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, suwako04dealdamage, nil) 
	
	caster:EmitSound("suwako_04") 
	 
	 		 local effectIndex = ParticleManager:CreateParticle( "particles/econ/items/kunkka/kunkka_weapon_whaleblade_retro/kunkka_spell_torrent_retro_whaleblade_b.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 2, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 5, target:GetOrigin())
		
	 		 local effectIndex2 = ParticleManager:CreateParticle( "particles/decompiled_particles/econ/items/kunkka/kunkka_weapon_whaleblade/kunkka_spell_torrent_splash_whaleblade.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex2, 0, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex2, 1, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex2, 2, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex2, 5, target:GetOrigin())		 	

	 		 local effectIndex4 = ParticleManager:CreateParticle( "particles/units/heroes/hero_earthshaker/earthshaker_fissure.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex4, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(effectIndex4, 1, caster:GetAbsOrigin())		
		ParticleManager:DestroyParticleSystem(effectIndex4,false)		
		
		local effectIndex = ParticleManager:CreateParticle( "particles/econ/events/ti7/shivas_guard_impact_ti7.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
		

end


function Suwako04voice(event)
	local caster = event.caster
	--local ability = event.ability	
	THDReduceCooldown(event.ability,-FindTalentValue(caster,"special_bonus_unique_suwako_3"))	

		caster:EmitSound("suwako_04_"..math.random(1,3))	
--caster:GiveMana(((caster:GetIntellect()*0.6)+120)*0.12)	

end


--LinkLuaModifier("modifier_suwako_mana", "scripts/vscripts/modifiers/modifier_suwako_mana.lua", LUA_MODIFIER_MOTION_NONE)


function Onsuwako04mana(keys)

	 local caster = keys.caster
	 local ability = keys.ability
	 
	 
	 
	 --caster:AddNewModifier(caster, ability, "modifier_suwako_mana",  {Duration = 0.1} )	 
	 
	 
	 
	 

end


function HideWearables( event )
	local hero = event.caster
	local ability = event.ability

	hero.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(hero.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
end


function ShowWearables( event )
	local hero = event.caster

	for i,v in pairs(hero.hiddenWearables) do
		v:RemoveEffects(EF_NODRAW)
	end
end


function OnSuwako03DealDamage(keys)

	local caster = keys.caster
	local dmg = keys.DealDamage
	local returnmana = keys.Manareturn
	local getmana = (dmg*returnmana)/100
	
	caster:GiveMana(getmana)	


end