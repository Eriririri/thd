


function Thdgetmana(target,amount)

	getmana = amount
	if target:HasItemInInventory("item_horse_blue") then
	
	
	
	getmana = getmana*1.5
	end
	SendOverheadEventMessage(nil,OVERHEAD_ALERT_MANA_ADD,target,amount,nil)
	
	target:GiveMana(getmana)

end