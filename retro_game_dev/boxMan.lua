local boxColor = colors.gray
local boxSize = 4
local boxPos = vector.new(1, 1, 0)

function draw()
    term.clear()
    paintutils.drawBox(boxPos.x, boxPos.y, boxPos.x + boxSize + 1, boxPos.y + boxSize, boxColor)
    term.setBackgroundColor(colors.black)
end

function youWin()
    term.clear()
    term.setCursorPos(1, 1)
    term.write("You Win!")
end

function input()
    local e, key = os.pullEvent("key")
    local kName = keys.getName(key)
    if kName == "w" then
        boxPos = boxPos + vector.new(0, -1)
    elseif kName == "s" then
        boxPos = boxPos + vector.new(0, 1)
    elseif kName == "a" then
        boxPos = boxPos + vector.new(-1, 0)
    elseif kName == "d" then
        boxPos = boxPos + vector.new(1, 0)
    end
end

function gameLoop()
    while true do
        input()
        draw()
        if boxPos.x > 50 or boxPos.y > 20 then
            youWin()
            break
        end
    end
end

gameLoop()
