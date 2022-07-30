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
--- func desc
---@param inventory table{string}
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