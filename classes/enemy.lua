Enemy = {}
Enemy.__index = Enemy

function Enemy:new(x, y, size, health)
    local obj = setmetatable({}, Enemy)
    obj.x = x
    obj.y = y
    obj.size = size
    obj.health = health
    obj.death_sound = "assets/break.mp3"
    obj.speed = 100
    return obj
end

function Enemy:playSound()
    local source = love.audio.newSource(self.death_sound, "static")
    source:play()
end

function Enemy:draw()
    if self.health > 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(self.health, self.x + self.size / 2 - 10, self.y + self.size / 2 - 10)
    end
end

function Enemy:checkCollision(bullet)
    if self.health > 0 and bullet.x > self.x and bullet.x < self.x + self.size and bullet.y > self.y and bullet.y <
        self.y + self.size then
        self.health = self.health - bullet.damage
        if self.health <= 0 then
            self:playSound()
        end
        return true
    end

    return false
end

function Enemy:moveTowardsPlayer(player, dt)
    local player_x, player_y = player:getPosition()
    local dx = player_x - self.x
    local dy = player_y - self.y

    local distance = math.sqrt(dx^2 + dy^2)

    if distance > 0 then
        local dirX, dirY = dx/distance, dy/distance
        local step = self.speed * dt
        if distance > step then 
            self.x = self.x + dirX * step
            self.y = self.y + dirY * step
        else
            self.x = player_x
            self.y = player_y
        end
    end
end

return Enemy
