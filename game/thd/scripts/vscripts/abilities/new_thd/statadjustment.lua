




function nonstrheromagicresistadjustment(keys)
	local caster = keys.caster
	local ability = keys.ability
	local strength = caster:GetStrength()
	
	local bonusmagicresist = (strength*0.08)
	local damagetaken = (100 - bonusmagicresist)
	local stackcount = (((100/damagetaken)*100)-100)
	
	
	caster:SetModifierStackCount("thdotsr_non_str_magicresist_adjust", ability, stackcount)



end

function strheromagicresistadjustment(keys)
	local caster = keys.caster
	local ability = keys.ability
	local strength = caster:GetStrength()
	
	local bonusmagicresist = (strength*0.1)
	local damagetaken = (100 - bonusmagicresist)
	local stackcount = (((100/damagetaken)*100)-100)
	
	
	caster:SetModifierStackCount("thdotsr_str_magicresist_adjust", ability, stackcount)



end

function nonagiherospeedadjustment(keys)
	local caster = keys.caster
	local ability = keys.ability
	local agility = caster:GetAgility()
	local stackcount = agility
	caster:SetModifierStackCount("thdotsr_non_agi_msspeed_adjust", ability, stackcount)



end


function agiherospeedadjustment(keys)
	local caster = keys.caster
	local ability = keys.ability
	local agility = caster:GetAgility()
	local stackcount = agility
	caster:SetModifierStackCount("thdotsr_agi_msspeed_adjust", ability, stackcount)



end


function nonintherospellampadjustment(keys)
	local caster = keys.caster
	local ability = keys.ability
	local intellect = caster:GetIntellect()
	local stackcount = intellect
	caster:SetModifierStackCount("thdotsr_non_int_spellamp_adjust", ability, stackcount)



end


function intherospellampadjustment(keys)
	local caster = keys.caster
	local ability = keys.ability
	local intellect = caster:GetIntellect()
	local stackcount = intellect
	caster:SetModifierStackCount("thdotsr_int_spellamp_adjust", ability, stackcount)



end


function strherohpadjustment(keys)
	local caster = keys.caster
	local ability = keys.ability
	local stackcount = caster:GetStrength()
	caster:SetModifierStackCount("thdotsr_str_hp_adjust", ability, stackcount)



end

function strherohpadjustment(keys)
	local caster = keys.caster
	local ability = keys.ability
	local stackcount = caster:GetStrength()
	caster:SetModifierStackCount("thdotsr_str_hp_adjust", ability, stackcount)



end

function agiheroarmoradjustment(keys)
	local caster = keys.caster
	local ability = keys.ability
	local stackcount = caster:GetAgility()
	caster:SetModifierStackCount("thdotsr_agi_armor_adjust", ability, stackcount)



end

function agiheroarmoradjustment(keys)
	local caster = keys.caster
	local ability = keys.ability
	local stackcount = caster:GetAgility()
	caster:SetModifierStackCount("thdotsr_agi_armor_adjust", ability, stackcount)



end

function intheromanaadjustment(keys)
	local caster = keys.caster
	local ability = keys.ability
	local stackcount = caster:GetIntellect()
	caster:SetModifierStackCount("thdotsr_int_mana_adjust", ability, stackcount)



end


function agiheroatkspeedadjustment(keys)
	local caster = keys.caster
	local ability = keys.ability
	local stackcount = caster:GetAgility()
	caster:SetModifierStackCount("thdotsr_agi_attackspeed_adjust", ability, stackcount)



end


function occultballchecking (keys)


	local caster = keys.caster
	local ability = keys.ability	

	
	if caster:HasItemInInventory("item_occult_ball") and caster:IsRealHero() then	
		
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_occultball_effects",{})	
		if caster:HasModifier("modifier_occultball_effects2") == false then

		ability:ApplyDataDrivenModifier(caster,caster,"modifier_occultball_effects2",{})
		end		
	end
	
	if caster:IsRealHero() then	
		if caster:HasItemInInventory("item_horse_red") then
		
		caster:SetContextNum("has_armor_penetration",TRUE, 0.5)
		else
		caster:SetContextNum("has_armor_penetration",FALSE, 0.5)		
		end
		
	end



end


function occultballeffects(keys)
	
	
	local caster = keys.caster
	local ability = keys.ability
	
	local particle3 = ParticleManager:CreateParticle("particles/newthd/item/occult_ball/occultball.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle3, 0, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z))


end

function occultballeffects2(keys)
	
	
	local caster = keys.caster
	local ability = keys.ability
	

	local effectIndex = ParticleManager:CreateParticle("particles/newthd/item/occult_ball/occult_ball3.vpcf", PATTACH_CUSTOMORIGIN, caster) 
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_attack1", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystemTime(effectIndex,2)

end