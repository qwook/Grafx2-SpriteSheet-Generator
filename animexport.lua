
--ANIM: AnimExport v0.2
--Convert anim into a spritesheet.
--by Henry (github.com/qwook)

--[[
Copyright (c) 2015 Henry Tran

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

run("./libs/memory.lua")

arg = memory.load({xOffset = 0, yOffset = 0, spacing = 0, maxRow = 0})

ok, xOffset, yOffset, maxRow, spacing = inputbox("AnimExport",
    "X-Offset",             arg.xOffset,     0, 256, 0,
    "Y-Offset",             arg.yOffset,     0, 256, 0,
    "Max Sprite Per Row",   arg.maxRow,      0, 256, 0,
    "Spacing",              arg.spacing,     0, 32,  0
)

if ok == true then

    memory.save({xOffset = xOffset, yOffset = yOffset, spacing = spacing, maxRow = maxRow})

    -- get the number of layers in the picture
    function getLayerCount()
        local i = 0
        while (true) do
            local succ, err = pcall(selectlayer,i)
            if not succ then break end
            i = i+1
        end
        return i
    end

    local layercount = getLayerCount()
    local w, h = getpicturesize()

    local wSprite = w*layercount + spacing*layercount
    local hSprite = h

    -- our max row is set
    -- the spritesheet width and height should be different.
    if maxRow > 0 then
        local rows = math.min(maxRow, layercount)
        local cols = math.floor(layercount / maxRow)+1
        wSprite = w*rows
        hSprite = h*cols
    end

    -- local wPicture, hPicture = getsparepicturesize()
    -- setsparepicturesize(math.max(wPicture, wSprite + xOffset), math.max(hPicture, hSprite + yOffset))
    setsparepicturesize(wSprite + xOffset,hSprite + yOffset)

    -- for each layer, copy and paste the pixels to the brush.
    for layer = 0, layercount-1 do
        for x = 0, w-1 do
            for y = 0, h-1 do
                selectlayer(layer)
                local pixel = getpicturepixel(x, y)
                if maxRow > 0 then
                    local row = layer % maxRow
                    local col = math.floor(layer / maxRow)
                    putsparepicturepixel(x + w*row + spacing*row + xOffset, y + h*col + spacing*col + yOffset, pixel)
                else
                    putsparepicturepixel(x + w*layer + spacing*layer + xOffset, y + yOffset, pixel)
                end
            end
        end
    end
    updatescreen()

end