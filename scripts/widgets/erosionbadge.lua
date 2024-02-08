local ImageButton = require "widgets/imagebutton"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local Text = require "widgets/text"

local bar_bg_x = -55
local bar_bg_y = 80

local erosion = Class(Widget, function(self, owner)
    Widget._ctor(self, "erosion")
    self.owner = owner

    self.bar_bg = self:AddChild(Image("images/arcueid_gui/erosionbar.xml", "erosionbar.tex"))
    self.fill = self:AddChild(Image("images/arcueid_gui/erosionbar.xml", "edark_20.tex"))
    self.num_bg = self:AddChild(Image("images/arcueid_gui/num_bg.xml", "num_bg.tex"))
    self.num = self:AddChild(Text(NUMBERFONT, 24, "120", { 255, 0, 0, 1 }))

    self.bar_bg:SetVAnchor(ANCHOR_MIDDLE)
    self.bar_bg:SetHAnchor(ANCHOR_RIGHT)
    self.bar_bg:SetScale(.55, .55, .55)
    self.bar_bg:SetPosition(bar_bg_x, bar_bg_y, 0)
    self.fill:SetVAnchor(ANCHOR_MIDDLE)
    self.fill:SetHAnchor(ANCHOR_RIGHT)
    self.fill:SetScale(.55, .55, .55)
    self.fill:SetPosition(bar_bg_x, bar_bg_y, 0)

    self.num_bg:SetVAnchor(ANCHOR_MIDDLE)
    self.num_bg:SetHAnchor(ANCHOR_RIGHT)
    self.num_bg:SetScale(.4, .5, .4)
    self.num_bg:SetPosition(self.bar_bg:GetPosition() + Vector3(0, -110, 0))

    self.num:SetVAnchor(ANCHOR_MIDDLE)
    self.num:SetHAnchor(ANCHOR_RIGHT)
    self.num:SetPosition(self.bar_bg:GetPosition() + Vector3(5, -110, 0))

    self.num:Show()
    self.bar_bg:Show()
    self.num_bg:Show()
    self.fill:Show()
    self:StartUpdating()
end)

function erosion:recal()
    local player = GetPlayer()
    if player then
        local erosion = player.components.arcueidstate.nightmarerosion
        if erosion then
            local percent = (erosion / TUNING.ARCUEID_MAXEROSION)
            local fillImageNumber = math.floor(percent * 20)
            if fillImageNumber == 0 then fillImageNumber = 1 end
            self.fill:SetPosition(bar_bg_x, bar_bg_y-(21-fillImageNumber)*(81/20), 0)
            self.fill:SetTexture("images/arcueid_gui/erosionbar.xml", "edark_" .. fillImageNumber .. ".tex")
            if erosion <= 10 then self.fill:Hide() end
            self.num:SetString(tostring(math.floor(erosion)))
        end
    end
end

function erosion:OnUpdate(dt)
    self:recal()
end

return erosion
