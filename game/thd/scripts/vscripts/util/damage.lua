LinkLuaModifier("modifier_item_frost_cap_slow", "scripts/vscripts/modifiers/modifier_item_frost_cap_slow.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_watermelon_debuff", "scripts/vscripts/modifiers/modifier_armor_reduction_item.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_cirno_claymore_debuff", "scripts/vscripts/modifiers/modifier_armor_reduction_item.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_yuemianzhinu_debuff", "scripts/vscripts/modifiers/modifier_armor_reduction_item.lua", LUA_MODIFIER_MOTION_NONE)
    DAMAGE_INCREASE_TYPE_STR = 1
    DAMAGE_INCREASE_TYPE_AGI = 2
    DAMAGE_INCREASE_TYPE_INT = 3

	--接口
	--[[

		"RunScript"
		{
			"ScriptFile"		"scripts/vscripts/abilities/xxx.lua"
			"Function"			"xxx"
			"damage_base"		"0"									//固定的基础伤害(默认0)
			"damage_increase"	"1"									//伤害系数(默认1)
			"damage_increase_type" "1"                              //加成类型,默认为0（无） 1=力量 2=敏捷 3=智力
			"damage_type"		"DAMAGE_TYPE_PURE"					//伤害类型(默认纯粹)
		}
		
        function XXX(keys)		
		
		    UnitDamageTarget(keys)
			
		end
		
	]]
		



	--全局Damage表
	Damage = {}

	local Damage = Damage

	setmetatable(Damage, Damage)

	--伤害表的默认值
	Damage.damage_meta = {
		__index = {
			attacker 			= nil, 						--伤害来源
			victim 				= nil, 						--伤害目标
			damage				= 0,						--伤害
			damage_type			= DAMAGE_TYPE_PURE,			--伤害类型,不写的话是纯粹伤害
			damage_flags 		= 1, 						--伤害标记
		},
	}
	
	function UnitDamageTargetTemplate(keys)
		local targets	= keys.target_entities	--技能施放目标(数组)

		if not targets then
			print(debug.traceback '无伤害目标！')
		end
		
		--添加默认值
		setmetatable(damage, Damage.damage_meta)
		
		
		--获取技能传参,构建伤害table
		damage.attacker				= EntIndexToHScript(keys.caster_entindex)						--伤害来源(施法者)
		
		if not attacker then
			print(debug.traceback '找不到施法者！')
		end
		
		--获取伤害类型
		damage.damage_type          = keys.damage_type
		
		--判断属性类型，获取单位身上加成的属性
		local attribute             = 0
		
		if (keys.damage_increase_type == DAMAGE_INCREASE_TYPE_STR) then
			--力量增量
			attribute = keys.attacker:GetStrength()
			
		elseif (keys.damage_increase_type == DAMAGE_INCREASE_TYPE_AGI) then
		    --敏捷增量
		    attribute = keys.attacker:GetAgility()
			
		elseif (keys.damage_increase_type == DAMAGE_INCREASE_TYPE_INT) then
		    --智力增量
		    attribute = keys.attacker:GetIntellect()
			
		end
		          
		
		--根据公式计算出伤害
		--伤害系数 * (力量 * 力量系数 + 敏捷 * 敏捷系数 + 智力 * 智力系数)
		local damageResult     		=  attribute * keys.damage_increase + keys.damage_base
		
		--遍历数组进行伤害
		for i, victim in ipairs(targets) do
	        damage.victim 		= victim
			damage.damage 		= damageResult
			ApplyDamage(damage)
		end
		
end
	
function UnitDamageTarget(DamageTable)
		local dDamage = vlua.clone(DamageTable)
		if(dDamage.victim:IsNightmared())then
			dDamage.victim:RemoveModifierByName("modifier_bane_nightmare")
		end
		--if dDamage.attacker:HasItemInInventory("item_bagua") then
			--dDamage.damage = dDamage.damage * 1.3
		--end
	--    for item_slot = 0,5 do 
	--	local individual_item = dDamage.attacker:GetItemInSlot(item_slot)
	--		if individual_item ~= nil then
	--			if individual_item:GetName() == "item_frost_cap" and dDamage.attacker:GetTeamNumber() ~= dDamage.victim:GetTeamNumber() then
								
	--				dDamage.victim:AddNewModifier(dDamage.victim, individual_item, "modifier_item_frost_cap_slow", { Duration = 2 } )
	--			end
	--		end
     --   end

		if dDamage.attacker:HasModifier("modifier_item_frost_cap") then
			if dDamage.attacker:GetTeamNumber() ~= dDamage.victim:GetTeamNumber() then
				dDamage.victim:AddNewModifier(dDamage.victim, individual_item, "modifier_item_frost_cap_slow", { Duration = 2 } )
			end
			
		end	 

	    for item_slot = 0,8 do 
		local individual_item = dDamage.attacker:GetItemInSlot(item_slot)
			if individual_item ~= nil then
				if individual_item:GetName() == "item_occult_ball"  then
					dDamage.damage = dDamage.damage * 1.25
				end
			end
        end	

		
	--	if dDamage.attacker:HasItemInInventory("item_occult_ball") then
	--		dDamage.damage = dDamage.damage * 1
	 --   end
		
		
		
		
	--	if dDamage.attacker:HasItemInInventory("item_pomojinlingli") and dDamage.damage_type == DAMAGE_TYPE_MAGICAL then
	--		if dDamage.victim:HasModifier("modifier_item_green_dam_barrier") then
	--			dDamage.victim:RemoveModifierByName("modifier_item_green_dam_barrier")
	--		end
	--	end
		
		
	--	if dDamage.attacker:IsHero() then
		
			if dDamage.damage_type == DAMAGE_TYPE_MAGICAL then
		
				if dDamage.attacker:HasModifier("modifier_item_violin_passive") then	
		
					local enemyMR = dDamage.victim:GetMagicalArmorValue()*100
					if enemyMR < 100 and enemyMR > 0 then
					 	local dealdamageviolin = (((100/(100-enemyMR))*(100-(enemyMR*0.7)))/100)

					
					 	dDamage.damage = dDamage.damage * dealdamageviolin
					end
				end	

				if dDamage.attacker:HasModifier("modifier_item_6ball_passive") then	
		
					dDamage.damage = dDamage.damage * 1.1
				end

			
		
			end

		
			if dDamage.damage_type == DAMAGE_TYPE_PHYSICAL then
				if dDamage.attacker:GetStrength() > 250 then
			
					if dDamage.attacker:HasModifier("modifier_item_sword_of_hisou_passive") then	
		
						dDamage.damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR
					end	
				end				
		
			end		
		
		
		
		
			if dDamage.damage_type == DAMAGE_TYPE_PURE then
				if dDamage.attacker:GetStrength() > 250 then
			
					if dDamage.attacker:HasModifier("modifier_item_sword_of_hisou_passive") then	
						dDamage.damage = dDamage.damage * 1.4
						dDamage.damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY
					end	
				end	
				if dDamage.victim:HasModifier("modifier_item_green_dam_barrier") then
			
					if dDamage.damage_flags ~= DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY then
					
					dDamage.damage = 0
					end

				end			
		
			end		

	--	end		
		
		--if dDamage.attacker:HasItemInInventory("item_bagua") then
		--	dDamage.damage = dDamage.damage * 1.25
		--end		
		
		--if dDamage.attacker:HasItemInInventory("item_occult_ball") and dDamage.damage_type == DAMAGE_TYPE_MAGICAL then
			--if dDamage.victim:HasModifier("modifier_item_green_dam_barrier") then
				--dDamage.victim:RemoveModifierByName("modifier_item_green_dam_barrier")
			--end
		--end
		
----------------------------------------------------------------------------------------------------------------------		
--		if dDamage.attacker:HasItemInInventory("item_watermelon") and dDamage.damage_type == DAMAGE_TYPE_PHYSICAL then
--	         dDamage.victim:RemoveModifierByName("modifier_item_watermelon_debuff")
--	         dDamage.victim:AddNewModifier(dDamage.victim, nil, "modifier_item_watermelon_debuff", { Duration = 3 } )
			 
		 
--		end	
		
--		if dDamage.attacker:HasItemInInventory("item_yuemianzhinu") and dDamage.damage_type == DAMAGE_TYPE_PHYSICAL then
		
--	         dDamage.victim:RemoveModifierByName("modifier_item_yuemianzhinu_debuff")
--	         dDamage.victim:AddNewModifier(dDamage.victim, nil, "modifier_item_yuemianzhinu_debuff", { Duration = 3 } )
--		end
		
--		if dDamage.attacker:HasItemInInventory("item_cirno_claymore") and dDamage.damage_type == DAMAGE_TYPE_PHYSICAL then
--	         dDamage.victim:RemoveModifierByName("modifier_item_cirno_claymore_debuff")
--	         dDamage.victim:AddNewModifier(dDamage.victim, nil, "modifier_item_cirno_claymore_debuff", { Duration = 3 } )
--		end	
----------------------------------------------------------------------------------------------------------------------			
		
		if dDamage.attacker:HasModifier("modifier_tewi04_damagecalculate") then
		
			if RollPercentage(40) then
		
			local tewibuff = dDamage.attacker:FindModifierByName("modifier_tewi04_damagecalculate")
		
			local tewiultimate = tewibuff:GetAbility()	
		
			local ability4_level = tewiultimate:GetLevel() - 1		
		
			local extradamage = tewiultimate:GetLevelSpecialValueFor("extra_tewi_damage",ability4_level)
		
			dDamage.damage = (dDamage.damage*(100+extradamage))/100
		
			end
						
		end
		
		
		if dDamage.victim:HasModifier("modifier_tewi04_damagecalculate") then
	
			if RollPercentage(40) then
		
				local tewibuff = dDamage.victim:FindModifierByName("modifier_tewi04_damagecalculate")
		
				local tewiultimate = tewibuff:GetAbility()	
		
				local ability4_level = tewiultimate:GetLevel() - 1		
		
				local extradamage = tewiultimate:GetLevelSpecialValueFor("extra_tewi_damage",ability4_level)
		
				dDamage.damage = dDamage.damage-(dDamage.damage*extradamage/100)
		
			end
		end		
		
		
	
		
		return ApplyDamage(dDamage)
end
	
	
	
function UnitDamageTarget2(DamageTable)
		local dDamage = vlua.clone(DamageTable)
		--if dDamage.attacker:HasItemInInventory("item_bagua") then
			--dDamage.damage = dDamage.damage * 1.3
		--end
	--    for item_slot = 0,5 do 
	--	local individual_item = dDamage.attacker:GetItemInSlot(item_slot)
	--		if individual_item ~= nil then
	--			if individual_item:GetName() == "item_frost_cap" and dDamage.attacker:GetTeamNumber() ~= dDamage.victim:GetTeamNumber() then
								
	--				dDamage.victim:AddNewModifier(dDamage.victim, individual_item, "modifier_item_frost_cap_slow", { Duration = 2 } )
	--			end
	--		end
     --   end

		if dDamage.attacker:HasModifier("modifier_item_frost_cap") then
			if dDamage.attacker:GetTeamNumber() ~= dDamage.victim:GetTeamNumber() then
				dDamage.victim:AddNewModifier(dDamage.victim, individual_item, "modifier_item_frost_cap_slow", { Duration = 2 } )
			end
			
		end	 

	    for item_slot = 0,8 do 
		local individual_item = dDamage.attacker:GetItemInSlot(item_slot)
			if individual_item ~= nil then
				if individual_item:GetName() == "item_occult_ball"  then
					dDamage.damage = dDamage.damage * 1.25
				end
			end
        end	

		
	--	if dDamage.attacker:HasItemInInventory("item_occult_ball") then
	--		dDamage.damage = dDamage.damage * 1
	 --   end
		
		
		
		
	--	if dDamage.attacker:HasItemInInventory("item_pomojinlingli") and dDamage.damage_type == DAMAGE_TYPE_MAGICAL then
	--		if dDamage.victim:HasModifier("modifier_item_green_dam_barrier") then
	--			dDamage.victim:RemoveModifierByName("modifier_item_green_dam_barrier")
	--		end
	--	end
		
		
	--	if dDamage.attacker:IsHero() then
		
			if dDamage.damage_type == DAMAGE_TYPE_MAGICAL then
		
				if dDamage.attacker:HasModifier("modifier_item_violin_passive") then	
		
					local enemyMR = dDamage.victim:GetMagicalArmorValue()*100
					if enemyMR < 100 and enemyMR > 0 then
					 	local dealdamageviolin = (((100/(100-enemyMR))*(100-(enemyMR*0.7)))/100)

					
					 	dDamage.damage = dDamage.damage * dealdamageviolin
					end
				end	

				if dDamage.attacker:HasModifier("modifier_item_6ball_passive") then	
		
					dDamage.damage = dDamage.damage * 1.1
				end

			
		
			end

		
			if dDamage.damage_type == DAMAGE_TYPE_PHYSICAL then
				if dDamage.attacker:GetStrength() > 250 then
			
					if dDamage.attacker:HasModifier("modifier_item_sword_of_hisou_passive") then	
		
						dDamage.damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR
					end	
				end				
		
			end		
		
		
		
		
			if dDamage.damage_type == DAMAGE_TYPE_PURE then
				if dDamage.attacker:GetStrength() > 250 then
			
					if dDamage.attacker:HasModifier("modifier_item_sword_of_hisou_passive") then	
						dDamage.damage = dDamage.damage * 1.4
						dDamage.damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY
					end	
				end	
				if dDamage.victim:HasModifier("modifier_item_green_dam_barrier") then
			
					if dDamage.damage_flags ~= DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY then
					
					dDamage.damage = 0
					end

				end			
		
			end		

	--	end		
		
		--if dDamage.attacker:HasItemInInventory("item_bagua") then
		--	dDamage.damage = dDamage.damage * 1.25
		--end		
		
		--if dDamage.attacker:HasItemInInventory("item_occult_ball") and dDamage.damage_type == DAMAGE_TYPE_MAGICAL then
			--if dDamage.victim:HasModifier("modifier_item_green_dam_barrier") then
				--dDamage.victim:RemoveModifierByName("modifier_item_green_dam_barrier")
			--end
		--end
		
----------------------------------------------------------------------------------------------------------------------		
--		if dDamage.attacker:HasItemInInventory("item_watermelon") and dDamage.damage_type == DAMAGE_TYPE_PHYSICAL then
--	         dDamage.victim:RemoveModifierByName("modifier_item_watermelon_debuff")
--	         dDamage.victim:AddNewModifier(dDamage.victim, nil, "modifier_item_watermelon_debuff", { Duration = 3 } )
			 
		 
--		end	
		
--		if dDamage.attacker:HasItemInInventory("item_yuemianzhinu") and dDamage.damage_type == DAMAGE_TYPE_PHYSICAL then
		
--	         dDamage.victim:RemoveModifierByName("modifier_item_yuemianzhinu_debuff")
--	         dDamage.victim:AddNewModifier(dDamage.victim, nil, "modifier_item_yuemianzhinu_debuff", { Duration = 3 } )
--		end
		
--		if dDamage.attacker:HasItemInInventory("item_cirno_claymore") and dDamage.damage_type == DAMAGE_TYPE_PHYSICAL then
--	         dDamage.victim:RemoveModifierByName("modifier_item_cirno_claymore_debuff")
--	         dDamage.victim:AddNewModifier(dDamage.victim, nil, "modifier_item_cirno_claymore_debuff", { Duration = 3 } )
--		end	
----------------------------------------------------------------------------------------------------------------------			
		
		if dDamage.attacker:HasModifier("modifier_tewi04_damagecalculate") then
		
			if RollPercentage(40) then
		
			local tewibuff = dDamage.attacker:FindModifierByName("modifier_tewi04_damagecalculate")
		
			local tewiultimate = tewibuff:GetAbility()	
		
			local ability4_level = tewiultimate:GetLevel() - 1		
		
			local extradamage = tewiultimate:GetLevelSpecialValueFor("extra_tewi_damage",ability4_level)
		
			dDamage.damage = (dDamage.damage*(100+extradamage))/100
		
			end
						
		end
		
		
		if dDamage.victim:HasModifier("modifier_tewi04_damagecalculate") then
	
			if RollPercentage(40) then
		
				local tewibuff = dDamage.victim:FindModifierByName("modifier_tewi04_damagecalculate")
		
				local tewiultimate = tewibuff:GetAbility()	
		
				local ability4_level = tewiultimate:GetLevel() - 1		
		
				local extradamage = tewiultimate:GetLevelSpecialValueFor("extra_tewi_damage",ability4_level)
		
				dDamage.damage = dDamage.damage-(dDamage.damage*extradamage/100)
		
			end
		end		
		
		
	
		
		return ApplyDamage(dDamage)
end	
	
function CDOTA_BaseNPC:GetPhysicalArmorReduction()
    local armornpc = self:GetPhysicalArmorValue()
    local armor_reduction = 1 - (0.06 * armornpc) / (1 + (0.06 * math.abs(armornpc)))
    armor_reduction = 100 - (armor_reduction * 100)
	
    return armor_reduction
end	