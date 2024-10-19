local ImageButton = require "widgets/imagebutton"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local Text = require "widgets/text"

local panelbg_x = 180
local panelbg_y = -80

local introduction

--buff图标资源检索
local iconexistlist = 
{
["buff_bleed"] = true,["buff_dehunger"]= true,["buff_halo"]= true,["buff_pep"]= true,["buff_restore"]= true,
["lbuff_bleed"]= true,["lbuff_dehunger"]= true,["lbuff_halo"]= true,["lbuff_pep"]= true,["lbuff_restore"]= true,
}

local buff = Class(Widget, function(self, name ,parent, pos, lasttime)
    Widget._ctor(self, "buff")
    --pos：在buffpanel中排列的位置 从0开始
    self.pos = pos
    self.parent = parent
    self.name = name
    self.lasttime = lasttime
    local nonprefixname = "missing"
    if iconexistlist[self.name] == true then
        if string.sub(self.name, 1, 5) == "buff_" then
            nonprefixname = string.sub(self.name, 6, -1) 
        else
            nonprefixname = string.sub(self.name, 7, -1) 
        end 
    end
    self.img = self:AddChild(Image("images/bufficon.xml", nonprefixname..".tex"))
    self.introductionbg = self:AddChild(Image("images/arcueid_gui/num_bg.xml", "num_bg.tex"))
    self.introduction = self:AddChild(Text(NUMBERFONT, 24, " ", { 255, 0, 0, 1 }))
    
    self.introductionbg:SetVAnchor(ANCHOR_TOP)
    self.introductionbg:SetHAnchor(ANCHOR_MIDDLE)
    self.introductionbg:SetScale(.4, .5, .4)
    self.introductionbg:SetPosition(self.parent.panelbg:GetPosition() + Vector3(0, -200, 0))

    self.introduction:SetVAnchor(ANCHOR_TOP)
    self.introduction:SetHAnchor(ANCHOR_MIDDLE)
    self.introduction:SetPosition(self.parent.panelbg:GetPosition() + Vector3(5, -200, 0))
    self.img:SetScale(1.5, 1.5, 1.5)
    self.img:Show()
    self.introductionbg:Hide()
    self.introduction:Hide()
    self:StartUpdating()
end)

local buff_ = { "buff1", "buff2", "buff3" }

local Buffpanel = Class(Widget, function(self, owner)
    Widget._ctor(self, "Buffpanel")
    self.owner = owner
    self.panelbg = self:AddChild(Image("images/arcueid_gui/transframe_1.xml", "transframe_1.tex"))

    self.panelbg:SetVAnchor(ANCHOR_TOP)
    self.panelbg:SetHAnchor(ANCHOR_MIDDLE)
    self.panelbg:SetScale(.8, .35, .4)
    self.panelbg:SetPosition(panelbg_x, panelbg_y, 0)
    if owner and owner.prefab == "arcueid" then
        introduction = owner.components.arcueidbuff.allbuffinfo["INTRODUCTION"]
    end
    
    self.panelbg:Show()
    self:StartUpdating()
end)

function buff:OnGainFocus()
    buff._base.OnGainFocus(self)
    self.introduction:Show()
    self.introductionbg:Show()
end

function buff:OnLoseFocus()
    buff._base.OnLoseFocus(self)
    self.introductionbg:Hide()
    self.introduction:Hide()
end

function buff:recal()
    if introduction == nil then
        return
    end

    if self.lasttime ~= nil then
        self.introduction:SetString(introduction[self.name].." 持续时间："..self.lasttime)
    else 
        self.introduction:SetString(introduction[self.name].." 持续时间：--")
    end
    
end

function buff:OnUpdate(dt)
    self:recal()
end

function Buffpanel:Setbuff(str, pos,lasttime)
    if self[str] == nil then
        self[str] = self:AddChild(buff(str, self, pos,lasttime))
    else
        self[str].img:Show()
    end
    self[str]:SetVAnchor(ANCHOR_TOP)
    self[str]:SetHAnchor(ANCHOR_MIDDLE)
    self[str]:SetPosition(self.panelbg:GetPosition() + Vector3(-30 * self[str].pos , 0, 0))
end

local sumdt = 0
function Buffpanel:OnUpdate(dt)
    -- 差分优化
    if sumdt < 1 then
        sumdt = sumdt + dt
        return
    else
        sumdt = 0
    end
    local setorder = 0
    local bufflist = self.owner.components.arcueidbuff.buff_modifiers_add_timer
    local lbufflist = self.owner.components.arcueidbuff.islastbuffactive

    for k, v in pairs(bufflist) do
        if self[k] ~= nil and v <= 0 then
            self[k].img:Hide() 
        end
    end

    for k, v in pairs(bufflist) do
        if lbufflist[k] == true then
            self:Setbuff(k,setorder,nil)
            setorder = setorder + 1
        elseif v > 0 and lbufflist[k] ~= true then
            self:Setbuff(k,setorder,v)
            setorder = setorder + 1
        end
    end

    
end

return Buffpanel
