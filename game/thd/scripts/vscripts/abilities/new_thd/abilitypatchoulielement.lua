

function PatchouEarthWaterFire(keys)

	local caster = keys.caster
	caster:RemoveAbility("ability_thdotsr_patchouli_water_fire_earth")
	caster:RemoveAbility("ability_thdotsr_patchouli_water_fire_metal")
	caster:RemoveAbility("ability_thdotsr_patchouli_water_fire_wood")
	caster:RemoveAbility("ability_thdotsr_patchouli_fire_metal_wood")
	caster:RemoveAbility("ability_thdotsr_patchouli_metal_wood_water")	
	caster:RemoveAbility("ability_thdotsr_patchouli_fire_metal_earth")		

	caster:AddAbility("ability_thdotsr_patchouli_water_fire")
	caster:AddAbility("ability_thdotsr_patchouli_water_earth")
	caster:AddAbility("ability_thdotsr_patchouli_fire_earth")
	caster:AddAbility("ability_thdotsr_patchouli_ultimate1")
	caster:AddAbility("ability_thdotsr_patchouli_ultimate2")	
	
	caster:SetAbilityPoints(caster:GetAbilityPoints()+1)



end

function PatchouMetalWoodWater(keys)

	local caster = keys.caster
	caster:RemoveAbility("ability_thdotsr_patchouli_water_fire_earth")
	caster:RemoveAbility("ability_thdotsr_patchouli_water_fire_metal")
	caster:RemoveAbility("ability_thdotsr_patchouli_water_fire_wood")
	caster:RemoveAbility("ability_thdotsr_patchouli_fire_metal_wood")
	caster:RemoveAbility("ability_thdotsr_patchouli_metal_wood_water")	
	caster:RemoveAbility("ability_thdotsr_patchouli_fire_metal_earth")		

	caster:AddAbility("ability_thdotsr_patchouli_metal_water")
	caster:AddAbility("ability_thdotsr_patchouli_wood_water")
	caster:AddAbility("ability_thdotsr_patchouli_metal_wood")
	caster:AddAbility("ability_thdotsr_patchouli_ultimate1")
	caster:AddAbility("ability_thdotsr_patchouli_ultimate2")	
	
	caster:SetAbilityPoints(caster:GetAbilityPoints()+1)



end



function PatchouWoodWaterEarth(keys)

	local caster = keys.caster
	caster:RemoveAbility("ability_thdotsr_patchouli_water_fire_earth")
	caster:RemoveAbility("ability_thdotsr_patchouli_water_fire_metal")
	caster:RemoveAbility("ability_thdotsr_patchouli_water_fire_wood")
	caster:RemoveAbility("ability_thdotsr_patchouli_fire_metal_wood")
	caster:RemoveAbility("ability_thdotsr_patchouli_fire_metal_earth")	

	caster:AddAbility("ability_thdotsr_patchouli_water_fire")
	caster:AddAbility("ability_thdotsr_patchouli_water_earth")
	caster:AddAbility("ability_thdotsr_patchouli_fire_earth")
	caster:AddAbility("ability_thdotsr_patchouli_ultimate1")
	caster:AddAbility("ability_thdotsr_patchouli_ultimate2")	
	
	caster:SetAbilityPoints(caster:GetAbilityPoints()+1)



end