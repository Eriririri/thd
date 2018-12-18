

function THDHealTarget(caster,target,healamount)


	if target:IsNull() == false then

		if target:HasModifier("modifier_item_loneliness") then
	
		healamount = healamount*1.3
	
		end
	
	
		if target:HasModifier("item_horse_red") then
	
		healamount = healamount*1.25
	
		end	
		
		if target:HasModifier("modifier_item_3rd_eye_debuff") then
	
		healamount = healamount*0.5
	
		end		
		


		SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,target,healamount,nil)
		target:Heal(healamount,caster)

	
	end




end


function THDHealTarget2(caster,target,healamount)

	if target:IsNull() == false then


		if target:HasModifier("modifier_item_loneliness") then
	
		healamount = healamount*1.3
	
		end
	
		if target:HasModifier("item_horse_red") then
	
		healamount = healamount*1.25
	
		end	
		

		if target:HasModifier("modifier_item_3rd_eye_debuff") then
	
		healamount = healamount*0.5
	
		end			


		--SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,target,healamount,nil)
		target:Heal(healamount,caster)

	


	end


end


function THDLifestealTarget(attacker,target,Lifesteal,dealdamage)

	local msgheal = (attacker:GetAverageTrueAttackDamage(attacker) * Lifesteal *0.01)

	local totalheal = dealdamage*Lifesteal*0.01





	if attacker:HasModifier("modifier_item_loneliness") then
	
	totalheal = totalheal*1.3
	
	msgheal = msgheal*1.3
	
	end
	
	if attacker:HasModifier("item_horse_red") then
	
	totalheal = totalheal*1.25
	
	msgheal = msgheal*1.25
	
	end	
	
	
	if target:HasModifier("modifier_item_3rd_eye_debuff") then
	
	totalheal = totalheal*0.5
	
	msgheal = msgheal*0.5
	
	end		
	
	local targetarmor = target:GetPhysicalArmorValue()
	
	totalheal = totalheal* (1-(targetarmor*0.052)/(0.9+0.048*targetarmor))
	
	msgheal = msgheal* (1-(targetarmor*0.052)/(0.9+0.048*targetarmor))
	
	
	if totalheal >= 0 then
	
	SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,attacker,msgheal,nil)	
	
	

	attacker:Heal(totalheal,attacker)

	
	end

--	end


end

function THDHealTargetLily(caster,target,healamount)


	if target:IsNull() == false then

		if target:HasModifier("modifier_item_loneliness") then
	
			healamount = healamount*1.3
	
		end
	
	
		if target:HasModifier("item_horse_red") then
	
			healamount = healamount*1.25
	
		end	



		
		if caster:FindAbilityByName("special_bonus_unique_lily_1"):GetLevel() > 0  then
		
			healamount = healamount*1.5
		
		end
		
		if target:HasModifier("modifier_item_3rd_eye_debuff") then
	
		--	healamount = healamount*0.5
	
		end			

		SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,target,healamount,nil)
		target:Heal(healamount,caster)		
	
	end




end




