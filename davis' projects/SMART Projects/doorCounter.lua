local openCounter = 0
local externalMonitor = peripheral.find("monitor")
local redstoneSide = "left"


if externalMonitor then term.redirect(externalMonitor) end

local redstoneHasReset = true
while true do
    if redstone.getInput(redstoneSide) and redstoneHasReset then
        redstoneHasReset = false
        openCounter = openCounter + 1
    elseif not redstone.getInput(redstoneSide) then
        redstoneHasReset = true
    end
    term.clear()
    print(openCounter)
    sleep(.1)
end