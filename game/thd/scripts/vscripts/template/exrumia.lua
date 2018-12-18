

function abcdexrumia(keys)

	local exrumia = keys.caster
				xxxx:RemoveAbility("ability_thdots_rumia01")
				xxxx:RemoveAbility("ability_thdots_rumia02")	
				xxxx:RemoveAbility("ability_thdots_rumia03")
				xxxx:RemoveAbility("ability_thdots_rumia04")
				xxxx:SetModel("models/thd2/rumia_ex/rumia_ex.vmdl")
				xxxx:SetOriginalModel("models/thd2/rumia_ex/rumia_ex.vmdl")	
				xxxx:SetPrimaryAttribute(1)
				
				xxxx:SetBaseStrength(target:GetBaseStrength())
				xxxx:SetBaseAgility(target:GetBaseAgility())
				xxxx:SetBaseIntellect(target:GetIntellect())	
				xxxx:SetBaseDamageMax(30)
				xxxx:SetBaseDamageMin(30)
				xxxx:AddAbility("ability_thdots_EXrumia01")
				xxxx:AddAbility("ability_thdots_EXrumia02")
				xxxx:AddAbility("ability_thdots_EXrumia03")
				xxxx:AddAbility("ability_thdots_EXrumia04")
				xxxx:AddAbility("ability_thdots_EXrumia05"):SetLevel(1)


				hero:SetPrimaryAttribute(1)
				hero:SetBaseStrength(20)
				hero:SetBaseAgility(30)
				hero:SetBaseIntellect(10)				
	
end