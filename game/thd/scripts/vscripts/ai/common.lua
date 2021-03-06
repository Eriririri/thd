if THTDSystem == nil then
	THTDSystem = {}
end

function CDOTA_BaseNPC:THTD_AI_Init()
	self:SetContextThink(DoUniqueString("thtd_ai_think"), 
		function()
			if self.thtd_close_ai == true or self:HasModifier("modifier_touhoutd_release_hidden") then
				return 0.5
			end
			local func = self["THTD_"..self:GetUnitName().."_thtd_ai"]
			if func then
				func(self)
			elseif self:IsAttacking() == false then
				self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
			end
			return 0.5
		end, 
	0.5)
end

function CDOTA_BaseNPC:IsReadyToCastAbility(ability)--.判断是否可以使用某个技能，太常用了就写了个API，方便简化下代码
	return ability:GetLevel() > 0 and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) and self:IsChanneling()==false
end

function CDOTA_BaseNPC:THTD_lily_thtd_ai()
	local ability = self:FindAbilityByName("thtd_lily_01")
	local ability2 = self:FindAbilityByName("thtd_lily_02")

	if self:IsReadyToCastAbility(ability2) and self:HasModifier("thtd_lily_02") == false then
		local unit = THTDSystem:FindRadiusOneUnit(self, ability2:GetCastRange())
		if unit~=nil and unit:IsNull()==false then 
			self:CastAbilityNoTarget(ability2, self:GetPlayerOwnerID()) 
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_cirno_thtd_ai()
	local ability = self:FindAbilityByName("thtd_cirno_02")

	if self:IsReadyToCastAbility(ability) then
		local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())
		if unit~=nil and unit:IsNull()==false then 
			self:CastAbilityOnTarget(unit, ability, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_letty_thtd_ai()
	local ability = self:FindAbilityByName("thtd_letty_01")

	if self:IsReadyToCastAbility(ability) then 
		local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())
		if unit~=nil and unit:IsNull()==false then 
			self:CastAbilityOnPosition(unit:GetAbsOrigin(), ability, self:GetPlayerOwnerID()) 
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_kogasa_thtd_ai()
	local ability = self:FindAbilityByName("thtd_kogasa_01")

	if self:IsReadyToCastAbility(ability) then 
		local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())
		if unit~=nil and unit:IsNull()==false then 
			self:CastAbilityOnPosition(unit:GetAbsOrigin(), ability, self:GetPlayerOwnerID()) 
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_lyrica_thtd_ai()
	local ability = self:FindAbilityByName("thtd_lyrica_01")

	if self:IsReadyToCastAbility(ability) then 
		local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())
		if unit~=nil and unit:IsNull()==false then 
			self:CastAbilityOnPosition(unit:GetAbsOrigin(), ability, self:GetPlayerOwnerID()) 
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_lunasa_thtd_ai()
	local ability = self:FindAbilityByName("thtd_lunasa_01")

	if self:IsReadyToCastAbility(ability) then 
		local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())
		if unit~=nil and unit:IsNull()==false then 
			self:CastAbilityOnPosition(unit:GetAbsOrigin(), ability, self:GetPlayerOwnerID()) 
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_merlin_thtd_ai()
	local ability = self:FindAbilityByName("thtd_merlin_01")

	if self:IsReadyToCastAbility(ability) then 
		local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())
		if unit~=nil and unit:IsNull()==false then 
			self:CastAbilityOnPosition(unit:GetAbsOrigin(), ability, self:GetPlayerOwnerID()) 
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_satori_thtd_ai()
	local ability = self:FindAbilityByName("thtd_satori_01")

	if self:IsReadyToCastAbility(ability) then 
		local unit = THTDSystem:FindRadiusOneUnitHasNoModifier(self, ability:GetCastRange()+500, "modifier_satori_01_debuff")
		if unit==nil or unit:IsNull()== false then 
			unit = THTDSystem:FindRadiusOneUnit(self, 1000) 
		end
		if unit~=nil and unit:IsNull()==false then 
			local point = nil
			if GetDistance(self, unit) > ability:GetCastRange() then
				local forward = (unit:GetAbsOrigin()-self:GetAbsOrigin()):Normalized()
				point = self:GetAbsOrigin() + forward * ability:GetCastRange()
			else 
				point = unit:GetAbsOrigin()
			end
			self:CastAbilityOnPosition(point, ability, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_iku_thtd_ai()
	local ability = self:FindAbilityByName("thtd_iku_02")

	if self:IsReadyToCastAbility(ability) then 
		local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())
		if unit~=nil and unit:IsNull()==false then 
			self:CastAbilityOnPosition(unit:GetAbsOrigin(), ability, self:GetPlayerOwnerID()) 
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_marisa_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_marisa_01")
	local ability3 = self:FindAbilityByName("thtd_marisa_03")

	if self:IsReadyToCastAbility(ability3) then
		local point = THTDSystem:FindRadiusOnePointPerfectLineAOE(self, ability3:GetCastRange(), 300, 1200, false)
		if point~=nil then
			self:CastAbilityOnPosition(point, ability3, self:GetPlayerOwnerID())
			return
		end
	end

	if ability3:GetLevel() == 0 and self:IsReadyToCastAbility(ability1) then
		local point = THTDSystem:FindRadiusOnePointPerfectLineAOE(self, ability1:GetCastRange(), 300, 1200, false)
		if point~=nil then
			self:CastAbilityOnPosition(point, ability1, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false and self:IsChanneling() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_tenshi_thtd_ai()
	local ability = self:FindAbilityByName("thtd_tenshi_01")

	if self:IsReadyToCastAbility(ability) then
		local _,_,unit = THTDSystem:FindRadiusOnePointPerfectAOE(self, ability:GetCastRange(), 400)
		if unit~=nil and unit:IsNull()==false then 
			self:CastAbilityOnTarget(unit, ability, self:GetPlayerOwnerID()) 
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_patchouli_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_patchouli_01")
	local ability4 = self:FindAbilityByName("thtd_patchouli_04")

	if self:IsReadyToCastAbility(ability1) then 
		local point = nil
		if self.thtd_patchouli_02_type == 1 then
			point = THTDSystem:FindRadiusOnePointPerfectAOE(self, ability1:GetCastRange(), 300)
		elseif self.thtd_patchouli_02_type == 2 then
			local target =  THTDSystem:FindRadiusOneUnitHasNoModifier(self, ability1:GetCastRange(), "modifier_patchouli_01_mercury_poison_debuff")
			if target==nil then 
				target = THTDSystem:FindRadiusOneUnit(self, ability1:GetCastRange()) 
			end
			if target~=nil then 
				point = target:GetAbsOrigin() 
			end
		else
			point = THTDSystem:FindRadiusOnePointPerfectAOE(self, ability1:GetCastRange(), 350)
		end
		if point~=nil then 
			self:CastAbilityOnPosition(point, ability1, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsReadyToCastAbility(ability4) and (THTDSystem:FindRadiusUnitCount(self,800) > 5 or THTDSystem:FindRadiousMostDangerousUnit(self,400)~=nil)  then
		self:CastAbilityNoTarget(ability4, self:GetPlayerOwnerID())
		return
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_reisen_thtd_ai()
	local ability = self:FindAbilityByName("thtd_reisen_03")

	local target = self:GetAttackTarget()
	if target == nil or target:IsNull() == true or target.thtd_is_feared_by_reisen_01 == true then
		target = THTDSystem:FindRadiousMostDangerousUnit(self, self:GetAttackRange(),
			function(targetunit) return targetunit.thtd_is_feared_by_reisen_01~=true end)
		if target~=nil and target:IsNull()==false then 
			THTDSystem:ChangeAttackTarget(self, target) 
		end
	end

	if self:IsReadyToCastAbility(ability) then
		local unit = THTDSystem:FindRadiousMostDangerousUnit(self, self:GetAttackRange()-250,
			function(targetunit) return targetunit.thtd_is_feared_by_reisen_01~=true end)
		if unit~=nil and unit:IsNull()==false then
			self:CastAbilityOnTarget(unit, ability, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_yuyuko_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_yuyuko_01")
	local ability3 = self:FindAbilityByName("thtd_yuyuko_03")

	local target = THTDSystem:FindRadiousMostDangerousUnit(self, ability3:GetCastRange(),
		function (targetunit) return targetunit:GetHealthPercent() <= 30 end)

	if self:IsChanneling() and target==nil then 
		self:InterruptChannel() 
	end

	if self:IsReadyToCastAbility(ability3) and target~=nil and target:IsNull()==false then
		self:CastAbilityOnPosition(target:GetAbsOrigin(), ability3, self:GetPlayerOwnerID())
		return
	end

	if self:IsReadyToCastAbility(ability1) and THTDSystem:FindRadiusUnitCount(self, ability1:GetCastRange())>0 then
		self:CastAbilityNoTarget(ability1, self:GetPlayerOwnerID())
		return
	end

	if self:IsAttacking() == false and self:IsChanneling() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_youmu_thtd_ai()
	local ability = self:FindAbilityByName("thtd_youmu_03")

	if self:IsReadyToCastAbility(ability) then 
		local point = THTDSystem:FindRadiusOnePointPerfectAOE(self, ability:GetCastRange(), 550)
		if point~=nil then 
			self:CastAbilityOnPosition(point, ability, self:GetPlayerOwnerID()) 
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function THTDSystem:FindUtsuhoPerfectPoint(entity, range)
	local unit = THTDSystem:FindRadiousMostDangerousUnit(entity, 400)
	if unit~=nil and unit:IsNull()==false then
		local Point = unit:GetAbsOrigin() + GetUnitBackWardVector(unit, entity:GetPlayerOwnerID()) * 280
		return Point
	end
	local enemies = THTD_FindUnitsInRadius(entity, entity:GetAbsOrigin(), range+350)
	local points = {}
	for k,v in pairs(enemies) do
		if v~=nil and v:IsNull()==false then
			local overlap = false
			local curpoint = v:GetAbsOrigin()
			for x,p in pairs(points) do
				if GetDistanceBetweenTwoVec2D(p, curpoint)<64 then
					overlap = true
					break
				end
			end
			if overlap==false then
				table.insert(points, curpoint)
			end
		end
	end
	local maxSumEffect = 0
	local point = nil
	for k1,p1 in pairs(points) do
		if GetDistanceBetweenTwoVec2D(p1, entity:GetAbsOrigin()) <= range then 
			local sumEffect = 0
			local count = 0
			for k2,p2 in pairs(points) do
				local dist = GetDistanceBetweenTwoVec2D(p1, p2)
				if dist < 350 then
					sumEffect = sumEffect + dist
					count = count + 1
				end
			end
			if sumEffect > maxSumEffect and count > 5 then
				maxSumEffect = sumEffect
				point = p1
			end
		end
	end
	if maxSumEffect > 999 then
		return point
	end
	return nil
end

function CDOTA_BaseNPC:THTD_utsuho_thtd_ai()
	local ability = self:FindAbilityByName("thtd_utsuho_03")

	if self:IsReadyToCastAbility(ability) then
		local point = THTDSystem:FindUtsuhoPerfectPoint(self, ability:GetCastRange())
		if point~=nil then 
			self:CastAbilityOnPosition(point, ability, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false and self:IsChanneling()==false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_rin_thtd_ai()
	local ability = self:FindAbilityByName("thtd_rin_01")

	if self:IsReadyToCastAbility(ability) then
		local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())
		if unit~=nil and unit:IsNull()==false then 
			self:CastAbilityOnTarget(unit, ability, self:GetPlayerOwnerID()) 
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_reimu_thtd_ai()
	local ability = self:FindAbilityByName("thtd_reimu_03")

	if self:IsReadyToCastAbility(ability) then
		local unit = THTDSystem:FindRadiousMostDangerousUnit(self, ability:GetCastRange())
		if unit~=nil and unit:IsNull()==false then 
			self:CastAbilityOnPosition(unit:GetAbsOrigin(), ability, self:GetPlayerOwnerID()) 
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_daiyousei_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_daiyousei_01")
	local ability2 = self:FindAbilityByName("thtd_daiyousei_02")

	if self:IsReadyToCastAbility(ability1) then
		local target = THTDSystem:FindFriendlyHighestStarRadiusOneUnit(self,ability1:GetCastRange())
		if target~=nil and target:THTD_IsTower() then 
			self:CastAbilityOnTarget(target,ability1,self:GetPlayerOwnerID()) 
			return
		end
	end

	if self:IsReadyToCastAbility(ability2) then
		local target = THTDSystem:FindFriendlyRadiusOneUnit(self, 1000)
		if target~=nil and target:THTD_IsTower() then 
			self:CastAbilityNoTarget(ability2,self:GetPlayerOwnerID()) 
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_remilia_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_remilia_01")
	local ability2 = self:FindAbilityByName("thtd_remilia_03")


	if self:IsReadyToCastAbility(ability2) then
		local point,count = THTDSystem:FindRadiusOnePointPerfectLineAOE(self, ability2:GetCastRange(), 300, 2500, false)
		if point~=nil and count>=3 then 
			self:CastAbilityOnPosition(point, ability2, self:GetPlayerOwnerID()) 
			return
		end
	end

	if self:IsReadyToCastAbility(ability1) then
		local point,count,unit = THTDSystem:FindRadiusOnePointPerfectAOE(self, ability1:GetCastRange(), 800)
		if unit~=nil and unit:IsNull()==false then
			self:CastAbilityOnTarget(unit, ability1, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_flandre_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_flandre_01")
	local ability4 = self:FindAbilityByName("thtd_flandre_04")

	if self.thtd_attatck_target==nil or self.thtd_attatck_target:IsNull() or GetDistance(self, self.thtd_attatck_target)>self:GetAttackRange() then
		local target = THTDSystem:FindRadiusWeakOneUnit(self,self:GetAttackRange())
		if target~=nil and target:IsNull()==false and target:IsAlive() then
			self.thtd_attatck_target = target
			THTDSystem:ChangeAttackTarget(self, target)
		end
	end

	if self:IsReadyToCastAbility(ability1) then
		local range = self:GetAttackRange()
		if ability4:GetLevel()>0 then range = ability4:GetCastRange() end
		if THTDSystem:FindRadiusUnitCount(self, range)>0 then
			self:CastAbilityNoTarget(ability1, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsReadyToCastAbility(ability4) then
		local unit = THTDSystem:FindRadiusWeakOneUnit(self, ability4:GetCastRange())
		if unit~=nil and unit:IsNull()==false then
			local damage = self:THTD_GetStar() * self:THTD_GetPower() * 16
			if self:FindAbilityByName("thtd_flandre_03"):GetLevel()>0 then
				damage = damage * (2 - unit:GetHealth()/unit:GetMaxHealth())
			end
			local DamageTable = {
		        victim = unit, 
		        attacker = self, 
		        damage = damage, 
		        damage_type = DAMAGE_TYPE_PHYSICAL, 
		        damage_flags = DOTA_DAMAGE_FLAG_NONE
		   	}
			if unit:GetHealth() < ReturnAfterTaxDamageAfterAbility(DamageTable)/3 then
				self:CastAbilityOnTarget(unit, ability4, self:GetPlayerOwnerID())
				return
			end
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

require( "../abilities/abilitysakuya")

function CDOTA_BaseNPC:NeedRefreshAbility()
	if self:THTD_IsTower() and self:HasModifier("modifier_sakuya_02_buff") == false then
		local targetAbility = nil
		for i=2,5 do
			local ability = self:GetAbilityByIndex(i)
			if ability~=nil and ability:GetAbilityName()~="ability_common_attack_buff" and not IsInSakuya02BlackList(ability) and 
				(ability:GetCooldown(-1)>0 or ability:GetManaCost(-1)>0) then
				targetAbility = ability
			end
		end
		if targetAbility ~= nil then
			if targetAbility:GetCooldownTimeRemaining()/targetAbility:GetCooldown(-1) > 0.35 or --刷新cd，cd剩余在35%以上 
				(targetAbility:GetManaCost(-1) > 0 and self:GetManaPercent() < 60) then--刷新回蓝
				return true
			end
		end
	end
	return false
end

function CDOTA_BaseNPC:THTD_sakuya_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_sakuya_01")
	local ability2 = self:FindAbilityByName("thtd_sakuya_02")
	local ability3 = self:FindAbilityByName("thtd_sakuya_03")
	local target = THTDSystem:FindFriendlyRadiusOneUnitLast(self,ability2:GetCastRange())

	if self:IsReadyToCastAbility(ability2) then
		local target = THTDSystem:FindFriendlyRadiusOneUnitLast(self,ability2:GetCastRange())
		if target~=nil and target:IsNull()==false and target:THTD_IsTower() and target:NeedRefreshAbility() then
			self:CastAbilityOnTarget(target,ability2,self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsReadyToCastAbility(ability3) and (THTDSystem:FindRadiusUnitCount(self, 800)>5 or THTDSystem:FindRadiousMostDangerousUnit(self,400)~=nil ) then
		self:CastAbilityNoTarget(ability3, self:GetPlayerOwnerID())
		return
	end

	if self:IsReadyToCastAbility(ability1) then
		local unit = THTDSystem:FindRadiusOneUnit(self,ability1:GetCastRange())
		if unit~=nil and unit:IsNull()==false then
			self:CastAbilityOnTarget(unit, ability1, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_koishi_thtd_ai()
	local ability3 = self:FindAbilityByName("thtd_koishi_03")
	local ability4 = self:FindAbilityByName("thtd_koishi_04")

	if self:IsReadyToCastAbility(ability3) and THTDSystem:FindRadiusUnitCount(self, self:GetAttackRange())>0 then
		local target = THTDSystem:FindFriendlyRadiusOneUnitLast(self, ability3:GetCastRange())
		if target~=nil and target:IsNull()==false and target:THTD_IsTower() and target.thtd_koishi_03_bonus~=true then
			self:CastAbilityOnTarget(target, ability3, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsReadyToCastAbility(ability4) and THTDSystem:FindRadiusUnitCount(self, self:GetAttackRange())>0 then
		self:CastAbilityNoTarget(ability4, self:GetPlayerOwnerID())
		return
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_koakuma_thtd_ai()
	local ability = self:FindAbilityByName("thtd_koakuma_01")

	if self:IsReadyToCastAbility(ability) then
		local unit = THTDSystem:FindRadiusOneUnit(self, 800)
		if unit~=nil and unit:IsNull()==false then
			self:CastAbilityOnTarget(unit, ability, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_meirin_thtd_ai()

end

function CDOTA_BaseNPC:THTD_yuuka_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_yuuka_01")
	local ability4 = self:FindAbilityByName("thtd_yuuka_04")

	if self:IsReadyToCastAbility(ability1) and THTDSystem:FindRadiusUnitCount(self, 800) > 0 then
		self:CastAbilityNoTarget(ability1, self:GetPlayerOwnerID())
		return
	end

	if self:IsReadyToCastAbility(ability4) then
		local point,count = THTDSystem:FindRadiusOnePointPerfectLineAOE(self, ability4:GetCastRange(), 300, 1000, false)
		if point~=nil and count >= 5 then
			self:CastAbilityOnPosition(point, ability4, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false and self:IsChanneling() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_yukari_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_yukari_01")
	local ability2 = self:FindAbilityByName("thtd_yukari_02")
	local ability4 = self:FindAbilityByName("thtd_yukari_04")

	if self.thtd_yukari_01_hidden_table == nil then
		self.thtd_yukari_01_hidden_table = {}
	end
	
	if self.thtd_yukari_01_stock == nil then
		self.thtd_yukari_01_stock = 3
	end

	if self:IsReadyToCastAbility(ability4) and (#THTD_FindUnitsInner(self)>=12 or THTDSystem:FindRadiousMostDangerousUnit(self,400)~=nil) then
		self:CastAbilityNoTarget(ability4, self:GetPlayerOwnerID())
		return
	end

	if self:IsReadyToCastAbility(ability1) and #self.thtd_yukari_01_hidden_table < self.thtd_yukari_01_stock then
		local unit = THTDSystem:FindRadiousMostDangerousUnit(self, ability1:GetCastRange()-200,
			function(targetunit) return (targetunit.thtd_yukari_01_hidden_count == nil or targetunit.thtd_yukari_01_hidden_count < 2) end)
		if unit~=nil and unit:IsNull()==false then
			self:CastAbilityOnTarget(unit, ability1, self:GetPlayerOwnerID())
		end
	end

	if self:IsReadyToCastAbility(ability2) and #self.thtd_yukari_01_hidden_table > 0 then
		local point = THTDSystem:FindRadiusOnePointPerfectAOE(self, ability2:GetCastRange(), 300)
		if point == nil then
			point = self:GetAbsOrigin() + ability2:GetCastRange() * GetUnitBackWardVector(self, self:GetPlayerOwnerID())
		end
		self:CastAbilityOnPosition(point, ability2, self:GetPlayerOwnerID())
		return
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_ran_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_ran_01")
	local ability2 = self:FindAbilityByName("thtd_ran_02")

	if self:IsReadyToCastAbility(ability2) and THTDSystem:FindRadiusUnitCount(self, self:GetAttackRange())>0 then
		self:CastAbilityNoTarget(ability2, self:GetPlayerOwnerID())
		-- ability2:CastAbility()
		return
	end

	if self:IsReadyToCastAbility(ability1) then
		local unit = THTDSystem:FindRadiusOneUnit(self,ability1:GetCastRange())
		if unit~=nil and unit:IsNull()==false then
			self:CastAbilityOnTarget(unit, ability1, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_chen_thtd_ai()
	local ability = self:FindAbilityByName("thtd_chen_01")

	if self:IsReadyToCastAbility(ability) and THTDSystem:FindRadiusUnitCount(self, ability:GetCastRange())>0 then
		if self.thtd_chen_01_last_origin ~= nil and GetDistanceBetweenTwoVec2D(self.thtd_chen_01_last_origin, self:GetAbsOrigin()) <= ability:GetCastRange() then
			self:CastAbilityOnPosition(self.thtd_chen_01_last_origin, ability, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_eirin_thtd_ai()
	local ability3 = self:FindAbilityByName("thtd_eirin_03")
	local ability4 = self:FindAbilityByName("thtd_eirin_04")

	if self:IsReadyToCastAbility(ability3) then
		local point, count = nil, 0
		local unit = THTDSystem:FindRadiousMostDangerousUnit(self, 400)
		if unit~=nil and unit:IsNull()==false then
			point = unit:GetAbsOrigin() + 350 * GetUnitBackWardVector(unit, self:GetPlayerOwnerID())
		else
			point, count = THTDSystem:FindRadiusOnePointPerfectAOE(self, ability3:GetCastRange(), 400)
			if count < 5 then point=nil end
		end
		if point~=nil then 
			self:CastAbilityOnPosition(point, ability3, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsReadyToCastAbility(ability4) then
		if self.thtd_eirin_03_position~=nil and THTDSystem:FindRadiusUnitCountInPoint(self, 400, self.thtd_eirin_03_position) > 4 then
			self:CastAbilityOnPosition(self.thtd_eirin_03_position, ability4, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_mokou_thtd_ai()
	local ability = self:FindAbilityByName("thtd_mokou_03")

	if self:IsReadyToCastAbility(ability) and THTDSystem:FindRadiusUnitCount(self, self:GetAttackRange())>0 then
		self:CastAbilityNoTarget(ability, self:GetPlayerOwnerID())
		return
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_kaguya_thtd_ai()
	local ability = self:FindAbilityByName("thtd_kaguya_01")

	if self:IsReadyToCastAbility(ability) then 
		local unit = THTDSystem:FindRadiusOneUnit(self, ability:GetCastRange())
		if unit~=nil and unit:IsNull()==false then 
			self:CastAbilityOnPosition(unit:GetAbsOrigin(), ability, self:GetPlayerOwnerID()) 
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_aya_thtd_ai()
	local ability = self:FindAbilityByName("thtd_aya_02")

	if self:IsReadyToCastAbility(ability) then
		local point = THTDSystem:FindRadiusOnePointPerfectLineAOE(self, 6666, 300, 1500, true)
		if point~=nil then
			local forward = (point - self:GetAbsOrigin()):Normalized()
			local dist = GetDistanceBetweenTwoVec2D(self:GetAbsOrigin() ,point)
			point = self:GetAbsOrigin() + (dist + 200) * forward
			self:CastAbilityOnPosition(point, ability, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_hatate_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_hatate_01")
	local ability2 = self:FindAbilityByName("thtd_hatate_02")

	if self:IsReadyToCastAbility(ability1) then
		local unit = THTDSystem:FindRadiusOneUnit(self,ability1:GetCastRange())
		if unit~=nil and unit:IsNull()==false then
			self:CastAbilityOnPosition(unit:GetAbsOrigin(), ability1, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsReadyToCastAbility(ability2) and #THTD_FindUnitsInner(self) >= 10 then
		self:CastAbilityNoTarget(ability2, self:GetPlayerOwnerID())
		return
	end

	if self:IsAttacking() == false and self:IsChanneling() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_sanae_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_sanae_01")
	local ability2 = self:FindAbilityByName("thtd_sanae_02")
	local ability3 = self:FindAbilityByName("thtd_sanae_03")
	local ability4 = self:FindAbilityByName("thtd_sanae_04")

	if self:IsReadyToCastAbility(ability4) and THTDSystem:FindRadiusOneUnit(self, self:GetAttackRange())~=nil and self:HasModifier("modifier_sanae_04_buff")==false then
		self:CastAbilityNoTarget(ability4, self:GetPlayerOwnerID())
		return
	end

	if self:IsReadyToCastAbility(ability2) then
		local point = THTDSystem:FindRadiusOnePointPerfectAOE(self, ability2:GetCastRange(), 300)
		if point~=nil then
			self:CastAbilityOnPosition(point, ability2, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsReadyToCastAbility(ability1) and THTDSystem:FindRadiusOneUnit(self, self:GetAttackRange())~=nil then
		local target = THTDSystem:FindFriendlyRadiusOneUnitLast(self, 800)
		if target~=nil and target:IsNull()==false and target:THTD_IsTower() and target.thtd_sanae_01_bonus~=true then
			self:CastAbilityOnTarget(target, ability1, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsReadyToCastAbility(ability3) then
		local point, count = nil, 0
		local unit = THTDSystem:FindRadiousMostDangerousUnit(self, 400)
		if unit~=nil and unit:IsNull()==false then
			point = unit:GetAbsOrigin() + 250 * GetUnitBackWardVector(unit, self:GetPlayerOwnerID())
		else
			point, count = THTDSystem:FindRadiusOnePointPerfectAOE(self, ability3:GetCastRange(), 400)
			if count < 5 then point=nil end
		end
		if point~=nil then 
			self:CastAbilityOnPosition(point, ability3, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_kanako_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_kanako_01")
	local ability4 = self:FindAbilityByName("thtd_kanako_04")

	if self:IsReadyToCastAbility(ability4) and THTDSystem:FindRadiusOneUnit(self,750)~=nil then
		self:CastAbilityNoTarget(ability4, self:GetPlayerOwnerID())
		return
	end

	if self:IsReadyToCastAbility(ability1) then
		local unit = THTDSystem:FindRadiousMostDangerousUnit(self, 600, 
			function(targetunit) return targetunit.thtd_is_kanako_knockback~=true end)
		if unit~=nil and unit:IsNull()==false then
			self:CastAbilityOnTarget(unit, ability1, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_momiji_thtd_ai()
	local ability = self:FindAbilityByName("thtd_momiji_01")

	if self:IsReadyToCastAbility(ability) and THTDSystem:FindRadiusUnitCount(self, self:GetAttackRange())>0 then
		self:CastAbilityNoTarget(ability, self:GetPlayerOwnerID())
		return
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_minamitsu_thtd_ai()
	local ability2 = self:FindAbilityByName("thtd_minamitsu_02")
	local ability3 = self:FindAbilityByName("thtd_minamitsu_03")
	local ability4 = self:FindAbilityByName("thtd_minamitsu_04")

	if self:IsReadyToCastAbility(ability2) and THTDSystem:FindRadiusUnitCount(self, self:GetAttackRange())>0 then
		self:CastAbilityNoTarget(ability2, self:GetPlayerOwnerID())
		return
	end

	if self:IsReadyToCastAbility(ability3) then
		local unit = THTDSystem:FindRadiousMostDangerousUnit(self, ability3:GetCastRange(),
			function(targetunit) return targetunit:HasModifier("modifier_minamitsu_01_slow_buff") end)
		if unit~=nil and unit:IsNull()==false then
			self:CastAbilityOnPosition(unit:GetAbsOrigin(), ability3, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsReadyToCastAbility(ability4) then
		local unit = THTDSystem:FindRadiousMostDangerousUnit(self, self:GetAttackRange(),
			function(targetunit) return targetunit:HasModifier("modifier_minamitsu_01_slow_buff") end)
		if unit~=nil and unit:IsNull()==false then
			self:CastAbilityNoTarget(ability4, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_nue_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_nue_01")
	local ability2 = self:FindAbilityByName("thtd_nue_02")

	if self:IsReadyToCastAbility(ability1) and ability2:IsInAbilityPhase() == false then
		local range = self:GetAttackRange()
		if ability2:GetLevel()>0 then range = ability2:GetCastRange() end
		if THTDSystem:FindRadiusUnitCount(self, range)>0 then
			self:CastAbilityNoTarget(ability1, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsReadyToCastAbility(ability2) and ability2:IsInAbilityPhase() == false then
		local unit = THTDSystem:FindRadiusWeakOneUnit(self, ability2:GetCastRange())
		if unit~=nil and unit:IsNull()==false and unit:IsAlive() then
			self:CastAbilityOnPosition(unit:GetAbsOrigin(), ability2, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false and ability2:IsInAbilityPhase() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_toramaru_thtd_ai()
	local ability = self:FindAbilityByName("thtd_toramaru_01")

	if self:IsReadyToCastAbility(ability) then
		local unit = THTDSystem:FindRadiusOneUnit(self, ability:GetCastRange())
		if unit~=nil and unit:IsNull()==false then
			self:CastAbilityOnTarget(unit, ability, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_suwako_thtd_ai()
	local ability = self:FindAbilityByName("thtd_suwako_03")

	if self:IsReadyToCastAbility(ability) then
		local unit = THTDSystem:FindRadiusOneUnit(self, 500)
		if unit~=nil and unit:IsNull()==false then
			self:CastAbilityNoTarget(ability, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_soga_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_soga_01")
	local ability2 = self:FindAbilityByName("thtd_soga_02")
	local ability3 = self:FindAbilityByName("thtd_soga_03")

	if self:IsReadyToCastAbility(ability1) then
		local unit1 = THTDSystem:FindRadiousMostDangerousUnit(self, ability1:GetCastRange())
		if unit1~=nil and unit1:IsNull()==false then
			self:CastAbilityOnPosition(unit1:GetAbsOrigin(),ability1,self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsReadyToCastAbility(ability2) then
		local point2 =  THTDSystem:FindRadiusOnePointPerfectAOE(self, ability2:GetCastRange(), 300)
		if point2~=nil then
			self:CastAbilityOnPosition(point2,ability2, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsReadyToCastAbility(ability3) then
		local point3, count3 =  THTDSystem:FindRadiusOnePointPerfectAOE(self, ability3:GetCastRange(), 500)
		if point3~=nil and count3>4 then
			self:CastAbilityOnPosition(point3,ability3,self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_futo_thtd_ai()
	local ability = self:FindAbilityByName("thtd_futo_03")

	if self:IsReadyToCastAbility(ability) then
		local point, count = THTDSystem:FindRadiusOnePointPerfectAOE(self, ability:GetCastRange(), 1000)
		if point~=nil and count>5 then
			self:CastAbilityOnPosition(point, ability, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_miko_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_miko_01")
	local ability4 = self:FindAbilityByName("thtd_miko_04")

	if self:IsReadyToCastAbility(ability4) and ability4:IsInAbilityPhase() == false and #THTD_FindUnitsInner(self) >= 5 then
		self:CastAbilityNoTarget(ability4, self:GetPlayerOwnerID())
		return
	end

	if self:IsReadyToCastAbility(ability1) and ability1:IsInAbilityPhase() == false and THTDSystem:FindRadiusUnitCount(self,1000)>0 then
		self:CastAbilityNoTarget(ability1, self:GetPlayerOwnerID())
		return
	end

	if self:IsAttacking() == false and ability1:IsInAbilityPhase() == false and ability4:IsInAbilityPhase() == false and self:IsChanneling() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_yoshika_thtd_ai()
	local ability = self:FindAbilityByName("thtd_yoshika_02")

	local target = self:GetAttackTarget()
	if target==nil or target:IsNull() or target:HasModifier("modifier_yoshika_01_slow") then
		target = THTDSystem:FindRadiusOneUnitHasNoModifier(self, self:GetAttackRange(), "modifier_yoshika_01_slow")
		if target~=nil and target:IsNull()==false then 
			THTDSystem:ChangeAttackTarget(self,target) 
		end
	end

	if self:IsReadyToCastAbility(ability) and #THTD_FindUnitsInner(self)>0 then
		self:CastAbilityNoTarget(ability, self:GetPlayerOwnerID())
		return
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_seiga_thtd_ai()
	local ability2 = self:FindAbilityByName("thtd_seiga_02")

	if self:IsReadyToCastAbility(ability2) and THTDSystem:FindRadiusUnitCount(self, self:GetAttackRange())>0 then
		local target = THTDSystem:FindFriendlyRadiusOneUnitLast(self,ability2:GetCastRange())
		if target~=nil and target:IsNull()==false and target:THTD_IsTower() then
			self:CastAbilityOnTarget(target,ability2,self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_keine_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_keine_01")
	local ability2 = self:FindAbilityByName("thtd_keine_02")
	local ability3 = self:FindAbilityByName("thtd_keine_03")

	local target = self:GetAttackTarget()
	if target==nil or target:IsNull() or target:HasModifier("thtd_keine_03_debuff") then
		target = THTDSystem:FindRadiousMostDangerousUnit(self, self:GetAttackRange(), 
			function (targetunit) return targetunit:HasModifier("thtd_keine_03_debuff")==false end)
		if target~=nil and target:IsNull()==false then
			THTDSystem:ChangeAttackTarget(self, target)
		end
	end

	if self:IsReadyToCastAbility(ability1) and self.thtd_keine_change~=2 and THTDSystem:FindRadiusUnitCount(self, self:GetAttackRange())>0 then
		local target1 = THTDSystem:FindFriendlyRadiusOneUnitLast(self,ability1:GetCastRange())
		if target1~=nil and target1:IsNull()==false and target1:THTD_IsTower() and target1.thtd_keine_01_open~=true then
			self:CastAbilityOnTarget(target1,ability1,self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsReadyToCastAbility(ability3) and self.thtd_keine_change==1 then
		local point3 = THTDSystem:FindRadiusOnePointPerfectAOE(self, ability3:GetCastRange(), 1000)
		if point3~=nil then
			self:CastAbilityOnPosition(point3, ability3, self:GetPlayerOwnerID())
			return
		end
	end 

	if self:IsReadyToCastAbility(ability2) then
		local unit = THTDSystem:FindRadiusOneUnit(self, self:GetAttackRange())
		if (self.thtd_keine_change == 1 and ability1:GetCooldownTimeRemaining() > 5 and unit ~= nil) or 
			(self.thtd_keine_change == 2 and (ability1:IsCooldownReady() or unit == nil) ) 
		then
			self:CastAbilityNoTarget(ability2, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_medicine_thtd_ai()
	local ability2 = self:FindAbilityByName("thtd_medicine_02")

	local target = self:GetAttackTarget()
	if target==nil or target:IsNull() or target:HasModifier("modifier_medicine_01_slow") then
		target = THTDSystem:FindRadiousMostDangerousUnit(self, self:GetAttackRange(), 
			function (targetunit) return targetunit:HasModifier("modifier_medicine_01_slow")==false end)
		if target~=nil and target:IsNull()==false then
			THTDSystem:ChangeAttackTarget(self, target)
		end
	end

	if self:IsReadyToCastAbility(ability2) then
		local point, count = nil, 0
		local unit = THTDSystem:FindRadiousMostDangerousUnit(self, 400,
			function(targetunit) return targetunit.thtd_medicine_move_lock~=true end)
		if unit~=nil and unit:IsNull()==false then
			point = unit:GetAbsOrigin() + 350*GetUnitBackWardVector(unit,self:GetPlayerOwnerID())
		else
			point = THTDSystem:FindRadiusOnePointPerfectAOE(self, ability2:GetCastRange(), 400)
		end
		if point~=nil then
			self:CastAbilityOnPosition(point, ability2, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_luna_thtd_ai()
	local ability2 = self:FindAbilityByName("thtd_luna_02")

	if self:IsReadyToCastAbility(ability2) and self.thtd_luna_02_bonus~=true then
		local point,count = THTDSystem:FindRadiusOnePointPerfectLineAOE(self, ability2:GetCastRange(), 200, 1000, false)
		if point~=nil and count>=3 then
			self:CastAbilityOnPosition(point, ability2, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_sunny_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_sunny_01")
	local ability2 = self:FindAbilityByName("thtd_sunny_02")

	if self:IsReadyToCastAbility(ability2) then
		local point = THTDSystem:FindRadiusOnePointPerfectAOE(self, ability2:GetCastRange(), 300)
		if point~=nil then
			self:CastAbilityOnPosition(point, ability2, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsReadyToCastAbility(ability1) then
		local unit = THTDSystem:FindRadiusOneUnit(self, ability1:GetCastRange())
		if unit~=nil and unit:IsNull()==false then
			self:CastAbilityOnTarget(unit, ability1, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_star_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_star_01")
	local ability2 = self:FindAbilityByName("thtd_star_02")

	if self:IsReadyToCastAbility(ability1) then
		local unit = THTDSystem:FindRadiusOneUnit(self, ability1:GetCastRange())
		if unit~=nil and unit:IsNull()==false then
			self:CastAbilityOnPosition(unit:GetAbsOrigin(), ability1, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsReadyToCastAbility(ability2) then
		local unit = THTDSystem:FindRadiusOneUnit(self, ability2:GetCastRange())
		if unit~=nil and unit:IsNull()==false then
			self:CastAbilityOnPosition(unit:GetAbsOrigin(), ability2, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_suika_thtd_ai()
	local ability3 = self:FindAbilityByName("thtd_suika_03")
	local ability4 = self:FindAbilityByName("thtd_suika_04")
	local unit = THTDSystem:FindRadiusOneUnit(self,800)

	if self:IsReadyToCastAbility(ability3) then
		local unit = THTDSystem:FindRadiusOneUnit(self, 800)
		if unit~=nil and unit:IsNull()==false then
			self:CastAbilityOnTarget(unit, ability3, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsReadyToCastAbility(ability4) then
		local unit = THTDSystem:FindRadiusOneUnit(self, 800)
		if unit~=nil and unit:IsNull()==false then
			self:CastAbilityOnTarget(unit, ability4, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_yuugi_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_yuugi_01")
	local ability3 = self:FindAbilityByName("thtd_yuugi_03")

	local target = self:GetAttackTarget()
	if target == nil or target:IsNull() == true then
		target = THTDSystem:FindRadiousMostDangerousUnit(self, self:GetAttackRange())
		if target~=nil and target:IsNull()==false then 
			THTDSystem:ChangeAttackTarget(self, target) 
		end
	end

	if self:IsReadyToCastAbility(ability1) and THTDSystem:FindRadiusUnitCount(self, self:GetAttackRange())>0 then
		self:CastAbilityNoTarget(ability1, self:GetPlayerOwnerID())
		return
	end

	if self:IsReadyToCastAbility(ability3) then
		local point, count = nil, 0
		local unit = THTDSystem:FindRadiousMostDangerousUnit(self, 400)
		if unit~=nil and unit:IsNull()==false then
			point = unit:GetAbsOrigin() + 450 * GetUnitBackWardVector(unit, self:GetPlayerOwnerID())
		else
			point, count = THTDSystem:FindRadiusOnePointPerfectAOE(self, ability3:GetCastRange(), 500)
			if count < 7 then point=nil end
		end
		if point~=nil then
			self:CastAbilityOnPosition(point, ability3, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_junko_thtd_ai()
	local ability2 = self:FindAbilityByName("thtd_junko_02")
	local ability3 = self:FindAbilityByName("thtd_junko_03")

	if self:IsReadyToCastAbility(ability2) and THTDSystem:FindRadiusUnitCount(self, 1000)>=3 then
		self:CastAbilityNoTarget(ability2, self:GetPlayerOwnerID())
		return
	end

	if self:IsReadyToCastAbility(ability3) then
		local point,count = THTDSystem:FindRadiusOnePointPerfectAOE(self, ability3:GetCastRange(), 500)
		if point~=nil and count>=3 then
			self:CastAbilityOnPosition(point, ability3, self:GetPlayerOwnerID())
			return
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function THTDSystem:CastAbility(unit,ability)
	if ability:IsUnitTarget() then
		local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	    local types =  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	    local flags = 0
	    local target = THTDSystem:FindRadiusOneUnit( unit,ability:GetCastRange(),teams,types,flags)
		if target then
			unit:CastAbilityOnTarget(target,ability,target:GetPlayerOwnerID())
		end
	elseif ability:IsPoint() or ability:GetBehavior() == 24 then
		local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	    local types =  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	    local flags = 0
	    local target = THTDSystem:FindRadiusOneUnit( unit,ability:GetCastRange(),teams,types,flags)
	    if target then
			unit:CastAbilityOnPosition(target:GetOrigin(),ability,target:GetPlayerOwnerID())
		end
	elseif ability:IsNoTarget() then
		ability:CastAbility()
	end
end

function THTDSystem:CastAbilityFriendly( unit,ability)
	if ability:IsUnitTarget() then
		local teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	    local types =  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	    local flags = 0
	    local target = THTDSystem:FindFriendlyRadiusOneUnit( unit,ability:GetCastRange(),teams,types,flags)
		if target then
			unit:CastAbilityOnTarget(target,ability,target:GetPlayerOwnerID())
		end
	elseif ability:IsPoint() or ability:GetBehavior() == 24 then
		local teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	    local types =  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	    local flags = 0
	    local target = THTDSystem:FindFriendlyRadiusOneUnit( unit,ability:GetCastRange(),teams,types,flags)
	    if target then
			unit:CastAbilityOnPosition(target:GetOrigin(),ability,target:GetPlayerOwnerID())
		end
	elseif ability:IsNoTarget() then
		ability:CastAbility()
	end
end

function THTDSystem:CastAbilityToUnit( unit,ability,target)
	if ability:IsUnitTarget() then
		unit:CastAbilityOnTarget(target,ability,target:GetPlayerOwnerID())
	elseif ability:IsPoint() or ability:GetBehavior() == 24 then
		unit:CastAbilityOnPosition(target:GetOrigin(),ability,target:GetPlayerOwnerID())
	end
end


function THTDSystem:FindRadiusOneUnit( entity, range)
	local enemies = THTD_FindUnitsInRadius(entity, entity:GetOrigin(), range)
	if #enemies > 0 then
		local index = RandomInt( 1, #enemies )
		return enemies[index]
	else
		return nil
	end
end

function THTDSystem:FindRadiusOneUnitHasNoModifier(entity,range,modifierName)
	local enemies = THTD_FindUnitsInRadius(entity, entity:GetOrigin(), range)
	if #enemies > 0 then
		for k,v in pairs(enemies) do
			if v:HasModifier(modifierName) ~= true then
				return v
			end
		end
		return nil
	else
		return nil
	end
end

function THTDSystem:FindRadiusUnitCount( entity, range)
	local enemies = THTD_FindUnitsInRadius(entity, entity:GetOrigin(), range)
	if #enemies > 0 then
		return #enemies
	else
		return 0
	end
end

function THTDSystem:FindRadiusUnitCountInPoint( entity, range, point)
	local enemies = THTD_FindUnitsInRadius(entity, point, range)
	if #enemies > 0 then
		return #enemies
	else
		return 0
	end
end

function GetLeftRightSide(a,b,p)--.用向量的叉乘判断p在有向直线ab的左边还是右边，直线ab将平面分成两块左边和右边
	return (b.x-a.x) * (p.y-a.y) - (p.x-a.x) * (b.y-a.y)
end

function IsInQuadrangle(point, a, b, c, d)--.循环判断p是否在有向直线ab,bc,cd,da的同向，这些直线的左边或者右边构成这个四边形
	local ab_side = GetLeftRightSide(a,b,point)
	local bc_side = GetLeftRightSide(b,c,point)
	local cd_side = GetLeftRightSide(c,d,point)
	local da_side = GetLeftRightSide(d,a,point)
	return (ab_side>=0 and bc_side>=0 and cd_side>=0 and da_side>=0) or (ab_side<=0 and bc_side<=0 and cd_side<=0 and da_side<=0)
end

function THTD_FindUnitsInLine(caster, point, forward, width, length)
--.这三个函数貌似都应该放到上层的common.lua文件中 方便一些人物技能调用 这里的width不是长方形的宽，而是直线技能得左右宽度
	if caster:THTD_IsTower() then
		forward = forward:Normalized()
		local orth_Vec = Vector(forward.y, -forward.x, 0)
		local a = point + orth_Vec * width
		local b = a + forward * length
		local c = b - orth_Vec * width * 2
		local d = c - forward * length
		local targets = {}
		local enemies = THTD_FindUnitsAll(caster)
		for _,v in pairs(enemies) do
			if v~=nil and v:IsNull()==false and IsInQuadrangle(v:GetAbsOrigin(), a, b, c, d) then
				table.insert(targets, v)
			end 
		end
		return targets
	end
end

function THTDSystem:FindRadiusUnitCountInLine(entity, point, forward, width, length)
	local enemies = THTD_FindUnitsInLine(entity, point, forward, width, length)
	if #enemies > 0 then
		return #enemies
	else
		return 0
	end
end

function THTDSystem:FindFriendlyRadiusOneUnitLast( entity, range)
	local friends = THTD_FindFriendlyUnitsInRadius(entity,entity:GetOrigin(),range)
	if #friends > 0 then
		if entity.thtd_last_cast_unit ~= nil and entity.thtd_last_cast_unit:IsNull() == false and entity.thtd_last_cast_unit:IsAlive() and GetDistanceBetweenTwoVec2D(entity:GetOrigin(),entity.thtd_last_cast_unit:GetOrigin()) <= range then
			return entity.thtd_last_cast_unit
		end
		local index = RandomInt( 1, #friends )
		return friends[index]
	else
		return nil
	end
end

function THTDSystem:FindRadiusWeakOneUnit( entity, range)
	local enemies = THTD_FindUnitsInRadius(entity, entity:GetOrigin(), range)
	if #enemies > 0 then
		local weakUnit = nil
		for k,v in pairs(enemies) do
			if v:GetHealth() > 0 then
				if weakUnit == nil then
					weakUnit = v
				end
				if v~=nil and v:IsNull()==false and v:IsAlive() and weakUnit~=nil and weakUnit:IsNull()==false and weakUnit:IsAlive() then
					if v:GetHealth() < weakUnit:GetHealth() then
						weakUnit = v
					end
				end
			end
		end
		return weakUnit
	else
		return nil
	end
end

function THTDSystem:FindRadiusLonelyOneUnit( entity, range , lonelyCount)
	local enemies = THTD_FindUnitsInRadius(entity, entity:GetOrigin(), range)
	if #enemies > 0 then
		local lonelyUnit = nil
		for k,v in pairs(enemies) do
			local units = THTD_FindFriendlyUnitsInRadius(entity,v:GetOrigin(),range)
			if #units <= lonelyCount then
				lonelyUnit = v
				break
			end
		end
		return lonelyUnit
	else
		return nil
	end
end

function THTDSystem:FindFriendlyRadiusOneUnit( entity, range)
	local friends = THTD_FindFriendlyUnitsInRadius(entity,entity:GetOrigin(),range)
	if #friends > 0 then
		local index = RandomInt( 1, #friends )
		return friends[index]
	else
		return nil
	end
end
function THTDSystem:FindFriendlyHighestStarRadiusOneUnit( entity, range)
	local friends = THTD_FindFriendlyUnitsInRadius(entity,entity:GetOrigin(),range)
	if #friends > 0 then
		local highestUnit = nil
		for k,v in pairs(friends) do
			if v:THTD_IsTower() and v~=entity and v:THTD_GetLevel()<10 then
				if highestUnit == nil then
					highestUnit = v
				end
				if v:THTD_GetStar() > highestUnit:THTD_GetStar() then
					highestUnit = v
				end
			end
		end
		return highestUnit
	else
		return nil
	end
end

function THTDSystem:FindRadiusOnePointLastCast( entity, range)
	local point = entity.thtd_last_cast_point
	if point == nil or GetDistanceBetweenTwoVec2D(point, entity:GetOrigin()) > range then
		local unit = THTDSystem:FindRadiusOneUnit(entity, range)
		if unit~=nil and unit:IsNull()==false then
			point = unit:GetOrigin()
		end
	end
	return point
end

function THTD_RandomUnitSelection(inputs, count)
	if #inputs<=count then
		return inputs
	end
	for i=2,#inputs do
		local j = RandomInt(1, i)
		if j~=i then
			local tmp = inputs[i]
			inputs[i] = inputs[j]
			inputs[j] = tmp
		end
	end
	local outputs = {}
	for i=1,count do
		table.insert(outputs, inputs[i])
	end
	return outputs
end

function THTDSystem:FindRadiusOnePointPerfectAOE( entity, range, AOErange)
	local enemies = THTD_FindUnitsInRadius(entity, entity:GetOrigin(), range)
	if #enemies > 10 then enemies = THTD_RandomUnitSelection(enemies, 10) end
	local target,maxCount = nil, 0
	for k,v in pairs(enemies) do
		if v~=nil and v:IsNull()==false then
			local count = THTDSystem:FindRadiusUnitCountInPoint(entity, AOErange, v:GetAbsOrigin())
			if target == nil or count > maxCount then
				target = v
				maxCount = count
			end
		end
	end
	if target~=nil then
		return target:GetAbsOrigin(), maxCount, target
	end
	return nil, 0
end

function THTDSystem:FindRadiusOnePointPerfectLineAOE(entity, range, width, length, onlyInner)
	local enemies = THTD_FindUnitsInRadius(entity, entity:GetOrigin(), range)
	if #enemies > 10 then enemies = THTD_RandomUnitSelection(enemies, 10) end
	local target,maxCount = nil, 0
	for k,v in pairs(enemies) do
		if v~=nil and v:IsNull()==false and not (onlyInner and v.thtd_is_outer==true) then
			local forward = (v:GetAbsOrigin() - entity:GetAbsOrigin()):Normalized()
			local count = THTDSystem:FindRadiusUnitCountInLine(entity, entity:GetOrigin(), forward, width, length)
			if target == nil or count > maxCount then
				target = v
				maxCount = count
			end
		end
	end
	if target~=nil then
		return target:GetAbsOrigin(), maxCount, target
	end
	return nil
end

FirstPointList = 
{
	[0] = Vector(-1408, 1056,0),
	[1] = Vector( 1408, 1056,0),
	[2] = Vector( 1408,-1056,0),
	[3] = Vector(-1408,-1056,0),
}

function GetUnitBackWardVector(unit, id)
	return (FirstPointList[id] - unit:GetAbsOrigin()):Normalized()
end

function THTDSystem:FindRadiousMostDangerousUnit(entity, range, ...)
	local enemies = THTD_FindUnitsInRadius(entity, entity:GetAbsOrigin(), range)
	local condition = ...
	if condition == nil then
		condition = function(...) return true end
	end
	local target = nil
	local maxdist = 0
	local firstpoint = FirstPointList[entity:GetPlayerOwnerID()]
	if #enemies > 0 then
		for k,v in pairs(enemies) do
			if v~=nil and v:IsNull()==false and condition(v) and v.thtd_ability_reisen_01_fearing ~= true then
				local dist = GetDistanceBetweenTwoVec2D(firstpoint, v:GetAbsOrigin())
				if target == nil or dist > maxdist then
					target = v
					maxdist = dist
				end
			end
		end
	end
	return target, maxdist
end

function THTDSystem:ChangeAttackTarget(entity, target)
	if entity.thtd_changing_attack_target == true then
		return
	end
	entity.thtd_changing_attack_target = true
	entity:SetContextThink(DoUniqueString("thtd_change_attack_target"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if target==nil or target:IsNull() or target:IsAlive()==false or 
				entity==nil or entity:IsNull() or entity:GetAttackTarget()==target or GetDistance(entity,target)>entity:GetAttackRange() then
				entity.thtd_changing_attack_target = false
				return nil
			end
			entity:MoveToTargetToAttack(target)
			return 0.1
		end,
	0)
end

function CDOTA_BaseNPC:THTD_mugiyousei_thtd_ai()
	local target = self:GetAttackTarget()

	local min_thtd_poison_buff = 0
	if target~=nil then
		min_thtd_poison_buff = target.thtd_poison_buff
	end
	local unit = target

	local enemies = THTD_FindUnitsInRadius(self, self:GetAbsOrigin(), self:GetAttackRange())
	if #enemies > 0 then
		for k,v in pairs(enemies) do
			if v~=nil and v:IsNull()==false and v.thtd_poison_buff < min_thtd_poison_buff then
				unit = v
				min_thtd_poison_buff = v.thtd_poison_buff
			end
		end
	end

	if unit~=nil and unit:IsNull()==false and unit~=target then
		THTDSystem:ChangeAttackTarget(self, unit)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_rumia_thtd_ai()

	if self.thtd_is_ex == true then
		local target = self:GetAttackTarget()
		if target==nil or target:IsNull()==true or target:GetHealthPercent()<=70 then
			target = THTDSystem:FindRadiousMostDangerousUnit(self, self:GetAttackRange(), 
				function (targetunit) return targetunit:GetHealthPercent() > 70 end)
			if target~=nil and target:IsNull()==false then
				THTDSystem:ChangeAttackTarget(self, target)
			end
		end
	end

	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end