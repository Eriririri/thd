modifier_item_frost_cap_slow = class({})
debuff="particles/items2_fx/veil_of_discord_debuff.vpcf"
Type="follow_origin"

function modifier_item_frost_cap_slow:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_item_frost_cap_slow:GetModifierMoveSpeedBonus_Percentage( params )
    return -30
end

function modifier_item_frost_cap_slow:IsHidden()
    return false
end
function modifier_item_frost_cap_slow:IsDebuff()
    return true
end


