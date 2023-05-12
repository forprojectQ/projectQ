function ui:members()
    dxDrawRoundedRectangle(self.x+200, self.y+25, self.w-220, 75, 12, tocolor(65, 67, 74))
    dxDrawRectangle(self.x+200, self.y+45, self.w-220, 75, tocolor(65, 67, 74))
    dxDrawRectangle(self.x+200, self.y+45+75, self.w-220, 2, tocolor(255, 255, 255, 125))
end