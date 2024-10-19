local assets={
	Asset("ANIM", "anim/arcueid_consume_luckybag.zip"),
	Asset("ATLAS", "images/inventoryimages/arcueid_consume.xml"),
}

local prefabs = {}

local function commonfn(str)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    --物品栏类型的物理碰撞
    MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("arcueid_consume_"..str)
    inst.AnimState:SetBuild("arcueid_consume_"..str)
    inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

	inst.components.inventoryitem.imagename = "arcueid_consume_"..str
    inst.components.inventoryitem.atlasname = "images/inventoryimages/arcueid_consume.xml"

	return inst
end

--可以抽到的饰品
local normaltrinket = 
{
    "trinket_relaxationbook",
    "trinket_eternallight",
    "trinket_seasoningbottle",
    "trinket_firstcanon"
}
local function luckybag()
    local inst = commonfn("luckybag")
    inst:AddComponent("normalaction")
    inst.normalactionfn = function (inst_)
        if inst_ then
            inst_:Remove()
        end
        local dice = math.random(999999)
        if dice % 100 < 20  then
            GetPlayer().components.inventory:GiveItem(SpawnPrefab(normaltrinket[((dice % #normaltrinket) + 1)]))
        else
            GetPlayer().components.inventory:GiveItem(SpawnPrefab("base_moonglass"))
        end
        
    end
	return inst
end

return 
Prefab( "common/inventory/arcueid_consume_luckybag", luckybag, assets, prefabs)