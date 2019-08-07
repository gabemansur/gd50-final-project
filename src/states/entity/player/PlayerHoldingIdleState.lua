--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerHoldingIdleState = Class{__includes = EntityIdleState}


function PlayerHoldingIdleState:enter(params)

    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerHoldingIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('holding-walk')
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.entity:changeState('throwing')
    end
end
