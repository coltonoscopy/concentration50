--[[
    Dependencies

    Stores references to all loaded resources and source code
    dependencies (libraries).
]]

Class = require 'class'

require 'Card'
require 'constants'

gTextures = {
    ['elephant'] = love.graphics.newImage('graphics/elephant.png'),
    ['giraffe'] = love.graphics.newImage('graphics/giraffe.png'),
    ['hippo'] = love.graphics.newImage('graphics/hippo.png'),
    ['monkey'] = love.graphics.newImage('graphics/monkey.png'),
    ['panda'] = love.graphics.newImage('graphics/panda.png'),
    ['parrot'] = love.graphics.newImage('graphics/parrot.png'),
    ['penguin'] = love.graphics.newImage('graphics/penguin.png'),
    ['pig'] = love.graphics.newImage('graphics/pig.png'),
    ['rabbit'] = love.graphics.newImage('graphics/rabbit.png'),
    ['snake'] = love.graphics.newImage('graphics/snake.png')
}

gFonts = {
    ['huge'] = love.graphics.newFont(128)
}