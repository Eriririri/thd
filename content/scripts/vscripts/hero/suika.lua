-- Author: EarthSalamander #42

---------------------------------------
--               TOSS                --
---------------------------------------

suika_toss = suika_toss or class({})

function suika_toss:CastFilterResultTarget( hTarget )
	if IsServer() then
		print(PlayerResource:IsDisableHelpSetForPlayerID(hTarget:GetPlayerOwnerID(), self:GetCaster():GetPlayerOwnerID()))
		print(PlayerResource:IsDisableHelpSetForPlayerID(self:GetCaster():GetPlayerOwnerID(), hTarget:GetPlayerOwnerID()))
		if hTarget:IsOpposingTeam(self:GetCaster():GetTeamNumber()) and PlayerResource:IsDisableHelpSetForPlayerID(hTarget:GetPlayerOwnerID(), self:GetCaster():GetPlayerOwnerID()) then 	
			return UF_FAIL_DISABLE_HELP
		end
	end

	return UnitFilter(hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
end

function suika_toss:OnSpellStart()
	self.tossPosition = self:GetCursorPosition()
	local hTarget = self:GetCursorTarget()
	local caster = self:GetCaster()
	local tossVictim = caster
	local duration = self:GetSpecialValueFor("duration")

	if not hTarget then
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), self.tossPosition, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 1, false)
		for _,target in pairs(targets) do
			hTarget = target
			break
		end
	end

	if hTarget then
		self.tossPosition = hTarget:GetAbsOrigin()
		self.tossTarget = hTarget
	else
		self.tossTarget = nil
	end

	local vLocation = self.tossPosition
	local kv =
	{
		vLocX = vLocation.x,
		vLocY = vLocation.y,
		vLocZ = vLocation.z,
		duration = duration,
		damage = self:GetSpecialValueFor("toss_damage")
	}

	local tossVictims = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("grab_radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP, 1, false)
	for _, victim in pairs(tossVictims) do
		if victim ~= caster then
			victim:AddNewModifier(caster, self, "modifier_suika_toss_movement", kv)
			break
		end
	end

	-- If only suika himself was found, launch him instead
	if FindTalentValue(caster, "special_bonus_unique_tiny_5") and #tossVictims <= 1 then
		caster:AddNewModifier(caster, self, "modifier_suika_toss_movement", kv)
	end

	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	EmitSoundOn("Ability.TossThrow", self:GetCaster())
end

function suika_toss:GetCastRange(vLocation, hTarget)
	if IsServer() or hTarget then
		return self:GetSpecialValueFor("cast_range")
	elseif hTarget == nil then
		return self:GetSpecialValueFor("grab_radius")
	end
end

function suika_toss:GetAOERadius()
	local ability = self
	local radius = ability:GetSpecialValueFor("radius")

	return radius
end

LinkLuaModifier("modifier_suika_toss_movement", "hero/suika", LUA_MODIFIER_MOTION_NONE)

modifier_suika_toss_movement = modifier_suika_toss_movement or class({})

function modifier_suika_toss_movement:IsDebuff() return true end
function modifier_suika_toss_movement:IsStunDebuff() return true end
function modifier_suika_toss_movement:RemoveOnDeath() return false end
function modifier_suika_toss_movement:IsHidden() return true end
function modifier_suika_toss_movement:IgnoreTenacity() return true end
function modifier_suika_toss_movement:IsMotionController() return true end
function modifier_suika_toss_movement:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_suika_toss_movement:OnCreated( kv )
	self.toss_minimum_height_above_lowest = 500
	self.toss_minimum_height_above_highest = 100
	self.toss_acceleration_z = 4000
	self.toss_max_horizontal_acceleration = 3000

	if IsServer() then
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		EmitSoundOn("Hero_suika.Toss.Target", self:GetParent())

		self.vStartPosition = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
		self.flCurrentTimeHoriz = 0.0
		self.flCurrentTimeVert = 0.0

		self.vLoc = Vector( kv.vLocX, kv.vLocY, kv.vLocZ )
		self.damage = kv.damage
		self.vLastKnownTargetPos = self.vLoc

		local duration = self:GetAbility():GetSpecialValueFor( "duration" )
		local flDesiredHeight = self.toss_minimum_height_above_lowest * duration * duration
		local flLowZ = math.min( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flHighZ = math.max( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flArcTopZ = math.max( flLowZ + flDesiredHeight, flHighZ + self.toss_minimum_height_above_highest )

		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt( 2.0 * flArcDeltaZ * self.toss_acceleration_z )

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt( math.max( 0, ( self.flInitialVelocityZ * self.flInitialVelocityZ ) - 2.0 * self.toss_acceleration_z * flDeltaZ ) )
		self.flPredictedTotalTime = math.max( ( self.flInitialVelocityZ + flSqrtDet) / self.toss_acceleration_z, ( self.flInitialVelocityZ - flSqrtDet) / self.toss_acceleration_z )

		self.vHorizontalVelocity = ( self.vLastKnownTargetPos - self.vStartPosition ) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0

		self.frametime = FrameTime()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_suika_toss_movement:OnIntervalThink()
	if IsServer() then
		-- Check for motion controllers
		if not self:CheckMotionControllers() then
			self:Destroy()
			return nil
		end

		-- Horizontal motion
		self:HorizontalMotion(self.parent, self.frametime)

		-- Vertical motion
		self:VerticalMotion(self.parent, self.frametime)
	end
end

function modifier_suika_toss_movement:TossLand()
	if IsServer() then
		-- If the Toss was already completed, do nothing
		if self.toss_land_commenced then
			return nil
		end

		-- Mark Toss as completed
		self.toss_land_commenced = true

		local caster = self:GetCaster()
		local radius = self:GetAbility():GetSpecialValueFor("radius")

		-- Destroy trees at the target point
		GridNav:DestroyTreesAroundPoint(self.vLastKnownTargetPos, radius, true)

		local victims = FindUnitsInRadius(caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 0, 1, false)
		for _, victim in pairs(victims) do
			local damage = self.damage
			if victim == self.parent then
				local damage_multiplier = 1 + self.ability:GetSpecialValueFor("bonus_damage_pct") / 100
				damage = damage * damage_multiplier
			end
			if victim:IsBuilding() then
				damage = damage * self.ability:GetSpecialValueFor("building_dmg") * 0.01
				ApplyDamage({victim = victim, attacker = caster, damage = damage, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability})
			else
				ApplyDamage({victim = victim, attacker = caster, damage = damage, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability})
			end
			if caster:HasScepter() and not victim:IsBuilding() then
				victim:AddNewModifier(caster, self.ability, "modifier_stunned", {duration = self.ability:GetSpecialValueFor("scepter_stun_duration")})
			end
		end
		if self.parent == caster then
			ApplyDamage({victim = caster, attacker = caster, damage = caster:GetMaxHealth() * self.ability:GetSpecialValueFor("self_dmg_pct") * 0.01, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability})
		end

		EmitSoundOn("Ability.TossImpact", self.parent)
		if caster:HasScepter() and self.parent:IsAlive() and self.parent ~= caster then
			self.parent:AddNewModifier(caster, self.ability, "modifier_suika_toss_scepter_bounce", {})
		end

		self.parent:SetUnitOnClearGround()
		Timers:CreateTimer(FrameTime(), function()
			ResolveNPCPositions(self.parent:GetAbsOrigin(), 150)
		end)
	end
end

function modifier_suika_toss_movement:OnDestroy()
	if IsServer() then
		self.parent:SetUnitOnClearGround()
	end
end

function modifier_suika_toss_movement:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_suika_toss_movement:GetOverrideAnimation( params ) return ACT_DOTA_FLAIL end

function modifier_suika_toss_movement:GetEffectName()
	return "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf"
end

function modifier_suika_toss_movement:CheckState()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetParent() ~= nil then
			if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() and ( not self:GetParent():IsMagicImmune() ) then
				local state = {
					[MODIFIER_STATE_STUNNED] = true,
				}

				return state
			else
				local state = {
					[MODIFIER_STATE_ROOTED] = true,
				}

				return state
			end
		end
	end

	local state = {}

	return state
end

function modifier_suika_toss_movement:HorizontalMotion( me, dt )
	if IsServer() then
		-- If the unit being tossed died, interrupt motion controllers and remove self
		if not self.parent:IsAlive() then
			self.parent:InterruptMotionControllers(true)
			self:Destroy()
		end

		self.flCurrentTimeHoriz = math.min( self.flCurrentTimeHoriz + dt, self.flPredictedTotalTime )
		local t = self.flCurrentTimeHoriz / self.flPredictedTotalTime
		local vStartToTarget = self.vLastKnownTargetPos - self.vStartPosition
		local vDesiredPos = self.vStartPosition + t * vStartToTarget

		local vOldPos = me:GetOrigin()
		local vToDesired = vDesiredPos - vOldPos
		vToDesired.z = 0.0
		local vDesiredVel = vToDesired / dt
		local vVelDif = vDesiredVel - self.vHorizontalVelocity
		local flVelDif = vVelDif:Length2D()
		vVelDif = vVelDif:Normalized()
		local flVelDelta = math.min( flVelDif, self.toss_max_horizontal_acceleration )

		self.vHorizontalVelocity = self.vHorizontalVelocity + vVelDif * flVelDelta * dt
		local vNewPos = vOldPos + self.vHorizontalVelocity * dt
		me:SetOrigin( vNewPos )
	end
end

function modifier_suika_toss_movement:VerticalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = ( -self.toss_acceleration_z * self.flCurrentTimeVert + self.flInitialVelocityZ ) < 0

		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + ( -0.5 * self.toss_acceleration_z * ( self.flCurrentTimeVert * self.flCurrentTimeVert ) + self.flInitialVelocityZ * self.flCurrentTimeVert )

		local flGroundHeight = GetGroundHeight( vNewPos, self:GetParent() )
		local bLanded = false
		if ( vNewPos.z < flGroundHeight and bGoingDown == true ) then
			vNewPos.z = flGroundHeight
			bLanded = true
		end

		me:SetOrigin( vNewPos )
		if bLanded == true then
			self:TossLand()
		end
	end
end

LinkLuaModifier("modifier_suika_toss_scepter_bounce", "hero/suika", LUA_MODIFIER_MOTION_VERTICAL)

modifier_suika_toss_scepter_bounce = modifier_suika_toss_scepter_bounce or class({})

function modifier_suika_toss_scepter_bounce:IsDebuff() return true end
function modifier_suika_toss_scepter_bounce:IsStunDebuff() return true end
function modifier_suika_toss_scepter_bounce:RemoveOnDeath() return false end
function modifier_suika_toss_scepter_bounce:IsHidden() return true end
function modifier_suika_toss_scepter_bounce:RemoveOnDeath() return false end
function modifier_suika_toss_scepter_bounce:IsMotionController() return true end
function modifier_suika_toss_scepter_bounce:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_suika_toss_scepter_bounce:OnCreated( kv )
	if IsServer() then
		if self:ApplyVerticalMotionController() == false then
			self:Destroy()
		end

		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		self.scepter_bounce_damage_pct = self.ability:GetSpecialValueFor("scepter_bounce_damage_pct")
		self.toss_damage = self.ability:GetSpecialValueFor("toss_damage")

		EmitSoundOn("Hero_suika.Toss.Target", self:GetParent())
		self.bounce_duration = self:GetAbility():GetSpecialValueFor("scepter_bounce_duration")
		self.time = 0
		self.toss_z = 0
		self.frametime = FrameTime()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_suika_toss_scepter_bounce:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_suika_toss_scepter_bounce:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------
function modifier_suika_toss_scepter_bounce:GetEffectName()
	return "particles/units/heroes/hero_suika/suika_toss_blur.vpcf"
end

function modifier_suika_toss_scepter_bounce:CheckState()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetParent() ~= nil then
			if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() and ( not self:GetParent():IsMagicImmune() ) then
				local state = {
					[MODIFIER_STATE_STUNNED] = true,
				}

				return state
			else
				local state = {
					[MODIFIER_STATE_ROOTED] = true,
				}

				return state
			end
		end
	end

	local state = {}

	return state
end

function modifier_suika_toss_scepter_bounce:OnIntervalThink()
	if IsServer() then
		-- Check for motion controllers
		if not self:CheckMotionControllers() then
			self:Destroy()
			return nil
		end

		-- Vertical motion
		self:VerticalMotion(self.parent, self.frametime)
	end
end

function modifier_suika_toss_scepter_bounce:VerticalMotion( me, dt )
	if IsServer() then

		if self.time < self.bounce_duration then
			self.time = self.time + dt
			if self.bounce_duration/2 > self.time then
				-- Go up
				-- This is to memorize the z point when it comes to cliffs and such although the division of speed by 2 isnt necessary, its more of a cosmetic thing
				self.toss_z = self.toss_z + 25
				-- Set the new location to the current ground location + the memorized z point
				self.parent:SetAbsOrigin(GetGroundPosition(self.parent:GetAbsOrigin(), self.parent) + Vector(0,0,self.toss_z))
			elseif self.parent:GetAbsOrigin().z > 0 then
				-- Go down
				self.toss_z = self.toss_z - 25
				self.parent:SetAbsOrigin(GetGroundPosition(self.parent:GetAbsOrigin(), self.parent) + Vector(0,0,self.toss_z))
			end
		else
			self.parent:InterruptMotionControllers(true)
			self:Destroy()
		end
	end
end

function modifier_suika_toss_scepter_bounce:OnRemoved()
	if IsServer() then
		local damage = self.toss_damage * self.scepter_bounce_damage_pct * 0.01
		local radius = self:GetAbility():GetSpecialValueFor("radius")

		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = self.caster, damage = damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
		end
		self:GetParent():SetUnitOnClearGround()
	end
end
