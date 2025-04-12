local ImageButton = require "widgets/imagebutton"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local Text = require "widgets/text"

local panelbg_x = 180
local panelbg_y = -120

local introduction

local buff = Class(Widget, function(self, name, parent, pos, lasttime)
    Widget._ctor(self, "buff")
    self.parent = parent
    self.name = name
    self.lasttime = lasttime
    local nonprefixname = "missing"
    if GetPlayer().components.arcueidbuff.allbuffinfo['iconexistlist'][self.name] == true then
        if string.sub(self.name, 1, 5) == "buff_" then
            nonprefixname = string.sub(self.name, 6, -1)
        else
            nonprefixname = string.sub(self.name, 7, -1)
        end
    end
    self.img = self:AddChild(Image("images/bufficon.xml", nonprefixname .. ".tex"))
    self.introductionbg = self:AddChild(Image("images/arcueid_gui/arcueid_ui.xml", "arcueid_introbgl.tex"))
    self.introduction = self:AddChild(Text(NUMBERFONT, 24, " ", { 255, 0, 0, 1 }))

    self.introductionbg:SetVAnchor(ANCHOR_TOP)
    self.introductionbg:SetHAnchor(ANCHOR_MIDDLE)
    self.introductionbg:SetScale(.5, .5, 1)
    self.introductionbg:SetPosition(self.parent.panelbg:GetPosition() + Vector3(0, -200, 0))

    self.introduction:SetVAnchor(ANCHOR_TOP)
    self.introduction:SetHAnchor(ANCHOR_MIDDLE)
    self.introduction:SetPosition(self.parent.panelbg:GetPosition() + Vector3(5, -200, 0))
    self.img:SetScale(1.5, 1.5, 1.5)
    self.img:Hide()
    self.introductionbg:Hide()
    self.introduction:Hide()
    self:StartUpdating()
end)

local Buffpanel = Class(Widget, function(self, owner)
    Widget._ctor(self, "Buffpanel")
    self.owner = owner
    self.panelbg = self:AddChild(Image("images/arcueid_gui/arcueid_ui.xml", "arcueid_panel.tex"))
    self.show_button = self:AddChild(ImageButton())

    self.panelbg:SetVAnchor(ANCHOR_TOP)
    self.panelbg:SetHAnchor(ANCHOR_MIDDLE)
    self.panelbg:SetScale(.8, .5, 1)
    self.panelbg:SetPosition(panelbg_x, panelbg_y, 0)

    -- z轴缩放置零后不能onfoucus
    self.show_button:SetScale(.6, .6, .6)
    self.show_button:SetText("关闭")
    self.show_button:SetOnClick(
        function()
            if self.panelbg.shown == false then
                self:Open()
                self.show_button:SetText("关闭")
            elseif self.panelbg.shown == true then
                self:Close()
                self.show_button:SetText("打开")
            end
        end)
    self.show_button:SetVAnchor(ANCHOR_TOP)
    self.show_button:SetHAnchor(ANCHOR_MIDDLE)
    self.show_button:SetPosition(panelbg_x - 250, panelbg_y +30, 0)

    if owner and owner.prefab == "arcueid" then
        introduction = owner.components.arcueidbuff.allbuffinfo["INTRODUCTION"] or ""
    end

    self.panelbg:Show()
    self.show_button:Show()
    self:StartUpdating()
end)

function Buffpanel:Close()
    local bufflist = self.owner.components.arcueidbuff.buff_modifiers_add_timer
    local lbufflist = self.owner.components.arcueidbuff.islastbuffactive
    for key, value in pairs(self) do
        if bufflist[key] or lbufflist[key] then
            value.img:Hide()
        end
    end
    self.panelbg:Hide()
end

function Buffpanel:Open()
    local bufflist = self.owner.components.arcueidbuff.buff_modifiers_add_timer
    local lbufflist = self.owner.components.arcueidbuff.islastbuffactive
    for key, value in pairs(self) do
        if bufflist[key] or lbufflist[key] then
            value.img:Show()
        end
    end
    self.panelbg:Show()
end

function Buffpanel:Setbuff(str, pos, lasttime)
    if self[str] == nil then
        self[str] = self:AddChild(buff(str, self, pos, lasttime))        
    end

    self[str]:SetVAnchor(ANCHOR_TOP)
    self[str]:SetHAnchor(ANCHOR_MIDDLE)
    self[str]:SetPosition(self.panelbg:GetPosition() +
    Vector3(-36 * (pos % 9) + 145, 50 - (45 * math.floor(pos / 9)), 0))
    self[str].img:Show()
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

    if self.panelbg.shown == false then
        return
    end

    local setorder = 0
    local bufflist = self.owner.components.arcueidbuff.buff_modifiers_add_timer
    local lbufflist = self.owner.components.arcueidbuff.islastbuffactive

    for k, v in pairs(bufflist) do
        if self[k] ~= nil and v <= 0 then
            self[k].img:Hide()
            -- self[k].k = nil
        end
    end

    -- print("------------")
    -- for k, v in pairs(bufflist) do
    --     print(k..":"..v)
    -- end
    -- print("------------")

    

    for k, v in pairs(bufflist) do
        if lbufflist[k] == true then
            self:Setbuff(k, setorder, nil)
            setorder = setorder + 1
        elseif v > 0 and lbufflist[k] ~= true then
            self:Setbuff(k, setorder, v)
            setorder = setorder + 1
        end
    end
end

--居然没有utf8模块？？，手动实现
function InsertStr(str, gap, char)
    if str == "" or str ==nil then
        return ""
    end

    gap = gap or 5
    char = char or "a"

    local result = ""
    local count = 0
    local i = 1

    while i <= #str do
        local byte = str:byte(i)
        if byte < 128 then
            -- ASCII 字符
            result = result .. str:sub(i, i)
            i = i + 1
        elseif byte >= 192 and byte < 224 then
            -- 2 字节字符
            result = result .. str:sub(i, i + 1)
            i = i + 2
        elseif byte >= 224 and byte < 240 then
            -- 3 字节字符
            result = result .. str:sub(i, i + 2)
            i = i + 3
        elseif byte >= 240 and byte < 248 then
            -- 4 字节字符
            result = result .. str:sub(i, i + 3)
            i = i + 4
        end

        count = count + 1

        if count % gap == 0 then
            result = result .. char
        end
    end

    return result
end

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

    local str = InsertStr(introduction[self.name], 10, "\n")
    local combuffinfo = self.parent.owner.components.arcueidbuff

    if combuffinfo.allbuffinfo['TYPE'][self.name] == 'timer' then
        str = str .. "\n剩余时间：" .. combuffinfo.buff_modifiers_add_timer[self.name] .. "秒"
    end

    self.introduction:SetString(str)
end

function buff:OnUpdate(dt)
    self:recal()
end

return Buffpanel
