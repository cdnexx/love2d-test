Game = {}
Game.__index = Game

function Game:new(score) 
    local obj = setmetatable({}, Game)
    obj.score = score
    return obj
end

function Game:getScore()
    return self.score
end

function Game:changeScore(amount)
    self.score = self.score + amount
end

return Game