local RiftSpawner = Class(function(self, inst)
    self.inst = inst

    self.minDist = 40
    self.maxDist = 80

    self.timetospawn_variation = TUNING.TOTAL_DAY_TIME * 1
    self.timetospawn = TUNING.TOTAL_DAY_TIME * 6
    
    self.spawntimer = self:GetSpawnTime()
    self.active = false

    self.prefab = "arcueid_shadow_rift"
    self.enabled = false

    self.validTileTypes = {4,5,6,7,30,31,45,46,47,54}
    self:Enable(false)

    self.isspawn = true

    self.inst:ListenForEvent("daytime", function(inst, data) 
        local player = GetPlayer()
        if player and player.components.age:GetAge() then
            local day = math.floor(GetWorld().components.age:GetAge() / TUNING.TOTAL_DAY_TIME)
            -- local day = GetClock().numcycles
            if day % 25 == 0 and self.isspawn == false then
                local pt = self:GetSpawnPoint(GetPlayer())
                self:SpawnFlower(pt)
                self.isspawn = true
            end
            if day % 25 ~= 0 then
                self.isspawn = false
            end
        end
    end)

end)

function RiftSpawner:Enable(enable)
    self.enabled = enable
	if self.enabled then 
		self.inst:StartUpdatingComponent(self)
	else
		self.inst:StopUpdatingComponent(self)
	end
end

function RiftSpawner:GetSpawnTime()
	return self.timetospawn + (math.random() * self.timetospawn_variation)
end

function RiftSpawner:CheckTileCompatibility(tile)
	for k,v in pairs(self.validTileTypes) do
		if v == tile then
			return true
		end
	end
end

function RiftSpawner:GetSpawnPoint(player)
	local pt = player:GetPosition()
    local theta = math.random() * 2 * PI
    local radius = math.random(self.minDist, self.maxDist)
    local steps = 40
    --local ground = GetWorld()
    local validpos = {}
    for i = 1, steps do
        local offset = Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))
        local try_pos = pt + offset
        local tile = GetVisualTileType(try_pos.x, try_pos.y, try_pos.z)
        if not (tile == GROUND.IMPASSABLE or tile > GROUND.UNDERGROUND ) and
        self:CheckTileCompatibility(tile) and 
		#TheSim:FindEntities(try_pos.x, try_pos.y, try_pos.z, 1, nil, {"FX", "NOCLICK", "INLIMBO"}) <= 0 then
			table.insert(validpos, try_pos)
        end
        theta = theta - (2 * PI / steps)
    end
    if #validpos > 0 then
    	local num = math.random(#validpos)
    	return validpos[num]
    else
    	return nil
    end
end

function RiftSpawner:SpawnFlower(pt)
	local flower = SpawnPrefab(self.prefab)
	flower.Transform:SetPosition(pt:Get())
end

function RiftSpawner:OnUpdate( dt )
    if self.active then
    	local player = GetPlayer()    
        if not player then return end

        if self.spawntimer == nil then
            self.spawntimer = self:GetSpawnTime()
        end

        self.spawntimer = self.spawntimer - dt

        if self.spawntimer <= 0 then
        	local pt = self:GetSpawnPoint(player)

        	if pt then
        		self:SpawnFlower(pt)
        	end

        	self.spawntimer = self:GetSpawnTime()
        end
    else
        self.inst:StopUpdatingComponent(self)
    end
end

function RiftSpawner:GetDebugString()
	return "Next spawn: "..tostring(self.spawntimer)
end

function RiftSpawner:OnSave()
    local data = {}
        data.spawntimer = self.spawntimer
        data.timetospawn = self.timetospawn
        data.timetospawn_variation = self.timetospawn_variation
        data.isspawn = self.isspawn
        data.active = self.active
    return data
end

function RiftSpawner:OnLoad(data)
    if data then
        self.spawntimer = data.spawntimer
        self.timetospawn = data.timetospawn or TUNING.TOTAL_DAY_TIME * 6
        self.timetospawn_variation = data.timetospawn_variation or TUNING.TOTAL_DAY_TIME * 1
        self.isspawn = data.isspawn or false
        self.active = data.active or true
        if not self.active then
            self.inst:StopUpdatingComponent(self)
        end
    end
end

function RiftSpawner:LongUpdate(dt)
    if self.enabled then
	   self:OnUpdate(dt)
    end
end

function RiftSpawner:SpawnModeNever()
    self.timetospawn_variation = -1
    self.timetospawn = -1
    self.active = false
    self.inst:StopUpdatingComponent(self)
end

function RiftSpawner:SpawnModeHeavy()
    self.timetospawn_variation = TUNING.TOTAL_DAY_TIME * 1
    self.timetospawn = TUNING.TOTAL_DAY_TIME * 2
end

function RiftSpawner:SpawnModeMed()
    self.timetospawn_variation = TUNING.TOTAL_DAY_TIME * 1
    self.timetospawn = TUNING.TOTAL_DAY_TIME * 4
end

function RiftSpawner:SpawnModeLight()
    self.timetospawn_variation = TUNING.TOTAL_DAY_TIME * 2
    self.timetospawn = TUNING.TOTAL_DAY_TIME * 10
end

return RiftSpawner
