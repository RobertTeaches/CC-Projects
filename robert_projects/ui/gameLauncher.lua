local ui = require("ui")
--[[
    For this Project, you can choose between some implementation options:
        1 Hardcoded Game Values 
            Hardcode the path to each game, as well as the button properties
            Simplest, and does not rely on ui.CreateButtonsInGrid() to cheat work
        OR
        2 Table Based Game Values
            Hardcode a table with a Name,path pair, so students can have design choces with naming
            Uses ui.CreateButtonsInGrid() to simplify dynamic button creation, so can be shorter, but more difficult
        OR  
        3 Directory Based Game Values
            Highest difficulty, but the most dynamic. Allows the student to pick a diretory, opens the directory,
            loads the file names into a table, and creates buttons based on that. Uses the order of files to run the correct one
            Deals less with ui based stuff, and more with directory/shell management, and higher level concepts such as tables/file names, and directry pathing
            ]]


--Hardcoded Values
local programPath = ".../../retro_game_dev/boxManApples.lua"
local programName = "boxManApples"

--Table of games
local games = {
    Apples = "../../retro_game_dev/boxManApples.lua",
    Maze = "../../retro_game_dev/boxManMaze.lua",
    Pong = "../../retro_game_dev/boxManPong.lua",
    Rythm = "../../retro_game_dev/boxManRythm.lua"
}

--Dir holding games
local dirPath = "../../retro_game_dev/"


local function mainMenuGrid_DirPath()
    local menu,width,height = ui.createMainWindow()

    local oldPath = shell.path()
    shell.setPath(dirPath)
    local gridText = shell.programs()
    shell.setPath(oldPath)

    ui.createButtonsInGrid(gridText)
end

local function mainMenuGrid_Table()
    local menu,width,height = ui.createMainWindow()
    local gridText = {}
    for name,path in pairs(games) do
        table.insert(gridText, name)
    end
    ui.createButtonsInGrid(gridText, 2, 7,3, nil, nil, nil, nil, gridText)

end

local function mainMenuHardCoded()
    local menu = ui.createMainWindow()
    local b1pos = vector.new(ui.width/2, ui.height/2)
    ui.createButton("Apples", b1pos.x, b1pos.y, 7, 4, colors.black, colors.lightBlue, "mainButton")
    ui.drawButtons()
end

--Hardcoded
local function readMouseHardcoded(b,cx,cy)
    local buttonKey = ui.checkButtonClick(cx,cy)
    if buttonKey then
        --GREEN COLORING ON CLICK
        ui.buttons[buttonKey].backColor = colors.green
        ui.clear(colors.black)
        ui.drawButtons()
        sleep(.05) --Highlight time, DOES yield, so input cannot be updated until highlighting is done
        ui.buttons[buttonKey].backColor  = colors.gray
        ui.clear(colors.black)
        ui.drawButtons()
        --GREEN COLORING ON CLICK

        if buttonKey == "mainButton" then
            term.setBackgroundColor(colors.black)
            term.clear()
            shell.run(programPath)
        elseif buttonKey == "exit" then
            term.setBackgroundColor(colors.black)
            term.clear()
            term.setCursorPos(1,1)
            error()
        end


       
    else
        term.setCursorPos(1,6)
        term.setBackgroundColor(colors.black)
        term.clear()
        print(string.format("Click Coords: (%d,%d)",cx, cy))
    end
    
end

--Table Based
local function readMouseTable(b,x,y)
    local button = ui.checkButtonClick(x,y)
    if button then
        if button == "exit" then error "Exited!" end
        local path = games[button]

        --TEMP GREEN COLORING
        ui.buttons[button].backColor = colors.green
        ui.clear(colors.black)
        ui.drawButtons()
        sleep(.05)
        ui.buttons[button].backColor  = colors.gray
        ui.clear(colors.black)
        ui.drawButtons()
        ---END TEMP GREEN COLOR

        local id = shell.openTab(path)
        shell.switchTab(id)
        ui.clear(colors.black)
        ui.drawButtons() 
    end
end

--Directory Based
local function readMouseDir(b,x,y)
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

--Every Menu will have the exit key, you can place the bottom two lines inside whatever 'mainMenu()' 
--functin you decide to use ----------
mainMenuGrid_DirPath()
ui.createButton("#", width -1, 1,2, 1, colors.white, colors.red, "exit")
ui.drawButtons()
----------------------------------------------

--Mouse Read Event
while true do
    local event, button, x, y = os.pullEvent("mouse_click")
    readMouseDir(nil, x, y)
end
