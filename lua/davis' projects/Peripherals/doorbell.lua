local speaker = peripheral.find("speaker")

while true do
    if redstone.getInput("right") == true then
        speaker.playSound("minecraft:block.anvil.land",3)
        sleep(3)
    end
end
