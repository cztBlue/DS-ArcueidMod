local ImageButton = require "widgets/imagebutton"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
require "util"

GemgeneratorPanel = Class(Widget, function(self, owner)
	Widget._ctor(self, "gempanel")
	self.generator = nil
	self.bg = self:AddChild(Image("images/arcueid_gui/arcueid_ui.xml", "arcueid_panel.tex"))
	self.Des = self:AddChild(Text(NUMBERFONT, 27, "ooo", { 255, 0, 0, 1 }))
	self.Stat = self:AddChild(Text(NUMBERFONT, 27, "ooo", { 255, 0, 0, 1 }))
	self.Textmare = self:AddChild(Text(NUMBERFONT, 27, "000/200", { 255, 0, 0, 1 }))
	self.Textmoon = self:AddChild(Text(NUMBERFONT, 27, "000/200", { 255, 0, 0, 1 }))
	self.StarChargeButton = self:AddChild(ImageButton("images/ui.xml", "button_small.tex"))
	self.TurnButton = self:AddChild(ImageButton("images/ui.xml", "button_small.tex"))

	self.bg:SetVAnchor(ANCHOR_MIDDLE)
	self.bg:SetHAnchor(ANCHOR_MIDDLE)
	self.bg:SetPosition(Vector3(200, 115, 0))
	self.bg:SetScale(.7, .7, 1)

	self.Textmare:SetVAnchor(ANCHOR_MIDDLE)
	self.Textmare:SetHAnchor(ANCHOR_MIDDLE)
	self.Textmare:SetPosition(self.bg:GetPosition() + Vector3(0, 100, 0))

	self.Textmoon:SetVAnchor(ANCHOR_MIDDLE)
	self.Textmoon:SetHAnchor(ANCHOR_MIDDLE)
	self.Textmoon:SetPosition(self.bg:GetPosition() + Vector3(0, 60, 0))

	self.Stat:SetVAnchor(ANCHOR_MIDDLE)
	self.Stat:SetHAnchor(ANCHOR_MIDDLE)
	self.Stat:SetPosition(self.bg:GetPosition() + Vector3(0, 20, 0))

	self.Des:SetVAnchor(ANCHOR_MIDDLE)
	self.Des:SetHAnchor(ANCHOR_MIDDLE)
	self.Des:SetPosition(self.bg:GetPosition() + Vector3(0, -40, 0))

	self.StarChargeButton:SetVAnchor(ANCHOR_MIDDLE)
	self.StarChargeButton:SetHAnchor(ANCHOR_MIDDLE)
	self.StarChargeButton:SetPosition(self.bg:GetPosition() + Vector3(-50, -100, 0))
	self.StarChargeButton:SetTextSize(27)
	self.StarChargeButton:SetScale(.8,.8,.8)
	self.StarChargeButton:SetText(" ")
	self.StarChargeButton:SetOnClick(function ()
		if self.generator then
			self.generator.startcharge = not self.generator.startcharge
		end
	end)

	self.TurnButton:SetVAnchor(ANCHOR_MIDDLE)
	self.TurnButton:SetHAnchor(ANCHOR_MIDDLE)
	self.TurnButton:SetPosition(self.bg:GetPosition() + Vector3(50, -100, 0))
	self.TurnButton:SetTextSize(27)
	self.TurnButton:SetScale(.8,.8,.8)
	self.TurnButton:SetText(" ")
	self.TurnButton:SetOnClick(function ()
		if self.generator then
			self.generator.canproduct_ = not self.generator.canproduct_
		end
	end)

	--inst is Player
	GetPlayer():ListenForEvent("OpenGemPanel", function(inst, data)
		self.generator = data.generator
		self:Open()
	end)
	GetPlayer():ListenForEvent("CloseGemPanel", function(inst, data)
		self:Close()
	end)

	self.Textmoon:Hide()
	self.Textmare:Hide()
	self.Stat:Hide()
	self.Des:Hide()
	self.bg:Hide()
	self.StarChargeButton:Hide()
	self.TurnButton:Hide()
	self:StartUpdating()
end)

function GemgeneratorPanel:Open()
	self.Textmoon:Show()
	self.Textmare:Show()
	self.Des:Show()
	self.Stat:Show()
	self.bg:Show()
	self.StarChargeButton:Show()
	self.TurnButton:Show()
end

function GemgeneratorPanel:Close()
	self.Textmoon:Hide()
	self.Textmare:Hide()
	self.Stat:Hide()
	self.Des:Hide()
	self.bg:Hide()
	self.StarChargeButton:Hide()
	self.TurnButton:Hide()
end

local sumdt = 0
function GemgeneratorPanel:OnUpdate(dt)
	-- 差分优化
	if sumdt < 1 then
		sumdt = sumdt + dt
		return
	else
		sumdt = 0
	end
	local default = ""
	if self.generator then
		self.Textmoon:SetString("月化燃料:"..self.generator.moonvalue .. "/200")
		self.Textmare:SetString("暗影燃料:"..self.generator.marevalue .. "/200")
		self.Des:SetString(self.generator.des)
		local strstat = "状态："

		if self.generator.components.container:GetItemInSlot(1) 
		and self.generator.components.container:GetItemInSlot(1).prefab == "trinket_twelvedice" then
			strstat = strstat .. "已翻转 "
		else
			strstat = strstat .. "未翻转 "
		end

		if self.generator.canproduct_ then
			strstat = strstat .. "已启动 "
			self.TurnButton:SetText("制动")
		else
			strstat = strstat .. "制动中 "
			self.TurnButton:SetText("开机")
		end

		if self.generator.startcharge then
			strstat = strstat .. "充能开启 "
			self.StarChargeButton:SetText("停止充能")
		else
			strstat = strstat .. "充能阻塞 "
			self.StarChargeButton:SetText("开始充能")
		end
		self.Stat:SetString(strstat)
	else
		self.Textmare:SetString(default)
		self.Textmoon:SetString(default)
		self.Stat:SetString(default)
		self.Des:SetString(default)
		self.Des:SetString(default)
	end
end

return GemgeneratorPanel
