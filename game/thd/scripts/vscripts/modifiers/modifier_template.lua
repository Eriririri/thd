modifier_template = class({})


function modifier_template:CheckState()
	local state =
		{
			[MODIFIER_STATE_STUNNED] = true
		}
	return state
end


function modifier_template:IsPurgable() 
	return false 
end


function modifier_template:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_template:GetModifierMoveSpeed_Max( params )
    return 2200
end

function modifier_template:GetModifierMoveSpeed_Limit( params )
    return 2200
end

function modifier_template:IsHidden()
    return true
end