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
        local newX = self.entity.liftedObject.x
        local newY = self.entity.liftedObject.y
        
        if (self.entity.direction == 'left') then
            newX = newX - OBJ_THROW_DISTANCE
            newY = newY - Y_LIFTED_OBJECT
        elseif (self.entity.direction == 'right') then
            newX = newX + OBJ_THROW_DISTANCE
            newY = newY - Y_LIFTED_OBJECT
        elseif (self.entity.direction == 'up') then
            newY = newY - OBJ_THROW_DISTANCE
        elseif (self.entity.direction == 'down') then
            newY = newY + OBJ_THROW_DISTANCE
        end
        self.entity.liftedObject.solid = true
        self.entity.liftedObject.state = 'full-fly'
        self.entity.liftedObject.moveTween = Timer.tween(OBJ_THROW_TIME, {
            [self.entity.liftedObject] = {x = newX, y = newY}
        }):finish(function()
            -- particle explosion
            self.entity.liftedObject.moveTween = nil
            self.entity.liftedObject:explode()
        end)
        gSounds['throw']:play()

        -- go back to normal idle
        self.entity:changeState('idle')
    end
end

function PlayerHoldingState:render()
    EntityIdleState.render(self)
    -- render the lifted obj again over the player
    self.entity.liftedObject:render(0, 0)
end