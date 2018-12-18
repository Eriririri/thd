



LinkLuaModifier("thdotsr_str_hp_adjust_lua", "util/global_modifier.lua", LUA_MODIFIER_MOTION_NONE)


thdotsr_str_hp_adjust_lua = class({})

function thdotsr_str_hp_adjust_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }

    return funcs
end

function thdotsr_str_hp_adjust_lua:GetModifierHealthBonus( params )
    local hpbonus = self:GetCaster():GetStrength()*(-4.5)
    return hpbonus
end

function thdotsr_str_hp_adjust_lua:IsHidden()
    return true
end

function thdotsr_str_hp_adjust_lua:RemoveOnDeath()
    return false
end

function thdotsr_str_hp_adjust_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end


LinkLuaModifier("thdotsr_int_mana_adjust", "util/global_modifier.lua", LUA_MODIFIER_MOTION_NONE)


thdotsr_int_mana_adjust = class({})

function thdotsr_int_mana_adjust:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_BONUS,
    }

    return funcs
end

function thdotsr_int_mana_adjust:GetModifierManaBonus( params )
    local reducebonus = self:GetCaster():GetIntellect()*(-3)
    return reducebonus
end

function thdotsr_int_mana_adjust:IsHidden()
    return true
end

function thdotsr_int_mana_adjust:RemoveOnDeath()
    return false
end

function thdotsr_int_mana_adjust:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end







LinkLuaModifier("modifier_reduce_50_heal", "util/global_modifier.lua", LUA_MODIFIER_MOTION_NONE)


modifier_reduce_50_heal = class({})

if IsServer() then
    function modifier_reduce_50_heal:OnCreated(args)
        self.LockedHealth = -1
		if self:GetParent() ~= "npc_dota_hero_furion" then
        self:StartIntervalThink(0.033)
		end
		--if self:GetParent() == "npc_dota_hero_furion" then
        --self:StartIntervalThink(0.033)
		--end		
		
    end

    function modifier_reduce_50_heal:OnRefresh(args)
    end

    function modifier_reduce_50_heal:OnIntervalThink()
        local target = self:GetParent()
		
        local current_health = target:GetHealth()
		
		local fullhp = target:GetMaxHealth()
		local almostfullhp = target:GetMaxHealth()-1		

        if self.LockedHealth == -1 then
            self.LockedHealth = current_health
        end
		if target:HasModifier("modifier_no_heal") then
			return
		end
		
		if target:GetClassname() ~= "npc_dota_hero_furion" then
		

			if current_health > self.LockedHealth then
			
			local hpdifferent = (current_health - self.LockedHealth)/2
			
			target:SetHealth(math.floor(hpdifferent+self.LockedHealth))
				--target:SetHealth()
			--ApplyDamage({attacker = self:GetCaster(), victim = target, ability = self:GetAbility(), damage = hpdifferent, damage_type = DAMAGE_TYPE_PURE,damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS })
			--target:SetHealth(self.LockedHealth)
			--else
				--self.LockedHealth = current_health
				--else
				--self.LockedHealth = current_health				
			end
			
			self.LockedHealth = current_health

		end
		
		if target:GetClassname() == "npc_dota_hero_furion" then
		

			if current_health > self.LockedHealth then
			
			local hpdifferent = (current_health - self.LockedHealth)/2
			local hpdifferent2 = (current_health - self.LockedHealth)	
				if 	hpdifferent2  > 50 then		
				target:SetHealth(math.floor(hpdifferent+self.LockedHealth))
				end
			
			end
			
			self.LockedHealth = current_health

		end	
		
		
    end
end