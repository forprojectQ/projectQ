local cursor = "arrow"
local screen = Vector2(guiGetScreenSize())
local active_gui = nil
local gui_cursor_types={
    ["gui-edit"]="text",
    ["gui-memo"]="text",
    ["gui-button"]="hand",
    ["gui-checkbox"]="hand",
}

setCursorAlpha(0)

function setPointer(pointer)
    if pointer then
        cursor = pointer
    end
end

bindKey("m", "down", function()
    local state = not isCursorShowing()
    showCursor(state)
    if state then
        cursor, active_gui = "arrow", nil
        setCursorPosition(screen.x / 2, screen.y / 2)
    end
end)

addEventHandler("onClientMouseEnter",root,function()
    local type = getElementType(source)
    if gui_cursor_types[type] then
        active_gui,cursor=source,gui_cursor_types[type]
    end    
end)

addEventHandler("onClientMouseLeave",root,function()
    local type = getElementType(source)
    if gui_cursor_types[type] then
        active_gui,cursor=nil,"arrow"
    end  
end)

addEventHandler("onClientRender", root, function()
    if (isCursorShowing()) then
        local cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX * screen.x, cursorY * screen.y
        dxDrawImage(cursorX, cursorY, 32, 32, "assets/"..(cursor or "arrow")..".png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
        if cursor ~= "arrow" and not isElement(active_gui) then
            cursor = "arrow"
        end
    end
end, true, "low-9999")
