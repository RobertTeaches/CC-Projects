local spiral_length = 4
local spiral_height = 16
local height = 0
local isClockwise = false

function getBlocks()
    currentSlot = turtle.getSelectedSlot
    for i=2,16 do
        if turtle.getItemCount(i) > 0 then
            turtle.select(i)
            return true
        end
    end
    if turtle.getSelectedSlot == currentSlot then
        return false
    end
end

function placeStep()
    turtle.place()
    turtle.up()
    turtle.forward()
    height = height + 1
end

turtle.select(2)
local firstSet = true
local buildLength = spiral_length

while true do
    local breakLoop = false

    for i=1,buildLength do 

        if turtle.getItemCount(turtle.getSelectedSlot()) <= 0 then
            if not getBlocks() then
                print("No blocks in inventory!")
                breakLoop = true
                break
            end

        else
            placeStep()
            if height >= spiral_height then
                breakLoop = true
                break
            end
        end
    end

    if firstSet then
        
        buildLength = buildLength - 1
    end

    if breakLoop then
        break
    end

    if isClockwise then
        turtle.turnRight()
    else
        turtle.turnLeft()
    end
end

turtle.forward()
for i=1,height do
    turtle.down()
end