buttons = {}
labels = {}
mainWindow = nil
width,height = 51,19
windowColor = colors.black

--- creates a 'button' ui object to be dislpayed in the window. Does not automatically draw the buttons, must use drawButtons()
---@param buttonText string
---@param x number
---@param y number
---@param width number or nil
---@param height number or nil
---@param foreColor color or nil
---@param backColor color or nil
---@param buttonID any or nil
---@param window table or nil
function createButton(buttonText,x,y, width, height, foreColor, backColor,buttonID, window)

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
    window.setBackgroundColor(windowColor)
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
        --print(string.len(buttonText) bTColor, string.len(bBColor))
        local old = term.redirect(window)
        paintutils.drawFilledBox(x, y, x + width - 1, y + height - 1, button.backColor)
        term.redirect(old)
        window.setCursorPos(x,y + math.floor(height/2))
        window.setBackgroundColor(button.backColor)
        window.setTextColor(button.foreColor)
        window.blit(button.text, bTColor, bBColor)
        window.setBackgroundColor(windowColor)
    end
    --print all values in table
end

function deleteButtons(parentWindow)
    parentWindow = parentWindow or mainWindow
    for i,button in pairs(buttons) do
        if button.parentWindow == parentWindow then
            buttons[i] = nil
        end
    end
end

function checkButtonClick(x,y, window)
    window = window or false
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
        if pointCollision(button.position.x, button.position.y, button.size.x, button.size.y, x, y)
        and (not window or window == button.parentWindow)
        then
            return key
        end
    end
    return false
end

function clear(color)
    color = color or windowColor
    mainWindow.setBackgroundColor(color)
    mainWindow.clear()
end

function createMainWindow(parentTerm)
    parentTerm = parentTerm or term.current()
    width,height = parentTerm.getSize()
    print(width,height)
    print("main window made")
    mainWindow = window.create(parentTerm,1,1,width,height,true)
    return mainWindow
end

function getSize()
    return width,height
end
--For 'require' implementations
return {buttons = buttons, mainWindow = mainWindow, getSize = getSize, windowColor = windowColor,
createButton = createButton, drawButtons = drawButtons, deleteButtons = deleteButtons, checkButtonClick = checkButtonClick, clear = clear, createMainWindow = createMainWindow}