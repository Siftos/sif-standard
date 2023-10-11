--local vars
local width, height = term.getSize()
--vars
align = {}
align.left = 200
align.right = 201

navbar = {
    backgroundcolor = colors.lightGray,
    highlighted_backgroundcolor = colors.blue,
    highlighted_textcolor = colors.white,
    textcolor = colors.blue,
    top = true,
    items = {}
}
--functions
function navbar:item(_text, _align, _highlighted)
    table.insert(self.items, #self.items + 1, {text = _text, align = _align, highlighted = _highlighted})
end

function navbar:paint()
    y = 1
    if not self.top then
        y = height
    end
    term.setCursorPos(1,y)
    term.setBackgroundColor(self.backgroundcolor)
    term.clearLine()
    right_x = width
    left_x = 1
    for _, v in ipairs(self.items) do
        if v.align == align.left then
            term.setCursorPos(left_x, y)
            left_x = left_x + #v.text
        elseif v.align == align.right then
            term.setCursorPos(right_x - #v.text, y)
            right_x = right_x - #v.text
        end
        term.setBackgroundColor(self.backgroundcolor)
        term.setTextColor(self.textcolor)
        if v.highlighted then
            term.setBackgroundColor(self.highlighted_backgroundcolor)
            term.setTextColor(self.highlighted_textcolor)
        end
        term.write(v.text)
    end
end