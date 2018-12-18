function OnHatate02start (keys)



	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = keys.target_entities
	local damagemulti = keys.DmgMulti	
	local dealdamatehatate = (caster:GetAverageTrueAttackDamage(caster)*(damagemulti+FindTalentValue(caster,"special_bonus_unique_hatate_2"))/100)
	
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, caster, dealdamatehatate, nil)	
	for _,v in pairs(targets) do
	--if v:isNull() ~= true then

		--UnitDamageTarget(damage_table)
		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_hatate02_debuff", {})		
	--	SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, v, dealdamatehatate, nil)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hatate/ability_hatate_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
	
	
	
		local damage_table = {
			ability = keys.ability,
			victim = v,
			attacker = caster,
			damage = dealdamatehatate,
			damage_type = DAMAGE_TYPE_PHYSICAL, 
			damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS
		}	
		UnitDamageTarget(damage_table)
	--end
	end
	
	
	caster:EmitSound("hatate02_"..math.random(1,3))


end


function OnHatate02Attack(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if(keys.attacker~=caster)then
		return
	end
	local target = keys.target
	local damage_table = {
				ability = keys.ability,
			    victim = target,
			    attacker = caster,
			    damage = keys.BounsDamage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
	}
	UnitDamageTarget(damage_table)
end



function Hatate01Blink(keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local pid = caster:GetPlayerID()
	local difference = point - casterPos
	local ability = keys.ability
	local range = ability:GetLevelSpecialValueFor("blink_range", (ability:GetLevel() - 1))
	
	
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_hatate_3"))

	if difference:Length2D() > range then
		point = casterPos + (point - casterPos):Normalized() * range
	end

	FindClearSpaceForUnit(caster, point, false)
	ProjectileManager:ProjectileDodge(caster)
	
	local blinkIndex = ParticleManager:CreateParticle("particles/econ/events/ti4/blink_dagger_start_ti4.vpcf", PATTACH_ABSORIGIN, caster)
	Timers:CreateTimer( 1, function()
		ParticleManager:DestroyParticle( blinkIndex, false )
		return nil
		end
	)
end


function Teleport( event )
	local caster = event.caster
	local point = event.target_points[1]
    FindClearSpaceForUnit(caster, point, true)
    caster:Stop() 
    caster:EmitSound("hatate03")	  
end


function hatateEX(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local Caster=keys.caster
	local level = keys.ability:GetLevel()
    local ability = Caster:FindAbilityByName("ability_thdots_hatate05z")
		ability:SetLevel(level)
		
		
	
end

function Hatate04voice(event)
	local caster = event.caster
	
	EmitGlobalSound("hatate04xx")	
	
	--end
end


function OnHatate03SpellStart(keys)
	local caster = keys.caster
	
	--caster:EmitSound("hatate03start")
	--caster:EmitSound("hatate03agi")
	--end
end

function OnHatate03Spellend(keys)
	local caster = keys.caster
	
	--caster:EmitSound("hatate03end")	
	
	--end
end

function Teleport2( event )
	local caster = event.caster
    caster:EmitSound("hatate03")	  
	
	local fountain = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin() , nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_BUILDING , DOTA_UNIT_TARGET_FLAG_INVULNERABLE , FIND_CLOSEST, false)
	
  	for _,base in pairs(fountain) do
	if base:GetClassname()  == "ent_dota_fountain" then

	local baseposition = base:GetAbsOrigin()
    FindClearSpaceForUnit(caster, baseposition, true)	
	
	end
	end		
end


function hataultimatetetalentcd (keys)

local caster = keys.caster

	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_hatate_1"))
	--caster:EmitSound("hatateteleport")
end

function hataultimatetetalentcd2 (keys)

local caster = keys.caster

	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_hatate_1"))
	caster:EmitSound("hatateteleport")
end

function OnHatateAttacklanded(keys)
	local caster = keys.caster
	local target = keys.target
	

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hatate/ability_hatate_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)


end

function OnHatate03Start(keys)

	local caster = EntIndexToHScript(keys.caster_entindex)
	local ability = keys.ability
	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_hatate03x", {})		
	caster:SetModifierStackCount("modifier_hatate03x", ability,keys.Hatatespeed)
	
	caster.hatateatkspeed = keys.Hatatespeed

end

function OnHatate03Think(keys)

	local caster = keys.caster
	local ability = keys.ability
	
	local stacks = caster:GetModifierStackCount("modifier_hatate03x", caster)
	local decreasestack = (caster.hatateatkspeed * keys.intervals)/keys.duration
	local finalstack = stacks - decreasestack
	caster:SetModifierStackCount("modifier_hatate03x", ability,finalstack)

end

