LinkLuaModifier("modifier_ability_thdots_bd", "abilities/abilitytower.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_thdots_bd_active", "abilities/abilitytower.lua", LUA_MODIFIER_MOTION_NONE)

ability_thdots_bd = class({})

function ability_thdots_bd:GetIntrinsicModifierName()
	return "modifier_ability_thdots_bd"
end

modifier_ability_thdots_bd = class({})

function modifier_ability_thdots_bd:IsHidden() return true end

function modifier_ability_thdots_bd:OnCreated()
	if IsClient() then return end

	self:StartIntervalThink(0.1)
--	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.radius = 1200
end

function modifier_ability_thdots_bd:OnIntervalThink()
	local units = FindUnitsInRadius(
		self:GetParent():GetTeam(),		
		self:GetParent():GetOrigin(),		
		nil,					
		self.radius,		
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_CREEP,
		0,
		FIND_CLOSEST,
		false
	)

	if #units == 0 then 
		if self.timer then return end
		self.timer = Timers:CreateTimer(3.0, function()
			if not self:GetParent():HasModifier("modifier_ability_thdots_bd_active") then
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ability_thdots_bd_active", {})
			end

			if not self:GetParent():HasModifier("modifier_backdoor_protection") then
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_backdoor_protection", {})
			end
		end)
	else
		for _, unit in pairs(units) do
			if unit:HasModifier("creepnobd") then
					return 
			end
			
			if unit:GetClassname() == "npc_dota_creep_lane" or unit:GetClassname() == "npc_dota_creep_siege" or unit:GetUnitName() == "npc_dota_mutation_pocket_roshan" then
			
			

			--if 
			--unit:GetUnitName() == "npc_dota_creep_goodguys_melee" or			
			--unit:GetUnitName() == "npc_dota_creep_goodguys_ranged" or
			--unit:GetUnitName() == "npc_dota_goodguys_siege" or
			--unit:GetUnitName() == "npc_dota_creep_badguys_melee" or
			--unit:GetUnitName() == "npc_dota_creep_badguys_ranged" or
			--unit:GetUnitName() == "npc_dota_badguys_siege" or
			
			--then
				if self:GetParent():HasModifier("modifier_ability_thdots_bd_active") then
					self:GetParent():RemoveModifierByName("modifier_ability_thdots_bd_active")
				end

				if self:GetParent():HasModifier("modifier_backdoor_protection") then
					self:GetParent():RemoveModifierByName("modifier_backdoor_protection")
				end

				self.timer = nil
			end
		end
	end
end

modifier_ability_thdots_bd_active = class({})

function modifier_ability_thdots_bd_active:GetTexture() return "backdoor_protection" end
function modifier_ability_thdots_bd_active:IsHidden() return false end

function modifier_ability_thdots_bd_active:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_ability_thdots_bd_active:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_ability_thdots_bd_active:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_ability_thdots_bd_active:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_ability_thdots_bd_active:GetModifierDamageOutgoing_Percentage ()
	return 100
end