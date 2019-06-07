
local char = {}
char.__index = char

function char.new(x, y, r)
    local self = {}
    setmetatable(self, char)

    self.x = x
    self.y = y
    self.r = r

    return self
end

function char:speed()
    -- @IDEA: can include any states like carrying, tired, etc.
    return 128 -- pixels per second
end

function char:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

function char:draw()
    love.graphics.circle("fill", self.x, self.y, 4)
end

return char
