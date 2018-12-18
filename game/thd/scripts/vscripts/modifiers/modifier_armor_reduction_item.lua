modifier_item_watermelon_debuff = class({})

function modifier_item_watermelon_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_item_watermelon_debuff:GetModifierPhysicalArmorBonus ( params )
    return -3
end


function modifier_item_watermelon_debuff:IsHidden()
    return false
end

function modifier_item_watermelon_debuff:GetTexture() 
   return "item_watermelon"
end


modifier_item_cirno_claymore_debuff = class({})

function modifier_item_cirno_claymore_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_item_cirno_claymore_debuff:GetModifierPhysicalArmorBonus ( params )
    return -7
end


function modifier_item_cirno_claymore_debuff:IsHidden()
    return false
end

function modifier_item_cirno_claymore_debuff:GetTexture() 
   return "item_cirno_claymore"
end

modifier_item_yuemianzhinu_debuff = class({})

function modifier_item_yuemianzhinu_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_item_yuemianzhinu_debuff:GetModifierPhysicalArmorBonus ( params )
    return -3
end


function modifier_item_yuemianzhinu_debuff:IsHidden()
    return false
end

function modifier_item_yuemianzhinu_debuff:GetTexture() 
   return "item_yuemianzhinu"
end