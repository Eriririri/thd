


koishi05boostcap = class({})

function koishi05boostcap:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
    }

    return funcs
end

function koishi05boostcap:GetModifierMoveSpeed_Max( params )
    return 1000
end

--function koishi05boostcap:IsHidden()
--    return true
--end

function koishi05boostcap:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end