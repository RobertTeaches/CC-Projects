ui = require("ui")


--Print out Shopping Results on Store Computer
local function printToWorker(phrase)
    print(phrase)
end
--Name,Price
local menu = {
    {"Sword", 5},
    {"Shovel", 2},
    {"Axe" , 4},
    {"Bow" , 2},
}


--Show shop UI 
local function shopUi()
    local monitor = peripheral.find("monitor")
    if not monitor then error "Need a Monitor to Display On!" end
    window = ui.createMainWindow(monitor)
    width,height = ui.getSize()
    ui.createButton("Test", width/2, height/2)
    ui.drawButtons()
end

local function monitorTouch(x,y)
    window.setCursorPos(1,1)
    local b = ui.checkButtonClick(x,y,window)
    if b then 
        local name,price = table.unpack(menu[b])
        printToWorker(name..":"..tostring(price))
    end
end

local function monitorControl()
    while true do
        m, side, x, y = os.pullEvent("monitor_touch")
        window.setCursorPos(1,1)
        --for i,v in pairs(m) do print(i,v) end
        --print(x, y)
        monitorTouch(x,y) 
    end
end

shopUi()
monitorControl()