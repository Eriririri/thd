function YasakaExActivex_OnInterval(keys)
	local Caster=keys.caster
	local Target=keys.target
	local Ability=keys.ability
	if Caster:IsRealHero() ~= true then
		return
	end

	
	
	if Target:HasModifier(keys.buff_name) == false then
		Ability:ApplyDataDrivenModifier(Caster, Target, keys.buff_name, {})
	end
	if Caster:HasModifier(keys.buff_name) == false then
		Ability:ApplyDataDrivenModifier(Caster, Target, keys.buff_name, {})
	end	
end

function YasakaExBuff_OnInterval(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local Target=keys.target
	local hBuff=Target:FindModifierByNameAndCaster(keys.buff_name,Caster)
	if not hBuff then return end

	local time_now=GameRules:GetGameTime()

	if not hBuff.change_stack_time then hBuff.change_stack_time=time_now end
	local last_change_time=hBuff.change_stack_time

	if Target:HasModifier(keys.activex_name) or Target:HasModifier("modifier_thdots_yasaka04_buff") then
		if hBuff:GetStackCount()==0 or (hBuff:GetStackCount()<keys.max_stack and time_now-last_change_time>=keys.add_interval) then
			hBuff:IncrementStackCount()
			hBuff.change_stack_time=time_now
		end
	else
		if time_now-last_change_time>=keys.sub_interval and Caster:GetUnitName() ~= Target:GetUnitName() then
			hBuff:DecrementStackCount()
			hBuff.change_stack_time=time_now
			if hBuff:GetStackCount()<=0 then
				hBuff:Destroy()
			end
		end
		if time_now-last_change_time>=keys.sub_interval and Caster:GetUnitName() == Target:GetUnitName() then
			if hBuff:GetStackCount() > 	keys.max_stack then
				hBuff:DecrementStackCount()
				hBuff.change_stack_time=time_now
			end
		end		
		
		
	end
end

function Yasaka01_Knockback(keys, target, vecDirection)
	local Ability=keys.ability
	local Caster=keys.caster
	local tick_interval=keys.tick_interval
	local duration=keys.knockback_distance/keys.knockback_speed
	local move_per_tick=keys.knockback_speed*tick_interval
	local max_tick=keys.knockback_distance/move_per_tick
	local tick=0
	local new_pos=target:GetOrigin()

	local OnThinkEnd=function ()
		FindClearSpaceForUnit(target, new_pos, false)
	end

	Ability:ApplyDataDrivenModifier(Caster, target, keys.knockback_debuff_name, {duration=duration})
	target:SetContextThink(
		"yasaka01_on_knockback",
		function ()
			if GameRules:IsGamePaused() then return 0.03 end
			if Ability:IsNull() then 
				OnThinkEnd()
				return nil
			end
			new_pos=target:GetOrigin()+move_per_tick*vecDirection
			GridNav:DestroyTreesAroundPoint(new_pos, 75, true)

			tick=tick+1
			if tick>=max_tick or not GridNav:IsTraversable(new_pos) or not target:HasModifier(keys.knockback_debuff_name) then 
				OnThinkEnd()
				return nil 
			end

			target:SetOrigin(new_pos)
			return tick_interval
		end,0)
end

function Yasaka01_OnSpellStart(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local TargetPoint=keys.target_points[1]
	local VecStart=Caster:GetOrigin()
	local Direction=(TargetPoint-VecStart):Normalized()
	local TickInterval=keys.tick_interval
	local MovePerTick=keys.speed*TickInterval
	local tick=0
	local tick_max=keys.range/MovePerTick
	local Ability02=Caster:FindAbilityByName("ability_thdots_yasaka02")
	local ability02_radius=nil

	local pointRad = GetRadBetweenTwoVec2D(Caster:GetOrigin(),TargetPoint)
	local forwardVec = Vector( math.cos(pointRad) * keys.speed , math.sin(pointRad) * keys.speed , 0 )

	local projectileTable = {
		Ability				= keys.ability,
		EffectName			= "particles/heroes/kanako/ability_kanako_01.vpcf",
		vSpawnOrigin		= Caster:GetOrigin() + Vector(0,0,128),
		fDistance			= keys.range,
		fStartRadius		= 120,
		fEndRadius			= 120,
		Source				= Caster,
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
		iVisionTeamNumber	= Caster:GetTeamNumber(),
		iSourceAttachment 	= PATTACH_CUSTOMORIGIN
	} 

	local projectileID = ProjectileManager:CreateLinearProjectile(projectileTable)

	local OnThinkEnd=function ()
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/kanako/ability_kanako_01_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(effectIndex, 0, VecStart+Direction*MovePerTick*tick)
		ParticleManager:SetParticleControl(effectIndex, 1, VecStart+Direction*MovePerTick*tick)
		ParticleManager:SetParticleControl(effectIndex, 3, VecStart+Direction*MovePerTick*tick)
		ParticleManager:SetParticleControl(effectIndex, 5, VecStart+Direction*MovePerTick*tick)
		ProjectileManager:DestroyLinearProjectile(projectileID)
		Caster:EmitSound("Hero_EarthSpirit.BoulderSmash.Target")
	end

	Caster:SetContextThink(
		"yasaka01_main_loop",
		function () 
			if GameRules:IsGamePaused() then return 0.03 end
			if Ability:IsNull() then 
				OnThinkEnd()
				return nil
			end
			if not ability02_radius and Ability02 and Caster:HasModifier("modifier_thdots_yasaka02_icon") then
				ability02_radius=Ability02:GetSpecialValueFor("radius")
			end
			local moved_distance=tick*MovePerTick
			local VecPos=VecStart+Direction*MovePerTick*tick
			local enemies = FindUnitsInRadius(
						Caster:GetTeamNumber(),
						VecPos,
						nil,
						keys.hitbox_radius,
						Ability:GetAbilityTargetTeam(),
						Ability:GetAbilityTargetType(),
						Ability:GetAbilityTargetFlags(),
						FIND_CLOSEST,
						false)
			if #enemies>0 then
				local Target=enemies[1]
				UnitDamageTarget{
					victim=Target, 
					attacker=Caster, 
					ability=Ability, 
					damage=Ability:GetAbilityDamage(),
					damage_type=Ability:GetAbilityDamageType(),
				}
				Yasaka01_Knockback(keys,Target,Direction)
				OnThinkEnd()
				return nil
			elseif not GridNav:IsTraversable(VecPos) or (ability02_radius and moved_distance>=ability02_radius and moved_distance-ability02_radius<120) then
				local enemies = FindUnitsInRadius(
						Caster:GetTeamNumber(),
						VecPos,
						nil,
						keys.stun_radius,
						Ability:GetAbilityTargetTeam(),
						Ability:GetAbilityTargetType(),
						Ability:GetAbilityTargetFlags(),
						FIND_CLOSEST,
						false)
				for _,v in pairs(enemies) do
					UtilStun:UnitStunTarget(Caster,v,keys.stun_duration)
				end
				GridNav:DestroyTreesAroundPoint(VecPos, keys.stun_radius, true)
				OnThinkEnd()
				return nil
			end

			GridNav:DestroyTreesAroundPoint(VecPos,keys.hitbox_radius,true)

			tick=tick+1
			if tick>=tick_max then 
				OnThinkEnd()
				return nil 
			end
			return TickInterval
		end,0)
end

function Yasaka02_OnSpellStart(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local radius=keys.radius
	local tick_interval=keys.tick_interval
	local offset=60

	local damage_table={
		victim=nil, 
		attacker=Caster, 
		ability=Ability, 
		damage=Ability:GetAbilityDamage()*tick_interval,
		damage_type=Ability:GetAbilityDamageType(),
	}

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/kanako/ability_kanako_02.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, Caster, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystemTime(effectIndex,keys.duration)

	Ability:ApplyDataDrivenModifier(Caster, Caster, keys.icon_name, {duration=keys.duration})
	local inside_enemies=FindUnitsInRadius(
			Caster:GetTeamNumber(),
			Caster:GetOrigin(),
			nil,
			radius,
			Ability:GetAbilityTargetTeam(),
			Ability:GetAbilityTargetType(),
			Ability:GetAbilityTargetFlags(),
			FIND_ANY_ORDER,
			false)
	for _,v in pairs(inside_enemies) do
		Ability:ApplyDataDrivenModifier(Caster, v, keys.debuff_name, {duration=keys.duration})
	end

	local OnThinkEnd=function ()
		-- 
	end

	Caster:SetContextThink(
		"yasaka02_main_loop",
		function ()
			if GameRules:IsGamePaused() then return 0.03 end
			if Ability:IsNull() or not Caster:HasModifier(keys.icon_name)  then 
				OnThinkEnd()
				return nil
			end
			local origin=Caster:GetOrigin()

			ProjectileManager:ProjectileDodge(Caster)

			for k,v in pairs(inside_enemies) do
				if not v:HasModifier(keys.debuff_name) or v:IsNull() or not v:IsAlive() then
					inside_enemies[k]=nil
				else
					if not v:IsPositionInRange(origin,radius) and (v:HasModifier("modifier_thdots_yugi04_think_interval") == false) and v:IsHero() and v:IsPositionInRange(origin,1000) then
						local new_pos=origin+(origin-v:GetOrigin()):Normalized()*(radius-offset)
						FindClearSpaceForUnit(v, new_pos, true)
						local effectIndex1 = ParticleManager:CreateParticle("particles/econ/events/fall_major_2015/teleport_end_fallmjr_2015_l.vpcf", PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl(effectIndex1, 0, new_pos)
						ParticleManager:SetParticleControl(effectIndex1, 1, new_pos)
						Caster:EmitSound("Hero_Dark_Seer.Ion_Shield_Start")
					end
				end
			end

			local enemies=FindUnitsInRadius(
				Caster:GetTeamNumber(),
				Caster:GetOrigin(),
				nil,
				radius,
				Ability:GetAbilityTargetTeam(),
				Ability:GetAbilityTargetType(),
				Ability:GetAbilityTargetFlags(),
				FIND_ANY_ORDER,
				false)
			for _,v in pairs(enemies) do
				
				if not v:HasModifier(keys.debuff_name) and (v:HasModifier("modifier_thdots_yugi04_think_interval") == false) and v:IsHero() then
					local new_pos=origin+(origin-v:GetOrigin()):Normalized()*(radius+offset)
					FindClearSpaceForUnit(v, new_pos, true)
					local effectIndex2 = ParticleManager:CreateParticle("particles/econ/events/fall_major_2015/teleport_end_fallmjr_2015_l.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(effectIndex2, 0, new_pos)
					ParticleManager:SetParticleControl(effectIndex2, 1, new_pos)
					Caster:EmitSound("Hero_Dark_Seer.Ion_Shield_Start")
				end

				if v:GetTeam() ~= Caster:GetTeam() then
					damage_table.victim=v
					UnitDamageTarget(damage_table)
				end
			end
			return keys.tick_interval
		end,0)
end

function Yasaka03_OnSpellStart(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local caster=keys.caster
	local Target=keys.target
	local target=keys.target
	if Caster:GetTeam()==Target:GetTeam() then
	
	--	Target:Heal(keys.heal_amt + caster:GetAttackDamage(), Caster)
		THDHealTarget(Caster,Target,keys.heal_amt + caster:GetAttackDamage())
	--	SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,Target,keys.heal_amt + caster:GetAttackDamage(),nil)
		Ability:ApplyDataDrivenModifier(Caster, Target, keys.buff_name, {})
	else
		if not is_spell_blocked(Target) then
			Ability:ApplyDataDrivenModifier(Caster, Target, keys.debuff_name, {})
			
		local damage_table = {
			ability = keys.ability,
			victim = target,
			attacker = caster,
			damage = keys.ability:GetAbilityDamage() + caster:GetAttackDamage(),
			damage_type = keys.ability:GetAbilityDamageType(), 
		    damage_flags = keys.ability:GetAbilityTargetFlags()
		}
		UnitDamageTarget(damage_table) 
		
		end
	end
end

function ReplaceAbilities(caster,src,dst)
	local abilitySrc=caster:FindAbilityByName(src)
	local abilityDst=caster:FindAbilityByName(dst)
	if abilitySrc and not abilityDst then
		local lvl=abilitySrc:GetLevel()
		caster:RemoveAbility(src)
		caster:AddAbility(dst)
		abilityDst=caster:FindAbilityByName(dst)
		abilityDst:SetLevel(lvl)
	end
end

function Yakasa04_SwapAbilities(caster,is_ultimate)
	if is_ultimate then
		caster:SetModel("models/thd2/kanako/kanako_mmd_transform.vmdl")
		caster:SetOriginalModel("models/thd2/kanako/kanako_mmd_transform.vmdl")
		ReplaceAbilities(caster,"ability_thdots_yasaka01","ability_thdots_yasaka41")
		ReplaceAbilities(caster,"ability_thdots_yasaka02","ability_thdots_yasaka42")
		ReplaceAbilities(caster,"ability_thdots_yasaka03","ability_thdots_yasaka43")
	else
		caster:RemoveGesture(ACT_DOTA_IDLE)
		caster:SetModel("models/thd2/kanako/kanako_mmd.vmdl")
		caster:SetOriginalModel("models/thd2/kanako/kanako_mmd.vmdl")
		ReplaceAbilities(caster,"ability_thdots_yasaka41","ability_thdots_yasaka01")
		ReplaceAbilities(caster,"ability_thdots_yasaka42","ability_thdots_yasaka02")
		ReplaceAbilities(caster,"ability_thdots_yasaka43","ability_thdots_yasaka03")
	end
end

function Yakasa04_OnChannelSucceeded(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local AbilityEx=Caster:FindAbilityByName("ability_thdots_yasakaEx")

	if not Caster:HasModifier(keys.buff_name) then
		Ability:EndCooldown()
		Ability:ApplyDataDrivenModifier(Caster, Caster, keys.buff_name, {})
		Yakasa04_SwapAbilities(Caster, true)
		if AbilityEx then 
			AbilityEx:SetLevel(2) 
		--	AbilityEx:ApplyDataDrivenModifier(Caster, Caster, "modifier_thdots_yasakaEx_buff", {})
		--	local hBuff=Caster:FindModifierByName("modifier_thdots_yasakaEx_buff")
		--	local exbuff_max_stack=AbilityEx:GetSpecialValueFor("max_stack")
		--	if hBuff and exbuff_max_stack then
		--		hBuff:SetStackCount(exbuff_max_stack)
		--	end
		end

		local OnThinkEnd=function ()
			-- 
		end

		local pos=Caster:GetOrigin()
		Caster:SetContextThink(
			"yasaka04_hold_postion",
			function ()
				if GameRules:IsGamePaused() then return 0.03 end
				if Ability:IsNull() then 
					OnThinkEnd()
					return nil
				end
				if not Caster:HasModifier("modifier_thdots_yasakaEx_buff") then
					AbilityEx:ApplyDataDrivenModifier(Caster, Caster, "modifier_thdots_yasakaEx_buff", {})
				end

				if not Caster:IsPositionInRange(pos,600) then
					pos=Caster:GetOrigin()
				else
					Caster:SetOrigin(pos)
				end

				if not Caster:HasModifier(keys.buff_name) then 
					Yakasa04_SwapAbilities(Caster, false)
					if AbilityEx then AbilityEx:SetLevel(1) end
					OnThinkEnd()
					return nil 
				end
				return 0.03
			end,0)
	else
		Caster:RemoveModifierByName(keys.buff_name)
		Caster:GiveMana(keys.mana_cost)
		local cd=Ability:GetCooldown(Ability:GetLevel())+FindTalentValue(Caster,"special_bonus_unique_zeus")
		Ability:EndCooldown()
		Ability:StartCooldown(cd)
	end
end

function Yakasa04_OnPhaseStart(keys)
	local Caster=keys.caster
	Caster:SetModel("models/thd2/kanako/kanako_mmd_transforming.vmdl")
	Caster:SetOriginalModel("models/thd2/kanako/kanako_mmd_transforming.vmdl")

	if not Caster:HasModifier("modifier_thdots_yasaka04_buff") then
		Caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	else
		Caster:StartGesture(ACT_DOTA_IDLE)
	end
end

function Yakasa04_OnChannelInterrupted(keys)
	local Caster=keys.caster
	if not Caster:HasModifier("modifier_thdots_yasaka04_buff") then
		Caster:SetModel("models/thd2/kanako/kanako_mmd.vmdl")
		Caster:SetOriginalModel("models/thd2/kanako/kanako_mmd.vmdl")
	else
		Caster:SetModel("models/thd2/kanako/kanako_mmd_transforming.vmdl")
		Caster:SetOriginalModel("models/thd2/kanako/kanako_mmd_transforming.vmdl")
	end
	keys.ability:EndCooldown()
end

function Yakasa04_OnChannelFinish(keys)
	local Caster=keys.caster
end

function Yasaka41_OnSpellStart(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local tick_interval=keys.tick_interval
	local rate_tick=keys.rate*keys.tick_interval
	local tick=0
	local last_down_tick=0
	local randomrange = Caster:Script_GetAttackRange()

	damage_table={
		victim=nil, 
		attacker=Caster, 
		damage=Ability:GetAbilityDamage(),
		damage_type=Ability:GetAbilityDamageType(),
	}

	Ability:ApplyDataDrivenModifier(Caster, Caster, keys.icon_name, {})
	local origin=Caster:GetOrigin()

	local OnThinkEnd=function ()
		Caster:RemoveModifierByName(keys.icon_name)
	end

	Caster:SetContextThink(
		"yasaka41_main_loop",
		function ()
			if GameRules:IsGamePaused() then return 0.03 end
			if Ability:IsNull() then 
				OnThinkEnd()
				return nil
			end
			if last_down_tick~=math.floor(tick*rate_tick) then
				last_down_tick=math.floor(tick*rate_tick)
				
				local rdpos=origin+RandomVector(keys.radius)*RandomFloat(0,1)
			--	local rdpos=origin+RandomVector(randomrange)*RandomFloat(0,1)
				local enemies=FindUnitsInRadius(
					Caster:GetTeamNumber(),
					rdpos,
					nil,
					keys.damage_radius,
					Ability:GetAbilityTargetTeam(),
					Ability:GetAbilityTargetType(),
					Ability:GetAbilityTargetFlags(),
					FIND_ANY_ORDER,
					false)
				for _,v in pairs(enemies) do
					damage_table.victim=v
					UnitDamageTarget(damage_table)

					UtilStun:UnitStunTarget(Caster,v,keys.stun_duration)
				end
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/kanako/ability_kanako_041.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(effectIndex, 0, rdpos)
				ParticleManager:SetParticleControl(effectIndex, 1, rdpos)
				ParticleManager:SetParticleControl(effectIndex, 3, rdpos)
				ParticleManager:DestroyParticleSystemTime(effectIndex,1.0)
				Caster:EmitSound("Visage_Familar.StoneForm.Cast")
				GridNav:DestroyTreesAroundPoint(rdpos, keys.damage_radius, true)
			end

			tick=tick+1
			if not Caster:HasModifier(keys.icon_name) then 
				OnThinkEnd()
				return nil 
			end
			return tick_interval
		end,0)
end

function Yasaka42_OnSpellStart(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local TargetPoint=keys.target_points[1]
	local tick_interval=keys.tick_interval
	local max_tick=keys.duration/tick_interval
	local tick=0

	local OnThinkEnd=function ()
		-- 
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/kanako/ability_kanako_042.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(effectIndex, 0, TargetPoint)
	ParticleManager:SetParticleControl(effectIndex, 7, TargetPoint)
	ParticleManager:DestroyParticleSystemTime(effectIndex,keys.duration)

	Caster:SetContextThink(
		"yasaka42_main_loop",
		function ()
			if GameRules:IsGamePaused() then return 0.03 end
			if Ability:IsNull() then 
				OnThinkEnd()
				return nil
			end
			local enemies=FindUnitsInRadius(
				Caster:GetTeamNumber(),
				TargetPoint,
				nil,
				keys.effect_radius,
				Ability:GetAbilityTargetTeam(),
				Ability:GetAbilityTargetType(),
				Ability:GetAbilityTargetFlags(),
				FIND_ANY_ORDER,
				false)
			for _,v in pairs(enemies) do
				Ability:ApplyDataDrivenModifier(Caster, v, keys.debuff_name, {})
			end
			tick=tick+1
			if tick>=max_tick then 
				OnThinkEnd()
				return nil 
			end
			return tick_interval
		end,0)
end

function Yasaka43_OnSpellStart(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local Target=keys.target
	local tick_interval=keys.tick_interval
	local tick_mana_spend=keys.mana_spend*tick_interval

	Target:Purge(false, true, false, true, false)
	Ability:ApplyDataDrivenModifier(Caster, Caster, keys.aura_name, {})

	local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_vine_glow_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(effectIndex, 0, Target:GetOrigin())

	local OnThinkEnd=function ()
		Caster:StopSound("Hero_WitchDoctor.Voodoo_Restoration.Loop")
	end

	Caster:SetContextThink(
		"yasaka43_main_loop",
		function ()
			if GameRules:IsGamePaused() then return 0.03 end
			if Ability:IsNull() then 
				Caster:RemoveModifierByName(keys.aura_name)
				OnThinkEnd()
				return nil
			end
			Caster:SpendMana(tick_mana_spend, Ability)
			if Caster:GetMana()<tick_mana_spend then
				Caster:InterruptChannel()
			end
			if not Caster:IsChanneling() then 
				Caster:RemoveModifierByName(keys.aura_name)
				OnThinkEnd()
				return nil 
			end
			return tick_interval
		end,0)

end
