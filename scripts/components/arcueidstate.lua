local ArcueidState = Class(function(self, inst)
    self.inst = inst
    self.recipeunlock = {}
    self.careful = false
    self.iceskill_cooldown = 0
    self.martyrseal_cooldown = 0
    self.martyrseal_highlight = 0
    self.nightmarerosion = 0
    self.nightmarerosion_temp = 0
    self.nightmarerosion_deep = 0
    self.erosion_deep_count = 10 --防止连续下弦累加
    self.seasontoggle = 3
    self.foodhealth = 0
    self.bleedhealth = 0
    self.displaymultiplier = {}
    
    self.inst:ListenForEvent("daytime", function(inst, data)
        if self.seasontoggle then
            self.seasontoggle = self.seasontoggle - 1
        else
            self.seasontoggle = math.random(2,8)
        end

        --新月+60事件
        if self.erosion_deep_count then
            self.erosion_deep_count = self.erosion_deep_count - 1
        else
            self.erosion_deep_count = 10
        end
        if GetClock():GetMoonPhase() == "new" and self.erosion_deep_count <= 0 then
            self:DoDeltaForErosion_DEEP(60)
            self.erosion_deep_count = 10
        end
        --改时段
        self:CalSegment()
        --乱季
        self:ToggleSeason()
    end, GetWorld())

    self.inst:ListenForEvent("dusktime", function(inst, data) self:CalSegment() end, GetWorld())
    self.inst:ListenForEvent("nighttime", function(inst, data) self:CalSegment() end, GetWorld())
    
    self.inst:StartUpdatingComponent(self)
end)

--切换季节
function ArcueidState:ToggleSeason()
    if self.nightmarerosion == 360 and self.seasontoggle <= 0 then
        if SaveGameIndex:IsModePorkland() then
            GetSeasonManager():StartLush()
        elseif SaveGameIndex:IsModeShipwrecked() then
            GetSeasonManager():StartDry()
        else
            GetSeasonManager():StartSummer()
        end
        return
    end

    if self.nightmarerosion > 240 and self.seasontoggle <= 0 then
        local indexnum = math.random(1,2)
        if SaveGameIndex:IsModePorkland() then
            if indexnum == 1 then GetSeasonManager():StartHumid()
            elseif indexnum == 2 then GetSeasonManager():StartLush() end
        elseif SaveGameIndex:IsModeShipwrecked() then
            if indexnum == 1 then GetSeasonManager():StartWet()
            elseif indexnum == 2 then GetSeasonManager():StartDry() end
        else
            if indexnum == 1 then GetSeasonManager():StartWinter()
            elseif indexnum == 2 then GetSeasonManager():StartSummer() end
        end
        return
    end


    if self.nightmarerosion > 180 and self.seasontoggle <= 0 then
        local indexnum = math.random(1,3)
        if SaveGameIndex:IsModePorkland() then
            if indexnum == 1 then GetSeasonManager():StartHumid()
            elseif indexnum == 2 or indexnum == 3 then GetSeasonManager():StartLush() end
        elseif SaveGameIndex:IsModeShipwrecked() then
            if indexnum == 1 then GetSeasonManager():StartWet()
            elseif indexnum == 2 then GetSeasonManager():StartDry()
            elseif indexnum == 3 then GetSeasonManager():StartGreen() end
        else
            if indexnum == 1 then GetSeasonManager():StartSpring()
            elseif indexnum == 2 then GetSeasonManager():StartSummer()
            elseif indexnum == 3 then GetSeasonManager():StartWinter() end
        end
        return
    end

    
end

--暗灾时祸
function ArcueidState:CalSegment()
    local clock = GetClock()
    local f = 1 - self.nightmarerosion / TUNING.ARCUEID_MAXEROSION
    local day, dusk = math.floor(clock.daysegs * f), math.floor(clock.dusksegs * f)
    clock:SetSegs(day, dusk, 16 - day - dusk)
end

function ArcueidState:IsCarefulWalking()
    return self.careful
end

function ArcueidState:OnCarefulStateUpdate()
    --careful
    local inst = self.inst
    if inst.prefab == "arcueid" and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET) == nil then
        inst.components.arcueidstate.careful = false
    elseif inst.prefab == "arcueid" and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET) ~= nil then
        if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab ~= "trinket_shadowcloak" then
            inst.components.arcueidstate.careful = false
        end
    end
    --local is_moving = inst.sg:HasStateTag("moving")
    if inst.components.arcueidstate.careful == true then
        inst.components.vigour.trinketfactor = -1.5
        inst:RemoveTag("character")
        inst:RemoveTag("scarytoprey")
        inst:RemoveTag("player")
    elseif inst.components.arcueidstate.careful == false and inst.prefab == "arcueid" and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET) ~= nil then
        if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_shadowcloak" then
            inst.components.vigour.trinketfactor = -0.15
            inst:AddTag("character")
            inst:AddTag("scarytoprey")
            inst:AddTag("player")
        end
        if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab ~= "trinket_shadowcloak" then
            inst:AddTag("character")
            inst:AddTag("scarytoprey")
            inst:AddTag("player")
        end
    end
end

function ArcueidState:DoDeltaForErosion_TEMP(value) 
    local over =  self.nightmarerosion + value - TUNING.ARCUEID_MAXEROSION
    if over <= 0 then
        if self.nightmarerosion_temp + value >= 0 then
            self.nightmarerosion_temp = self.nightmarerosion_temp + value
        else
            self.nightmarerosion_temp = 0
        end
    elseif over > 0 then
        self.nightmarerosion_temp = self.nightmarerosion_temp + value - over
    end
end

function ArcueidState:DoDeltaForErosion_DEEP(value)
    if self.nightmarerosion_deep + value >=  TUNING.ARCUEID_MAXEROSION then
        self.nightmarerosion_deep = TUNING.ARCUEID_MAXEROSION
    elseif self.nightmarerosion_deep + value <=  0 then
        self.nightmarerosion_deep = 0
    else
        self.nightmarerosion_deep = self.nightmarerosion_deep + value
    end

    if self.nightmarerosion_deep > TUNING.ARCUEID_MAXEROSION then
        self.nightmarerosion_deep = TUNING.ARCUEID_MAXEROSION
    end
end

function ArcueidState:DoDeltaForErosion_POTION(value)
    local dero = self.nightmarerosion_deep
    local tero = self.nightmarerosion_temp
    if dero + value >= 0  then
        self:DoDeltaForErosion_DEEP(value)
    elseif dero + value <= 0 then
        self:DoDeltaForErosion_DEEP(-dero)
        self:DoDeltaForErosion_TEMP(dero+value)
    end
end

function ArcueidState:GetErosionPercent()
    return (self.nightmarerosion /TUNING.ARCUEID_MAXEROSION )
end

function ArcueidState:AddFoodHealth(value)
    if self.foodhealth == nil then
        self.foodhealth = 0
    end
    self.foodhealth = self.foodhealth + (value or 0)
end

function ArcueidState:AddBleedHealth(value)
    print("wwwww2"..value)
    if self.bleedhealth == nil then
        self.bleedhealth = 0
    end
    self.bleedhealth = self.bleedhealth + (value or 0)
end

local setcountbysecond = 0
function ArcueidState:OnUpdate(dt)
    -- 不启用侵蚀
    self.nightmarerosion_temp = 0
    self.nightmarerosion_deep = 0
    self.nightmarerosion = 0

    -- 差分优化
    if setcountbysecond >= 1 then
        setcountbysecond = 0
        self:UpdateBySecond()
    else
        setcountbysecond = setcountbysecond + dt
    end

    self:OnCarefulStateUpdate()
    if self.iceskill_cooldown >= 0 then self.iceskill_cooldown = self.iceskill_cooldown - dt end
    if self.martyrseal_cooldown >= 0 then self.martyrseal_cooldown = self.martyrseal_cooldown - dt end
    if self.martyrseal_highlight >= 0 then self.martyrseal_highlight = self.martyrseal_highlight - dt end

    --test
    if self.nightmarerosion and self.nightmarerosion_deep then
        self.nightmarerosion = self.nightmarerosion_deep + self.nightmarerosion_temp

        if self.nightmarerosion <= self.nightmarerosion_deep then
            self.nightmarerosion = self.nightmarerosion_deep
        end

        if self.nightmarerosion > self.nightmarerosion_deep then
            self:DoDeltaForErosion_TEMP(- 0.0013)
        end
        
        --检查溢出
        if self.nightmarerosion > TUNING.ARCUEID_MAXEROSION then
            self.nightmarerosion_temp = TUNING.ARCUEID_MAXEROSION - self.nightmarerosion_deep
            self.nightmarerosion = TUNING.ARCUEID_MAXEROSION
        end
    end
end

function ArcueidState:UpdateBySecond()
    local healthdelta = 0

    -- foodhealth增益
    -- 80/480s,上限100
    if self.foodhealth == nil then
        self.foodhealth = 0
    elseif self.foodhealth >= 100 then
        self.foodhealth = 100
    end

    if self.foodhealth >= 0 then
        healthdelta = healthdelta + 8/48
        self.foodhealth = self.foodhealth - 8/48
    end

    -- bleedhealth增益
    -- 200/480s,上限350
    if self.bleedhealth == nil then
        self.bleedhealth = 0
    elseif self.bleedhealth >= 350 then
        self.bleedhealth = 350
    end

    if self.bleedhealth >= 0 then
        healthdelta = healthdelta - 20/48
        self.bleedhealth = self.bleedhealth - 20/48
    end

    self.inst.components.health:DoDelta(healthdelta)

end

function ArcueidState:OnSave()
    local data = {}
    data.recipeunlock = self.recipeunlock
    data.nightmarerosion = self.nightmarerosion
    data.nightmarerosion_deep = self.nightmarerosion_deep
    data.erosion_deep_count = self.erosion_deep_count
    data.foodhealth =  self.foodhealth or 0
    data.bleedhealth =  self.bleedhealth or 0
    return data
end

function ArcueidState:OnLoad(data)
    self.recipeunlock = data.recipeunlock
    self.nightmarerosion = data.nightmarerosion or 0
    self.nightmarerosion_deep = data.nightmarerosion_deep or 0
    self.erosion_deep_count = data.erosion_deep_count
    self.foodhealth =  data.foodhealth or 0
    self.bleedhealth =  data.bleedhealth or 0

    self:CalSegment()
end

return ArcueidState
