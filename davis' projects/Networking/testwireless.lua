peripheral.wrap("right").open(69)

function do_dance()
    multishell.launch({}, "rom/programs/turtle/dance.lua")
end

function event_action(input)
    print("event_action called ", input)
    if(input == "dance") then
        do_dance()
    elseif(input == "forward") then
        turtle.forward()
    elseif(input == "dig") then
        turtle.dig()
    elseif(input == "turnLeft") then
        turtle.turnLeft()
    elseif(input == "turnRight") then
        turtle.turnRight()
    elseif(input == "back") then
        turtle.back()
    elseif(input == "up") then
        turtle.up()
    elseif(input == "down") then
        turtle.down()
    end
end

while true do   
    local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if (print(tostring(message)) > 0) then
        event_action(message)
    end
end
