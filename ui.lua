--local vars
local width, height = term.getSize()
--vars
align = {}
align.left = 200
align.right = 201

navbar = {
    enabled = false,
    backgroundcolor = colors.lightGray,
    highlighted_backgroundcolor = colors.blue,
    highlighted_textcolor = colors.white,
    textcolor = colors.blue,
    top = true,
    items = {}
}

window = {
    x = 3,
    y = 3,
    width = 15,
    height = 30,
    name = "Window",
    enabled = false,
    fullscreen = false,
    background_color = colors.white,
    topbar_color = colors.gray,
    topbar_textcolor = colors.white,
    highlighted_exit = true,
    items = {}
}
--functions
function window:item()

end

function window:paint()
    for dx = 0, self.width - 1 do
        for dy = 0, self.height - 1 do
            term.setCursorPos(self.x + dx, self.y + dy)
            term.setBackgroundColor(self.background_color)
            if dy == 0 then
                term.setBackgroundColor(self.topbar_color)
            end
            term.write(" ")
        end
    end
    term.setCursorPos(self.x, self.y)
    term.setBackgroundColor(self.topbar_color)
    term.setTextColor(self.topbar_textcolor)
    term.write(self.name)
    term.setCursorPos(self.x + self.width - 1, self.y)
    term.setTextColor(colors.red)
    if self.highlighted_exit then
        term.setBackgroundColor(colors.red)
        term.setTextColor(colors.white)
    end
    write("x")
end

function navbar:item(_text, _align, _highlighted)
    table.insert(self.items, #self.items + 1, {_text, _align, _highlighted})
end

function navbar:paint()
    local y = 1
    if not self.top then
        y = height
    end
    term.setCursorPos(1,y)
    term.setBackgroundColor(self.backgroundcolor)
    term.clearLine()
    local right_x = width
    local left_x = 1
    for _, v in ipairs(self.items) do
        if v[2] == align.left then
            term.setCursorPos(left_x, y)
            left_x = left_x + #v[1] + 1
        elseif v[2] == align.right then
            term.setCursorPos(right_x - #v[1], y)
            right_x = right_x - #v[1] - 1
        end
        term.setBackgroundColor(self.backgroundcolor)
        term.setTextColor(self.textcolor)
        if v[3] then
            term.setBackgroundColor(self.highlighted_backgroundcolor)
            term.setTextColor(self.highlighted_textcolor)
        end
        term.write(v[1])
    end
end

function navbar:is_clicked(mouse, x, y)
    if mouse == 3 then
        return nil
    end
    if navbar.top then
        if y ~= 1 then
            return nil
        end
    end
    if not navbar.top then
        if y ~= height then
            return nil
        end
    end
    local right_x = width
    local left_x = 1
    for i, v in ipairs(self.items) do
        if v[2] == align.right then
            right_x = right_x - #v[1]
            if x >= right_x and x <= right_x + #v[1] - 1 then
                return i
            end
        elseif v[2] == align.left then
            if x >= left_x and x <= left_x + #v[1] - 1 then
                return i
            end
            left_x = left_x + #v[1] + 1
        end
    end
    return nil
end

function paint()
    if navbar.enabled then
        navbar:paint()
    end
end

function is_clicked(mouse, x, y)
    if navbar.enabled then
        local item = navbar:is_clicked(mouse, x, y)
        if item ~= nil then
            return "navbar", item
        end
    end
    return "", nil
end