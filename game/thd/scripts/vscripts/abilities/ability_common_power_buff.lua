

function powerbuffreducerespawn(keys)
    local caster = EntIndexToHScript(keys.caster_entindex)
   caster:SetTimeUntilRespawn(caster:GetRespawnTime()*0.75)
end