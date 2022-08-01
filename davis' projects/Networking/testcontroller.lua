local modem = peripheral.find("modem")
modem.open(69)
modem.open(70)

function send(payload)
    modem.transmit(69, 70, payload)
end

function kn(input)
    return keys.getName(input)
end

function event_action(input)
    if(kn(input) == "leftCtrl") then
        send("shutdown")
        os.queueEvent("terminate")
    elseif(kn(input) == "w") then
        send("forward")
    elseif(kn(input) == "a") then
        send("turnLeft")
    elseif(kn(input) == "d") then
        send("turnRight")
    elseif(kn(input) == "s") then
        send("back")
    elseif(kn(input) == "space") then
        send("up")
    elseif(kn(input) == "leftShift") then
        send("down")
    elseif(kn(input) == "left") then
        send("dig")
    elseif(kn(input) == "up") then
        send("digUp")
    elseif(kn(input) == "down") then
        send("digDown")
    end
end    

function debugformatprint(input)
    return print(kn(input))
end

while true do
    local event, key, is_held = os.pullEvent("key")
    if(debugformatprint(key) > 0) then
        event_action(key)
    end
end
