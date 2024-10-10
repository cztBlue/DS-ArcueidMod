local assets =
{
    Asset("ANIM", "anim/trinket_relaxationbook.zip"),
    Asset("ANIM", "anim/trinket_mooncloak.zip"),
    Asset("ANIM", "anim/trinket_eternallight.zip"),
    Asset("ANIM", "anim/trinket_shadowcloak.zip"),
    Asset("ANIM", "anim/trinket_moonamulet.zip"),
    Asset("ANIM", "anim/trinket_seasoningbottle.zip"),
    Asset("ANIM", "anim/trinket_icecrystal.zip"),
    Asset("ANIM", "anim/trinket_jadestar.zip"),
    Asset("ANIM", "anim/trinket_moonring.zip"),
    Asset("ANIM", "anim/trinket_moonwristband.zip"),
    Asset("ANIM", "anim/trinket_propheteye.zip"),
    Asset("ANIM", "anim/trinket_twelvedice.zip"),
    Asset("ANIM", "anim/trinket_spiritbottle.zip"),
    Asset("ANIM", "anim/trinket_martyrseal.zip"),
    Asset("ANIM", "anim/trinket_jadeblade.zip"),
    Asset("ANIM", "anim/trinket_firstcanon.zip"),
    Asset("ANIM", "anim/trinket_sacrificeknife.zip"),

    Asset("ATLAS", "images/inventoryimages/relaxationbook.xml"),
    Asset("ATLAS", "images/inventoryimages/mooncloak.xml"),
    Asset("ATLAS", "images/inventoryimages/eternallight.xml"),
    Asset("ATLAS", "images/inventoryimages/shadowcloak.xml"),
    Asset("ATLAS", "images/inventoryimages/moonamulet.xml"),
    Asset("ATLAS", "images/inventoryimages/seasoningbottle.xml"),
    Asset("ATLAS", "images/inventoryimages/icecrystal.xml"),
    Asset("ATLAS", "images/inventoryimages/jadestar.xml"),
    Asset("ATLAS", "images/inventoryimages/moonring.xml"),
    Asset("ATLAS", "images/inventoryimages/moonwristband.xml"),
    Asset("ATLAS", "images/inventoryimages/propheteye.xml"),
    Asset("ATLAS", "images/inventoryimages/twelvedice.xml"),
    Asset("ATLAS", "images/inventoryimages/spiritbottle.xml"),
    Asset("ATLAS", "images/inventoryimages/martyrseal.xml"),
    Asset("ATLAS", "images/inventoryimages/jadeblade.xml"),
    Asset("ATLAS", "images/inventoryimages/firstcanon.xml"),
    Asset("ATLAS", "images/inventoryimages/sacrificeknife.xml"),
}

local prefabs = {}

local function commonfn(str)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()

    --物品栏类型的物理碰撞
    MakeInventoryPhysics(inst)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst:AddComponent("equippable")

    inst.AnimState:SetBank("trinket_" .. str)
    inst.AnimState:SetBuild("trinket_" .. str)
    inst.AnimState:PlayAnimation("idle")

    inst.components.inventoryitem.imagename = str
    inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. str .. ".xml"

    --装备类型
    if GetPlayer().prefab == "arcueid" then
        inst.components.equippable.equipslot = EQUIPSLOTS.TRINKET
    else
        inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    end

    return inst
end

----------------------饰品方法------------------

--休憩之书
local function relaxationbook()
    local inst = commonfn("relaxationbook")

    --可漂浮
    -- if IsDLCEnabled(CAPY_DLC) then
    -- 	MakeInventoryFloatable(inst, "idle_water", "idle")
    -- end

    --护甲 --参数解释InitCondition(amount, absorb_percent)
    -- inst:AddComponent("armor")
    -- inst.components.armor:InitCondition(TUNING.ARMORWOOD, TUNING.ARMORWOOD_ABSORPTION)

    -- --inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL     --装备回san值
    -- --inst.components.equippable.walkspeedmult = 2    --装备后移速倍率

    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = TUNING.ARCUEID_VIGOURBUFF_E
            owner.components.arcueidbuff.islastbuffactive['lbuff_recover'] = true
            owner.components.arcueidbuff.islastbuffactive['lbuff_dehunger'] = true
            owner.components.arcueidbuff.islastbuffactive['lbuff_pep'] = true
        end
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = 0
            owner.components.arcueidbuff.islastbuffactive['lbuff_recover'] = false
            owner.components.arcueidbuff.islastbuffactive['lbuff_dehunger'] = false
            owner.components.arcueidbuff.islastbuffactive['lbuff_pep'] = false
        end
        --owner.AnimState:ClearOverrideSymbol("swap_body")
    end)

    return inst
end

--月光斗篷
local function mooncloak()
    local inst = commonfn("mooncloak")

    --隔热
    inst.components.equippable.insulated = true
    --防水
    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(1)

    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = TUNING.ARCUEID_VIGOURBUFF_C
        end
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = 0
        end
    end)

    return inst
end

--不灭烛
local function eternallight()
    local inst = commonfn("eternallight")

    --发光（175 238 238）苍白的绿宝石色
    local light = inst.entity:AddLight()
    light:SetIntensity(.6)
    light:SetFalloff(2)
    light:SetRadius(5)
    light:SetColour(175 / 255, 238 / 255, 238 / 255)
    light:Enable(false)

    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = -TUNING.ARCUEID_VIGOURBUFF_E

            --动态光源?
            owner.fire = SpawnPrefab("eternalfire")
            local follower = owner.fire.entity:AddFollower()
            follower:FollowSymbol(owner.GUID, "swap_object", -120, -175, 2)

            inst.SoundEmitter:PlaySound("dontstarve/wilson/torch_LP", "torch")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/torch_swing")
            inst.SoundEmitter:SetParameter( "torch", "intensity", 1 )
        end
    end)



    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = 0
            -- light:Enable(false)

            owner.fire:Remove()
            owner.fire = nil

            --inst.SoundEmitter:KillSound("torch")
            inst.SoundEmitter:PlaySound("dontstarve/common/fireOut")
        end
    end)

    -- InventoryItems automatically enable their lights when dropped, so we need to counteract that
    inst:ListenForEvent("ondropped", function(inst)
        if inst.currentTempRange ~= 5 then
            light:SetIntensity(.6)
            light:SetFalloff(2)
            light:SetRadius(.7)
            light:SetColour(175 / 255, 238 / 255, 238 / 255)
            light:Enable(true)
            inst.Light:Enable(true)
        end
    end)

    return inst
end

--阴影斗篷
local function shadowcloak()
    local inst = commonfn("shadowcloak")

    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = -TUNING.ARCUEID_VIGOURBUFF_E
        end
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = 0
            inst:AddTag("character")
            inst:AddTag("scarytoprey")
            inst:AddTag("player")
        end
    end)
    return inst
end

--月亮吊坠
local function moonamulet()
    local inst = commonfn("moonamulet")
    inst:AddTag("fogproof")
    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = TUNING.ARCUEID_VIGOURBUFF_C
        end
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = 0
        end
    end)

    return inst
end

--调料瓶
local function seasoningbottle()
    local inst = commonfn("seasoningbottle")

    inst:AddTag("maketool")

    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = -TUNING.ARCUEID_VIGOURBUFF_D
        end
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = 0
        end
    end)

    return inst
end

--立冬
local function icecrystal()
    local inst = commonfn("icecrystal")

    inst:AddComponent("lizhuang")

    --用耐久代替冷却系统？
    inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(100)
	inst.components.finiteuses:SetUses(100)
	inst.components.finiteuses:SetOnFinished(function(inst)end)
	--inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 99)

    inst.components.equippable:SetOnEquip(function(inst, owner)
        owner.components.vigour.trinketfactor = -TUNING.ARCUEID_VIGOURBUFF_E
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid"
            and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil
            and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab == "dress_ice" then
            owner.components.inventory:Unequip(EQUIPSLOTS.BODY)
        end
    end)

    return inst
end

--翡翠星星
local function jadestar()
    local inst = commonfn("jadestar")

    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = -TUNING.ARCUEID_VIGOURBUFF_D
            owner.components.arcueidbuff.islastbuffactive['lbuff_echou'] = true
        end
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.arcueidbuff.islastbuffactive['lbuff_echou'] = false
            if owner:HasTag("monster") then
                owner:RemoveTag("monster")
                owner.components.leader:RemoveFollowersByTag("pig")
                owner.components.leader:RemoveFollowersByTag("spider")
            end
        end
    end)

    return inst
end

--第一圣典
local function firstcanon()
    local inst = commonfn("firstcanon")

    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = -TUNING.ARCUEID_VIGOURBUFF_C
        end
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = 0
        end
    end)

    return inst
end

--翡翠之刃
local function jadeblade()
    local inst = commonfn("jadeblade")

    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = -TUNING.ARCUEID_VIGOURBUFF_D
        end
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = 0
        end
    end)

    return inst
end

--赴死者勋
local function martyrseal()
    local inst = commonfn("martyrseal")

    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = TUNING.ARCUEID_VIGOURBUFF_E
        end
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = 0
        end
    end)

    inst:ListenForEvent("activeforcefield", function()
        if GetPlayer().prefab == "arcueid"
            and GetPlayer().components.arcueidstate.martyrseal_cooldown <= 0 then
            --15分钟冷却
            GetPlayer().components.arcueidstate.martyrseal_cooldown = 60 * 15
            inst.fx = SpawnPrefab("forcefieldfx")
            inst.fx.entity:SetParent(GetPlayer().entity)
            inst.fx.Transform:SetPosition(0, 0.2, 0)
            inst.fx.AnimState:SetMultColour(0 / 255, 0 / 255, 255 / 255, 1)
            local fx_hitanim = function()
                inst.fx.AnimState:PlayAnimation("hit")
                --inst.fx.AnimState:PushAnimation("idle_loop")
            end
            inst:DoTaskInTime(TUNING.MARTYRSEAL_HUGHLIGHT_TIME, function(self)
                if self.fx then
                    self.fx:Remove()
                    self.fx = nil
                end
            end)
        end
    end)
    return inst
end

--瓶中灵
local function spiritbottle()
    local inst = commonfn("spiritbottle")

    --深橙色（255,140,0）
    local light = inst.entity:AddLight()
    light:SetIntensity(.3)
    light:SetFalloff(2)
    light:SetRadius(1.7)
    light:SetColour(255 / 255, 140 / 255, 0 / 255)
    light:Enable(false)
    inst:AddComponent("touch_bottle")
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL

    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = TUNING.ARCUEID_VIGOURBUFF_D
            light:Enable(true)
        end
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = 0
            light:Enable(false)
        end
    end)

    return inst
end

--十二面骰子
local function twelvedice()
    local inst = commonfn("twelvedice")
    inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL

    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = -TUNING.ARCUEID_VIGOURBUFF_D
        end
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = 0
        end
    end)

    return inst
end

--先知之眼
--洞察：概率暴击，1%必杀
--睿智：可解锁物品
local function propheteye()
    local inst = commonfn("propheteye")

    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = -TUNING.ARCUEID_VIGOURBUFF_C
            --owner.components.builder.ingredientmod = 1
        end
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = 0
            --owner.components.builder.ingredientmod = 1.5
        end
    end)

    return inst
end

--月亮护腕
--防残疾
local function moonwristband()
    local inst = commonfn("moonwristband")

    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = TUNING.ARCUEID_VIGOURBUFF_D
        end
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = 0
        end
    end)

    return inst
end

--月亮指环
--防致盲
local function moonring()
    local inst = commonfn("moonring")

    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = TUNING.ARCUEID_VIGOURBUFF_C
        end
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = 0
        end
    end)

    return inst
end

--献祭小刀
local function sacrificeknife()
    local inst = commonfn("sacrificeknife")
    inst:AddComponent("lizhuang")
    inst:AddTag("maketool")

    inst.components.equippable:SetOnEquip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = 0
        end
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid" then
            owner.components.vigour.trinketfactor = 0
        end
    end)

    return inst
end



local function icecrystal()
    local inst = commonfn("icecrystal")

    inst:AddComponent("lizhuang")

    --用耐久代替冷却系统？
    inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(100)
	inst.components.finiteuses:SetUses(100)
	inst.components.finiteuses:SetOnFinished(function(inst)end)
	--inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 99)

    inst.components.equippable:SetOnEquip(function(inst, owner)
        owner.components.vigour.trinketfactor = -TUNING.ARCUEID_VIGOURBUFF_E
    end)

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if owner.prefab == "arcueid"
            and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil
            and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab == "dress_ice" then
            owner.components.inventory:Unequip(EQUIPSLOTS.BODY)
        end
    end)

    return inst
end

return
    Prefab("common/inventory/trinket_relaxationbook", relaxationbook, assets),
    Prefab("common/inventory/trinket_mooncloak", mooncloak, assets),
    Prefab("common/inventory/trinket_eternallight", eternallight, assets),
    Prefab("common/inventory/trinket_shadowcloak", shadowcloak, assets),
    Prefab("common/inventory/trinket_moonamulet", moonamulet, assets),
    Prefab("common/inventory/trinket_seasoningbottle", seasoningbottle, assets),
    Prefab("common/inventory/trinket_icecrystal", icecrystal, assets),
    Prefab("common/inventory/trinket_moonring", moonring, assets),
    Prefab("common/inventory/trinket_moonwristband", moonwristband, assets),
    Prefab("common/inventory/trinket_propheteye", propheteye, assets),
    Prefab("common/inventory/trinket_twelvedice", twelvedice, assets),
    Prefab("common/inventory/trinket_spiritbottle", spiritbottle, assets),
    Prefab("common/inventory/trinket_martyrseal", martyrseal, assets),
    Prefab("common/inventory/trinket_jadeblade", jadeblade, assets),
    Prefab("common/inventory/trinket_jadestar", jadestar, assets),
    Prefab("common/inventory/trinket_firstcanon", firstcanon, assets),
    Prefab("common/inventory/trinket_sacrificeknife", sacrificeknife, assets)
