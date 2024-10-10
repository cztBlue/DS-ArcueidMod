--building
require "prefabutil"
require "tuning"

local assets =
{
	Asset("ANIM", "anim/building_psionic_farm.zip"),
}

local prefabs = {}

local function OnLoad(inst, data)
end

local function OnSave(inst, data)
end


local function onhammered(inst, worker)
	inst:Remove()
end

local function onhit(inst, worker)
end

local function onbuilt(inst)
end

local function commonfn(str)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local minimap = inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()

	--地图图标
	-- minimap:SetPriority(5)
	-- minimap:SetIcon(str .. ".tex")

	--日常动画
	anim:SetBank("building_" .. str)
	anim:SetBuild("building_" .. str)
	anim:PlayAnimation("idle", true)

	--TAG
	inst:AddTag("structure")
	inst:AddTag("playerowned")
	inst:AddComponent("inspectable")

	--操作组件
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	inst:ListenForEvent("onbuilt", onbuilt)

	--雪覆盖特性
	MakeSnowCovered(inst, .01)

	inst.OnLoad = OnLoad
	inst.OnSave = OnSave

	return inst
end

local rates = 
{
	TUNING.FARM1_GROW_BONUS,
	TUNING.FARM2_GROW_BONUS,
	TUNING.FARM3_GROW_BONUS,
}


local croppoints = {
	{ Vector3(0,0,0) },
	{ Vector3(0,0,0) },
	{ Vector3(0,0,0) },
}

local function setfertilityfn(inst, fert_percent)
	local anim = "full"
	if fert_percent <= 0 then
		anim = "empty"
	elseif fert_percent <= .33 then
		anim = "med2"
	elseif fert_percent <= .66 then
		anim = "med1"
	end
	-- inst.AnimState:PlayAnimation("anim")
end

local function psionic_farm()
    local inst = commonfn("psionic_farm")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
    MakeObstaclePhysics(inst, .1)
    local level = 2
    inst:AddComponent("savedrotation")

    inst:AddComponent("grower_psionic")
    inst.components.grower_psionic.level = level
    inst.components.grower_psionic.onplantfn = function() inst.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds") end
    inst.components.grower_psionic.croppoints = croppoints[level]
    inst.components.grower_psionic.growrate = rates[level]
    
    local cycles_per_level = {10,20,30}
    
    inst.components.grower_psionic.max_cycles_left = cycles_per_level[level] or 6
    inst.components.grower_psionic.cycles_left = inst.components.grower_psionic.max_cycles_left
    inst.components.grower_psionic.setfertility = setfertilityfn



	--后注入覆盖
	--onhammered
	inst.components.workable:SetOnFinishCallback(function(inst, worker)
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
		inst:Remove()
	end)

	--onhit
	inst.components.workable:SetOnWorkCallback(function(inst, worker)
	end)

	inst.OnSave = function(inst, data)
	end

	inst.OnLoad = function(inst, data)
	end

	return inst
end

return
Prefab("common/objects/building_psionic_farm", psionic_farm, assets), 
MakePlacer("common/building_psionic_farm_placer", "building_psionic_farm", "building_psionic_farm", "idle")