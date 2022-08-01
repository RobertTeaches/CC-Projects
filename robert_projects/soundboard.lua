os.loadAPI("ui.lua")

local sounds = {
    "block.anvil.land",
    "block.anvil.use",
    "block.anvil.use",
    "item.trident.thunder",
    "entity.creeper.primed",
    "item.crossbow.loading_end",
    "item.crossbow.loading_end",
    "item.crossbow.loading_end",
    "item.crossbow.loading_end",
    "item.crossbow.loading_end",
    "item.crossbow.loading_end",
    "item.crossbow.loading_end",
    "item.crossbow.loading_end",
    "item.crossbow.loading_end",
    "item.crossbow.loading_end",
    "item.crossbow.loading_end",
    "item.crossbow.loading_end",
    --and so on
}
local speaker = peripheral.find("speaker")
if not speaker then error("Please attach a speaker or I wont' work!") end

--Trying two approaches, one dynamic
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

soundboardMenu()

local function readMouse(m, x, y)
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

while true do
    local event, button, x, y = os.pullEvent("mouse_click")
    readMouse(button,x,y)
end
