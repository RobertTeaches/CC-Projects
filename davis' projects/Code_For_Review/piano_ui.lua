ui = require("ui")   
local speaker = peripheral.find("speaker")

function piano(num)
    speaker.playNote("harp",3,num)
end

local function drawPiano()
    ui.createMainWindow()
    local color
    for i=0,5 do
        if i % 2 == 0 then color = colors.black else color = colors.white end
        ui.createButton("", i+ui.width/4, ui.height/2, 1, 5, colors.red, color, i)
    end
    for i=6,10 do 
        if i % 2 == 0 then color = colors.white else color = colors.black end
        ui.createButton("", i+ui.width/4, ui.height/2, 1, 5, colors.red, color, i)
    end
    for i=11,17 do
        if i % 2 == 0 then color = colors.black else color = colors.white end
        ui.createButton("", i+ui.width/4, ui.height/2, 1, 5, colors.red, color, i)
    end
    for i=18,22 do 
        if i % 2 == 0 then color = colors.white else color = colors.black end
        ui.createButton("", i+ui.width/4, ui.height/2, 1, 5, colors.red, color, i)
    end
    for i = 23,24 do
        if i % 2 == 0 then color = colors.black else color = colors.white end
        ui.createButton("", i+ui.width/4, ui.height/2, 1, 5, colors.red, color, i)
    end
    ui.clear(colors.gray)
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