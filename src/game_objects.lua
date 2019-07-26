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

    ['pot'] = {
        -- TODO
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
          gSounds['hit-enemy']:play()
          player.health = player.health + 2
          if player.health > 6 then
            player.health = 6
          end
      end
    }
}
