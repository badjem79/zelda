--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity, room)
    self.entity = entity
    self.entity:changeAnimation('walk-down')

    self.room = room

    self.objects = self.room.objects

    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0

    -- keeps track of whether we just hit a wall
    self.bumped = false
end

function EntityWalkState:update(dt)
    
    -- assume we didn't hit a wall
    self.bumped = false

    -- boundary checking on all sides, allowing us to avoid collision detection on tiles
    if self.entity.direction == 'left' then
        self.entity.x = self.entity.x - self.entity.walkSpeed * dt
        
        if self.entity.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then 
            self.entity.x = MAP_RENDER_OFFSET_X + TILE_SIZE
            self.bumped = true
        else
            for k, object in pairs(self.objects) do
                -- trigger collision callback on object
                if not object.destroyed and object.solid and self.entity:collides(object) then
                    object:onCollide(self.entity)
                    self.bumped = true
                    self.entity.x = object.x + object.width + 1
                end
            end
        end

    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x + self.entity.walkSpeed * dt

        if self.entity.x + self.entity.width >= RIGHT_EDGE then
            self.entity.x = RIGHT_EDGE - self.entity.width
            self.bumped = true
        else
            for k, object in pairs(self.objects) do
                -- trigger collision callback on object
                if not object.destroyed and object.solid and self.entity:collides(object) then
                    object:onCollide(self.entity)
                    self.bumped = true
                    self.entity.x = object.x - self.entity.width - 1
                end
            end
        end
    elseif self.entity.direction == 'up' then
        self.entity.y = self.entity.y - self.entity.walkSpeed * dt

        if self.entity.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.entity.height / 2 then 
            self.entity.y = MAP_RENDER_OFFSET_Y + TILE_SIZE - self.entity.height / 2
            self.bumped = true
        else
            for k, object in pairs(self.objects) do
                -- trigger collision callback on object
                if not object.destroyed and object.solid and self.entity:collides(object) then
                    object:onCollide(self.entity)
                    self.bumped = true
                    self.entity.y = self.entity.y + self.entity.walkSpeed * dt --object.y + object.height + 1
                end
            end
        end
    elseif self.entity.direction == 'down' then
        self.entity.y = self.entity.y + self.entity.walkSpeed * dt

        if self.entity.y + self.entity.height >= BOTTOM_EDGE then
            self.entity.y = BOTTOM_EDGE - self.entity.height
            self.bumped = true
        else
            for k, object in pairs(self.objects) do
                -- trigger collision callback on object
                if not object.destroyed and object.solid and self.entity:collides(object) then
                    object:onCollide(self.entity)
                    self.bumped = true
                    self.entity.y = object.y - self.entity.height - 1
                end
            end
        end
    end
end

function EntityWalkState:processAI(params, dt)
    local room = params.room
    local directions = {'left', 'right', 'up', 'down'}

    if self.moveDuration == 0 or self.bumped then
        
        -- set an initial move duration and direction
        self.moveDuration = math.random(5)
        self.entity.direction = directions[math.random(#directions)]
        self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    elseif self.movementTimer > self.moveDuration then
        self.movementTimer = 0

        -- chance to go idle
        if math.random(3) == 1 then
            self.entity:changeState('idle')
        else
            self.moveDuration = math.random(5)
            self.entity.direction = directions[math.random(#directions)]
            self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
        end
    end

    self.movementTimer = self.movementTimer + dt
end

function EntityWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
    
    -- debug code
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end