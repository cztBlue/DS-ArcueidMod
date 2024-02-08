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
	Widget._ctor(self, "yanjiu")
    self.owner = owner
	GetPlayer():ListenForEvent("OpenNormalLetter",function()
		self:Open()
	end)
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
	self.txt = self:AddChild(Text(UIFONT, 25,[[
		    任务：对外交流
		条件：获得1个通讯台
		说明：反正肯定回不去（bushi）
		制作1个研究台，并进行研究
		获得一定量的研究点数
		制作研究通讯技术
		学会制作通讯台后制作通讯台
		由于通讯台材料包含终端
		该任务无需提交
		注意，过快推进主线会有负面事件
		请先以攀科技为主
		]]))
	self.txt:SetPosition(-350, 0, 0)
	self.txt:SetHAlign(ANCHOR_LEFT)

	--翻页
	self.arrow_l = self.image:AddChild(ImageButton("images/arcueid_gui/turnarrow_icon.xml", "turnarrow_icon.tex")) --上一页
	self.arrow_l:SetPosition(-630, 0, 0)
	self.arrow_l:SetOnClick(function()
		self.txt:SetString([[
			翻页测试文本0
		]])
		self.curpagenum = self.curpagenum - 1
	end)
	self.arrow_l:SetScale(2, 2, 2)
	self.arrow_r = self.image:AddChild(ImageButton("images/hud.xml", "turnarrow_icon.tex")) --下一页
	self.arrow_r:SetPosition(630, 0, 0)
	self.arrow_r:SetOnClick(function()
		self.txt:SetString([[
			翻页测试文本1
		]])
		self.curpagenum = self.curpagenum + 1
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