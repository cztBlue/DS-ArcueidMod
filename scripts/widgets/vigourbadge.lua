local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local VigourBadge = Class(Badge, function(self, owner)
	Badge._ctor(self, "vigour", owner)
	self.owner = owner
	self.anim:GetAnimState():SetBank("sanity")
    self.anim:GetAnimState():SetBuild("vigour")
    self.anim:GetAnimState():PlayAnimation("anim")

	self.topperanim = self.underNumber:AddChild(UIAnim())
    self.topperanim:GetAnimState():SetBank("wet")
    self.topperanim:GetAnimState():SetBuild("wet_meter_player")
    self.topperanim:SetClickable(false)

	self.vigourarrow = self.underNumber:AddChild(UIAnim())
	self.vigourarrow:GetAnimState():SetBank("sanity_arrow")
	self.vigourarrow:GetAnimState():SetBuild("sanity_arrow")
	self.vigourarrow:GetAnimState():PlayAnimation("neutral")
	self.vigourarrow:SetClickable(false)

	self.arrowdir = "neutral"
	owner.vigourarrow = self.vigourarrow
	self:StartUpdating()
end)

function VigourBadge:OnUpdate(dt)
	local vigourpercent = self.owner.components.vigour:GetPercent()
	self:SetPercent(vigourpercent,TUNING.ARCUEID_MAXVIGOUR)

	--vigourbuff动画
	local rate = GetPlayer().components.vigour:GetRate()
	local small_down = .02
	local med_down = .1
	local large_down = .3
	local small_up = .01
	local med_up = .1
	local large_up = .2
	local anim = nil
	anim = "neutral"
	if rate > 0  then
		if rate > large_up then
			anim = "arrow_loop_increase_most"
		elseif rate > med_up then
			anim = "arrow_loop_increase_more"
		elseif rate > small_up then
			anim = "arrow_loop_increase"
		end
	elseif rate < 0  then
		if rate < -large_down then
			anim = "arrow_loop_decrease_most"
		elseif rate < -med_down then
			anim = "arrow_loop_decrease_more"
		elseif rate < -small_down then
			anim = "arrow_loop_decrease"
		end
	end
	
	if anim and self.arrowdir ~= anim then
		self.arrowdir = anim
		self.vigourarrow:GetAnimState():PlayAnimation(anim, true)
	end
end

return VigourBadge