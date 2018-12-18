if AbilitySakuya == nil then
	AbilitySakuya = class({})
end

function OnSakuyaExSpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	THDReduceCooldown(keys.ability,FindTalentValue(caster,"special_bonus_unique_templar_assassin"))
	if(caster.ability_sakuya_01_stun == FALSE or caster.ability_sakuya_01_stun == nil)then
		caster.ability_sakuya_01_stun = TRUE
		local effectIndex = ParticleManager:CreateParticle(
			"particles/heroes/sakuya/ability_sakuya_ex.vpcf", 
			PATTACH_CUSTOMORIGIN, 
			caster)
		caster.ability_sakuya_ex_index = effectIndex
		ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_attack1", Vector(0,0,0), true)
	else
		return
	end
end

function OnSakuya01SpellReset(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if(caster.sakuya04_cooldown_reset==TRUE)then
		keys.ability:EndCooldown()
		local usedCount = caster.sakuya04_ability_01_used_count + 1
		caster:SetMana(caster:GetMana() - usedCount * 0.25 * keys.ability:GetManaCost(keys.ability:GetLevel()))
		caster.sakuya04_ability_01_used_count = usedCount
	end
end

function OnSakuya01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	--local intBouns = (caster:GetIntellect()	- (caster:GetIntellect()%6)) / 6 * keys.IntMulti + 1
	--local agiBouns = (caster:GetAgility() - (caster:GetAgility()%6)) / 6 * keys.AgiMulti
	local bounsDamage = 0
	
	if(caster.ability_sakuya_01_stun==TRUE)then
		UnitPauseTargetSakuya( caster,target,(keys.StunDuration+FindTalentValue(caster,"special_bonus_unique_sakuya_3")),keys.ability )

		local effectIndex = ParticleManager:CreateParticle(
			"particles/heroes/sakuya/ability_sakuya_ex_stun.vpcf", 
			PATTACH_CUSTOMORIGIN, 
			caster)
		ParticleManager:SetParticleControlEnt(effectIndex , 0, target, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:DestroyParticleSystem(effectIndex,false)
		bounsDamage = keys.DamageBouns
	end


	if(caster.ability_sakuya_ex_index ~= -1 and caster.ability_sakuya_ex_index ~= nil)then
		ParticleManager:DestroyParticleSystem(caster.ability_sakuya_ex_index,true)
		caster.ability_sakuya_ex_index = -1
	end
	
	--local dealdamage = (agiBouns + keys.Damage + bounsDamage) * intBouns
	
	local intBonusx = ((caster:GetIntellect()*keys.IntMulti*1/100)+1)
	local agiBounusx = (caster:GetAgility() * keys.AgiMulti)
	local dealdamage = (agiBounusx + keys.Damage)*intBonusx
	
	
	local damage_table = {
			    victim = target,
			    attacker = caster,
			    damage = dealdamage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0,
	    	    ability = keys.ability
	}
	UnitDamageTarget(damage_table)

	Timer.Wait 'ability_sakuya_01_stun_timer' (0.5,
		function()
			caster.ability_sakuya_01_stun = FALSE
		end
	)	
end

function OnSakuya02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	keys.ability.ability_sakuya02_point_x = targetPoint.x
	keys.ability.ability_sakuya02_point_y =targetPoint.y
	keys.ability.ability_sakuya02_point_z =targetPoint.z
end

function OnSakuya02SpellDamage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targetPoint = Vector(keys.ability.ability_sakuya02_point_x,keys.ability.ability_sakuya02_point_y,keys.ability.ability_sakuya02_point_z)
	local targets = keys.target_entities

	local pointRad = GetRadBetweenTwoVec2D(vecCaster,targetPoint)
	local pointRad1 = pointRad + math.pi * (keys.DamageRad/180)
	local pointRad2 = pointRad - math.pi * (keys.DamageRad/180)

	local forwardVec = Vector( math.cos(pointRad) * 2000 , math.sin(pointRad) * 2000 , 0 )

	local knifeTable = {
		Ability				= keys.ability,
		EffectName			= "particles/thd2/heroes/sakuya/ability_sakuya_01.vpcf",
		vSpawnOrigin		= vecCaster + Vector(0,0,128),
		fDistance			= keys.DamageRadius,
		fStartRadius		= 120,
		fEndRadius			= 120,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_FLAG_NONE,
		fExpireTime			= GameRules:GetGameTime() + 10.0,
		bDeleteOnHit		= false,
		vVelocity			= forwardVec,
		bProvidesVision		= true,
		iVisionRadius		= 400,
		iVisionTeamNumber	= caster:GetTeamNumber(),
		iSourceAttachment 	= PATTACH_CUSTOMORIGIN
	} 

	ProjectileManager:CreateLinearProjectile(knifeTable)

	for i=1,keys.ability:GetLevel() do
		local iVec = Vector( math.cos(pointRad + math.pi/18*(i+0.5)) * 2000 , math.sin(pointRad + math.pi/18*(i+0.5)) * 2000 , 0 )
		knifeTable.vVelocity = iVec
		ProjectileManager:CreateLinearProjectile(knifeTable)
		iVec = Vector( math.cos(pointRad - math.pi/18*(i+0.5)) * 2000 , math.sin(pointRad - math.pi/18*(i+0.5)) * 2000 , 0 )
		knifeTable.vVelocity = iVec
		ProjectileManager:CreateLinearProjectile(knifeTable)
	end

	for _,v in pairs(targets) do
		local vVec = v:GetOrigin()
		local vecRad = GetRadBetweenTwoVec2D(targetPoint,vecCaster)
		if IsPointInCircularSector(vVec.x,vVec.y,math.cos(vecRad),math.sin(vecRad),keys.DamageRadius,math.pi * (keys.DamageRad/180),vecCaster.x,vecCaster.y) then
			--local intBouns = (caster:GetIntellect()	- (caster:GetIntellect()%6)) / 6 * keys.IntMulti + 1
			--local agiBouns = (caster:GetAgility() - (caster:GetAgility()%6)) / 6 * keys.AgiMulti
			--local dealdamage = (agiBouns + keys.Damage) * intBouns
			local intBonusx = ((caster:GetIntellect()*keys.IntMulti*1/100)+1)
			local agiBounusx = (caster:GetAgility() * keys.AgiMulti)
			local dealdamage = (agiBounusx + keys.Damage)*intBonusx
			local damage_table = {
				victim = v,
				attacker = caster,
				damage = dealdamage,
				damage_type = keys.ability:GetAbilityDamageType(), 
				damage_flags = 0,
				ability = keys.ability
			}
			UnitDamageTarget(damage_table)
		end
	end
	if(caster.sakuya04_cooldown_reset==TRUE)then
		keys.ability:EndCooldown()
		local usedCount = caster.sakuya04_ability_02_used_count + 1
		caster:SetMana(caster:GetMana() - usedCount * 0.25 * keys.ability:GetManaCost(keys.ability:GetLevel()))
		caster.sakuya04_ability_02_used_count = usedCount
	end
end


function OnSakuya03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	caster.ability_sakuya03_point_x = targetPoint.x
	caster.ability_sakuya03_point_y = targetPoint.y
	caster.ability_sakuya03_point_z = targetPoint.z
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_templar_assassin_2"))
	if FindTalentValue(caster,"special_bonus_unique_sakuya_2")~=0 then
	keys.ability:ApplyDataDrivenModifier( caster, caster, "modifier_thdots_sakuya03_talent_attackspeed", {} )
	end	
	ProjectileManager:ProjectileDodge(caster)	
end

function OnSakuya03SpellDamage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targetPoint = Vector(caster.ability_sakuya03_point_x,caster.ability_sakuya03_point_y,caster.ability_sakuya03_point_z)
	local targets = keys.target_entities

	local pointRad = GetRadBetweenTwoVec2D(vecCaster,targetPoint)

	local forwardVec = Vector( math.cos(pointRad) * 1000 , math.sin(pointRad) * 1000 , 0 )
	local knifeTable = {
	    Ability        	 	=   keys.ability,
		EffectName			=	"particles/thd2/heroes/sakuya/ability_sakuya_01.vpcf",
		vSpawnOrigin		=	vecCaster + Vector(0,0,64),
		fDistance			=	keys.DamageRadius/2,
		fStartRadius		=	120,
		fEndRadius			=	120,
		Source         	 	=   caster,
		bHasFrontalCone		=	false,
		bRepalceExisting 	=  false,
		iUnitTargetTeams		=	"DOTA_UNIT_TARGET_TEAM_ENEMY",
		iUnitTargetTypes		=	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_CREEP",
		iUnitTargetFlags		=	"DOTA_UNIT_TARGET_FLAG_NONE",
		fExpireTime     =   GameRules:GetGameTime() + 10.0,
		bDeleteOnHit    =   false,
		vVelocity       =   forwardVec,
		bProvidesVision	=	true,
		iVisionRadius	=	400,
		iVisionTeamNumber = caster:GetTeamNumber()
	}

	for i=0,5 do
		local iVec = Vector( math.cos(pointRad + math.pi/6*i) * 1000 , math.sin(pointRad + math.pi/6*i) * 1000 , 0 )
		knifeTable.vVelocity = iVec
		ProjectileManager:CreateLinearProjectile(knifeTable)
		iVec = Vector( math.cos(pointRad - math.pi/6*i) * 1000 , math.sin(pointRad - math.pi/6*i) * 1000 , 0 )
		knifeTable.vVelocity = iVec
		ProjectileManager:CreateLinearProjectile(knifeTable)
	end

	local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/sakuya/ability_sakuya_03.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, caster:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	if(GetDistanceBetweenTwoVec2D(vecCaster,targetPoint)<=keys.MaxRange)then
		caster:SetOrigin(targetPoint)
	else
		local blinkVector = Vector(math.cos(pointRad)*keys.MaxRange,math.sin(pointRad)*keys.MaxRange,0) + vecCaster
		caster:SetOrigin(blinkVector)
	end
	
	SetTargetToTraversable(caster)

	for _,v in pairs(targets) do
		local damage_table = {
			victim = v,
			attacker = caster,
			damage = keys.Damage,
			damage_type = keys.ability:GetAbilityDamageType(), 
			damage_flags = 0,
			ability = keys.ability
		}
		UnitDamageTarget(damage_table)
	end
	if(caster.sakuya04_cooldown_reset==TRUE)then
		keys.ability:EndCooldown()
		local usedCount = caster.sakuya04_ability_03_used_count + 1
		caster:SetMana(caster:GetMana() - usedCount * 0.25 * keys.ability:GetManaCost(keys.ability:GetLevel()))
		caster.sakuya04_ability_03_used_count = usedCount
	end
end

function OnSakuya04SpellStart(keys)
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
	local nEffectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/sakuya/ability_sakuya_04.vpcf",PATTACH_CUSTOMORIGIN,unit)
	local vecCorlor = Vector(255,0,0)
	
		
	caster.sakuya04_Effect_Unit = unit:GetEntityIndex()
	caster.sakuya04_ability_01_used_count = 0
	caster.sakuya04_ability_02_used_count = 0
	caster.sakuya04_ability_03_used_count = 0

	local ability = caster:FindAbilityByName("ability_thdots_sakuya01") 
	if(ability~=nil)then
		ability:EndCooldown()
	end
	ability = caster:FindAbilityByName("ability_thdots_sakuya02") 
	if(ability~=nil)then
		ability:EndCooldown()
	end
	ability = caster:FindAbilityByName("ability_thdots_sakuya03") 
	if(ability~=nil)then
		ability:EndCooldown()
	end

	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString('ability_sakuya04_remove'),
    	function ()
    		if GameRules:IsGamePaused() then return 0.03 end
		    if (unit~=nil) then
		        unit:RemoveSelf()
		        caster.sakuya04_cooldown_reset = FALSE
		    	return nil
			end
	    end,keys.Ability_Duration+0.1
	)
	
	if FindTalentValue(caster,"special_bonus_unique_sakuya_1")==0 then
		caster:EmitSound("Voice_Thdots_SakuyaEX.AbilitySakuya042")		
	--	ParticleManager:SetParticleControl( nEffectIndex, 0, caster:GetOrigin())		
		
	end	
	
	local effectIndex3 = ParticleManager:CreateParticle("particles/thd2/heroes/sakuya/ability_sakuya_04.vpcf", PATTACH_CUSTOMORIGIN, caster)		
		
		
	ParticleManager:SetParticleControlEnt(effectIndex3 , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
	
	ParticleManager:DestroyParticleSystemTime(effectIndex3,keys.Ability_Duration)	
	
	
	
	
end

function OnSakuya04SpellThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local effectUnitIndex = caster.sakuya04_Effect_Unit
	local effectUnit = EntIndexToHScript(effectUnitIndex)
	local vecEffectUnit = effectUnit:GetOrigin()

	--if(GetDistanceBetweenTwoVec2D(vecCaster,vecEffectUnit) <= keys.Radius)then
		caster.sakuya04_cooldown_reset = TRUE
	--else
		--caster.sakuya04_cooldown_reset = FALSE
	--end
end


function Sakuya04Talent(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	--local target = keys.target	
	if FindTalentValue(caster,"special_bonus_unique_sakuya_1")~=0 then
	--Tutorial:SetTimeFrozen( true )
	
		local sakuyaultimate = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin() , nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH,DOTA_UNIT_TARGET_ALL,keys.ability:GetAbilityTargetFlags(), FIND_CLOSEST, false)
	local effectIndex2 = ParticleManager:CreateParticle("particles/thd2/heroes/sakuya/ability_sakuya_04.vpcf", PATTACH_CUSTOMORIGIN, caster)	
  	for _,sakuyatarget in pairs(sakuyaultimate) do	

	--	if sakuyatarget:GetUnitName() ~= "npc_dummy_unit" then	


		keys.ability:ApplyDataDrivenModifier( caster, sakuyatarget, "Illusion_world", {} )
		--keys.ability:ApplyDataDrivenModifier( caster, caster, "Sakuya_world", {} )		

		
		
	
		if sakuyatarget:IsHero() then					
			if sakuyatarget:GetUnitName() ~= "npc_dota_hero_templar_assassin" then			
			--	ParticleManager:SetParticleControlEnt(effectIndex2 , 0, sakuyatarget, 5, "follow_origin", Vector(0,0,0), true)
			
				ParticleManager:SetParticleControl( effectIndex2, 0, sakuyatarget:GetOrigin())	
				ParticleManager:DestroyParticleSystemTime(effectIndex2,keys.Duration+1)				
			--	ParticleManager:DestroyParticleSystem(effectIndex2,false)	

			end	
		
		end
				
	--	end
	--caster:EmitSound("Voice_Thdots_SakuyaEX.AbilitySakuya04ex_1")	
	--caster:EmitSound("Voice_Thdots_SakuyaEX.AbilitySakuya04ex_"..math.random(1,3))
	end		
--	ParticleManager:DestroyParticleSystem(effectIndex3,false)	
	
	keys.ability:ApplyDataDrivenModifier( caster, caster, "Sakuya_world", {} )	
	caster:RemoveModifierByName("Illusion_world")	
	caster:EmitSound("Voice_Thdots_SakuyaEX.AbilitySakuya041")	
	end
end

function Sakuya04Talentvoice(event)
	local caster = event.caster
	
	if FindTalentValue(caster,"special_bonus_unique_sakuya_1")~=0 then	
	EmitGlobalSound("Voice_Thdots_SakuyaEX.AbilitySakuya04ex_"..math.random(1,3))
	end
end

function Sakuya04Talentsetduration(keys)
	local target=keys.target
	local talentduration = keys.Duration
	local caster=keys.caster
	local durationstopworld=keys.Duration
	
	if target ~= caster and target:GetUnitName() ~= "npc_dummy_unit" and target:GetClassname()=="npc_dota_healer" then 
		local allbuffs = target:FindAllModifiers()
	
	for _, v in pairs(allbuffs) do

	local buffsname = v:GetName()
	if 
	buffsname ~= "modifier_thdots_sanae04_think_interval" 
	and
	buffsname ~= "Illusion_world" 
	and
	buffsname ~= "Private_square_slow"	
	then
	
		local allbuffduration = v:GetDuration()
		local allbuffdurationdone = v:GetElapsedTime()
		local allbuffdurationleft = allbuffduration-allbuffdurationdone
		
		--v:SetDuration(allbuffdurationleft+talentduration,false)
		local classname = target:GetClassname()	
		local name = target:GetName()
		print(name)
		print(classname)
		print(buffsname)
			
		end
		
		end
	end
	--if target ~= caster then
	
	--PlayerResource:SetCameraTarget(target:GetPlayerOwnerID(), target)
	--Timers:CreateTimer(durationstopworld, function() 
	--PlayerResource:SetCameraTarget(target:GetPlayerOwnerID(), nil)
	--end)	
	
	--end

end