if AbilityReisen == nil then
	AbilityReisen = class({})
end

function OnReisenExSpellStart(caster,target)
	for i=1,1 do
		local rad = RandomFloat(-math.pi,math.pi)
		local dis = RandomFloat(400,700)
		local unit = CreateUnitByName(
			"npc_thdots_unit_reisenEx_unit"
			,target:GetOrigin() + Vector(dis*math.cos(rad),dis*math.sin(rad),0)
			,false
			,caster
			,caster
			,caster:GetTeam()
		)
		--unit:MoveToTargetToAttack(target)
		
		unit:SetContextThink("ability_reisen_ex_spell_think_attack", 
			function ()
				if GameRules:IsGamePaused() then return 0.03 end
				if(target==nil)then
					return nil
				end
				local newOrder = {
			 		UnitIndex = unit:entindex(), 
			 		OrderType =  DOTA_UNIT_ORDER_ATTACK_TARGET,
			 		TargetIndex = target:entindex(), --Optional.  Only used when targeting units
			 		AbilityIndex = 0, --Optional.  Only used when casting abilities
			 		Position = nil, --Optional.  Only used when targeting the ground
			 		Queue = 0 --Optional.  Used for queueing up abilities
			 	}
				ExecuteOrderFromTable(newOrder)
				return nil
			end, 
		0.1)
		unit:SetContextThink("ability_reisen_ex_spell_think", 
			function ()
				if GameRules:IsGamePaused() then return 0.03 end
				unit:ForceKill(true)
			end, 
		2.3)
	end
	local dummy = CreateUnitByName("npc_dummy_unit", 
	    	    target:GetAbsOrigin(), 
				false, 
				caster, 
				caster, 
				caster:GetTeamNumber()
	)
	dummy:SetContextThink("ability_reisen_ex_dummy_think", 
			function ()
				if GameRules:IsGamePaused() then return 0.03 end
				dummy:RemoveSelf()
			end, 
	2.3)
end

function OnReisen01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	local Reisen01rad = GetRadBetweenTwoVec2D(caster:GetOrigin(),targetPoint)
	keys.ability:SetContextNum("ability_Reisen01_Rad",Reisen01rad,0)
end

function OnReisen01SpellMove(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targets = keys.target_entities
	local Reisen01rad = keys.ability:GetContext("ability_Reisen01_Rad")

	local vec = Vector(vecCaster.x-math.cos(Reisen01rad)*keys.MoveSpeed/50,vecCaster.y-math.sin(Reisen01rad)*keys.MoveSpeed/50,vecCaster.z)
	caster:SetOrigin(vec)
end

function OnReisen01SpellHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local damage_table = {
				ability = keys.ability,
			    victim = keys.target,
			    attacker = caster,
			    damage = dealdamage ,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = keys.ability:GetAbilityTargetFlags()
	}
	UnitDamageTarget(damage_table)
	if(caster:GetContext("ability_reisen02_buff")==TRUE)then
		local targets = FindUnitsInRadius(
		   	caster:GetTeam(),		--caster team
		  	keys.target:GetOrigin(),		--find position
		   	nil,					--find entity
		    caster:GetContext("ability_reisen02_buff_radius"),		--find radius
		   	DOTA_UNIT_TARGET_TEAM_ENEMY,
		   	keys.ability:GetAbilityTargetType(),
		   	0, 
		   	FIND_CLOSEST,
		   	false
	    )
	    OnReisen02FireEffect(keys.target)
	    OnReisen02DealDamage(caster,targets)
	end

	OnReisenExSpellStart(caster,keys.target)

	SetTargetToTraversable(caster)
end

function OnReisen02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	caster:SetContextNum("ability_reisen02_buff",TRUE,0)
	caster:SetContextNum("ability_reisen02_buff_damage",keys.BounsDamage,0)
	caster:SetContextNum("ability_reisen02_buff_stun_duration",keys.Duration,0)
	caster:SetContextNum("ability_reisen02_buff_radius",keys.Radius,0)
	caster:SetContextNum("ability_reisen02_buff_type",keys.ability:GetAbilityDamageType(),0)
	caster:SetContextNum("ability_reisen02_buff_flag",keys.ability:GetAbilityTargetFlags(),0)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/reisen/ability_reisen02_buff.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_attack1", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystemTime(effectIndex,keys.AbilityDuration)

	caster:SetContextThink("ability_reisen02_buff_timer", 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			caster:SetContextNum("ability_reisen02_buff",FALSE,0)
			return nil
		end, 
	keys.AbilityDuration)
end

function OnReisen02DealDamage(caster,targets)
	for _,v in pairs(targets) do
		local damage_table = {
			ability = keys.ability,
			victim = v,
			attacker = caster,
			damage = caster:GetContext("ability_reisen02_buff_damage"),
			damage_type = caster:GetContext("ability_reisen02_buff_type"), 
			damage_flags = caster:GetContext("ability_reisen02_buff_flag")
		}

		--PrintTable(damage_table)
		--OnReisenExSpellStart(caster,v)
		UnitDamageTarget(damage_table)
		UtilStun:UnitStunTarget( caster,v,caster:GetContext("ability_reisen02_buff_stun_duration") )
	end	
end

function OnReisen02FireEffect(v)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/reisen/ability_reisen02.vpcf", PATTACH_CUSTOMORIGIN, v)
	ParticleManager:SetParticleControlEnt(effectIndex, 0, v, 0, follow_origin, v:GetOrigin(), false)
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnReisen03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	local reisen03rad = GetRadBetweenTwoVec2D(caster:GetOrigin(),targetPoint) + math.pi/3
	local reisen03dis = GetDistanceBetweenTwoVec2D(caster:GetOrigin(),targetPoint)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/reisen/ability_reisen_01_e.vpcf", PATTACH_CUSTOMORIGIN, caster)
	local originVector = caster:GetOrigin() + Vector(math.cos(reisen03rad- math.pi/37.5)*reisen03dis,math.sin(reisen03rad- math.pi/37.5)*reisen03dis,0)

	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_eye", Vector(0,0,0), true)
	ParticleManager:SetParticleControl(effectIndex, 1, originVector)
	ParticleManager:SetParticleControlEnt(effectIndex , 9, caster, 5, "attach_eye", Vector(0,0,0), true)
	
	
	keys.ability:SetContextNum("ability_reisen03_Rad",reisen03rad,0)
	keys.ability:SetContextNum("ability_reisen03_dis",reisen03dis,0)
	keys.ability:SetContextNum("ability_reisen03_effectIndex",effectIndex,0)

	UnitPauseTarget( caster,caster,0.5)
end


function OnReisen03SpellMove(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targets = keys.target_entities
	local originRad = keys.ability:GetContext("ability_reisen03_Rad")
	local originVector = Vector(math.cos(originRad),math.sin(originRad),0)
	local originDis = keys.ability:GetContext("ability_reisen03_dis")
	
	for _,v in pairs(targets) do
		local vecV = v:GetOrigin()
		if(IsRadInRect(vecV,vecCaster,100,originDis,originRad))then
			local damage_table = {
			    victim = v,
			    attacker = caster,
			   	damage = keys.ability:GetAbilityDamage(),
			    damage_type = keys.ability:GetAbilityDamageType(), 
			    ability_damage_target_type = keys.ability:GetAbilityTargetType(),
	    	   	damage_flags = 0
			}
			OnReisen03DamageTarget(damage_table)
		end
	end
	local effectIndex = keys.ability:GetContext("ability_reisen03_effectIndex")
	local originRad = originRad - math.pi/37.5
	caster:SetForwardVector(Vector(math.cos(originRad)*originDis,math.sin(originRad)*originDis,0))
	local forwardVec = caster:GetForwardVector()
	keys.ability:SetContextNum("ability_reisen03_Rad",originRad,0)

	ParticleManager:SetParticleControl(effectIndex, 1, caster:GetOrigin() + Vector(math.cos(originRad)*originDis,math.sin(originRad)*originDis,0))
	
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnReisen03DamageTarget(damage_table)
	local caster = damage_table.attacker
	local target = damage_table.victim
	if(target:GetContext("ability_reisen03_damage_tag")==nil or target:GetContext("ability_reisen03_damage_tag")==FALSE)then
		target:SetContextNum("ability_reisen03_damage_tag",TRUE,0)
		Timer.Wait 'ability_reisen03_damage_tag' (1,
			function()
				OnReisenExSpellStart(caster,target)
				UnitDamageTarget(damage_table)
				
				if(caster:GetContext("ability_reisen02_buff")==TRUE)then
					local targets = FindUnitsInRadius(
					   	caster:GetTeam(),		--caster team
					  	target:GetOrigin(),		--find position
					   	nil,					--find entity
					   	caster:GetContext("ability_reisen02_buff_radius"),		--find radius
					   	DOTA_UNIT_TARGET_TEAM_ENEMY,
					   	damage_table.ability_damage_target_type,
					   	0, 
					   	FIND_CLOSEST,
					   	false
				    )
				    OnReisen02FireEffect(target)
				    OnReisen02DealDamage(caster,targets)
				end

				target:SetContextNum("ability_reisen03_damage_tag",FALSE,0)
			end
		)
	end
end

function OnReisen04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local OnHitFuction = "OnReisen04ProjectileOnHit"
	local forwardVec = caster:GetForwardVector()
	local forwardCos = forwardVec.x
	local forwardSin = forwardVec.y

	for i=1,5 do
		local rollRad = math.pi/6 * i - math.pi/2
		local shotVector =  Vector(math.cos(rollRad)*forwardCos - math.sin(rollRad)*forwardSin,
								 forwardSin*math.cos(rollRad) + forwardCos*math.sin(rollRad),
								 0)
		local BulletTable = {
		    Ability        	 	=   keys.ability,
			EffectName			=	"particles/heroes/reisen/ability_reisen_04_bullet.vpcf",
			vSpawnOrigin		=	caster:GetOrigin() + Vector(0,0,64),
			vSpawnOriginNew		=	caster:GetOrigin() + Vector(0,0,64),
			fDistance			=	1500,
			fStartRadius		=	keys.DamageRadius,
			fEndRadius			=	keys.DamageRadius,
			Source         	 	=   caster,
			bHasFrontalCone		=	false,
			bRepalceExisting 	=  false,
			iUnitTargetTeams		=	"DOTA_UNIT_TARGET_TEAM_ENEMY",
			iUnitTargetTypes		=	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_CREEP",
			iUnitTargetFlags		=	"DOTA_UNIT_TARGET_FLAG_NONE",
			fExpireTime     =   GameRules:GetGameTime() + 10.0,
			bDeleteOnHit    =   true,
			vVelocity       =   shotVector,
			bProvidesVision	=	true,
			iVisionRadius	=	400,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		DotsCreateProjectileMoveToTargetPoint(BulletTable,caster,keys.MoveSpeed,keys.Acceleration1,keys.Acceleration2,OnHitFuction)
	end
end

function OnReisen04ProjectileOnHit(caster,targets,ability)
    local damage_table = {
    	ability = keys.ability,
        victim = targets[1],
        attacker = caster,
        damage = ability:GetAbilityDamage(),
        damage_type = ability:GetAbilityDamageType(),
        damage_flags = ability:GetAbilityTargetFlags()
    }
    OnReisenExSpellStart(caster,targets[1])
    UnitDamageTarget(damage_table)
    if(caster:GetContext("ability_reisen02_buff")==TRUE and (GetDistanceBetweenTwoVec2D(caster:GetOrigin(),targets[1]:GetOrigin()) >= 200))then
		local targets02 = FindUnitsInRadius(
		   	caster:GetTeam(),		--caster team
		  	targets[1]:GetOrigin(),		--find position
		   	nil,					--find entity
		    caster:GetContext("ability_reisen02_buff_radius"),		--find radius
		   	DOTA_UNIT_TARGET_TEAM_ENEMY,
		   	ability:GetAbilityTargetType(),
		   	0, 
		   	FIND_CLOSEST,
		   	false
	    )
	    OnReisen02FireEffect(targets[1])
	    OnReisen02DealDamage(caster,targets02)
	end
end


function DotsCreateProjectileMoveToTargetPoint(projectileTable,caster,speed,acceleration1,acceleration2,OnHitFuction)
    local effectIndex = ParticleManager:CreateParticle(projectileTable.EffectName, PATTACH_CUSTOMORIGIN, caster)
    local acceleration = acceleration1
    local targets = {}
    caster:SetContextThink(DoUniqueString("ability_caster_projectile"), 
        function()
        	if GameRules:IsGamePaused() then return 0.03 end
            local vec = projectileTable.vSpawnOriginNew + projectileTable.vVelocity*speed/50
            local dis = GetDistanceBetweenTwoVec2D(projectileTable.vSpawnOrigin,vec)
            targets = FindUnitsInRadius(
                caster:GetTeam(),       --caster team
                vec,                    --find position
                nil,                    --find entity
                projectileTable.fStartRadius,       --find radius
                projectileTable.Ability:GetAbilityTargetTeam(),
                projectileTable.Ability:GetAbilityTargetType(),
                projectileTable.Ability:GetAbilityTargetFlags(), 
                FIND_CLOSEST,
                false
            )
            if(targets[1]~=nil)then
                if(projectileTable.bDeleteOnHit)then
                    if(OnHitFuction=="OnReisen04ProjectileOnHit")then
                        OnReisen04ProjectileOnHit(caster,targets,projectileTable.Ability)
                    end
                    ParticleManager:DestroyParticleSystem(effectIndex,true)
                    return nil
                else
                    if(OnHitFuction=="OnReisen04ProjectileOnHit")then
                        OnReisen04ProjectileOnHit(caster,targets,projectileTable.Ability)
                    end
                    targets = {}
                end
            end

            if(speed <= 0 and acceleration2 ~= 0)then
                acceleration = acceleration2
                speed = 0
                acceleration2 = 0
            end

            if(dis<projectileTable.fDistance)then
                    ParticleManager:SetParticleControl(effectIndex,3,vec)
                    projectileTable.vSpawnOriginNew = vec
                    speed = speed + acceleration
                    return 0.02
            else
                ParticleManager:DestroyParticleSystem(effectIndex,true)
                return nil
            end
        end, 
    0.02)
end

function OnReisenOld01SpellSuccess(keys)
    local caster = EntIndexToHScript(keys.caster_entindex)
    local target = keys.target
    
        local damage_table = {
            ability = keys.ability,
            victim = keys.target,
            attacker = caster,
            damage = keys.ability:GetAbilityDamage() + FindTalentValue(caster,"special_bonus_unique_reisen_1"),
            damage_type = keys.ability:GetAbilityDamageType(),
            damage_flags = keys.ability:GetAbilityTargetFlags()
        }
        UnitDamageTarget(damage_table)
   	if FindTalentValue(caster,"special_bonus_unique_reisen_2")~=0 then
		keys.ability:ApplyDataDrivenModifier( caster, target, "modifier_reisen01old_talent", {} )
	end 
end

function OnReisenOld04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	keys.ability:ApplyDataDrivenModifier(caster, caster, "ability_reisenold04_modifier", {duration = keys.duration + FindTalentValue(caster,"special_bonus_unique_mirana_2")})
	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_reisen04_aura", {duration = keys.duration + FindTalentValue(caster,"special_bonus_unique_mirana_2")})
	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_reisen04_aurainvisible", {duration = 1.5})
	
	
	local Caster=keys.caster
    local ability = Caster:FindAbilityByName("phantom_lancer_juxtapose")
		ability:SetLevel(5)
	
	
end

function IllusionProcAuraEndThinker(keys)
local caster=keys.caster
local targets=FindUnitsInRadius(caster:GetTeamNumber(),
							caster:GetOrigin(),
							nil,
							99999,
							DOTA_UNIT_TARGET_TEAM_FRIENDLY,
							DOTA_UNIT_TARGET_HERO,
							DOTA_UNIT_TARGET_FLAG_NONE,
							FIND_ANY_ORDER,
							false)
local ability=keys.ability
for _,target in pairs(targets) do
ability:ApplyDataDrivenModifier(caster,target,"modifier_illusion_proc_aura_end",{Duration=0.8})
end
end

function OnReisenOld02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if(caster.ability_reisen02_illusion_max == nil)then
		caster.ability_reisen02_illusion_max = 0
	end
	if(caster.ability_reisen02_illusion_max < keys.Max_illusions)then
		caster.ability_reisen02_illusion_max = caster.ability_reisen02_illusion_max + 2
		for i=1,2 do
			illusion=create_illusion_reisen(keys,caster:GetOrigin(),keys.Illusion_damage_in_pct,keys.Illusion_damage_out_pct,keys.Illusion_duration)
			if (illusion ~= nil) then
				local CasterAngles = caster:GetAnglesAsVector()
				illusion:SetAngles(CasterAngles.x,CasterAngles.y,CasterAngles.z)
				illusion:SetHealth(illusion:GetMaxHealth()*caster:GetHealthPercent()*0.01)
				illusion:SetMana(illusion:GetMaxMana()*caster:GetManaPercent()*0.01)
				local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantom_lancer_spawn_smoke.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 0, illusion:GetOrigin())
				ParticleManager:SetParticleControl(effectIndex, 1, illusion:GetOrigin())
				illusion.illusioncaster = caster
			end
		end
	end
end


function IllusionProcAuraEnd(keys)
local target=keys.target
local ability = target:FindAbilityByName("phantom_lancer_juxtapose")
ability:SetLevel(4)


end

function reisendestroyillusion(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target	

	if target:IsRealHero()==false and target:GetClassname() == "npc_dota_hero_mirana" then
	target:Destroy()
	end
	

end




function MinamitsuEX(keys)
local target=keys.target
local ability = target:FindAbilityByName("ability_thdots_minamitsu05")
ability:SetLevel(1)
end

function MinamitsuEX1(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local Caster=keys.caster
	local level = keys.ability:GetLevel()
    local ability = Caster:FindAbilityByName("ability_thdots_minamitsu05")
		ability:SetLevel(level)
		
		
	
end


function MinamitsuEXThinker(keys)
local caster=keys.caster
local targets=FindUnitsInRadius(caster:GetTeamNumber(),
							caster:GetOrigin(),
							nil,
							99999,
							DOTA_UNIT_TARGET_TEAM_FRIENDLY,
							DOTA_UNIT_TARGET_HERO,
							DOTA_UNIT_TARGET_FLAG_NONE,
							FIND_ANY_ORDER,
							false)
local ability=keys.ability
for _,target in pairs(targets) do
ability:ApplyDataDrivenModifier(caster,target,"ability_thdots_minamitsu05",{Duration=0.8})
end
end


function OnReisen04Spellend(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local Caster=keys.caster
	local level = keys.ability:GetLevel()
    local ability = Caster:FindAbilityByName("phantom_lancer_juxtapose")
		ability:SetLevel(4)		
		
	
end

function OnReisen04Spellend2(keys)
local caster=keys.caster
local targets=FindUnitsInRadius(caster:GetTeamNumber(),
							caster:GetOrigin(),
							nil,
							99999,
							DOTA_UNIT_TARGET_TEAM_FRIENDLY,
							DOTA_UNIT_TARGET_HERO,
							DOTA_UNIT_TARGET_FLAG_NONE,
							FIND_ANY_ORDER,
							false)
local ability = target:FindAbilityByName("phantom_lancer_juxtapose")
for _,target in pairs(targets) do
ability:SetLevel(4)
end
end

function Newreisenex(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	--local hero	
	local ability = keys.ability
	
	--local reisenpassive = caster:FindModifierByName("modifier_reisen_illusion_count")	
	
	--local reisenillusioncount = reisenpassive:GetStackCount()
	
	--if(caster.ability_Newreisenex_illusion_max == nil)then
		--caster.ability_Newreisenex_illusion_max = 0
	--end	
	
	--if(caster:IsIllusion())then
		--hero = caster:GetOwner()

	--else
		--hero = caster
	--end
	if(reisen.ability_Newreisenex_illusion_max == nil)then
		reisen.ability_Newreisenex_illusion_max = 0
	end
	
	--if caster:IsRealHero()==true and reisenillusioncount <(5) then
	if reisen.ability_Newreisenex_illusion_max < 3 then	
	--local reisen_illusion = AnimeIllusionManager:CreateIllusion(caster, abiliy, illusions_duration, illusions_outgoing_damage, illusions_incoming_damage, caster:GetAbsOrigin() + RandomVector(200))
	THDIllusionManager:CreateIllusion(caster, abiliy, 10, -86, 300, caster:GetAbsOrigin() + RandomVector(200))
	
	caster.ability_Newreisenex_illusion_max = caster.ability_Newreisenex_illusion_max + 1
    --caster:SetModifierStackCount("modifier_reisen_illusion_count", caster, reisenillusioncount + 1)	
	end
		

end

function OnReisenEX02OnDeath(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if(caster:IsIllusion())then
		local hero = caster:GetOwner()
		--local reisenpassive = hero:FindModifierByName("modifier_reisen_illusion_count")			
		--local reisenillusioncount = reisenpassive:GetStackCount()		
	hero.ability_Newreisenex_illusion_max = hero.ability_Newreisenex_illusion_max + 1		
	end
end


function OnReisen03newSpellStart(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local agimulti = keys.agimultiply


	local dealdamage = ability:GetAbilityDamage()+(caster:GetAgility()*agimulti)
    ApplyDamage({victim = target, attacker = caster, damage = dealdamage, damage_type = ability:GetAbilityDamageType()})
		
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target,dealdamage, nil)

	 local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_reisen/ability_reisen_03_explosion_h.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 2, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 5, target:GetOrigin())
		
end

function OnReisen04buffcheck(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local Caster=keys.caster
	local target = keys.target
    local ability = keys.ability
	if  target:GetClassname() == "npc_dota_hero_mirana" then
	
	ability:ApplyDataDrivenModifier(caster, target, "modifier_reisen04_aura_buff2", {duration = keys.duration + FindTalentValue(caster,"special_bonus_unique_mirana_2")})	

	end
		
	
end


function OnReisen04buffcheckinvisible(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local Caster=keys.caster
	local target = keys.target
    local ability = keys.ability
	if  target:GetClassname() == "npc_dota_hero_mirana" then
	
	ability:ApplyDataDrivenModifier(caster, target, "modifier_reisen04_aura_buff2invisible", {duration = keys.duration + FindTalentValue(caster,"special_bonus_unique_mirana_2")})	

	end
		
	
end