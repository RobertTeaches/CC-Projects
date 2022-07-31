os.loadAPI("ui")

local sounds = {
    "block.anvil.land",
    "block.anvil.use",
    "block.anvil.use",
    "entity.cat.purr",
    "entity.creeper.primed",
    "item.crossbow.loading_end",
    --and so on
}
--Trying two approaches, one dynamic
local function soundboardDyamic()
    ui.createMainWindow(colors.blue)
    local buttonWidth, buttonHeight = 3,2
    local spacing = 1
    local numOfColumns = math.floor(ui.width / (buttonWidth + spacing*2))
    local numOfRows = math.ceil(#sounds / numOfColumns)
    local startPoint = vector.new(1, ui.height/(numOfRows+1))
    local i = 1
    for y = 1, numOfRows do
        for x = 1, numOfColumns do
            local bPos = vector.new(x * (buttonWidth + spacing) + startPoint.x,
                                     y * (buttonHeight + spacing) + startPoint.y)
            ui.createButton(tostring(i), bPos.x, bPos.y, buttonWidth, buttonHeight, colors.white, colors.gray) 

            i = i + 1
        end
    end
end

--And one hardcoded
local function soundboardDesigned()

end

