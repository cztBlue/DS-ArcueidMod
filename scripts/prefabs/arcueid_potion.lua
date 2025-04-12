local assets={
	Asset("ANIM", "anim/potion_holywater.zip"),
	Asset("ANIM", "anim/potion_enhance.zip"),
	Asset("ATLAS", "images/inventoryimages/potion_holywater.xml"),
	Asset("ATLAS", "images/inventoryimages/potion_enhance.xml"),
}

local function commonfn(str)
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --物品栏类型的物理碰撞
    MakeInventoryPhysics(inst)
	inst.AnimState:SetBank("potion_enhance")
    inst.AnimState:SetBuild("potion_enhance")
    inst.AnimState:PlayAnimation(str)
	inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst:AddComponent("stackable")
	inst:AddComponent("edible")
	inst.components.edible.foodtype = "VEGGIE"
	inst.components.inventoryitem.imagename = "potion_"..str
    inst.components.inventoryitem.atlasname = "images/inventoryimages/potion_enhance.xml"
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    return inst
end

--洗涤水
local function holywater()
	local inst = commonfn("holywater")
	inst:DoTaskInTime(0, function()
		inst.components.edible.healthvalue = 50
		inst.components.edible.hungervalue = 0
		inst.components.edible.sanityvalue = 35
	end)
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.arcueidstate:DoDeltaForErosion_POTION(-30)
		end
	end)
	return inst
end

--红药水
local function healing()
	local inst = commonfn("healing")
	inst:DoTaskInTime(0, function()
	end)

	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.health:DoDelta(eater.components.health.maxhealth)
		end
	end)
	return inst
end

--蓝药水
local function vigour()
	local inst = commonfn("vigour")
	inst:DoTaskInTime(0, function()
		
	end)
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.vigour.DoDelta(150)
		end
	end)
	return inst
end

--抵抗药水
local function resilience()
	local inst = commonfn("resilience")
	inst:DoTaskInTime(0, function() 
		inst.components.edible.sanityvalue = -30 
	end)
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.arcueidbuff:ActiveArcueidBuff("buff_resistance")
		end
	end)
	return inst
end

--暴击药水
local function critical()
	local inst = commonfn("critical")
	inst:DoTaskInTime(0, function()
		inst.components.edible.sanityvalue = -30
	end)
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.arcueidbuff:ActiveArcueidBuff("buff_critical")
		end
	end)
	return inst
end

--汲血药水
local function bloodthirst()
	local inst = commonfn("bloodthirst")
	inst:DoTaskInTime(0, function() 
		inst.components.edible.sanityvalue = -30 
	end)
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.arcueidbuff:ActiveArcueidBuff("buff_bloodthirst")
		end
	end)
	return inst
end

return 
Prefab( "common/inventory/potion_holywater", holywater, assets, {}),
Prefab( "common/inventory/potion_vigour", vigour, assets, {}),
Prefab( "common/inventory/potion_resilience", resilience, assets, {}),
Prefab( "common/inventory/potion_critical", critical, assets, {}),
Prefab( "common/inventory/potion_bloodthirst", bloodthirst, assets, {}),
Prefab( "common/inventory/potion_healing", healing, assets, {})