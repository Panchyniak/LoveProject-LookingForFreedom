local class = require 'code/lib/middleclass'

Enemy_Bullet = class('Enemy_Bullet')

function Enemy_Bullet:initialize(x, y, v)
    self.x = x
    self.y = y
    --self.angle = a
    --self.vx = v * math.cos(a)
    --self.vy = v * math.sin(a)
    --self.radius = 3
    self.startTime = love.timer.getTime()
    self.speed = v
    self.scaleFactorX = 1
	self.scaleFactorY = 1
	self.originalWidth = 16
	self.originalheight = 16
	self.width = self.scaleFactorX * self.originalWidth
    self.height = self.scaleFactorY * self.originalheight
    self.image = images.bullet
    self.playerPositionX = game.player.x
    self.playerPositionY = game.player.y
end

function Enemy_Bullet:update(dt)

    self.y = self.y + self.speed

    if love.timer.getTime() - self.startTime > 3 then
        self.to_delete = true
    end

end

function Enemy_Bullet:draw()
    love.graphics.setColor(255, 0, 0)
    love.graphics.draw(self.image, self.x, self.y, 0, self.scaleFactorX, self.scaleFactorY, 8, 8)
end