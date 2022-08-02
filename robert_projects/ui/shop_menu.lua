local ui = require("ui")
local shopMonitor = peripheral.wrap("back")
local workerDisplay = peripheral.wrap("right")
--[[
    This project has a few differnt ways to teach it, depending on the guide-writer's preference
    Our options:
    1 - Auto Grid OR Hand-Placed Items. 
        Auto grid offloads the spacing and placement of buttons to the UI api, which may or may not be ideal 
        for this project difficulty. Hand-Placing can get tedious, but teaches the fundamentals of screen space 
        more literally

    2 - Hardcoding the Menu OR Loading it from a .txt File
        Hardcoding the menu reduces overhead, and has them interacting with table implicit declarations
        Loading it from a textfile adds concepts such as: 
            File-Opening, Closing, and General Management
            Lua's string.gmatch(), which does pattern matching similar to Regex
            Shell directory understanding, and filepath understanding

    3 - Extra monitor for Employee OR Print to terminal
        Depending on the complexity and scope of this project, you may want to skip the extra monitor and 
        just print the shop-results to the terminal. This can reduce logistics and explanation overhead, as you
        don't have to manage two monitors, and can take advantage of peripheral.find()


]]--


--Print out Shopping Results on Store Computer
local function printToWorker(phrase)
    local old = term.redirect(workerDisplay)
    print(phrase)
    term.redirect(old)
end

--HARDCODED Menu
--Name,Price
local menu = {
    {"Sword", 5},
    {"Shovel", 8},
    {"Axe" , 4},
    {"Bow" , 2},
}


--Show shop UI with hand-picked values
local function shopUi()
    if not shopMonitor then error "Need a Monitor to Display On!" end
    shopWindow = ui.createMainWindow(shopMonitor)
    width,height = ui.getSize()

    ui.createButton("X", width - 1, 1, 2, 1, colors.white, colors.red, "exit")
    ui.createButton("Sword", width/4, height/4, 7, 3)
    ui.createLabel("5", width/4 + 2, (height/4) - 1, 3, colors.black, colors.yellow)

    ui.createButton("Shovel", 8+ (width/4), height/4, 8, 3)
    ui.createLabel("5", 10 + (width/4) , (height/4) - 1, 4, colors.black, colors.yellow)

    ui.drawAll()
end

---Loads a menu with "Item price" configuration, line by line
---@param path string
---@return table
local function loadMenuFromTxt(path)
    if not fs.exists(path) then fs.open(path, "w") end
    local file = fs.open(path, "r")
    local m = {}

    line = file.readLine()
    while line do 
        local item = {}
        for token in string.gmatch(line, "[^%s^]+") do
            table.insert(item,token)
        end
        table.insert(m, item)
        line = file.readLine()
    end

    return m
end

--Show shop UI in grid using UI.createButtonsInGrid() function
local function shopUIGrid()
    if not shopMonitor then error "Need a Monitor to Display On!" end
    shopWindow = ui.createMainWindow(shopMonitor)
    width,height = ui.getSize()
    menu = loadMenuFromTxt (shell.dir().."/prices.txt")
    local text = {}
    for  _,item in pairs(menu) do
        table.insert(text, item[1]..":"..tostring(item[2]))
    end

    ui.createButtonsInGrid(text, 2, 10, 3, nil, nil, vector.new(3, 0))
    ui.createButton("X", width - 1, 1, 2, 1, colors.white, colors.red, "exit")
    ui.createButton("@", 1, 1, 2, 1, colors.white, colors.blue, "reset")
    ui.drawButtons()
end

local function monitorTouch(x,y)
    local b = ui.checkButtonClick(x,y,shopWindow)
    if b then 
        if b == "exit" then
            ui.clear(colors.lightBlue)
            workerDisplay.clear()
            error ""
        elseif b == "reset" then
            ui.clear(colors.black)
            workerDisplay.clear()
            shell.run("shop_menu.lua")
            error ""
        else
        local name,price = table.unpack(menu[b])
        printToWorker(name..":"..tostring(price))
        end
    end
end

local function monitorControl()
    while true do
        m, side, x, y = os.pullEvent("monitor_touch")
        shopWindow.setCursorPos(1,1)
        --for i,v in pairs(m) do print(i,v) end
        --print(x, y)
        monitorTouch(x,y) 
    end
end

shopUIGrid()
monitorControl()