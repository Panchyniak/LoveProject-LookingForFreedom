local class = require 'code/lib/middleclass'

Bullet = class('Bullet')

function Bullet:initialize(x, y, v)
    self.x = x
    self.y = y
    self.startTime = love.timer.getTime()
    self.speed = v
    self.scaleFactorX = 1
	self.scaleFactorY = 1
	self.originalWidth = 16
	self.originalheight = 16
	self.width = self.scaleFactorX * self.originalWidth
	self.height = self.scaleFactorY * self.originalheight
end

function Bullet:update(dt)

    self.y = self.y - self.speed

    if love.timer.getTime() - self.startTime > 3 then
        self.to_delete = true
    end
end

function Bullet:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.bullet, self.x, self.y, self.angle, self.scaleFactorX, self.scaleFactorY, 8, 8)
end