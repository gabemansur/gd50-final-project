--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },

    ['block'] = {
        type = 'block',
        texture = 'tiles',
        frame = 120,
        width = 16,
        height = 16,
        solid = true,
        collidable = true,
        defaultState = 'default',
        states = {
            ['default'] = {
                frame = 120
            }
        }
    },

    ['pot'] = {
      type = 'pot',
      texture = 'tiles',
      frame = 14,
      width = 16,
      height = 16,
      solid = false,
      collidable = true,
      consumable = true,
      defaultState = 'default',
      states = {
          ['default'] = {
              frame = 14
          },
          ['broken'] = {
            frame = 52
          }

      },

      onConsume = function(player, object, objects)
        -- If the player is already holding an object, put it down
        if player.object then
          local object = player.object
          object.x = object.x - 4
          player.object = nil
          table.insert(objects, object)
        end
        gSounds['pickup']:play()
        player.object = object
        player:changeState('lifting')
      end
    },

    ['bomb'] = {
      type = 'bomb',
      texture = 'tiles',
      frame = 16,
      width = 16,
      height = 16,
      solid = false,
      collidable = true,
      consumable = true,
      defaultState = 'unlit',
      states = {
          ['unlit'] = {
              frame = 16
          },
          ['lit'] = {
            frame = 35
          },
          ['exploding'] = {
            frame = 54
          },
          ['exploded'] = {
            frame = 54
          }
      },

      onConsume = function(player, object, objects)
        -- If the player is already holding an object, put it down
        if player.object then
          local object = player.object
          object.x = object.x - 4
          player.object = nil
          table.insert(objects, object)
        end
        gSounds['pickup']:play()
        player.object = object
        player:changeState('lifting')
      end
    },

    ['heart'] ={
      type = 'heart',
      texture = 'hearts',
      frame = 5,
      width = 16,
      height = 16,
      solid = false,
      collidable = true,
      consumable = true,
      defaultState = 'default',
      states = {
          ['default'] = {
              frame = 5
          }
      },
      onConsume = function(player, object)
          gSounds['life']:play()
          player.health = player.health + 2
          if player.health > 6 then
            player.health = 6
          end
      end
    },

    ['blue-gem'] ={
      type = 'gem',
      texture = 'items',
      frame = 114,
      width = 16,
      height = 16,
      solid = false,
      collidable = true,
      consumable = true,
      defaultState = 'default',
      states = {
          ['default'] = {
              frame = 114
          }
      },
      onConsume = function(player, object)
          gSounds['gem']:play()
          player.gems = player.gems + 1
      end
    },

    ['red-gem'] ={
      type = 'items',
      texture = 'items',
      frame = 115,
      width = 16,
      height = 16,
      solid = false,
      collidable = false,
      consumable = true,
      defaultState = 'default',
      states = {
          ['default'] = {
              frame = 115
          }
      },
      onConsume = function(player, object)
          gSounds['gem']:play()
          player.gems = player.gems + 5
      end
    }
}
