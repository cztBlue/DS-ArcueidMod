--UTF-8编码

local Screen = require "widgets/screen"
local Menu = require "widgets/menu"
local Widget = require "widgets/widget"
local TextEdit = require "widgets/textedit"

local VALID_CHARS = [[ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,:;[]\@!#$%&()'*+-/=?^_{|}~"]]

--------------------------------------------------------------------------------------------------------------------------------------------------

local EditScreen = Class(Screen, function(self, attach)
	Screen._ctor(self, "EditScreen")

	self.active = true
	SetPause(true,"pause")

	self.attach = attach
	
	self.root = self:AddChild(Widget("ROOT"))
	self.root:SetVAnchor(ANCHOR_MIDDLE)
	self.root:SetHAnchor(ANCHOR_MIDDLE)
	self.root:SetPosition(0,0,0)
	self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
    
	local shield = self.root:AddChild( Image( "images/globalpanels.xml", "panel.tex" ) )
	shield:SetPosition( 0,0,0 )
	shield:SetSize( 500, 300 )

	local label_height = 50
	local signtext_offset = 30
	local fontsize = 30
	local edit_width = 350
	local edit_bg_padding = 60

    self.signtext_bg = self.root:AddChild( Image() )
	self.signtext_bg:SetTexture( "images/ui.xml", "textbox_long.tex" )
	self.signtext_bg:SetPosition( 0, signtext_offset, 0 )
	self.signtext_bg:ScaleToSize( edit_width + edit_bg_padding, label_height )

	self.signtext = self.root:AddChild( TextEdit( BODYTEXTFONT, fontsize, self.text or "") )
	self.signtext:SetPosition( 0, signtext_offset, 0 )
	self.signtext:SetRegionSize( edit_width, label_height )
	self.signtext:SetHAlign(ANCHOR_LEFT)
	self.signtext:SetFocusedImage( self.signtext_bg, UI_ATLAS, "textbox_long_over.tex", "textbox_long.tex" )
	self.signtext:SetTextLengthLimit(60)
	self.signtext:SetCharacterFilter(VALID_CHARS)

--	self.signtext:SetEditing(true)

	self.menu = self.root:AddChild(Menu(nil, 200, true))
	self.menu:SetPosition(-50, -70 ,0)
	self.menu:SetScale(0.6)
	self.menu:AddItem("写入", function() self:OnOK(true) end)
	self.menu:AddItem("取消", function() self:OnOK() end)

	self.default_focus = self.signtext
	
	self.signtext:SetEditing(true)
end)

function EditScreen:OnOK(bool)
	if bool then
		local text = self.signtext:GetLineEditString()
		if text and string.len(text) > 0 and self.attach.components.signable then
			self.attach.components.signable:SetText(text)
			self.attach.components.signable.signed = true
		end
	end
	self.active = false
	SetPause(false)
	TheFrontEnd:PopScreen()
end

function EditScreen:OnRawKey(key, down)
	if not down and key == KEY_ENTER then
		self:OnOK(true)
		return true
	end
	if EditScreen._base.OnRawKey(self, key, down) then return true end
	return false
end

function EditScreen:OnControl(control, down)
	if EditScreen._base.OnControl(self,control, down) then return true end

	if (control == CONTROL_PAUSE or control == CONTROL_CANCEL) and not down then	
		self:OnOK()
		return true
	end
end

function EditScreen:OnUpdate(dt)
	if self.active then
		SetPause(true)
	end
end

return EditScreen