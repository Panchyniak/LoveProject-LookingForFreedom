local class = require 'code/lib/middleclass'

Player = class('Player')

function Player:initialize()
    self.x = nativeCanvasWidth/2
    self.y = nativeCanvasHeight/2 + 150

    self.radius = 10

    self.angle = 0

    self.triggerReleased = false
    self.lastShotTime = 0

    self.lastFootstepTime = 0

	self.alive = true
	
	self.movementSpeed = 3
	self.direction = "center"
end

function Player:update(dt)

    --Get table of all connected Joysticks and pick first one:
	--local joystick = love.joystick.getJoysticks()[1]

	if love.keyboard.isDown("right") then --or joystick:isGamepadDown("dpright") then
		self.x = self.x + self.movementSpeed
		self.direction = "right"
	elseif love.keyboard.isDown("left") then -- or joystick:isGamepadDown("dpleft") then
		self.x = self.x - self.movementSpeed
		self.direction = "left"
	end

	if love.keyboard.isDown("down") then --or joystick:isGamepadDown("dpdown") then
		self.y = self.y + self.movementSpeed
		self.direction = "center"
	elseif love.keyboard.isDown("up") then --or joystick:isGamepadDown("dpup") then
		self.y = self.y - self.movementSpeed
		self.direction = "center"
	end

	-- shooting
	if love.keyboard.isDown('space') then
		-- Time to wait before next shot.
        if self.triggerReleased and love.timer.getTime() - self.lastShotTime > 0.01 then
			local gun_x = self.x + 40
            local gun_y = self.y + 32 * math.sin(self.angle) + 10 * math.cos(self.angle)
            local angle = self.angle + math.random() * 0.2 - 0.1
            game.bullets:add(Bullet:new(gun_x, gun_y, angle, 1200))
            self.lastShotTime = love.timer.getTime()

            -- Sound effect.
            sounds.gunshot:setPitch(1.17^(2*math.random() - 1))
            sounds.gunshot:stop()
            sounds.gunshot:play()

        end
        self.triggerReleased = false
    else
        self.triggerReleased = true
    end
end

function Player:draw()

	-- Draw the player and his movement.
	local player = images.playerCenter
	
	if self.direction == "right" then
		player = images.playerRight
	elseif self.direction == "left" then
		player = images.playerLeft
	elseif self.direction == "center" then
		player = images.playerCenter
	else
		player = images.playerCenter
	end

	love.graphics.draw(player, self.x, self.y, 0, 3, 3, 0, 0)
end