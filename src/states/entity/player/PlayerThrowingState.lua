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
      object.speed = 0
      object.timer = 5
      object.onTimerExpire = (function(object, entities)
        print(object.type .. ' goes boom!')
        object.x = (object.x - 2) * TILE_SIZE
        object.y = object.y - 2 * TILE_SIZE
        object.height = object.height * 4
        object.width = object.width * 4
        for i, entity in pairs(entities) do
          if entity:collides(object) then
            entity:damage(1)
            gSounds['hit-enemy']:play()
          end
        end
        if self.player:collides(object) then
          self.player:damage(1)
          gSounds['hit-player']:play()
        end
      end)
      local projectile = Projectile(object, self.dungeon)
      table.insert(self.dungeon.currentRoom.objects, projectile)
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
