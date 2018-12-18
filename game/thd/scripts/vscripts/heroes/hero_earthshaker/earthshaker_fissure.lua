if earthshaker_fissure_lua == nil then
	earthshaker_fissure_lua = class({})
end

LinkLuaModifier( "earthshaker_fissure_lua_stun", "heroes/hero_earthshaker/earthshaker_fissure_stun.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "earthshaker_fissure_lua_thinker", "heroes/hero_earthshaker/earthshaker_fissure_think.lua", LUA_MODIFIER_MOTION_NONE )

function earthshaker_fissure_lua:GetBehavior() 
	local behav = DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	return behav
end



function earthshaker_fissure_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPoint = self:GetCursorPosition() 
	local nLenght = self:GetCastRange( self:GetCursorPosition(), nil)
	local vForward = self:GetCursorPosition() - hCaster:GetAbsOrigin()
	vForward = vForward:Normalized() 
	local nDuration	= self:GetSpecialValueFor( "fissure_duration" )
	local nStun	= self:GetSpecialValueFor( "stun_duration" )
	local nRadius	= self:GetSpecialValueFor( "fissure_radius" )
	
	local vStartPos = hCaster:GetAbsOrigin()
	local vEndPos = vStartPos + vForward * nLenght
	vStartPos = vStartPos + vForward * 64
	EmitSoundOnLocationWithCaster(vEndPos, "Hero_EarthShaker.Fissure.Cast", hCaster )
	local particleName = "particles/newthd/newearthfissure/tenshi_fissure1.vpcf"
	
	
	--AddFOWViewer(2, hCaster:GetAbsOrigin(), 100, 0.05, false)
	--AddFOWViewer(3, hCaster:GetAbsOrigin(), 100, 0.05, false)	
	
	local nFXIndex = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, hCaster )
	ParticleManager:SetParticleControl( nFXIndex, 0, vStartPos )
	ParticleManager:SetParticleControl( nFXIndex, 0, vStartPos )
	ParticleManager:SetParticleControl( nFXIndex, 1, vEndPos )
	ParticleManager:SetParticleControl( nFXIndex, 2, Vector( nDuration, 0, 0 ) )
	
	--			local selfAuraBorderFx3 = ParticleManager:CreateParticleForTeam(particleName, PATTACH_ABSORIGIN, hCaster, 2)
	--ParticleManager:SetParticleControl( selfAuraBorderFx3, 0, vStartPos )
	--ParticleManager:SetParticleControl( selfAuraBorderFx3, 0, vStartPos )
	--ParticleManager:SetParticleControl( selfAuraBorderFx3, 1, vEndPos )
	--ParticleManager:SetParticleControl( selfAuraBorderFx3, 2, Vector( nDuration, 0, 0 ) )	
	--			local selfAuraBorderFx4 = ParticleManager:CreateParticleForTeam(particleName, PATTACH_ABSORIGIN, hCaster, 3)
	--ParticleManager:SetParticleControl( selfAuraBorderFx4, 0, vStartPos )
	--ParticleManager:SetParticleControl( selfAuraBorderFx4, 0, vStartPos )
	--ParticleManager:SetParticleControl( selfAuraBorderFx4, 1, vEndPos )
	--ParticleManager:SetParticleControl( selfAuraBorderFx4, 2, Vector( nDuration, 0, 0 ) )	
	
	
	local numBoulder = math.floor( nLenght / (32*2) ) + 1
	local stepLength = nLenght / ( numBoulder - 1 )
	for i=1, numBoulder do
		local boulderPos = vStartPos + vForward * (i-1) * stepLength
		self:SpawnBoulder(boulderPos,nDuration)
	end
	local tVictims = FindUnitsInLine( hCaster:GetTeamNumber(), vStartPos, vEndPos , nil, nRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, FIND_ANY_ORDER  )
	local nDamageType = self:GetAbilityDamageType()
	local nDamage = (self:GetAbilityDamage() + hCaster:GetStrength()*1.5) + ((self:GetAbilityDamage() + hCaster:GetStrength()*1.5)*FindTalentValue(hCaster,"special_bonus_unique_tenshi_1"))
--	local damage = {
--		attacker = hCaster,
--		damage = nDamage,
--		damage_type = nDamageType,
--		ability = self
--	}
	for k,v in pairs(tVictims) do
		FindClearSpaceForUnit(v, v:GetAbsOrigin(), true)
		if v:GetTeam() ~= hCaster:GetTeam() then
			v:AddNewModifier( hCaster, self, "earthshaker_fissure_lua_stun", { duration = nStun } )
			--damage.victim = v
			

			
			
		--	ApplyDamage( damage )
			local effectIndex = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_low_egset.vpcf", PATTACH_CUSTOMORIGIN, hCaster)			
			ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex, 1, v:GetOrigin())
			ParticleManager:DestroyParticleSystem(effectIndex,false)
			
			if v:IsHero()==true  then
			hCaster:EmitSound"Voice_Thdots_Tenshi.AbilityTenshi01EX_1"		
			
			end
			
				
			local damage_table = {
				ability = self,
			    victim = v,
			    attacker = hCaster,
			    damage = nDamage,
			    damage_type = nDamageType, 
	    	    damage_flags = 0
	    	    }			
	    	    UnitDamageTarget(damage_table)				
		end
	end
	
end

function earthshaker_fissure_lua:SpawnBoulder(vPos,nDuration)
	local hCaster = self:GetCaster()
	--DebugDrawCircle(vPos, Vector(255,255,255), 1, 32, true, nDuration) 
	CreateModifierThinker(hCaster, self, "earthshaker_fissure_lua_thinker", {duration = nDuration , radius = 46}, vPos, hCaster:GetTeam(), true) 
end



