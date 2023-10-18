function buildPen(length,width)
	turtle.up()

	placeFences(length,true,true)
	turtle.turnRight()
	placeFences(width,false,false)
	turtle.turnRight()
	placeFences(length,false,false)
	turtle.turnRight()
	placeFences(width,false,false)
	turtle.turnRight()
end

function placeFences(distance,gates,first)
	gatePosition1 = -1
	gatePosition2 = -1

    if gates then
        if(distance % 2 == 0) then
            gatePosition1 = distance/2
            gatePosition2 = gatePosition1+1
        else
            gatePosition1 = math.floor(distance / 2 + 1)
        end
	end

	turtle.select(2)

	for i=1,distance do
		if not first and i == 1 then
		
		else
			turtle.forward()
			if i == gatePosition1 or i == gatePosition2 then
				turtle.select(3)
				turtle.turnLeft()
				turtle.placeDown()
				turtle.turnRight()
			else
				turtle.select(2)
				turtle.placeDown()
			end
		end
	end
end

print("Please enter desired pen length")
local l = io.read()
print("Please enter desired pen width")
local w = io.read()

buildPen(l,w)