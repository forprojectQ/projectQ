local screen = Vector2(guiGetScreenSize())
setCursorAlpha(0)

bindKey("m", "down", function()
    if (isCursorShowing()) then
        showCursor(false)
    else
        showCursor(true)
    end
end)

addEventHandler("onClientRender", root, function()
    if (isCursorShowing()) then
        local cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX * screen.x, cursorY * screen.y
        dxDrawImage(cursorX, cursorY, 36, 36, "assets/cursor.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
    end
end, true, "low-9999")