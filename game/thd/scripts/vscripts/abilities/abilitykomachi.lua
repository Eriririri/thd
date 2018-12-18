-- Change all this to what you want to name this skill



function OnKomachi05AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local ability = caster:FindAbilityByName("ability_thdots_komachi05")
	local target = keys.target
	
	local KomachiCooldown = ability:GetCooldownTimeRemaining()
	local abilitycooldown = ability:GetCooldown(ability:GetLevel() - 1)
	--ability:GetCooldown(ability:GetLevel())
	
	
	if 	KomachiCooldown == 0 and target:IsBuilding() ~= true then
	keys.ability:ApplyDataDrivenModifier(caster, target, keys.modifier_name, {})
	
	ability:StartCooldown(12)	
	
	ApplyDamage({victim = target, attacker = caster, damage = ability:GetAbilityDamage()+(caster:GetLevel()*12), damage_type = DAMAGE_TYPE_PHYSICAL})
	

	end
	

	
	
end



function OnKomachi05AttackLanded2(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local ability = caster:FindAbilityByName("ability_thdots_komachi05")
	local target = keys.target
	
	local KomachiCooldown =ability:GetCooldownTimeRemaining()
	
	
	if 	KomachiCooldown == 0 and target:IsBuilding() ~= true then
	
		keys.ability:ApplyDataDrivenModifier( caster, caster, "modifier_komachi_animationx", {} )	

	end	
end


function Komachi05animation(event)

	local caster = event.caster
	local ability = caster:FindAbilityByName("ability_thdots_komachi05")	
	local KomachiCooldown = ability:GetCooldownTimeRemaining()	
	
	if 	KomachiCooldown == 0 then

--event.caster:StartGesture(liandao)
	end
end

function Komachi05animationend(event)

	local caster = event.caster

--event.caster:RemoveGesture(liandao)
end


function OnKomachi03SoulExplodeStart(keys)
	local caster = keys.caster
	
	caster:Kill(caster,caster)




end

function OnKomachi03AttackLanded(keys)
	local caster = keys.caster
	
	caster:Kill(caster,caster)




end

function OnKomachi03Explode(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	local targets = keys.target_entities
	local radius = keys.radius
		local particle_explosion_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(particle_explosion_fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_explosion_fx, 1, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_explosion_fx, 2, Vector(radius, 1, 1))
		ParticleManager:ReleaseParticleIndex(particle_explosion_fx)	
		EmitSoundOn("Hero_Techies.LandMine.Detonate", caster)
		for _,v in pairs(targets) do
			local deal_damage =	keys.dealdamage + (keys.dealdamagepct*v:GetMaxHealth()/100)
			if v:IsBuilding() == false then
					local damage_table = {
						ability = ability,
						victim = v,
						attacker = caster,
						damage = deal_damage,
						damage_type = keys.ability:GetAbilityDamageType(), 
						damage_flags = 0
					}
					UnitDamageTarget(damage_table)	
			end				
		end


end



		
function OnKomachi03reducehp(keys)

	local caster = keys.caster
	
	local casterlocation = caster:GetAbsOrigin()
	
	local ability = keys.ability
	
	local hero = caster:GetOwner()
	
	local herolocation = hero:GetAbsOrigin()
	
	local distance	= (casterlocation - herolocation):Length()
	
	local smalldamage = keys.smalldamage
	
	local mediumdamage = keys.mediumdamage
	
	if distance < keys.smallradius then
	
	
		
		local damage_table = {
				ability = keys.ability,
			    victim = caster,
			    attacker = caster,
			    damage = smalldamage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY
		}	
		UnitDamageTarget(damage_table)	
		
	
	
	
	elseif distance >= keys.mediumradius then
	
		local damage_table = {
				ability = keys.ability,
			    victim = caster,
			    attacker = caster,
			    damage = mediumdamage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY
		}	
		UnitDamageTarget(damage_table)	

	
	
	
	end
	
	--if caster:GetHealth() <= 1  then
	
	--caster:Kill(caster,caster)
	--caster():ForceKill(false)
	
	--end



end		
		

function OnKomachi03reducehpx(keys)

	local caster = keys.caster
	
	local casterlocation = caster:GetAbsOrigin()
	
	local ability = keys.ability
	
	local hero = caster:GetOwner()
	
	local herolocation = hero:GetAbsOrigin()
	
	local distance	= (casterlocation - herolocation):Length()
	
	if distance < keys.smallradius then
	
		caster:SetHealth(caster:GetHealth()-keys.smalldamage)	
		
		--if caster:GetHealth() <= 1 and caster:IsNull() == false and caster:IsAlive() then
	
		if caster:GetHealth() <= 1  then
	
		--caster:Kill(caster,caster)
		caster():ForceKill(false)
	
		end
		
	
	
	
	elseif distance >= keys.mediumradius then
	
		caster:SetHealth(caster:GetHealth()-keys.mediumdamage)	
		
		
		if caster:GetHealth() <= 1  then
	
		--caster:Kill(caster,caster)
		caster():ForceKill(false)
	
		end

	
	
	
	end
	
	if caster:GetHealth() <= 1  then
	
	--caster:Kill(caster,caster)
	caster():ForceKill(false)
	
	end



end

function OnKomachi03stop (keys)

	local caster = keys.caster
	caster:Stop()
	
	local ability = keys.ability
	local komachi = caster:GetOwner()
	local ability3level = komachi:GetAbilityByIndex(3):GetLevel()
	ability:SetLevel(ability3level)

end