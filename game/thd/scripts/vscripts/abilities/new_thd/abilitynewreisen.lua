




function OnReisen01SpellSuccess(keys)
    local caster = EntIndexToHScript(keys.caster_entindex)
    local target = keys.target
	
	
--		keys.ability:ApplyDataDrivenModifier( caster, target, "modifier_reisen01old_slow", {} )	
		if FindTalentValue(caster,"special_bonus_unique_reisen_2")~=0 then
			keys.ability:ApplyDataDrivenModifier( caster, target, "modifier_reisen01old_talent", {} )
		end 	
    
        local damage_table = {
            ability = keys.ability,
            victim = keys.target,
            attacker = caster,
            damage = keys.ability:GetAbilityDamage() + FindTalentValue(caster,"special_bonus_unique_reisen_1"),
            damage_type = keys.ability:GetAbilityDamageType(),
            damage_flags = keys.ability:GetAbilityTargetFlags()
        }
        UnitDamageTarget(damage_table)
end





function OnNewthdReisen02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if(caster.ability_reisen02_illusion_max == nil)then
		caster.ability_reisen02_illusion_max = 0
	end
	local illusionsummon = keys.illusionsummon
	if(caster.ability_reisen02_illusion_max < keys.Max_illusions + FindTalentValue(caster,"special_bonus_unique_reisen_3"))then
		caster.ability_reisen02_illusion_max = caster.ability_reisen02_illusion_max + illusionsummon
		for i=1,illusionsummon do
			illusion=create_illusion_reisen_newthd(keys,caster:GetOrigin(),keys.Illusion_damage_in_pct,keys.Illusion_damage_out_pct,keys.Illusion_duration)
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

function OnNewthdReisen02SpellSuccess(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local hero
	local chance = RandomFloat(0,100)

	if(caster:IsIllusion())then
		hero = caster.illusioncaster
		if(hero:FindModifierByName("ability_newthd_reisen04_modifier") ~= nil)then
			chance = 0
		end
		if(chance>keys.illusionChance)then
			return
		end
	else
		hero = caster
		if(hero:FindModifierByName("ability_newthd_reisen04_modifier") ~= nil)then
			chance = 0
		end
		if(chance>keys.Chance)then
			return
		end
	end
	if(hero.ability_reisen02_illusion_max == nil)then
		hero.ability_reisen02_illusion_max = 0
	end
	if(hero.ability_reisen02_illusion_max < (keys.Max_illusions + FindTalentValue(hero,"special_bonus_unique_reisen_3") ))then
		hero.ability_reisen02_illusion_max = hero.ability_reisen02_illusion_max + 1
		illusion=create_illusion_reisen_newthd(keys,caster:GetOrigin(),keys.Illusion_damage_in_pct,keys.Illusion_damage_out_pct,keys.Illusion_duration)
		if (illusion ~= nil) then
			local CasterAngles = hero:GetAnglesAsVector()
			illusion:SetAngles(CasterAngles.x,CasterAngles.y,CasterAngles.z)
			illusion:SetHealth(illusion:GetMaxHealth()*hero:GetHealthPercent()*0.01)
			illusion:SetMana(illusion:GetMaxMana()*hero:GetManaPercent()*0.01)
			local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantom_lancer_spawn_smoke.vpcf", PATTACH_CUSTOMORIGIN, hero)
			ParticleManager:SetParticleControl(effectIndex, 0, illusion:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex, 1, illusion:GetOrigin())
			if(hero:IsIllusion())then
				illusion.illusioncaster = hero.illusioncaster
			else
				illusion.illusioncaster = hero
			end
		end
	end
end

function OnNewthdReisen02OnDeath(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if(caster:IsIllusion())then
		local hero = caster.illusioncaster
		hero.ability_reisen02_illusion_max = hero.ability_reisen02_illusion_max - 1
	end
end

function create_illusion_reisen_newthd(keys, illusion_origin, illusion_incoming_damage, illusion_outgoing_damage, illusion_duration)	
	local player_id = keys.caster:GetPlayerID()
	local caster_team = keys.caster:GetTeam()
	
	local illusion = CreateUnitByName(keys.caster:GetUnitName(), illusion_origin, true, keys.caster, nil, caster_team)

	illusion:SetPlayerID(player_id)
	illusion:SetControllableByPlayer(player_id, true)

	--Level up the illusion to the caster's level.
	local caster_level = keys.caster:GetLevel()
	for i = 1, caster_level - 1 do
		illusion:HeroLevelUp(false)
	end

	--Set the illusion's available skill points to 0 and teach it the abilities the caster has.
	illusion:SetAbilityPoints(0)
	for ability_slot = 0, 16 do
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
	print("AddNewModifier")
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle 
	illusion:AddNewModifier(keys.caster, keys.ability, "modifier_illusion", {duration = illusion_duration, outgoing_damage = illusion_outgoing_damage, incoming_damage = illusion_incoming_damage})
	print("MakeIllusion")
	illusion:MakeIllusion()  --Without MakeIllusion(), the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.  Without it, IsIllusion() returns false and IsRealHero() returns true.
	illusion:SetMaximumGoldBounty(0)
	illusion:SetMinimumGoldBounty(0)
	return illusion
end


function OnReisen03SpellStart(keys)
	local caster = keys.caster
	local targets = keys.target_entities
	local ability = keys.ability
	local agimulti = keys.agimultiply


	local dealdamage = ability:GetAbilityDamage()+(caster:GetAgility()*agimulti)
	
	
	for _,v in pairs(targets) do	
	
		
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, v,dealdamage, nil)

	 local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_reisen/ability_reisen_03_explosion_h.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, v:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 2, v:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 5, v:GetOrigin())
		
		ability:ApplyDataDrivenModifier(caster, v, "modifier_ability_thdotsr_reisen03", {})		
		ability:ApplyDataDrivenModifier(caster, v, "modifier_ability_thdotsr_reisen03_blind", {})		


		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = dealdamage,
			    damage_type = ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}	
		UnitDamageTarget(damage_table)

	end
		
end


function OnReisenNewThd04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	keys.ability:ApplyDataDrivenModifier(caster, caster, "ability_newthd_reisen04_modifier", {Duration = keys.duration + FindTalentValue(caster,"special_bonus_unique_mirana_2")})
	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_reisen04_aurainvisible", {duration = keys.invis_duration})
--	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_reisen04_aura", {duration = keys.duration + FindTalentValue(caster,"special_bonus_unique_mirana_2")})	
	
	
end
	
	
	
function OnNewThdReisen04buffcheck(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local Caster=keys.caster
	local target = keys.target
    local ability = keys.ability
	if  target:GetClassname() == "npc_dota_hero_mirana" then
	
	ability:ApplyDataDrivenModifier(caster, target, "modifier_reisen04_aura_buff2", {duration = keys.duration + FindTalentValue(caster,"special_bonus_unique_mirana_2")})	

	end
		
	
end	


function OnNewThdReisen04buffcheckinvisible(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local Caster=keys.caster
	local target = keys.target
    local ability = keys.ability
	if  target:GetClassname() == "npc_dota_hero_mirana" then
	
	ability:ApplyDataDrivenModifier(caster, target, "modifier_reisen04_aura_buff2invisible", {duration = keys.duration + FindTalentValue(caster,"special_bonus_unique_mirana_2")})	

	end
		
	
end


function OnNewThdReisen04Spellend(keys)
	local targets = keys.target_entities
	local caster = keys.caster
	
	
	for _,v in pairs(targets) do	
	
		if  v:GetClassname() == "npc_dota_hero_mirana" and v:IsRealHero()==false then
	
			v:Kill(caster, caster)
		
		end		



	end	
	




end


function OnReisenIllusionDeath(keys)


	local caster = keys.caster
	
	local attackerx = keys.attacker
	
	local spendgold = (caster:GetLevel()*2) 
	
	--local playerid = attackerx:GetPlayerID()
	
	if caster:IsRealHero() == false and attackerx:IsRealHero() == true then
	
	local owner = attackerx:GetPlayerOwner()
	
	local playerid = owner:GetPlayerID()
	PlayerResource:SpendGold(playerid,spendgold,4)
	--PlayerResource:SpendGold(playerid,spendgold,DOTA_ModifyGold_PurchaseItem)
	
	
	end






end
