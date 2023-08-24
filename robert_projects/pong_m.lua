--Game Variables
local players = {
    player1 = {
        position = vector.new(0, 0),
        score = 0
    },
    player2 = {
        position = vector.new(0, 0),
        score = 0
    }
}

local whichPlayer = ""

local playerSize = vector.new(1, 3)


local gameSize = vector.new(52, 19)

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
            recieveChannel = payload[2]
        end
    end
    print(whichPlayer)
    print(recieveChannel)
end

local function key_input()
    while playGame do
        event, key, isHeld = os.pullEvent("key")
        if keys.getName(key) == "w" then
            players[whichPlayer].position.add(0,1)
        elseif keys.getName(key) == "s" then
            players[whichPlayer].position.add(0, -1)
        end
    end
end

local function update_server()
    while playGame do
        sleep(refreshRate)
        modem.transmit(serverChannel, recieveChannel, textutils.serialiseJSON({whichPlayer, players[whichPlayer].position}))
    end
end

local function draw()
    term.clear()
    print(players[whichPlayer].position.tostring())
    print(ballPos.tostring())
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
        local payload = textutils.unserialiseJSON(message)
        if payload then
            players[payload[1]].position = payload[2]
            ballPos = payload[3]
            ballVel = payload[4]
        end
    end
end


connect_server()


parallel.waitForAll(key_input, update_server, recieve_server, update_client)