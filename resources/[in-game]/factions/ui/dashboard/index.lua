function ui:dashboard()
    --// SAYFA BAŞLIĞI
    dxDrawText("Birlik Panosu", self.x+210, self.y+30, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoBBig)
    dxDrawText("Lorem İpsum Lorem İpsum Lorem İpsum Lorem İpsum.", self.x+210, self.y+50, nil, nil, tocolor(175, 175, 175), 1, self.fonts.robotoSmall)

    --// BİLGİ KUTUCUKLARI ...
    dxDrawRectangle(self.x+200+self.w/2-15, self.y+25, 185, self.h-50, tocolor(65, 67, 74))
    dxDrawRoundedRectangle(self.x+200+self.w/2, self.y+25, 185, self.h-50, 12, tocolor(65, 67, 74))

    dxDrawRoundedRectangle(self.x+200+self.w/2-7, self.y+45, 185, 60, 8, tocolor(39, 41, 46))
    dxDrawRectangle(self.x+200+self.w/2-7, self.y+55, 2, 40, tocolor(88, 101, 242, 125))

    dxDrawRoundedRectangle(self.x+200+self.w/2-7, self.y+45+65, 185, 60, 8, tocolor(39, 41, 46))
    dxDrawRectangle(self.x+200+self.w/2-7, self.y+55+65, 2, 40, tocolor(88, 101, 242, 125))

    dxDrawRoundedRectangle(self.x+200+self.w/2-7, self.y+45+65*2, 185, 60, 8, tocolor(39, 41, 46))
    dxDrawRectangle(self.x+200+self.w/2-7, self.y+55+65*2, 2, 40, tocolor(88, 101, 242, 125))
end