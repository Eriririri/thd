passive_byakuren04_bonus_health_lua = class({})





function passive_byakuren04_bonus_health_lua:IsPurgable() 
	return false 
end


function passive_byakuren04_bonus_health_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }

    return funcs
end

function passive_byakuren04_bonus_health_lua:GetModifierHealthBonus( params )

    --self.abilitylevel = (self:GetAbility():GetLevel())
    self.manascale = self:GetAbility():GetSpecialValueFor("health_increase")
    local bonusbyakurenhealth = self:GetCaster():GetMaxMana()*self.manascale
    return bonusbyakurenhealth
end

function passive_byakuren04_bonus_health_lua:RemoveOnDeath()
    return false
end

function passive_byakuren04_bonus_health_lua:IsHidden()
    return true
end