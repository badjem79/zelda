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
        consumable = false,
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
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        consumable = true,
        defaultState = 'full',
        states = {
            ['star'] = {
                frame = 6
            },
            ['full'] = {
                frame = 5
            },
            ['half'] = {
                frame = 3
            }
        }
    },
    ['pot'] = {
        type = 'pot',
        texture = 'pots',
        frame = 110,
        width = 16,
        height = 16,
        solid = true,
        consumable = false,
        defaultState = 'full',
        states = {
            ['full'] = {
                frame = 110
            },
            ['empty'] = {
                frame = 111
            }
        }
    }
}