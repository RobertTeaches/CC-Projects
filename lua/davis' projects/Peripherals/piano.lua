local speaker = peripheral.find("speaker")


function piano(num)
    speaker.playNote("harp",2,num)
end


while true do
    local event, key = os.pullEvent("key")
    key = keys.getName(key)
    if key == "a" then
        print("A")
        piano(3)
    elseif key == "w" then
        print("A#")
        piano(4)
    elseif key == "s" then
        print("B")
        piano(5)
    elseif key == "d" then
        print("C")
        piano(6)
    elseif key == "r" then
        print("C#")
        piano(7)
    elseif key == "f" then
        print("D")
        piano(8)
    elseif key == "t" then
        print("D#")
        piano(9) 
    elseif key == "g" then
        print("E")
        piano(10)
    elseif key == "h" then
        print("F")
        piano(11)
    elseif key == "u" then
        print("F#")
        piano(12)
    elseif key == "j" then
        print("G")
        piano(13)
    elseif key == "i" then
        print("G#")
        piano(14)
    elseif key == "k" then
        print("A")
        piano(15)
    end
end
