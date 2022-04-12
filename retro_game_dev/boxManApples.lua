local boxColor = colors.blue
local appleColor = colors.white
local screenExtents = vector.new(51, 20)
math.randomseed(os.time())

Player = {
    size = vector.new(6,2),
    position = vector.new(0, 17),

    move = function (self, direction)
        if self.position.x + direction.x >= 0 and self.position.x + direction.x <= screenExtents.x - self.size.x then
            self.position = self.position + direction
        end
    end,

    draw = function (self)
        paintutils.drawBox(self.position.x, self.position.y, 
        self.position.x + self.size.x, self.position.y + self.size.y, 
        boxColor)
    end,
}

Apple = {
    size = vector.new(1,1),
    position = vector.new(0,0),
    velocity = vector.new(0, 0.5),

    --Our Lua constructor I hate it  i hate it i hate it i hate it haithea taeitaetat
    new = function(self, o, position, speed)
        o = o or {}
        o.position = position
        o.velocity = speed
        setmetatable(o, self)
        self.__index = self
        return o
    end,
    draw = function(self)
        --print("called"..self.position.x..self.position.y)
        paintutils.drawPixel(self.position.x, self.position.y, appleColor)
    end,

    
    update = function (self)
        self.position = self.position + self.velocity
    end
}

local player = Player
local apples = {}
local points = 0

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
    player:draw()


    for num, apple in pairs(apples) do
        apple:draw()
        --print(apple.size)
    end
    term.setBackgroundColor(colors.black)
    term.setCursorPos(1,1)
    print("Score: "..points)
end

function spawn_apples(totalApples)
    totalApples = totalApples or 3 --Default/Optional
    for i = 1, totalApples do 
        --Random spot on top of screen
        local pos = vector.new(math.random(1,50), 0)
        --Random fall speed between .25 and .75 (need the math this way for some reason)
        local startSpeed = vector.new(0, .25 * math.random(1, 3.0))
        --Take note of the : operator, similar to . but not the same
        local a = Apple:new(nil, pos, startSpeed)
        table.insert(apples, a)
    end

end

function apple_code()
    --Loop through all apples
    for num, apple in pairs(apples) do
        apple:update() --Updating position

        --If we "collide" with the player, add a point and 'delete' the apple from the list
        if collision_point_box(player.position, player.size, apple.position) then
            points = points + 1
            table.remove(apples, num)
        end

        --If we go below the bottom of the screen (20), delete the apple from the list
        if apple.position.y > 20 then 
            table.remove(apples, num)
        end
    end

    --Spawn more apples if the count is too low
    if #apples < 2 then
        spawn_apples(2)
    end
end


function KeyInput()
    while true do 
        local e, key = os.pullEvent("key")
                local kName = keys.getName(key)
                if kName == "a" then
                    player:move(vector.new(-1.8,0))
                elseif kName == "d" then
                    player:move(vector.new(1.8,0))
                end
    end
end

function GameLoop()
    while true do
        draw()
        apple_code()
        sleep(0.05)
    end   
end
spawn_apples(3)
parallel.waitForAny(GameLoop, KeyInput)
