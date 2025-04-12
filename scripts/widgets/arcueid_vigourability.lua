local ImageButton = require "widgets/imagebutton"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
require "util"

VigourAbilityPanel = Class(Widget, function(self, owner)
	Widget._ctor(self, "vigourabilitypanel")
    self.owner = owner
    -- self.selected = false
    local offset_y = 100
    local offset_x = 100

    self.heart_button = self:AddChild(ImageButton( "images/arcueid_gui/arcueid_ui.xml", "bheart_icon.tex", "bheart_icon.tex", "bheart_icon.tex" ))
    self.heart_button:SetScale(.8,.8,.8)
    self.heart_button:SetOnClick( function() self.owner.components.arcueidstate.abilityselected = 1 end )
    self.heart_button:SetVAnchor(ANCHOR_MIDDLE)
    self.heart_button:SetHAnchor(ANCHOR_MIDDLE)
    self.heart_button:SetPosition(Vector3(-offset_x, 0, 0))

    self.brain_button = self:AddChild(ImageButton( "images/arcueid_gui/arcueid_ui.xml", "bbrain_icon.tex", "bbrain_icon.tex", "bbrain_icon.tex" ))
    self.brain_button:SetScale(.8,.8,.8)
    self.brain_button:SetOnClick( function() self.owner.components.arcueidstate.abilityselected = 2 end )
    self.brain_button:SetVAnchor(ANCHOR_MIDDLE)
    self.brain_button:SetHAnchor(ANCHOR_MIDDLE)
    self.brain_button:SetPosition(Vector3(0, offset_y, 0))

    self.stomach_button = self:AddChild(ImageButton( "images/arcueid_gui/arcueid_ui.xml", "bstomach_icon.tex", "bstomach_icon.tex", "bstomach_icon.tex" ))
    self.stomach_button:SetScale(.8,.8,.8)
    self.stomach_button:SetOnClick( function() self.owner.components.arcueidstate.abilityselected = 3 end )
    self.stomach_button:SetVAnchor(ANCHOR_MIDDLE)
    self.stomach_button:SetHAnchor(ANCHOR_MIDDLE)
    self.stomach_button:SetPosition(Vector3(offset_x, 0, 0))

    self.heart_button:Hide()
    self.brain_button:Hide()
    self.stomach_button:Hide()
	self:StartUpdating()
end)

function  VigourAbilityPanel:Open()
    self.heart_button:Show()
    self.brain_button:Show()
    self.stomach_button:Show()
end

function  VigourAbilityPanel:Close()
    self.heart_button:Hide()
    self.brain_button:Hide()
    self.stomach_button:Hide()
end

function VigourAbilityPanel:OnUpdate(dt)
    if self.owner.components.arcueidstate.abilityon == true and self.owner.components.arcueidstate.abilityselected == 0 then
        self:Open()
    else
        self:Close()
    end
end

return VigourAbilityPanel