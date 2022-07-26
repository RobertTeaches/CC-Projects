os.loadAPI("st-apis/GameEngine")

--Game Variables
local playerColor = colors.gray
local playerPos = vector.new(1,1)
local prizeColor = colors.yellow
local prizePos = vector.new(math.random(5,50), math.random(1,19))

--Game Functions
local function draw()
    paintutils.drawBox(playerPos.x, playerPos.y, 1, 2, playerColor)
    paintutils.drawBox(prizePos.x, prizePos.y, 1, 1, prizeColor)
end

--Core Update Loop
function Update()
    draw()
    if playerPos.x == prizePos.x and
       playerPos.y == prizePos.y then
        playerColor = colors.green
    end
    if GameEngine.pressedKeys["d"] then 
        playerPos = playerPos + vector.new(1,0)
    elseif GameEngine.pressedKeys["a"] then 
        playerPos = playerPos + vector.new(-1,0)
    elseif GameEngine.pressedKeys["s"] then 
        playerPos = playerPos + vector.new(0,-1)
    elseif GameEngine.pressedKeys["w"] then 
        playerPos = playerPos + vector.new(0,1)
    end
end

--Start() is not neccessary as a function, I just contain the init stuff inside
--The GameEngine needs two things, to add your own Update function to the loop, and to start the GameEngine
function Start()
    GameEngine.addUpdateFunction(Update)
    GameEngine.init()
end


