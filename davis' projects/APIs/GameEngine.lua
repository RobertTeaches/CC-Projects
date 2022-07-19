--Game Engine does not handling drawing, only running a loop and reading input
pressedKeys = {}
updateTime = 0.1
_onUpdate_Functions = {}


--Main Loop
local function gameLoop()
    while sleep(0.1) do
        for i, v in pairs(_onUpdate_Functions) do
            v()
        end
    end
end
--Key Loop
local function keyDownInput()
    while true do 
        local e, key = os.pullEvent("key")
        pressedKeys[keys.getName(key)] = true
    end
end
local function keyUpInput()
   while true do
    local e, key = os.pullEvent("key_up")
        pressedKeys[keys.getName(key)] = false
   end 
end

function init()
    parallel.waitForAny(gameLoop, keyDownInput, keyUpInput)
end

function addUpdateFunction(fun)
    table.insert(_onUpdate_Functions, fun)
end

return {init = init, addUpdateFunction = addUpdateFunction}