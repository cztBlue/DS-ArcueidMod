local assets = {
    Asset("ANIM", "anim/arcueid_letter_normal.zip"),
    Asset("ANIM", "anim/arcueid_letterpaper.zip"),
	Asset("ATLAS", "images/inventoryimages/letter_normal.xml"),
    Asset("IMAGE", "images/inventoryimages/letter_normal.tex"),
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
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    -- inst:AddComponent("stackable")

    inst.AnimState:SetBank("arcueid_"..str)
    inst.AnimState:SetBuild("arcueid_"..str)
    inst.AnimState:PlayAnimation("idle")

    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..str..".xml"
    inst.components.inventoryitem.imagename = str

    -- inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    return inst
end

local function readfn(inst, reader)
    reader:PushEvent("OpenNormalLetter")
	return true
end

--letter
local function letter_normal()
    local inst = commonfn("letter_normal")


    inst:AddComponent("book")
    inst.components.book:SetOnReadFn(readfn)
    inst.components.book:SetAction(ACTIONS.READLETTER)
    return inst
end


return Prefab("common/inventory/arcueid_letter_normal", letter_normal, assets, prefabs)
