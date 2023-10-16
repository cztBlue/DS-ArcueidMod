local Widget = require "widgets/widget"
local Image = require "widgets/image"


local BlindScreen = Class(Widget, function(self, owner)
	self.owner = owner
	Widget._ctor(self, "BloodOver")
	self:SetClickable(false)

	self.img = self:AddChild(Image("images/fx.xml", "blood_over.tex"))
	self.img:SetEffect("shaders/uifade.ksh")
	self.img:SetHAnchor(ANCHOR_MIDDLE)
	self.img:SetVAnchor(ANCHOR_MIDDLE)
	self.img:SetScaleMode(SCALEMODE_FILLSCREEN)

	self:Show()
	self.laststep = 0

	self.alpha_min = 0.3
	self.alpha_min_target = 1
end)

function BlindScreen:OnUpdate()
	if GetPlayer().components.arcueidbuff then
		if GetPlayer().components.arcueidbuff.buff_modifiers_add_timer['buff_blindness'] == nil or
			(GetPlayer().components.arcueidbuff.buff_modifiers_add_timer['buff_blindness'] ~= nil
				and GetPlayer().components.arcueidbuff.buff_modifiers_add_timer['buff_blindness'] <= 0) then
			self.alpha_min = 1
		end

		if GetPlayer().components.arcueidbuff.buff_modifiers_add_timer['buff_blindness'] ~= nil and
			GetPlayer().components.arcueidbuff.buff_modifiers_add_timer['buff_blindness'] > 0 and
			GetPlayer().components.arcueidbuff.buff_modifiers_add_timer['buff_blindness'] <= 5 then
			self.alpha_min = 1 - (GetPlayer().components.arcueidbuff.buff_modifiers_add_timer['buff_blindness'] / 5.0)
		elseif GetPlayer().components.arcueidbuff.buff_modifiers_add_timer['buff_blindness'] ~= nil and
			GetPlayer().components.arcueidbuff.buff_modifiers_add_timer['buff_blindness'] > 5 then
			self.alpha_min = 0
		end
	else
		self.alpha_min = 1
	end
	self.img:SetAlphaRange(self.alpha_min, 1)
		if self.alpha_min >= .99 then
			self:Hide()
		else
			self:Show()
		end
end

return BlindScreen
