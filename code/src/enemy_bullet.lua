local class = require 'code/lib/middleclass'

Bullet = class('Bullet')

function Bullet:initialize(x, y, v)
    self.x = x
    self.y = y
    self.angle = a
    self.vx = v * math.cos(a)
    self.vy = v * math.sin(a)
    self.radius = 3
    self.startTime = love.timer.getTime()
    self.speed = v
    self.scaleFactorX = 1
	self.scaleFactorY = 1
	self.originalWidth = 16
	self.originalheight = 16
	self.width = self.scaleFactorX * self.originalWidth
    self.height = self.scaleFactorY * self.originalheight
    self.draw = draw
    self.playerPositionX = game.player.x
    self.playerPositionY = game.player.y
end

function Bullet:update(dt)

    -- movement
    local vx = self.speed * math.cos(self.angle)
    local vy = self.speed * math.sin(self.angle)

    local d = math.sqrt(playerPositionX ^ 2 + playerPositionY ^ 2)
    if d > 10 then
        self.x = self.x + vx * dt
        self.y = self.y - vy * dt
    end

    if love.timer.getTime() - self.startTime > 3 then
        self.to_delete = true
    end
end

function Bullet:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.draw, self.x, self.y, self.angle, self.scaleFactorX, self.scaleFactorY, 8, 8)
end