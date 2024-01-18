--buling_system的UI代码，还没改
local Screen = require "widgets/screen"
local Button = require "widgets/button"
local AnimButton = require "widgets/animbutton"
local ImageButton = require "widgets/imagebutton"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local Text = require "widgets/text" 
local TextButton = require "widgets/textbutton" 
require "util"


buling_system = Class(Widget, function(self,owner)
	Widget._ctor(self, "yanjiu")
    self.owner = owner
	GetPlayer():ListenForEvent("OpenBuling_system",function()
		self:Open()
	end)
	self.IsUIShow =false
    SetPause(true,"pause")
    self.root = self:AddChild(Widget("ROOT"))
    self.root:SetVAnchor(ANCHOR_MIDDLE)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    self.root:SetPosition(0,0,0)
    self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
	self.image = self:AddChild(Image("images/bulingui/bulingui.xml", "bulingui.tex"))
	self.image:SetPosition(0, 0, 0)
	self.closebutton = self:AddChild(ImageButton("images/bulingui/buling_close.xml", "buling_close.tex"))
	self.closebutton:SetPosition(300, 300, 0)
	self.closebutton:SetOnClick(
	function ()
		self:Close()
	end)
	self.txt = self:AddChild(Text(BODYTEXTFONT, 25,STRINGS['TASK'..GetPlayer().components.buling_task.tasknum]))
	self.txt:SetPosition(0, 0, 0)
	self.bulingbutton = self:AddChild(ImageButton("images/bulingui/buling_button.xml", "buling_button.tex"))
	self.bulingbutton:SetPosition(20, -220, 0)
	self.bulingbutton:SetOnClick(
	function ()
		if GetPlayer().components.buling_task:Getitem() == nil then
			GetPlayer().components.buling_task:nexttask()
		else
			if GetPlayer().components.inventory:Has(GetPlayer().components.buling_task:Getitem(),GetPlayer().components.buling_task:Getitemnum()) then
				GetPlayer().components.buling_task:itemnexttask()
			end
		end
	end)
	self:StartUpdating()
end)
function buling_system:OnUpdate(dt)
	self.txt:SetString(STRINGS['TASK'..GetPlayer().components.buling_task.tasknum])
end
function buling_system:Open()
	self:Show()
end
function buling_system:Close()
	self:Hide()
end
return buling_system