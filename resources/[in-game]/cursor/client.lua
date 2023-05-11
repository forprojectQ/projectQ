local cursor = "arrow"
local screen = Vector2(guiGetScreenSize())

function setPointer(pointer)
    if pointer then
        cursor = pointer
    end
end

bindKey("m", "down", function()
    local state = not isCursorShowing()
    showCursor(state)
    if state then
        cursor = "arrow"
        setCursorPosition(screen.x / 2, screen.y / 2)
    end
end)

gui_cursor_types={
    ["gui-edit"]="text",
    ["gui-memo"]="text",
    ["gui-button"]="hand",
    ["gui-checkbox"]="hand",
}

local active_gui = nil
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

setCursorAlpha(0)