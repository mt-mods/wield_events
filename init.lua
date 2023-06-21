
-- playername -> key
local last_wielded_key = {}

-- playername -> itemstack
local last_itemstack = {}

-- returns an unique itemstack key
local function get_key(itemstack, itemindex)
    return itemstack:get_name() .. "/" ..
        itemstack:get_count() .. "/" ..
        itemstack:get_description() .. "/" ..
        itemindex
end

-- wield-check loop
minetest.register_globalstep(function()
    for _, player in ipairs(minetest.get_connected_players()) do
        local itemstack = player:get_wielded_item()
        local itemindex = player:get_wield_index()
        local playername = player:get_player_name()
        local key = get_key(itemstack, itemindex)
        local current_item_def = minetest.registered_items[itemstack:get_name()]

        if last_wielded_key[playername] ~= key then
            -- wield item changed

            -- previous item
            local previous_itemstack = last_itemstack[playername]
            if previous_itemstack then
                local previous_item_def = minetest.registered_items[previous_itemstack:get_name()]
                if previous_item_def then
                    if type(previous_item_def.on_blur) == "function" then
                        previous_item_def.on_blur(previous_itemstack, player)
                    end
                end
            end

            -- new item
            if current_item_def then
                if type(current_item_def.on_focus) == "function" then
                    current_item_def.on_focus(itemstack, player)
                end
            end
        else
            -- same item
            if current_item_def then
                if type(current_item_def.on_step) == "function" then
                    current_item_def.on_step(itemstack, player)
                end
            end
        end

        -- store key and itemstack
        last_wielded_key[playername] = key
        last_itemstack[playername] = itemstack
    end
end)

minetest.register_on_leaveplayer(function(player)
    local playername = player:get_player_name()
    last_wielded_key[playername] = nil
    last_itemstack[playername] = nil
end)
