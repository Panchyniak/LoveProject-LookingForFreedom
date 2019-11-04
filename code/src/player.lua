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
	
	self.movementSpeed = 200
	self.direction = "center"

	self.scaleFactorX = 3
	self.scaleFactorY = 3

	--Image has 16 pixels x 16 pixels
	self.originalWidth = 16 
	self.originalheight = 16

	self.width = self.scaleFactorX * self.originalWidth
	self.height = self.scaleFactorY * self.originalheight
	
end

function Player:update(dt)

    --Get table of all connected Joysticks and pick first one:
	--local joystick = love.joystick.getJoysticks()[1]

	--[[ if love.keyboard.isDown("up") and love.keyboard.isDown("right") then
		if self.x + self.width < nativeCanvasWidth and self.y > 0 then
			self.x = self.x + self.movementSpeed * dt
			self.y = self.y - self.movementSpeed * dt
			self.direction = "right"
		elseif self.x + self.width < nativeCanvasWidth and self.y <= 0 then
			self.x = self.x + self.movementSpeed * dt
			self.direction = "right"
		elseif self.x + self.width >= nativeCanvasWidth and self.y > 0 then
			self.y = self.y - self.movementSpeed * dt
			self.direction = "center"
		end
	elseif love.keyboard.isDown("down") and love.keyboard.isDown("right") then
		if self.x + self.width < nativeCanvasWidth and self.y + self.height < nativeCanvasHeight then
			self.x = self.x + self.movementSpeed * dt
			self.y = self.y + self.movementSpeed * dt
			self.direction = "right"
		elseif self.x + self.width < nativeCanvasWidth and self.y + self.height >= nativeCanvasHeight then
			self.x = self.x + self.movementSpeed * dt
			self.direction = "right"
		elseif self.x + self.width >= nativeCanvasWidth and self.y + self.height < nativeCanvasHeight then
			self.y = self.y - self.movementSpeed * dt
			self.direction = "center"
		end
	else ]]
	if love.keyboard.isDown("right") then --or joystick:isGamepadDown("dpright") then
		if self.x + self.width < nativeCanvasWidth then
			self.x = self.x + self.movementSpeed * dt
			self.direction = "right"
		else
			self.direction = "right"
		end
	elseif love.keyboard.isDown("left") then -- or joystick:isGamepadDown("dpleft") then
		if self.x > 0 then
			self.x = self.x - self.movementSpeed * dt
			self.direction = "left"
		else
			self.direction = "left"
		end
	end
	
	if love.keyboard.isDown("down") then --or joystick:isGamepadDown("dpdown") then
		if self.y + self.height < nativeCanvasHeight then
			self.y = self.y + self.movementSpeed * dt
			self.direction = "center"
		else
			self.direction = "center"
		end
		
	elseif love.keyboard.isDown("up") then --or joystick:isGamepadDown("dpup") then
		if self.y > 0 then
			self.y = self.y - self.movementSpeed * dt
			self.direction = "center"
		else
			self.direction = "center"
		end
	end

	-- shooting
	if love.keyboard.isDown('space') then
		-- Time to wait before next shot.
        if self.triggerReleased and love.timer.getTime() - self.lastShotTime > 0.01 then
			local gun_x = self.x + 40
            local gun_y = self.y + 32
            game.bullets:add(Bullet:new(gun_x, gun_y, 20))
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

	love.graphics.draw(player, self.x, self.y, 0, self.scaleFactorX, self.scaleFactorY, 0, 0)
end