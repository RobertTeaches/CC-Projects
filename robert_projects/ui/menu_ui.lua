--POTENTIAL API CODE START

buttons = {}
labels = {}
mainWindow = {}
width,height = term.getSize()

local function createButton(buttonText, 
                            x,y, width, height, 
                            foreColor, backColor, 
                            buttonID, window)
                            
    --Setting defaults, probably not needed in project-guide
    window = window or mainWindow

    --Id should exist as a key that has not been used in the button table,
    --otherwise it will be the next int index
    buttonID = buttonID or #buttons + 1
    if buttons[buttonID] ~= nil then print(buttonID.." is used") buttonID = #buttons + 1 end
    
    backColor = backColor or colors.white
    foreColor = foreColor or colors.gray
    width = width or 5
    height = height or 2
    x = x or 1
    y = y or 1
    buttonText = buttonText or "BLANK"

    local textLength = string.len(buttonText)
    --Visual adjustment to add spaces before/after button text, 
    --so that blit covers the entire button, and we won't have
    --any text issues
    local wDelta = width - textLength
    if wDelta < 0 then 
        width = textLength
    else
        local beforeNum = math.floor(wDelta/2)
        local afterNu = math.ceil(wDelta/2)

        for i = 1, beforeNum do buttonText = " "..buttonText end
        for i = 1, afterNu do buttonText = buttonText.." " end
    end
    

    local buttonObject = {
        text = buttonText,
        position = vector.new(x,y),
        size = vector.new(width,height),
        foreColor = foreColor,
        backColor = backColor,
        parentWindow = window
    }
    buttons[buttonID] = buttonObject
    window.setBackgroundColor(colors.black)
end

local function drawButtons()
    for i,button in pairs(buttons) do
        local bTColor = ""
        local bBColor = ""
        local x,y = button.position.x, button.position.y
        local width,height = button.size.x, button.size.y
        local window = button.parentWindow
        for ii = 1,string.len(button.text) do
            bTColor = bTColor..tostring(colors.toBlit(button.foreColor))
            bBColor = bBColor..tostring(colors.toBlit(button.backColor))
        end
        --print(string.len(buttonText), bTColor, string.len(bBColor))
        paintutils.drawFilledBox(x, y, x + width - 1, y + height - 1, button.backColor)
        
        window.setCursorPos(x,y + math.floor(height/2))
        window.setBackgroundColor(button.backColor)
        window.setTextColor(button.foreColor)
        window.blit(button.text, bTColor, bBColor)
    end
    term.setBackgroundColor(colors.black)
end

local function checkButtonClick(x,y)
    local function pointCollision(bX,bY, bW, bH, x, y)
        if bX + bW -1 >= x and bX - 1 <= x 
        and bY + bH -1 >= y and bY - 1 <= y 
        then 
            return true
        else 
            return false
        end
    end
    for key,button in pairs(buttons) do
        if pointCollision(button.position.x, button.position.y, 
                            button.size.x, button.size.y,
                             x, y) 
        then
            return key                     
        end
    end
    return false
end
--POTENTIAL API CODE END


term.setCursorBlink(true)



local function mainMenu()
    local menu = window.create(term.current(),1,1,width,height,true)
    mainWindow = menu
    local b1pos = vector.new(width/2, height/2)
    createButton("Menu", 1,1, 6, 1, colors.black, colors.grey)
    createButton("Exit", 46, 1, 5, 1, colors.white, colors.red, "exit")
    createButton("Click me!", b1pos.x, b1pos.y, 7, 4, colors.black, colors.lightBlue, "mainButton")
    drawButtons()
end

function readMouse(b,cx,cy)
    local buttonKey = checkButtonClick(cx,cy)
    if buttonKey then
        term.setCursorPos(1,6)
        term.setBackgroundColor(colors.black)
        print(buttonKey)
        if buttonKey == "mainButton" then
            term.setBackgroundColor(colors.black)
            term.clear()
            term.setTextColor(colors.white)
            term.setCursorPos(1, height/2 - 2)
            write("Thank you For clicking the button...")
        elseif buttonKey == "exit" then
            term.setBackgroundColor(colors.black)
            term.clear()
            term.setCursorPos(1,1)
            error()
        end


        buttons[buttonKey].backColor = colors.green
    else
        term.setCursorPos(1,6)
        term.setBackgroundColor(colors.black)
        term.clear()
        print(string.format("Click Coords: (%d,%d)",cx, cy))
    end
    drawButtons()
end

mainMenu()

while true do
    local event, button, x, y = os.pullEvent("mouse_click")
    readMouse(button,x,y)
end
