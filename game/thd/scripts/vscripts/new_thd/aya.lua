

ability_thdotsr_Aya05 = class({})


function ability_thdotsr_Aya05:GetIntrinsicModifierName()
	return "modifier_ability_thdotsr_Aya05"
end

LinkLuaModifier("modifier_ability_thdotsr_Aya05", "new_thd/aya", LUA_MODIFIER_MOTION_NONE)

modifier_ability_thdotsr_Aya05 = modifier_ability_thdotsr_Aya05 or class({})



function modifier_ability_thdotsr_Aya05:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}

	return funcs
end


function modifier_ability_thdotsr_Aya05:GetModifierMoveSpeedBonus_Special_Boots()

	local totalspeed = self:GetParent():GetLevel()*3.6
	return totalspeed
end


function modifier_ability_thdotsr_Aya05:GetModifierIgnoreMoveSpeedLimit()
	return 10000
end
