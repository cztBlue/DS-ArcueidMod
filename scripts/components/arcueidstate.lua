local ArcueidState = Class(function(self, inst)
    self.inst = inst
    self.careful = false
    self.iceskill_cooldown = 0
    self.martyrseal_cooldown = 0
    self.martyrseal_highlight = 0
end)

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


--arcueid.lua注册OnUpdate
function ArcueidState:OnUpdate()
    local dt = 0.0333333
    if self.iceskill_cooldown >= 0 then
        self.iceskill_cooldown = self.iceskill_cooldown - dt
    end

    if self.martyrseal_cooldown >= 0 then
        self.martyrseal_cooldown = self.martyrseal_cooldown - dt
    end

    if self.martyrseal_highlight >= 0 then
        self.martyrseal_highlight = self.martyrseal_highlight - dt
    end
end

return ArcueidState
