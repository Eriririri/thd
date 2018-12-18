modifier_shikieiki_respawn = class({})




function modifier_shikieiki_respawn:IsPurgable() 
	return false 
end


function modifier_shikieiki_respawn:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_RESPAWNTIME_STACKING,
    }

    return funcs
end

function modifier_shikieiki_respawn:GetModifierStackingRespawnTime( params )
    local respawntimeincrease2 = self:GetParent():GetAssists()+self:GetParent():GetKills()
	
	if self:GetParent():HasModifier("modifier_komachi_respawn") then
		respawntimeincrease2 = respawntimeincrease2 + 20
	end	
	
	
    return respawntimeincrease2
end


--function modifier_shikieiki_respawn:IsHidden()
--    return true
--end


function modifier_shikieiki_respawn:RemoveOnDeath() return false end