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
    MakeInventoryPhysics(inst)

    -- if IsDLCEnabled(CAPY_DLC) then
    -- 	MakeInventoryFloatable(inst, "idle_water", "idle")
    -- end
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    -- inst:AddComponent("stackable")

    inst.AnimState:SetBank("arcueid_" .. str)
    inst.AnimState:SetBuild("arcueid_" .. str)
    inst.AnimState:PlayAnimation("idle")

    inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. str .. ".xml"
    inst.components.inventoryitem.imagename = str

    return inst
end

--用来记录信封页数
local page = {}
page[0] = 4
page[1] = 1
------------

local function letter_normal()
    local inst = commonfn("letter_normal")
    inst:AddComponent("book")
    inst.components.book:SetOnReadFn(function (inst, reader)
        reader:PushEvent("OpenNormalLetter",{letterid = inst.letterid,total = page[inst.letterid]})
    return true
    end)
    inst.components.book:SetAction(ACTIONS.READLETTER)
    -- inst.letterid = math.random(0,1)
    inst.letterid = 0
    inst.displaynamefn = function (inst)
        local str = "手书 #"..tostring(inst.letterid)
        return str
    end
    inst.OnSave = function(inst, data)
        data.letterid = inst.letterid
        return data
	end
	inst.OnLoad = function(inst, data)
        inst.letterid = data.letterid
	end
    -- inst:ListenForEvent("vigour_change", function() print(inst.letterid) end, GetWorld())
    return inst
end

return Prefab("common/inventory/arcueid_letter_normal", letter_normal, assets, prefabs)
