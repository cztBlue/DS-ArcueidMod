local Vigour = Class(function(self, inst)
    self.inst = inst
    self.maxvigour = 100
    self.minvigour = 0
    self.currentvigour = self.maxvigour
    self.penalty = 0

    --for vigour buff
    self.moonfactor = 0
    self.bodyequipfactor = 0
    self.trinketfactor = 0
    self.rate = 0 --每秒x点

    self.careful = false
    
end)

function Vigour:IsCarefulWalking()
    return self.careful
end

function Vigour:OnSave()    
    return 
    {
		vigour = self.currentvigour,
		penalty = self.penalty > 0 and self.penalty or nil,
        --rate = self.rate
	}
end

function Vigour:OnLoad(data)
    self.penalty = data.penalty or self.penalty
    --self.rate = data.rate or self.rate
    if data.vigour then
        self:SetVal(data.vigour, "file_load")
	elseif data.percent then
		self:SetPercent(data.percent, "file_load")
    end
end

function Vigour:SetPercent(percent, cause)
    self:SetVal(self.maxvigour*percent, cause)
    self:DoDelta(0)
end

function Vigour:GetPercent()
    return self.currentvigour / self.maxvigour
end

function Vigour:SetMaxVigour(amount)
    self.maxvigour = amount
    self.currentvigour = amount
end

function Vigour:SetMinVigour(amount)
    self.minvigour = amount
end

function Vigour:GetMaxVigour()
    return (self.maxvigour - self.penalty*60)
end

function Vigour:DoDelta(amount, inst, cause)    
    local old_percent = self:GetPercent()
    self:SetVal(self.currentvigour + amount, cause,inst)
    local new_percent = self:GetPercent()
end

function Vigour:SetVal(val, cause,inst)
    local old_percent = self:GetPercent()

    self.currentvigour = val
    if self.currentvigour > self:GetMaxVigour() then
        self.currentvigour = self:GetMaxVigour()
    end

    if self.minvigour and self.currentvigour < self.minvigour then
        self.currentvigour = self.minvigour
    end
    if self.currentvigour < 0 then
        self.currentvigour = 0
    end

    local new_percent = self:GetPercent()

    GetWorld():PushEvent("vigour_change", {inst = inst , cause = cause} ) 
    
end

function Vigour:GetRate()
    self.rate = self.moonfactor + self.trinketfactor + self.bodyequipfactor
	return self.rate
end

function Vigour:OnUpdate()
    self:Recalc()
end

function Vigour:Recalc()
    local dt=0.0333333
    self:DoDelta(self.rate*dt)
end

return Vigour