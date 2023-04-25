function createRandomPlateText()
    local characters = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
	local plate = ""

 	for i = 1, 3 do
    	plate = plate..characters[math.random(1, #characters)]
	end

	plate = plate.."-"
	
    for i = 1, 3 do
		plate = plate..math.random(1, 9)
	end
    
	return plate
end