Game = require("classes/game")
Player = require("classes/player")
Enemy = require("classes/enemy")
Weapon = require("classes/weapon")

function love.load()
    win_width = 1280
    win_height = 720

    font = love.graphics.newFont(16)
    love.graphics.setFont(font)

    -- For testing
    love.audio.setVolume(0.05)

    background_music = love.audio.newSource("assets/bg_loop.mp3", "stream")
    background_music:setLooping(true)
    background_music:setVolume(0.05)
    background_music:play()

    weapons = {
        -- Weapon(NAME, FIRE_RATE, BULLET_SPEED, BULLET_COLOR, DAMAGE)
        Weapon:new("AR", 0.1, 1000, {0, 1, 1}, 5),
        Weapon:new("Pistol", 0.5, 700, {0, 1, 0}, 4),
        Weapon:new("SMG", 0.025, 1000, {1, 1, 0}, 1)
    }

    current_weapon = 1

    player = Player:new(400, 400, 20, 500, weapons[1], 100)
    game = Game:new(0)
    score_display = ""

    shooting = false
    bullets = {}
    shoot_timer = 0

    spawn_timer = 0
    spawn_rate = 20
    enemies = {}

    math.randomseed(os.time())

    love.window.setTitle("Zerg Rush!")
    love.window.setMode(win_width, win_height)
end

function love.update(dt)
    score_display = "Score: " .. game:getScore()

    player:move(dt, win_width, win_height)

    spawn_timer = spawn_timer - dt
    if spawn_timer <= 0 then
        local enemy_size = math.random(30, 60)
        local enemy = Enemy:new(math.random(win_width-enemy_size), math.random(win_height-enemy_size), enemy_size, math.floor(math.random(1, 5)*(enemy_size/15)))
        table.insert(enemies, enemy)
        spawn_timer = spawn_rate
    end

    if shooting then
        shoot_timer = shoot_timer - dt
        if shoot_timer <= 0 then
            local mouse_x, mouse_y = love.mouse.getPosition()
            local new_bullets = player.weapon:shoot(player, mouse_x, mouse_y)
            for _, bullet in ipairs(new_bullets) do
                table.insert(bullets, bullet)
            end
            shoot_timer = player.weapon.fire_rate
        end
    end

    for _, enemy in ipairs(enemies) do 
        enemy:moveTowardsPlayer(player, dt)
        player:checkCollision(enemy)
    end

    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet.x = bullet.x + bullet.dx * dt
        bullet.y = bullet.y + bullet.dy * dt

        -- Verify collitions
        for _, enemy in ipairs(enemies) do
            if enemy:checkCollision(bullet, game) then
                table.remove(bullets, i)
            end
        end

        -- Delete bullet
        if bullet.x < 0 or bullet.x > win_width or bullet.y < 0 or bullet.y > win_height then
            table.remove(bullets, i)
        end
    end
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        shooting = true
    end
    if button == 2 then
        if current_weapon < #weapons then
            current_weapon = current_weapon + 1
            player:setWeapon(weapons[current_weapon])
        else
            current_weapon = 1
            player:setWeapon(weapons[current_weapon])
        end
    end
end

function love.mousereleased(x, y, button, isotuch)
    if button == 1 then
        shooting = false
        shoot_timer = 0
    end
end

function love.draw()
    
    player:draw()



    -- Draw bullets
    for b, bullet in ipairs(bullets) do
        love.graphics.setColor(bullet.color)
        love.graphics.circle('fill', bullet.x, bullet.y, 5)
    end

    -- Draw enemies
    for _, enemy in ipairs(enemies) do
        enemy:draw()
    end

    love.graphics.setColor(1,1,1)
    love.graphics.print("Weapon: " .. weapons[current_weapon].name, 10, 10)
    love.graphics.print(score_display, win_width - (font:getWidth(score_display)) - 10, 10)
    
end