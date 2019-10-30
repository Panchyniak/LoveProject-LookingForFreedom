-- Importing necessary packages.
local class = require 'code/lib/middleclass'
local stateful = require 'code/lib/stateful'

-- Creating the class "Game".
Game = class('Game')
Game:include(stateful)

function Game:initialize(state)
    self:gotoState(state)
end

-- Adding new states to the class "Game".
Menu = Game:addState('Menu')
Play = Game:addState('Play')
GameOver = Game:addState('GameOver')

----------------------------------------------------------------------
------------------------------Menu State------------------------------
----------------------------------------------------------------------

function Menu:enteredState()
    -- music
    music.menu:play()
end

function Menu:exitedState()
    -- music
    music.menu:stop()
end

function Menu:update(dt)
    -- Start the game when the player presses space or return.
    if love.keyboard.isDown('return') then
        self:gotoState('Play')
        return
    end
end

function Menu:draw()
    -- Draw menu background.
    love.graphics.setColor(255, 255, 255)
    love.graphics.setBackgroundColor(255, 255, 255)
    local w = images.ground:getWidth()
    local h = images.ground:getHeight()
    --for x = 0, nativeCanvasWidth, w do
    --   for y = 0, nativeCanvasHeight, h do
    --        love.graphics.draw(images.ground, x, y)
    --    end
    --end

    -- Draw menu title.
    love.graphics.setFont(fonts.PixelManiaMedium)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf('LOOKING', nativeCanvasWidth / 2 - 530, nativeCanvasHeight / 2 - 200, 1000, 'center')
    love.graphics.setFont(fonts.PixelManiaSmall)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf('FOR', nativeCanvasWidth / 2 - 370, nativeCanvasHeight / 2 - 185, 1000, 'center')
    love.graphics.setFont(fonts.PixelManiaLarge)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf('FREEDOM', nativeCanvasWidth / 2 - 500, nativeCanvasHeight / 2 - 165, 1000, 'center')

    -- Draw "press start" text.
    if math.cos(2 * math.pi * love.timer.getTime()) > 0 then
        love.graphics.setFont(fonts.PixelOperatorMedium)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf('Press \'Enter\' to start', nativeCanvasWidth / 2 - 500, nativeCanvasHeight / 2 + 150, 1000, 'center')
    end

end

----------------------------------------------------------------------
------------------------------Play State------------------------------
----------------------------------------------------------------------

function Play:enteredState()
    -- music
    music.main:play()

    self.player = Player:new()
    self.bullets = Container:new()
    --self.enemies = Container:new()
    --self.director = Director:new()
    --self.coins = Container:new()

    -- score
    --self.score = 0

    -- timer
    --self.timeLeft = 30
end

function Play:update(dt)

    self.player:update(dt)
    self.bullets:update(dt)
    --self.enemies:update(dt)
    
    if self.player.alive == false then
        self:gotoState('GameOver')
    end

    --self.director:update(dt)
    --self.coins:update(dt)
    -- update timer
    --self.timeLeft = self.timeLeft - dt
    --if self.timeLeft < 0 then
    --    self:gotoState('GameOver')
    --    return
    --end

    -- back to menu
    if love.keyboard.isDown('escape') then
        self:gotoState('Menu')
        return
    end
end

function Play:draw()
    -- Draw background.
    love.graphics.setColor(255, 255, 255)
    local w = images.ground:getWidth()
    local h = images.ground:getHeight()
    for x = 0, nativeCanvasWidth, w do
        for y = 0, nativeCanvasHeight, h do
            love.graphics.draw(images.ground, x, y)
        end
    end

    self.player:draw()
    self.bullets:draw()

    -- print score
    --love.graphics.setFont(fonts.large)
    --love.graphics.setColor(255, 255, 255)
    --love.graphics.printf(self.score, nativeCanvasWidth - 1000 - 20, 0, 1000, 'right')

    -- print timer
    --love.graphics.setFont(fonts.large)
    --love.graphics.setColor(255, 255, 255)
    --local seconds = round(self.timeLeft)
    --if seconds < 10 then
    --    if math.cos(self.timeLeft * 12) > 0 then
    --        love.graphics.printf('0:0' .. seconds, 20, 0, 1000, 'left')
    --    end
    --else
    --    love.graphics.printf('0:' .. seconds, 20, 0, 1000, 'left')
    --end
end

function Play:exitedState()
    -- music
    music.main:stop()
end