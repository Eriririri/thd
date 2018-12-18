function ThundergodsWrath(keys)
	local caster = keys.caster
	
	local target = keys.target
	local ability = keys.ability
	local sight_radius = ability:GetLevelSpecialValueFor("sight_radius", (ability:GetLevel() -1))
	local sight_duration = ability:GetLevelSpecialValueFor("sight_duration", (ability:GetLevel() -1))
	
	
	-- If the target is not invisible, we deal damage to it
	
    ApplyDamage({victim = target, attacker = caster, damage = ability:GetAbilityDamage()+(caster:GetStrength()*1), damage_type = ability:GetAbilityDamageType()})
	
	
	-- Gives the caster's team vision around the target
	AddFOWViewer(caster:GetTeam(), target:GetAbsOrigin(), sight_radius, sight_duration, false)
	-- Renders the particle on the target
	local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, target)
	-- Raise 1000 if you increase the camera height above 1000
	ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	ParticleManager:SetParticleControl(particle, 1, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,1000 ))
	ParticleManager:SetParticleControl(particle, 2, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	-- Plays the sound on the target
	EmitSoundOn(keys.sound, target)
end
function talent(keys)
local castertalent = EntIndexToHScript(keys.caster_entindex)
THDReduceCooldown(keys.ability,-FindTalentValue(castertalent,"special_bonus_unique_earthshaker_2"))
end