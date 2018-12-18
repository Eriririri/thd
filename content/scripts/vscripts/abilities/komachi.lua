LinkLuaModifier("modifier_ability_thdots_komachi01", "hero/komachi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_thdots_komachi_soul_explode", "hero/komachi", LUA_MODIFIER_MOTION_NONE)

ability_thdots_komachi01 = class({})

function ability_thdots_komachi01:OnSpellStart()
	if IsServer() then
		self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_ability_thdots_komachi01", {duration=self:GetSpecialValueFor("link_duration")})
	end
end

modifier_ability_thdots_komachi01 = class({})

function modifier_ability_thdots_komachi01:OnCreated()
	if IsClient() then return end	
	self.stun_duration = 2.0
	self.break_distance = self:GetAbility():GetSpecialValueFor("break_distance")
--	self.break_distance = 3600
	self.swap = true

	self:StartIntervalThink(FrameTime())

	EmitSoundOn("Hero_Ancient_Apparition.ColdFeetCast", self:GetParent())

	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
end

function modifier_ability_thdots_komachi01:OnIntervalThink()
	if IsServer() then
		if (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length() > self.break_distance then
			print("Distance Break!")
			self.swap = false
			self:GetParent():RemoveModifierByName("modifier_ability_thdots_komachi01")
			return
		end

		EmitSoundOn("Hero_Ancient_Apparition.ColdFeetTick", self:GetParent())
	end
end

function modifier_ability_thdots_komachi01:OnRemoved()
	if IsServer() then
		if self.particle then
			ParticleManager:DestroyParticle(self.particle, false)
			ParticleManager:ReleaseParticleIndex(self.particle)
		end

		if self.tick_timer then
			Timers:RemoveTimer(self.tick_timer)
		end

		if self.swap then
			self:GetCaster().pos = self:GetCaster():GetAbsOrigin()
			self:GetParent().pos = self:GetParent():GetAbsOrigin()
			self:GetCaster():SetAbsOrigin(self:GetParent().pos)
			self:GetParent():SetAbsOrigin(self:GetCaster().pos)
		end
	end
end

-----------------------------------------------------------------------

LinkLuaModifier("modifier_ability_thdots_komachi02", "hero/komachi", LUA_MODIFIER_MOTION_NONE)

ability_thdots_komachi02 = ability_thdots_komachi02 or class({})

function ability_thdots_komachi02:GetAbilityTextureName()
	return "custom/komachi/ability_thdots_komachi02"
end

function ability_thdots_komachi02:GetIntrinsicModifierName()
	return "modifier_ability_thdots_komachi02"
end

-------------------------------------------
-- Counter Helix modifier
-------------------------------------------

modifier_ability_thdots_komachi02 = modifier_ability_thdots_komachi02 or class({})

function modifier_ability_thdots_komachi02:OnCreated()
	self.particle_spin_1 = "particles/units/heroes/hero_axe/axe_attack_blur_counterhelix.vpcf"
	self.particle_spin_2 = "particles/units/heroes/hero_axe/axe_counterhelix.vpcf"
	self.modifier_enemy_taunt = "modifier_berserkers_call_debuff_cmd"

	-- ability specials
	self.radius = self:GetAbility():GetSpecialValueFor("spin_radius")
	self.lifesteal = self:GetAbility():GetSpecialValueFor("lifesteal")
	self.spin_lifesteal = self:GetAbility():GetSpecialValueFor("spin_lifesteal")
	self.damage = self:GetAbility():GetSpecialValueFor("spin_bonus_damage")
end

function modifier_ability_thdots_komachi02:OnRefresh()
	self:OnCreated()
end

function modifier_ability_thdots_komachi02:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return decFuncs
end

function modifier_ability_thdots_komachi02:OnAttackLanded(keys)
	local attacker = keys.attacker
	local target = keys.target
	local damage = keys.damage + (self:GetStrength()*1)
	

	-- Only apply if the target is the parent of the debuff
	if self:GetParent() == attacker then
		-- If the attacker was on the same team, do nothing
		if attacker:GetTeamNumber() == target:GetTeamNumber() then
			return nil
		end

		-- If the attacker is a building, a ward or a courier, do nothing
		if attacker:IsBuilding() then
			return nil
		end

		if self:GetCaster():PassivesDisabled() then
			return nil
		end

		-- Add lifesteal particle
		self.particle_lifesteal_fx = ParticleManager:CreateParticle(self.particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, attacker)
		ParticleManager:SetParticleControl(self.particle_lifesteal_fx, 0, attacker:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_lifesteal_fx, 1, attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.particle_lifesteal_fx)

		-- If it's an illusion, it doesn't heal (just fakes it)
		if attacker:IsIllusion() then
			return nil
		end

		-- Calculate heal amount based on damage percentage
--		local heal_amount = damage * self.lifefsteal * 0.01

		-- Heal the attacker
		attacker:Heal(self.lifesteal, attacker)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, attacker, self.lifesteal, nil)

		--calculate chance to counter helix
		self.proc_chance = self:GetAbility():GetSpecialValueFor("spin_chance")
		if RollPercentage(self.proc_chance) then
			self:Spin()
		end
	end
end

function modifier_ability_thdots_komachi02:Spin()
	self.helix_pfx_1 = ParticleManager:CreateParticle(self.particle_spin_1, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(self.helix_pfx_1, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.helix_pfx_1)

	self.helix_pfx_2 = ParticleManager:CreateParticle(self.particle_spin_2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(self.helix_pfx_2, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.helix_pfx_2)

	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_1)
	self:GetCaster():EmitSound("Hero_Axe.CounterHelix")

	-- Find nearby enemies
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	local total_damage = self.damage + self:GetCaster():GetAttackDamage()

	-- Apply damage to valid enemies
	for _,enemy in pairs(enemies) do
		ApplyDamage({attacker = self:GetCaster(), victim = enemy, ability = self:GetAbility(), damage = total_damage, damage_type = DAMAGE_TYPE_PURE})
		self:GetCaster():Heal(self.spin_lifesteal, self:GetCaster())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetCaster(), self.spin_lifesteal, nil) -- crash for reasons
	end
end

function modifier_ability_thdots_komachi02:IsPassive() return true end
function modifier_ability_thdots_komachi02:IsHidden() return true end
function modifier_ability_thdots_komachi02:IsBuff() return true end
function modifier_ability_thdots_komachi02:IsPurgable() return false end

ability_thdots_komachi03 = ability_thdots_komachi03 or class({})
-- CODE IS IN OnEntityKilled EVENT

ability_thdots_komachi_soul_explode = class({})

function ability_thdots_komachi_soul_explode:OnSpellStart()
	if IsServer() then
		-- Find nearby enemies
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		-- Apply damage to valid enemies
		for _,enemy in pairs(enemies) do
			local damage_pct = enemy:GetMaxHealth() / 100 * (self:GetSpecialValueFor("damage_pct") )
			ApplyDamage({attacker = self:GetCaster(), victim = enemy, ability = self, damage = self:GetSpecialValueFor("damage") + damage_pct, damage_type = DAMAGE_TYPE_PURE})
		end

		EmitSoundOn("Hero_Techies.LandMine.Detonate", self:GetCaster())
		local particle_explosion_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(particle_explosion_fx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_explosion_fx, 1, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_explosion_fx, 2, Vector(self:GetSpecialValueFor("radius"), 1, 1))
		ParticleManager:ReleaseParticleIndex(particle_explosion_fx)
		self:GetCaster():ForceKill(false)
	end
end

function ability_thdots_komachi_soul_explode:GetIntrinsicModifierName()
	return "modifier_ability_thdots_komachi_soul_explode"
end

modifier_ability_thdots_komachi_soul_explode = class({})

function modifier_ability_thdots_komachi_soul_explode:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_MIN_HEALTH,
	}

	return funcs
end

function modifier_ability_thdots_komachi_soul_explode:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true
	}

	return state
end

function modifier_ability_thdots_komachi_soul_explode:OnCreated()
	if IsClient() then return end	
	self:StartIntervalThink(1.0)
end

function modifier_ability_thdots_komachi_soul_explode:OnIntervalThink()
	if IsServer() then
		local distance = (self:GetCaster():GetAbsOrigin() - self:GetCaster():GetOwner():GetAbsOrigin()):Length()
		if distance <= self:GetAbility():GetSpecialValueFor("small_distance") then
			self:GetCaster():SetHealth(self:GetCaster():GetHealth() - self:GetAbility():GetSpecialValueFor("small_damage"))
		elseif distance >= self:GetAbility():GetSpecialValueFor("small_distance") and distance <= self:GetAbility():GetSpecialValueFor("long_distance") then
			self:GetCaster():SetHealth(self:GetCaster():GetHealth() - self:GetAbility():GetSpecialValueFor("medium_damage"))
		elseif distance >= self:GetAbility():GetSpecialValueFor("long_distance") then
			self:GetCaster():SetHealth(self:GetCaster():GetHealth() - self:GetAbility():GetSpecialValueFor("long_damage"))
		end

		if self:GetCaster():GetHealth() <= 1 then
			self:GetCaster():ForceKill(false)
		end
	end
end

function modifier_ability_thdots_komachi_soul_explode:GetMinHealth()
	return 1
end

function modifier_ability_thdots_komachi_soul_explode:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_ability_thdots_komachi_soul_explode:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_ability_thdots_komachi_soul_explode:GetAbsoluteNoDamagePure()
	return 1
end

ability_thdots_komachi04 = ability_thdots_komachi04 or class({})
LinkLuaModifier("modifier_reapers_scythe", "hero/komachi", LUA_MODIFIER_MOTION_NONE)

function ability_thdots_komachi04:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end

function ability_thdots_komachi04:OnSpellStart()
	if IsServer() then
		if self:GetCursorTarget():TriggerSpellAbsorb(self) then
			return nil
		end

		self:GetCaster():EmitSound("Hero_Necrolyte.ReapersScythe.Cast")
		self:GetCursorTarget():EmitSound("Hero_Necrolyte.ReapersScythe.Target")

		-- blink
		local distance = (self:GetCursorTarget():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()
		local direction = (self:GetCursorTarget():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
		local blink_point = self:GetCaster():GetAbsOrigin() + direction * (distance - 128)
		self:GetCaster():SetAbsOrigin(blink_point)
		Timers:CreateTimer(FrameTime(), function()
			FindClearSpaceForUnit(self:GetCaster(), blink_point, true)
		end)

		self:GetCaster():SetForwardVector(direction)

		-- Disjoint projectiles
		ProjectileManager:ProjectileDodge(self:GetCaster())

		-- Fire blink particle
		self.blink_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:ReleaseParticleIndex(self.blink_pfx)

		-- Fire blink end sound
		self:GetCursorTarget():EmitSound("Hero_PhantomAssassin.Strike.End")

--		if self:GetCursorTarget():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
--			self:GetCaster():MoveToTargetToAttack(self:GetCursorTarget())
--		end

		self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_reapers_scythe", {duration = self:GetSpecialValueFor("stun_duration") + FrameTime()})
	end
end

modifier_reapers_scythe = modifier_reapers_scythe or class({})

function modifier_reapers_scythe:IsPurgable() return false end
function modifier_reapers_scythe:IsPurgeException() return false end
function modifier_reapers_scythe:RemoveOnDeath() return false end

function modifier_reapers_scythe:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf"
end

function modifier_reapers_scythe:StatusEffectPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_reapers_scythe:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_reapers_scythe:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_reapers_scythe:CheckState()
	local state =
		{
			[MODIFIER_STATE_STUNNED] = true
		}
	return state
end

function modifier_reapers_scythe:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		}
	return decFuncs
end

function modifier_reapers_scythe:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_reapers_scythe:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		self.damage = self:GetAbility():GetSpecialValueFor("damage_pct")

		local stun_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_stunned.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
		self:AddParticle(stun_fx, false, false, -1, false, false)
		local orig_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_orig.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		self:AddParticle(orig_fx, false, false, -1, false, false)

		local scythe_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(scythe_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(scythe_fx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(scythe_fx)

		Timers:CreateTimer(self:GetAbility():GetSpecialValueFor("stun_duration"), function()
			self.damage = self.damage * (self:GetParent():GetMaxHealth()) / 100
			local actually_dmg = ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_PURE})
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, self:GetParent(), actually_dmg, nil)
		end)
	end
end

function modifier_reapers_scythe:OnRefresh()
		if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		self.damage = self:GetAbility():GetSpecialValueFor("damage_pct")

		local stun_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_stunned.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
		self:AddParticle(stun_fx, false, false, -1, false, false)
		local orig_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_orig.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		self:AddParticle(orig_fx, false, false, -1, false, false)

		local scythe_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(scythe_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(scythe_fx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(scythe_fx)
	end
end

