buttons = {}
labels = {}
mainWindow = nil
width,height = 51,19
local windowColor = colors.black

--[[
    Button Object Structure:
    {
        text = buttonText,
        position = vector.new(x,y),
        size = vector.new(width,height),
        foreColor = foreColor,
        backColor = backColor,
        parentWindow = window
    }
    Label Object Structure:
    {
        text = labelText,
        position = vector.new(x,y),
        width = width,
        textColor = foreColor,
        backColor = backColor,
        parentWindow = window
    }
]]

--- creates a 'button' ui object to be dislpayed in the window. Does not automatically draw the buttons, must use drawButtons()
---@param buttonText string
---@param x number
---@param y number
---@param width number | nil
---@param height number | nil
---@param foreColor color | nil
---@param backColor color |nil
---@param buttonID any | nil
---@param window table | nil
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

    --The basis for ALL button object
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

---Creates and places a grid in a window, fitting content or parameters
---@param text {any:string}
---@param buttonWidth number|nil
---@param buttonHeight number|nil
---@param spacing number|nil
---@param window craftosWindow|nil
---@param gridWidth number|nil
---@param offset vector|nil
---@param buttonIDPrefix string|nil
---@param buttonIDList {any:string}|nil Must be same length as text table!
function createButtonsInGrid(text, spacing, buttonWidth, buttonHeight,  window, gridWidth, offset, buttonIDPrefix, buttonIDList)

    local longestWord = 0
    for i,t in pairs(text) do 
        if string.len(t) > longestWord then longestWord = string.len(t) end
    end
    local buttonWidth , buttonHeight = buttonWidth or longestWord , buttonHeight or 3
    spacing = spacing or 1
    gridWidth = gridWidth or width
    offset = offset or vector.new(0,0)
    buttonIDList = buttonIDList or nil
    if buttonIDList and #buttonIDList ~= #text then buttonIDList = nil end

    local numOfColumns = math.min( math.floor(gridWidth / (buttonWidth + spacing*2)), #text)
    local numOfRows = math.ceil(#text / numOfColumns)
    local totalColumnWidth = numOfColumns * (buttonWidth + spacing)
    local totalRowHeight = numOfRows * (buttonHeight + spacing)
    local startPoint = vector.new((width - totalColumnWidth)/2, ((height - totalRowHeight)/2) + buttonHeight/2) + offset
    
    local i = 1
    for y = 0, numOfRows-1 do
        for x = 0, numOfColumns-1 do
            local bPos = vector.new(x * (buttonWidth + spacing) + startPoint.x,
                                     y * (buttonHeight + spacing) + startPoint.y)
            if string.len(text[i]) > buttonWidth then text[i] = string.sub(text[i], 1, buttonWidth) end

            --Setting id from parameters dynamically
            if buttonIDList then
                id = (buttonIDPrefix and (buttonIDPrefix..buttonIDList[i]) or buttonIDList[i])
            else
                id = (buttonIDPrefix and (buttonIDPrefix..tostring(i)) or id)
            end
            --Create button with proper info and positioning
            createButton(text[i], bPos.x, bPos.y, buttonWidth, buttonHeight, 
                            colors.white, colors.gray, id, window)
            i = i + 1
            if i > #text then return end 
        end
    end
end

--Creates a ui object for displaying lines of text. Can only handle SINGLE lines, with no word-wrapping
---@param labelText string
---@param x number
---@param y number
---@param width number|nil
---@param foreColor color|nil
---@param backColor color|nil
---@param labelID any |nil
---@param window table | nil
function createLabel(labelText, x,y, width, foreColor, backColor, labelID, window)
    window = window or mainWindow
    labelID = labelID or #labels + 1
    x = x or 1
    y = y or 1
    --Caching len of text
    local len = string.len(labelText)
    width = width or len
    foreColor = foreColor or colors.white
    backColor = backColor or colors.gray

    local wDelta = width - len
    if wDelta >= 0 then
        local beforeSpaces = math.floor(wDelta/2)
        local afterSpaces = math.ceil(wDelta/2)
        --Adding proper spacing before and after
        for i = 1,beforeSpaces do labelText = " "..labelText end
        for i = 1,afterSpaces do labelText = labelText.." " end
    else --If our label text is bigger than width, we override the provided value
        width = len
    end

    --This is the basis for all labels in the UI API, and their fields
    local labelObject = {
        text = labelText,
        position = vector.new(x,y),
        width = width,
        textColor = foreColor,
        backColor = backColor,
        parentWindow = window
    }
    table.insert(labels, labelObject)
end


function drawLabels()
    for i,label in pairs(labels) do
        local blitFColor, blitBColor = "",""
        local x,y = label.position.x, label.position.y
        local window = label.parentWindow
        for x = 1,string.len(label.text) do
            blitBColor = blitBColor..colors.toBlit(label.backColor)
            blitFColor = blitFColor..colors.toBlit(label.textColor)
        end
        window.setCursorPos(x,y)
        window.blit(label.text, blitFColor, blitBColor)
    end
end

--One function to create a single label and draw it on the provided window, or mainWindow
---@param text string
---@param x number|nil
---@param y number|nil
---@param width number|nil
---@param foreColor colors|nil
---@param backColor colors|nil
---@param window craftOSWindow|nil
function quickDrawLabel(text, x,y, width, foreColor, backColor, window)
    window = window or mainWindow
    labelID = labelID or #labels + 1
    x = x or 1
    y = y or 1
    --Caching len of text
    local len = string.len(text)
    width = width or len
    foreColor = foreColor or colors.white
    backColor = backColor or colors.gray

    local wDelta = width - len
    if wDelta >= 0 then
        local beforeSpaces = math.floor(wDelta/2)
        local afterSpaces = math.ceil(wDelta/2)
        --Adding proper spacing before and after
        for i = 1,beforeSpaces do labelText = " "..labelText end
        for i = 1,afterSpaces do labelText = labelText.." " end
    else --If our label text is bigger than width, we override the provided value
        width = len
    end

    local blitFColor, blitBColor = "",""
    for i = 1,string.len(text) do
        blitBColor = blitBColor..colors.toBlit(backColor)
        blitFColor = blitFColor..colors.toBlit(foreColor)
    end
    window.setCursorPos(x,y)
    window.blit(text, blitFColor, blitBColor)

end

--Draws a button from the list by index
function drawButton(index)
    local button = buttons[index]
    if not button then return false,"Button could not be found!" end
    local bTColor = ""
    local bBColor = ""
    local x,y = button.position.x, button.position.y
    local width,height = button.size.x, button.size.y
    local window = button.parentWindow
    for ii = 1,string.len(button.text) do
        bTColor = bTColor..tostring(colors.toBlit(button.foreColor))
        bBColor = bBColor..tostring(colors.toBlit(button.backColor))
    end
    ------We need to redirect for paintutils, as it uses term.current() for it's window 
    local old = term.redirect(window)
    paintutils.drawFilledBox(x, y, x + width - 1, y + height - 1, button.backColor)
    term.redirect(old)
    ---------------------------------------------------------------------------
    window.setCursorPos(x,y + math.floor(height/2))
    --window.setBackgroundColor(button.backColor)
    --window.setTextColor(button.foreColor)
    window.blit(button.text, bTColor, bBColor)

    mainWindow.setBackgroundColor(windowColor)
end


---Goes through all buttons, calling drawButton() with the proper index, 
---IF window is the button's parent window, OR the param is null, 
---drawing all buttons on their respective windows
---@param window craftOSWindow|nil
function drawButtons(window)
    for i,button in pairs(buttons) do
        if not window or button.parentWindow == window then drawButton(i) end
    end
end



---YEILDS FOR duration!! Use small values, less than 1
---@param index any
---@param backColor colors
---@param foreColor colors
---@param duration number
---@return boolean,string|nil :Success,error code 
function highlightButton(index, backColor, foreColor, duration)
    local button = buttons[index]
    if not button then return false,"Button could not be found!" end
    local oldB, oldF = button.backColor, button.foreColor
    button.backColor = backColor
    button.foreColor = foreColor
    drawButton(index)
    sleep(duration)
    button.foreColor = oldF
    button.backColor = oldB
    drawButton(index)
    return true
end

--Draws all Labels and Buttons to each window, shortcut for drawButtons() and drawLabels()
function drawAll()
    drawButtons()
    drawLabels()
end

---Takes in monitor/screen position, and returns the button that would be clicked by that position
---Does not handle click types, only returns an id from a screen position and window
---@param x integer
---@param y integer
---@param window craftOSWindow
---@return any buttonId
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

---Overrides the default background color
---@param color colors
---@return colors|nil oldColor
function setBackgroundColor(color)
    if not color then return nil end
    if not colors.test(colors, color) then return nil end
    local oldColor = mainWindow.getBackgroundColor()
    mainWindow.setBackgroundColor(color)
    return oldColor
end

---Clears mainWindow background with provided color or the default color
---@param color colors|nil
function clear(color)
    color = color or windowColor
    setBackgroundColor(color)
    mainWindow.clear()
end

---Creates a fresh window in parentTerm (or main terminal)
---@param parentTerm craftOSWindow|nil
---@return table:the window created
---@return integer: the width
---@return integer: the height
function createMainWindow(parentTerm)
    parentTerm = parentTerm or term.current()
    width,height = parentTerm.getSize()
    print(width,height)
    print("main window made")
    mainWindow = window.create(parentTerm,1,1,width,height,true)
    return mainWindow, width,height
end

---Returns width and height of mainWindow
---@return integer
---@return integer
function getSize()
    return width,height
end


--For 'require' implementations
return {buttons = buttons, mainWindow = mainWindow, getSize = getSize, createButton = createButton, 
        createButtonsInGrid = createButtonsInGrid,drawButtons = drawButtons, checkButtonClick = checkButtonClick, 
        clear = clear, createMainWindow = createMainWindow, createLabel = createLabel, drawLabels = drawLabels,
        drawAll = drawAll, quickDrawLabel = quickDrawLabel, drawButton = drawButton, highlightButton = highlightButton}