os.loadAPI("disk/STProjects/APIs/GameEngine.lua")

--Game Variables
local playerColor = colors.gray
local playerPos = vector.new(1,1)
local prizeColor = colors.yellow
local prizePos = vector.new(math.random(5,50), math.random(1,19))
local playerWidth = 1
local playerHeight = 2
local isWin = false

--Game Functions
local function draw()
    paintutils.drawBox(playerPos.x, playerPos.y, playerPos.x+playerWidth, playerPos.y+playerHeight, playerColor)
    if not isWin then
        paintutils.drawPixel(prizePos.x, prizePos.y, prizeColor)
    end
    term.setBackgroundColor(colors.black)
end

--Core Update Loop
function Update()
    draw()
    if (prizePos.x >= playerPos.x and prizePos.x <= playerPos.x+playerWidth) and
       (prizePos.y >= playerPos.y and prizePos.y <= playerPos.y+playerHeight) then
        playerColor = colors.green
        isWin = true
    end
    if GameEngine.pressedKeys["d"] then 
        playerPos.x = playerPos.x + 1
    elseif GameEngine.pressedKeys["a"] then 
        playerPos.x = playerPos.x - 1
    elseif GameEngine.pressedKeys["s"] then 
        playerPos.y = playerPos.y + 1
    elseif GameEngine.pressedKeys["w"] then 
        playerPos.y = playerPos.y -1
    end
end

--Start() is not neccessary as a function, I just contain the init stuff inside
--The GameEngine needs two things, to add your own Update function to the loop, and to start the GameEngine
function Start()
    GameEngine.addUpdateFunction(Update)
    GameEngine.init()
end

Start()

