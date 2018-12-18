





modifier_item_loneliness_thdr_passive = class({})


function modifier_item_loneliness_thdr_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,	
    }

    return funcs
end

if IsServer() then

    function modifier_item_loneliness_thdr_passive:OnCreated( params )
	
	
	    local missinghealth = (self:GetParent():GetMaxHealth()	- self:GetParent():GetHealth() )
	    self:SetStackCount(missinghealth)
	
	
    	self:StartIntervalThink(1.0)
    end


    function modifier_item_loneliness_thdr_passive:OnIntervalThink()

	    local missinghealth = (self:GetParent():GetMaxHealth()	- self:GetParent():GetHealth())
	    self:SetStackCount(missinghealth)	


    end


end


function modifier_item_loneliness_thdr_passive:GetModifierConstantHealthRegen( params )
	  
    local totalhpregen = self:GetStackCount()*1.5/100 
	  
    return totalhpregen
end

function modifier_item_loneliness_thdr_passive:IsHidden() return true end

