require "clickfuncs"
require "engine"
require "mathK"

function love.load()
    engine.load(5)

    gameW, gameH = love.window.getMode()
    engine.imgs.grass = love.graphics.newImage('grass.png')

    land = {}
    counter = 0
    
    mySquare = engine.newObject({color = {0,1,0.8}, onclick = click.debug})
    engine.newObject({color = {1,0,0}, parent = mySquare, x = 50, onclick = click.debug1})
end

function love.update(dt)
    
end

function love.keypressed( key, scancode, isrepeat )
    
end

function love.mousepressed( x, y, button, istouch )
    engine.checkObjectsPressed(x,y,button,istouch)
end

function love.draw()
    engine.drawObjects()
end