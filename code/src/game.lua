-- Importing necessary packages.
local class = require 'code/lib/middleclass'
local stateful = require 'code/lib/stateful'

-- Creating the class "Game".
Game = class('Game')
Game:include(stateful)

function Game:initialize(state)
    self.level = 1
    self.score = 0
    --self.player = Player:new()
    self:gotoState(state)
end

-- Adding new states to the class "Game".
Menu = Game:addState('Menu')
Play = Game:addState('Play')
PlayLevelOne = Game:addState('PlayLevelOne')
PlayLevelOneBoss = Game:addState('PlayLevelOneBoss')
PlayLevelTwo = Game:addState('PlayLevelTwo')
GameOver = Game:addState('GameOver')
YouWin = Game:addState('YouWin')

----------------------------------------------------------------------
------------------------------Menu State------------------------------
----------------------------------------------------------------------

function Menu:enteredState()
    self.score = 0
    --self.player = 10
    -- Playing music.
    music.menu:play()
    -- Setting background color.

    love.graphics.setColor(255, 255, 255)
    love.graphics.setBackgroundColor(255, 255, 255)

end

function Menu:exitedState()
    -- Playing music.
    music.menu:stop()
end

function Menu:update(dt)

    -- Start the game when the player press space or return.
    if love.keyboard.isDown('return') then
        self:gotoState('PlayLevelOne')
        return
    end

end

function Menu:draw()

    -- Draw menu background.
    love.graphics.setColor(255, 255, 255)
    love.graphics.setBackgroundColor(255, 255, 255)

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
-------------------------Play Level One State-------------------------
----------------------------------------------------------------------

function PlayLevelOne:enteredState()

    -- Playing music.
    music.main:play()
    
    -- Creating new objects.
    self.player = Player:new()
    self.bullets = Container:new()
    self.enemyBullets = Container:new()
    self.enemies = Container:new()
    self.director = Director:new()

    -- Setting score initial value.
    self.score = 0
    --self.player.healthPoints = 20
end

function PlayLevelOne:update(dt)

    backgroundProperties.y = backgroundProperties.y + backgroundProperties.speed * dt
    backgroundProperties.y2 = backgroundProperties.y2 + backgroundProperties.speed * dt

    if backgroundProperties.y > nativeCanvasHeight then
        backgroundProperties.y = backgroundProperties.y2 - images.backgroundLevelOneAux:getHeight()
    end

    if backgroundProperties.y2 > nativeCanvasHeight then
        backgroundProperties.y2 = backgroundProperties.y - images.backgroundLevelOne:getHeight()
    end

    self.player:update(dt)
    self.bullets:update(dt)
    self.enemyBullets:update(dt)
    self.enemies:update(dt)
    self.director:update(dt)
    
    -- Go to gameover state when the player deads.
    if self.player.alive == false then
        self:gotoState('GameOver')
    end

    -- Back to menu when escape is pressed.
    if love.keyboard.isDown('escape') then
        self.level = 1
        self:gotoState('GameOver')
        return
    end

    -- Back to menu when escape is pressed.
    if self.score >= 200 then
        self.level = 2
        self:gotoState('PlayLevelOneBoss')
        return
    end
end

function PlayLevelOne:draw()

    -- Draw background.
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.backgroundLevelOne, backgroundProperties.x, backgroundProperties.y)
    love.graphics.draw(images.backgroundLevelOneAux, backgroundProperties.x, backgroundProperties.y2)

    self.player:draw()
    self.bullets:draw()
    self.enemyBullets:draw()
    self.enemies:draw()

    -- Print score.
    love.graphics.setFont(fonts.PixelManiaSmall)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("SCORE " .. self.score, 20, 560, 1000, 'left')

end

function PlayLevelOne:exitedState()
    -- Stopping music.
    music.main:stop()    
end

----------------------------------------------------------------------
----------------------Play Level One Boss State-----------------------
----------------------------------------------------------------------

function PlayLevelOneBoss:enteredState()

    -- Playing music.
    music.main:play()

    self.player = Container:new()
    self.bullets = Container:new()
    self.bossLevelOne = Container:new()
    self.bossBullets = Container:new()
    backgroundProperties.speed = 60

end

function PlayLevelOneBoss:update(dt)

    backgroundProperties.y = backgroundProperties.y + backgroundProperties.speed * dt
    backgroundProperties.y2 = backgroundProperties.y2 + backgroundProperties.speed * dt

    if backgroundProperties.y > nativeCanvasHeight then
        backgroundProperties.y = backgroundProperties.y2 - images.backgroundLevelOneBossAux:getHeight()
    end

    if backgroundProperties.y2 > nativeCanvasHeight then
        backgroundProperties.y2 = backgroundProperties.y - images.backgroundLevelOneBoss:getHeight()
    end

    self.player:update(dt)
    self.bullets:update(dt)
    self.bossLevelOne:update(dt)
    self.bossBullets:update(dt)
    
    if self.player.alive == false then
        self:gotoState('GameOver')
    end

    -- Back to menu when escape is pressed.
    if love.keyboard.isDown('escape') then
        self:gotoState('GameOver')
        return
    end
end

function PlayLevelOneBoss:draw()

    -- Draw background.
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.backgroundLevelOneBoss, backgroundProperties.x, backgroundProperties.y)
    love.graphics.draw(images.backgroundLevelOneBossAux, backgroundProperties.x, backgroundProperties.y2)

    self.player:draw()
    self.bullets:draw()
    self.enemyBullets:draw()

    -- Print score.
    love.graphics.setFont(fonts.PixelManiaSmall)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("SCORE " .. self.score, 20, 560, 1000, 'left')

end

function PlayLevelOneBoss:exitedState()
    -- Stopping music.
    music.main:stop()
end

----------------------------------------------------------------------
-----------------------------Gameover State---------------------------
----------------------------------------------------------------------

function GameOver:enteredState()

    self.player.healthPoints = 10
    -- Setting background color.
    love.graphics.setColor(0, 0, 0)
    love.graphics.setBackgroundColor(0, 0, 0)

    -- playing gameover sound.
    sounds.gameover:setPitch(1.17^(2*math.random() - 1))
    sounds.gameover:stop()
    sounds.gameover:play()
end

function GameOver:update(dt)
    if love.keyboard.isDown('space') then
        self:gotoState('PlayLevelOne')
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

    love.graphics.setFont(fonts.PixelOperatorMedium)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf('Press \'space\' to restart', nativeCanvasWidth / 2 - 500, nativeCanvasHeight / 2 + 150, 1000, 'center')

end

function GameOver:exitedState()
    -- Stopping music.
    music.main:stop()
end