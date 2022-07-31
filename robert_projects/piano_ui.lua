os.loadAPI("ui.lua")

local speaker = peripheral.find("speaker")
function piano(num)
    speaker.playNote("harp",2,num)
end

local function drawPiano()
    ui.createMainWindow()
    for i = 2,50 do
        local color
        if i % 2 == 0 then color = colors.yellow else color = colors.white end 
        ui.createButton("", i, ui.height/2 - 3, 1, 5, colors.red, color, i)
    end
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