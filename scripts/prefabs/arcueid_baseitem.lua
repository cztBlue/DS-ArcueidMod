local assets={
	Asset("ANIM", "anim/base_moonglass.zip"),
	Asset("ANIM", "anim/base_gemfragment.zip"),
	Asset("ANIM", "anim/base_moonrock_nugget.zip"),
	Asset("ANIM", "anim/base_horrorfuel.zip"),
	Asset("ANIM", "anim/base_puregem.zip"),
	Asset("ANIM", "anim/base_moonempyreality.zip"),
	Asset("ANIM", "anim/base_gemblock.zip"),
	Asset("ANIM", "anim/base_polishgem.zip"),
	Asset("ANIM", "anim/base_puremoonempyreality.zip"),
	
	Asset("ATLAS", "images/inventoryimages/moonglass.xml"),
	Asset("ATLAS", "images/inventoryimages/gemfragment.xml"),
	Asset("ATLAS", "images/inventoryimages/moonrock_nugget.xml"),
	Asset("ATLAS", "images/inventoryimages/horrorfuel.xml"),
	Asset("ATLAS", "images/inventoryimages/puregem.xml"),
	Asset("ATLAS", "images/inventoryimages/moonempyreality.xml"),
	Asset("ATLAS", "images/inventoryimages/gemblock.xml"),
	Asset("ATLAS", "images/inventoryimages/polishgem.xml"),
	Asset("ATLAS", "images/inventoryimages/puremoonempyreality.xml"),
	--要显示在配方里的基础材料要保持资源名和预制体名一致
	Asset("ATLAS", "images/inventoryimages/base_moonglass.xml"),
	Asset("ATLAS", "images/inventoryimages/base_gemfragment.xml"),
	Asset("ATLAS", "images/inventoryimages/base_moonrock_nugget.xml"),
	Asset("ATLAS", "images/inventoryimages/base_horrorfuel.xml"),
	Asset("ATLAS", "images/inventoryimages/base_puregem.xml"),
	Asset("ATLAS", "images/inventoryimages/base_moonempyreality.xml"),
	Asset("ATLAS", "images/inventoryimages/base_gemblock.xml"),
	Asset("ATLAS", "images/inventoryimages/base_polishgem.xml"),
	Asset("ATLAS", "images/inventoryimages/base_puremoonempyreality.xml"),
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
	
	--漂浮动画没做
	-- if IsDLCEnabled(CAPY_DLC) then
	-- 	MakeInventoryFloatable(inst, "idle_water", "idle")
	-- end

	inst.AnimState:SetBank("base_"..str)
    inst.AnimState:SetBuild("base_"..str)
    inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst:AddComponent("stackable")

	inst.components.inventoryitem.imagename = str
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..str..".xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    
    return inst
end

--月亮水晶
local function moonglass()
	local inst = commonfn("moonglass")
	inst.AnimState:PlayAnimation("f1")
	return inst
end

--宝石碎片
local function gemfragment()
	local inst = commonfn("gemfragment")
	return inst
end

--月岩
local function moonrock_nugget()
	local inst = commonfn("moonrock_nugget")
	return inst
end

--纯粹恐惧
local function CreateCore()
	local inst = CreateEntity()

	inst:AddTag("FX")
	--[[Non-networked entity]]
	--inst.entity:SetCanSleep(false)
	inst.persists = false

	inst.entity:AddTransform()
	inst.entity:AddAnimState()

	inst.AnimState:SetBank("base_horrorfuel")
	inst.AnimState:SetBuild("base_horrorfuel")
	inst.AnimState:PlayAnimation("middle_loop", true)
	inst.AnimState:SetFinalOffset(1)

	inst.currentlight = 0
	inst.targetlight = 0

	return inst
end

local function horrorfuel()
	local inst = commonfn("horrorfuel")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:SetMultColour(1, 1, 1, 0.5)

	inst.core = CreateCore()
	inst.core.entity:SetParent(inst.entity)

	return inst
end

--纯粹宝石
local function puregem()
	local inst = commonfn("puregem")
	return inst
end

--弥散月质 
local function moonempyreality()
	local inst = commonfn("moonempyreality")
	inst.AnimState:PlayAnimation("idle_flight_loop",true)
	return inst
end

--精粹月质
local function puremoonempyreality()
	local inst = commonfn("puremoonempyreality")
	inst.AnimState:PlayAnimation("idle_loop",true)
	return inst
end

--宝石块
local function gemblock()
	local inst = commonfn("gemblock")
	return inst
end

--打磨宝石
local function polishgem()
	local inst = commonfn("polishgem")
	return inst
end

return 
Prefab( "common/inventory/base_moonglass", moonglass, assets, prefabs),
Prefab( "common/inventory/base_gemfragment", gemfragment, assets, prefabs),
Prefab( "common/inventory/base_moonrock_nugget", moonrock_nugget, assets, prefabs),
Prefab( "common/inventory/base_horrorfuel", horrorfuel, assets, prefabs),
Prefab( "common/inventory/base_puregem", puregem, assets, prefabs),
Prefab( "common/inventory/base_moonempyreality", moonempyreality, assets, prefabs),
Prefab( "common/inventory/base_gemblock", gemblock, assets, prefabs),
Prefab( "common/inventory/base_polishgem", polishgem, assets, prefabs),
Prefab( "common/inventory/base_puremoonempyreality", puremoonempyreality, assets, prefabs)