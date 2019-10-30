-- Importing necessary packages.
require 'code/lib/misc'
require 'code/src/game'
require 'code/src/player'
require 'code/src/bullet'
require 'code/src/container'
--require 'code/src/enemy'

function love.load()
    -- Setting canvas.
    nativeWindowWidth = 500
    nativeWindowHeight = 600

    nativeCanvasWidth = 500
    nativeCanvasHeight = 600

    canvas = love.graphics.newCanvas(nativeCanvasWidth, nativeCanvasHeight)
    canvas:setFilter('nearest', 'nearest', 1)

    -- Importing assets.

    -- Fonts:
    fonts = {}
    --
    fonts.PixelManiaLarge = love.graphics.newFont('assets/fonts/Pixelmania.ttf', 35)
    fonts.PixelManiaMedium = love.graphics.newFont('assets/fonts/Pixelmania.ttf', 25)
    fonts.PixelManiaSmall = love.graphics.newFont('assets/fonts/Pixelmania.ttf', 15)
    --
    fonts.PixelOperatorLarge = love.graphics.newFont('assets/fonts/PixelOperator.ttf', 35)
    fonts.PixelOperatorMedium = love.graphics.newFont('assets/fonts/PixelOperator.ttf', 25)
    fonts.PixelOperatorSmall = love.graphics.newFont('assets/fonts/PixelOperator.ttf', 15)
    fonts.PixelOperatorTiny = love.graphics.newFont('assets/fonts/PixelOperator.ttf', 15)
    --
    fonts.huge = love.graphics.newFont('assets/fonts/Gamer.ttf', 96)
    fonts.large = love.graphics.newFont('assets/fonts/Gamer.ttf', 72)
    fonts.medium = love.graphics.newFont('assets/fonts/Gamer.ttf', 48)
    --

    -- Images:
    images = {}
    love.graphics.setDefaultFilter('nearest', 'nearest', 1)

    images.ground = love.graphics.newImage('assets/images/ground.png')
    images.playerCenter = love.graphics.newImage('assets/images/playerCenter.png')
    images.playerRight = love.graphics.newImage('assets/images/playerRight.png')
    images.playerLeft = love.graphics.newImage('assets/images/playerLeft.png')
    
    images.bullet =love.graphics.newImage('assets/images/bullet.png')
    -- Musics:
    music = {}
    music.menu = love.audio.newSource('assets/music/menu.wav', 'stream')
    music.menu:setVolume(0.5)
    music.menu:setLooping(true)

    music.main = love.audio.newSource('assets/music/clearside.wav', 'stream')
    music.main:setVolume(0.35)
    music.main:setLooping(true)

    -- Sounds:
    sounds = {}
    sounds.gunshot = love.audio.newSource('assets/sounds/gunshot.wav', 'static')
    --sounds.footstep = love.audio.newSource('assets/sounds/footstep.wav', 'static')
    --sounds.footstep:setVolume(0.1)

    --sounds.punch = love.audio.newSource('assets/sounds/punch.wav', 'static')
    --sounds.kill = love.audio.newSource('assets/sounds/kill.wav', 'static')
    --sounds.die = love.audio.newSource('assets/sounds/die.wav', 'static')

    -- Shaders:
    moonshine = require 'code/lib/moonshine'
    shaders = moonshine(moonshine.effects.filmgrain).chain(moonshine.effects.vignette)
    shaders.filmgrain.size = 4
    shaders.filmgrain.opacity = 0.1
    shaders.vignette.radius = 1.1
    shaders.vignette.opacity = 0.6

    -- Seed random time function.
    math.randomseed(os.time())

    -- Hide mouse.
    love.mouse.setVisible(false)

    -- Loading the game menu state.
    game = Game:new('Menu')
end

function love.update(dt)

    -- Determine window scale and offset
    windowScaleX = love.graphics.getWidth() / nativeWindowWidth
    windowScaleY = love.graphics.getHeight() / nativeWindowHeight
    windowScale = math.min(windowScaleX, windowScaleY)
    windowOffsetX = round((windowScaleX - windowScale) * (nativeWindowWidth * 0.5))
    windowOffsetY = round((windowScaleY - windowScale) * (nativeWindowHeight * 0.5))

    -- Calling the update game state passing deltatime.
    game:update(dt)
end


function love.draw()

    -- Draw everything to canvas of native size, then upscale and offset.
    love.graphics.setCanvas(canvas)
    game:draw()
    love.graphics.setCanvas()
    love.graphics.setColor(255, 255, 255)
    shaders.draw(function () love.graphics.draw(canvas, windowOffsetX, windowOffsetY, 0, windowScale, windowScale) end)

    -- letterboxing
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 0, 0, windowOffsetX, windowHeight)
    love.graphics.rectangle('fill', windowWidth - windowOffsetX, 0, windowOffsetX, windowHeight)
    love.graphics.rectangle('fill', 0, 0, windowWidth, windowOffsetY)
    love.graphics.rectangle('fill', 0, windowHeight - windowOffsetY, windowWidth, windowOffsetY)

end