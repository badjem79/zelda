--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end

    if love.keyboard.wasPressed('c') or love.keyboard.wasPressed('C') then
        local near = false
        if (self.entity.bumpedObject) then
            if (self.entity.direction == 'left') then
                if (self.entity.x <= self.entity.bumpedObject.x + self.entity.bumpedObject.width + 1) and
                   (self.entity.x > self.entity.bumpedObject.x) and
                   (self.entity.y < self.entity.bumpedObject.y + self.entity.bumpedObject.height - self.entity.height/2) and
                   (self.entity.y >= self.entity.bumpedObject.y - self.entity.height/2) then
                    near = true
                end
            elseif (self.entity.direction == 'right') then
                if self.entity.x >= self.entity.bumpedObject.x - self.entity.width - 1 and
                   self.entity.x < self.entity.bumpedObject.x and
                   (self.entity.y < self.entity.bumpedObject.y + self.entity.bumpedObject.height - self.entity.height/2) and
                   (self.entity.y > self.entity.bumpedObject.y - self.entity.height/2) then
                    near = true
                end
            elseif (self.entity.direction == 'up') then
                if self.entity.y <= self.entity.bumpedObject.y + self.entity.bumpedObject.height + 1 and
                   self.entity.y > self.entity.bumpedObject.y and
                   self.entity.x > self.entity.bumpedObject.x - self.entity.width/2 and
                   self.entity.x < self.entity.bumpedObject.x + self.entity.bumpedObject.width - self.entity.width/2 then
                    near = true
                end
            elseif (self.entity.direction == 'down') then
                if self.entity.y >= self.entity.bumpedObject.y - self.entity.height - 1 and
                   self.entity.y < self.entity.bumpedObject.y and
                   self.entity.x > self.entity.bumpedObject.x - self.entity.width/2 and
                   self.entity.x < self.entity.bumpedObject.x + self.entity.bumpedObject.width - self.entity.width/2 then
                    near = true
                end
            end
        end
        if near then
            -- set bumped as lifted
            self.entity.liftedObject = self.entity.bumpedObject
            self.entity.bumpedObject = nil
            self.entity.liftedObject.solid = false
            
            -- lift pot and go to lift
            self.entity:changeState('lift') --idle-holding
        end
    end
end