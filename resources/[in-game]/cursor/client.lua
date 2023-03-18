local cursor = "arrow"
local screen = Vector2(guiGetScreenSize())

function setPointer(result)
	cursor = result
end

bindKey("m", "down", function()
    if (isCursorShowing()) then
        showCursor(false)
    else
		cursor = "arrow"
		setCursorPosition(screen.x/2, screen.y/2)
        showCursor(true)
    end
end)

addEventHandler("onClientRender", root, function()
    if (isCursorShowing()) then
        local cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX * screen.x, cursorY * screen.y
        dxDrawImage(cursorX, cursorY, 32, 32, "assets/"..(cursor or "arrow")..".png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
    end
end, true, "low-9999")

setCursorAlpha(0)