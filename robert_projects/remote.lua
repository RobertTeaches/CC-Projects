local connectionChannel = ...
local monitor = peripheral.wrap("right")
local modem = peripheral.find("modem")

if not modem then error("No Modem!") end
modem.open(tonumber(connectionChannel))

if monitor then 
    newTab = shell.openTab("monitor", "right", "shell") 
else
    newTab = shell.openTab("shell")
end
shell.switchTab(newTab)

while true do
    local event = {os.pullEvent("modem_message")}
    local key = tonumber(event[5])
    os.queueEvent("key", key, false)
    local key_ = keys.getName(key)
    if string.len(key_) <= 2 then
        os.queueEvent("char", key_)
    elseif key_ == "space" then
        os.queueEvent("char", " ")
    elseif key_ == "slash" then
        os.queueEvent("char", "/")
    elseif key_ == "period" then
        os.queueEvent("char", ".")
    elseif key_ == "comma" then
        os.queueEvent("char", ",")
    elseif key_ == "minus" then
        os.queueEvent("char", "-")
    end
end
