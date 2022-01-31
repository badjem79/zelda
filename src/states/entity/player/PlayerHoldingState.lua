--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerHoldingState = Class{__includes = EntityIdleState}

function PlayerHoldingState:enter(params)
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerHoldingState:update(dt)
    self.entity:changeAnimation('idle-holding-' .. self.entity.direction)

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk-holding')
    end

    if love.keyboard.wasPressed('x') or love.keyboard.wasPressed('X') then
        -- throw the object

        -- go back to normal idle
        self.entity:changeState('idle')
    end
end