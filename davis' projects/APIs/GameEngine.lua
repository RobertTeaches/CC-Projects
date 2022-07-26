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

    --We choose this range due to the number range provided for keyCodes here:
    -- https://github.com/cc-tweaked/CC-Tweaked/blob/ebef3117f201aaece14b9ac6a58d75e671456acf/src/main/resources/data/computercraft/lua/rom/apis/keys.lua#L149
    for i in 1,350 do
        if keys.getName(i) then
            pressedKeys[keys.getName(i)] = false
        end
    end
end

function addUpdateFunction(fun)
    table.insert(_onUpdate_Functions, fun)
end

return {init = init, addUpdateFunction = addUpdateFunction, pressedKeys = pressedKeys}