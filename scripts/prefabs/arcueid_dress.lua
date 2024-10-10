local assets =
{
    Asset("ANIM", "anim/dress_ice.zip"),
    Asset("ANIM", "anim/dress_redmoon.zip"),

    Asset("ATLAS", "images/inventoryimages/ice.xml"),
    Asset("ATLAS", "images/inventoryimages/redmoon.xml"),
}

local prefabs = {}

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function commonfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    --物品栏类型的物理碰撞
    MakeInventoryPhysics(inst)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst:AddComponent("equippable")

    return inst
end

--身缠冰河
local function ice()
    local inst = commonfn()
    --动画资源
    inst.AnimState:SetBank("dress_ice")
    inst.AnimState:SetBuild("dress_ice")
    inst.AnimState:PlayAnimation("anim")

    --可漂浮
    if IsDLCEnabled(CAPY_DLC) then
        MakeInventoryFloatable(inst, "idle_water", "idle")
    end

    inst.components.inventoryitem.imagename = "ice"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ice.xml"

    --装备类型
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY

    --发光(125, 249, 255)电蓝色
    local light = inst.entity:AddLight()
    light:SetIntensity(.4)
    light:SetFalloff(2)
    light:SetRadius(4)
    light:SetColour(125 / 255, 249 / 255, 255 / 255)
    light:Enable(false)

    --隔热
    inst.components.equippable.insulated = true

    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.bodyequipfactor = -0.06
            owner.AnimState:OverrideSymbol("torso", "dress_ice", "torso")
            owner.AnimState:OverrideSymbol("face", "dress_ice", "face")
            owner.AnimState:OverrideSymbol("arm_upper_skin", "dress_ice", "arm_upper_skin")
            owner.AnimState:OverrideSymbol("arm_lower", "dress_ice", "arm_lower")
            owner.AnimState:OverrideSymbol("foot", "dress_ice", "foot")
            owner.AnimState:OverrideSymbol("hand", "dress_ice", "hand")
            owner.AnimState:OverrideSymbol("headbase", "dress_ice", "headbase")
            owner.AnimState:OverrideSymbol("headbase_hat", "dress_ice", "headbase_hat")
            owner.AnimState:OverrideSymbol("hair", "dress_ice", "hair")
            owner.components.health.fire_damage_scale = 0
            if owner.components.combat:GetWeapon() ~= nil and owner.components.combat:GetWeapon().prefab == "sharpclaw" then
                owner.components.inventory:Unequip(EQUIPSLOTS.HANDS)
            end
            light:Enable(true)
        end
    end)
    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.bodyequipfactor = 0
            owner.AnimState:OverrideSymbol("torso", "arcueid", "torso")
            owner.AnimState:OverrideSymbol("face", "arcueid", "face")
            owner.AnimState:OverrideSymbol("arm_upper_skin", "arcueid", "arm_upper_skin")
            owner.AnimState:OverrideSymbol("arm_lower", "arcueid", "arm_lower")
            owner.AnimState:OverrideSymbol("foot", "arcueid", "foot")
            owner.AnimState:OverrideSymbol("hand", "arcueid", "hand")
            owner.AnimState:OverrideSymbol("headbase", "arcueid", "headbase")
            owner.AnimState:OverrideSymbol("headbase_hat", "arcueid", "headbase_hat")
            owner.AnimState:OverrideSymbol("hair", "arcueid", "hair")
            owner.components.health.fire_damage_scale = 1
            light:Enable(false)
        end
    end)

    inst.components.inventoryitem.cangoincontainer = false
    inst:DoTaskInTime(0, function(inst)
        if not inst.components.equippable.isequipped then
            inst:Remove()
        end
    end) --下一帧移除 脱手移除

    return inst
end


--朱月mode
local function redmoon()
    local inst = commonfn()
    inst.AnimState:SetBank("dress_redmoon")
    inst.AnimState:SetBuild("dress_redmoon")
    inst.AnimState:PlayAnimation("anim")
    inst.components.inventoryitem.imagename = "redmoon"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/redmoon.xml"

    if IsDLCEnabled(CAPY_DLC) then
        MakeInventoryFloatable(inst, "idle_water", "idle")
    end
    inst.components.equippable.equipslot = EQUIPSLOTS.TRINKET

    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.bodyequipfactor = 0
            owner.AnimState:OverrideSymbol("torso", "dress_redmoon", "torso")
            owner.AnimState:OverrideSymbol("face", "dress_redmoon", "face")
            owner.AnimState:OverrideSymbol("arm_upper_skin", "dress_redmoon", "arm_upper_skin")
            owner.AnimState:OverrideSymbol("arm_lower", "dress_redmoon", "arm_lower")
            owner.AnimState:OverrideSymbol("arm_upper", "dress_redmoon", "arm_upper")
            owner.AnimState:OverrideSymbol("foot", "dress_redmoon", "foot")
            owner.AnimState:OverrideSymbol("hand", "dress_redmoon", "hand")
            owner.AnimState:OverrideSymbol("headbase", "dress_redmoon", "headbase")
            owner.AnimState:OverrideSymbol("headbase_hat", "dress_redmoon", "headbase_hat")
            owner.AnimState:OverrideSymbol("hair", "dress_redmoon", "hair")
            owner.AnimState:OverrideSymbol("leg", "dress_redmoon", "leg")
            owner.AnimState:OverrideSymbol("hairpigtails", "dress_redmoon", "hairpigtails")
        end
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.bodyequipfactor = 0
            owner.AnimState:OverrideSymbol("torso", "arcueid", "torso")
            owner.AnimState:OverrideSymbol("face", "arcueid", "face")
            owner.AnimState:OverrideSymbol("arm_upper_skin", "arcueid", "arm_upper_skin")
            owner.AnimState:OverrideSymbol("arm_lower", "arcueid", "arm_lower")
            owner.AnimState:OverrideSymbol("arm_upper", "arcueid", "arm_upper")
            owner.AnimState:OverrideSymbol("foot", "arcueid", "foot")
            owner.AnimState:OverrideSymbol("hand", "arcueid", "hand")
            owner.AnimState:OverrideSymbol("headbase", "arcueid", "headbase")
            owner.AnimState:OverrideSymbol("headbase_hat", "arcueid", "headbase_hat")
            owner.AnimState:OverrideSymbol("hair", "arcueid", "hair")
            owner.AnimState:OverrideSymbol("leg", "arcueid", "leg")
            owner.AnimState:OverrideSymbol("hairpigtails", "arcueid", "hairpigtails")
        end
    end)
    
    inst.components.inventoryitem.cangoincontainer = false
    inst:DoTaskInTime(0, function(inst)
        if not inst.components.equippable.isequipped then
            inst:Remove()
        end
    end) --脱手移除

    return inst
end

return
    Prefab("common/inventory/dress_ice", ice, assets),
    Prefab("common/inventory/dress_redmoon", redmoon, assets)
