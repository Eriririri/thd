creepnobd = class({})


--function creepnobd:CheckState()
--	local state =
--		{
--			[MODIFIER_STATE_STUNNED] = true
--		}
--	return state
--end


function creepnobd:IsPurgable() 
	return false 
end


function creepnobd:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function creepnobd:GetModifierMoveSpeedBonus_Constant( params )
	return 1
end



function creepnobd:IsHidden()
	return true
end