local ui = require "ui"
--[[
    Three implementations:
        1. Creating our own grid, coding the dynamic system ourself
            Deep, specific understanding of how "grid" based math works, including spacing
            createButtonsInGrid() will likely not be a UI api function you create in a guide, so it may be good
            to hit it here
        2. Using UI api to create a grid of buttons for us
            Simple, easy, requires very little code to actually set up. Can utilize table/dict tricks to easily store 
            labels and sound names
            Can focus guide more on tables, indexing a list, keys/ids, and data structures instead of 2d math
        3. Hardcoding the button positions,ids,colors, etc
            More tedious, but gives a much simpler example of UI pixel placement, spacing, clicking, etc
            Sounds can be built up slowly, with repeatable steps, so that students can add to the code in a way that 
            challenges them and forces them to write functional code 
            (not just adding to a list of values, actually needing to code in the id check, if statements, etc..)
]]

--Table Of Sounds
local sounds = {
    "block.anvil.land",
    "block.anvil.use",
    "item.trident.thunder",
    "entity.creeper.primed",
    "item.crossbow.loading_end",
    --and so on
}
local speaker = peripheral.find("speaker")
if not speaker then error("Please attach a speaker or I wont' work!") end

--Trying two approaches, one dynamic with grid-code in the project
local function soundboardMenu()
    window = ui.createMainWindow(colors.blue)
    local buttonWidth, buttonHeight = 4,3
    local spacing = 1
    local numOfColumns = math.min( math.floor(ui.width / (buttonWidth + spacing*2)), #sounds)
    local numOfRows = math.ceil(#sounds / numOfColumns)
    local totalColumnWidth = numOfColumns * (buttonWidth + spacing)
    local totalRowHeight = numOfRows * (buttonHeight + spacing)
    local startPoint = vector.new((ui.width - totalColumnWidth)/2, ((ui.height - totalRowHeight)/2) + buttonHeight/2)
    local i = 1
    for y = 0, numOfRows-1 do
        for x = 0, numOfColumns-1 do
            local bPos = vector.new(x * (buttonWidth + spacing) + startPoint.x,
                                     y * (buttonHeight + spacing) + startPoint.y)
            ui.createButton(tostring(i), bPos.x, bPos.y, buttonWidth, buttonHeight, 
                            colors.white, colors.gray, i)
            i = i + 1
            if i > #sounds then ui.drawButtons() return end 
        end
    end

    ui.drawButtons()
end

local sounds2 = {
    Anvil1 = "block.anvil.land",
    Anvil2 = "block.anvil.use",
    Thunder = "item.trident.thunder",
    Creeper = "entity.creeper.primed",
    Crossbow = "item.crossbow.loading_end",
    --and so on
}

--Using ui.createButtonsInGrid() to do it in very few lines
local function soundBoard_UIGrid()
    window,w,h = ui.createMainWindow()
    local names = {}
    for name,_ in pairs(sounds2) do
        table.insert(names, name)
    end
    ui.createButtonsInGrid(names, 3, 10, 5, nil, nil, nil, nil, names)
    ui.drawButtons()
end

--Hardcoding positions, names, indexes, and colors
local function soundboardHardcoded()
    local window = ui.createMainWindow()
    ui.createButton("Anvil1", 5,2, 10, 5, colors.black, colors.lightGray, "Anvil1")
    ui.createButton("Anvil2", 16,2, 10, 5, colors.black, colors.lightGray, "Anvil2")
    ui.createButton("Thunder", 27,2, 10, 5, colors.black, colors.yellow, "Thunder")
    ui.createButton("Creeper", 38,2, 10, 5, colors.black, colors.green, "Creeper")
    ui.createButton("Bow", 5,10, 10, 5, colors.white, colors.brown, "Bow")
    ui.drawButtons()
end

soundboardHardcoded()

--Hardcoded Dynamic GRID
local function readMouseTable1(m, x, y)
     local buttonHit = ui.checkButtonClick(x,y)
     if buttonHit then
        speaker.playSound(sounds[buttonHit], 1, 1)
        ui.buttons[buttonHit].backColor = colors.blue
        ui.drawButtons()
        sleep(1)
        ui.buttons[buttonHit].backColor = colors.gray
        ui.drawButtons()
     end
end

--UI Dynamic Grid
local function readMouseTable2(m, x, y)
    local buttonHit = ui.checkButtonClick(x,y)
    if buttonHit then
       speaker.playSound(sounds2[buttonHit], 1, 1)
       ui.buttons[buttonHit].backColor = colors.blue
       ui.drawButtons()
       sleep(1)
       ui.buttons[buttonHit].backColor = colors.gray
       ui.drawButtons()
    end
end

--Hardcoded Positions and values
local function readMouseHardcoded(m,x,y)
    local button = ui.checkButtonClick(x,y)
    if button then
        local soundName = ""
        if button == "Anvil1" then
            soundName = "block.anvil.land"
        elseif button == "Anvil2" then
            soundName = "block.anvil.use"
        elseif button == "Thunder" then
            soundName = "item.trident.thunder"
        elseif button == "Creeper" then
            soundName = "entity.creeper.primed"   
        elseif button == "Bow" then
            soundName = "item.crossbow.loading_end"
        end
        speaker.playSound(soundName, 1, 1)
        ui.highlightButton(button, colors.red, colors.white, .5)
    end


end

while true do
    local event, button, x, y = os.pullEvent("mouse_click")
    readMouseHardcoded(button,x,y)
end
