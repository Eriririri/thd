

ability_thdotsr_yuyukoEx = class({})



function ability_thdotsr_yuyukoEx:GetIntrinsicModifierName()
	return "modifier_ability_thdotsr_yuyukoEx"
end

LinkLuaModifier("modifier_ability_thdotsr_yuyukoEx", "new_thd/yuyuko", LUA_MODIFIER_MOTION_NONE)

modifier_ability_thdotsr_yuyukoEx = modifier_ability_thdotsr_yuyukoEx or class({})


function modifier_ability_thdotsr_yuyukoEx:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_RESPAWNTIME_STACKING,
	}

	return funcs
end

function modifier_ability_thdotsr_yuyukoEx:GetModifierStackingRespawnTime( params )
    return -7
end


function modifier_ability_thdotsr_yuyukoEx:IsHidden()
    return true
end


function modifier_ability_thdotsr_yuyukoEx:RemoveOnDeath() return false end