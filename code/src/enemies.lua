local class = require 'code/lib/middleclass'

require 'code/src/collision'

Enemy = class('Enemy')

function Enemy:initialize(x, y, v)
    self.x = x
    self.y = y
    self.angle = 0
    self.speed = v
    self.healthPoints = math.random(0, 5)
    self.playerPositionX = game.player.x
    self.playerPositionY = game.player.y
    self.direction = math.random(0, 2)
    self.scaleFactorX = 3
	self.scaleFactorY = 3
	self.originalWidth = 16 
    self.originalheight = 16
    self.width = self.scaleFactorX * self.originalWidth
    self.height = self.scaleFactorY * self.originalheight
    self.yLimit = math.random(1, 5)
    self.isGoingToRightSide = true
    self.isGoingToLeftSide = true
end

function Enemy:update(dt)

    -- Destroy the enemy if gets out of the canvas.
    if self.y > 700 or self.x > 600 or self.x < -100 then
        self.to_delete = true
    end

    -- Begin enemy movement logic.
    if self.yLimit == 1 then
        if self.y > self.height * self.yLimit then
            if ((self.x <= nativeCanvasWidth / 2 and self.isGoingToRightSide == true) or (self.isGoingToLeftSide == false)) then
                self.x = self.x + self.speed * dt
                self.isGoingToLeftSide = false
            elseif ((self.y >= nativeCanvasWidth / 2 and self.isGoingToLeftSide == true) or (self.isGoingToRightSide == false)) then
                self.x = self.x - self.speed * dt
                self.isGoingToRightSide = false
            end
        end
    elseif self.yLimit == 2 then
        if self.y > self.height * self.yLimit then
            if ((self.x <= nativeCanvasWidth / 2 and self.isGoingToRightSide == true) or (self.isGoingToLeftSide == false)) then
                self.x = self.x + self.speed * dt
                self.isGoingToLeftSide = false
            elseif ((self.y >= nativeCanvasWidth / 2 and self.isGoingToLeftSide == true) or (self.isGoingToRightSide == false)) then
                self.x = self.x - self.speed * dt
                self.isGoingToRightSide = false
            end
        end
    elseif self.yLimit == 3 then
        if self.y > self.height * self.yLimit then
            if ((self.x <= nativeCanvasWidth / 2 and self.isGoingToRightSide == true) or (self.isGoingToLeftSide == false)) then
                self.x = self.x + self.speed * dt
                self.isGoingToLeftSide = false
            elseif ((self.y >= nativeCanvasWidth / 2 and self.isGoingToLeftSide == true) or (self.isGoingToRightSide == false)) then
                self.x = self.x - self.speed * dt
                self.isGoingToRightSide = false
            end
        end
    elseif self.yLimit == 4 then
        if self.y > self.height * self.yLimit then
            if ((self.x <= nativeCanvasWidth / 2 and self.isGoingToRightSide == true) or (self.isGoingToLeftSide == false)) then
                self.x = self.x + self.speed * dt
                self.isGoingToLeftSide = false
            elseif ((self.y >= nativeCanvasWidth / 2 and self.isGoingToLeftSide == true) or (self.isGoingToRightSide == false)) then
                self.x = self.x - self.speed * dt
                self.isGoingToRightSide = false
            end
        end
    elseif self.yLimit == 5 then
        if self.y > self.height * self.yLimit then
            if ((self.x <= nativeCanvasWidth / 2 and self.isGoingToRightSide == true) or (self.isGoingToLeftSide == false)) then
                self.x = self.x + self.speed * dt
                self.isGoingToLeftSide = false
            elseif ((self.y >= nativeCanvasWidth / 2 and self.isGoingToLeftSide == true) or (self.isGoingToRightSide == false)) then
                self.x = self.x - self.speed * dt
                self.isGoingToRightSide = false
            end
        end
    end

    self.y = self.y + (self.speed * dt)
    -- End enemy movement logic.

    -- Check bullet and enemy collision.
    for i=1, #game.bullets.contents do
        local bullet = game.bullets.contents[i]
        if CheckCollision(bullet.x, bullet.y, bullet.width, bullet.height, self.x - self.width, self.y - self.height, self.width, self.height) then
            self.healthPoints = self.healthPoints - 1
            bullet.to_delete = true
            if self.healthPoints <= 0 then
                -- Increasing the score.
                game.score = game.score + 1
                -- Removing the enemy that don't have health anymore.
                self.to_delete = true
            end
        end
    end

    if math.random(0, 100) > 98 then -- 2% of shoot.
        local gun_x = self.x - self.width + self.width / 2
        local gun_y = self.y - 2
        game.enemyBullets:add(EnemyBullets:new(gun_x, gun_y, 5))

        -- Sound effect.
        sounds.gunshot:setPitch(1.17^(2*math.random() - 1))
        sounds.gunshot:stop()
        sounds.gunshot:play()
    end

end

function Enemy:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.enemySkull, self.x, self.y, 0, self.scaleFactorX, self.scaleFactorY, 16, 22)
end