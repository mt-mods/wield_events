Events for wield item switching

Provides callbacks for `on_select`, `on_step` and `on_deselect` on wielded items

# Api

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

# License

MIT