nametag = class("NAMETAG")

function nametag:init()
    self:loadAssets()
    self.functions = {
        render = function(...) self:render(...) end
    }
    addEventHandler("onClientRender", root, self.functions.render, true, "low-9999")
end

function nametag:loadAssets()
    assert(loadstring(exports.dxlibrary:loadFunctions()))()
    self.fonts = {
        awesome = exports.fonts:getFont("AwesomeRegular", 20),
        awesome2 = exports.fonts:getFont("AwesomeSolid", 23),
        robotoB = exports.fonts:getFont("RobotoB", 11),
        roboto = exports.fonts:getFont("Roboto", 12),
    }
end

function nametag:render()
    if localPlayer:getData("online") then
        for i, v in ipairs(Element.getAllByType("player")) do 
            if v.onScreen then 
                if v:getData("online") then
                    local lx, ly, lz = localPlayer.position.x, localPlayer.position.y, localPlayer.position.z
                    local rx, ry, rz = getPedBonePosition( v, 5 )
                    local distance = getDistanceBetweenPoints3D(lx, ly, lz, rx, ry, rz)
                    if localPlayer:getTarget() == v or distance < 12 then 
                        local sx, sy = getScreenFromWorldPosition(rx, ry, rz+0.3, 100, false)
                        local name = v.name
                        local id = v:getData("playerid")
                        local r, g, b = v:getNametagColor()
                        local dbid = v:getData("dbid")
                        -- OYUNCU İSMİ
                        dxDrawText(""..name.." ("..id..")", sx+1, sy, sx+1, sy, tocolor(0, 0, 0, 255), 1, self.fonts.robotoB, "center", "center", false, false, false, false, false)
                        dxDrawText(""..name.." ("..id..")", sx-1, sy, sx-1, sy, tocolor(0, 0, 0, 255), 1, self.fonts.robotoB, "center", "center", false, false, false, false, false)
                        dxDrawText(""..name.." ("..id..")", sx, sy+1, sx, sy+1, tocolor(0, 0, 0, 255), 1, self.fonts.robotoB, "center", "center", false, false, false, false, false)
                        dxDrawText(""..name.." ("..id..")", sx, sy-1, sx, sy-1, tocolor(0, 0, 0, 255), 1, self.fonts.robotoB, "center", "center", false, false, false, false, false)
                        dxDrawText(""..name.." #800000("..id..")", sx, sy, sx, sy, tocolor(r, g, b, 255), 1, self.fonts.robotoB, "center", "center", false, false, false, true, false)
                    end
                end
            end
        end
    end
end

nametag:new()