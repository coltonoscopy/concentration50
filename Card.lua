--[[
    Card

    Represents a card with its image and ID information.
]]

Card = Class{}

function Card:init(face, x, y)
    self.face = face
    self.x = x
    self.y = y

    -- is visible temporarily while looking for a pair
    self.visible = false

    -- card has been found in a pair and should stay visible
    self.permanentlyRevealed = false
end

function Card:update(dt)
    local mouseX, mouseY = love.mouse.getPosition()

    if love.mouse.isDown(1) then
        if mouseX >= self.x and mouseY >= self.y and
            mouseX <= self.x + CARD_WIDTH and mouseY <= self.y + CARD_HEIGHT then
                if not self.visible and not self.permanentlyRevealed then
                    self.visible = true
                end
        end
    end
end

function Card:render()
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle('fill', self.x, self.y, CARD_WIDTH, CARD_HEIGHT, 3)

    love.graphics.setColor(1, 1, 1, 1)
    if self.visible or self.permanentlyRevealed then
        love.graphics.draw(gTextures[self.face], 
            self.x + X_OFFSET, self.y + Y_OFFSET, 0, 0.25, 0.25)
    end
end