ui = require("ui")
util = require("util")

local chest = peripheral.find("minecraft:chest")
local monitor = peripheral.find("monitor")
thingsToTrack = {"minecraft:stone", "minecraft:cobblestone",
                "minecraft:iron_ore", "minecraft:gold_ore",
                "minecraft:diamond_ore", "minecraft:coal"}



function getChestInfo()
    --Search all chest Slots
    chestInfo = {}
    numItems = 0
    for i = 1, chest.size() do
        local item = chest.getItemDetail(i)
        if item ~= nil then
            --Check if item is in the list of things to track
            for j = 1, #thingsToTrack do
                if item.name == thingsToTrack[j] then
                    --If it is, add it to the chestInfo table
                    --filter out everything before ':'
                    x,y = string.find(item.name, ":")
                    shortName = string.sub(item.name, y + 1)
                    if chestInfo[shortName] == nil then chestInfo[shortName] = 0 numItems = numItems + 1 end
                    chestInfo[shortName] = chestInfo[shortName] + item.count
                end
            end
        end
    end
    return chestInfo, numItems
end

function updateMonitor()
    ui.deleteButtons(monitor)
    chestInfo,numItems = getChestInfo()
    print(numItems)
    for i,v in ipairs(chestInfo) do print(v) end
    numLabels = numItems
    if numLabels == 0 then return end
    mx, my = monitor.getSize()
    lw = math.min(10, math.floor(mx/numLabels))
    lh = math.floor(my/3)
    i = 0
    for index, value in pairs(chestInfo) do
        print("Making button for "..index)
        ui.createButton(index..chestInfo[index], (i * lw) + 1, 2, lw, lh, colors.white, colors.gray, i, monitor)
        i = i+1
    end

    ui.drawButtons()
end

--Set up the UI display and begin the loop

ui.createMainWindow(monitor)


while true do
    getChestInfo()
    updateMonitor()
    sleep(.1)
end
