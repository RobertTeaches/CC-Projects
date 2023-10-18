os.loadAPI("STGPS.lua")

local modem = peripheral.find("modem")
local channel = STGPS.GetGlobalChannel()
local replyChannel = 30
local id = 10
modem.open(replyChannel)



while true do
    local option = io.read()

    if option == "1" then 
        local pos = STGPS.Position(id)
        for k,v in pairs(pos) do
            --print(v)
        end
        modem.transmit(channel, replyChannel, pos) 
    elseif option == "2" then 
        print("What computers position would you like?")
        option = io.read()

        modem.transmit(channel,replyChannel, STGPS.GetComputerPosition(option))

        while true do
            local event, side, c, rc, payload, distance = os.pullEvent("modem_message")
            print(payload.ID)
        end
    end
end

