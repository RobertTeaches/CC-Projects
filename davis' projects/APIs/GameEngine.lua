--Game Engine does not handling drawing, only running a loop and reading input
pressedKeys = {}
_onUpdate_Functions = {}
refreshRate = 15 -- WARNING: MAX REFRESH RATE IS 20FPS.
updateTime = math.floor((100 * (1/refreshRate))) / 100


--Main Loop
local function gameLoop()
    --Calls each update function every "updateTime" seconds
    while true do
        term.clear()
        for i, v in pairs(_onUpdate_Functions) do
            v()
        end
        sleep(updateTime)
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

function addUpdateFunction(fun)
    table.insert(_onUpdate_Functions, fun)
end

local hasStarted = false
function init()
    if hasStarted then return end

    hasStarted = true
    --We choose this range due to the number range provided for keyCodes here:
    -- https://github.com/cc-tweaked/CC-Tweaked/blob/ebef3117f201aaece14b9ac6a58d75e671456acf/src/main/resources/data/computercraft/lua/rom/apis/keys.lua#L149
    for i = 1,350 do
        if keys.getName(i) then
            pressedKeys[keys.getName(i)] = false
        end
    end
    parallel.waitForAny(gameLoop, keyDownInput, keyUpInput)
end
