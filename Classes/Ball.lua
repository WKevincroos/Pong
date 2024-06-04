Ball = Class{}

function Ball:init(x, y)
    self.x = x
    self.y = y

    self.velX = math.random(2) == 1  and 100 or -100
    self.velY = math.random(-50, 50) * 1.5
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT / 2

    self.velX = math.random(2) == 1  and 100 or -100
    self.velY = math.random(-50, 50) * 1.5
end

function Ball:update(dt)
    self.x = self.x + self.velX * dt
    self.y = self.y + self.velY * dt
end

function Ball:draw()
    love.graphics.circle('fill', self.x, self.y, 3)
end

function Ball:collides(obj)
    -- x1 > x2 + width e y1 < y2 + width e x1 + width < x2 e y1 + width > y2
    if self.x  <= obj.x + obj.width and self.x + 3 >= obj.x and self.y <= obj.y + obj.height and self.y + 3 >= obj.y then
        return true
    end
    return false
end