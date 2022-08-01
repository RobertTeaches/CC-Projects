local size = tonumber(...)
	function build()
		turtle.placeDown()
		if turtle.getItemCount(turtle.getSelectedSlot()) == 0 then
			turtle.select(turtle.getSelectedSlot() + 1)
		end
	end

function pyramid(height)
    turtle.up()
    local length = height*2-1
    if height == 1 then
        turtle.placeDown()
    else
        for i = 1, 4 do
            for i = 1, length-1 do
                build()
                turtle.forward()
            end
            turtle.turnRight()
        end
        turtle.forward()
        turtle.turnRight()
        turtle.forward()
        turtle.turnLeft()
        pyramid(height - 1)
    end
end

pyramid(size)
    
