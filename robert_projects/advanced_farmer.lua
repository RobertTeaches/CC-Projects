hoeSlot = 10
shovelSlot = 9
emptySlot = 11
produceSlot = 12
seedSlots = {1,2,3,4}
waterSlots = {13,14,15,16}
farmSize = 0

local function confirmInventory()
    for k,i in pairs(seedSlots) do
        turtle.select(i)
        local data = turtle.getItemDetail()
        if data then
            if not string.find(data.name, "seeds") then
                return false
            end
        else 
            return false
        end
    end

    --Bottom inventory slots must be filled with water buckets
    for k,i in pairs(waterSlots) do
        turtle.select(i) 
        local data = turtle.getItemDetail()
        if data then 
            if data.name ~= "minecraft:water_bucket" then
                return false
            end
        else
            return false
        end
    end
    turtle.select(shovelSlot)
    local data = turtle.getItemDetail()
    if data then
        if not string.find(data.name, "shovel") then
            print(string.format("Don't forget to put a shovel in the %dth slot!", shovelSlot))
            return false
        end
    else
        print(string.format("Don't forget to put a shovel in the %dth slot!", shovelSlot))
        return false
    end

    turtle.select(10)
    local data = turtle.getItemDetail()
    if data then
        if not string.find(data.name, "hoe") then
            print(string.format("Don't forget to put a hoe in the %dth slot!", hoeSlot))
            return false
        end
    else
        print(string.format("Don't forget to put a hoe in the %dth slot!", hoeSlot))
        return false
    end

    return true
end

local function plantSeed()
    for k,i in pairs(seedSlots) do
        turtle.select(i)
        detail = turtle.getItemDetail()
        if detail then
            if string.find(detail.name, "seeds") then
                turtle.placeDown()
                break
            end
        end
    end
    --We use should use an algorithm/formula at the beginning to ensure there are enough seeds
    if detail == nil then print("Ran out of seeds!") end
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
    turtle.select(emptySlot) --selecting what should be an empty slot, and offloading our 
                     --equipped tool, if there is one
    turtle.equipRight()

    turtle.select(hoeSlot) --Grab the hoe slot
    turtle.equipRight() --Equip the hoe
    for x = 1,size do
        for y = 1, size do
            if shouldPlaceWater(x,y) then
                --Put hoe away in slot 6, equip shovel from slot 5
                --Realizing we can just do this we a right/left item equipped, oop
                turtle.select(hoeSlot) turtle.equipRight()
                turtle.select(shovelSlot) turtle.equipRight()
                turtle.select(emptySlot)
                --Dig hole under turtle
                turtle.down()
                turtle.digDown()
                --Grab a bucket from bottom row that has water in it
                for k,i in pairs(waterSlots) do
                    turtle.select(i)
                    bucket = turtle.getItemDetail()
                    if string.find(bucket.name, "water") then break end
                end
                --confirming we did grab a water bucket, then placing it down
                if string.find(bucket.name, "water") then
                    turtle.placeDown()
                end
                turtle.up()
                --Putting shovel away, and equipping hoe
                turtle.select(shovelSlot) turtle.equipRight()
                turtle.select(hoeSlot) turtle.equipRight()
                write("W ")
            else
                --Using Hoe on Ground
                turtle.digDown()
                plantSeed() 
                write("D ")
            end
            turtle.forward()
        end
        turtle.digDown()
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
        -- turtle.digDown()
        -- plantSeed()
        write("\n")
    end

    --Return
    goBack(size)

    turtle.select(hoeSlot)
    turtle.equipRight()
end

local function checkFarm(size)
    if turtle.getItemCount(hoeSlot) > 0 then
        turtle.select(hoeSlot)
        turtle.equipRight()
    end
   --[[
    Same movement style as before, column by column, 
    turning right for odd and left for even
   ]] 
    for x = 1,size do
        for y = 1, size do
            --Read data about plant
            local success, data = turtle.inspectDown()
            local age = 0
            if success then
                if data.state then
                    if data.state.age then
                        print(string.format("This is %d age!", data.state.age))
                        age = data.state.age
                    end
                end
            else
                print("Failed to inspect block underneat")
                turtle.digDown()
                plantSeed()
            end
            --If this plant is fully grown
            if age > 6 then
                print("Fully grown this one is!")
                --ezTurtle.selectSlotWithItem()
                turtle.select(produceSlot)
                turtle.digDown()
                plantSeed()
            end
            turtle.forward()
        end
        --Get last block of each column
        local success, data = turtle.inspectDown()
        if success then
            if data.state then
                if data.state.age then
                    print(string.format("This is %d age!", data.state.age))
                    age = data.state.age
                end
            end
        else
            print("Failed to inspect block underneat")
            turtle.digDown()
            plantSeed()
        end
        --If this plant is fully grown
        if age > 6 then
            print("Fully grown this one is!")
            --ezTurtle.selectSlotWithItem()
            turtle.select(produceSlot)
            turtle.digDown()
            plantSeed()
        end

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
    turtle.select(hoeSlot) turtle.equipRight()
    goBack(size)
end
local args = {...}

if args[1] ~= "inspectOnly" then
if confirmInventory() then
    io.write("Great! Your inventory is set up, I will begin now. Please give me space to work!\n",
        "What size should the farm be?\nSize: ")
    local size = tonumber(io.read())
    farmSize = size
    io.write(string.format("Can you confirm that there is a %d x %d size area in front of me?", size, size)) 
    local confirm = io.read()
    if string.find(string.lower(confirm), "yes") then
        print("Ok, building!")
        createFarm(farmSize, true)
        print("Farm Created!! Doing Inspections every 60 seconds")
        while true do
            sleep(60)
            checkFarm(farmSize)
        end
    end 
else
    print("Sorry, I can't start yet! My invetory needs seeds to fill the top row, and water buckets to fill the bottom")
end
else
   print "How big is the farm?"
   local size = tonumber(io.read())
   checkFarm(size)
end