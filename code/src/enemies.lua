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
    --self.bullets = Container:new()
end

function Enemy:update(dt)

    -- update angle to player
    --[[ local player_dx = self.playerPositionX - self.x
    local player_dy = self.playerPositionY - self.y

    -- movement
    local vx = self.speed * math.cos(self.angle)
    local vy = self.speed * math.sin(self.angle)

    local d = math.sqrt(player_dx^2 + player_dy^2)
    if d > 10 then
        self.x = self.x + vx * dt
        self.y = self.y + vy * dt
    end ]]

    -- Destroy the enemy if gets out of the canvas.
    if self.y > 700 or self.x > 600 or self.x < -100 then
        self.to_delete = true
    end

    if self.direction == 1 then
        self.x = self.x + self.speed * dt
    elseif  self.direction == 2 then
        self.x = self.x - self.speed * dt
    end

    self.y = self.y + (self.speed * dt)

    -- Check bullet and enemy collision.
    for i=1, #game.bullets.contents do
        local bullet = game.bullets.contents[i]
        
        if CheckCollision(bullet.x, bullet.y, bullet.width, bullet.height, self.x - self.width, self.y - self.height, self.width, self.height) then
            self.healthPoints = self.healthPoints - 1
            bullet.to_delete = true
        end

    end

    if self.healthPoints <= 0 then
        -- Increasing the score.
        game.score = game.score + 1
        -- Removing the enemy that don't have health anymore.
        self.to_delete = true
    end

    if math.random(0, 100) > 98 then -- 2% of shoot.
		-- Time to wait before next shot.
            local gun_x = self.x - self.width + self.width / 2
            local gun_y = self.y - 2
            game.bullets:add(Enemy_Bullet:new(gun_x, gun_y, 5))

            -- Sound effect.
            sounds.gunshot:setPitch(1.17^(2*math.random() - 1))
            sounds.gunshot:stop()
            sounds.gunshot:play()
    else

    end

end

function Enemy:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.enemySkull, self.x, self.y, 0, self.scaleFactorX, self.scaleFactorY, 16, 22)
end