local assets={
	Asset("ANIM", "anim/potion_holywater.zip"),
	Asset("ATLAS", "images/inventoryimages/potion_holywater.xml"),
}

local prefabs = 
{
}

local function commonfn(str)
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --物品栏类型的物理碰撞
    MakeInventoryPhysics(inst)
	inst.AnimState:SetBank("potion_"..str)
    inst.AnimState:SetBuild("potion_"..str)
    inst.AnimState:PlayAnimation("idle")
	inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst:AddComponent("stackable")
	inst:AddComponent("edible")
	inst.components.edible.foodtype = "VEGGIE"
	inst.components.inventoryitem.imagename = "potion_"..str
    inst.components.inventoryitem.atlasname = "images/inventoryimages/potion_"..str..".xml"
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

return 
Prefab( "common/inventory/potion_holywater", holywater, assets, prefabs)