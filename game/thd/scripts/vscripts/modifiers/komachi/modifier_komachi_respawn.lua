modifier_komachi_respawn = class({})




function modifier_komachi_respawn:IsPurgable() 
	return false 
end


function modifier_komachi_respawn:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_RESPAWNTIME_STACKING,
    }

    return funcs
end

function modifier_komachi_respawn:GetModifierStackingRespawnTime( params )
    local respawntimeincrease = self:GetParent():GetLevel()+5
    return respawntimeincrease
end


function modifier_komachi_respawn:IsHidden()
    return true
end


function modifier_komachi_respawn:RemoveOnDeath() return false end