local assets={
	Asset("ATLAS", "images/inventoryimages/sharpclaw.xml"),
    Asset("IMAGE", "images/inventoryimages/sharpclaw.tex"),

	Asset("ANIM", "anim/sharpclaw.zip"),
	Asset("ANIM", "anim/swap_arcueid_sharpclaw.zip"),
}

local prefabs = {}

--预设没有耐久，不启用
-- local function onfinished(inst)
--     inst:Remove()
-- end

local function CheckEquipped(inst)
    --下一帧没被装备则移除
    if not inst.components.equippable.isequipped then       
        inst:Remove() 
    end
end

--每次攻击活力值减3
local function onattack(inst, attacker, target)
    if attacker and attacker.prefab == "arcueid" 
    and attacker.components.arcueidbuff.islastbuffactive["lbuff_blightedbody"] == true then
        attacker.components.vigour:DoDelta(-3,attacker,"clawattack")
    end
    local slash = SpawnPrefab("ef_darkscar")
    local pt = Vector3(target.Transform:GetWorldPosition()) + Vector3(math.random() * 2 - 1, 1 + math.random() * 2 - 1, 0.5)
    slash.Transform:SetPosition(pt:Get())
end


local function fn(colour)
    --爪子不用特别显示出装备动画
    local function OnEquip(inst, owner)
        owner.AnimState:OverrideSymbol("hand", "swap_arcueid_sharpclaw", "hand")
        owner.AnimState:OverrideSymbol("swap_object", "swap_arcueid_sharpclaw", "sharpclaw")
        owner.AnimState:Show("ARM_carry") 
        owner.AnimState:Hide("ARM_normal") 
    end

    local function OnUnequip(inst, owner) 
        owner.AnimState:Hide("ARM_carry") 
        owner.AnimState:Show("ARM_normal") 
        inst:DoTaskInTime(0,inst.Remove) --脱手移除
    end

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("sharpclaw")
    anim:SetBuild("sharpclaw")
    anim:PlayAnimation("idle")

	inst:AddTag("sharp")

	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(60)
    inst.components.weapon:SetOnAttack(onattack)

    --能挖能砍
    -- inst:AddComponent("tool")
    -- inst.components.tool:SetAction(ACTIONS.CHOP)
    -- inst.components.tool:SetAction(ACTIONS.MINE)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "sharpclaw"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/sharpclaw.xml"
    
	inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )


    inst.components.inventoryitem.cangoincontainer = false
    inst:DoTaskInTime(0,CheckEquipped)    --下一帧移除 脱手移除

    inst:AddTag("sharpclaw")

    return inst
end

return  Prefab("common/inventory/sharpclaw", fn, assets, prefabs)