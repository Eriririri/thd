
---------------------------------------------------------------------------------------
--[[
DEBUG FUNCTIONS
]]

--ITEM_DEBUG=true

function PrintTargetInfo(target)
	print("Target Name:"..target:GetName())
	print("Target ModelName: "..target:GetModelName())
	
	print("Target Has Abilities("..tostring(target:GetAbilityCount())..")")
	for i=0,target:GetAbilityCount()-1 do
		local indent="\t"
		local Ability=target:GetAbilityByIndex(i)
		if Ability then
			print(indent.."Target's Ability index:"..tostring(i).." name:"..Ability:GetName())
			indent=indent.."\t"
			print(indent.."GetLevel:"..tostring(Ability:GetLevel()))
		end
	end
	
	print("Target Has Modifiers("..tostring(target:GetModifierCount()).."):")
	for i=0,target:GetModifierCount()-1 do
		local indent="\t"
		local ModifierName=target:GetModifierNameByIndex(i)
		print(indent.."Target's Modifier index:"..tostring(i).." name:"..ModifierName)
		local ModifierClass=target:FindModifierByName(ModifierName)
		if ModifierClass then
			indent=indent.."\t"
			local Ability=ModifierClass:GetAbility()
			if Ability then
				print(indent.."GetAbility:"..tostring(Ability))
				print(indent.."GetAbility Name:"..Ability:GetAbilityName())
			end
			print(indent.."CDOTA_Modifier_Lua:GetAttributes:"..tostring(CDOTA_Modifier_Lua.GetAttributes(ModifierClass)))
			print(indent.."GetStackCount:"..tostring(ModifierClass:GetStackCount()))
			print(indent.."GetDuration:"..tostring(ModifierClass:GetDuration()))
			print(indent.."GetRemainingTime:"..tostring(ModifierClass:GetRemainingTime()))
			print(indent.."GetClass:"..ModifierClass:GetClass())
			print(indent.."GetCaster Name"..ModifierClass:GetCaster():GetName())
			print(indent.."GetParent Name"..ModifierClass:GetParent():GetName())
		end
	end
end

function ItemAbility_Debug_GetGold(keys)
	DebugPrint("ItemAbility_GetGold"..keys.bonus_gold)
	local Caster = keys.caster
	local CasterPlayerID = Caster:GetPlayerID()
	PlayerResource:SetGold(CasterPlayerID,PlayerResource:GetUnreliableGold(CasterPlayerID) + keys.bonus_gold,false)
end
function ItemAbility_Debug_PrintHealth(keys)
	if (keys.caster) then
		DebugPrint(keys.debug_string.."caster health is "..keys.caster:GetHealth())
	end
	if (keys.target) then
		DebugPrint(keys.debug_string.."target health is "..keys.target:GetHealth())
	end
end

function DebugPrint(msg)
	if ITEM_DEBUG==true then print(msg) end
end

function DebugFunction(func,...)
	if ITEM_DEBUG then func(...) end
end
---------------------------------------------------------------------------------------
-- UTIL Functions

function clamp (Num, Min, Max)
	if (Num>Max) then return Max
	elseif (Num<Min) then return Min
	else return Num
	end
end

function round (num)
	return math.floor(num + 0.5)
end
 
function distance(a, b)
    local xx = (a.x-b.x)
    local yy = (a.y-b.y)
    return math.sqrt(xx*xx + yy*yy)
end

function GetAngleBetweenTwoVec(a,b)
	local y = b.y - a.y
	local x = b.x - a.x
	return math.atan2(y,x)
end

function ItemAbility_SpendItem(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	
	if (ItemAbility:IsItem()) then
		local Charge = ItemAbility:GetCurrentCharges()
		if (Charge>1) then
			ItemAbility:SetCurrentCharges(Charge-1)
		else
			Caster:RemoveItem(ItemAbility)
		end
	end
end

function PrintTable(t, indent, done)
	--DebugPrint ( string.format ('PrintTable type %s', type(keys)) )
    if type(t) ~= "table" then return end

    done = done or {}
    done[t] = true
    indent = indent or 0

    local l = {}
    for k, v in pairs(t) do
        table.insert(l, k)
    end

    table.sort(l)
    for k, v in ipairs(l) do
        -- Ignore FDesc
        if v ~= 'FDesc' then
            local value = t[v]

            if type(value) == "table" and not done[value] then
                done [value] = true
                DebugPrint(string.rep ("\t", indent)..tostring(v)..":")
                PrintTable (value, indent + 2, done)
            elseif type(value) == "userdata" and not done[value] then
                done [value] = true
                DebugPrint(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
                PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
            else
                if t.FDesc and t.FDesc[v] then
                    DebugPrint(string.rep ("\t", indent)..tostring(t.FDesc[v]))
                else
                    DebugPrint(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
                end
            end
        end
    end
end

function PrintKeys(keys)
	PrintTable(keys)
end

function UnitStunTarget(caster,target,stuntime)
    UtilStun:UnitStunTarget(caster,target,stuntime)
end

-- extra keys params:
-- string ModifierName
-- int Blockable
-- int ApplyToTower
function ItemAbility_ModifierTarget(keys)
	local ItemAbility = keys.ability
	local Caster = keys.Caster or keys.caster
	local Target = keys.Target or keys.target
	if Caster and Target and Caster:GetTeam()~=Target:GetTeam() then
		if keys.Blockable==1 and is_spell_blocked_by_hakurei_amulet(Target) then
			return
		elseif (not keys.ApplyToTower or keys.ApplyToTower==0) and Target:IsBuilding() then
			return
		end
	end
	ItemAbility:ApplyDataDrivenModifier(Caster,Target,keys.ModifierName,{})	
end

function ItemAbility_ModifierTarget3d(keys)
	local ItemAbility = keys.ability
	local Caster = keys.Caster or keys.caster
	local Target = keys.Target or keys.target
	if Caster and Target and Caster:GetTeam()~=Target:GetTeam() then
		if keys.Blockable==1 and is_spell_blocked_by_hakurei_amulet(Target) then
			return
		elseif (not keys.ApplyToTower or keys.ApplyToTower==0) and Target:IsBuilding() then
			return
		end
	end
	ItemAbility:ApplyDataDrivenModifier(Caster,Target,"modifier_item_three_dimension_debuff",{})
	ItemAbility:ApplyDataDrivenModifier(Caster,Target,"modifier_item_three_dimension_debuff_effects",{})
	if Caster:GetTeam() ~= Target:GetTeam() then
	ItemAbility:ApplyDataDrivenModifier(Caster,Target,"modifier_item_three_dimension_debuff_enemy",{})	
	
	end
	
end



function ItemAbility_ModifierTarget2(keys)
	local ItemAbility = keys.ability
	local Caster = keys.Caster or keys.caster
	local Target = keys.Target or keys.target
	ItemAbility:ApplyDataDrivenModifier(Caster,Target,keys.ModifierName,{})
end

function ItemAbility_ModifierGhostBladeActive(keys)
	local ItemAbility = keys.ability
	local Caster = keys.Caster or keys.caster
	local Target = keys.Target or keys.target
	
	if Target:IsBuilding()== true then
		return 	
	end
	ItemAbility:ApplyDataDrivenModifier(Caster,Target,keys.ModifierName,{})
end
-- extra keys params:
-- string ModifierName
-- int ModifierCount
-- table ApplyModifierParams
function ItemAbility_SetModifierStackCount(keys)
	local ItemAbility = keys.ability
	local Caster = keys.Caster or keys.caster
	local Target = keys.Target or keys.target

	if (keys.ModifierCount>0) then
		if (Target:HasModifier(keys.ModifierName)==false) then
			local Params = {}
			if (keys.ApplyModifierParams) then
				Params=keys.ApplyModifierParams
			end
			ItemAbility:ApplyDataDrivenModifier(Caster,Target,keys.ModifierName,Params)
		end

		Target:SetModifierStackCount(keys.ModifierName,ItemAbility,keys.ModifierCount)
	elseif(Target:HasModifier(keys.ModifierName)) then
		Target:RemoveModifierByName(keys.ModifierName)
	end
end

-- extra keys params:
-- int CountChange
-- string ModifierName
-- int ModifierCount
-- table ApplyModifierParams
function ItemAbility_ModifyModifierStackCount(keys)
	local ItemAbility = keys.ability
	local Caster = keys.Caster or keys.caster
	local Target = keys.Target or keys.target
	local ModifierStackCount = 0

	if (Target:HasModifier(keys.ModifierName)) then
		ModifierStackCount=Target:GetModifierStackCount(keys.ModifierName,Caster)
	end

	keys.ModifierCount=ModifierStackCount+keys.CountChange
	ItemAbility_SetModifierStackCount(keys)
end

---------------------------------------------------------------------------------------

function ItemAbility_CardGoodMan_OnSpellStart(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	ItemAbility_ModifierTarget({
		ability=keys.ability,
		Caster=Caster,
		Target=Target,
		ModifierName=keys.DebuffName,
		Blockable=0
	})
	ItemAbility_SpendItem(keys)
end

function ItemAbility_CardBadMan_OnSpellStart(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	
	ItemAbility:ApplyDataDrivenModifier(Caster,Caster,keys.BuffName,{})
	
	ItemAbility_SpendItem(keys)
	Caster:EmitSound("fast_card")	
end

function ItemAbility_CardWorseMan_OnSpellStart(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	local AbsorbMana = min(Target:GetMana(),keys.AbsorbManaAmount)
	
	
	
	
	 
		Target:ReduceMana(AbsorbMana)
		Caster:GiveMana(AbsorbMana)
		SendOverheadEventMessage(nil,OVERHEAD_ALERT_MANA_LOSS,Target,AbsorbMana,nil)
		
		UnitDamageTarget({
				ability = ItemAbility,
				victim = Target,
				attacker = Caster,
				damage = keys.AbsorbDamage,
				damage_type = DAMAGE_TYPE_PURE
			
			})
		SendOverheadEventMessage(nil,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,Target,keys.AbsorbDamage,nil)
	
	
	ItemAbility_SpendItem(keys)
end
function ItemAbility_CardLoveMan_OnSpellStart(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	
	totalheal = keys.HealAmount
	
	if Target:HasModifier("modifier_item_love_card_penalty") then
--	Target:Heal(keys.HealAmount/2,Caster)
--	SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,Target,keys.HealAmount/2,nil)	
--	Caster:EmitSound("lover_card")
		totalheal = totalheal/2
	end
	
	ItemAbility:ApplyDataDrivenModifier(Caster,Target,"modifier_item_love_card_penalty",{})
	
--	Target:Heal(keys.HealAmount,Caster)
--	SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,Target,keys.HealAmount,nil)
	
	THDHealTarget(Caster,Target,totalheal)	
	
	
	ItemAbility_SpendItem(keys)
	Target:EmitSound("lover_card")
	
end
function ItemAbility_MrYang_OnSpellStart(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	keys.target:Purge(true, false, false, false, false)
	if is_spell_blocked_by_hakurei_amulet(Target) then
		return
	end
	
	ItemAbility:ApplyDataDrivenModifier(Caster,Target,keys.DeclineIntDebuffName,{})
	
	Target:AddNewModifier(Caster, ItemAbility, "modifier_reduce_50_heal",  {duration = keys.SlowdownDuration} )
	--Target:AddNewModifier(Caster, ItemAbility, "modifier_reduce_50_heal",  {duration = 10} )
	for i=0.0,keys.SlowdownDuration,keys.SlowdownInterval do
		ItemAbility:ApplyDataDrivenModifier(Caster,Target,keys.SlowdownDebuffName,{duration=i})
	end
end

function modifier_item_basher_bash_chance_on_attack_landed(keys)
local Target = keys.target
	if (not keys.caster:HasModifier("bash_cooldown_modifier") and Target:IsBuilding()==false and keys.caster:IsRealHero()) then
		local random_int = RandomInt(1, 100)
		local is_ranged_attacker = keys.caster:IsRangedAttacker()
		
		if (is_ranged_attacker and random_int <= keys.BashChanceRanged) or (not is_ranged_attacker and random_int <= keys.BashChanceMelee) then
			keys.target:EmitSound("DOTA_Item.SkullBasher")
			keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_item_basher_bash", nil)
			
			
			--Give the caster a generic "bash cooldown" modifier so they cannot bash in the next couple of seconds due to any item.
			keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "bash_cooldown_modifier", nil)
		end
	end
end





function ItemAbility_GhostBallon_OnAttacked(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Attacker = keys.attacker	
	if (Attacker:IsBuilding()==false) then
		ItemAbility:ApplyDataDrivenModifier(Caster,Attacker,keys.ModifierName,{})
	end
end

function ItemAbility_WindGun_OnAttack(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	local damage_to_deal = keys.PhysicalDamage
	if (Caster:IsRealHero() and Target:IsRealHero()==false and Target:IsBuilding()==false) and Target:GetTeam() ~= Caster:GetTeam() then
		local damage_table = {
			ability = ItemAbility,
			victim = Target,
			attacker = Caster,
			damage = damage_to_deal,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = 1
		}
		UnitDamageTarget(damage_table)
		local effectIndex = ParticleManager:CreateParticle("particles/econ/items/sniper/sniper_charlie/sniper_base_attack_explosion_charlie.vpcf", PATTACH_ABSORIGIN_FOLLOW, Target)
		ParticleManager:SetParticleControl(effectIndex, 3, Caster:GetAbsOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)
	end
end

function ItemAbility_Camera_OnAttack(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	if (Caster:IsRealHero() and Target:IsBuilding()==false) then
		local damage_to_deal =Target:GetMaxHealth()*keys.DamageHealthPercent*0.01
		if Target:GetUnitName()=="npc_dota_roshan" then damage_to_deal=damage_to_deal*0.1 end
		local damage_table = {
			ability = ItemAbility,
			victim = Target,
			attacker = Caster,
			damage = damage_to_deal,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_UNIT_TARGET_FLAG_NONE
		}
		UnitDamageTarget(damage_table)
		
		--SendOverheadEventMessage(nil,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,Target,damage_to_deal,nil)
		--PrintTable(damage_table)
		--DebugPrint("ItemAbility_Camera_OnAttack| Damage:"..damage_to_deal)
	end
end

function ItemAbility_Verity_OnAttack(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	if (Target:IsBuilding()==false and Caster:IsIllusion()==false) then
		
		if ItemAbility:IsCooldownReady() then
			local damage_table = {
				ability = ItemAbility,
				victim = Target,
				attacker = Caster,
				damage = 200,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage_flags = 1
			}
			UnitDamageTarget(damage_table)
			Target:ReduceMana(100)
			ItemAbility:StartCooldown(ItemAbility:GetCooldown(1))
		end

		local RemoveMana = Target:GetMaxMana()*keys.PenetrateRemoveManaPercent*0.01
		RemoveMana=min(RemoveMana,Target:GetMana())
		Target:ReduceMana(RemoveMana)
		local damage_to_deal = RemoveMana*keys.PenetrateDamageFactor
		if (damage_to_deal>0) then
			local damage_table = {
				ability = ItemAbility,
				victim = Target,
				attacker = Caster,
				damage = damage_to_deal,
				damage_type = DAMAGE_TYPE_PURE,
				damage_flags = 1
			}
			UnitDamageTarget(damage_table)
			
			--PrintTable(damage_table)
			DebugPrint("ItemAbility_Verity_OnAttack| Damage:"..damage_to_deal)
		end
	end
end

function ItemAbility_Kafziel_OnAttack(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	if (Caster:IsRealHero() and Target:IsBuilding()==false) then
		local damage_to_deal = (Caster:GetHealth()-Target:GetHealth())*keys.HarvestDamageFactor
		if (damage_to_deal>0) then
			local damage_table = {
				ability = ItemAbility,
				victim = Target,
				attacker = Caster,
				damage = damage_to_deal,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = 1
			}
			UnitDamageTarget(damage_table)
			SendOverheadEventMessage(nil,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,Target,damage_to_deal,nil)
			
			--PrintTable(damage_table)
			DebugPrint("ItemAbility_Kafziel_OnAttack| Damage:"..damage_to_deal)
		end
	end
end

function ItemAbility_Kafziel_OnAttack2(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	if Caster:GetHealth() > Target:GetHealth() then
		Target:AddNewModifier(Caster, ItemAbility, "modifier_reduce_50_heal",  {duration = keys.heal_duration} )	
	end	
	
end

function ItemAbility_Frock_Poison(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Attacker = keys.attacker
	if (Attacker:IsBuilding()==false) then
		local damage_to_deal = 0
		if (Attacker:IsHero()) then
			local MaxAttribute = max(max(Attacker:GetStrength(),Attacker:GetAgility()),Attacker:GetIntellect())
			damage_to_deal = keys.PoisonDamageBase + Attacker:GetAttackDamage()*keys.PoisonDamageFactor
												  --MaxAttribute
		end
		damage_to_deal = max(damage_to_deal,keys.PoisonMinDamage)
		if (damage_to_deal>0) then
			local damage_table = {
				ability = ItemAbility,
				victim = Attacker,
				attacker = Caster,
				damage = damage_to_deal*0.75,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = 1
			}
			UnitDamageTarget(damage_table)
			SendOverheadEventMessage(nil,OVERHEAD_ALERT_BONUS_POISON_DAMAGE,Attacker,damage_to_deal,nil)
			
			--PrintTable(damage_table)
			DebugPrint("ItemAbility_Frock_Poison| Damage:"..damage_to_deal)
		end
	end
end

function ItemAbility_Frock_Poison_TakeDamage(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Attacker = keys.attacker
	local damage_to_deal = keys.TakenDamage * 0.5
	if (Attacker:IsBuilding()==false) and Attacker ~= Caster and Attacker:HasModifier("modifier_item_frock_OnTakeDamage") == false then
		if (damage_to_deal>0 and damage_to_deal<=Caster:GetMaxHealth()) then
			local damage_table = {
				ability = ItemAbility,
				victim = Attacker,
				attacker = Caster,
				damage = damage_to_deal,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = 1
			}
			UnitDamageTarget(damage_table)
			SendOverheadEventMessage(nil,OVERHEAD_ALERT_BONUS_POISON_DAMAGE,Attacker,damage_to_deal,nil)
		end
	end
end

function ItemAbility_LoneLiness_RegenHealth(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Health = Caster:GetHealth()
	local MaxHealth = Caster:GetMaxHealth()
	local HealthRegen = Caster:GetHealthRegen()
	local HealAmount = (MaxHealth-Health)*keys.PercentHealthRegenBonus*0.01 + HealthRegen*keys.HealthRegenMultiplier*0.01
	Caster:Heal(HealAmount,Caster)
end

function ItemAbility_HakureiTicket_FeastHeal(keys)
	local Caster = keys.caster
	local HealAmount = keys.HealAmount
	local Targets = keys.target_entities
	for i,v in pairs(Targets) do
		local totalheal = HealAmount + v:GetMaxHealth()*0.10
	--	v:Heal(totalheal,Caster)
	--	SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,v,totalheal,nil)
		THDHealTarget(Caster,v,totalheal)		
		
		
		local effectIndex = ParticleManager:CreateParticle("particles/items2_fx/mekanism.vpcf", PATTACH_CUSTOMORIGIN, v)
		ParticleManager:SetParticleControlEnt(effectIndex , 0, v, 5, "follow_origin", Vector(0,0,0), true)
	end
end


function ItemAbility_DoctorDoll_Heal(keys)
	local Caster = keys.caster
	
	totalheal = keys.HealAmount
	
	
	THDHealTarget(Caster,Caster,totalheal)	
	
	

end


function ItemAbility_DoctorDoll_DeclineHealth(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Health = Caster:GetHealth()
	
	local damage_to_deal = min(keys.DeclineHealthPerSec,Health-1)
	if (damage_to_deal>0) then
		Caster:SetHealth(Health - damage_to_deal)
		SendOverheadEventMessage(nil,OVERHEAD_ALERT_BONUS_POISON_DAMAGE,Caster,damage_to_deal,nil)
		
		--PrintTable(damage_table)
	end
end

function create_illusion(keys, illusion_origin, illusion_incoming_damage, illusion_outgoing_damage, illusion_duration)	
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
	

	if keys.caster:HasAbility("ability_thdots_EXrumia01") then 
	
	local exrumia = keys.caster
				illusion:RemoveAbility("ability_thdots_rumia01")
				illusion:RemoveAbility("ability_thdots_rumia02")	
				illusion:RemoveAbility("ability_thdots_rumia03")
				illusion:RemoveAbility("ability_thdots_rumia04")
				illusion:SetModel("models/thd2/rumia_ex/rumia_ex.vmdl")
				illusion:SetOriginalModel("models/thd2/rumia_ex/rumia_ex.vmdl")	
				illusion:SetPrimaryAttribute(1)
				
				illusion:SetBaseStrength(exrumia:GetBaseStrength())
				illusion:SetBaseAgility(exrumia:GetBaseAgility())
				illusion:SetBaseIntellect(exrumia:GetIntellect())	
				illusion:SetBaseDamageMax(30)
				illusion:SetBaseDamageMin(30)
				illusion:AddAbility("ability_thdots_EXrumia01")
				illusion:AddAbility("ability_thdots_EXrumia02")
				illusion:AddAbility("ability_thdots_EXrumia03")
				illusion:AddAbility("ability_thdots_EXrumia04")
				illusion:AddAbility("ability_thdots_EXrumia05"):SetLevel(1)		
	

	end		
	
	
	
	
	
	
	
	
	
	
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
	for item_slot = 0, 8 do
	
		local wipe_item_index = illusion:GetItemInSlot(item_slot)
		if wipe_item_index then
			illusion:RemoveItem(wipe_item_index)
		end	
	
		local individual_item = keys.caster:GetItemInSlot(item_slot)
		if individual_item ~= nil then
			local illusion_duplicate_item = CreateItem(individual_item:GetName(), illusion, illusion)
			illusion:AddItem(illusion_duplicate_item)
			illusion_duplicate_item:SetPurchaser(nil)			
			
		end
	end
	
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle 
	illusion:AddNewModifier(keys.caster, keys.ability, "modifier_illusion", {duration = illusion_duration, outgoing_damage = illusion_outgoing_damage, incoming_damage = illusion_incoming_damage})
	
	illusion:MakeIllusion()  --Without MakeIllusion(), the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.  Without it, IsIllusion() returns false and IsRealHero() returns true.

	--illusion:GetModelName()
	return illusion
end

function ItemAbility_DummyDoll_OnSpellStart(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	
	ProjectileManager:ProjectileDodge(Caster)
	--create_illusion(keys, illusion_origin, illusion_incoming_damage, illusion_outgoing_damage, illusion_duration)	
	illusion=create_illusion(keys,Caster:GetAbsOrigin(),keys.illusion_damage_percent_incoming_melee,-100,keys.illusions_duration)
	if (illusion ~= nil) then
	
	
	
	
	
	
		local CasterAngles = Caster:GetAnglesAsVector()
		illusion:SetAngles(CasterAngles.x,CasterAngles.y,CasterAngles.z)
		illusion:SetBaseMoveSpeed(400)
		illusion:SetHealth(illusion:GetMaxHealth()*Caster:GetHealthPercent()*0.01)
		illusion:SetMana(illusion:GetMaxMana()*Caster:GetManaPercent()*0.01)
		--ItemAbility:ApplyDataDrivenModifier(illusion,illusion,keys.illusion_modifier,{})
	end
end

function ItemTentacleRoot(keys)
	if caster:IsRealHero() then
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target,"modifier_item_tentacle_root",{})
	end
end

function ItemAbility_Lunchbox_Charge(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.unit
	if Caster:GetTeam()~=Target:GetTeam() and Caster:CanEntityBeSeenByMyTeam(Target) then
		local CurrentActiveAbility=Target:GetCurrentActiveAbility()
		if (ItemAbility:IsItem() and CurrentActiveAbility and not CurrentActiveAbility:IsItem()) then
		print(CurrentActiveAbility:GetAbilityName())
			local Charge = ItemAbility:GetCurrentCharges()
			if (Charge<keys.MaxCharges) then
				ItemAbility:SetCurrentCharges(Charge+1)
			end
		end
	end
end

function ItemAbility_Lunchbox_OnSpellStart(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	if (ItemAbility:IsItem()) then
		local Charge = ItemAbility:GetCurrentCharges()
		local HealAmount = Charge*keys.RestorePerCharge
		if (Charge>0) then
		
		--	Caster:Heal(HealAmount,Caster)
			THDHealTarget(Caster,Caster,HealAmount)
			
		--	SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,Caster,HealAmount,nil)
			Caster:GiveMana(HealAmount)
			SendOverheadEventMessage(nil,OVERHEAD_ALERT_MANA_ADD,Caster,HealAmount,nil)
			
			ItemAbility:SetCurrentCharges(0)
		end
	end
end

function ItemAbility_God_Lunchbox_OnSpellStart(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	if (ItemAbility:GetCurrentCharges()==keys.MaxCharges) then
		--Purge(bool RemovePositiveBuffs, bool RemoveDebuffs, bool BuffsCreatedThisFrameOnly, bool RemoveStuns, bool RemoveExceptions) 
		Caster:Purge(false,true,false,true,false)
	end
	ItemAbility_Lunchbox_OnSpellStart(keys) --Spend Charges
end

function ItemAbility_DragonStar_Purge(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	DebugPrint("ItemAbility_Dragon_Star_Purge")
	--Purge(bool RemovePositiveBuffs, bool RemoveDebuffs, bool BuffsCreatedThisFrameOnly, bool RemoveStuns, bool RemoveExceptions) 
	Caster:Purge(false,true,false,true,false)
end

function ItemAbility_mushroom_kebab_OnSpellStart(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local game_time = math.floor(GameRules:GetDOTATime(false, false) / 60)
	if 	game_time < 15 then
		return
	end	
	Caster:SetBaseStrength(Caster:GetBaseStrength() + keys.IncreaseStrength)
	if (ItemAbility:IsItem()) then
		Caster:RemoveItem(ItemAbility)
		--ItemAbility:Kill()
	end
end

function ItemAbility_mushroom_pie_OnSpellStart(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local game_time = math.floor(GameRules:GetDOTATime(false, false) / 60)
	if 	game_time < 15 then
		return
	end	
	
	Caster:SetBaseAgility(Caster:GetBaseAgility() + keys.IncreaseAgility)
	if (ItemAbility:IsItem()) then
		Caster:RemoveItem(ItemAbility)
		--ItemAbility:Kill()
	end
end

function ItemAbility_mushroom_soup_OnSpellStart(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local game_time = math.floor(GameRules:GetDOTATime(false, false) / 60)
	if 	game_time < 15 then
		return
	end
	
	Caster:SetBaseIntellect(Caster:GetBaseIntellect() + keys.IncreaseIntellect)
	if (ItemAbility:IsItem()) then
		Caster:RemoveItem(ItemAbility)
		--ItemAbility:Kill()
	end
end

function ItemAbility_HorseKing_OnOpen_SpendMana(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	--if (Caster:GetMaxMana()>keys.NeedSpendMana) then
	do
		if (Caster:GetManaPercent()<keys.SpendManaPercent and ItemAbility:GetToggleState()) then
			ItemAbility:ToggleAbility()
		else
			local SpendMana = Caster:GetMaxMana()*keys.SpendManaPercent*0.01
			Caster:SpendMana(SpendMana,ItemAbility)
			--Caster:ReduceMana(SpendMana)
		end
	end
end

function ItemAbility_HorseKing_ToggleOff(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	if (ItemAbility:GetToggleState()) then
		ItemAbility:ToggleAbility()
	end
end

function ItemAbility_DonationBox_OnSpellStart(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	local GoldBounty = Target:GetGoldBounty()
	if Target:GetUnitName() == "ability_minamitsu_04_ship" or Target:GetUnitName() == "ability_margatroid03_doll" then
		return
	end
	Target:SetMaximumGoldBounty(GoldBounty+keys.BonusGold)
	Target:SetMinimumGoldBounty(GoldBounty+keys.BonusGold)
	Target:Kill(ItemAbility,Caster)
	SendOverheadEventMessage(nil,OVERHEAD_ALERT_GOLD,Caster,keys.BonusGold,nil)
	Caster:AddExperience(80,DOTA_ModifyXP_CreepKill,false,false)
	
	local effectIndex = ParticleManager:CreateParticle("particles/thd2/items/item_donation_box.vpcf", PATTACH_CUSTOMORIGIN, Caster)
	ParticleManager:SetParticleControl(effectIndex, 0, Caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, Target:GetAbsOrigin())
	
	local Duration=0.0
	Caster:SetThink(function ()
		if (Duration>1.0) then 
			ParticleManager:DestroyParticleSystem(effectIndex,false)
			return nil 
		end
		
		Duration = Duration+0.02
		ParticleManager:SetParticleControl(effectIndex, 0, Caster:GetAbsOrigin())
		return 0.02
	end)
end

function ItemAbility_DonationGem_BounsGold(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.unit
	local CasterPlayerID = Caster:GetPlayerOwnerID()
	local GoldBountyAmount=keys.GoldBountyAmount
	
	if Target:GetTeam()~=Caster:GetTeam() then
		if (ItemAbility and ItemAbility:IsCooldownReady()) then
			ItemAbility:StartCooldown(ItemAbility:GetCooldown(ItemAbility:GetLevel()))
			Caster.ItemAbility_DonationGem_TriggerTime=GameRules:GetGameTime()
			PlayerResource:SetGold(CasterPlayerID,PlayerResource:GetUnreliableGold(CasterPlayerID) + GoldBountyAmount,false)
			
			local effectIndex = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, Caster)
			ParticleManager:DestroyParticleSystem(effectIndex,false)
			
			SendOverheadEventMessage(Caster:GetOwner(),OVERHEAD_ALERT_GOLD,Caster,GoldBountyAmount,nil)
			DebugPrint("ItemAbility_DonationGem_BounsGold| Bounty Gold: "..tostring(GoldBountyAmount))
		end
	end
end

function ItemAbility_Rocket_OnHit(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	if is_spell_blocked_by_hakurei_amulet(Target) then
		return
	end
	Caster:EmitSound("THD_ITEM.Rocket_Hit")
	UnitDamageTarget({
		ability = ItemAbility,
		victim = Target,
		attacker = Caster,
		damage = keys.RocketDamage,
		damage_type = DAMAGE_TYPE_MAGICAL
	})
	UnitStunTarget(Caster,Target,keys.StunDuration)
end

function ItemAbility_9ball_OnSpellStart(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local vecCaster = Caster:GetOrigin()
	local radian = RandomFloat(0,6.28)
	local range = RandomFloat(keys.BlinkRangeMin,keys.BlinkRangeMax)
	vecCaster.x = vecCaster.x+math.cos(radian)*range
	vecCaster.y = vecCaster.y+math.sin(radian)*range
	Caster:SetOrigin(vecCaster)
	FindClearSpaceForUnit(Caster,vecCaster,false)
	ProjectileManager:ProjectileDodge(Caster)
	--SetTargetToTraversable(Caster)
end

function ItemAbility_PresentBox_RestoreGold(keys)
	local ItemAbility = keys.ability
	if (ItemAbility:IsItem())then
		local Caster = keys.caster
		local CasterPlayerID = Caster:GetPlayerOwnerID()
		local RestoreGold = ItemAbility:GetCost()*keys.RestoreGoldPercent*0.01
		PlayerResource:SetGold(CasterPlayerID,PlayerResource:GetUnreliableGold(CasterPlayerID) + RestoreGold,false)
		Caster:RemoveItem(ItemAbility)
		SendOverheadEventMessage(Caster:GetOwner(),OVERHEAD_ALERT_GOLD,Caster,RestoreGold,nil)
	end
end

function ItemAbility_PresentBox_OnInterval(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local CasterPlayerID = Caster:GetPlayerOwnerID()
	--DebugPrint("now:"..PlayerResource:GetUnreliableGold(CasterPlayerID).."+"..keys.GiveGoldAmount)
	--PlayerResource:SetGold(CasterPlayerID,PlayerResource:GetUnreliableGold(CasterPlayerID) + keys.GiveGoldAmount,false)
	--SendOverheadEventMessage(Caster:GetOwner(),OVERHEAD_ALERT_GOLD,Caster,keys.GiveGoldAmount,nil)
	local game_time = math.floor(GameRules:GetDOTATime(false, false) / 60)	
	if game_time >0 then	
	Caster:ModifyGold(keys.GiveGoldAmount, false, 0)
	end
end

function ItemAbility_Lifu_RestoreGold(keys)
	local ItemAbility = keys.ability
	if (ItemAbility:IsItem())then
		local Caster = keys.caster
		local CasterPlayerID = Caster:GetPlayerOwnerID()
		local RestoreGold = ItemAbility:GetCost()*keys.RestoreGoldPercent*0.01
		PlayerResource:SetGold(CasterPlayerID,PlayerResource:GetUnreliableGold(CasterPlayerID) + RestoreGold,false)
		Caster:RemoveItem(ItemAbility)
		SendOverheadEventMessage(Caster:GetOwner(),OVERHEAD_ALERT_GOLD,Caster,RestoreGold,nil)
	end
end

function ItemAbility_Lifu_OnInterval(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local CasterPlayerID = Caster:GetPlayerOwnerID()
	--DebugPrint("now:"..PlayerResource:GetUnreliableGold(CasterPlayerID).."+"..keys.GiveGoldAmount)
	--PlayerResource:SetGold(CasterPlayerID,PlayerResource:GetUnreliableGold(CasterPlayerID) + keys.GiveGoldAmount,false)
	--SendOverheadEventMessage(Caster:GetOwner(),OVERHEAD_ALERT_GOLD,Caster,keys.GiveGoldAmount,nil)
	Caster:ModifyGold(keys.GiveGoldAmount, false, 0)	
end


function OnBurningSakeStart(keys)

	local caster = keys.caster
	local target = keys.target
	
	target:EmitSound("BurningSake2")
	target:EmitSound("BurningSake1")
	target:EmitSound("BurningSake3")
	
	local particle3 = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_cast.vpcf", PATTACH_CUSTOMORIGIN, target)
		local vecTarget = target:GetOrigin()

		ParticleManager:SetParticleControl(particle3, 0, vecTarget)	
		ParticleManager:SetParticleControl(particle3, 1, vecTarget)			
		ParticleManager:SetParticleControl(particle3, 2, vecTarget)	
	

end

function OnBurningSakeAttack(keys)
	local caster = keys.caster
	local attackerx = keys.attacker
	
	if RollPercentage(keys.stunchance) then
		EmitGlobalSound("BurningSakeSelf_"..math.random(1,6))	
	--	attackerx:EmitSound("BurningSakeSelf_"..math.random(1,6))		
		UtilStun:UnitStunTarget( caster,attackerx,keys.stun_duration)
	end


end

function ItemAbility_burning_sake_OnInterval(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local CasterPlayerID = Caster:GetPlayerOwnerID()

	
	Caster:ModifyGold(keys.GiveGoldAmount, false, 0)	
end

function Lifureturnward(keys)
--	local ItemAbility = keys.ability
	local Caster = keys.caster
	
	local CurrentActiveAbility = Caster:GetCurrentActiveAbility()
--	if CurrentActiveAbility then
	print(CurrentActiveAbility:GetAbilityName())
	
--	end

	
end

function ItemAbility_Peach_OnTakeDamage(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local DamageTaken = keys.DamageTaken
	local TakeDamageCount = Caster.ItemAbility_Peach_TakeDamageCount
	local SpeedupDuration = keys.SpeedupDuration
	local SpeedupModifierName = keys.SpeedupModifierName
	local SpeedupMaxModifierStack = keys.SpeedupMaxModifierStack
	local TimeNow = GameRules:GetGameTime()
	if (TakeDamageCount==nil) then
		TakeDamageCount=0
	end
	
	if (Caster.ItemAbility_Peach_LastTriggerTime==nil or TimeNow-Caster.ItemAbility_Peach_LastTriggerTime>=SpeedupDuration) then
		TakeDamageCount=0
		Caster.ItemAbility_Peach_LastTriggerTime = GameRules:GetGameTime()
	end
	
	TakeDamageCount = TakeDamageCount + DamageTaken
	Caster.ItemAbility_Peach_TakeDamageCount=TakeDamageCount
	DebugPrint("Item_Peach TakenDamageCount.."..TakeDamageCount)
	
	if (TakeDamageCount>keys.TakeDamageTrigger) then
		local ModifierCount = round(TakeDamageCount/keys.TakeDamageTrigger)+1
		local TriggerBuff = nil
		ModifierCount = min(ModifierCount,SpeedupMaxModifierStack)
		
		if (Caster:HasModifier(SpeedupModifierName)) then
			if (Caster:GetModifierStackCount(SpeedupModifierName,Caster)~=ModifierCount or (ModifierCount==SpeedupMaxModifierStack and TimeNow>Caster.ItemAbility_Peach_LastTriggerTime)) then
				Caster:RemoveModifierByName(SpeedupModifierName)
				ItemAbility:ApplyDataDrivenModifier(Caster,Caster,SpeedupModifierName,{duration = SpeedupDuration})
				Caster:SetModifierStackCount(SpeedupModifierName,ItemAbility,ModifierCount)
				TriggerBuff = true
			end
		else
			ItemAbility:ApplyDataDrivenModifier(Caster,Caster,SpeedupModifierName,{duration = SpeedupDuration})
			Caster:SetModifierStackCount(SpeedupModifierName,ItemAbility,ModifierCount)
			TriggerBuff = true
		end
		
		if (TriggerBuff) then
			Caster.ItemAbility_Peach_LastTriggerTime = TimeNow
		end
	end
end

function ItemAbility_Anchor_OnTakeDamage(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local DamageTaken = keys.DamageTaken
	local TakeDamageCount = Caster.ItemAbility_Anchor_TakeDamageCount
	local BuffDuration = keys.BuffDuration
	local IconModifierName = keys.IconModifierName
	local BuffMaxStack = keys.BuffMaxStack
	local TimeNow = GameRules:GetGameTime()
	if (TakeDamageCount==nil) then
		TakeDamageCount=0
	end
	
	if (Caster.ItemAbility_Anchor_LastTriggerTime==nil or TimeNow-Caster.ItemAbility_Anchor_LastTriggerTime>=BuffDuration) then
		TakeDamageCount=0
		Caster.ItemAbility_Anchor_LastTriggerTime = TimeNow
	end
	
	TakeDamageCount = TakeDamageCount + DamageTaken
	Caster.ItemAbility_Anchor_TakeDamageCount=TakeDamageCount
	DebugPrint("Item_Anchor TakenDamageCount.."..TakeDamageCount)
	
	if (TakeDamageCount>keys.TakeDamageTrigger) then
		local ModifierCount = round(TakeDamageCount/keys.TakeDamageTrigger)+1
		local TriggerBuff = nil
		ModifierCount = keys.CritChanceConst+min(ModifierCount,BuffMaxStack)*keys.BuffCritChance
		
		if (Caster:HasModifier(IconModifierName)) then
			if (Caster:GetModifierStackCount(IconModifierName,Caster)~=ModifierCount or (ModifierCount==keys.CritChanceConst+BuffMaxStack*keys.BuffCritChance and TimeNow>Caster.ItemAbility_Anchor_LastTriggerTime)) then
				Caster:RemoveModifierByName(IconModifierName)
				ItemAbility:ApplyDataDrivenModifier(Caster,Caster,IconModifierName,{duration = BuffDuration})
				Caster:SetModifierStackCount(IconModifierName,ItemAbility,ModifierCount)
				TriggerBuff = true
			end
		else
			ItemAbility:ApplyDataDrivenModifier(Caster,Caster,IconModifierName,{duration = BuffDuration})
			Caster:SetModifierStackCount(keys.IconModifierName,ItemAbility,ModifierCount)
			TriggerBuff = true
		end
		
		if (TriggerBuff) then
			Caster.ItemAbility_Anchor_LastTriggerTime = TimeNow
		end
	end
end

function ItemAbility_Anchor_OnAttackStart(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local CritChance = keys.CritChanceConst
	
	if (Caster:HasModifier(keys.IconModifierName)) then
		CritChance = Caster:GetModifierStackCount(keys.IconModifierName,Caster)
	end
	
	if (CritChance>=RandomInt(1,100)) then
		ItemAbility:ApplyDataDrivenModifier(Caster,Caster,keys.CritModifierName,{})
	end
end

function ItemAbility_NuclearStick_OnAbility(keys)
	local Caster=keys.caster
	local Ability=Caster:GetCurrentActiveAbility()
	local ReductionCooldown=keys.ReductionCooldown
	local AbilityCooldown=Ability:GetCooldown(Ability:GetLevel())*(100-ReductionCooldown)*0.01
	if not Ability or Ability:IsItem() then return end
	Caster:SetThink(function()
		DebugPrint("StartCooldown: "..tostring(AbilityCooldown).." sec")
		Ability:EndCooldown()
		Ability:StartCooldown(AbilityCooldown)
		return nil
	end)
end

function ItemAbility_Yuri_OnSpell(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	local ContractOverRange = keys.ContractOverRange
	local MaxRange = ContractOverRange*3
	local MaxSpeed=keys.MaxSpeed
	local BuffModifierName = keys.BuffModifierName
	local FirstDistance = 400
	DebugFunction(PrintTargetInfo,Target)
	
	if Caster:GetTeam()~=Target:GetTeam() and is_spell_blocked_by_hakurei_amulet(Target) then
		return
	end
	
	ItemAbility:ApplyDataDrivenModifier(Caster,Caster,keys.BuffModifierName,{})

	local effectIndex = ItemAbility_Yuri_create_line(Caster,Target)

	Caster:SetThink(function ()
		local CasterPos = Caster:GetAbsOrigin()
		local TargetPos = Target:GetAbsOrigin()
		local Distance = distance(CasterPos,TargetPos)
		if (Caster:HasModifier(BuffModifierName)==false or Target:IsAlive()==false or Distance>MaxRange) then
			Caster:RemoveModifierByNameAndCaster(BuffModifierName,Caster)
			ParticleManager:DestroyParticleSystem(effectIndex,true)
			return nil
		end
		
		if (Distance>FirstDistance) then
			local vec = TargetPos - CasterPos
			local MoveDistance = (Distance-FirstDistance)
			MoveDistance=(MoveDistance*MoveDistance)/(200*200)*MaxSpeed*0.02
			if MoveDistance>1.0 then
				Caster:SetAbsOrigin(CasterPos + vec:Normalized()*MoveDistance)
			end
		end
		return 0.02
	end)
end

function ItemAbility_Yuri_create_line(caster,target)
	local effectIndex = ParticleManager:CreateParticle("particles/thd2/items/item_lily.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 1, target, 5, "attach_hitloc", Vector(0,0,0), true)
	return effectIndex
end

function ItemAbility_Pad_Physical_Block(keys)
	local Caster = keys.caster
	local DamageBlock = min(keys.DamageBlock,keys.DamageTaken)
	
	DebugPrint("ItemAbility_Pad Physical Block: "..DamageBlock)
	Caster:SetHealth(Caster:GetHealth()+DamageBlock)
	
	
	SendOverheadEventMessage(nil,OVERHEAD_ALERT_BLOCK,Caster,DamageBlock,nil)
end

function ItemAbility_Bra_Physical_Block(keys)
	local Caster = keys.caster
	local DamageBlock = min(keys.DamageBlock,keys.DamageTaken)
	local bExistPad=false
	for i=0,5 do
		local item=Caster:GetItemInSlot(i)
		if item and item:GetName()=="item_pad" then
			bExistPad=true
			break
		end
	end
	if bExistPad then return end
	
	DebugPrint("ItemAbility_Bra Physical Block: "..DamageBlock)
	Caster:SetHealth(Caster:GetHealth()+DamageBlock)
	
	SendOverheadEventMessage(nil,OVERHEAD_ALERT_BLOCK,Caster,DamageBlock,nil)
end

function ItemAbility_MoonBow_OnHit(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	local damage_to_deal = keys.arrow_damage_const + Caster:GetIntellect()*keys.arrow_damage_int_mult
	--if (Target:IsHero()) then
		if (damage_to_deal>0) then
			local damage_table = {
				ability = ItemAbility,
				victim = Target,
				attacker = Caster,
				damage = damage_to_deal,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = 0
			}
			--PrintTable(damage_table)
			DebugPrint("ItemAbility_Moon_Bow_OnHit| Damage:"..damage_to_deal)
			UnitDamageTarget(damage_table)
			
			
			SendOverheadEventMessage(nil,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,Target,damage_to_deal,nil)
		end
	--end
end
function MoonBowManaCost(keys)
local caster=keys.caster
local manacostpct=keys.ManaCostPct
local ability=keys.ability
local mana=caster:GetMaxMana()*manacostpct/100
caster:SpendMana(mana,ability)


end

function ItemAbility_InabaIllusionWeapon_OnEquip(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local AttackCapability=Caster:GetAttackCapability()
	local IsMelee=false
	local IsRanged=false
	local IsCannon=false
	if AttackCapability==DOTA_UNIT_CAP_MELEE_ATTACK then IsMelee=true
	elseif AttackCapability==DOTA_UNIT_CAP_RANGED_ATTACK then IsRanged=true
	else IsCannon=true end 
	
	if IsMelee then
		if not Caster:HasModifier(keys.ModifierBuffMelee) then
			ItemAbility:ApplyDataDrivenModifier(Caster,Caster,keys.ModifierBuffMelee,{})
		end
	elseif IsRanged then
		if not Caster:HasModifier(keys.ModifierBuffRanged) then
			ItemAbility:ApplyDataDrivenModifier(Caster,Caster,keys.ModifierBuffRanged,{})
		end
	elseif IsCannon then
		if not Caster:HasModifier(keys.ModifierBuffCannon) then
			ItemAbility:ApplyDataDrivenModifier(Caster,Caster,keys.ModifierBuffCannon,{})
		end
	end
end

function ItemAbility_InabaIllusionWeapon_OnUnequip(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local ItemCount = 0
	for i=0,5 do
		local curr_item=Caster:GetItemInSlot(i)
		if curr_item and curr_item:GetName()==ItemAbility:GetName() then
			ItemCount=ItemCount+1
		end
	end
	if ItemCount<=0 then
		if Caster:HasModifier(keys.ModifierBuffMelee) then
			Caster:RemoveModifierByName(keys.ModifierBuffMelee)
		end
		if Caster:HasModifier(keys.ModifierBuffRanged) then
			Caster:RemoveModifierByName(keys.ModifierBuffRanged)
		end
		if Caster:HasModifier(keys.ModifierBuffCannon) then
			Caster:RemoveModifierByName(keys.ModifierBuffCannon)
		end
	end
end

function ItemAbility_InabaIllusionWeapon_Melee_OnAttackLanded(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	local CleavePercent=keys.CleavePercent
	local CleaveRadius=keys.CleaveRadius
	local ItemCount=0
	if Caster:IsRealHero() and Caster:GetTeam()~=Target:GetTeam() then
		for i=0,5 do
			local curr_item=Caster:GetItemInSlot(i)
			if curr_item and curr_item:GetName()==ItemAbility:GetName() then
				ItemCount=ItemCount+1
			end
		end
		
		if (ItemCount>0) then
			local Damage=keys.AttackDamage*ItemCount*CleavePercent*0.01
			DoCleaveAttack(Caster,Target,ItemAbility,Damage,CleaveRadius,CleaveRadius,CleaveRadius,"particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf")
		end
	end
end
function Deathdrop(keys)
local caster=keys.caster
local ability=keys.ability
caster:DropItemAtPositionImmediate(ability,caster:GetAbsOrigin())


end

function ItemAbility_InabaIllusionWeapon_Ranged_OnAttack(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	local RangedSplitNum=keys.RangedSplitNum
	local RangedSplitRadius=keys.RangedSplitRadius
--	local casterattackrange = Caster:GetAttackRange()+200
	local casterattackrange = Caster:Script_GetAttackRange()+200
	local ItemCount=0
	if Caster:GetTeam()~=Target:GetTeam() then
		for i=0,5 do
			local curr_item=Caster:GetItemInSlot(i)
			if curr_item and curr_item:GetName()==ItemAbility:GetName() then
				ItemCount=ItemCount+1
			end
		end
		local MaxTargets=ItemCount*RangedSplitNum
	--	local Targets=FindUnitsInRadius(Caster:GetTeamNumber(),
	--									Caster:GetAbsOrigin(),
	--									nil,
	--									RangedSplitRadius,
	--									DOTA_UNIT_TARGET_TEAM_ENEMY,
	--									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
	--									DOTA_UNIT_TARGET_FLAG_NONE,
	--									FIND_ANY_ORDER,--[[FIND_CLOSEST,]]
	--									false)		
		
		local Targets=FindUnitsInRadius(Caster:GetTeamNumber(),
										Caster:GetAbsOrigin(),
										nil,
										casterattackrange,
										DOTA_UNIT_TARGET_TEAM_ENEMY,
										DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
										DOTA_UNIT_TARGET_FLAG_NONE,
										FIND_ANY_ORDER,--[[FIND_CLOSEST,]]
										false)
		for _,unit in pairs(Targets) do
			if MaxTargets>0 then
				if unit and unit:IsAlive() and unit~=Target and Caster:CanEntityBeSeenByMyTeam(unit) then
					Caster:PerformAttack(unit,true,false,true,false,true,false,true)
					MaxTargets=MaxTargets-1
				end
			else break end
		end
	end
end

function ItemAbility_InabaIllusionWeapon_Cannon_OnAttackLanded(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	local CannonDamageMin=keys.CannonDamageMin
	local CannonDamageMax=keys.CannonDamageMax
	local CannonDamageRadius=keys.CannonDamageRadius
	local ItemCount=0
	if Caster:IsRealHero() and Caster:GetTeam()~=Target:GetTeam() then
		for i=0,5 do
			local curr_item=Caster:GetItemInSlot(i)
			if curr_item and curr_item:GetName()==ItemAbility:GetName() then
				ItemCount=ItemCount+1
			end
		end
		
		if (ItemCount>0) then
			local Damage=RandomFloat(CannonDamageMin,CannonDamageMax)*ItemCount
			local Targets=FindUnitsInRadius(Caster:GetTeamNumber(),
											Target:GetAbsOrigin(),
											nil,
											CannonDamageRadius,
											DOTA_UNIT_TARGET_TEAM_ENEMY,
											DOTA_UNIT_TARGET_ALL,
											DOTA_UNIT_TARGET_FLAG_NONE,
											FIND_ANY_ORDER,
											false)
			for _,unit in pairs(Targets) do
				if unit and unit:IsAlive() then
					UnitDamageTarget{
						ability = ItemAbility,
						victim = unit,
						attacker = Caster,
						damage = Damage,
						damage_type = DAMAGE_TYPE_PURE
					}
				end
			end	
			DebugPrint("ItemAbility_InabaIllusionWeapon_Cannon_OnAttackLanded| Damage:"..Damage)
		end
	end
end
--------------------------------------------------------------------------------------------------------
--[[
	item_hakurei_amulet
]]
function is_spell_blocked_by_hakurei_amulet(target)
	if target:HasModifier("modifier_item_sphere_target") then
		target:RemoveModifierByName("modifier_item_sphere_target")  --The particle effect is played automatically when this modifier is removed (but the sound isn't).
		target:EmitSound("DOTA_Item.LinkensSphere.Activate")
		return true
	end
	return false
end

function ItemAbility_HakureiAmulet_OnCreated(keys)
	if keys.ability ~= nil and keys.ability:IsCooldownReady() then
		if keys.caster:HasModifier("modifier_item_sphere_target") then  --Remove any potentially temporary version of the modifier and replace it with an indefinite one.
			keys.caster:RemoveModifierByName("modifier_item_sphere_target")
		end
		keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_item_sphere_target", {duration = -1})
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_item_hakurei_amulet_icon", {duration = -1})
	end
end

function ItemAbility_HakureiAmulet_OnDestroy(keys)
	local num_off_cooldown_linkens_spheres_in_inventory = 0
	for i=0, 5, 1 do --Search for off-cooldown Linken's Spheres in the player's inventory.
		local current_item = keys.caster:GetItemInSlot(i)
		if current_item ~= nil then
			if current_item:GetName() == "item_hakurei_amulet" and current_item:IsCooldownReady() then
				num_off_cooldown_linkens_spheres_in_inventory = num_off_cooldown_linkens_spheres_in_inventory + 1
			end
		end
	end
	
	--If the player just got rid of their last Linken's Sphere, which was providing the passive spellblock.
	if num_off_cooldown_linkens_spheres_in_inventory == 0 then
		keys.caster:RemoveModifierByName("modifier_item_sphere_target")
		keys.caster:RemoveModifierByName("modifier_item_hakurei_amulet_icon")
	end
end
function ItemAbility_HakureiAmulet_OnIntervalThink(keys)
	if not keys.caster:HasModifier("modifier_item_sphere_target") then
		if keys.caster:HasModifier("modifier_item_hakurei_amulet_icon") then -- blocked spell
			for i=0, 5, 1 do
				local current_item = keys.caster:GetItemInSlot(i)
				if current_item ~= nil and current_item:GetName()=="item_hakurei_amulet" then
					current_item:StartCooldown(current_item:GetCooldown(current_item:GetLevel()))
				end
			end
			keys.caster:RemoveModifierByName("modifier_item_hakurei_amulet_icon")
		else -- reset modifier
			local num_off_cooldown_linkens_spheres_in_inventory = 0
			for i=0, 5, 1 do
				local current_item = keys.caster:GetItemInSlot(i)
				if current_item ~= nil then
					if current_item:GetName() == "item_hakurei_amulet" and current_item:IsCooldownReady() then
						num_off_cooldown_linkens_spheres_in_inventory = num_off_cooldown_linkens_spheres_in_inventory + 1
					end
				end
			end
			if num_off_cooldown_linkens_spheres_in_inventory>0 then
				keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_item_sphere_target", {duration = -1})
				keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_item_hakurei_amulet_icon", {duration = -1})
			end
		end
	end
end

function ItemAbility_Qijizhixing_OnSpellStart(keys)
	local caster = keys.caster
	local target = keys.target
	
	local totalheal = (keys.HealAmount + caster:GetMaxMana() * (keys.BonusHeal/100))

--	target:Heal(totalheal,caster)
--	SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,target,totalheal,nil)

	THDHealTarget(caster,target,totalheal)
	target:Purge(false,true,false,true,false)
end

function ItemAbility_Ganggenier_OnDealDamage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if(caster.ganggenierlock == nil)then
		caster.ganggenierlock = false
	end

	if(caster.ganggenierlock == true)then
		return
	end

	caster.ganggenierlock = true
	
	local damage_table = {
		ability = keys.ability,
		victim = keys.unit,
		attacker = caster,
		damage = keys.DamageDeal * keys.IncreaseDamage/100,
		damage_type = DAMAGE_TYPE_PURE, 
		damage_flags = DOTA_DAMAGE_FLAG_NONE
	}
	UnitDamageTarget(damage_table)
	caster.ganggenierlock = false
end

function ItemAbility_Morenjingjuan_Antiblink_OnSpellStart(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local vecTarget = target:GetOrigin()
	local attackspeed = keys.AttackSpeedIncrese * (caster:GetMaxMana() - target:GetMaxMana())

	target.isAntiBlink = true

	attackspeedint =  math.floor(attackspeed/100)

	ability:ApplyDataDrivenModifier(caster,caster,"modifier_item_morenjingjuan_buff",{duration = keys.Duration})
	caster:SetModifierStackCount("modifier_item_morenjingjuan_buff",ability,attackspeedint)

	local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_ambient_body.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(effectIndex, 0, vecTarget)

	local effectIndex2 = ParticleManager:CreateParticle("particles/thd2/items/item_morenjingjuan.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex2 , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
	ParticleManager:SetParticleControl(effectIndex2, 1, Vector(0,0,0))
	ParticleManager:SetParticleControl(effectIndex2, 6, Vector(1,1,1))
	ParticleManager:DestroyParticleSystemTime(effectIndex2,keys.Duration)

	local count = 0

	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString('item_ability_morenjingjuan'),
    	function ()
    		if GameRules:IsGamePaused() then return 0.03 end
    		count = count + 0.03

    		if target:HasModifier("modifier_item_morenjingjuan_antiblink") == false then
				ParticleManager:DestroyParticleSystem(effectIndex,true)
    			return nil
    		end

    		if target.is_Iku_02_knock == true then
    			return 0.03
    		end

		    target:SetOrigin(vecTarget)

		    if count > keys.Duration then
		    	ParticleManager:DestroyParticleSystem(effectIndex,true)
		    	return nil
		    else
		    	return 0.03
		    end
	    end,
	    0.03
	)

end

function ItemAbility_yuemianzhinu_range(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_item_yuemianzhinu_range",{})
	end
end

function modifier_item_bagua_spellamp(keys)
   local caster=keys.caster
   local ability=keys.ability
   ability:ApplyDataDrivenModifier(caster,caster,"modifier_item_bagua_spellamp",{})
end

function ItemAbility_phoenix_wing_burn(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local distance = GetDistanceBetweenTwoVec2D(caster:GetOrigin(),target:GetOrigin())
	local dealdamage = keys.damage + caster:GetMaxHealth() * keys.damage_percent/100
	if distance>=0 and distance<200 then
		dealdamage = dealdamage
	elseif distance>=200 and distance<400 then
		dealdamage = dealdamage*1
	elseif distance>=400 then
		dealdamage = dealdamage*1
	end
		local damage_table = {
				ability = ability,
			    victim = target,
			    attacker = caster,
			    damage = dealdamage,
			    damage_type = DAMAGE_TYPE_MAGICAL, 
	    	    damage_flags = DOTA_DAMAGE_FLAG_HPLOSS
		}	
--	ApplyDamage(damage_table)
	UnitDamageTarget2(damage_table)	
	--UnitDamageTarget({
	--	ability = ability,
	--	victim = target,
	--	attacker = caster,
	--	damage = dealdamage,
	--	damage_type = DAMAGE_TYPE_MAGICAL
	--})
end

function modifier_item_lifesteal_datadriven_on_orb_impact(keys)
	if keys.target.GetInvulnCount == nil then
		keys.ability:ApplyDataDrivenModifier(keys.attacker, keys.attacker, "modifier_thd_life_steal", {duration = 0.01})
	end
end
function modifier_item_red_sword_of_distortion_on_orb_impact(keys)
	if keys.target.GetInvulnCount == nil then
		keys.ability:ApplyDataDrivenModifier(keys.attacker, keys.attacker, "modifier_item_red_sword_of_distortion_lifesteal", {duration = 0.03})
	end
end
function modifier_item_autumn_leaves_on_orb_impact(keys)
	if keys.target.GetInvulnCount == nil then
		keys.ability:ApplyDataDrivenModifier(keys.attacker, keys.attacker, "modifier_item_autumn_leaves_lifesteal", {duration = 0.03})
	end
end
function modifier_item_teeth_on_orb_impact(keys)
	if keys.target.GetInvulnCount == nil then
		keys.ability:ApplyDataDrivenModifier(keys.attacker, keys.attacker, "modifier_item_teeth_lifesteal", {duration = 0.03})
	end
end
function modifier_item_teeth_on_orb_impact2(keys)
	if keys.target.GetInvulnCount == nil then
		keys.ability:ApplyDataDrivenModifier(keys.attacker, keys.attacker, "modifier_item_teeth_lifesteal_active", {duration = 0.03})
	end
end


function OnZunGlasses_Take_Damage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if(caster:GetHealth()<=keys.DamageTaken and caster:GetClassname()~="npc_dota_hero_necrolyte")then
		local randomInt = RandomInt(0,100)
		if randomInt <= 100 and keys.ability:IsCooldownReady() then
			caster:SetHealth(caster:GetHealth()+keys.DamageTaken)
			keys.ability:StartCooldown(keys.ability:GetCooldown(keys.ability:GetLevel()))
		end
	end
end

function modifier_item_grudge_bow_magic_resistance_decreasing(params)
local target_stack = params.target:FindModifierByName("modifier_item_grudge_bow_magic_resistance_decrease2")
 if params.caster:IsRealHero() and not params.target:IsBuilding() then
  if target_stack==nil then 
  params.ability:ApplyDataDrivenModifier(params.caster, params.target, "modifier_item_grudge_bow_magic_resistance_decrease2",nil)
  params.target:FindModifierByName("modifier_item_grudge_bow_magic_resistance_decrease2"):IncrementStackCount()
  else
        if target_stack:GetStackCount() < params.MaxStack then 
        target_stack:IncrementStackCount()		
        end
  target_stack:SetDuration(params.Duration, true)		
  end  

  local damage_table = {
				ability = params.ability,
				victim = params.target,
				attacker = params.caster,
				damage = params.Damage,
				damage_type = DAMAGE_TYPE_MAGICAL, 
				damage_flags = 0
		}
  UnitDamageTarget(damage_table)
  end
	
end  


--function modifier_item_red_sword_of_distortion_amplify(keys)
--local AmpDamage = 
--if keys.target.GetInvulnCount == nil then  --If the caster is not attacking a building.
		--ApplyDamage({victim = keys.target, attacker = keys.caster, damage = keys.WindwalkBonusDamage, damage_type = DAMAGE_TYPE_PHYSICAL,})
	--end
-------------------------------------------------------------------------------------------------------------------
--[[Author: Pizzalol
	Date: 18.01.2015.
	Checks if the target is an illusion, if true then it kills it
	otherwise the target model gets swapped into a frog]]
function voodoo_start( keys )
	local target = keys.target
	local model = keys.model

	if target:IsIllusion() then
		target:ForceKill(true)
	else
		if target.target_model == nil then
			target.target_model = target:GetModelName()
		end

		target:SetOriginalModel(model)
	end
end

--[[Author: Pizzalol
	Date: 18.01.2015.
	Reverts the target model back to what it was]]
function voodoo_end( keys )
	local target = keys.target

	-- Checking for errors
	if target.target_model ~= nil then
		target:SetModel(target.target_model)
		target:SetOriginalModel(target.target_model)
	end
end

--[[Author: Noya
	Date: 10.01.2015.
	Hides all dem hats
]]
function HideWearables( event )
	--[[
	local hero = event.target
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	print("Hiding Wearables")
	--hero:AddNoDraw() -- Doesn't work on classname dota_item_wearable

	hero.wearableNames = {} -- In here we'll store the wearable names to revert the change
	hero.hiddenWearables = {} -- Keep every wearable handle in a table, as its way better to iterate than in the MovePeer system
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() ~= "" and model:GetClassname() == "dota_item_wearable" then
            local modelName = model:GetModelName()
            if string.find(modelName, "invisiblebox") == nil then
            	-- Add the original model name to revert later
            	table.insert(hero.wearableNames,modelName)
            	print("Hidden "..modelName.."")

            	-- Set model invisible
            	model:SetModel("models/development/invisiblebox.vmdl")
            	table.insert(hero.hiddenWearables,model)
            end
        end
        model = model:NextMovePeer()
        if model ~= nil then
        	print("Next Peer:" .. model:GetModelName())
        end
    end]]
end

--[[Author: Noya
	Date: 10.01.2015.
	Shows the hidden hero wearables
]]
function ShowWearables( event )
	--[[
	local hero = event.target
	print("Showing Wearables on ".. hero:GetModelName())

	-- Iterate on both tables to set each item back to their original modelName
	for i,v in ipairs(hero.hiddenWearables) do
		for index,modelName in ipairs(hero.wearableNames) do
			if i==index then
				print("Changed "..v:GetModelName().. " back to "..modelName)
				v:SetModel(modelName)
			end
		end
	end]]
end


LinkLuaModifier( "modifier_item_loneliness_thdr_passive", "items/item_lua/item_loneliness_thdr.lua", LUA_MODIFIER_MOTION_NONE )

function modifier_item_loneliness_regen(keys)
   local caster=keys.caster
   local ability=keys.ability
 --  ability:ApplyDataDrivenModifier(caster,caster,"modifier_item_loneliness_regen_health",{})
 --  ability:ApplyDataDrivenModifier(caster,caster,"modifier_item_loneliness_regen_health",{})
   caster:AddNewModifier(caster, ability,"modifier_item_loneliness_thdr_passive",  {} ) 
end

function modifier_item_loneliness_regen2(keys)
   local caster=keys.caster
   local ability=keys.ability
   local missinghealth = caster:GetMaxHealth() - caster:GetHealth()
   caster:SetModifierStackCount("modifier_item_loneliness_hp_regen", ability, missinghealth)
end

------------------------------------------------------------------------------------------------
function ItemAbility_THDTALON_OnAttack(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	local damage_to_deal = keys.PhysicalDamage
	if (Caster:IsRealHero() and Target:IsRealHero()==false and Target:IsBuilding()==false and  Caster:HasItemInInventory("item_quelling_blade") ~= true and Caster:GetAttackCapability() == 1 ) then
		local damage_table = {
			ability = ItemAbility,
			victim = Target,
			attacker = Caster,
			damage = damage_to_deal,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = 1
		}
		UnitDamageTarget(damage_table)
		local effectIndex = ParticleManager:CreateParticle("particles/econ/items/sniper/sniper_charlie/sniper_base_attack_explosion_charlie.vpcf", PATTACH_ABSORIGIN_FOLLOW, Target)
		ParticleManager:SetParticleControl(effectIndex, 3, Caster:GetAbsOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)
	end
	if (Caster:IsRealHero() and Target:IsRealHero()==false and Target:IsBuilding()==false and  Caster:HasItemInInventory("item_quelling_blade") ~= true and Caster:GetAttackCapability() == 1 and Target:IsNeutralUnitType()==true ) then
		local damage_table = {
			ability = ItemAbility,
			victim = Target,
			attacker = Caster,
			damage = damage_to_deal,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = 1
		}
		UnitDamageTarget(damage_table)
		local effectIndex = ParticleManager:CreateParticle("particles/econ/items/sniper/sniper_charlie/sniper_base_attack_explosion_charlie.vpcf", PATTACH_ABSORIGIN_FOLLOW, Target)
		ParticleManager:SetParticleControl(effectIndex, 3, Caster:GetAbsOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)
	end	
end

function talon_nuke(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability	
	
	

	
	if ( target:IsNeutralUnitType()==true ) and (target:IsAncient()==false ) then
	 ApplyDamage({victim = target, attacker = caster, damage = target:GetHealth()*0.4 , damage_type = DAMAGE_TYPE_PURE})
	
	caster:EmitSound("thd_irontalon")	
	
	end
	
	
	
	if  target:GetName() == "npc_dota_ward_base" then
	target:Kill(caster, caster) 
	end	

	if target:GetName() == "npc_dota_ward_base_truesight" then
	target:Kill(caster, caster) 
	end	
	

	if target:GetName() ~= "npc_dota_ward_base_truesight" and target:GetName() ~= "npc_dota_ward_base" and target:IsNeutralUnitType()~=true then
	ability:EndCooldown()
	return
	
	
	end	
	if target:IsAncient()==true then
	ability:EndCooldown()
	return
	
	
	end		

end


function modifier_item_smart_phone(params)
local caster_stack = params.caster:FindModifierByName("modifier_item_smart_phone_buff")
 --if params.caster:IsRealHero() and not params.target:IsBuilding() then
 
  if caster_stack==nil then 
  params.ability:ApplyDataDrivenModifier(params.caster, params.caster, "modifier_item_smart_phone_buff",nil)
  params.caster:FindModifierByName("modifier_item_smart_phone_buff"):IncrementStackCount()
  else
        if caster_stack:GetStackCount() < params.MaxStack then 
        caster_stack:IncrementStackCount()		
        end
  caster_stack:SetDuration(params.Duration, true)		
  end

params.caster:GiveMana(2)

end  


function modifier_item_pad_check(keys)
	local ItemAbility = keys.ability
	local caster = keys.caster
	local AttackCapability=caster:GetAttackCapability()
	
	if AttackCapability==DOTA_UNIT_CAP_MELEE_ATTACK then 
	
	ItemAbility:ApplyDataDrivenModifier(caster,caster,"modifier_item_pad_melee",{})	
	
	end
	
	if AttackCapability==DOTA_UNIT_CAP_RANGED_ATTACK then 
	
	ItemAbility:ApplyDataDrivenModifier(caster,caster,"modifier_item_pad_range",{})	
	
	end
		
	
	
	
	

end

function modifier_item_pad_check2(keys)
	local ItemAbility = keys.ability
	local caster = keys.caster
	local AttackCapability=caster:GetAttackCapability()
	
	if AttackCapability==DOTA_UNIT_CAP_MELEE_ATTACK then 
	
	--ItemAbility:ApplyDataDrivenModifier(caster,caster,"modifier_item_pad_melee",{})	
	caster:RemoveModifierByName("modifier_item_pad_melee")
	end
	
	if AttackCapability==DOTA_UNIT_CAP_RANGED_ATTACK then 
	
	--ItemAbility:ApplyDataDrivenModifier(caster,caster,"modifier_item_pad_range",{})	
	
	caster:RemoveModifierByName("modifier_item_pad_range")	
	end
		
	
	
	
	

end

function modifier_item_bra_check(keys)
	local ItemAbility = keys.ability
	local caster = keys.caster
	local AttackCapability=caster:GetAttackCapability()
	
	if AttackCapability==DOTA_UNIT_CAP_MELEE_ATTACK then 
	
	ItemAbility:ApplyDataDrivenModifier(caster,caster,"modifier_item_bra_melee",{})	
	
	end
	
	if AttackCapability==DOTA_UNIT_CAP_RANGED_ATTACK then 
	
	ItemAbility:ApplyDataDrivenModifier(caster,caster,"modifier_item_bra_range",{})	
	
	end
		
	
	
	
	

end

function modifier_item_bra_check2(keys)
	local ItemAbility = keys.ability
	local caster = keys.caster
	local AttackCapability=caster:GetAttackCapability()
	
	if AttackCapability==DOTA_UNIT_CAP_MELEE_ATTACK then 
	
	--ItemAbility:ApplyDataDrivenModifier(caster,caster,"modifier_item_pad_melee",{})	
	caster:RemoveModifierByName("modifier_item_bra_melee")
	end
	
	if AttackCapability==DOTA_UNIT_CAP_RANGED_ATTACK then 
	
	--ItemAbility:ApplyDataDrivenModifier(caster,caster,"modifier_item_pad_range",{})	
	
	caster:RemoveModifierByName("modifier_item_bra_range")	
	end
		
	
	
	
	

end



function ItemAbility_Modifierwatermelon(keys)
	local ItemAbility = keys.ability
	local Caster = keys.Caster or keys.caster
	local Target = keys.Target or keys.target
	Target:RemoveModifierByName("modifier_item_watermelon_debuff")
end

function ItemAbility_Modifiercirnoclaymore(keys)
	local ItemAbility = keys.ability
	local Caster = keys.Caster or keys.caster
	local Target = keys.Target or keys.target
	Target:RemoveModifierByName("modifier_item_cirno_claymore_debuff")
end

function ItemAbility_Modifierdemonbow(keys)
	local ItemAbility = keys.ability
	local Caster = keys.Caster or keys.caster
	local Target = keys.Target or keys.target
	Target:RemoveModifierByName("modifier_item_yuemianzhinu_debuff")
end

function ItemAbility_mushroom_soup_goliath_OnSpellStart(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	Caster:SetBaseIntellect(Caster:GetBaseIntellect() + keys.Increasestat)
	Caster:SetBaseStrength(Caster:GetBaseStrength() + keys.Increasestat)
	Caster:SetBaseAgility(Caster:GetBaseAgility() + keys.Increasestat)	
	if (ItemAbility:IsItem()) then
		Caster:RemoveItem(ItemAbility)
		--ItemAbility:Kill()
	end
end


function modifier_item_green_eye_kaboom (event)



	local caster = event.caster
	local attackerx = event.attacker
	local casterHP = caster:GetHealth()
	local levelscale = event.levelscale
	local explodedamagez = event.explodedamage	
	local hpexplode = event.hpexplode	
	local dealdamage = explodedamagez+(attackerx:GetLevel()*levelscale)+ attackerx:GetMaxHealth()*hpexplode/100		
	if casterHP == 0 and caster:IsIllusion()==false and attackerx:IsBuilding() ==false then 
		
		
			local damage_table = {
				ability = event.ability,
				victim = attackerx,
				attacker = caster,
				damage = dealdamage,
				damage_type = DAMAGE_TYPE_PURE, 
				damage_flags = DOTA_UNIT_TARGET_FLAG_NONE
			}
			UnitDamageTarget(damage_table)		
		
		
		
		
		end
	
	

end

function item3dsound(keys)

local caster = keys.caster

caster:EmitSound("thd_3dsound")

end


function itemsharpsound(keys)

local caster = keys.caster

caster:EmitSound("thd_sharp_phase")

end


function modifier_item_basher_bash_chance_on_attack_landed2(keys)
local Target = keys.target
	if  keys.caster:HasModifier("bash_cooldown_modifier")==false and Target:IsBuilding()==false and keys.caster:IsRealHero() then
		local random_int = RandomInt(1, 100)
		local is_ranged_attacker = keys.caster:IsRangedAttacker()
		local caster = keys.caster
		local meleechance = keys.BashChanceMelee
		local rangechange = keys.BashChanceRanged
		if caster:GetAttackCapability()==1 then
			if RollPercentage(meleechance) then
			keys.target:EmitSound("DOTA_Item.SkullBasher")
			keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_item_basher_bash", nil)
			
			
			--Give the caster a generic "bash cooldown" modifier so they cannot bash in the next couple of seconds due to any item.
			keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "bash_cooldown_modifier", nil)
			end
		end	
		if caster:GetAttackCapability()==2 then
			if RollPercentage(rangechange) then
			keys.target:EmitSound("DOTA_Item.SkullBasher")
			keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_item_basher_bash", nil)
			
			
			--Give the caster a generic "bash cooldown" modifier so they cannot bash in the next couple of seconds due to any item.
			keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "bash_cooldown_modifier", nil)
			end	
		end			
		
	end
end


--LinkLuaModifier("modifier_item_historybook_respawn", "scripts/vscripts/modifiers/items/modifier_item_historybook_respawn.lua", LUA_MODIFIER_MOTION_NONE)


--function OnHistoryBookSetRespawn(keys)
--	local caster = keys.caster
--	local ability = keys.ability
	
--	caster:AddNewModifier(caster, ability, "modifier_item_historybook_respawn",  { Duration = 0.3} )	
	




--end

function ItemAbility_Hisou_fire(keys)

	local caster = keys.caster

	local particle3 = ParticleManager:CreateParticle("particles/newthd/item/sword_of_hisou/sword_of_hisou_fire2.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle3, 0, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z))		
		--ParticleManager:SetParticleControl(particle3, 1, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z)) 	
		--ParticleManager:SetParticleControl(particle3, 2, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z))



end


function THDlifesteal (keys)


	local attacker = keys.attacker
	local target = keys.target
	local dealdamagez = keys.DealDamage
	
--	local toheal = dealdamagez*keys.LifestealPercentz/100
	
	if target:IsBuilding() then
	
	return
	
	end
	
--	attacker:Heal(toheal,attacker)
--	SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,attacker,toheal,nil)	
	
	THDLifestealTarget(attacker,target,keys.LifestealPercentz,dealdamagez)
	
	
--	SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,attacker,toheal,nil)	
	
	local particle3 = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
	ParticleManager:SetParticleControl(particle3, 0, Vector(attacker:GetAbsOrigin().x, attacker:GetAbsOrigin().y, attacker:GetAbsOrigin().z))		



end

function ItemAbility_concordia_effects(keys)

	local caster = keys.caster

	local particle3 = ParticleManager:CreateParticle("particles/newthd/item/sword_of_hisou/sword_of_hisou_fire2.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle3, 0, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z))		
		--ParticleManager:SetParticleControl(particle3, 1, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z)) 	
		--ParticleManager:SetParticleControl(particle3, 2, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z))



end

function ItemAbility_horse_grey(keys)
	local ItemAbility = keys.ability
	local Caster = keys.Caster or keys.caster

	ItemAbility:ApplyDataDrivenModifier(Caster,Caster,"modifier_item_horse_grey_penalty",{})	
	
end


function ItemAbility_RocketMk1_OnHit(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	if is_spell_blocked_by_hakurei_amulet(Target) then
		return
	end
	Caster:EmitSound("THD_ITEM.Rocket_Hit")
	
	
	dealdamage = keys.RocketDamage + (Target:GetMaxHealth() -  Target:GetHealth())*0.5
	
	local truedamage = dealdamage * (1-Target:GetMagicalArmorValue())
	
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, Target,truedamage, nil)
	
	UnitDamageTarget({
		ability = ItemAbility,
		victim = Target,
		attacker = Caster,
		damage = dealdamage,
		damage_type = DAMAGE_TYPE_MAGICAL
	})
	
end




function third_eye_interval (keys)

	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Target = keys.target
	if is_spell_blocked_by_hakurei_amulet(Target) then
		return
	end
	
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, Target,keys.Damage, nil)
	UnitDamageTarget({
		ability = ItemAbility,
		victim = Target,
		attacker = Caster,
		damage = keys.Damage,
		damage_type = DAMAGE_TYPE_PURE
	})

end

function Ghost_blade_start (keys)

	local caster = keys.caster
	local ability = keys.ability
	local ItemAbility = keys.ability	
	ItemAbility:ApplyDataDrivenModifier(caster,caster,keys.ModifierName,{})	
	
end
