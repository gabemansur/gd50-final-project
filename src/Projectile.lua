--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{}

function Projectile:init(def, dungeon)

  self.x = def.x
  self.y = def.y
  self.width = def.width
  self.height = def.height
  self.direction = def.direction

  -- Set the original position, to reference in checking distance thrown
  self.originalX = def.x
  self.originalY = def.y

  self.dungeon = dungeon

  self.type = 'projectile'
  self.texture = def.texture
  self.frame = def.frame or 1
  self.solid = def.solid

  self.defaultState = def.defaultState
  self.state = self.defaultState
  self.states = def.states

  self.collidable = true
  self.consumable = false

  self.onCollide = def.onCollide or function() end
  self.onConsume = def.onConsume or function() end


end

function Projectile:update(dt)

  if self.direction == 'up' then
    self.y = self.y - PROJECTILE_SPEED * dt
  elseif self.direction == 'down' then
    self.y = self.y + PROJECTILE_SPEED * dt
  elseif self.direction == 'left' then
    self.x = self.x - PROJECTILE_SPEED * dt
  elseif self.direction == 'right' then
    self.x = self.x + PROJECTILE_SPEED * dt
  end

  if ((self.direction == 'up' or self.direction == 'down') and math.abs(self.y - self.originalY) > (4 * TILE_SIZE))
      or ((self.direction == 'left' or self.direction == 'right') and math.abs(self.x - self.originalX) > (4 * TILE_SIZE)) then
      self.x = -999 -- Not sure how else to make it disappear from the room 
  end

  if self:hitWall() then
    self.x = -999
  end

end

-- Determines if the projectile hit a wall
function Projectile:hitWall()
  return self.direction == 'up' and self.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2
     or self.direction == 'down' and self.y >= (VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE)
         + MAP_RENDER_OFFSET_Y - TILE_SIZE)
     or self.direction == 'right' and self.x + self.width >= VIRTUAL_WIDTH - TILE_SIZE * 2
     or self.direction == 'left' and self.x <= MAP_RENDER_OFFSET_X + TILE_SIZE
end

function Projectile:render(adjacentOffsetX, adjacentOffsetY)
  love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
      self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end
