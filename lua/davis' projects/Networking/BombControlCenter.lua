modem = peripheral.find("modem")
modem.open(1)

function isFull()
    if turtle.getItemCount(16) > 0 then
        return true
    else
        return false
    end
end

function storeItems()
    for i=2,16 do
        name = turtle.getItemDetail(i).name
        turtle.select(i)
        if name == "minecraft:tnt" then
            turtle.dropUp()
        else
            turtle.dropDown()
        end
    end
    turtle.select(1)
end

print("How far would you like your bombers to go?")
distance = tonumber(io.read())
print("How many turtles would you like to use?")
quantity = tonumber(io.read())

for i=1,quantity do
	turtle.select(1)
    turtle.place()
    peripheral.call("front","turnOn")
    sleep(1)
    modem.transmit(1,1,(quantity-(i-1)))
    modem.transmit(1,1,distance)
    sleep(2)
end

sleep(9.5)

modem.transmit(1,1,"Start")

returnCount = 0

while returnCount ~= quantity do
    if turtle.detect() then
        turtle.dig()
        returnCount = returnCount + 1
    end
    if isFull() then
        storeItems()
    end
end

