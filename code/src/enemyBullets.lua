local class = require 'code/lib/middleclass'

EnemyBullets = class('EnemyBullets')

function EnemyBullets:initialize(x, y, v)
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
    self.playerPositionX = game.player.x
    self.playerPositionY = game.player.y
end

function EnemyBullets:update(dt)

    self.y = self.y + self.speed

    if love.timer.getTime() - self.startTime > 3 then
        self.to_delete = true
    end

end

function EnemyBullets:draw()
    love.graphics.setColor(255, 0, 0)
    love.graphics.draw(images.bullet, self.x, self.y, 0, self.scaleFactorX, self.scaleFactorY, 8, 8)
end