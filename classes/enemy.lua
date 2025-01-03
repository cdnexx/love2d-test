Enemy = {}
Enemy.__index = Enemy

function Enemy:new(x, y, size, health)
    local obj = setmetatable({}, Enemy)
    obj.x = x
    obj.y = y
    obj.size = size
    obj.health = health
    obj.death_sound = "assets/break.mp3"
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

return Enemy
