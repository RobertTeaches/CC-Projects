

--Game Variables
local gameSize = vector.new(52, 19)
local players = {
    player1 = {
        position = vector.new(3, 0),
        score = 0
    },
    player2 = {
        position = vector.new(49, 0),
        score = 0
    }
}

local whichPlayer = ""
local otherPlayer = ""

local playerSize = vector.new(1, 3)



local ballPos = vector.new(gameSize.x / 2, gameSize.y / 2)
local ballVel = vector.new(0.1, 0.1)

local playGame = true

--Networking
local serverChannel = 112

local connecingChannel = math.random(65000)

local refreshRate = 1/5

local recieveChannel = -1

local modem = peripheral.find("modem")

modem.open(connecingChannel)

local function connect_server()
    modem.transmit(serverChannel, connecingChannel, "connect")
    while whichPlayer == "" do
        repeat
            event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        until channel == connecingChannel
        local payload = textutils.unserialiseJSON(message)
        if payload then 
            whichPlayer = payload[1]
            if whichPlayer == "player1" then otherPlayer = "player2" else otherPlayer = "player1" end
            recieveChannel = payload[2]
        end
    end
    print(whichPlayer)
    modem.open(recieveChannel)
end

local function key_input()
    while playGame do
        event, key, isHeld = os.pullEvent("key")
        if keys.getName(key) == "w" then
            players[whichPlayer].position = players[whichPlayer].position - vector.new(0,1)
        elseif keys.getName(key) == "s" then
            players[whichPlayer].position = players[whichPlayer].position + vector.new(0,1)
        end
    end
end

local function update_server()
    while playGame do
        sleep(refreshRate)
        --print(players[whichPlayer].position)
        modem.transmit(serverChannel, recieveChannel, textutils.serialiseJSON({whichPlayer, players[whichPlayer].position}))
    end
end

local function draw()
    term.setBackgroundColor(colors.black)
    term.clear()
    --Draw player1
    paintutils.drawLine(players["player1"].position.x, players["player1"].position.y, players["player1"].position.x, players["player1"].position.y + playerSize.y, colors.blue)
    --Draw player2
    paintutils.drawLine(players["player2"].position.x, players["player2"].position.y, players["player2"].position.x, players["player2"].position.y + playerSize.y, colors.red)

    --Draw ball
    paintutils.drawPixel(ballPos.x, ballPos.y, colors.white)
end

local function update_client()
    while playGame do
        draw()
        sleep(1/10)
    end
end

local function recieve_server()
    while playGame do
        repeat
            event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        until channel == recieveChannel
        --print(message)
        local payload = textutils.unserialiseJSON(message)
        if payload then
            players[otherPlayer].position = vector.new(payload[1].x, payload[1].y)
            ballPos = vector.new(payload[2].x, payload[2].y)
            ballVel = vector.new(payload[3].x, payload[3].y)
            --print(ballPos)
            --print("Player 1: "..players["player1"].position.y.." "..players["player2"].position.y)
        end
    end
end


connect_server()


parallel.waitForAll(key_input, update_server, recieve_server, update_client)