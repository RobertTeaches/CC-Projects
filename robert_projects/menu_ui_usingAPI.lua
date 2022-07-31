os.loadAPI("ui.lua")

term.setCursorBlink(true)

local function mainMenu()
    local menu = ui.createMainWindow()
    local b1pos = vector.new(ui.width/2, ui.height/2)
    ui.createButton("Menu", 1,1, 6, 1, colors.black, colors.grey)
    ui.createButton("Exit", 46, 1, 5, 1, colors.white, colors.red, "exit")
    ui.createButton("Click me!", b1pos.x, b1pos.y, 7, 4, colors.black, colors.lightBlue, "mainButton")
    ui.drawButtons()
end

function readMouse(b,cx,cy)
    local buttonKey = ui.checkButtonClick(cx,cy)
    if buttonKey then
        term.setCursorPos(1,6)
        term.setBackgroundColor(colors.black)
        print(buttonKey)
        if buttonKey == "mainButton" then
            term.setBackgroundColor(colors.black)
            term.clear()
            term.setTextColor(colors.white)
            term.setCursorPos(1, ui.height/2 - 2)
            write("Thank you For clicking the button...")
        elseif buttonKey == "exit" then
            term.setBackgroundColor(colors.black)
            term.clear()
            term.setCursorPos(1,1)
            error()
        end


        ui.buttons[buttonKey].backColor = colors.green
    else
        term.setCursorPos(1,6)
        term.setBackgroundColor(colors.black)
        term.clear()
        print(string.format("Click Coords: (%d,%d)",cx, cy))
    end
    ui.drawButtons()
end

mainMenu()

while true do
    local event, button, x, y = os.pullEvent("mouse_click")
    readMouse(button,x,y)
end
