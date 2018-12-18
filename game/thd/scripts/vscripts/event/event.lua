if THDOTSGameMode == nil then
	THDOTSGameMode = {}
end

function THDOTSGameMode:OnPlayerPickitemup(keys)

		local itemname = (keys.itemname )
		local playeridforpick = EntIndexToHScript(keys.PlayerID+1)
		local herocheck = playeridforpick:GetAssignedHero()		
		local heroName = herocheck:GetClassname()
		
	if (itemname == 'item_occult_ball') and (heroName == "npc_dota_hero_earthshaker")
	then
	

	local abilityocculttenshi= herocheck:FindAbilityByName("tenshi042")
	abilityocculttenshi:SetLevel(3)	
	end
		
	if (itemname == 'item_occult_ball') and (heroName == "npc_dota_hero_lina")
	then
	

	local abilityocculthakureireimu= herocheck:FindAbilityByName("Fantasy_Seal")
	abilityocculthakureireimu:SetLevel(3)	
	
	
	end	
	

end
