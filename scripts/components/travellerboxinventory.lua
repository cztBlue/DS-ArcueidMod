-- 根箱组件重写
local RootTrunkInventory = Class(function(self, inst)
	self.inst = inst
	self.inst:DoTaskInTime(0,function() self:SpawnTrunk() end)
end)


function RootTrunkInventory:OnSave()
	local data = {}	
	local refs = {}
	if self.trunk and self.trunk:IsValid() then
		data.trunk = self.trunk.GUID
		table.insert(refs,data.trunk)	
	end
	return data, refs
end

function RootTrunkInventory:OnLoad(data)
	if data.trunk then
		self.cancelspawn = true
	end
end

function RootTrunkInventory:LoadPostPass(ents, data)
	if data.trunk and ents[data.trunk] then
		self.trunk = ents[data.trunk].entity
	else 
		print("ROOT TRUNK WARNING: THERE WAS AN ERROR! THE OLD TRUNK WAS NOT FOUND, MUST CREATE A NEW ONE. ")
		self.trunk = nil
	end
end

function RootTrunkInventory:LongUpdate(dt)

end

function RootTrunkInventory:OnUpdate( dt )

end

function RootTrunkInventory:empty( target )
	local t_cont = target.components.container
	local cont = self.trunk.components.container
	if t_cont and cont then
		for i,slot in pairs(cont.slots) do
			local item = cont:RemoveItemBySlot(i)
			local success = t_cont:GiveItem(item, i, nil, nil, true)

			-- Notes(DiogoW): The root trunk no longer accepts irreplaceable items,
			-- but irreplaceable items already inside are dropped at (0,0,0) because of it.
			-- This solves the issue.

			if not success and item and item:IsValid() then
				item.Transform:SetPosition(t_cont.inst.Transform:GetWorldPosition())
				if item.components.inventoryitem then
					item.components.inventoryitem:OnDropped(true)
				end
			end
		end
	end	
end

function RootTrunkInventory:fill( source )
	local s_cont = source.components.container
	local cont = self.trunk.components.container
	if s_cont and cont then
		for i,slot in pairs(s_cont.slots) do
			local item = s_cont:RemoveItemBySlot(i)
			cont:GiveItem(item, i, nil, nil, true)
		end
	end	
end

function RootTrunkInventory:SpawnTrunk()
	if not self.trunk then
		print("SPAWN TRUNK!!!!!!!!!!!!!!!!!!!!!!!!")
		self.trunk = SpawnPrefab("roottrunk")
	end
	self.trunk:RemoveFromScene()
end

return RootTrunkInventory
