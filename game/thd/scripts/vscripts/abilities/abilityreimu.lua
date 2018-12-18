-- Reimu01
-- init Ball parameters

REIMU01_GRAVITY = 11

REIMU02_FOLLOW_RADIUS = 650
REIMU02_DAMAGE_RADIUS = 150
REIMU02_LIGHTSPEED = 20

if AbilityReimu == nil then
	AbilityReimu = class({})
end

function OnReimu01SpellStart(keys)
local caster = EntIndexToHScript(keys.caster_entindex)
	AbilityReimu:OnReimu01Start(keys)
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_clockwerk_3"))
end

function OnReimu02SpellStart(keys)
	AbilityReimu:OnReimu02Start(keys)
end

function OnReimu02OnLightStart(keys)
	AbilityReimu:OnReimu02OnLight(keys)
end

function OnReimu03SpellStart(keys)
 
	local caster = EntIndexToHScript(keys.caster_entindex)
	if(caster:GetTeam() == keys.target:GetTeam())then
		keys.target:SetPhysicalArmorBaseValue(10000)	
		keys.target:SetContextThink(DoUniqueString('SetPhysicalArmor99999'),
    	function ()
    		if GameRules:IsGamePaused() then return 0.03 end
			keys.target:SetPhysicalArmorBaseValue(keys.target:GetPhysicalArmorBaseValue() - keys.target:GetPhysicalArmorBaseValue())
			keys.target:RemoveModifierByName("modifier_ability_dota2x_reimu03_effect")
			return nil
    	end,keys.Duration)
	else
        if is_spell_blocked(keys.target) then return end	
	    UtilSilence:UnitSilenceTarget(caster,keys.target,keys.Duration)
	    if FindTalentValue(caster,"special_bonus_unique_reimu_1")~=0 then
	    keys.ability:ApplyDataDrivenModifier( caster,keys.target, "modifier_reimu_talent", {} )
	    end			
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString('Release Effect'),
    	function ()
    		if GameRules:IsGamePaused() then return 0.03 end
			keys.target:RemoveModifierByName("modifier_ability_dota2x_reimu03_effect")
	    	return nil
    	end,keys.Duration)
	end
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_clockwerk_4"))	
end

function OnReimu03xSpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	
	if(caster:GetTeam() == keys.target:GetTeam())then
	    keys.ability:ApplyDataDrivenModifier( caster,keys.target, "modifier_reimu_03_immune", {} )	

	
	else
        if is_spell_blocked(keys.target) then return end	
	    UtilSilence:UnitSilenceTarget(caster,keys.target,keys.Duration)
	    if FindTalentValue(caster,"special_bonus_unique_reimu_1")~=0 then
	    keys.ability:ApplyDataDrivenModifier( caster,keys.target, "modifier_reimu_talent", {} )
	    end		
	end
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_clockwerk_4"))		
	



end



function OnReimu04SpellStart(keys)
local caster = EntIndexToHScript(keys.caster_entindex)
	AbilityReimu:OnReimu04Start(keys)
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_omniknight_1"))
end

function OnReimu04SpellThink(keys)
	AbilityReimu:OnReimu04Think(keys)
end

function AbilityReimu:OnReimu01Start(keys)
	-- »ù´¡Êý¾Ý»ñÈ¡
	local targetPoint = keys.target_points[1]
	local caster = EntIndexToHScript(keys.caster_entindex)
	local LightIndex = ParticleManager:CreateParticle("particles/thd2/heroes/reimu/reimu_01_effect_b.vpcf", PATTACH_CUSTOMORIGIN, nil)
	local FireIndex = ParticleManager:CreateParticle("particles/heroes/reimu/reimu_01_effect_fire.vpcf", PATTACH_CUSTOMORIGIN, nil)
	-- ´´½¨ÇòÌØÐ§
	local ballunit = CreateUnitByName(
		"npc_dota2x_unit_reimu01_ball"
		,caster:GetOrigin()
		,false
		,caster
		,caster
		,caster:GetTeam()
		)
	ballunit.tReimu01Elements = {
			Ball = {paIndex = nil , t = 0, g = REIMU01_GRAVITY, v = 0},
			Target = nil,
			Decrease = 0,
			OriginZ = 0,
	}
	ParticleManager:SetParticleControlEnt(FireIndex, 0, ballunit, 0, follow_origin, ballunit:GetOrigin(), false)
	--ParticleManager:SetParticleControlEnt(LightIndex, 0, ballunit, 0, attach_hitloc, ballunit:GetOrigin(), false)
	--ParticleManager:SetParticleControlEnt(LightIndex, 3, ballunit, 0, attach_hitloc, ballunit:GetOrigin(), false)
	ballunit.LightIndex = LightIndex
	ballunit.forward = 0
	--»ñÈ¡µØÃæZÖá×ø±ê
	ballunit.tReimu01Elements.OriginZ = GetGroundPosition(targetPoint,nil).z
	if ballunit then
		local diffVec = targetPoint - caster:GetOrigin()
		--ballunit:SetForwardVector(diffVec:Normalized())
		local vec3 = Vector(targetPoint.x,targetPoint.y,ballunit.tReimu01Elements.OriginZ+300)
		ballunit.tReimu01Elements.ballVector = vec3
		ballunit:SetOrigin(vec3)
	end

	ballunit:SetContextThink("OnReimu01Release",
		function ()
			if GameRules:IsGamePaused() then return 0.03 end
			if( ballunit == nil )then
				return
			end
			local headOrigin = ballunit.tReimu01Elements.ballVector
			
			ballunit.tReimu01Elements.Ball.t = ballunit.tReimu01Elements.Ball.t + 0.1
			local ut = ballunit.tReimu01Elements.Ball.t
			local ug = ballunit.tReimu01Elements.Ball.g
			ballunit.tReimu01Elements.Ball.v = ballunit.tReimu01Elements.Ball.v + ug
			local uv = ballunit.tReimu01Elements.Ball.v
			local uz = headOrigin.z - uv
			local vec = Vector(headOrigin.x,headOrigin.y,uz)
			local locability = keys.ability
			local abilitylevel = locability:GetLevel()
			ParticleManager:SetParticleControl(ballunit.LightIndex, 0, vec)
			ParticleManager:SetParticleControl(ballunit.LightIndex, 3, vec)
			--ballunit.forward = ballunit.forward + 10
			--forward = ballunit.forward/180 * math.pi
			--ballunit:SetForwardVector(Vector(math.cos(forward),0,math.tan(forward)))
			ballunit.tReimu01Elements.ballVector = vec
			if uz <= ballunit.tReimu01Elements.OriginZ+80 then	
				local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/reimu/reimu_01_effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 0, vec)
				ParticleManager:SetParticleControl(effectIndex, 2, vec)
				ParticleManager:DestroyParticleSystem(effectIndex,false)
				ballunit.tReimu01Elements.Ball.v = ballunit.tReimu01Elements.Ball.v / math.sqrt(1.5) * -1
				vec = Vector(headOrigin.x,headOrigin.y,ballunit.tReimu01Elements.OriginZ+80.1)
				ballunit.tReimu01Elements.ballVector = vec
				local DamageTargets = FindUnitsInRadius(
				   caster:GetTeam(),		--caster team
				   ballunit:GetOrigin(),		--find position
				   nil,					--find entity
				   keys.Radius,		--find radius
				   DOTA_UNIT_TARGET_TEAM_ENEMY,
				   keys.ability:GetAbilityTargetType(),
				   0, FIND_CLOSEST,
				   false
			    )
				local decrease = ballunit.tReimu01Elements.Decrease
				for _,v in pairs(DamageTargets) do
				   local intscale = keys.intscale
				   local DamageTable = {
				   			ability = keys.ability,
			                victim = v, 
			                attacker = caster, 
			                damage = keys.ability:GetAbilityDamage()+(caster:GetIntellect()*intscale) * (1-decrease), 
			                damage_type = keys.ability:GetAbilityDamageType(), 
			                damage_flags = 0
		           }
				   UnitDamageTarget(DamageTable)
				   UtilStun:UnitStunTarget(caster,v,keys.StunDuration)
				end
				ballunit.tReimu01Elements.Decrease = ballunit.tReimu01Elements.Decrease + keys.DamageDecrease
				ballunit:EmitSound("Visage_Familar.StoneForm.Cast")
			end
			
			if ut >= 2.2 then
				ParticleManager:DestroyParticleSystem(ballunit.LightIndex,true)	
				ballunit.tReimu01Elements.Ball.g = REIMU01_GRAVITY
				ballunit.tReimu01Elements.Ball.t = 0
				ballunit.tReimu01Elements.Ball.v = 0
				ballunit.tReimu01Elements.Decrease = 0
				ballunit.tReimu01Elements.Ball.OriginZ = 0
				ballunit:RemoveSelf()
				
				ballunit.tReimu01Elements.Ball.unit = nil
				return nil
			end
			return 0.1
		end, 
	0.1)
end

--Reimu02
function AbilityReimu:initLightData(level)
	self.tReimu02Light = self.tReimu02Light or {}
	zincrease = REIMU02_LIGHTSPEED
	for i = 0,level+1 do
		self.tReimu02Light[i] = {
			Ball = {unit = nil , t = 0 },
			Target = nil,
		}
	end
end

function AbilityReimu:OnReimu02Start(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vec0 = caster:GetOrigin()
	local ability = keys.ability
	local abilitylevel = ability:GetLevel()
	
	
	AbilityReimu:initLightData(abilitylevel)

	for i = 0,(abilitylevel+1) do
		local veccre = Vector(vec0.x + math.cos(0.628 * i) * 60 ,vec0.y + math.sin(0.628 * i) * 60 ,500)
		self.tReimu02Light[i].Ball.unit = CreateUnitByName(
			"npc_dota2x_unit_reimu02_light"
			,vec0
			,false
			,caster
			,caster
			,caster:GetTeam()
		)
		local removeUnit = self.tReimu02Light[i].Ball.unit
		removeUnit:SetContextThink("ability_reimu02_unit_remove",
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				removeUnit:RemoveSelf()
				return nil
			end,5
		)
		
		if self.tReimu02Light[i].Ball.unit then
			self.tReimu02Light[i].Ball.unit:SetOrigin(veccre)
			self.tReimu02Light[i].Ball.unit:SetForwardVector(
				Vector(
					math.cos(RandomFloat(math.pi, -math.pi)),
					math.sin(RandomFloat(math.pi, -math.pi)),
					0)
				)
		else
		    self.tReimu02Light[i].Ball.unit = nil 
		end
	end
end

function AbilityReimu:OnReimu02OnLight (keys)
	local i = 0
	local caster = EntIndexToHScript(keys.caster_entindex)
	local level = keys.ability:GetLevel()
	self.tReimu02Light[i].Ball.t = self.tReimu02Light[i].Ball.t + 0.03
	
	if (self.tReimu02Light[i].Ball.t >= 1.47) then
		for i = 0,level+1 do
			if(self.tReimu02Light[i].Ball.unit ~= nil)then
		        self.tReimu02Light[i].Ball.unit:RemoveSelf()
		        self.tReimu02Light[i].Ball.unit = nil
			end
		end
		return
	end
	--ÉÏÏÂÌø¶¯
	for i = 0,level+1 do
		if (self.tReimu02Light[i].Ball.unit ~= nil) then
		
		    local vec = self.tReimu02Light[i].Ball.unit:GetOrigin()
		    local DamageTargets = FindUnitsInRadius(
		       caster:GetTeam(),		--caster team
		       vec,		--find position
		       nil,					--find entity
	    	   REIMU02_DAMAGE_RADIUS,		--find radius
	    	   DOTA_UNIT_TARGET_TEAM_ENEMY,
	    	   keys.ability:GetAbilityTargetType(),
	    	   0, 0,
	    	   false
	        )
		    for k,v in pairs(DamageTargets) do
			   if (v ~= nil) then
				   local DamageTable = {
				   		ability = keys.ability,
	                    victim = v, 
	                    attacker = caster, 
	                    damage = keys.ability:GetAbilityDamage()+(caster:GetIntellect()*0.5), 
	                    damage_type = keys.ability:GetAbilityDamageType(), 
	                    damage_flags = 1
                   }
				   v:EmitSound("Hero_Wisp.Spirits.Target")
				   UnitDamageTarget(DamageTable)
				   self.tReimu02Light[i].Ball.unit:RemoveSelf()
				   self.tReimu02Light[i].Ball.unit = nil
		           break				   
				   
			   end
		    end
			
			if (self.tReimu02Light[i].Ball.unit~= nil) then
					
			    local FollowTargets = FindUnitsInRadius(
		          caster:GetTeam(),		--caster team
		          vec,		--find position
		          nil,					--find entity
		          REIMU02_FOLLOW_RADIUS,		--find radius
		          DOTA_UNIT_TARGET_TEAM_ENEMY,
				  keys.ability:GetAbilityTargetType(),
		          0, 0,
		          false
	            )
			
			    local FollowTarget = nil
			
		        for k,v in pairs(FollowTargets) do
				   if (v == nil) then
		             self.tReimu02Light[i].Ball.unit:RemoveSelf()
				     self.tReimu02Light[i].Ball.unit = nil
		             break
			       else
				     FollowTarget = v
				     break
				   end
				end
				
				if (FollowTarget ~= nil) then
					
		            local vecenemy = FollowTarget:GetOrigin()
		
		            local radian = GetRadBetweenTwoVec2D(vec,vecenemy)
		   
		            vec.x = math.cos(radian) * REIMU02_LIGHTSPEED + vec.x
		            vec.y = math.sin(radian) * REIMU02_LIGHTSPEED + vec.y
		
			   end 
		   end
		   if vec.z>=500 then
				local ranInt = -10
				self.zincrease = ranInt
			end
			
		    if vec.z<=400 then
		    	local ranInt = 10
			    self.zincrease = ranInt
		    end
			
		    vec = Vector(vec.x + self.zincrease,vec.y + self.zincrease,vec.z + self.zincrease)
			if (self.tReimu02Light[i].Ball.unit~=nil)then
		    	self.tReimu02Light[i].Ball.unit:SetOrigin(vec+self.tReimu02Light[i].Ball.unit:GetForwardVector()*9) 
		    end
		end
	end
end
-- Reimu02End



function AbilityReimu:OnReimu04Start(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local unit = CreateUnitByName(
		"npc_reimu_04_dummy_unit"
		,caster:GetOrigin()
		,false
		,caster
		,caster
		,caster:GetTeam()
	)
	local nEffectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/reimu/reimu_04_effect.vpcf",PATTACH_CUSTOMORIGIN,unit)
	local vecCorlor = Vector(255,255,0)
	ParticleManager:SetParticleControl( nEffectIndex, 0, caster:GetOrigin())
	ParticleManager:SetParticleControl( nEffectIndex, 1, caster:GetOrigin())
	ParticleManager:SetParticleControl( nEffectIndex, 2, vecCorlor)
	ParticleManager:SetParticleControl( nEffectIndex, 3, caster:GetForwardVector())
	ParticleManager:SetParticleControl( nEffectIndex, 4, caster:GetOrigin())
	ParticleManager:SetParticleControl( nEffectIndex, 5, caster:GetOrigin())
	
	unit:SetOwner(caster)
	--unit:AddAbility("ability_dota2x_reimu04_unit")
	local unitAbility = unit:FindAbilityByName("ability_dota2x_reimu04_unit")
	unitAbility:SetLevel(keys.ability:GetLevel())
	unit:CastAbilityImmediately(unitAbility,0)
		
	keys.ability:SetContextNum("Reimu04_Effect_Unit" , unit:GetEntityIndex(), 0)
	unit:SetContextThink(DoUniqueString('ability_reimu04_damage'),
    	function ()
    		if GameRules:IsGamePaused() then return 0.03 end
		    unit:RemoveSelf()
		   	return nil
	end,keys.Ability_Duration+0.1)
end

function AbilityReimu:OnReimu04Think(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local Targets = keys.target_entities

	for k,v in pairs(Targets) do
		if(v:GetTeam() == caster:GetTeam())then
			if(v:GetContext("Reimu04_Effect_MAGIC_IMMUNE")~=0) then
			    v:SetContextNum("Reimu04_Effect_MAGIC_IMMUNE" , 0, 0)
			    keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_dota2x_reimu04_magic_immune", {Duration = keys.Ability_Duration})
				v:SetContextThink(DoUniqueString('ability_reimu04_magic_immune'),
				function ()
					if GameRules:IsGamePaused() then return 0.03 end
				    if (v~=nil) then
		                v:SetContextNum("Reimu04_Effect_MAGIC_IMMUNE" , 1, 0)
					    return nil
				    end
		        end,keys.Ability_Duration)
			end
		else
			if(v:GetContext("Reimu04_Effect_Damage")==nil)then
			    v:SetContextNum("Reimu04_Effect_Damage" , 1, 0)
				v:SetContextNum("Reimu04_Effect_Damage_Count" , keys.Damage_Count, 0)
			end
			
			if(v:GetContext("Reimu04_Effect_Damage")==1)then
				v:SetContextNum("Reimu04_Effect_Damage" , 0, 0)
				v:SetContextThink(DoUniqueString('ability_reimu04_damage'),
    	        function ()
    	        	if GameRules:IsGamePaused() then return 0.03 end
				    v:SetContextNum("Reimu04_Effect_Damage" , 1, 0)
					v:SetContextNum("Reimu04_Effect_Damage_Count" , keys.Damage_Count, 0)
				end,keys.Ability_Duration)
				
				local DamageTable = {
					ability = keys.ability,
	                victim = v, 
	                attacker = caster, 
	                damage = keys.ability:GetAbilityDamage()/keys.Damage_Count, 
	                damage_type = keys.ability:GetAbilityDamageType(), 
	                damage_flags = 1
                }
			    UnitDamageTarget(DamageTable)
				UtilStun:UnitStunTarget(caster,v,keys.Stun_Duration)
				Timer.Loop 'ability_reimu04_damage' (0.4, keys.Damage_Count-1,
			    function(i)
		            local DamageTable = {
		            	ability = keys.ability,
	                    victim = v, 
	                    attacker = caster, 
	                    damage = keys.ability:GetAbilityDamage()/keys.Damage_Count, 
	                    damage_type = keys.ability:GetAbilityDamageType(), 
	                    damage_flags = 1
                    }
			        UnitDamageTarget(DamageTable)
				    UtilStun:UnitStunTarget(caster,v,keys.Stun_Duration)
					local count = v:GetContext("Reimu04_Effect_Damage_Count")
					count = count - 1
					if (count<=0) then
						v:SetContextNum("Reimu04_Effect_Damage_Count" , 0, 0)
						return nil
					else
					    if(v~=nil)then
							v:SetContextNum("Reimu04_Effect_Damage_Count" , count, 0)
						end
					end
			    end
		        )
			end
		end
	end
end


function reimuinnate(keys)
	local Caster = keys.caster
	local CasterPlayerID = Caster:GetPlayerOwnerID()
	--DebugPrint("now:"..PlayerResource:GetUnreliableGold(CasterPlayerID).."+"..keys.GiveGoldAmount)
	PlayerResource:SetGold(CasterPlayerID,PlayerResource:GetUnreliableGold(CasterPlayerID) + keys.GiveGoldAmount,false)
	--SendOverheadEventMessage(Caster:GetOwner(),OVERHEAD_ALERT_GOLD,Caster,keys.GiveGoldAmount,nil)
end

function reimuinnate2(keys)
	local caster = keys.caster
	local DamageAvoid = keys.DamageTaken
	
	caster:SetHealth(caster:GetHealth()+DamageAvoid)			
	local effectIndex2 = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_CUSTOMORIGIN, caster) 
	ParticleManager:SetParticleControlEnt(effectIndex2 , 0, caster, 0, "follow_origin", Vector(0,0,0), true)

		Timer.Wait 'ability_mokou_04_wing_destory' (1.5,
			function()
				ParticleManager:DestroyParticle(effectIndex2,true)
			end
		)
end



function reimuEX(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local Caster=keys.caster
	local level = keys.ability:GetLevel()
    local ability = Caster:FindAbilityByName("ability_thdots_reimu05")
		ability:SetLevel(level+1)
    local ability2 = Caster:FindAbilityByName("Fantasy_Seal")
		ability2:SetLevel(level)		
		
	
end

function reimuoccult(keys)
	local caster = keys.caster			
	local effectIndex2 = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_CUSTOMORIGIN, caster) 
	ParticleManager:SetParticleControlEnt(effectIndex2 , 0, caster, 0, "follow_origin", Vector(0,0,0), true)

		Timer.Wait 'ability_mokou_04_wing_destory' (1.5,
			function()
				ParticleManager:DestroyParticle(effectIndex2,true)
			end
		)
		
		
end



function reimuocculteffects( event )
	local caster	= event.caster
	local ability	= event.ability
	--local modifierStackName	= event.modifier_stack_name

	--local hpCost		= event.hp_cost_perc
	local numSpirits	= 4

	-- Create particle FX
	local particleName = "particles/units/heroes/reimu/reimu_blue.vpcf"
	pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( pfx, 1, Vector( numSpirits, 0, 0 ) )
	for i=1, numSpirits do
		ParticleManager:SetParticleControl( pfx, 8+i, Vector( 1, 0, 0 ) )
	end

	caster.fire_spirits_numSpirits	= numSpirits
	caster.fire_spirits_pfx			= pfx



end

function OnReimuoccultSpellStart(keys)
local caster = EntIndexToHScript(keys.caster_entindex)
	--AbilityReimu:OnReimu04Start(keys)
	THDReduceCooldown(keys.ability,-FindTalentValue(caster,"special_bonus_unique_omniknight_1"))
	
	caster:EmitSound("reimuoccult_1")	
	local ability2 = caster:FindAbilityByName("fantasy_lanch")	
		ability2:StartCooldown(5)
	
end

function reimuexplode(keys)


EmitGlobalSound("reimuexplode")
end