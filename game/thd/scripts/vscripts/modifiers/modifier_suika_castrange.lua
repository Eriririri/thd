modifier_suika_castrange = class({})




function modifier_suika_castrange:IsPurgable() 
	return false 
end


function modifier_suika_castrange:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
    }

    return funcs
end

function modifier_suika_castrange:GetModifierCastRangeBonus( params )
    return 500
end



function modifier_suika_castrange:IsHidden()
    return true
end