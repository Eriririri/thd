--[[ ============================================================================================================
	Author: Rook, with help from some of Pizzalol's SpellLibrary code
	Date: January 25, 2015
	Called when Blink Dagger is cast.  Blinks the caster in the targeted direction.
	Additional parameters: keys.MaxBlinkRange and keys.BlinkRangeClamp
================================================================================================================= ]]
function item_blink_datadriven_on_spell_start(keys)
	ProjectileManager:ProjectileDodge(keys.caster)  --Disjoints disjointable incoming projectiles.
	
	--ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, keys.caster)
	--ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_ti7/antimage_blink_start_ti7.vpcf", PATTACH_ABSORIGIN, keys.caster)
	
	--ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, keys.caster)
	--ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_ti7/antimage_blink_start_ti7_ashes.vpcf", PATTACH_ABSORIGIN, keys.caster)
	--ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_ti7/antimage_blink_start_ti7_flame.vpcf", PATTACH_ABSORIGIN, keys.caster)
	----ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_ti7/antimage_blink_start_ti7_pyro_soft.vpcf", PATTACH_ABSORIGIN, keys.caster)
	--ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_ti7/antimage_blink_start_ti7_remnant_ember.vpcf", PATTACH_ABSORIGIN, keys.caster)
	--ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_ti7/antimage_blink_start_ti7_ribbon.vpcf", PATTACH_ABSORIGIN, keys.caster)
	--ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_ti7/antimage_blink_start_ti7_smoke.vpcf", PATTACH_ABSORIGIN, keys.caster)
--	ParticleManager:CreateParticle("particles/econ/events/ti6/blink_dagger_end_ti6.vpcf", PATTACH_ABSORIGIN, keys.caster)
	ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/blink_dagger_start_sparkles_fm06.vpcf", PATTACH_ABSORIGIN, keys.caster)
	keys.caster:EmitSound("DOTA_Item.BlinkDagger.Activate")
	
	local origin_point = keys.caster:GetAbsOrigin()
	local target_point = keys.target_points[1]
	local difference_vector = target_point - origin_point
	
	if difference_vector:Length2D() > keys.MaxBlinkRange then  --Clamp the target point to the BlinkRangeClamp range in the same direction.
		target_point = origin_point + (target_point - origin_point):Normalized() * keys.BlinkRangeClamp
	end
	
	keys.caster:SetAbsOrigin(target_point)
	FindClearSpaceForUnit(keys.caster, target_point, false)
	
--	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, keys.caster)
	
	ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/blink_dagger_end_fm06.vpcf", PATTACH_ABSORIGIN, keys.caster)	
	
end


--[[ ============================================================================================================
	Author: Rook
	Date: January 25, 2015
	Called when a unit with Blink Dagger in their inventory takes damage.  Puts the Blink Dagger on a brief cooldown
	if the damage is nonzero (after reductions) and originated from any player or Roshan.
	Additional parameters: keys.BlinkDamageCooldown and keys.Damage
	Known Bugs: keys.Damage contains the damage before reductions, whereas we want to compare the damage to 0 after reductions.
================================================================================================================= ]]
function modifier_item_blink_datadriven_damage_cooldown_on_take_damage(keys)
	local attacker_name = keys.attacker:GetName()

	if keys.Damage > 0 and (attacker_name == "npc_dota_roshan" or keys.attacker:IsControllableByAnyPlayer()) and keys.attacker:GetTeam() ~= keys.caster:GetTeam() then  --If the damage was dealt by neutrals or lane creeps, essentially.
		if keys.ability:GetCooldownTimeRemaining() < keys.BlinkDamageCooldown then
			keys.ability:StartCooldown(keys.BlinkDamageCooldown)
		end
	end
end