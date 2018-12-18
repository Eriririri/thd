

LinkLuaModifier( "modifier_item_history_book_passive", "items/item_lua/item_history_book.lua", LUA_MODIFIER_MOTION_NONE )


if item_history_book == nil then item_history_book = class({}) end



function item_history_book:GetIntrinsicModifierName()

	return "modifier_item_history_book_passive" 
	
end


modifier_item_history_book_passive = class({})





function modifier_item_history_book_passive:IsPurgable() 
	return false 
end


function modifier_item_history_book_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }

    return funcs
end

function modifier_item_history_book_passive:GetModifierBonusStats_Strength( params )
    local statbonus = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
    return statbonus
end

function modifier_item_history_book_passive:GetModifierBonusStats_Agility( params )
    local statbonus = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
    return statbonus
end

function modifier_item_history_book_passive:GetModifierBonusStats_Intellect( params )
    local statbonus = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
    return statbonus
end

function modifier_item_history_book_passive:GetModifierPercentageRespawnTime( params )
    local respawnreduction = (self:GetAbility():GetSpecialValueFor("reduce_respawn"))/100
    return respawnreduction
end

function modifier_item_history_book_passive:IsHidden()
    return false
end