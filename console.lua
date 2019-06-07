local console = {}

local command_history = {}
local output_history = {}

local commands = {
    look = {
        name = "look",
        description = "",
        entity_arg_count = 0,
        positional_arg_count = 1,
        subject_requirements = {"creature/sight>=1"},
        object_requirements = {},
    }
    inspect = {
        name = "inspect",
        description = "",
        entity_arg_count = 1,
        positional_arg_count = 0,
        subject_requirements = {"creature.sight>=2", "creature.sentience>=1"},
        object_requirements = {},
    },
    eat = {
        name = "eat",
        description = "",
        entity_arg_count = 1,
        positional_arg_count = 0,
        subject_requirements = {"creature.mouth>=1"},
        object_requirements = {{"edible"}},
    },
    drink = {
        name = "drink",
        description = "",
        entity_arg_count = 1,
        positional_arg_count = 0,
        subject_requirements = {"creature.mouth>=1"},
        object_requirements = {{"fluid"}},
    },
    pick_up = {
        name = "pick up",
        description = "",
        entity_arg_count = 1,
        positional_arg_count = 0,
        subject_requirements = {"creature.manipulation>=1"},
        object_requirements = {{"handleable"}},
    },
    drop = {
        name = "drop",
        description = "",
        entity_arg_count = 1,
        positional_arg_count = 0,
        subject_requirements = {"creature.manipulation>=1"},
        object_requirements = {{"handleable"}},
    },
    throw = {
        name = "throw",
        description = "",
        entity_arg_count = 1,
        positional_arg_count = 1,
        subject_requirements = {"creature.manipulation>=1"},
        object_requirements = {{"handleable"}},
    },
    dip = {
        name = "dip",
        description = "",
        entity_arg_count = 2,
        positional_arg_count = 0,
        subject_requirements = {"creature.manipulation>=2"},
        object_requirements = {{"handleable"}, {"fluid"}},
    },
    put_on = {
        name = "put on",
        description = "",
        entity_arg_count = 1,
        positional_arg_count = 0,
        subject_requirements = {"creature.manipulation>=2"},
        object_requirements = {{"wearable", "handleable"}},
    },
    take_off = {
        name = "take off",
        description = "",
        entity_arg_count = 1,
        positional_arg_count = 0,
        subject_requirements = {"creature.manipulation>=2"},
        object_requirements = {{"worn", "handleable"}},
    },
    read = {
        name = "read",
        description = "",
        entity_arg_count = 1,
        positional_arg_count = 0,
        subject_requirements = {"creature.sight>=2", "creature.sentience>=2"},
        object_requirements = {{"legible"}},
    },
    stow = {
        name = "stow",
        description = "",
        entity_arg_count = 2,
        positional_arg_count = 0,
        subject_requirements = {"creature.manipulation>=2"},
        object_requirements = {{"handleable", "stowable"}, {"container"}},
    },
    remove = {
        name = "remove",
        description = "",
        entity_arg_count = 2,
        positional_arg_count = 0,
        subject_requirements = {"creature.manipulation>=2"},
        object_requirements = {{"handleable", "stowed"}, {"container"}},
    },
}

local suggestions = {}
local highlighted_suggestion = 0

local function generate_suggestions_from_command_names() 

end

local function generate_suggestions_from_entity_names() 

end

local function generate_suggestions_from_nearby_entities() 

end

local function clear_suggestions()
    suggestions = {}
    highlighted_suggestion = 0
end

local current_command = ""
local cursor_position = 1

local function next_char()
    return current_command:sub(cursor_position, cursor_position)
end

local function prev_char()
    return current_command:sub(cursor_position-1, cursor_position-1)
end

console.active = false

function console.keytyped(key)
    if key == " " and love.keyboard.isDown("lctrl", "rctrl") then 
        return 
    end
    local before = current_command:sub(1, cursor_position)
    local after  = current_command:sub(cursor_position)
    current_command = before .. key .. after
    cursor_position = cursor_position + 1
end

function console.keypressed(key)
    if key == "escape" then
        if #suggestions > 0 then
            clear_suggestions()
        else
            console.inactive = true
        end
    end
    if key == "left" and cursor_position > 1 then
        cursor_position = cursor_position - 1
        if next_char() == " " then
            clear_suggestions()
        end
    end
    if key == "right" and cursor_position < current_command:len() then
        cursor_position = cursor_position + 1
        if prev_char() == " " then
            clear_suggestions()
        end
    end
    if key == "up" and #suggestions > 0 then
        highlighted_suggestion = highlighted_suggestion - 1
        if highlighted_suggestion < 1 then
            highlighted_suggestion = #suggestions
        end
    end
    if key == "down" and #suggestions > 0 then
        highlighted_suggestion = highlighted_suggestion + 1
        if highlighted_suggestion > #suggestions then
            highlighted_suggestion = 1
        end
    end
    if key == "backspace" and cursor_position > 1 then
        local before = current_command:sub(1, cursor_position - 1)
        local after  = current_command:sub(cursor_position)
        current_command = before .. after
    end
    if key == "delete" and cursor_position < current_command:len() then
        local before = current_command:sub(1, cursor_position)
        local after  = current_command:sub(cursor_position + 1)
        current_command = before .. after
    end
    if key == "space" and love.keyboard.isDown("lctrl", "rctrl") then
        -- TODO: populate suggestions table from possible command/entity names
    elseif key == "space" then
        -- TODO: populate suggestions table from nearby entities
    end
    if key == "enter" or key == "return" then
        local success, error_message = console.command(current_command)
        table.insert(command_history, current_command)
        if success then
            current_command = ""
        else
            table.insert(output_history, error_message)
        end
    end
end

function console.command(command_string)
    local command = nil
    local args = {}
    for word in command_string:gmatch("%S+") do 
        if command == nil then
            command = word
        else
            table.insert(args, word)
        end
    end
    if not commands[command] then
        local msg = string.format("no command '%s'.", command)
        return false, msg
    end
    if commands[commands].entity_arg_count < #args then
        local msg = string.format("not enough args for '%s'. Expected %d, got %d", 
            command, commands[commands].entity_arg_count, #args)
        return false, msg
    end

    -- TODO: perform action
    print(string.format("performing '%s'...", command))
end

function console.update(dt)
    -- TODO: flash cursor
end

function console.draw()
    love.graphics.print(current_command, 0, 0)
    love.graphics.print(string.rep(" ", cursor_position) .. "|", 0, 0)
    -- TODO: draw suggestions somehow
end

return console
