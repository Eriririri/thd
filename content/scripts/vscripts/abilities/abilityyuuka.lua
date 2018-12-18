ABILITY_YUUKA_FLOWER_UNIT_NAME="ability_yuuka_flower"
ABILITY_YUUKAEX_NAME="ability_thdots_YuukaEx"
ABILITY_YUUKAEX_FLOWER_MODIFIER_NAME="modifier_thdots_yuukaex_flower"
ABILITY_YUUKAEX_FLOWER_BUFF_MODIFIER_NAME="modifier_thdots_yuukaex_flower_buff"
ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME="modifier_thdots_yuukaex_bonus_damage"


g_ability_yuukaex_flowers={}

function YuukaEx_OnCreateFlower(keys)
	local Caster=keys.caster
	local Flower=keys.target
	local AbilityEx=Caster:FindAbilityByName(ABILITY_YUUKAEX_NAME)
	if AbilityEx then
		AbilityEx:ApplyDataDrivenModifier(Caster,Flower,ABILITY_YUUKAEX_FLOWER_BUFF_MODIFIER_NAME,{})
		Flower:SetModifierStackCount(ABILITY_YUUKAEX_FLOWER_BUFF_MODIFIER_NAME,AbilityEx,Caster:GetLevel())

		if not Caster:HasModifier(ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME) then
			AbilityEx:ApplyDataDrivenModifier(Caster,Caster,ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME,{})
		end
		local stack_count=Caster:GetModifierStackCount(ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME,Caster)+1
		Caster:SetModifierStackCount(ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME,AbilityEx,stack_count)

		local illusion=Yuuka04_GetIllusion(Caster)
		if illusion and stack_count>0 then
			if not illusion:HasModifier(ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME) then
				AbilityEx:ApplyDataDrivenModifier(Caster,illusion,ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME,{})
			end
			illusion:SetModifierStackCount(ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME,AbilityEx,stack_count)
		end
	end
	
	
	
end

function YuukaEx_OnDestroyFlower(keys)
	local Caster=keys.caster
	local Flower=keys.target
	local AbilityEx=Caster:FindAbilityByName(ABILITY_YUUKAEX_NAME)

	if AbilityEx then
		local stack_count=Caster:GetModifierStackCount(ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME,Caster)-1
		if stack_count>0 then
			Caster:SetModifierStackCount(ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME,AbilityEx,stack_count)
		else
			Caster:RemoveModifierByNameAndCaster(ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME,Caster)
		end

		local illusion=Yuuka04_GetIllusion(Caster)
		if illusion then
			if stack_count>0 then
				if not illusion:HasModifier(ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME) then
					AbilityEx:ApplyDataDrivenModifier(Caster,illusion,ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME,{})
				end
				illusion:SetModifierStackCount(ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME,AbilityEx,stack_count)
			else
				illusion:RemoveModifierByNameAndCaster(ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME,Caster)
			end
		end
	end
	Flower:SetOrigin(GetGroundPosition(Flower:GetOrigin(), Flower) + Vector(0,0,-200))
	Flower:ForceKill(false)
end

function YuukaCreateFlower(Caster, vecPos, fDuration)
	local AbilityEx=Caster:FindAbilityByName(ABILITY_YUUKAEX_NAME)
	if AbilityEx then
		local flower_unit=CreateUnitByName(
					ABILITY_YUUKA_FLOWER_UNIT_NAME,
					vecPos,
					true,
					Caster,
					Caster,
					Caster:GetTeam())
		flower_unit:SetBaseMaxHealth(flower_unit:GetBaseMaxHealth()+Caster:GetLevel()*AbilityEx:GetSpecialValueFor("flower_hp_per_lvl"))
		flower_unit:SetMana(0)
		flower_unit:SetControllableByPlayer(Caster:GetPlayerOwnerID(), true) 

		

		AbilityEx:ApplyDataDrivenModifier(Caster,flower_unit,ABILITY_YUUKAEX_FLOWER_MODIFIER_NAME,{Duration=fDuration})
		return flower_unit
	end
end

function YuukaEx_IllusionCastAnimation(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local illusion=Yuuka04_GetIllusion(Caster)
	if illusion then
		illusion:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	end
end

function YuukaEx_OnSpellStart(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local Flower=keys.target
	local MaxFlower=keys.MaxFlower
	local playerid=Caster:GetPlayerOwnerID()
	local player_flowers=g_ability_yuukaex_flowers[playerid]
	if not player_flowers then
		player_flowers={}
		g_ability_yuukaex_flowers[playerid]=player_flowers
	end

	local flower=YuukaCreateFlower(Caster, Caster:GetOrigin()+Caster:GetForwardVector()*100, nil)
	if flower then
		table.insert(player_flowers,1,flower)
	end

	local illusion=Yuuka04_GetIllusion(Caster)
	if illusion then
		local flower=YuukaCreateFlower(Caster, illusion:GetOrigin()+illusion:GetForwardVector()*100, nil)
		if flower then
			table.insert(player_flowers,1,flower)
		end
	end

	if flower then
		for i=1,#player_flowers do
			local flower=player_flowers[i]
			if not IsValidEntity(flower) or not flower:IsAlive() then
				table.remove(player_flowers,i)
			elseif i>MaxFlower then
				if IsValidEntity(flower) and flower:IsAlive() then
					flower:ForceKill(false)
				end
				player_flowers[i]=nil
			end
		end
	end
	
	
end

function YuukaEx_FlowerCheckDayNight(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local Target=keys.target

	if Caster and Ability and GameRules:IsDaytime() then
		if not Target:HasModifier(keys.DayBuffName) then
			Ability:ApplyDataDrivenModifier(Target,Target,keys.DayBuffName,{})
		end
		if Target:HasModifier(keys.NightBuffName) then
			Target:RemoveModifierByNameAndCaster(keys.NightBuffName,Target)
		end
	else
		if not Target:HasModifier(keys.NightBuffName) then
			Ability:ApplyDataDrivenModifier(Target,Target,keys.NightBuffName,{})
		end
		if Target:HasModifier(keys.DayBuffName) then
			Target:RemoveModifierByNameAndCaster(keys.DayBuffName,Target)
		end
	end
end

function YuukaEx_FlowerOnDayHealing(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local Target=keys.target
	local illusion=Yuuka04_GetIllusion(Caster)
	if Caster then
		local heal_amount=math.min(Caster:GetMana(),Target:GetMaxHealth()-Target:GetHealth())
		if heal_amount>0 then
			Caster:SpendMana(heal_amount,Ability)
			Target:Heal(heal_amount,Caster)
			SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,Target,heal_amount,nil)
		end
	end
end

function Yuuka01_IllusionCastAnimation(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local illusion=Yuuka04_GetIllusion(Caster)
	if illusion then
		illusion:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	end
end

function Yuuka01_OnSpeelStart(keys)
    local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_tusk_5"))
	local Caster=keys.caster
	local Radius=keys.Radius
	local Duration=keys.Duration
	local FlowerNum=keys.FlowerNum
	local illusion=Yuuka04_GetIllusion(Caster)
	

	for i=1,FlowerNum do
		local radian=(math.pi*2)*(i/FlowerNum)

		local pos=Caster:GetOrigin()
		pos.x=pos.x+math.cos(radian)*Radius
		pos.y=pos.y+math.sin(radian)*Radius
		YuukaCreateFlower(Caster, pos, Duration)

		if illusion then
			local pos=illusion:GetOrigin()
			pos.x=pos.x+math.cos(radian)*Radius
			pos.y=pos.y+math.sin(radian)*Radius
			YuukaCreateFlower(Caster, pos, Duration)
		end
	end

end

function Yuuka02_IllusionCastAnimation(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local Target=keys.target
	local illusion=Yuuka04_GetIllusion(Caster)
	if illusion then
		illusion:StartGesture(ACT_DOTA_CAST_ABILITY_1)
		illusion:SetForwardVector((Target:GetOrigin()-illusion:GetOrigin()):Normalized())
	end
end

function Yuuka02_OnSpellStart(keys)
	if is_spell_blocked(keys.target) then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_oracle")*4)
	local Ability=keys.ability
	local Caster=keys.caster
	local Target=keys.target
	local Duration=keys.Duration
	local StunDuration=keys.StunDuration
	local MoveSpeed=keys.MoveSpeed
	local CreateFlowerInterval=keys.CreateFlowerInterval
	local illusion=Yuuka04_GetIllusion(Caster)
	local vecCaster = Caster:GetOrigin()
	

	local OnTrackingThink = 
		function (vecPos)
			Caster:EmitSound("Hero_Furion.Teleport_Appear")
			YuukaCreateFlower(Caster, vecPos, Duration)
			if (Target:GetOrigin()-vecPos):Length2D()<50 then
				if Target:IsAlive() then
					ApplyDamage{
						ability = Ability,
						victim = Target,
						attacker = Caster,
						damage = Ability:GetAbilityDamage(),
						damage_type = Ability:GetAbilityDamageType()
					}
    				UtilStun:UnitStunTarget(Caster,Target,StunDuration)
				end
				return true
			end
		end

	local time_count=0
	local now_pos=Caster:GetOrigin()
	local now_pos2=nil
	if illusion then 
		now_pos2=illusion:GetOrigin() 
		local vecIllusion = illusion:GetOrigin()
		Caster:SetContextThink(
			"ability_yuuka02_tracking_illusion",
			function ()
				if GameRules:IsGamePaused() then return 0.03 end
				if not IsValidEntity(Target) then return nil end
				time_count=time_count+CreateFlowerInterval

				if now_pos2 then
					now_pos2=now_pos2+(Target:GetOrigin()-now_pos2):Normalized()*MoveSpeed*CreateFlowerInterval
					if (GetDistanceBetweenTwoVec2D(vecIllusion, now_pos2)<=2000) then
						if OnTrackingThink(now_pos2) then
							now_pos2=nil
						end
					end
				end

				if (not now_pos2) or (time_count>Duration) then
					return nil
				end

				return CreateFlowerInterval
			end,0)
	end
	Caster:SetContextThink(
		"ability_yuuka02_tracking",
		function ()
			if GameRules:IsGamePaused() then return 0.03 end
			if not IsValidEntity(Target) then return nil end
			time_count=time_count+CreateFlowerInterval

			if now_pos then
				now_pos=now_pos+(Target:GetOrigin()-now_pos):Normalized()*MoveSpeed*CreateFlowerInterval
				if (GetDistanceBetweenTwoVec2D(vecCaster, now_pos)<=2000) then
					if OnTrackingThink(now_pos) then
						now_pos=nil
					end
				end
			end

			if (not now_pos) or (time_count>Duration) then
				return nil
			end

			return CreateFlowerInterval
		end,0)

end

function Yuuka03_IllusionCastAnimation(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local Point=keys.target_points[1]
	local illusion=Yuuka04_GetIllusion(Caster)
	if illusion then
		illusion:StartGesture(ACT_DOTA_CAST_ABILITY_3)
		illusion:SetForwardVector((Point-illusion:GetOrigin()):Normalized())
	end
end

function Yuuka03_OnSpellStart(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local Point=keys.target_points[1]
	local Radius=keys.Radius
	local Duration=keys.Duration
	local BuffName=keys.BuffName
	local illusion=Yuuka04_GetIllusion(Caster)

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/yuuka/ability_yuuka_03.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(effectIndex, 0, Point)
	ParticleManager:SetParticleControl(effectIndex, 7, Point)
	
	local interval=0.5
	local time_count=0
	Caster:SetContextThink(
		"ability_yuuka03_main",
		function ()
			if GameRules:IsGamePaused() then return 0.03 end
			local flowers=FindUnitsInRadius(
				Caster:GetTeamNumber(),
				Point,
				nil,
				Radius,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER,
				DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
				FIND_ANY_ORDER,
				false)
			for _,v in pairs(flowers) do
				local unit_name=v:GetUnitName()
				if unit_name==ABILITY_YUUKA_FLOWER_UNIT_NAME or unit_name==Caster:GetUnitName() then
					Ability:ApplyDataDrivenModifier(Caster, v, BuffName, {Duration=1})
				end
			end

			time_count=time_count+interval
			if time_count>Duration then return nil end
			return interval
		end,0)
end

function Yuuka04_GetIllusion(Caster)
	if Caster then
		if IsValidEntity(Caster.ability_yuuka04_illusion) and Caster.ability_yuuka04_illusion:IsAlive() then
			return Caster.ability_yuuka04_illusion
		else
			Caster.ability_yuuka04_illusion=nil
		end
	end
end

function Yuuka04_OnSpellStart(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local target=keys.target
	local flower = nil

	THDReduceCooldown(keys.ability,-FindTalentValue(Caster,"special_bonus_unique_warlock_3"))

	if target:GetUnitName()==ABILITY_YUUKA_FLOWER_UNIT_NAME then
		flower = target
	end

	if not flower then 
		Ability:EndCooldown()
		Ability:RefundManaCost()
		return
	end

	--需要注意find出来的flower是否死亡!
	local pos=flower:GetOrigin()

	flower:AddNoDraw()
	flower:ForceKill(true)

	local illusion=Yuuka04_CreateIllusion(keys, pos, keys.IllusionDamageInPct, keys.IllusionDamageOutPct, keys.Duration)

	FindClearSpaceForUnit(Caster,Caster:GetOrigin(),true)
	Caster.ability_yuuka04_illusion=illusion
	local AbilityEx=Caster:FindAbilityByName(ABILITY_YUUKAEX_NAME)
	if AbilityEx and Caster:HasModifier(ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME) then
		if not illusion:HasModifier(ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME) then
			AbilityEx:ApplyDataDrivenModifier(Caster,illusion,ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME,{})
		end

		local stack_count=Caster:GetModifierStackCount(ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME,Caster)
		illusion:SetModifierStackCount(ABILITY_YUUKAEX_BONUS_DAMAGE_MODIFIER_NAME,AbilityEx,stack_count)
	end

end


function Yuuka04_CreateIllusion(keys, illusion_origin, illusion_incoming_damage, illusion_outgoing_damage, illusion_duration)	
	local player_id = keys.caster:GetPlayerID()
	local caster_team = keys.caster:GetTeam()
	
	local illusion = CreateUnitByName(keys.caster:GetUnitName(), illusion_origin, true, keys.caster, nil, caster_team)  --handle_UnitOwner needs to be nil, or else it will crash the game.

	illusion:SetPlayerID(player_id)
	illusion:SetControllableByPlayer(player_id, true)

	--Level up the illusion to the caster's level.
	local caster_level = keys.caster:GetLevel()
	for i = 1, caster_level - 1 do
		illusion:HeroLevelUp(false)
	end

	--Set the illusion's available skill points to 0 and teach it the abilities the caster has.
	illusion:SetAbilityPoints(0)
	for ability_slot = 0, 15 do
		local individual_ability = keys.caster:GetAbilityByIndex(ability_slot)
		if individual_ability ~= nil then 
			local illusion_ability = illusion:FindAbilityByName(individual_ability:GetAbilityName())
			if illusion_ability ~= nil then
				illusion_ability:SetLevel(individual_ability:GetLevel())
			end
		end
	end

	--Recreate the caster's items for the illusion.
	for item_slot = 0, 5 do
		local individual_item = keys.caster:GetItemInSlot(item_slot)
		if individual_item ~= nil then
			local illusion_duplicate_item = CreateItem(individual_item:GetName(), illusion, illusion)
			illusion:AddItem(illusion_duplicate_item)
		end
	end
	
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle 
	illusion:AddNewModifier(keys.caster, keys.ability, "modifier_illusion", {duration = illusion_duration, outgoing_damage = illusion_outgoing_damage, incoming_damage = illusion_incoming_damage})
	
	illusion:MakeIllusion()  --Without MakeIllusion(), the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.  Without it, IsIllusion() returns false and IsRealHero() returns true.

	return illusion
end
