LinkLuaModifier("modifier_movespeed_cap_aya", "scripts/vscripts/modifiers/modifier_movespeed_cap_aya.lua", LUA_MODIFIER_MOTION_NONE)


if AbilityAya == nil then
	AbilityAya = class({})
end

function OnAya01SpellStart(keys)
	AbilityAya:OnAya01Start(keys)
	local caster = keys.caster
	--caster:EmitSound("Aya01_"..math.random(1,3))	
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_aya_3"))	
end

function OnAya01SpellMove(keys)
local caster = keys.caster
 if caster:IsFrozen()~=true then

	AbilityAya:OnAya01Move(keys)
	end
end

function OnAya02CastFilterResultTarget(hTarget)
	local caster = self:GetCaster()

	if caster:IsRooted() then 
		return UF_FAIL_CUSTOM
	end
end

function OnAya02SpellStart(keys)
	local caster = keys.caster
	local target = keys.target
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_aya_2"))	
	if is_spell_blocked(keys.target) then return end
	keys.ability:ApplyDataDrivenModifier(keys.caster,keys.target,keys.BuffName,{})
	keys.ability:ApplyDataDrivenModifier(keys.caster,keys.target,keys.EffectName,{})
	
	if target:IsHero() and target:GetHealth() < target:GetMaxHealth()*0.5 then
		caster:EmitSound("Aya02_1")	
	
	end
	
	
end

function OnAya02Attack(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if(keys.attacker~=caster)then
		return
	end
	local target = keys.target	
	local basedamage = keys.BounsDamage
	local maxdamage = keys.MaxDamage*target:GetMaxHealth()*0.01
	local dealdamage = math.max(maxdamage,basedamage)	
	local debuff = target:FindModifierByName("modifier_thdots_aya02_buff")
	debuff:SetDuration(keys.Durationx, true)
	local damage_table = {
				ability = keys.ability,
			    victim = target,
			    attacker = caster,
			    damage = dealdamage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
	}
	UnitDamageTarget(damage_table)
end

function OnAya03SpellStart(keys)
	AbilityAya:OnAya03Start(keys)
end

function OnAya04SpellOrderMoved(keys)
	AbilityAya:OnAya04OrderMoved(keys)
end

function OnAya04SpellOrderAttack(keys)
	AbilityAya:OnAya04OrderAttack(keys)
end

function OnAya04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local levelcd = (caster:GetLevel()*1.5)*(-1)
	THDReduceCooldown(keys.ability,levelcd)
	
	
	keys.ability:ApplyDataDrivenModifier( caster, caster, "modifier_thdots_aya04_blink", {duration = keys.Duration + FindTalentValue(caster,"special_bonus_unique_aya_5")} )
	if FindTalentValue(caster,"special_bonus_unique_aya_1")~=0 then
		keys.ability:ApplyDataDrivenModifier( caster, caster, "modifier_aya_talent_agi", {duration = keys.Duration + FindTalentValue(caster,"special_bonus_unique_aya_5")} )
	end
end



function AbilityAya:OnAya01Start(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	local Aya01rad = GetRadBetweenTwoVec2D(caster:GetOrigin(),targetPoint)
	local Aya01dis = GetDistanceBetweenTwoVec2D(caster:GetOrigin(),targetPoint)
	if(Aya01dis>keys.FixDis)then
		Aya01dis = keys.FixDis
	end
	keys.ability:SetContextNum("ability_Aya01_Rad",Aya01rad,0)
	keys.ability:SetContextNum("ability_Aya01_Dis",Aya01dis,0)
end

function AbilityAya:OnAya01Move(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targets = keys.target_entities
	
	if caster.Aya01voice == nil then 
		caster.Aya01voice = 0
	end	
		
	
	-- Ñ­»µ¸÷¸öÄ¿±êµ¥Î»
	for _,v in pairs(targets) do
		if(v:GetContext("ability_Aya01_damage")==nil)then
			v:SetContextNum("ability_Aya01_damage",TRUE,0)
		end
		if(v:GetContext("ability_Aya01_damage")==TRUE)then
			local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = keys.ability:GetAbilityDamage()+FindTalentValue(caster,"special_bonus_unique_slark_2")+(caster:GetAgility()*1),
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		    }
			
			if v:IsHero() then
				if caster.Aya01voice == 0 then
		 		   caster:EmitSound("Aya01_"..math.random(1,3))
		 		   caster.Aya01voice = 1
			    end
			end

			
		    UnitDamageTarget(damage_table)
			v:SetContextNum("ability_Aya01_damage",FALSE,0)
			Timer.Wait 'ability_Aya01_damage_timer' (1.4,
			function()
				v:SetContextNum("ability_Aya01_damage",TRUE,0)
			end
		
	    	)
			
			
			
		end
	end
	local Aya01rad = keys.ability:GetContext("ability_Aya01_Rad")
	local vec = Vector(vecCaster.x+math.cos(Aya01rad)*keys.MoveSpeed/50,vecCaster.y+math.sin(Aya01rad)*keys.MoveSpeed/50,vecCaster.z)
	caster:SetOrigin(vec)
	
	local aya01dis = keys.ability:GetContext("ability_Aya01_Dis")
	if(aya01dis<0)then
		SetTargetToTraversable(caster)
		keys.ability:SetContextNum("ability_Aya01_Dis",0,0)
		caster:RemoveModifierByName("modifier_thdots_aya01_think_interval")
	else
	    aya01dis = aya01dis - keys.MoveSpeed/50
	    keys.ability:SetContextNum("ability_Aya01_Dis",aya01dis,0)
	end
	
	--caster.Aya01voice = 0
end

function AbilityAya:OnAya03Start(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targets = keys.target_entities
	for _,v in pairs(targets) do
		local deal_damage = keys.ability:GetAbilityDamage() + (caster:GetIntellect()*1.4) + keys.AbilityMulti * caster:GetPrimaryStatValue()
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = deal_damage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)
	end
	local effectIndex = ParticleManager:CreateParticle(
	"particles/econ/items/windrunner/windrunner_cape_cascade/windrunner_windrun_cascade.vpcf", 
	PATTACH_CUSTOMORIGIN, 
	caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin() + caster:GetForwardVector()*100)
	ParticleManager:SetParticleControl(effectIndex, 1, caster:GetOrigin() + caster:GetForwardVector()*100)
	ParticleManager:SetParticleControl(effectIndex, 3, caster:GetOrigin() + caster:GetForwardVector()*100)
	ParticleManager:DestroyParticleSystemTime(effectIndex,2)
end

function AbilityAya:OnAya04OrderMoved(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	
	if caster:IsRooted() == true or caster:IsStunned() == true or caster:IsSilenced() == true or caster:IsHexed() == true  then
	
	return nil
	
	end
	
	if(keys.ability:GetContext("ability_Aya04_blink_lock")==FALSE)then
		return
	end
	

	keys.ability:ApplyDataDrivenModifier( caster, caster, "modifier_thdots_aya04_animation", {Duration=0.3} )
	

	local vecMove = caster:GetOrigin() + keys.BlinkRange * caster:GetForwardVector()
	caster:SetOrigin(vecMove)

	local effectIndex = ParticleManager:CreateParticle(
		"particles/heroes/aya/ability_aya_04.vpcf", 
		PATTACH_CUSTOMORIGIN, 
		caster)
	ParticleManager:SetParticleControl(effectIndex, 0, vecMove)
	ParticleManager:SetParticleControl(effectIndex, 3, vecMove)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	if(keys.ability:GetContext("ability_Aya04_blink_lock")==TRUE or keys.ability:GetContext("ability_Aya04_blink_lock")==nil)then
		keys.ability:SetContextNum("ability_Aya04_blink_lock",FALSE,0)
		Timer.Wait 'ability_Aya04_blink_lock' (0.1,
			function()
				keys.ability:SetContextNum("ability_Aya04_blink_lock",TRUE,0)
			end
	    	)
	end
end

function AbilityAya:OnAya04OrderAttack(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	
	if caster:IsRooted() == true or caster:IsStunned() == true then
	
	return nil
	
	end	
	
	if(keys.ability:GetContext("ability_Aya04_blink_lock")==FALSE)then
		return
	end
	local vectarget = keys.target:GetOrigin()
	caster:SetOrigin(vectarget)

	local effectIndex = ParticleManager:CreateParticle(
		"particles/heroes/aya/ability_aya_04.vpcf", 
		PATTACH_CUSTOMORIGIN, 
		caster)
	ParticleManager:SetParticleControl(effectIndex, 0, vectarget)
	ParticleManager:SetParticleControl(effectIndex, 3, vectarget)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	if(keys.ability:GetContext("ability_Aya04_blink_lock")==TRUE or keys.ability:GetContext("ability_Aya04_blink_lock")==nil)then
		keys.ability:SetContextNum("ability_Aya04_blink_lock",FALSE,0)
		Timer.Wait 'ability_Aya04_blink_lock' (0.1,
			function()
				keys.ability:SetContextNum("ability_Aya04_blink_lock",TRUE,0)
			end
	    	)
	end
end

function OnAyaEXSpellThinkStart(keys)
    local caster = EntIndexToHScript(keys.caster_entindex)
    caster:SetContextThink("ability_ayaex_think", 
    function()
        if GameRules:IsGamePaused() then return 0.03 end
        OnAyaEXSpellThink(keys)
        return 0.05
    end, 
    0.05)
end


function OnAyaEXSpellThink(keys)
    local caster = EntIndexToHScript(keys.caster_entindex)
    caster:SetModifierStackCount("passive_ayaex_bonus_movespeed", caster, caster:GetLevel())
end

function MaxSpeed(keys)
local caster = keys.caster
local ability = keys.ability
caster:AddNewModifier(caster, ability, "modifier_movespeed_cap_aya",  { Duration = keys.duration} )
end
function Aya01animation(event)

	local caster = event.caster

	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
end

function Aya01animationend(event)

	local caster = event.caster

	caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
	
	caster.Aya01voice = 0
	
end

function Aya04animationend(event)

	local caster = event.caster

	caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_4)
end


function Aya04animation(event)

	local caster = event.caster

	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
end

function Aya04animationend2(event)

	local caster = event.caster

	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_4)
end

function Aya_attack_count(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local Ability = keys.ability	
	local ayastack = caster:FindModifierByName("modifier_aya03_charge_count")
    local ayaattackcount = ayastack:GetStackCount()
	local vecCaster = caster:GetOrigin()
	
	
	
	
	if ayaattackcount <(keys.Maxattacks)
	
	
	then	
	
    caster:SetModifierStackCount("modifier_aya03_charge_count", caster, ayaattackcount + 1)
	
	end

	if ayaattackcount == (keys.Maxattacks)

	then
	
	
	keys.ability:ApplyDataDrivenModifier( caster, caster, "modifier_thdots_aya03_animation", {} )
	
	
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targets = keys.target_entities
	for _,v in pairs(targets) do
		local deal_damage = keys.ability:GetAbilityDamage() + (keys.AbilityMulti+FindTalentValue(caster,"special_bonus_unique_aya_4")) * caster:GetPrimaryStatValue()
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = deal_damage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		
	keys.ability:ApplyDataDrivenModifier( caster, v, "modifier_aya03_slow", {} )
	UnitDamageTarget(damage_table)	
	end
	caster:EmitSound("Brewmaster_Storm.DispelMagic")	
	local effectIndex = ParticleManager:CreateParticle(
	"particles/econ/items/windrunner/windrunner_cape_cascade/windrunner_windrun_cascade.vpcf", 
	PATTACH_CUSTOMORIGIN, 
	caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin() + caster:GetForwardVector()*100)
	ParticleManager:SetParticleControl(effectIndex, 1, caster:GetOrigin() + caster:GetForwardVector()*100)
	ParticleManager:SetParticleControl(effectIndex, 3, caster:GetOrigin() + caster:GetForwardVector()*100)
	ParticleManager:DestroyParticleSystemTime(effectIndex,2)	
	
	
    caster:SetModifierStackCount("modifier_aya03_charge_count", caster, 1)	
	end

	
end


function Aya03_attack_set(keys)

	local caster = keys.caster
	local Ability = keys.ability	
	--local ayastack = caster:FindModifierByName("modifier_aya03_charge_count")
    caster:SetModifierStackCount("modifier_aya03_charge_count", caster, 1)
	
	


end
	
