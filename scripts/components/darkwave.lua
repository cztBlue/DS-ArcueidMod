local DarkWave = Class(function(self, inst)
    self.inst = inst
    self.curnum = 0
    --start,stop
    self.spawnmode = "stop"
    GetWorld():ListenForEvent("generadog", function()
        self.spawnmode = "start"
        self.curnum = 1
    end)
    self.inst:StartUpdatingComponent(self)
end)

local DARK_SPAWN_DIST = 10


function DarkWave:GetSpawnPoint(pt)
    local theta = math.random() * 2 * PI
    local radius = DARK_SPAWN_DIST

    local offset = FindWalkableOffset(pt, theta, radius, 12, true)
    if offset then
        return pt + offset
    end
end

function DarkWave:SpawnDarkCreature()
    if self.curnum <= 0 then
        self.spawnmode = "stop"
        return
    end

    local pt = Vector3(GetPlayer().Transform:GetWorldPosition())
    local spawn_pt = self:GetSpawnPoint(pt)
    if spawn_pt and self.curnum >= 0 then
        self.curnum = self.curnum - 1
        local darkcreature = SpawnPrefab("hound")
        if darkcreature then
            darkcreature.Physics:Teleport(spawn_pt:Get())
            darkcreature:FacePoint(pt)
            darkcreature.components.combat:SuggestTarget(GetPlayer())
        end
    end
end

function DarkWave:OnUpdate(dt)
    if self.spawnmode == "stop" then
        return
    end
    self:SpawnDarkCreature()
end

return DarkWave
