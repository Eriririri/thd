modifier_item_historybook_respawn = class({})





function modifier_item_historybook_respawn:IsPurgable() 
	return false 
end


function modifier_item_historybook_respawn:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE,
    }

    return funcs
end

function modifier_item_historybook_respawn:GetModifierPercentageRespawnTime( params )
    local respawnreduction = self:GetAbility():GetSpecialValueFor("reduce_respawn")
    return respawnreduction
end

function modifier_item_historybook_respawn:IsHidden()
    return false
end