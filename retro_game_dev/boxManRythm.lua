local rythmBlocks = {}
local rythmPossibilites = {"w", "s", "a", "d"}

local blockStart = vector.new(25,0)
local blockSpeed = .25

local timeBetweenBlocks = 1
local blockPerfectHeight = 17

local points = 0


local function add_rythm_block()
    local newBlock = {
        position = blockStart,
        rythmKey = rythmPossibilites[math.random(1,4)]
    }
    table.insert(rythmBlocks, newBlock)
end
local function update_blocks()
    for i,v in pairs(rythmBlocks) do
        v.position = v.position + vector.new(0,blockSpeed)
    end
    if #rythmBlocks > 0 and rythmBlocks[1].position.y > 20 then
        table.remove(rythmBlocks,1)
    end
end

local function draw_blocks()
    for i,v in pairs(rythmBlocks) do
        local color
        if v.rythmKey == "w" then
            color = colors.red
        elseif v.rythmKey == "s" then
            color = colors.blue 
        elseif v.rythmKey == "d" then 
            color = colors.green
        elseif v.rythmKey == "a" then 
            color = colors.yellow
        end
        paintutils.drawPixel(v.position.x, v.position.y, color)
        --print(v.position)
    end
end
debugO = ""
local function hit_block(blockKey)
    local block = table.remove(rythmBlocks, 1)
    if not block then return end
    debugO = block.position
    if blockKey == block.rythmKey and math.floor(block.position.y + .5) == blockPerfectHeight then
        points = points + 1
        if points % 7 == 0 then
            timeBetweenBlocks = timeBetweenBlocks - 0.125
            blockSpeed = blockSpeed + .1
        end
    end
end

function draw()
    term.clear()
    draw_blocks()
    paintutils.drawLine(1, blockPerfectHeight, 51, blockPerfectHeight, colors.green)
    term.setBackgroundColor(colors.black)
    term.setCursorPos(1,1)
    print("Points: "..points)
    term.setTextColor(colors.red)
    print("w")
    term.setTextColor(colors.blue)
    print("s")
    term.setTextColor(colors.green)
    print("d")
    term.setTextColor(colors.yellow)
    print("a")
    --print(debugO)
end

function KeyInput()
    while true do 
        local e, key = os.pullEvent("key")
                local kName = keys.getName(key)
                if kName == "a" or kName == "d" or kName == "w" or  kName == "s" then
                    hit_block(kName)
                end
    end
end

local gameTimer = timeBetweenBlocks
function GameLoop()
    while true do
        draw()
        sleep(0.05)
        --Rythm Timer
        gameTimer = gameTimer - 0.05
        if gameTimer <= 0 then
            timeBetweenBlocks = timeBetweenBlocks - math.random(-.1,.1)
            gameTimer = timeBetweenBlocks
            add_rythm_block()
        end
        update_blocks()

    end   
end

parallel.waitForAny(GameLoop, KeyInput)