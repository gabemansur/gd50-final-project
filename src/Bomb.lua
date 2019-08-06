Bomb = Class{}

function Bomb:init(def, x, y)

  self.x = x
  self.y = y
  self.width = def.width
  self.height = def.height
  self.direction = def.direction
  --self.speed = def.speed or PROJECTILE_SPEED
  --self.timer = def.timer or 0
  --self.onTimerExpire = def.onTimerExpire or function() end

  -- Set the original position, to reference in checking distance thrown
  --self.originalX = def.x
  --self.originalY = def.y

  self.dungeon = dungeon

  self.type = 'bomb'
  self.texture = def.texture
  self.frame = def.frame or 1
  self.solid = def.solid

  self.defaultState = def.defaultState
  self.state = self.defaultState
  self.states = def.states

  self.collidable = def.collidable
  self.consumable = def.consumable

  self.onCollide = def.onCollide or function() end
  self.onConsume = def.onConsume or function() end

  local hitboxX, hitboxY, hitboxWidth, hitboxHeight
  hitboxWidth = TILE_SIZE * 2
  hitboxHeight = TILE_SIZE * 2
  hitboxX = self.x - TILE_SIZE
  hitboxY = self.y - TILE_SIZE

  self.hitBox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)
  self.fuseTime = 5
  self.clouds = {}
end

function Bomb:update(dt)
  if self.state == 'lit' then
    Timer.after(self.fuseTime, function()
      local hitboxX, hitboxY, hitboxWidth, hitboxHeight
      hitboxWidth = TILE_SIZE * 2
      hitboxHeight = TILE_SIZE * 2
      hitboxX = self.x - TILE_SIZE
      hitboxY = self.y - TILE_SIZE

      self.clouds = {
        {
          x = math.random(self.hitBox.x, self.hitBox.width),
          y = math.random(self.hitBox.y, self.hitBox.height),
          width = 16,
          height = 16,
          opacity = 255
        },
        {
          x = math.random(self.hitBox.x, self.hitBox.width),
          y = math.random(self.hitBox.y, self.hitBox.height),
          width = 16,
          height = 16,
          opacity = 255
        },
        {
          x = math.random(self.hitBox.x, self.hitBox.width),
          y = math.random(self.hitBox.y, self.hitBox.height),
          width = 16,
          height = 16,
          opacity = 255
        }
      }

      self.state = 'exploding'
    end)
  end

  if self.state == 'exploding' then
    Timer.after(.5, function()
      self.state = 'exploded'
    end)
  end
end


function Bomb:render(adjacentOffsetX, adjacentOffsetY)
  love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
      self.x + adjacentOffsetX, self.y + adjacentOffsetY)

  love.graphics.setColor(255, 0, 255, 255)
  love.graphics.rectangle('line', self.hitBox.x, self.hitBox.y, self.hitBox.width, self.hitBox.height)
  love.graphics.setColor(255, 255, 255, 255)

  if self.state == 'exploding' then
    for i, cloud in pairs(self.clouds) do
      love.graphics.draw(gTextures['tiles'], gFrames['tiles'][247],
          cloud.x, cloud.y)

      Timer.tween(.5, {
          [cloud] = {opacity = 0}
      }):finish(function() table.remove(self.clouds, i) end)
    end
  end
end
