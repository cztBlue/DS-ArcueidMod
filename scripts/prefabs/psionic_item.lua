local assets={
	Asset("ANIM", "anim/psionic_moonseed.zip"),
	Asset("ATLAS", "images/inventoryimages/psionic_moonseed.xml"),
	Asset("ANIM", "anim/psionic_soil.zip"),
	Asset("ATLAS", "images/inventoryimages/psionic_soil.xml"),
	Asset("ANIM", "anim/psionic_liquid.zip"),
	Asset("ATLAS", "images/inventoryimages/psionic_liquid.xml"),
	Asset("ANIM", "anim/psionic_holypetal.zip"),
	Asset("ATLAS", "images/inventoryimages/psionic_holypetal.xml"),
	Asset("ANIM", "anim/psionic_norsoil.zip"),
	Asset("ATLAS", "images/inventoryimages/psionic_norsoil.xml"),
	Asset("ANIM", "anim/psionic_gorypetal.zip"),
	Asset("ATLAS", "images/inventoryimages/psionic_gorypetal.xml"),
	Asset("ANIM", "anim/psionic_thirstyfruit.zip"),
	Asset("ATLAS", "images/inventoryimages/psionic_thirstyfruit.xml"),
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
	
	-- if IsDLCEnabled(CAPY_DLC) then
	-- 	MakeInventoryFloatable(inst, "idle_water", "idle")
	-- end

	inst.AnimState:SetBank("psionic_"..str)
    inst.AnimState:SetBuild("psionic_"..str)
    inst.AnimState:PlayAnimation("idle",true)

	inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst:AddComponent("stackable")

	inst.components.inventoryitem.imagename = "psionic_"..str
    inst.components.inventoryitem.atlasname = "images/inventoryimages/psionic_"..str..".xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
    
    return inst
end

--灵化种子
local function moonseed()
	local inst = commonfn("moonseed")
    inst:AddComponent("plantable_psionic")
    inst:AddComponent("tradable")
    inst:AddTag("lettervalue")
	inst.components.tradable.goldvalue = 1
	return inst
end

--碎土
local function norsoil()
	local inst = commonfn("norsoil")
	return inst
end

--灵化土壤
local function soil()
	local inst = commonfn("soil")
	return inst
end

--灵液
local function liquid()
	local inst = commonfn("liquid")
	return inst
end

--圣之花
local function holypetal()
	local inst = commonfn("holypetal")
	return inst
end

--腥
local function gorypetal()
	local inst = commonfn("gorypetal")
	return inst
end

--嗜
local function thirstyfruit()
	local inst = commonfn("thirstyfruit")
	return inst
end


return 
Prefab( "common/inventory/psionic_moonseed", moonseed, assets, prefabs),
Prefab( "common/inventory/psionic_soil", soil, assets, prefabs),
Prefab( "common/inventory/psionic_liquid", liquid, assets, prefabs),
Prefab( "common/inventory/psionic_holypetal", holypetal, assets, prefabs),
Prefab( "common/inventory/psionic_gorypetal", gorypetal, assets, prefabs),
Prefab( "common/inventory/psionic_thirstyfruit", thirstyfruit, assets, prefabs),
Prefab( "common/inventory/psionic_norsoil", norsoil, assets, prefabs)