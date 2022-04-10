local openCounter = 0
local externalMonitor = peripheral.find("monitor")
local chat = peripheral.wrap("bottom")
local redstoneSide = "left"


if externalMonitor then term.redirect(externalMonitor) end

local redstoneHasReset = true
while true do
    if redstone.getInput(redstoneSide) and redstoneHasReset then
        redstoneHasReset = false
        openCounter = openCounter + 1
        if chat then chat.sendMessage("Welcome Home!") end
    elseif not redstone.getInput(redstoneSide) then
        redstoneHasReset = true
    end
    term.clear()
    print(openCounter)
    
    sleep(.1)
end
