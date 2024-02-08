local Widget = require "widgets/widget"
local Image = require "widgets/image"


local BloodScreen = Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "BloodScreen")
	self:SetClickable(false)

	self.img = self:AddChild(Image("images/bloodscreen.xml", "bloodscreen_border.tex"))
	self.img:SetEffect( "shaders/uifade.ksh" )
    self.img:SetHAnchor(ANCHOR_MIDDLE)
    self.img:SetVAnchor(ANCHOR_MIDDLE)
    self.img:SetScaleMode(SCALEMODE_FILLSCREEN)

	self.img2 = self:AddChild(Image("images/bloodscreen.xml", "bloodscreen_c1.tex"))
	self.img2:SetEffect( "shaders/uifade.ksh" )
    self.img2:SetHAnchor(ANCHOR_MIDDLE)
    self.img2:SetVAnchor(ANCHOR_MIDDLE)
    self.img2:SetScaleMode(SCALEMODE_FILLSCREEN)

	self.img3 = self:AddChild(Image("images/bloodscreen.xml", "bloodscreen_c2.tex"))
	self.img3:SetEffect( "shaders/uifade.ksh" )
    self.img3:SetHAnchor(ANCHOR_MIDDLE)
    self.img3:SetVAnchor(ANCHOR_MIDDLE)
    self.img3:SetScaleMode(SCALEMODE_FILLSCREEN)

	self.img4 = self:AddChild(Image("images/bloodscreen.xml", "bloodscreen_c3.tex"))
	self.img4:SetEffect( "shaders/uifade.ksh" )
    self.img4:SetHAnchor(ANCHOR_MIDDLE)
    self.img4:SetVAnchor(ANCHOR_MIDDLE)
    self.img4:SetScaleMode(SCALEMODE_FILLSCREEN)

    self:Show()
    self.laststep = 0
    
    self.alpha_min = 0.3
    self.alpha_min_target = 1
	self:StartUpdating()
end)

function BloodScreen:OnUpdate()
	if GetPlayer().components.arcueidstate then
		self.alpha_min = 1- (GetPlayer().components.arcueidstate.iceskill_cooldown / 10.5) 
	else
		self.alpha_min = 1
	end
	
	self.img:SetAlphaRange(self.alpha_min,1)
	
	if self.alpha_min >= .99 then
		self:Hide()
	else
		self:Show()
	end
end



return BloodScreen