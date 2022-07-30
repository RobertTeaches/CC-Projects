os.loadAPI("ezTurtle.lua")
emptySlot = 11
produceSlot = 12


local function plantSeed()
    if ezTurtle.selectSlotWithItem("seeds") then
        turtle.placeDown()
    else
        print("Ran out of seeds!")
    end
    turtle.select(emptySlot)   
end

--Assumes we are at bottom-right corner
local function goBack(size)
    

    if size % 2 ~= 0 then
        for x = 1,size do
            turtle.forward()
        end
        turtle.turnRight()    
        for x = 1,size do
            turtle.forward()
        end
    else 
        turtle.turnLeft()
        for x = 1,size do
            turtle.forward()
        end
    end
    turtle.turnRight()

end

local function createFarm(size, addWater)
    function shouldPlaceWater(x, y)
        if size == 4 then return false end
        if x == size or x == 1 then return false end
        if y == size or y == 1 then return false end
        if size % 2 ~= 0 then
            if x == math.ceil(size/2) and y == math.ceil(size/2) then
                return true
            end
        else
            if (x == size/2 or x == (size/2) + 1 ) 
            and (y == size/2 or y == (size/2) + 1) 
            then
                return true
            end
        end

        return false
    end

    --[[
        Start at Top-Left Corner, move
        through columns (y) first.
        At the end of a column, 
        if our column number is odd, we turn right
        if it is even, we turn left   
    ]]
    ezTurtle.selectSlotWithItem("shovel") 
    turtle.equipLeft()
    ezTurtle.selectSlotWithItem("hoe") --Grab the hoe slot
    turtle.equipRight() --Equip the hoe
    ezTurtle.selectEmptySlot()
    for x = 1,size do
        for y = 1, size do
            if shouldPlaceWater(x,y) then
                --Dig hole under turtle
                turtle.down()
                turtle.digDown("left")
                --confirming we did grab a water bucket, then placing it down
                if ezTurtle.selectSlotWithItem("water") then
                    turtle.placeDown()
                else
                    error("Ran out of water! This wasn't supposed to happen, shutting down")
                    return
                end
                turtle.up()
                write("W ")
            else
                --Using Hoe on Ground
                turtle.digDown("right")
                plantSeed() 
                write("D ")
            end
            turtle.forward()
        end
        turtle.digDown("right")
        plantSeed()
        if x % 2 == 0 then
            turtle.turnLeft()
            turtle.forward()
            turtle.turnLeft()
        else
            turtle.turnRight()
            turtle.forward()
            turtle.turnRight()
        end
        write("\n")
    end
    --Return
    goBack(size)
end

local function checkFarm(size)
    --Scans a data object, looking for an age-state
   local function getAge(data)
    if data.state then
        if data.state.age then
            print(string.format("This is %d age!", data.state.age))
            return data.state.age
        end
        return 0
    end
   end
   --Checks the state of the plant below the turtle, harvesting it if it is grown
   --and replacing broken/harvested blocks 
   local function checkPlant()
    local success, data = turtle.inspectDown()
    if success then
        --If our plant is fully grown
        if getAge(data) > 6 then
        print("Fully grown this one is!")
        --ezTurtle.selectSlotWithItem()
        turtle.select(produceSlot)
        turtle.digDown("right")
        plantSeed()
        end
    else
        print("No Produce Here! Replanting...")
        turtle.digDown("right")
        plantSeed()
    end
   end

    for x = 1,size do
        for y = 1, size do
            --Read data about plant
            checkPlant()
            turtle.forward()
        end
        --We call this to check the last plant in each column
        checkPlant()

        --Cycling to next row, turning around as well
        if x % 2 == 0 then
            turtle.turnLeft()
            turtle.forward()
            turtle.turnLeft()
        else
            turtle.turnRight()
            turtle.forward()
            turtle.turnRight()
        end
    end
    goBack(size)
end

local neededInventory = {"seeds", "seeds", "seeds", "seeds", 
                          nil,     nil,     nil,     nil, 
                          "shovel", "hoe",  nil,     nil,
                          "water", "water", "water", "water"    
                        }


if ezTurtle.confirmInventory(neededInventory) then
    io.write("Great! Your inventory is set up, I will begin now. Please give me space to work!\n",
        "What size should the farm be?\nSize: ")
    local size = tonumber(io.read())
    io.write(string.format("Can you confirm that there is a %d x %d size area in front of me?", size, size)) 
    local confirm = io.read()
    if string.find(string.lower(confirm), "yes") then
        print("Ok, building!")
        createFarm(size, true)
        print("Farm Created!! Doing Inspections every 60 seconds")
        while true do
            sleep(60)
            checkFarm(size)
        end
    end 
else
    print("Sorry, I can't start yet! My invetory needs seeds to fill the top row, and water buckets to fill the bottom")
end
