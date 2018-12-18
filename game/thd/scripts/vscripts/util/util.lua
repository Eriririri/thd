DEBUG = true
GameMode = nil

TRUE = 1
FALSE = 0


function GetDistanceBetweenTwoVec2D(a, b)
	local xx = (a.x-b.x)
	local yy = (a.y-b.y)
	return math.sqrt(xx*xx + yy*yy)
end

function GetRadBetweenTwoVec2D(a,b)
	local y = b.y - a.y
	local x = b.x - a.x
	return math.atan2(y,x)
end
--aVec:原点向量
--rectOrigin：单位原点向量
--rectWidth：矩形宽度
--rectLenth：矩形长度
--rectRad：矩形相对Y轴旋转角度
function IsRadInRect(aVec,rectOrigin,rectWidth,rectLenth,rectRad)
	local aRad = GetRadBetweenTwoVec2D(rectOrigin,aVec)
	local turnRad = aRad + (math.pi/2 - rectRad)
	local aRadius = GetDistanceBetweenTwoVec2D(rectOrigin,aVec)
	local turnX = aRadius*math.cos(turnRad)
	local turnY = aRadius*math.sin(turnRad)
	local maxX = rectWidth/2
	local minX = -rectWidth/2
	local maxY = rectLenth
	local minY = 0
	if(turnX<maxX and turnX>minX and turnY>minY and turnY<maxY)then
		return true
	else
		return false
	end
	return false
end

function IsRadBetweenTwoRad2D(a,rada,radb)
	local maxrad = math.max(rada,radb)
	local minrad = math.min(rada,radb)
	
	if rada >= 0 and radb >= 0 then
		if(a<=maxrad and a>=minrad)then
			print("true")
			return true
		end
	elseif rada >=0 and radb < 0 then

	elseif rada < 0 and radb >= 0 then
		if(a<maxrad and a>minrad)then
			print("true")
			return true
		end
	elseif rada < 0 and radb < 0 then
		if(a<maxrad and a>minrad)then
			print("true")
			return true
		end
	end

	return false
end


-- cx = 目标的x
-- cy = 目标的y
-- ux = math.cos(theta)   (rad是caster和target的夹角的弧度制表示)
-- uy = math.sin(theta)
-- r = 目标和原点之间的距离
-- theta = 夹角的弧度制
-- px = 原点的x
-- py = 原点的y
-- 返回 true or false(目标是否在扇形内，在的话=true，不在=false)

function IsPointInCircularSector(cx,cy,ux,uy,r,theta,px,py)
	local dx = px - cx
	local dy = py - cy

	local length = math.sqrt(dx * dx + dy * dy)

	if (length > r) then
		return false
	end

	local vec = Vector(dx,dy,0):Normalized()
	return math.acos(vec.x * ux + vec.y * uy) < theta
 end 

function SetTargetToTraversable(target)
	local vecTarget = target:GetOrigin() 
	local vecGround = GetGroundPosition(vecTarget, nil)

	UnitNoCollision(target,target,0.1)
end

function ParticleManager:DestroyParticleSystem(effectIndex,bool)
	if(bool)then
		ParticleManager:DestroyParticle(effectIndex,true)
		ParticleManager:ReleaseParticleIndex(effectIndex) 
	else
		Timer.Wait 'Effect_Destroy_Particle' (4,
			function()
				ParticleManager:DestroyParticle(effectIndex,true)
				ParticleManager:ReleaseParticleIndex(effectIndex) 
			end
		)
	end
end

function ParticleManager:DestroyParticleSystemTime(effectIndex,time)
	Timer.Wait 'Effect_Destroy_Particle_Time' (time,
		function()
			ParticleManager:DestroyParticle(effectIndex,true)
			ParticleManager:ReleaseParticleIndex(effectIndex) 
		end
	)
end

function is_spell_blocked(target)
	if target:HasModifier("modifier_item_sphere_target") then
		target:RemoveModifierByName("modifier_item_sphere_target")  --The particle effect is played automatically when this modifier is removed (but the sound isn't).
		target:EmitSound("DOTA_Item.LinkensSphere.Activate")
		return true
	end
	return false
end

function THDReduceCooldown(ability,value)
	if value == 0 then return end
	local cooldown=(ability:GetCooldown(ability:GetLevel())+value)*(ability:GetCooldownTimeRemaining()/ability:GetCooldown(ability:GetLevel()))
	ability:EndCooldown()
	ability:StartCooldown(cooldown)
end

function FindTalentValue(caster,name)
	local ability = caster:FindAbilityByName(name)
	if ability~=nil then
		return ability:GetSpecialValueFor("value")
	else
		return 0
	end
end

function PrintTable(t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
	if type(t) ~= "table" then return end

	done = done or {}
	done[t] = true
	indent = indent or 0

	local l = {}
	for k, v in pairs(t) do
	table.insert(l, k)
	end

	table.sort(l)
	for k, v in ipairs(l) do
		-- Ignore FDesc
		if v ~= 'FDesc' then
			local value = t[v]

			if type(value) == "table" and not done[value] then
				done [value] = true
				print(string.rep ("\t", indent)..tostring(v)..":")
				PrintTable (value, indent + 2, done)
			elseif type(value) == "userdata" and not done[value] then
				done [value] = true
				print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
				PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
			else
				if t.FDesc and t.FDesc[v] then
					print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
				else
					print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
				end
			end
		end
	end
end

-- Initializes heroes' innate abilities
function InitializeInnateAbilities(hero)
	-- Cycle through all of the heroes' abilities, and upgrade the innates ones
	for i = 0, 15 do        
		local current_ability = hero:GetAbilityByIndex(i)       
		if current_ability and current_ability.IsInnateAbility then
			if current_ability:IsInnateAbility() then
				current_ability:SetLevel(1)
			end
		end
	end
end

function CDOTA_Modifier_Lua:CheckMotionControllers()
	local parent = self:GetParent()
	local modifier_priority = self:GetMotionControllerPriority()
	local is_motion_controller = false
	local motion_controller_priority
	local found_modifier_handler

	local non_imba_motion_controllers = {
		"modifier_brewmaster_storm_cyclone",
		"modifier_dark_seer_vacuum",
		"modifier_eul_cyclone",
		"modifier_earth_spirit_rolling_boulder_caster",
		"modifier_huskar_life_break_charge",
		"modifier_invoker_tornado",
		"modifier_item_forcestaff_active",
		"modifier_rattletrap_hookshot",
		"modifier_phoenix_icarus_dive",
		"modifier_shredder_timber_chain",
		"modifier_slark_pounce",
		"modifier_spirit_breaker_charge_of_darkness",
		"modifier_tusk_walrus_punch_air_time",
		"modifier_earthshaker_enchant_totem_leap"
	}

	-- Fetch all modifiers
	local modifiers = parent:FindAllModifiers()	

	for _,modifier in pairs(modifiers) do		
		-- Ignore the modifier that is using this function
		if self ~= modifier then			

			-- Check if this modifier is assigned as a motion controller
			if modifier.IsMotionController then
				if modifier:IsMotionController() then
					-- Get its handle
					found_modifier_handler = modifier

					is_motion_controller = true

					-- Get the motion controller priority
					motion_controller_priority = modifier:GetMotionControllerPriority()

					-- Stop iteration					
					break
				end
			end

			-- If not, check on the list
			for _,non_imba_motion_controller in pairs(non_imba_motion_controllers) do				
				if modifier:GetName() == non_imba_motion_controller then
					-- Get its handle
					found_modifier_handler = modifier

					is_motion_controller = true

					-- We assume that vanilla controllers are the highest priority
					motion_controller_priority = DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST

					-- Stop iteration					
					break
				end
			end
		end
	end

	-- If this is a motion controller, check its priority level
	if is_motion_controller and motion_controller_priority then
		-- If the priority of the modifier that was found is higher, override
		if motion_controller_priority > modifier_priority then			
			return false
		-- If they have the same priority levels, check which of them is older and remove it
		elseif motion_controller_priority == modifier_priority then			
			if found_modifier_handler:GetCreationTime() >= self:GetCreationTime() then				
				return false
			else				
				found_modifier_handler:Destroy()
				return true
			end
		-- If the modifier that was found is a lower priority, destroy it instead
		else			
			parent:InterruptMotionControllers(true)
			found_modifier_handler:Destroy()
			return true
		end
	else
		-- If no motion controllers were found, apply
		return true
	end
end

function CDOTA_BaseNPC:SetUnitOnClearGround()
	Timers:CreateTimer(FrameTime(), function()
		self:SetAbsOrigin(Vector(self:GetAbsOrigin().x, self:GetAbsOrigin().y, GetGroundPosition(self:GetAbsOrigin(), self).z))		
		FindClearSpaceForUnit(self, self:GetAbsOrigin(), true)
		ResolveNPCPositions(self:GetAbsOrigin(), 64)
	end)
end
