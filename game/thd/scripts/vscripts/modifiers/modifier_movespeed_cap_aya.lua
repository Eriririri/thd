modifier_movespeed_cap_aya = class({})

function modifier_movespeed_cap_aya:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_movespeed_cap_aya:GetModifierMoveSpeed_Max( params )
    return 600
end

function modifier_movespeed_cap_aya:GetModifierMoveSpeed_Limit( params )
    return 600
end

function modifier_movespeed_cap_aya:IsHidden()
    return true
end