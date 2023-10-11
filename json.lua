--Vars

-- Local functions
local function removeWhitespace(json_string)
    local new_json_string = ""
    local inside_quotes = false
    for i = 1, #json_string do
        local char = string.sub(json_string, i, i)
        if char ~= " " then
            new_json_string = new_json_string..char
        end
        if char == '"' then
            if not inside_quotes then
                inside_quotes = true
            else
                inside_quotes = false
            end
        end
        if char == " " and inside_quotes then
            new_json_string = new_json_string..char
        end
    end
    if inside_quotes then
        return "error while decoding json: invalid json string, non-closed quotes", nil
    end
    return nil, new_json_string
end

local function makeVariable(json_string)
    local text = ""
    local key = ""
    local value
    local found_colon = false
    for i = 1, #json_string do
        local char = string.sub(json_string, i, i)
        if char ~= '"' and char ~= ':' and not char ~= ',' then
            text = text..char
        end
        if char == ":" then
            found_colon = true
            key = text
            text = ""
        end
        if found_colon and i == #json_string then
           value = text
           if tonumber(value) ~= nil then
                value = tonumber(value)
           end    
        end
    end
    return key, value
end


local function makeObj(json_string, arrayfunc)
    local obj = {}
    local items = {}
    local item = ""
    local inside_brackets = false
    local inside_curlies = false
    for i = 2, #json_string -1 do
        local char = string.sub(json_string, i, i)
        if char == "{" then
            inside_curlies = true
        end
        if char == "}" then
            inside_curlies = false
        end
        if char == "[" then
            inside_brackets = true
        end
        if char == "]" then
            inside_brackets = false
        end
        if char == "," and not inside_brackets and not inside_curlies then
            items[#items + 1] = item
            item = ""
        else
            item = item..char
        end
    end
    items[#items + 1] = item

    for i = 1, #items do
        item = items[i]
        local after_colon = false
        local key = ""
        local value = ""
        for pos = 1, #item do
            local char = string.sub(item, pos, pos)
            if after_colon then
                value = value..char
            end
            if char == ":" then
                after_colon = true
            end
            if not after_colon then
                if char ~= '"' then
                    key = key..char
                end
            end
        end
        if string.sub(value, 1, 1) == "{" then
            local child_obj = makeObj(value, arrayfunc)
            obj[key] = child_obj  
            value = ""
            key = ""
        elseif string.sub(value, 1, 1) == "[" then
            local child_array = arrayfunc(value)
            obj[key] = child_array
            value = ""
            key = ""
        else
            if tonumber(value) ~= nil then
                value = tonumber(value)
            else
                value = string.sub(value, 2, #value - 1)
            end
            if value == "true" then
                value = true
            end
            if value == "false" then
                value = false
            end
            obj[key] = value
            value = ""
            key = ""
        end
    end
    return obj
end

local function makeArray(json_string)
    local array = {}
    local inside_quote = false
    local inside_curly = false
    local inside_brackets = false
    local value = ""
    for i=2, #json_string-1 do
        local char = string.sub(json_string, i, i)
        if char == '"' then
            if not inside_quote then
                inside_quote = true
            else
                inside_quote = false
            end
        end
        if char == '"' and (inside_curly or inside_brackets) then
            value = value..char
        elseif char ~= '"' then
            value = value..char
        end
        if char == '[' then
            inside_brackets = true
        end
        if char == "]" then
            inside_brackets = false
        end
        if char == '{' then
            inside_curly = true
        end
        if char == "}" then
            inside_curly = false
        end
        if char == "," and not inside_quote and not inside_curly and not inside_brackets then
            if string.sub(value, 1, 1) == "{" then
                value = makeObj(value, makeArray)
            elseif string.sub(value, 1, 1) == "[" then
                value = makeArray(value)
            end
            array[#array + 1] = value
            value = ""
        end
    end
    if string.sub(value, 1, 1) == "{" then
        value = makeObj(value, makeArray)
    elseif string.sub(value, 1, 1) == "[" then
        value = makeArray(value)
    end
    if value == "true" then
        value = true
    end
    if value == "false" then
        value = false
    end
    array[#array + 1] = value
    return array
end

--Functions
function decode(json_string)
    err, jsonstring = removeWhitespace(json_string)
    if err ~= nil then
        return err, nil
    end
    local obj = {}
    local first_char = string.sub(json_string, 1, 1)
    if first_char == "{" then
        obj = makeObj(json_string, makeArray)
    elseif first_char == "[" then
        obj = makeArray(json_string)
    end
    return nil, obj
end

function encode(lua_table)

end

