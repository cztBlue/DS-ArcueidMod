local Badge = require "widgets/badge"

local VigourBadge = Class(Badge, function(self, owner)
	Badge._ctor(self, "vigour", owner)
	self.anim:GetAnimState():SetBank("sanity")
    self.anim:GetAnimState():SetBuild("vigour")
    self.anim:GetAnimState():PlayAnimation("anim")
	self:StartUpdating()
end)

function VigourBadge:OnUpdate(dt)
	local vigourpercent = self.owner.components.vigour:GetPercent()
	self:SetPercent(vigourpercent,TUNING.ARCUEID_MAXVIGOUR)
end

return VigourBadge