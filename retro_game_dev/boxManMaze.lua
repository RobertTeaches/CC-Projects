local boxColor = colors.blue
local finishColor = colors.green
local trapColor = colors.red
local playerSize = vector.new(0,2)

local playerPos = vector.new(5,1,0)
local numOfTraps = 20
local trapSpawnArea = {vector.new(4,2,0), vector.new(46, 18, 0)}
local finishSpawnArea = {vector.new(30,2,0), vector.new(46, 18, 0)}
trapsPos = {}
local finishPos

local gameOver = false

function drawPlayer(pos, size)
    paintutils.drawBox(pos.x, pos.y, 
                    pos.x + size.x, pos.y + size.y, 
                    boxColor)
end

function drawTrap(pos)
    paintutils.drawPixel(pos.x, pos.y, trapColor)
end

function drawFinish()
    paintutils.drawPixel(finishPos.x, finishPos.y, finishColor)
end

function collision_point_box(boxPos, size, pointPos)
    local boxExtents = vector.new(boxPos.x + size.x, boxPos.y + size.y)

    if boxPos.x <= pointPos.x and boxExtents.x >= pointPos.x then
        if boxPos.y <= pointPos.y and boxExtents.y >= pointPos.y then
            return true
        end
    end
    return false
end

function spawnTraps()
    for count = 1,numOfTraps do
        local randX = math.random(trapSpawnArea[1].x, trapSpawnArea[2].x)
        local randY = math.random(trapSpawnArea[1].y, trapSpawnArea[2].y)
        table.insert(trapsPos, vector.new(randX, randY, 0))
    end
end


function drawMaze()
    for count,trap in pairs(trapsPos) do
        drawTrap(trap)
    end
    drawFinish()
    term.setBackgroundColor(colors.black)
end

function start()
    spawnTraps()
    local randX = math.random(finishSpawnArea[1].x, finishSpawnArea[2].x)
    local randY = math.random(finishSpawnArea[1].y, finishSpawnArea[2].y)
    finishPos = vector.new(randX, randY, 0)
    --
    term.clear()
    drawMaze()
    --
    sleep(1)
end

function lose()
    gameOver = true
    --term.clear()
    drawMaze()
    print("Lose :(")
end

function win()
    gameOver = true
    drawMaze()
    print("Win! :)")
end

function movePlayer(dir)
    if playerPos.y + dir.y > 0 and playerPos.y + dir.y < 20 - playerSize.y and playerPos.x + dir.x > 0 and  playerPos.x + dir.x < 50 - playerSize.x then
        playerPos = playerPos + vector.new(dir.x,dir.y)
    end
end


function draw()
    term.clear()
    drawPlayer(playerPos, playerSize)
    term.setBackgroundColor(colors.black)
end


function maze_code()
    if collision_point_box(playerPos, playerSize, finishPos) then
        win()
    end
    for count,trap in pairs(trapsPos) do
        if collision_point_box(playerPos, playerSize, trap) then
            lose()
        end
    end

end

function KeyInput()

    local e, key = os.pullEvent("key")
    local kName = keys.getName(key)
    if kName == "w" then
        movePlayer(vector.new(0,-1,0))
    elseif kName == "s" then
        movePlayer(vector.new(0,1,0))
    elseif kName == "a" then
        movePlayer(vector.new(-1,0,0))
    elseif kName == "d" then
        movePlayer(vector.new(1,0,0))
    end

end

local monitor = peripheral.find("monitor")
local screen = term.current()

function externalMonitor()
    term.redirect(screen)
    draw()
    screen = term.redirect(monitor)
    draw()
end

function GameLoop()
    while true do
        externalMonitor()
        KeyInput()
        maze_code()
        if gameOver then break end
    end   
end

start()
GameLoop()
