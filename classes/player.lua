Weapon = require("classes/weapon")

Player = {}
Player.__index = Player

function Player:new(x, y, size, speed, weapon)
    local obj = setmetatable({}, Player)
    obj.x = x
    obj.y = y
    obj.size = size
    obj.speed = speed
    obj.weapon = weapon
    return obj
end

function Player:move(dt, win_width, win_height)
    if love.keyboard.isDown('w') and self.y > 0 then
        self.y = self.y - (self.speed * dt)
    end
    if love.keyboard.isDown('a') and self.x > 0 then
        self.x = self.x - (self.speed * dt)
    end
    if love.keyboard.isDown('s') and self.y < win_height - self.size then
        self.y = self.y + (self.speed * dt)
    end
    if love.keyboard.isDown('d') and self.x < win_width - self.size then
        self.x = self.x + (self.speed * dt)
    end
end

function Player:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
end

function Player:getCenter()
    return self.x + self.size / 2, self.y + self.size / 2
end

function Player:setWeapon(weapon)
    self.weapon = weapon
end

function Player:getPosition()
    return self.x, self.y
end

return Player