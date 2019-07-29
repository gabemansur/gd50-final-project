PlayerLiftingState = Class{__includes = BaseState}

function PlayerLiftingState:init(player, object)
    self.player = player
    self.object = object

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 8

    local direction = self.player.direction

    -- lifting-left, lifting-up, etc
    self.player:changeAnimation('lifting-' .. self.player.direction)
end

function PlayerLiftingState:enter(params)

    -- restart sword swing sound for rapid swinging
    --gSounds['sword']:stop()
    --gSounds['sword']:play()

    -- restart animation
    self.player.currentAnimation:refresh()

    -- Tween the object being lifted
    Timer.tween(0.1, {
        [self.player.object] = {x = self.player.x, y = self.player.y - (self.player.object.height - 2)}
    })
end

function PlayerLiftingState:update(dt)
    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('holding-idle')
    end

end

function PlayerLiftingState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

end
