local ROOT_2 = math.sqrt(2)
local char = require 'char'
local console = require 'console'

local GAME_MODES = {
    walking = {
        name = "walking", game_speed = 1
    },
    interaction = {
        name = "walking", game_speed = 0
    },
    reflection = {
        name = "walking", game_speed = 0
    },
    engagement = {
        name = "walking", game_speed = 0
    },
    talking = {
        name = "walking", game_speed = 0
    },
}
local game, map, player, npcs

local function set_game_mode(name)
    if GAME_MODES[name] then
        game.mode  = name
        game.speed = GAME_MODES[name].game_speed
    end
end

function love.load()
    set_game_mode("walking")
    map = require 'map'
    player = char.new(0, 0, 0)
    npcs = {}
end
 
function love.keypressed(key)
    if game.mode == "walking" then
        if key == "space" then
            set_game_mode("interaction")
            console.active = true
        elseif key == "e" then
            set_game_mode("engagement")
        elseif key == "r" then
            set_game_mode("reflection")
        elseif key == "t" then
            set_game_mode("talking")
        end
    elseif game.mode == "interaction" then
        console.keypressed(text)
        if not console.active then
            set_game_mode("walking")
        end
    end
end

function love.textinput(text)
    if game.mode == "interaction" then
        console.keytyped(text)
    end
end

function love.update(dt)
    if game.speed == 0 then return end
    if game.mode == "walking" then
        local dx, dy = 0, 0
        if love.keyboard.isDown("w") then
            dy = dy - 1
        end
        if love.keyboard.isDown("a") then
            dx = dx - 1
        end
        if love.keyboard.isDown("s") then
            dy = dy + 1
        end
        if love.keyboard.isDown("d") then
            dx = dx + 1
        end
        if dx ~= and dy ~= 0 then
            dx = dx / ROOT_2
            dy = dy / ROOT_2
        end
        dx = dx * player:speed() * dt * game.speed
        dy = dy * player:speed() * dt * game.speed
        player:move(dx, dy)
    end
    player:update(dt * game.speed)
    for _, npc in pairs(npcs) do
        npc:update(dt * game.speed)
    end
end

function love.draw()
    map.draw()
    for _, npc in pairs(npcs) do
        npc:draw()
    end
    player:draw()
end
