--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerWalkHoldingState = Class{__includes = EntityWalkState}

function PlayerWalkHoldingState:init(player, room)
    self.entity = player
    
    self.room = room

    self.objects = self.room.objects

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerWalkHoldingState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-holding-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-holding-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-holding-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-holding-down')
    else
        self.entity:changeState('idle-holding')
    end

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)

    -- can't pass thru doors

    -- move the lifted obj accordingly
    self.entity.liftedObject.x = self.entity.x
    self.entity.liftedObject.y = self.entity.y + Y_LIFTED_OBJECT
end

function PlayerWalkHoldingState:render()
    EntityWalkState.render(self)
    -- render the lifted obj again over the player
    self.entity.liftedObject:render(0, 0)
end