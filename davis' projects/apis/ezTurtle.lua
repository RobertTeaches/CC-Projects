function selectEmptySlot()
    for i = 1,16 do
        if turtle.getItemCount(i) == 0 then
            turtle.select(i)
            return true
        end
    end
    return false
end

function selectSlotWithItem(item)
    for i = 1,16 do
        if turtle.getItemDetail(i) and string.find(turtle.getItemDetail(i).name, item) then
            turtle.select(i)
            return true
        end
    end
    return false
end
---Confirms that inventory matches the turtle's inventory
---@param inventory table{string}
---the inventory must be a 16-item table, with each slot either being the name of an
---item, or nil
function confirmInventory(inventory)
    for i = 1,16 do
        turtle.select(i)
        local slotInfo = turtle.getItemDetail()
        if (inventory[i] == nil) ~= (slotInfo == nil) then
            error("Incorrect Turtle Inventory Supplied.")
            print(string.format("In slot %d was expecting a %s item"), i, inventory[i])
            return false
        end
        if slotInfo then
            if not string.find(slotInfo.name, inventory[i]) then
                error("Incorrect Turtle Inventory Supplied.")
                print(string.format("In slot %d was expecting a %s item"), i, inventory[i])
                return false
            end
        end 
    end
    return true
end

function equipTool(toolName, side)
    side = side or "right"
    side = string.lower(side)
    if selectSlotWithItem(toolName) then
        if side == "right" then turtle.equipRight()
        elseif side == "left" then turtle.equipLeft()
        else error("Supplied Side must be left or right!")
        end
    else
        error(string.format("Could not find %s in turtle inventory", toolName))
    end
end

function unequipTools()
    if selectEmptySlot() then
        turtle.equipRight()
    else 
        error "Could not find an empty slot!"
    end

    if selectEmptySlot() then
        turtle.equipLeft()
    else
        error "Could not find an empty slot!"
    end
end