PlayerThrowingState = Class{__includes = BaseState}

function PlayerThrowingState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 8

    local direction = self.player.direction

    -- lifting-left, lifting-up, etc
    self.player:changeAnimation('lifting-' .. self.player.direction)
end

function PlayerThrowingState:enter(params)

    -- restart sword swing sound for rapid swinging
    --gSounds['sword']:stop()
    --gSounds['sword']:play()

    -- restart animation
    self.player.currentAnimation:refresh()

    -- Convert the object we are holding into a Projectile

    -- Hold the object in a local var, and clear out the player's object field
    local object = self.player.object;
    self.player.object = nil

    if object.type == 'pot' then
      -- We can convert an pot object to a projectile, but we need to
      -- change a few fields first
      object.direction = self.player.direction -- Projectiles have direction
      object.consumable = false
      object.onConsume = false
      object.collidable = true
      local projectile = Projectile(object, self.dungeon)
      table.insert(self.dungeon.currentRoom.objects, projectile)

    elseif object.type == 'bomb' then
      object.state = 'lit'
      object.x = self.player.x
      object.y = self.player.y
      if self.player.direction == 'left' then
        object.x = self.player.x - object.width - 10
      elseif self.player.direction == 'right' then
        object.x = self.player.x + object.width + 10
      elseif self.player.direction == 'up' then
        object.y = self.player.y - object.height - 10
      elseif self.player.direction == 'down' then
        object.y = self.player.y + object.height + 10
      end
      object:lightFuse() 
      table.insert(self.dungeon.currentRoom.objects, object)
    end

end

function PlayerThrowingState:update(dt)
    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end

end

function PlayerThrowingState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

end
