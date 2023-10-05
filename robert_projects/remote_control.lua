local modem = peripheral.find("modem")
local connectionChannel = ...
connectionChannel = tonumber(connectionChannel)
modem.open(connectionChannel)

while true do
  local event = {os.pullEvent("key")}
  modem.transmit(connectionChannel, connectionChannel, event[2])
end  
  
