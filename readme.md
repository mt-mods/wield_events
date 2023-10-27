Events for wield item switching

Provides callbacks for `on_select`, `on_step` and `on_deselect` on wielded items

![luacheck](https://github.com/mt-mods/technic/workflows/luacheck/badge.svg)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![ContentDB](https://content.minetest.net/packages/mt-mods/wield_events/shields/downloads/)](https://content.minetest.net/packages/mt-mods/wield_events/)

# Api

## Item parameter
```lua
minetest.register_tool("my_mod:my_tool", {
    description = "My tool",
    inventory_image = "my_mod.png",
    stack_max = 1,
    range = 0,
    on_select = function(itemstack, player)
        -- called when the player switches to the item
    end,
    on_step = function(itemstack, player)
        -- called on every globalstep while the item is selected
    end,
    on_deselect = function(itemstack, player)
        -- called when the player switches away from the item
    end
})
```

## Global callback
```lua
wield_events.register_on_select(function(itemstack, player)
    -- called when the player switches any item
end)

wield_events.register_on_step(function(itemstack, player)
    -- called on every globalstep while any item is selected
end)

wield_events.register_on_deselect(function(itemstack, player)
    -- called when the player switches away from any item
end)
```

# Demo

* `pick_and_place` https://github.com/BuckarooBanzay/pick_and_place/blob/master/place_tool.lua

# License

MIT