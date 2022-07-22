modem = peripheral.find("modem")
modem.open(1)

function returnHome()
    turtle.turnLeft()
    turtle.turnLeft()
    for i=1,distance do
        turtle.forward()
    end
    for i=1,height do
        turtle.down()
    end
    turtle.turnRight()
    currentPosition = 0
    while currentPosition <  position do
        if turtle.forward() then
            currentPosition = currentPosition + 1
        end
    end
end

print("Waiting for instructions...")

a,b,c,d,msg = os.pullEvent("modem_message")
position = msg*3
a,b,c,d,msg = os.pullEvent("modem_message")
distance = tonumber(msg)
height = 20

turtle.up()

stacks = distance/64
for i=1,stacks do
    turtle.suck(64)
end
turtle.suck(distance%64)
    
turtle.down()

turtle.turnLeft()

for i=1,position do
    turtle.forward()
end

turtle.turnLeft()

for i=1,height do turtle.up() end

redstone.setOutput("bottom",true)

while true do
    a,b,c,d,strmsg = os.pullEvent("modem_message")
    if strmsg == "Start" then
        break
    end
end

for i=1,distance do
    turtle.forward()
    turtle.placeDown()
end

returnHome()
    
