Weapon = {}
Weapon.__index = Weapon

function Weapon:new(name, fire_rate, bullet_speed, color, damage)
    local obj = setmetatable({}, Weapon)
    obj.name = name
    obj.fire_rate = fire_rate
    obj.bullet_speed = bullet_speed
    obj.color = color
    obj.damage = damage
    obj.sound = "assets/shot.mp3"
    return obj
end

function Weapon:playSound()
    local source = love.audio.newSource(self.sound, "static")
    source:play()
end

function Weapon:shoot(player, mouse_x, mouse_y)
    local bullets = {}
    local player_center_x, player_center_y = player:getCenter()

    local angle = math.atan2(mouse_y - player_center_y, mouse_x - player_center_x)
    local bullet_dx = math.cos(angle) * self.bullet_speed
    local bullet_dy = math.sin(angle) * self.bullet_speed

    self:playSound()
    table.insert(bullets, {
        x = player_center_x,
        y = player_center_y,
        dx = bullet_dx,
        dy = bullet_dy,
        color = self.color,
        damage = self.damage
    })

    return bullets
end

return Weapon