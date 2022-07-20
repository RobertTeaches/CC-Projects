--Global Variables
GlobalChannel = 100
--computer = {}
users = {}
userCount = 0

--Local Variables
local modem = peripheral.find("modem")
modem.open(100)

--Local Functions

function GetComputerPosition(id)
    local computer = {}
    computer["ID"] = id
    computer["action"] = "getComputerPosition"
    return computer
end

--Global Functions

function GetGlobalChannel()
    return GlobalChannel
end

function Position(id)
    local computer = {}
    x,y,z = gps.locate()
    computer["x"] = x
    computer["y"] = y
    computer["z"] = z
    computer["ID"] = id
    computer["action"] = "receiveMyPosition"
    return computer
end

function StartGlobalGPS()
    --print("Starting")
    while true do 
        --print("Waiting for a message")
        local event, side, channel, replyChannel, payload, distance = os.pullEvent("modem_message")
        
        if payload.action == "receiveMyPosition" then
            --print("Added user to the table")
            users[payload.ID] = payload
            userCount = userCount+1
        elseif payload.action == "getComputerPosition" then
            print("Getting computer ".. payload.ID .. "'s location")
            target = {}
            for k,v in pairs(users) do
                if tonumber(payload.ID) == v.ID then
                    target = users[k]
                end
            end
            sleep(2)
            print("Sending user " .. target.ID .. "'s position to " .. replyChannel)
            modem.transmit(replyChannel,GlobalChannel,target)
        end

        print("Current User Count: " .. userCount)
        for k,v in pairs(users) do
            print("User " .. v.ID .. " - X: " .. v.x .. " Y: " .. v.y .. " Z: " .. v.z)
        end
    end
end
