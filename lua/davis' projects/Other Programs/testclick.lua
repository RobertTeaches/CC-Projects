function kn(input)
    local names = 
    {
        [1] = "left",
        [2] = "middle",
        [3] = "right"
    }
    return names[input]
end
term.setCursorBlink(true)
local buttons = window.create(term.current(),1,2,3,3,true)
buttons.setCursorPos(1,1)
buttons.blit(" ^ ","fff","787")
buttons.setCursorPos(1,2)
buttons.blit("<V>","fff","888")
buttons.setCursorPos(1,3)
buttons.blit("^0v","fff","777")

function output(b,cx,cy)
    term.setCursorPos(1,6)
    term.clearLine()
    print(("%s click at x:%s, y:%s"):format(kn(b),cx,cy))
end

while true do
    local event, button, x, y = os.pullEvent("mouse_click")
    output(button,x,y)
end
