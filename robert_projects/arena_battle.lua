local arenaLocation = {x = "~", y = "~", z = "0"}
--Must concat "minecraft:" in front of key
local playerLoadout = {
    diamond_sword = 1,
    diamond_axe = 1,
    shield = 1,
    bow = 1,
    arrow = 64,
    diamond_helmet = 1,
    diamond_chestplate = 1,
    diamond_leggings = 1,
    diamond_boots = 1,
    golden_apple = 2,
    steak = 2
}

local team = "ArenaBattle"
local playerDistance = 10

local function assignTeam()
    commands.team("add", team)
    commands.team("join", team, string.format("@a[distance=..%d]", playerDistance))
end

local function movePlayers()

    local r = {commands.spreadplayers(arenaLocation.x, arenaLocation.y, 1, 25, false,"@a[team=" .. team .. "]")}
    local f = fs.open("errorout.json", "a")
    f.write(textutils.serialiseJSON(r))
    f.close()
end

local function startGame()
    for item,amount in pairs(playerLoadout) do
        commands.give("@a[team=" .. team .. "]", "minecraft:" .. item, amount)
    end
end

assignTeam()
movePlayers()
startGame()

