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
    -- Playing music.
    music.menu:play()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setBackgroundColor(255, 255, 255)
end

function Menu:exitedState()
    -- Playing music.
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

    -- Playing music.
    music.main:play()

    self.player = Player:new()
    self.bullets = Container:new()
    self.enemies = Container:new()
    self.director = Director:new()

    -- Setting score initial value.
    self.score = 0
end

function Play:update(dt)

    backgroundProperties.y = backgroundProperties.y + backgroundProperties.speed * dt
    backgroundProperties.y2 = backgroundProperties.y2 + backgroundProperties.speed * dt

    if backgroundProperties.y > nativeCanvasHeight then
        backgroundProperties.y = backgroundProperties.y2 - images.backgroundTwo:getHeight()
    end

    if backgroundProperties.y2 > nativeCanvasHeight then
        backgroundProperties.y2 = backgroundProperties.y - images.background:getHeight()
    end

    self.player:update(dt)
    self.bullets:update(dt)
    self.enemies:update(dt)
    self.director:update(dt)
    
    if self.player.alive == false then
        self:gotoState('GameOver')
    end

    -- Back to menu when escape is pressed.
    if love.keyboard.isDown('escape') then
        self:gotoState('GameOver')
        return
    end
end

function Play:draw()

    -- Draw background.

    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.background, backgroundProperties.x, backgroundProperties.y)
    love.graphics.draw(images.backgroundTwo, backgroundProperties.x, backgroundProperties.y2)

    --[[ love.graphics.setColor(255, 255, 255)
    local w = images.ground:getWidth()
    local h = images.ground:getHeight()
    for x = 0, nativeCanvasWidth, w do
       for y = 0, nativeCanvasHeight, h do
            love.graphics.draw(images.ground, x, y)
        end
    end ]]

    self.player:draw()
    self.bullets:draw()
    self.enemies:draw()

    -- Print score.
    love.graphics.setFont(fonts.PixelManiaSmall)
    love.graphics.setColor(0, 0, 0)
    --love.graphics.printf("SCORE " .. self.score, nativeCanvasWidth - 1350, 560, 1000, 'right')
    love.graphics.printf("SCORE " .. self.score, 20, 560, 1000, 'left')

end

function Play:exitedState()
    -- Playing music.
    music.main:stop()
end

----------------------------------------------------------------------
-----------------------------Gameover State---------------------------
----------------------------------------------------------------------

function GameOver:enteredState()
    love.graphics.setColor(0, 0, 0)
    love.graphics.setBackgroundColor(0, 0, 0)

    sounds.gameover:setPitch(1.17^(2*math.random() - 1))
    sounds.gameover:stop()
    sounds.gameover:play()
end

function GameOver:update(dt)
    if love.keyboard.isDown('return') then
        self:gotoState('Play')
        return
    end
end

function GameOver:draw()

    -- Draw gameover background.
    love.graphics.setColor(0, 0, 0)
    local w = images.groundBlack:getWidth()
    local h = images.groundBlack:getHeight()
    for x = 0, nativeCanvasWidth, w do
       for y = 0, nativeCanvasHeight, h do
            love.graphics.draw(images.ground, x, y)
        end
    end

    -- Draw gameover title.
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(fonts.PixelManiaMedium)
    love.graphics.printf('VOCE', nativeCanvasWidth / 2 - 500, nativeCanvasHeight / 2 - 200, 1000, 'center')
    love.graphics.printf('REPROVOU', nativeCanvasWidth / 2 - 500, nativeCanvasHeight / 2 - 150, 1000, 'center')

end

function GameOver:exitedState()
    -- Playing music.
    music.main:stop()
end