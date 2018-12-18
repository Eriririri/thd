

LinkLuaModifier("nimazhale", "util/global_modifier2.lua", LUA_MODIFIER_MOTION_NONE)


nimazhale = class({})



function nimazhale:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BONUS_DAY_VISION,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,		
    }

    return funcs
end

function nimazhale:GetBonusNightVision( params )
    return -10000
end

function nimazhale:GetBonusDayVision( params )
    return -10000
end



if IsServer() then
    function nimazhale:OnCreated(args)
        self.LockedHealth = -1
        self:StartIntervalThink(0.033)
    end

    function nimazhale:OnRefresh(args)
    end

    function nimazhale:OnIntervalThink()
        local target = self:GetParent()
        local current_health = target:GetHealth()

        if self.LockedHealth == -1 then
            self.LockedHealth = current_health
        end

        if current_health > self.LockedHealth then
            target:SetHealth(self.LockedHealth)
        else
            self.LockedHealth = current_health
        end
    end
end

function nimazhale:RemoveOnDeath() return false end