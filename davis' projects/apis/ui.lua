buttons = {}
labels = {}
mainWindow = nil
width,height = term.getSize()

function createButton(buttonText, 
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

function drawButtons()
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

function checkButtonClick(x,y)
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

function createMainWindow()
    print("main window made")
    mainWindow = window.create(term.current(),1,1,width,height,true)
    return mainWindow
end