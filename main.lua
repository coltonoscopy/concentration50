--[[
    Concentration Game

    Author: Colton Ogden

    Game where the goal is to match pairs of face-down cards.
]]

require 'Dependencies'

local selectTimer = 0
local readyToSelect = true

local firstCard, secondCard
local cardsFlipped = {}

local gameOver = false

function love.load()
    love.window.setTitle('Concentration')

    love.graphics.setFont(gFonts['huge'])

    math.randomseed(os.time())

    love.window.setMode(1280, 720, {
        fullscreen = false,
        resizable = false
    })

    generateCards()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)

    if gameOver then
        return
    end

    cardsFlipped = {}

    if readyToSelect then

        -- allows us to perform any clicking on cards to find pairs
        for y = 1, CARDS_TALL do
            for x = 1, CARDS_WIDE do
                gCards[y][x]:update(dt)
            end
        end

        -- check all cards to see if 2 visible are true
        local numVisible = 0

        for y = 1, CARDS_TALL do
            for x = 1, CARDS_WIDE do
                
                -- if we've temporarily flipped this card...
                if gCards[y][x].visible then

                    -- add it to a card table to check
                    table.insert(cardsFlipped, {x=x, y=y})
                end
            end
        end

        -- if we've flipped two cards, check if they're equivalent
        if #cardsFlipped == 2 then

            readyToSelect = false

            firstCard, secondCard = cardsFlipped[1], cardsFlipped[2]
            
            -- keep cards permanently revealed if they match faces
            local card1, card2 = gCards[firstCard.y][firstCard.x], gCards[secondCard.y][secondCard.x]
            if card1.face == card2.face then
                
                gCards[firstCard.y][firstCard.x].permanentlyRevealed = true
                gCards[secondCard.y][secondCard.x].permanentlyRevealed = true
            end

            local allRevealed = true
            for y = 1, CARDS_TALL do
                for x = 1, CARDS_WIDE do
                    if not gCards[y][x].permanentlyRevealed then
                        allRevealed = false
                    end
                end
            end

            if allRevealed then
                gameOver = true
            end
        end
    else
        selectTimer = selectTimer + dt
        
        if selectTimer > 1 then
            readyToSelect = true
            selectTimer = 0

            -- revert the pair of cards to not visible either way
            gCards[firstCard.y][firstCard.x].visible = false
            gCards[secondCard.y][secondCard.x].visible = false

            cardsFlipped = {}
        end
    end
end

function love.draw()
    for y = 1, CARDS_TALL do
        for x = 1, CARDS_WIDE do
            gCards[y][x]:render()
        end
    end

    if gameOver then
        love.graphics.printf('You Win!', 0, WINDOW_HEIGHT / 2 - 64, WINDOW_WIDTH, 'center')
    end
end

function generateCards()
    gCards = {}

    local animalMap = {}
    local animalKeys = {}
    local numAnimals = (CARDS_TALL * CARDS_WIDE) / 2

    -- get a unique animal for every pair of animals
    for i = 1, numAnimals do
        local animalStr

        repeat
            animalStr = ANIMALS[math.random(#ANIMALS)]
        until not animalMap[animalStr]

        animalMap[animalStr] = 2
        table.insert(animalKeys, animalStr)
    end

    local marginX = WINDOW_WIDTH - (CARD_WIDTH * CARDS_WIDE + CARD_PADDING)
    local marginY = WINDOW_HEIGHT - (CARD_HEIGHT * CARDS_TALL + CARD_PADDING)

    for y = 1, CARDS_TALL do
        
        table.insert(gCards, {})

        for x = 1, CARDS_WIDE do

            -- get random animal
            local randomIndex = math.random(#animalKeys)
            local randomAnimal = animalKeys[randomIndex]

            -- insert new card with animal face in grid, check for value being 0
            -- after decrementing animal map, then delete from keys and map if so
            table.insert(gCards[y], Card(randomAnimal, 
                (marginX / 2) + (x - 1) * (CARD_WIDTH + CARD_PADDING),
                (marginY / 2) + (y - 1) * (CARD_HEIGHT + CARD_PADDING)))

            if animalMap[randomAnimal] then
                animalMap[randomAnimal] = animalMap[randomAnimal] - 1
            end
            
            if animalMap[randomAnimal] == 0 then

                -- delete the animal from keys and map
                table.remove(animalKeys, randomIndex)
                animalMap[randomAnimal] = nil

            end
        end
    end
end