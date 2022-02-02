--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    self.consumable = def.consumable

    self.destroyed = false

    -- default empty collision callback
    self.onCollide = function() end

    -- particle system belonging to the object, emitted on destroy
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

    -- lasts between 0.5-1 seconds seconds
    self.psystem:setParticleLifetime(0.7, 1)

    -- give it an acceleration of anywhere between X1,Y1 and X2,Y2 (0, 0) and (80, 80) here
    -- gives generally downward 
    -- self.psystem:setLinearAcceleration(-15, 0, 15, 80)

    -- spread of particles; normal looks more natural than uniform
    self.psystem:setEmissionArea('normal', 5, 5)
    
    self.psystem:setColors(
        1,
        35 /255,
        35 / 255,
        1,
        254 / 255,
        1,
        181 / 255,
        0
    )

    self.moveTween = nil

    self.exploding = false
end

function GameObject:explode()
    if not self.exploding then
        self.exploding = true

        self.psystem:emit(64)
        
        if self.moveTween ~= nil then
            Timer.after(0.3, function ()
                self.moveTween:remove()
                self.moveTween = nil;
            end)
        end

        Timer.after(0.8, function ()
            self.destroyed = true
        end)
        gSounds['explosion']:play()
    end
end

function GameObject:update(dt)
    self.psystem:update(dt)

    if self.type == 'pot' then
        if not self.exploding and (
           self.x < MAP_RENDER_OFFSET_X or self.x > RIGHT_EDGE or
           self.y < MAP_RENDER_OFFSET_Y or self.y > BOTTOM_EDGE) then
                self:explode()
        end
    end

end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    if not self.exploding then
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
            self.x + adjacentOffsetX, self.y + adjacentOffsetY)
    end

    love.graphics.draw(self.psystem, self.x + self.width/2, self.y + self.height/2)
end