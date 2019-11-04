local class = require 'code/lib/middleclass'

Director = class('Director')

function Director:initialize()
    self.time = 0
    self.nextSpawnTime = 0
end

function Director:update(dt)
    self.time = self.time + dt

    -- Add a new enemy.
    if self.time > self.nextSpawnTime then
        --local angle = math.random() * 2 * math.pi
        --nativeCanvasWidth/2 + (nativeCanvasWidth + 30) * math.cos(angle)
        local x = math.random(0, love.graphics.getWidth() - 48) -- 48 is the enemy width.
        if x < 0 then
            x = 0
        end

        --nativeCanvasHeight/2 + (nativeCanvasHeight + 30) * math.sin(angle)
        local y = -48 -- 48 is the enemy height.
        local v = 100 + math.random(0, 30)

        game.enemies:add(Enemy:new(x, y, v))

        -- Increase difficulty over time, with some randomness.
        self.nextSpawnTime = self.time + 2.4 * math.exp(-0.024 * self.time) + 0.4 + math.random() * 0.7
    end
end