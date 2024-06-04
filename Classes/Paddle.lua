Paddle = Class{}

function Paddle:init(x, y, height)
    self.x = x
    self.y = y
    self.width = 5
    self.height = height
    self.speed = 0
end

function Paddle:update(dt)
    if self.speed < 0 then
        self.y = math.max(0, self.y + self.speed * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.speed * dt)
    end
end

function Paddle:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end