--If using 'customSelector', make sure it uses 'distance' 1 or less times. You can hardcode values in, but distance can only be used once
function getPlayerList(distance, customSelector)
    if distance == nil then distance = 100 end
    if customSelector == nil then customSelector = "@a[distance=..%d]" end
    local sel = string.format(customSelector, distance)
    result = {commands.xp("add", sel, 0)}
    if result[1] == false then return result end
    names = {}
    for k, v in ipairs(result[2]) do
        b,e = string.find(v,"points to ")
        if b ~= nil then
            table.insert(names, string.sub(v, e + 1))
        end
    end
    return names
end

function saveCommandOutput(commandResult, outputFile) 
    outputFile = outputFile or "command_output.json"
    local f = fs.open(outputFile, "w")
    f.write(textutils.serialiseJSON(commandResult))
end

return {getPlayerList = getPlayerList, saveCommandOutput = saveCommandOutput}