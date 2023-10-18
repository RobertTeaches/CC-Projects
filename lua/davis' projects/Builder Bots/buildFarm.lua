function refuel()
    turtle.select(1)
    turtle.refuel(1)
end

function needsFuel()
    if turtle.getFuelLevel() > 25 then
        return true
    else
        return false
    end
end

function placeSeed()
    for i=2,16 do 
        if turtle.getItemCount(i) > 0 then
            turtle.select(i)
            turtle.placeDown()
        end
    end
end

function moveForward()
    while not turtle.forward() do
        turtle.dig()
        turtle.attack()
    end
end



print("Enter the dimensions of your farm. \nNote that the plot will be built starting at the bottom left corner.\nDimension 1:")
length = io.read()
print("Dimension 2:")
width = io.read()

turtle.up()

for i = 1,width do
    if needsFuel() then
        refuel()
    end
    
    
    if i~=1 then
        if i%2 == 0 then
            turtle.turnRight()
            moveForward()
            turtle.turnRight()
            moveForward()
        else
            turtle.turnLeft()
            moveForward()
            turtle.turnLeft()
            moveForward()
        end
    end
    
    for j = 1,length do
        turtle.digDown()
        placeSeed()
        moveForward()
    end
end
