modifier_movespeed_cap_goliath = class({})

function modifier_movespeed_cap_goliath:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_movespeed_cap_goliath:GetModifierMoveSpeed_Max( params )
    return 2200
end

function modifier_movespeed_cap_goliath:GetModifierMoveSpeed_Limit( params )
    return 2200
end

function modifier_movespeed_cap_goliath:IsHidden()
    return true
end