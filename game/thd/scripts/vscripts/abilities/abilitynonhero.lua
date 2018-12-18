LinkLuaModifier("modifier_movespeed_cap_goliath", "scripts/vscripts/modifiers/modifier_movespeed_cap_goliath.lua", LUA_MODIFIER_MOTION_NONE)

function MaxSpeed(keys)
local caster = keys.caster
local ability = keys.ability
caster:AddNewModifier(caster, ability, "modifier_movespeed_cap_goliath",  {} )
end