Bomb = Class{}

function Bomb:init(def, x, y)

  self.x = x
  self.y = y
  self.width = def.width
  self.height = def.height
  self.direction = def.direction

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

  self.hitBox = nil

  self.fuseTime = 3
  self.clouds = {}
end

function Bomb:lightFuse()
  local hitboxX, hitboxY, hitboxWidth, hitboxHeight
  hitboxWidth = (TILE_SIZE * 4) + self.width / 2
  hitboxHeight = (TILE_SIZE * 4) + self.height / 2
  hitboxX = self.x - 2 * TILE_SIZE
  hitboxY = self.y - 2 * TILE_SIZE

  self.hitBox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)
  self.state = 'lit'

  Timer.after(self.fuseTime, function()


    self.clouds = {
      {
        x = math.random(self.hitBox.x, self.hitBox.x + self.hitBox.width),
        y = math.random(self.hitBox.y, self.hitBox.y + self.hitBox.height),
        width = 16,
        height = 16,
        opacity = 255
      },
      {
        x = math.random(self.hitBox.x, self.hitBox.x + self.hitBox.width),
        y = math.random(self.hitBox.y, self.hitBox.y + self.hitBox.height),
        width = 16,
        height = 16,
        opacity = 255
      },
      {
        x = math.random(self.hitBox.x, self.hitBox.x + self.hitBox.width),
        y = math.random(self.hitBox.y, self.hitBox.y + self.hitBox.height),
        width = 16,
        height = 16,
        opacity = 255
      }
    }

    self:explode()
  end)

end

function Bomb:explode()
  self.state = 'exploding'
  gSounds['explosion']:play()
  Timer.after(1, function()
    self.state = 'exploded'
  end)
end

function Bomb:update(dt)

end


function Bomb:render(adjacentOffsetX, adjacentOffsetY)
  love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
      self.x + adjacentOffsetX, self.y + adjacentOffsetY)

  if self.state == 'exploding' then
    for i, cloud in pairs(self.clouds) do
      love.graphics.draw(gTextures['tiles'], gFrames['tiles'][247],
          cloud.x, cloud.y)

      Timer.tween(2, {
          [cloud] = {opacity = 0}
      }):finish(function() table.remove(self.clouds, i) end)
    end
  end
end
