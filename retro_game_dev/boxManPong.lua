local boxColor = colors.blue
local pongColor = colors.green
local compColor = colors.red
local boxSize = vector.new(0,2)
local playerPos = vector.new(5,1,0)
local computerPos = vector.new(45, 1,0)


local pongPos = vector.new(25,15,0)
local pongVelocity = vector.new(-0.5,-0.5,0)

function drawPlayer(pos, size)
    paintutils.drawBox(pos.x, pos.y, 
                    pos.x + size.x, pos.y + size.y, 
                    boxColor)
end
function drawComp(pos, size)
    paintutils.drawBox(pos.x, pos.y, 
                    pos.x + size.x, pos.y + size.y, 
                    compColor)
end
function drawPong(pos)
    paintutils.drawPixel(pos.x, pos.y, pongColor)
end

function collision_point_box(boxPos, size, pointPos)
    local boxExtents = vector.new(boxPos.x + size.x + 1, boxPos.y + size.y)

    if boxPos.x - 1 <= pointPos.x and boxExtents.x >= pointPos.x then
        if boxPos.y - 1 <= pointPos.y and boxExtents.y + 1 >= pointPos.y then
            return true
        end
    end
    return false
end

function draw()
    term.clear()
    drawPlayer(playerPos, boxSize)
    drawComp(computerPos, boxSize)
    drawPong(pongPos)
    term.setBackgroundColor(colors.black)
end

function pong_code()
    pongPos = pongPos + pongVelocity

    if pongPos.x < 2 or pongPos.x > 49 then
        pongVelocity = vector.new(-pongVelocity.x, pongVelocity.y)
    end
    if pongPos.y < 2 or pongPos.y > 19 then
        pongVelocity = vector.new(pongVelocity.x, -pongVelocity.y)
    end

    if collision_point_box(playerPos, boxSize, pongPos) then
        pongVelocity = vector.new(math.abs(pongVelocity.x), pongVelocity.y)
    end

    if collision_point_box(computerPos, boxSize, pongPos) then
        pongVelocity = vector.new(-math.abs(pongVelocity.x), pongVelocity.y)
    end

    if pongPos.y  > computerPos.y then
        moveComputer(.5)
    elseif pongPos.y  < computerPos.y then
        moveComputer(-.5)
    end

end

function movePlayer1(dir)
    if playerPos.y + dir > 0 and playerPos.y + dir < 20 - boxSize.y then
        playerPos = playerPos + vector.new(0,dir)
    end
end

function moveComputer(dir)
    if computerPos.y + dir > 0 and computerPos.y + dir < 20 - boxSize.y then
        computerPos = computerPos + vector.new(0,dir)
    end
end

function keyInput()
    while true do 
        local e, key = os.pullEvent("key")
                local kName = keys.getName(key)
                if kName == "w" then
                    movePlayer1(-1)
                elseif kName == "s" then
                    movePlayer1(1)
                end
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

function gameLoop()
    while true do
        externalMonitor()
        pong_code()
        sleep(0.01)
    end   
end

term.redirect(monitor)
parallel.waitForAny(gameLoop, keyInput)
