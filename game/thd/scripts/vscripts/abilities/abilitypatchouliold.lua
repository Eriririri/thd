function OnPatchouli01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/patchouli/ability_patchouli_01.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:SetParticleControl(effectIndex, 3, targetPoint)

	local time = 0

	caster:SetContextThink(DoUniqueString("OnPatchouli01SpellStart"), 
		function ()
			if GameRules:IsGamePaused() then return 0.03 end
			time = time + 0.03

			local targets = FindUnitsInRadius(
			   caster:GetTeam(),
			   targetPoint,	
			   nil,	
			   keys.radius,
			   DOTA_UNIT_TARGET_TEAM_ENEMY,
			   keys.ability:GetAbilityTargetType(),
			   keys.ability:GetAbilityTargetFlags(), 
			   FIND_CLOSEST,
			   false
		    )

		    for k,v in pairs(targets) do
		    	local damage_table = {
						ability = keys.ability,
					    victim = v,
					    attacker = caster,
					    damage = deal_damage*0.03,
					    damage_type = keys.ability:GetAbilityDamageType(), 
			    	    damage_flags = keys.ability:GetAbilityTargetFlags()
				}
				UnitDamageTarget(damage_table)
		    end

			if time>keys.duration then
				ParticleManager:DestroyParticleSystem(effectIndex,false)
				return nil
			end
			return 0.03
		end,
	0.03)
end