function doOneEighty()
    turtle.turnLeft()
    turtle.turnLeft()
end

function swapBlocks()
    if turtle.getSelectedSlot() == 2 then
        turtle.select(3)
    else
        turtle.select(2)
    end
end

function buildLogo()
    turtle.select(2)
    turtle.forward()
    for i=1,7 do 
        turtle.forward()
        turtle.placeDown()
    end
    turtle.forward()
    doOneEighty()
    turtle.up()
    turtle.placeDown()
    swapBlocks()
    for i=1,7 do
        turtle.forward()
        turtle.placeDown()
    end
    swapBlocks()
    turtle.forward()
    turtle.placeDown()
    doOneEighty()
    turtle.up()
    turtle.placeDown()
    swapBlocks()
    for i=1,5 do
        turtle.forward()
        turtle.placeDown()
    end
    swapBlocks()
    for i=1,2 do
        turtle.forward()
        turtle.placeDown()
    end
    doOneEighty()
    turtle.up()
    turtle.forward()
    for i=1,2 do
        turtle.forward()
        turtle.placeDown()
    end
    swapBlocks()
    for i=1,3 do
        turtle.forward()
        turtle.placeDown()
    end
    turtle.forward()
    swapBlocks()
    turtle.placeDown()
    doOneEighty()
    turtle.up()
    turtle.forward()
    turtle.placeDown()
    swapBlocks()
    for i=1,4 do
        turtle.forward()
        turtle.placeDown()
    end
    swapBlocks()
    turtle.forward()
    turtle.placeDown()
    doOneEighty()
    turtle.up()
    turtle.placeDown()
    swapBlocks()
    for i=1,4 do
        turtle.forward()
        turtle.placeDown()
    end
    swapBlocks()
    turtle.forward()
    turtle.placeDown()
    turtle.forward()
    doOneEighty()
    turtle.up()
    turtle.placeDown()
    swapBlocks()
    for i=1,3 do
        turtle.forward()
        turtle.placeDown()
    end
    swapBlocks()
    for i=1,2 do
        turtle.forward()
        turtle.placeDown()
    end
    turtle.forward()
    turtle.forward()
    turtle.up()
    doOneEighty()
    turtle.placeDown()
    turtle.forward()
    turtle.placeDown()
    swapBlocks()
    for i=1,5 do
        turtle.forward()
        turtle.placeDown()
    end
    swapBlocks()
    turtle.forward()
    turtle.placeDown()
    doOneEighty()
    turtle.up()
    turtle.placeDown()
    swapBlocks()
    for i=1,7 do
        turtle.forward()
        turtle.placeDown()
    end
    swapBlocks()
    turtle.forward()
    turtle.placeDown()
    doOneEighty()
    turtle.up()
    for i=1,7 do
        turtle.forward()
        turtle.placeDown()
    end
    turtle.forward()
    turtle.forward()
    for i=1,10 do turtle.down() end
end
    
buildLogo()    
