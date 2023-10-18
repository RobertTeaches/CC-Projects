local arenaSize = 10
local arenaHeight = 16
local arenaWalls = "minecraft:stone"
local arenaFloor = "minecraft:snow_block"
local playerTool = "minecraft:diamond_shovel"
local gameDuration = 10
local center = {}
center.x , center.y, center.z = commands.getBlockPosition()
--Can be modified to fit a different server style, or turned into a list of players for
--i.e playerSelector = "RobertTeaches, Notch, Dinnerbone"
--i.e playerSelector = "@a[team=red]"
local playerSelector = "@a[distance=..15]"

--Utility function to set up the game
function build_arena()
    --Fill the floor
    commands.fill(center.x - arenaSize, center.y + arenaHeight, center.z - arenaSize, center.x + arenaSize, center.y + arenaHeight, center.z + arenaSize, arenaFloor)
    --Build the walls
    --Left Wall
    commands.fill(center.x - arenaSize, center.y + arenaHeight, center.z - arenaSize, 
                  center.x - arenaSize, center.y + arenaHeight + 2, center.z + arenaSize, 
                  arenaWalls)
    --Right Wall
    commands.fill(center.x + arenaSize, center.y + arenaHeight, center.z - arenaSize, 
                  center.x + arenaSize, center.y + arenaHeight + 2, center.z + arenaSize, 
                  arenaWalls)
    --Front Wall
    commands.fill(center.x - arenaSize, center.y + arenaHeight, center.z - arenaSize, 
                  center.x + arenaSize, center.y + arenaHeight + 2, center.z - arenaSize, 
                  arenaWalls)
    --Back Wall
    commands.fill(center.x - arenaSize, center.y + arenaHeight, center.z + arenaSize, 
                  center.x + arenaSize, center.y + arenaHeight + 2, center.z + arenaSize, 
                  arenaWalls)
end


function place_players()
    --Before doing anything, assign all players in selector to the 'spleef' team`
    commands.team("add", "spleef")
    commands.team("join", "spleef", playerSelector)
    --Set playerSelector to search for players on the spleef team
    playerSelector = "@a[team=spleef]"
    --Give players a shovel
    commands.give(playerSelector, playerTool)

    --Place players on the floor (x, y, distBetweenPlayers, distFromCenter, careAboutTeams, target)
    commands.spreadplayers(center.x, center.z, 3, arenaSize - 1, false, playerSelector)
    -- ({commands.spreadPlayers(string.format("%d, %d",pos.x, pos.z), 3, arenaSize - 1, false, playerSelector)})
end

function begin_game()
    commands.say("Starting game...")
    commands.gamemode("adventure", playerSelector)
    for i = 1,5 do
        commands.say(6 - i)
        sleep(1)
    end
    commands.say("Go!")
    commands.gamemode("survival", playerSelector)

end

function clear_arena()
    pos = center
    commands.fill(pos.x - arenaSize, pos.y + arenaHeight, pos.z - arenaSize, 
                  pos.x + arenaSize, pos.y + arenaHeight + 2, pos.z + arenaSize, 
                  "minecraft:air")
end

function tell_winners()
    pos = {}
    pos.x = center.x - arenaSize
    pos.z = center.z - arenaSize
    pos.y = center.y + arenaHeight + 1
    local sel = string.format("@a[x=%d,y=%d,z=%d,distance=..%d]", pos.x, pos.y, pos.z, arenaSize * 2)

    commands.tell(sel, "You win!")
end

--Game code:
--1 Set up arena correctly
--2 Place players and give proper tools 
--3 Start game with countdown 
--4 Wait for game duration to complete
--5 Determine Winner(s)
--6 End game and reset arena

build_arena()
place_players()
begin_game()
--Running Game
sleep(gameDuration/2)
commands.say("Halfway there!")
sleep(gameDuration/2)
--Game has Finished
commands.say("Game over!")
tell_winners()
--This allows the winners code to run fully before teleporting players back to the start
sleep(1)
commands.gamemode("creative", playerSelector)
commands.clear(playerSelector)
commands.tp(playerSelector, "~ ~ ~3")
clear_arena()
err.close()