LinkLuaModifier("modifier_ability_throne", "abilities/abilitythrone.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_throne_active", "abilities/abilitythrone.lua", LUA_MODIFIER_MOTION_NONE)

ability_throne = class({})

function ability_throne:GetIntrinsicModifierName()
	return "modifier_ability_throne"
end

modifier_ability_throne = class({})

function modifier_ability_throne:IsHidden() return true end

function modifier_ability_throne:OnCreated()
	if IsClient() then return end

	self:StartIntervalThink(0.1)
--	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.radius = 3600
end

function modifier_ability_throne:OnIntervalThink()
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
		self.timer = Timers:CreateTimer(10.0, function()
			if not self:GetParent():HasModifier("modifier_ability_throne_active") then
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ability_throne_active", {})
			end

			if not self:GetParent():HasModifier("modifier_backdoor_protection") then
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_backdoor_protection", {})
			end
		end)
	else
		for _, unit in pairs(units) do
			if unit:GetClassname() == "npc_dota_creep_lane" or unit:GetClassname() == "npc_dota_creep_siege" then
				if self:GetParent():HasModifier("modifier_ability_throne_active") then
					self:GetParent():RemoveModifierByName("modifier_ability_throne_active")
				end

				if self:GetParent():HasModifier("modifier_backdoor_protection") then
					self:GetParent():RemoveModifierByName("modifier_backdoor_protection")
				end

				self.timer = nil
			end
		end
	end
end

modifier_ability_throne_active = class({})

function modifier_ability_throne_active:GetTexture() return "backdoor_protection" end
function modifier_ability_throne_active:IsHidden() return false end

function modifier_ability_throne_active:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}

	return funcs
end

function modifier_ability_throne_active:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_ability_throne_active:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_ability_throne_active:GetAbsoluteNoDamagePure()
	return 1
end
