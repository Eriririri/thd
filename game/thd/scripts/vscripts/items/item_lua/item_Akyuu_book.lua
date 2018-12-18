

LinkLuaModifier( "modifier_item_Akyuu_book_passive", "items/item_lua/item_Akyuu_book.lua", LUA_MODIFIER_MOTION_NONE )


if item_Akyuu_book == nil then item_Akyuu_book = class({}) end



function item_Akyuu_book:GetIntrinsicModifierName()

	return "modifier_item_Akyuu_book_passive" 
	
end


modifier_item_Akyuu_book_passive = class({})





function modifier_item_Akyuu_book_passive:IsPurgable() 
	return false 
end





function modifier_item_Akyuu_book_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_RESPAWN,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end


function modifier_item_Akyuu_book_passive:GetModifierMoveSpeedBonus_Percentage( params )
    local bonsspeed = self:GetAbility():GetSpecialValueFor("ms_speed")
    return bonsspeed
end

function modifier_item_Akyuu_book_passive:GetModifierMagicalResistanceBonus( params )
    local magicresistbonus = self:GetAbility():GetSpecialValueFor("bons_resist")
    return magicresistbonus
end

function modifier_item_Akyuu_book_passive:GetModifierPhysicalArmorBonus( params )
    local armorbonus = self:GetAbility():GetSpecialValueFor("bons_armor")
	--local percarmor = self:GetParent():GetPhysicalArmorValue()*2
	--if self.totalarmor = nil then
	--self.totalarmor = 0
	--end
	
	

    return armorbonus
    --return percarmor	
end

function modifier_item_Akyuu_book_passive:GetModifierBonusStats_Strength( params )
    local statbonus = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
    return statbonus
end

function modifier_item_Akyuu_book_passive:GetModifierBonusStats_Agility( params )
    local statbonus = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
    return statbonus
end

function modifier_item_Akyuu_book_passive:GetModifierBonusStats_Intellect( params )
    local statbonus = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
    return statbonus
end

function modifier_item_Akyuu_book_passive:GetModifierPercentageRespawnTime( params )

    local respawnreduction = (self:GetAbility():GetSpecialValueFor("reduce_respawn"))/100
	
	local caster = self:GetCaster()
	
	
	if caster:HasItemInInventory("item_history_book") then
		respawnreduction = 0
	end		
	
	
    return respawnreduction
end

function modifier_item_Akyuu_book_passive:IsHidden()
    return false
end



function modifier_item_Akyuu_book_passive:OnRespawn(keys)

	local caster = self:GetCaster()
	
	caster:AddNewModifier(caster, self:GetAbility(), "modifier_item_Akyuu_book_respawn", {duration = self:GetAbility():GetSpecialValueFor("bonus_all_stats_death_duration") + FrameTime()})	
	
	
  
end


LinkLuaModifier( "modifier_item_Akyuu_book_respawn", "items/item_lua/item_Akyuu_book.lua", LUA_MODIFIER_MOTION_NONE )

modifier_item_Akyuu_book_respawn = class({})


function modifier_item_Akyuu_book_respawn:IsPurgable() 
	return false 
end


--function modifier_item_Akyuu_book_respawn:GetAbilityTextureName()
--	return "items/btnitemhiedabook"
--end


function modifier_item_Akyuu_book_respawn:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }

    return funcs
end

function modifier_item_Akyuu_book_respawn:GetModifierBonusStats_Strength( params )
    local statbonus = self:GetAbility():GetSpecialValueFor("bonus_all_stats_death")
    return statbonus
end

function modifier_item_Akyuu_book_respawn:GetModifierBonusStats_Agility( params )
    local statbonus = self:GetAbility():GetSpecialValueFor("bonus_all_stats_death")
    return statbonus
end

function modifier_item_Akyuu_book_respawn:GetModifierBonusStats_Intellect( params )
    local statbonus = self:GetAbility():GetSpecialValueFor("bonus_all_stats_death")
    return statbonus
end
