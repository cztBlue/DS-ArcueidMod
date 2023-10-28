local Widget = require "widgets/screen"
local Button = require "widgets/button"
local AnimButton = require "widgets/animbutton"
local ImageButton = require "widgets/imagebutton"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local UIAnim = require "widgets/uianim"
require "util"

CraftRecipesTrinket = Class(Widget, function(self, owner)
	Widget._ctor(self, "yanjiu")
	self.owner = owner
	self.cailiaobuzu = 0
	self.IsUIShow = false
	SetPause(true, "pause")
	self.root = self:AddChild(Widget("ROOT"))
	self.root:SetVAnchor(ANCHOR_MIDDLE)
	self.root:SetHAnchor(ANCHOR_MIDDLE)
	self.root:SetPosition(0, 0, 0)
	self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
	self.page = 1
	self.pagemax = 2
	GetPlayer():ListenForEvent("OpenCraftRecipesTrinket", function()
		self:Open()
	end)
	GetPlayer():ListenForEvent("CloseCraftRecipesTrinket", function()
		self:Close()
	end)
	--背景
	self.image = self:AddChild(Image("images/globalpanels.xml", "panel_skinny.tex"))
	--self.image:SetPosition(650, 365, 0)
	self.image:SetPosition(-350, 0, 0)
	self.image2 = self:AddChild(Image("images/globalpanels.xml", "presetbox.tex"))
	self.image2:SetPosition(350, 0, 0)
	--格子
	self.gezi5 = self.image2:AddChild(Image("images/hud.xml", "inv_slot.tex"))
	self.gezi5:SetPosition(-100, -65, 0)
	self.gezi5:SetScale(0.7, 0.7, 0)

	self.gezi1 = self.gezi5:AddChild(Image("images/hud.xml", "inv_slot.tex"))
	self.gezi1:SetPosition(-70, 70, 0)
	--self.gezi1:SetScale(0.7, 0.7, 0)

	self.gezi2 = self.gezi5:AddChild(Image("images/hud.xml", "inv_slot.tex"))
	self.gezi2:SetPosition(0, 70, 0)
	--self.gezi2:SetScale(0.7, 0.7, 0)

	self.gezi3 = self.gezi5:AddChild(Image("images/hud.xml", "inv_slot.tex"))
	self.gezi3:SetPosition(70, 70, 0)
	--self.gezi3:SetScale(0.7, 0.7, 0)

	self.gezi4 = self.gezi5:AddChild(Image("images/hud.xml", "inv_slot.tex"))
	self.gezi4:SetPosition(-70, 0, 0)
	--self.gezi4:SetScale(0.7, 0.7, 0)

	self.gezi6 = self.gezi5:AddChild(Image("images/hud.xml", "inv_slot.tex"))
	self.gezi6:SetPosition(70, 0, 0)
	--self.gezi6:SetScale(0.7, 0.7, 0)

	self.gezi7 = self.gezi5:AddChild(Image("images/hud.xml", "inv_slot.tex"))
	self.gezi7:SetPosition(-70, -70, 0)
	--self.gezi7:SetScale(0.7, 0.7, 0)

	self.gezi8 = self.gezi5:AddChild(Image("images/hud.xml", "inv_slot.tex"))
	self.gezi8:SetPosition(0, -70, 0)
	--self.gezi8:SetScale(0.7, 0.7, 0)

	self.gezi9 = self.gezi5:AddChild(Image("images/hud.xml", "inv_slot.tex"))
	self.gezi9:SetPosition(70, -70, 0)
	--self.gezi9:SetScale(0.7, 0.7, 0)
	--关闭
	self.closebutton = self:AddChild(ImageButton())
	--self.closebutton:SetText(STRINGS.DAIMIAO_CLOSE)
	self.closebutton:SetPosition(860, 150, 0)
	self.closebutton:SetOnClick(
		function()
			self:Close()
		end)
	--翻页

	self.arrow_l = self.image:AddChild(ImageButton("images/arcueid_gui/turnarrow_icon.xml", "turnarrow_icon.tex")) --上一页
	self.arrow_l:SetPosition(-120, -200, 0)
	self.arrow_l:SetOnClick(function()
		self.page = self.page - 1
		if self.page < 1 then self.page = 1 end
		self:flip()
	end)
	self.arrow_r = self.image:AddChild(ImageButton("images/hud.xml", "turnarrow_icon.tex")) --下一页
	self.arrow_r:SetPosition(120, -200, 0)
	self.arrow_r:SetOnClick(function()
		self.page = self.page + 1
		if self.page > self.pagemax then self.page = self.pagemax end
		self:flip()
	end)
	self.arrow_r:Hide()
	self.arrow_l:Hide()
	self:flip()
end)
--炼金配方里的图要在这里写，不然图打不出来
local arcueidItem = { "base_moonglass", "base_gemfragment", "base_moonrock_nugget", "base_horrorfuel", "base_puregem",
	"base_moonempyreality", "base_gemblock", }
function CraftRecipesTrinket:IsArcueidItem(name)
	for key, value in pairs(arcueidItem) do
		if name == value then
			return true
		end
	end
	return false
end

-- function CraftRecipesTrinket:RemovePrefix(name)
-- 	local remove1 = string.gsub(name, "trinket_", "")
-- 	local remove2 = string.gsub(remove1, "trinket_", "")
-- 	return remove2
-- end

function CraftRecipesTrinket:flip()
	self:CK()
	if self.page == 1 then
		self:page1()
	elseif self.page == 2 then
		self:page2()
	elseif self.page == 3 then
		self:page3()
	end
	if self.page == 1 then
		self.arrow_l:Disable()
	else
		self.arrow_l:Enable()
	end
	if self.page == self.pagemax then
		self.arrow_r:Disable()
	else
		self.arrow_r:Enable()
	end
end

--(-120, 190, 0),(-40, 190, 0),(40, 190, 0),(120, 190, 0),(-120, 110, 0),(-40, 110, 0),(40, 110, 0),(120, 110, 0)
--(-120, 30, 0),(-40, 30, 0),..(120, -130, 0)
function CraftRecipesTrinket:page1()
	--宝石块
	self.item1 = self.image:AddChild(ImageButton("images/inventoryimages/base_gemblock.xml", "base_gemblock.tex"))
	self.item1:SetPosition(-120, 190, 0) --调位置
	self.item1:SetOnClick(
		function()
			local name = "base_gemblock" --改名字
			self:QK()
			self.tubiao = self.image2:AddChild(Image("images/inventoryimages/" .. name .. ".xml", name .. ".tex"))
			self.tubiao:SetPosition(-100, 100, 0)
			self.text1 = self.image2:AddChild(Text(BODYTEXTFONT, 50,
				STRINGS.NAMES[string.upper("base_" .. name)])) --调类名(选)
			self.text1:SetPosition(50, 100, 0)
			self.text2 = self.image2:AddChild(Text(BODYTEXTFONT, 30,
				STRINGS.CHARACTERS.ARCUEID.DESCRIBE.TRINKET_EFFECT[string.upper("base_" .. name)])) --调类名(选)
			self.text2:SetPosition(80, -50, 0)

			for k, v in pairs(TUNING.ARCUEID_TRINKETRECIPES["base_" .. name]) do --调类名和配方表(选)
				if v ~= nil then
					if self:IsArcueidItem(v) then
						self["cailiao" .. tostring(k)] = self["gezi" .. tostring(k)]:AddChild(ImageButton(
							"images/inventoryimages/" .. v .. ".xml",
							v .. ".tex"))
					else
						self["cailiao" .. tostring(k)] = self["gezi" .. tostring(k)]:AddChild(ImageButton(
							"images/inventoryimages.xml", v .. ".tex"))
					end
				end
			end
		end)

	--蛋包饭
	-- self.item2 = self.image:AddChild(ImageButton("images/inventoryimages/omeletterice.xml", "omeletterice.tex"))
	-- self.item2:SetPosition(-40, 190, 0)
	-- self.item2:SetOnClick(
	-- 	function()
	-- 		local name = "omeletterice"
	-- 		self:QK()
	-- 		self.tubiao = self.image2:AddChild(Image("images/inventoryimages/" .. name .. ".xml", name .. ".tex"))
	-- 		self.tubiao:SetPosition(-100, 100, 0)
	-- 		self.text1 = self.image2:AddChild(Text(BODYTEXTFONT, 50,
	-- 			STRINGS.NAMES[string.upper("arcueid_food_" .. name)]))
	-- 		self.text1:SetPosition(50, 100, 0)
	-- 		self.text2 = self.image2:AddChild(Text(BODYTEXTFONT, 30,
	-- 			STRINGS.CHARACTERS.ARCUEID.DESCRIBE.FOOD_EFFECT[string.upper("arcueid_food_" .. name)]))
	-- 		self.text2:SetPosition(80, -50, 0)

	-- 		for k, v in pairs(TUNING.ARCUEID_FOODRECIPES["arcueid_food_"..name]) do
	-- 			if v ~= nil then
	-- 				if self:IsArcueidItem(v) then
	-- 					self["cailiao" .. tostring(k)] = self["gezi" .. tostring(k)]:AddChild(ImageButton(
	-- 						"images/inventoryimages/" .. self:RemovePrefix(v) .. ".xml",
	-- 						self:RemovePrefix(v) .. ".tex"))
	-- 				else
	-- 					self["cailiao" .. tostring(k)] = self["gezi" .. tostring(k)]:AddChild(ImageButton(
	-- 						"images/inventoryimages.xml", v .. ".tex"))
	-- 				end
	-- 			end
	-- 		end
	-- 	end)
end

function CraftRecipesTrinket:page2()
end

function CraftRecipesTrinket:Close()
	self.openui = false
	self:Hide()
end

function CraftRecipesTrinket:Open()
	self.openui = true
	self:Show()
end

function CraftRecipesTrinket:QK()
	if self.tubiao then self.tubiao:Kill() end
	if self.text1 then self.text1:Kill() end
	if self.text2 then self.text2:Kill() end
	if self.cailiao1 then self.cailiao1:Kill() end
	if self.cailiao2 then self.cailiao2:Kill() end
	if self.cailiao3 then self.cailiao3:Kill() end
	if self.cailiao4 then self.cailiao4:Kill() end
	if self.cailiao5 then self.cailiao5:Kill() end
	if self.cailiao6 then self.cailiao6:Kill() end
	if self.cailiao7 then self.cailiao7:Kill() end
	if self.cailiao8 then self.cailiao8:Kill() end
	if self.cailiao9 then self.cailiao9:Kill() end
end

function CraftRecipesTrinket:CK()
	if self.item1 then self.item1:Kill() end
	if self.item2 then self.item2:Kill() end
	if self.item3 then self.item3:Kill() end
	if self.item4 then self.item4:Kill() end
	if self.item5 then self.item5:Kill() end
	if self.item6 then self.item6:Kill() end
	if self.item7 then self.item7:Kill() end
	if self.item8 then self.item8:Kill() end
	if self.item9 then self.item9:Kill() end
	if self.item10 then self.item10:Kill() end
	if self.item11 then self.item11:Kill() end
	if self.item12 then self.item12:Kill() end
	if self.item13 then self.item13:Kill() end
	if self.item14 then self.item14:Kill() end
	if self.item15 then self.item15:Kill() end
	if self.item16 then self.item16:Kill() end
	if self.item17 then self.item17:Kill() end
	if self.item18 then self.item18:Kill() end
	if self.item19 then self.item19:Kill() end
	if self.item20 then self.item20:Kill() end
end

return CraftRecipesTrinket
