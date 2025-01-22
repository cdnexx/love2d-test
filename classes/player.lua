Weapon = require("classes/weapon")

Player = {}
Player.__index = Player

function Player:new(x, y, size, speed, weapon, health)
    local obj = setmetatable({}, Player)
    obj.x = x
    obj.y = y
    obj.size = size
    obj.speed = speed
    obj.weapon = weapon
    obj.health = health
    obj.shape = "circle"
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
    if self.shape == "square" then
        love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
    elseif self.shape =="circle" then
        love.graphics.circle('fill', self.x, self.y, self.size/2)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self.health, self.x, self.y)
end

function Player:getCenter()
    if self.shape == "square" then
        return self.x + self.size / 2, self.y + self.size / 2
    elseif self.shape == "circle" then
        return self.x, self.y
    end
end

function Player:getHealth()
    return self.health
end

function Player:changeHealth(amount) 
    self.health = self.health + amount
end

function Player:setWeapon(weapon)
    self.weapon = weapon
end

function Player:getPosition()
    return self.x, self.y
end

function Player:checkShapeCollision(entity)
    local entityX, entityY = entity:getPosition()
    local entitySize = entity:getSize()
    if entity:getShape() == "rectangle" then
        local closestX = math.max(entityX, math.min(self.x, entityX + entitySize))
        local closestY = math.max(entityY, math.min(self.y, entityY + entitySize))

        local dx, dy = self.x - closestX, self.y - closestY
        local distance = math.sqrt(dx^2 + dy^2)

        return distance <= self.size
    elseif entity:getShape() == "circle" then
        return false
    end
end

function Player:checkCollision(entity)
    if self:checkShapeCollision(entity) then
        self:changeHealth(-1)
    end
end

return Player