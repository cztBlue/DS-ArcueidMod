local Widget = require "widgets/widget"
local Image = require "widgets/image"


local IceScreen = Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "IceOver")
	self:SetClickable(false)

	self.img = self:AddChild(Image("images/fx.xml", "ice_over.tex"))
	self.img:SetEffect( "shaders/uifade.ksh" )
    self.img:SetHAnchor(ANCHOR_MIDDLE)
    self.img:SetVAnchor(ANCHOR_MIDDLE)
    self.img:SetScaleMode(SCALEMODE_FILLSCREEN)

    self:Show()
    self.laststep = 0
    
    self.alpha_min = 0.3
    self.alpha_min_target = 1
end)

function IceScreen:OnUpdate()
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



return IceScreen