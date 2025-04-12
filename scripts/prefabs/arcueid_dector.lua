local assets={
    Asset("ANIM", "anim/arcueid_dector.zip"), -- 装饰
}

local function commonfn(str)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

	inst.AnimState:SetBank("arcueid_dector")
    inst.AnimState:SetBuild("arcueid_dector")
    inst.AnimState:PlayAnimation(str)

    return inst
end

local function shadow1()
	local inst = commonfn("s-0")
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(-3)
	return inst
end

local function shadow2()
	local inst = commonfn("s-1")
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(-3)
	return inst
end

return 
Prefab( "common/inventory/dector_shadow1", shadow1, assets, {}),
Prefab( "common/inventory/dector_shadow2", shadow2, assets, {})