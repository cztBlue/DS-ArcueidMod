local Rotationupdater = Class(function(self, inst)
    self.inst = inst
end)

function Rotationupdater:OnEntitySleep()
    self.inst:StopUpdatingComponent(self)
end

function Rotationupdater:OnEntityWake()
    self.inst:StartUpdatingComponent(self)
end

function Rotationupdater:OnUpdate(dt)
    local downvec = TheCamera:GetDownVec()
    local facedown = -(math.atan2(downvec.z, downvec.x) * (180/math.pi))	
    self.inst.Transform:SetRotation(facedown)
end

return Rotationupdater