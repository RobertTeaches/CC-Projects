--This server is responsible for recieving messages from game computers, doing server calculations, and then
--sending messages back to game computers for them to distBetweenPlayers

--Game variables
local player1 = {
    position = vector.new(0, 0),
    score = 0
}
local player2 = {
    position = vector.new(0, 0),
    score = 0
}

local playerSize = vector.new(1, 3)


local gameSize = vector.new(52, 19)

local ballPos = vector.new(gameSize.x / 2, gameSize.y / 2)
local ballVel = vector.new(1, 1)

local playGame = true
--Networking variables
local refresh_rate = 1 / 10

local recievingChannel = 112

local player1Channel = 221
local player2Channel = 222

local modem = peripheral.find("modem")

modem.open(recievingChannel)


--For our client's to connect to our server, they must know which channel to send messages to
--For simplicity, we will hardcode these values in, but this is insecure and easily hackable
local function connect_players()
    print("Waiting for Player 1...")
    local message = ""
    while message ~= "connect" do
        repeat
            event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        until channel == recievingChannel
    end
    --We received the connect message from a computer
    modem.transmit(replyChannel, recievingChannel, textutils.serialiseJSON({ "player1", player1Channel }))
    message = ""
    print("Player 1 Connected")
    while message ~= "connect" do
        repeat
            event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        until channel == recievingChannel
    end
    modem.transmit(replyChannel, recievingChannel, textutils.serialiseJSON({ "player2", player2Channel }))

    return true
end

local function update_clients()
    modem.transmit(player1Channel, recievingChannel, textutils.serialiseJSON({ player2.position, ballPos, ballVel }))
    modem.transmit(player2Channel, recievingChannel, textutils.serialiseJSON({ player1.position, ballPos, ballVel }))
end

local function recieve_client()
    while playGame do
        --Payload will be in JSON array, with
        -- 1. being player sending
        -- 2. being playerPos
        repeat
            event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        until channel == recievingChannel
        print(message)
        local payload = textutils.unserialiseJSON(message)
        if payload then
            if payload[1] == "player1" then
                player1.position = vector.new(payload[2].x, payload[2].y)
                print("Player 1: "..player1.position.y)
            else
                player2.position = vector.new(payload[2].x, payload[2].y)
                print("Player 2: "..player2.position.y)
            end
        end
    end
end

local function reset_ball()
        ballVel = vector.new(math.random(1) - 0.5, math.random(1) - 0.5)
        ballPos = vector.new(gameSize.x / 2, gameSize.y / 2)
end

local function ball_collision()
    if ballPos.x > gameSize.x or ballPos.x < 1 then
        reset_ball()
    end
    if ballPos.y > gameSize.y or ballPos.y < 1 then
        ballVel.y = -ballVel.y
    end
    if ballPos.x == player1.position.x and ballPos.y >= player1.position.y and ballPos.y <= player1.position.y + playerSize.y then
        ballVel.x = -ballVel.x * 1.1
    end
    if ballPos.x == player2.position.x and ballPos.y >= player2.position.y and ballPos.y <= player2.position.y + playerSize.y then
        ballVel.x = -ballVel.x * 1.1
    end
end

local function game_logic()
    while playGame do
        sleep(refresh_rate)
        update_clients()
        ballPos = ballPos + ballVel
        ball_collision()
    end
end

parallel.waitForAny(connect_players, recieve_client)

parallel.waitForAll(game_logic, recieve_client)
