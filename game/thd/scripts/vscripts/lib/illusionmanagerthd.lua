
IllusionManagerTHD = IllusionManagerTHD or class({})
function IllusionManagerTHD:CreateIllusion(caster, ability, duration, outgoing_damage, incoming_damage, illusion_spawn)
	if not IsServer() then return end
	
	if not caster then return end

	if caster:IsCourier() then return end
	
	local caster_team = caster:GetTeam()
	local caster_id = caster:GetPlayerID()
	local illsuion_name = caster:GetUnitName()

	local illusion = CreateUnitByName(illsuion_name, illusion_spawn, true, caster, caster:GetOwner(), caster_team)
	
	illusion:SetPlayerID(caster_id)
	illusion:SetControllableByPlayer(caster_id, true)
	illusion:AddNewModifier(caster, ability, "modifier_illusion", {duration = duration, outgoing_damage = outgoing_damage, incoming_damage = incoming_damage})
	illusion:SetHealth(caster:GetHealth())
	illusion:MakeIllusion()
	IllusionManagerTHD:ResetIllusion(caster,illusion)

	return illusion
end
function IllusionManagerTHD:ResetIllusion(tEntity,tIllusion)
	if not IsServer() then return end	
	
	IllusionManagerTHD:WipeIllusion(tIllusion)

	for ability_slot = 0, 16 do
		local ability = tEntity:GetAbilityByIndex(ability_slot)
		if ability then
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			local illusionAbility = tIllusion:FindAbilityByName(abilityName)

			if illusionAbility then 
				illusionAbility:SetLevel(abilityLevel) 
			else
				if abilityName == "item_THD_new_item" then
					print("Ignoring..")
				else
					local newability = tIllusion:AddAbility(abilityName)
					newability:SetLevel(abilityLevel)
				end
			end
		end
	end

	if tIllusion:IsCreep() then return end	
	
	local illusion_level = tIllusion:GetLevel()
	local entity_level 	 = tEntity:GetLevel()
	local leveldifference = entity_level-illusion_level
	local illusion_health = tEntity:GetHealth()

	for i=1,leveldifference do
		tIllusion:HeroLevelUp(false)
	end	

	tIllusion:SetAbilityPoints(0)
	tIllusion:SetHealth(illusion_health)
	
	for item_slot = 0, 8 do
		local individual_item = tEntity:GetItemInSlot(item_slot)
		if individual_item then
			local illusion_duplicate_item = CreateItem(individual_item:GetName(), tIllusion, tIllusion)
			local illusion_individual_item = tIllusion:AddItem(illusion_duplicate_item)
			if individual_item.activestate then
				illusion_individual_item:SetActiveState(individual_item.activestate)
			end
		end
	end
end
function IllusionManagerTHD:WipeIllusion(tIllusion)
	if not IsServer() then return end
	
	for ability_slot = 0, 16 do
		local wipe_ability_index = tIllusion:GetAbilityByIndex(ability_slot)
		if wipe_ability_index then
			local abilityName = wipe_ability_index:GetAbilityName()
			tIllusion:RemoveAbility(abilityName)
		end
	end

	if tIllusion:IsCreep() then return end	

	for item_slot = 0, 8 do	
		local wipe_item_index = tIllusion:GetItemInSlot(item_slot)
		if wipe_item_index then
			tIllusion:RemoveItem(wipe_item_index)
		end		
	end
end
-----------------------------------------------------------------------------------------------------------
THDIllusionManager = THDIllusionManager or class({})
function THDIllusionManager:CreateIllusion(caster, ability, duration, outgoing_damage, incoming_damage, illusion_spawn)
	if not IsServer() then
		return nil
	end
	if not caster:IsRealHero() then
		return nil
	end

	local illusion = CreateUnitByName(caster:GetUnitName(), illusion_spawn, true, caster:GetOwner(), caster:GetOwner(), caster:GetTeam())

	illusion:AddNewModifier(caster, ability, "modifier_illusion", {duration = duration, outgoing_damage = outgoing_damage, incoming_damage = incoming_damage})
	
	illusion:SetPlayerID(caster:GetPlayerID())
	illusion:SetControllableByPlayer(caster:GetPlayerID(), true)

	illusion:MakeIllusion()

	self:ResetIllusion(caster, illusion)

	illusion:SetHealth(caster:GetHealth())
	illusion:SetMana(caster:GetMana())
	
	return illusion
end

function THDIllusionManager:ResetIllusion(caster, illusion)

	for i = 1, (caster:GetLevel() - illusion:GetLevel()) do
		illusion:HeroLevelUp(false)
	end

	illusion:SetAbilityPoints(0)

	for i = 0, 8 do
		local item = illusion:GetItemInSlot(i)
		if item then
			illusion:RemoveItem(item)
		end
	end

	for i = 0, caster:GetAbilityCount() - 1 do
		local ability = caster:GetAbilityByIndex(i)
		if ability then
			local state = ability:GetToggleState()
			local name = ability:GetName()
			local ability_level = ability:GetLevel()
			local illusion_ability = illusion:FindAbilityByName(name)
				
			illusion_ability:SetLevel(ability_level)
			
			if state == true then
				illusion_ability:ToggleAbility()
			end
		end
	end

	for i = 0, 8 do
		local item = caster:GetItemInSlot(i)
		if item then
			local state = item:GetToggleState()
			local item_created = CreateItem(item:GetName(), illusion, illusion)
			local item_added = illusion:AddItem(item_created)
			if state == true then
				item_added:ToggleAbility()
			end
		end
	end
end