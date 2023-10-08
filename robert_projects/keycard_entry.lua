
keys = {}
drive = peripheral.wrap("front")
keycardPrinter = peripheral.wrap("back")
speaker = peripheral.find("speaker")

--Peripheral.find gives a touple of all peripherals with that type, in order based on the side connected
--If multiple are connected to one side via a hub, it will go in order of name

function keyExists(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function generateKeycard()
    if not keycardPrinter.isDiskPresent() then
        print("Insert Blank Disk Into Keycard Printer")
        return
    end
    local key = math.random(100000, 999999)
    while keyExists(keys, key) do
        key = math.random(100000, 999999)
    end
    table.insert(keys, key)
    keycardPrinter.setDiskLabel(tostring(key))
    saveKeys()
    return key
end

function saveKeys()
    local file = fs.open("keys.txt", "w")
    for _, key in pairs(keys) do
        file.writeLine(key)
    end
    file.close()
end

function readKeys()
    local file = fs.open("keys.txt", "r")
    if file then
        for line in file.readLine do
            table.insert(keys, tonumber(line))
        end
        file.close()
    end
end


function checkCard(cardNumber)
    if keyExists(keys, cardNumber) then
        return true
    else
        return false
    end
end

function readCard()
    if drive.isDiskPresent() then
        return tonumber(drive.getDiskLabel())
    end
end


function runStaffMenu()
    while true do
        term.clear()
        term.setCursorPos(1,1)
        print("Staff Menu")
        print("1. Generate Keycard")
        print("2. Manual Entry")
        local input = read()
        if input == "1" then
            local key = generateKeycard()
            if key then
                print("Generated Keycard: " .. key)
                keycardPrinter.ejectDisk()
            end
            sleep(2)
        elseif input == "2" then
            print("Enter Keycard Number")
            local key = tonumber(read())
            if checkCard(key) then
                redstone.setOutput("right", true)
                sleep(3)
                redstone.setOutput("right", false)
            else
                if speaker then
                    speaker.playSound("minecraft:entity.villager.no")
                end
            end
        end
    end
end

function runCardCheck()
    while true do
        sleep(.1)
        local cardNumber = readCard()
        if cardNumber then
            if checkCard(cardNumber) then
                redstone.setOutput("right", true)
                drive.ejectDisk()
                sleep(5)
                redstone.setOutput("right", false)
            else
                if speaker then
                    speaker.playSound("minecraft:entity.villager.no")
                end
            end
        end
    end
end

readKeys()

parallel.waitForAll(runStaffMenu, runCardCheck)