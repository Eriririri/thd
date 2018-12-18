modifier_backdoor_protection_lua = class({})

function modifier_backdoor_protection_lua:IsHidden()
	return true
end

function modifier_backdoor_protection_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		
	}

	return funcs
end

function modifier_backdoor_protection_lua:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_backdoor_protection_lua:GetAbsoluteNoDamageMagical()
	return 1
end
