



LinkLuaModifier("thdotsr_int_mana_adjust", "util/global_modifier.lua", LUA_MODIFIER_MOTION_NONE)


thdotsr_int_mana_adjust = class({})

function thdotsr_int_mana_adjust:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }

    return funcs
end

function thdotsr_int_mana_adjust:GetModifierHealthBonus( params )
    local hpbonus = self:GetCaster():GetStrength()*(-4.5)
    return hpbonus
end

function thdotsr_int_mana_adjust:IsHidden()
    return true
end

function thdotsr_int_mana_adjust:RemoveOnDeath()
    return false
end

function thdotsr_int_mana_adjust:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end