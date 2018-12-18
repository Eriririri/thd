function RollPseudoRandom(base_chance, entity)
	local chances_table = { {5, 0.38},
							{10, 1.48},
							{15, 3.22},
							{16, 3.65},
							{17, 4.09},
							{19, 5.06},
							{20, 5.57},
							{21, 6.11},
							{22, 6.67},
							{24, 7.85},
							{25, 8.48},
							{27, 9.78},
							{30, 11.9},
							{35, 15.8},
							{40, 20.20},
							{50, 30.20},
							{60, 42.30},
							{70, 57.10},
							{100, 100}
						  }

	entity.pseudoRandomModifier = entity.pseudoRandomModifier or 0
	local prngBase
	for i = 1, #chances_table do
		if base_chance == chances_table[i][1] then		  
			prngBase = chances_table[i][2]
		end	 
	end

	if not prngBase then
		log.warn("The chance was not found! Make sure to add it to the table or change the value.")
		return false
	end
	
	if RollPercentage( prngBase + entity.pseudoRandomModifier ) then
		entity.pseudoRandomModifier = 0
		return true
	else
		entity.pseudoRandomModifier = entity.pseudoRandomModifier + prngBase		
		return false
	end
end