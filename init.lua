wield_events = {}

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

-- on_* callbacks
local on_select, on_deselect, on_step = {}, {}, {}

function wield_events.register_on_select(func)
    table.insert(on_select, func)
end

function wield_events.register_on_deselect(func)
    table.insert(on_deselect, func)
end

function wield_events.register_on_step(func)
    table.insert(on_step, func)
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
                    if type(previous_item_def.on_deselect) == "function" then
                        previous_item_def.on_deselect(previous_itemstack, player)
                    end

                    for _, func in ipairs(on_deselect) do
                        func(previous_itemstack, player)
                    end
                end
            end

            -- new item
            if current_item_def then
                if type(current_item_def.on_select) == "function" then
                    current_item_def.on_select(itemstack, player)
                end

                for _, func in ipairs(on_select) do
                    func(itemstack, player)
                end
            end
        else
            -- same item
            if current_item_def then
                if type(current_item_def.on_step) == "function" then
                    current_item_def.on_step(itemstack, player)
                end
            end
            for _, func in ipairs(on_step) do
                func(itemstack, player)
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
