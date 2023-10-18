local ui = require("ui")
--Folder holding games
local dirPath = "/rom/programs/fun"

local function mainMenu()
	local menu,width,height = ui.createMainWindow()
	
	local oldPath = shell.path()
	shell.setPath(dirPath)
	local gridText = shell.programs()
	shell.setPath(oldPath)
	
	ui.createButtonsInGrid(gridText)
	
	ui.createButton("#", width -1, 1,2, 1, colors.white, colors.red, "exit")
	ui.drawButtons()
end

local function readMouse(x,y)
    local button = ui.checkButtonClick(x,y)
    if button then   
        if button == "exit" then error "Exit" end
		local old = shell.path()
        shell.setPath(dirPath)

        local gameNames = shell.programs()
        local selectedGame = gameNames[button]

		ui.highlightButton(button,colors.lightGray, colors.black, .5)
		
        local tab = shell.openTab(selectedGame)
        shell.switchTab(tab)

        shell.setPath(old)
	end
end

mainMenu()

while true do
    local event, button, x, y = os.pullEvent("mouse_click")
    readMouse(x, y)
end


local function mainMenu()
    local menu,width,height = ui.createMainWindow()

    local oldPath = shell.path()
    shell.setPath(dirPath)
    local gridText = shell.programs()
    shell.setPath(oldPath)

    ui.createButtonsInGrid(gridText)
    ui.createButton("#", width -1, 1,2, 1, colors.white, colors.red, "exit")
    ui.drawButtons()
end


--Directory Based
local function readMouse(b,x,y)
    local button = ui.checkButtonClick(x,y)
    if button then   
        if button == "exit" then error "Exit" end

        --button is a number
        --Get to shell path
        local old = shell.path()
        shell.setPath(dirPath)
        print(old)
        --Grab list of gamePaths
        local gameNames = shell.programs()
        --Select game based on number index
        local selectedGame = gameNames[button]
        local id = shell.openTab(selectedGame)
        shell.switchTab(id)
        ui.clear()
        ui.drawAll()
        --Back to original folder!
        shell.setPath(old)
    end
end

mainMenu()

--Mouse Read Event
while true do
    local event, button, x, y = os.pullEvent("mouse_click")
    readMouse(nil, x, y)
end
