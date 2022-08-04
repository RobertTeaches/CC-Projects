--os.loadAPI("ui.lua")
ui = require "ui"

local speaker = peripheral.find("speaker")
function piano(num)
    speaker.playNote("harp",2,num)
end

local function drawPiano()
    window, width, height = ui.createMainWindow()
    for i = 2,50 do
        local color
        if i % 2 == 0 then color = colors.black else color = colors.white end 
        ui.createButton("", i, height/2 - 3, 1, 5, colors.red, color, i)
    end
    ui.clear(colors.gray)
    --print("after set",ui.windowColor)
    ui.drawButtons()
end

local function readMouse(m, x, y) 
    local buttonKey = ui.checkButtonClick(x,y)
    if buttonKey then
        piano(buttonKey)
    end
end

drawPiano()

while true do
    local event, button, x, y = os.pullEvent("mouse_click")
    readMouse(button,x,y)
end