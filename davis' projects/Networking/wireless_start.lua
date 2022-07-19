local target = "stlogo.lua"
local modem = peripheral.find("modem")
local startChannel = 1
modem.open(startChannel)
local isStart = false

function runProgram(transmit_start)
    if transmit_start then
        print("Sending start message")
        modem.transmit(1,1,"start")
        return true
    end

    while true do 
        print("Primed")
        local modem_event, side, channel, replyChannel, message = os.pullEvent("modem_message")
        if message == "start" then
            os.run({},target)
            break
        end
    end
    return true;
end

print("Press 1 to prime and 0 to start")
while true do 
    local key_event, key, is_held = os.pullEvent("key")
    
    if keys.getName(key) == "zero" then
        isStart = true
        break
    elseif keys.getName(key) == "one" then
        print("Priming")
        break
    end
end

runProgram(isStart)
