--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerLiftState = Class{__includes = BaseState}

function PlayerLiftState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.offsetY = 0
    self.offsetX = 0

    local direction = self.player.direction

    -- lift-left, lift-up, etc
    self.player:changeAnimation('lift-' .. direction)

    if direction == 'left' then
        self.offsetX = 5
    elseif direction == 'right' then
        self.offsetX = -5
    elseif direction == 'up' then
        self.offsetY = 5
    elseif direction == 'down' then
        self.offsetY = -5
    end

    self.liftedObject = nil
end

function PlayerLiftState:enter(params)

    -- sound for lifting
    gSounds['lift']:play()

    -- restart animation
    self.player.currentAnimation:refresh()

    -- tween
    Timer.tween(0.5, {
        [self.player.liftedObject] = {x = self.player.x, y = self.player.y + Y_LIFTED_OBJECT}
    })
end

function PlayerLiftState:update(dt)

    -- if we've fully elapsed through one cycle of animation, change to idle-holding state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle-holding')
    end

end

function PlayerLiftState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.offsetX), math.floor(self.player.y - self.offsetY))
    -- render the lifted obj again over the player
    self.player.liftedObject:render(0, 0)
end