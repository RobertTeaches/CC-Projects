local function confirmInventory()
    for i = 1,4 do
        turtle.select(i)
        local data = turtle.getItemDetail()
        if data then
            if data.name ~= "minecraft:wheat_seeds" then
                return false
            end
        else 
            return false
        end
    end

    --Bottom inventory slots must be filled with water buckets
    for i = 13,16 do
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

    return true
end

local function createFarm(size, addWater)
    function shouldPlaceWater(x, y)
        --[[
            size = 3, addWater = true
            D D D 
            D W D
            D D D    
    
            size = 4, addWater = true
            D D D D 
            D D D D 
            D D D D
            D D D D --Seems to not work well with size 4
            
            size = 5, addwater = true
            D D D D D
            D D D D D
            D D W D D
            D D D D D
            D D D D D
            
            size = 6
            D D D D D D
            D D D D D D 
            D D W W D D
            D D W W D D
            D D D D D D 
            D D D D D D 
    
            size = 7
            D D D D D D D 
            D D D D D D D 
            D D D D D D D 
            D D D W D D D 
            D D D D D D D 
            D D D D D D D 
            D D D D D D D 
    
            size = 8
            D D D D D D D D 
            D D D D D D D D 
            D D D D D D D D
            D D D W W D D D
            D D D W W D D D
            D D D D D D D D
            D D D D D D D D
            D D D D D D D D
        ]]--
        if size == 4 then return false end
        if x == size or x == 1 then return false end
        if y == size or y == 1 then return false end
        if size % 2 ~= 0 then
            if x == math.ceil(size/2) and y == math.ceil(size/2) then
                return true
            end
        else
            if (x == size/2 or x == (size/2) + 1 ) and (y == size/2 or y == (size/2) + 1) then
                return true
            end
        end

        return false
    end
    
    for x = 1,size do
        for y = 1, size do
            if shouldPlaceWater(x,y) then
                write("W ")
            else 
                write("D ")
            end
        end
        write("\n")
    end
end

if confirmInventory() then
    io.write("Great! Your inventory is set up, I will begin now. Please give me space to work!\n",
        "What size should the farm be?\nSize: ")
    local size = tonumber(io.read())
    io.write(string.format("Can you confirm that there is a %d x %d size area in front of me?", size, size)) 
    local confirm = io.read()
    if string.find(string.lower(confirm), "yes") then
        print("Ok, building!")
        createFarm(size, true)
    end 
else
    print("Sorry, I can't start yet! My invetory needs seeds to fill the top row, and water buckets to fill the bottom")
end