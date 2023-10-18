local printer = peripheral.find("printer")

function writeText(str)
    local sizeX,sizeY = printer.getPageSize()
    for i=1,string.len(str) do
        local x,y = printer.getCursorPos()
        if x > sizeX then
            printer.setCursorPos(1,y+1)
        else
            character = string.sub(str,i,i)
            printer.write(character)
        end
    end
end

while true do
    print("What would you like to do?")
    print("1. Write to the current page")
    print("2. Change current page title")
    print("3. End current page")
    print("4. Exit the program")
    
    option = io.read()
    
    if printer.getInkLevel() < 1 or printer.getPaperLevel() < 1 then  
        if printer.getInkLevel() < 1 then
            print("Printer is out of ink. Please add more ink to your printer")
        elseif printer.getPaperLevel() < 1 then
            print("Printer is out of paper. Please add more Paper")
        end
    else
        if option == "1" then
            print("Enter what you would like to write:")
            local text = io.read()
            printer.newPage()
            writeText(text)
        elseif option == "2" then
            print("Enter the new page title:")
            local text = io.read()
            printer.setPageTitle(text)
        elseif option == "3" then
            print("Current page ended")
            printer.endPage()
        elseif option == "4" then
            print("Exiting the program...")
            break
        else
            print("Please enter valid input")
        end
    end
    sleep(1)
    term.clear()
end
        
