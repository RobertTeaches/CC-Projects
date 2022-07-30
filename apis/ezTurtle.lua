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