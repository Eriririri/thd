




active_yugi01_hp_bouns = class({})

function active_yugi01_hp_bouns:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }

    return funcs
end

function active_yugi01_hp_bouns:GetModifierHealthBonus( params )

    self.hp = self:GetAbility():GetSpecialValueFor("HP_STACKS")

    local hpincrease = self:GetCaster():GetStrength()*self.hp

    return hpincrease
end



function active_yugi01_hp_bouns:IsHidden()
    return true
end

function active_yugi01_hp_bouns:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end