--letter_normal的UI代码，还没改
local Screen = require "widgets/screen"
local Button = require "widgets/button"
local AnimButton = require "widgets/animbutton"
local ImageButton = require "widgets/imagebutton"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local Text = require "widgets/text" 
local TextButton = require "widgets/textbutton" 
require "util"

local letter_normal = Class(Widget, function(self,owner)
	Widget._ctor(self, "letter")
    self.owner = owner
	self.total_page = 0
	self.letterid = 0
	self.curpagenum = 0
	self.IsUIShow =false
    SetPause(true,"pause")
    self.root = self:AddChild(Widget("ROOT"))
    self.root:SetVAnchor(ANCHOR_MIDDLE)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    self.root:SetPosition(0,0,0)
    self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
	--背景
	self.image = self:AddChild(Image("images/arcueid_gui/letter_paper.xml", "letter_paper.tex"))
	self.image:SetPosition(0, 0, 0)
	self.image:SetScale(.85,.85,.85)
	--叉
	self.closebutton = self:AddChild(ImageButton("images/arcueid_gui/arcueid_close.xml", "arcueid_close.tex"))
	self.closebutton:SetPosition(450, 300, 0)
	self.closebutton:SetScale(.85,.85,.85)
	self.closebutton:SetOnClick(
	function ()
		self:Close()
	end)

	--文本(BODYFONT,TITLEFONT,NUMBERFONT,UIFONT,TALKINGFONT)
	-- self.txt = self:AddChild(Text(UIFONT, 25,STRINGS.LETTERCONTENT["ID"..tostring(self.letterid)]))
	self.txt = self:AddChild(Text(UIFONT, 25,""))

	GetPlayer():ListenForEvent("OpenNormalLetter",function(inst,data)
		self.letterid = data.letterid 
		self.total_page = data.total 
		self.txt:SetString(STRINGS.LETTERCONTENT["ID"..tostring(self.letterid).."_"..tostring(self.curpagenum)])
		self:Open()
	end)
	self.txt:SetPosition(0, 0, 0)
	self.txt:SetHAlign(ANCHOR_LEFT)

	--翻页
	self.arrow_l = self.image:AddChild(ImageButton("images/arcueid_gui/turnarrow_icon.xml", "turnarrow_icon.tex")) --上一页
	self.arrow_l:SetPosition(-630, 0, 0)
	self.arrow_l:SetOnClick(function()
		if self.curpagenum  >=  1 then
			self.curpagenum = self.curpagenum - 1
		end
		self.txt:SetString(STRINGS.LETTERCONTENT["ID"..tostring(self.letterid).."_"..tostring(self.curpagenum)])
	end)
	self.arrow_l:SetScale(2, 2, 2)
	self.arrow_r = self.image:AddChild(ImageButton("images/hud.xml", "turnarrow_icon.tex")) --下一页
	self.arrow_r:SetPosition(630, 0, 0)
	self.arrow_r:SetOnClick(function()
		if self.curpagenum < self.total_page - 1 then
			self.curpagenum = self.curpagenum + 1
		end
		self.txt:SetString(STRINGS.LETTERCONTENT["ID"..tostring(self.letterid).."_"..tostring(self.curpagenum)])
	end)
	self.arrow_r:SetScale(2, 2, 2)
	self.arrow_r:Show()
	self.arrow_l:Show()

	--这个用来动态更新OnUpdate
	self:StartUpdating()
end)
function letter_normal:OnUpdate(dt)
	
end

function letter_normal:Open()
	self:Show()
end
function letter_normal:Close()
	self:Hide()
end
return letter_normal