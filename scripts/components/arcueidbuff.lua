local ArcueidBuff = Class(function(self, inst)
    self.inst = inst
    self.interval = 1

    self.islastbuffactive =
    {
        ['lbuff_recover'] = false,
        ['lbuff_pep'] = false,
        ['lbuff_dehunger'] = false,
        ['lbuff_echou'] = false,
    }
    self.buff_modifiers_add_timer = {['buff_bottlelight'] = 0}
    self.buff_modifiers_add = {
        --持续性buff
        --恶臭，被视为怪物,自动被蜘蛛跟随
        ['lbuff_echou'] = function(self)
            if self.islastbuffactive['lbuff_echou'] == true and not self.inst:HasTag("monster") then
                self.inst:AddTag("monster")
                if self.inst and self.inst.components.leader then
                    self.inst.components.leader:RemoveFollowersByTag("pig")
                    local x, y, z = self.inst.Transform:GetWorldPosition()
                    local ents = TheSim:FindEntities(x, y, z, TUNING.SPIDERHAT_RANGE, { "spider" })
                    for k, v in pairs(ents) do
                        if (not v.components.health or not v.components.health:IsDead()) and v.components.follower and not v.components.follower.leader and not self.inst.components.leader:IsFollower(v) and self.inst.components.leader.numfollowers < 10 then
                            self.inst.components.leader:AddFollower(v)
                        end
                    end
                end
            elseif self.islastbuffactive['lbuff_echou'] == false and self.inst:HasTag("monster") then
                self.inst:RemoveTag("monster")
                self.inst.components.leader:RemoveFollowersByTag("pig")
                self.inst.components.leader:RemoveFollowersByTag("spider")
            end
        end,
        --回血
        ['lbuff_recover'] = function(self)
            self.inst.components.health:DoDelta(.05)
        end,
        --回san
        ['lbuff_pep'] = function(self)
            self.inst.components.sanity:DoDelta(.05)
        end,
        --去饱食度
        ['lbuff_dehunger'] = function(self)
            self.inst.components.hunger:DoDelta(-.2)
        end,

        --时限性buff
        --恢复->回血
        ['buff_recover'] = function(self)
            self.inst.components.health:DoDelta(.3)
        end,
        --画饼->回饱食度
        ['buff_pieInTheSky'] = function(self)
            self.inst.components.hunger:DoDelta(.3)
        end,
        --振奋->回san
        ['buff_pep'] = function(self)
            self.inst.components.sanity:DoDelta(.3)
        end,
        --光环->发光(60s)
        ['buff_halo'] = function(self)
            --发光(125, 249, 255)电蓝色
            local light = self.inst.entity:AddLight()
            light:SetIntensity(.4)
            light:SetFalloff(2)
            light:SetRadius(6)
            light:SetColour(125 / 255, 249 / 255, 255 / 255)
            light:Enable(true)
            if self.buff_modifiers_add_timer['buff_halo'] == 0 then
                self.inst:DoTaskInTime(0, function()
                    light:Enable(false)
                end)
            end
        end,
        --小小精灵
        ['buff_bottlelight'] = function(self)
            --深橙色（255,140,0）
            local light = self.inst.entity:AddLight()
            light:SetIntensity(self.buff_modifiers_add_timer['buff_bottlelight'] * .25 / 100 + .1)
            light:SetFalloff(2)
            light:SetRadius(self.buff_modifiers_add_timer['buff_bottlelight'] * 4.1 / 100)
            light:SetColour(255 / 255, 140 / 255, 0 / 255)
            light:Enable(true)
            if self.buff_modifiers_add_timer['buff_bottlelight'] == 0 then
                self.inst:DoTaskInTime(0, function()
                    light:Enable(false)
                end)
            end
        end,
        --休憩->回复活力
        ['buff_rest'] = function(self)
            self.inst.components.vigour:DoDelta(.35)
        end,

        --回复->同时回复三维
        ['buff_restore'] = function(self)
            self.inst.components.health:DoDelta(.2)
            self.inst.components.hunger:DoDelta(.2)
            self.inst.components.sanity:DoDelta(.2)
        end,

        --夜视->全屏不黑(60s)
        ['buff_nightVision'] = function(self)
            if GetClock() and GetWorld() and GetWorld().components.colourcubemanager then
                GetClock():SetNightVision(true)
                GetWorld().components.colourcubemanager:SetOverrideColourCube(
                    "images/colour_cubes/mole_vision_on_cc.tex", 2)
                if self.buff_modifiers_add_timer['buff_nightVision'] <= 5 then
                    if GetClock() then
                        GetClock():SetNightVision(false)
                    end
                    if GetWorld() and GetWorld().components.colourcubemanager then
                        GetWorld().components.colourcubemanager:SetOverrideColourCube(nil, .5)
                    end
                end
            end
        end,
        --残疾->临时扣血量上限(max=>-90)
        ['buff_disability'] = function(self)
            if self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil
                and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab == "trinket_moonwristband"
            then
                return
            end
            if self.buff_modifiers_add_timer['buff_disability'] > 90 then
                self.inst.components.health.buffpenalty = 90
            else
                self.inst.components.health.buffpenalty = self.buff_modifiers_add_timer['buff_disability']
            end
        end,
        --敌视->被当成怪物
        ['buff_hatred'] = function(self)
            if self.buff_modifiers_add_timer['buff_hatred'] >= 2 and not self.inst:HasTag("monster") then
                self.inst:AddTag("monster")
            elseif self.buff_modifiers_add_timer['buff_hatred'] < 2 and self.inst:HasTag("monster") then
                self.inst:RemoveTag("monster")
            end
        end,
        --盲视->血滤镜（锁高度？）(50s)
        ['buff_blindness'] = function(self)
            if self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil
                and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab == "trinket_moonwristband" then
                buff_modifiers_add_timer['buff_blindness'] = 0
            end
        end,

    }
    self:Starbuff()
end)

local buffDefueatTime =
{
    --buff
    ['buff_recover'] = 300,
    ['buff_pieInTheSky'] = 350,
    ['buff_pep'] = 300,
    ['buff_halo'] = 200,
    ['buff_bottlelight'] = 100,
    ['buff_rest'] = 300,
    ['buff_restore'] = 220,
    ['buff_nightVision'] = 400,
    --debuff
    ['buff_disability'] = 13,
    ['buff_hatred'] = 200,
    ['buff_blindness'] = 20,
}

function ArcueidBuff:ActiveArcueidBuff(key, timer)
    if key then
        self.buff_modifiers_add_timer[key] = timer or buffDefueatTime[key]
    end
end

function ArcueidBuff:AddArcueidBuff(key, timer)
    if key and self.buff_modifiers_add_timer[key] == nil then
        self.buff_modifiers_add_timer[key] = 0
    end

    if key then
        self.buff_modifiers_add_timer[key] = self.buff_modifiers_add_timer[key] + (timer or buffDefueatTime[key])
    end
end

function ArcueidBuff:TaskBufffn()
    --持续性buff逻辑
    for key, value in pairs(self.islastbuffactive) do
        if self.islastbuffactive[key] == true then
            self.buff_modifiers_add_timer[key] = 1
        else
            self.buff_modifiers_add_timer[key] = 0
        end
    end

    for k, v in pairs(self.buff_modifiers_add_timer) do
        if self.buff_modifiers_add_timer[k] and self.buff_modifiers_add_timer[k] > 0 then
            self.buff_modifiers_add_timer[k] = self.buff_modifiers_add_timer[k] - self.interval
            if self.buff_modifiers_add[k] ~= nil then self.buff_modifiers_add[k](self) end
        end
    end
end

function ArcueidBuff:Starbuff()
    self.taskbuff = self.inst:DoPeriodicTask(self.interval, function()
        self:TaskBufffn()
    end)
end

function ArcueidBuff:OnSave()
    local data = {}
    data.buff_modifiers_add_timer = self.buff_modifiers_add_timer
    return data
end

function ArcueidBuff:OnLoad(data)
    self.buff_modifiers_add_timer = data.buff_modifiers_add_timer
    self:TaskBufffn()
end

return ArcueidBuff
