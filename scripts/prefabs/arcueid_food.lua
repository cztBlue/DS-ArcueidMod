local assets = {
	Asset("ANIM", "anim/arcueid_food.zip"),

	Asset("ATLAS", "images/inventoryimages/tofusoup.xml"),
	Asset("ATLAS", "images/inventoryimages/takoyaki.xml"),
	Asset("ATLAS", "images/inventoryimages/omeletterice.xml"),
	Asset("ATLAS", "images/inventoryimages/berrycake.xml"),
	Asset("ATLAS", "images/inventoryimages/shrimpfriedrice.xml"),
	Asset("ATLAS", "images/inventoryimages/sandwich.xml"),
	Asset("ATLAS", "images/inventoryimages/puff.xml"),
	Asset("ATLAS", "images/inventoryimages/piri.xml"),
	Asset("ATLAS", "images/inventoryimages/pepper.xml"),
	Asset("ATLAS", "images/inventoryimages/mixedsoup.xml"),
	Asset("ATLAS", "images/inventoryimages/ketchup.xml"),
	Asset("ATLAS", "images/inventoryimages/hotdog.xml"),
	Asset("ATLAS", "images/inventoryimages/doughnut.xml"),
	Asset("ATLAS", "images/inventoryimages/creamhoneycut.xml"),
	Asset("ATLAS", "images/inventoryimages/chocolatecookies.xml"),
	Asset("ATLAS", "images/inventoryimages/berryeggtart.xml"),

}

local prefabs =
{
}

local function commonfn(foodname)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()

	--物品栏类型的物理碰撞
	MakeInventoryPhysics(inst)

	--漂浮动画没做
	-- if IsDLCEnabled(CAPY_DLC) then
	-- 	MakeInventoryFloatable(inst, "idle_water", "idle")
	-- end

	inst.AnimState:SetBank("arcueid_food")
	inst.AnimState:SetBuild("arcueid_food")
	inst.AnimState:PlayAnimation(foodname)

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst:AddComponent("edible")
	inst:AddComponent("stackable")

	inst.components.edible.foodtype = "VEGGIE"
	inst.components.inventoryitem.imagename = foodname
	inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. foodname .. ".xml"
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

	inst.arc_hea = 0
	inst.arc_hun = 0
	inst.arc_san = 0
	inst.arc_vig = 0

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:DoTaskInTime(0, function()
		inst.components.edible.healthvalue = inst.arc_hea
		inst.components.edible.hungervalue = inst.arc_hun
		inst.components.edible.sanityvalue = inst.arc_san
	end)

	inst.SetFoodValue = function(v)
		inst.arc_hun = v[1]
		inst.arc_san = v[2]
		inst.arc_hea = v[3]
		inst.arc_vig = v[4]
	end

	return inst
end

--浆果蛋糕
local function berrycake()
	local inst = commonfn("berrycake")
	inst.components.edible.foodtype = "VEGGIE"
	inst.SetFoodValue(TUNING.ARCUEID_FOOD_VALUE_A)
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.arcueidbuff:ActiveArcueidBuff("buff_recover")
			eater.components.vigour:DoDelta(inst.arc_vig, eater, "successdish")
		end
	end)

	return inst
end

--章鱼烧
local function takoyaki()
	local inst = commonfn("takoyaki")
	inst.components.edible.foodtype = "MEAT"
	inst.SetFoodValue(TUNING.ARCUEID_FOOD_VALUE_C)
	--inst.SetFoodValue({0,0,0,-50})
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.vigour:DoDelta(inst.arc_vig, eater, "successdish")
			eater.components.arcueidbuff:ActiveArcueidBuff("buff_pieInTheSky")
		end
	end)

	return inst
end

--豆腐汤
local function tofusoup()
	local inst = commonfn("tofusoup")
	inst.components.edible.foodtype = "VEGGIE"
	inst.SetFoodValue(TUNING.ARCUEID_FOOD_VALUE_E)
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.vigour:DoDelta(inst.arc_vig, eater, "successdish")
		end
	end)

	return inst
end

--蛋包饭
local function omeletterice()
	local inst = commonfn("omeletterice")
	inst.components.edible.foodtype = "MEAT"
	inst.SetFoodValue(TUNING.ARCUEID_FOOD_VALUE_C)
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.vigour:DoDelta(inst.arc_vig, eater, "successdish")
			eater.components.arcueidbuff:ActiveArcueidBuff("buff_pieInTheSky")
		end
	end)

	return inst
end
--浆果蛋挞
local function berryeggtart()
	local inst = commonfn("berryeggtart")
	inst.SetFoodValue(TUNING.ARCUEID_FOOD_VALUE_C)
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.vigour:DoDelta(inst.arc_vig, eater, "successdish")
			eater.components.arcueidbuff:ActiveArcueidBuff("buff_pep")
		end
	end)

	return inst
end

--巧克力曲奇
local function chocolatecookies()
	local inst = commonfn("chocolatecookies")
	inst.SetFoodValue(TUNING.ARCUEID_FOOD_VALUE_B)
	inst.components.edible.foodtype = "VEGGIE"
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.vigour:DoDelta(inst.arc_vig, eater, "successdish")
			eater.components.arcueidbuff:ActiveArcueidBuff("buff_restore")
		end
	end)

	return inst
end

--奶油蜂蜜切饼
local function creamhoneycut()
	local inst = commonfn("creamhoneycut")
	inst.SetFoodValue(TUNING.ARCUEID_FOOD_VALUE_A)
	inst.components.edible.foodtype = "VEGGIE"
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.vigour:DoDelta(inst.arc_vig, eater, "successdish")
			eater.components.arcueidbuff:ActiveArcueidBuff("buff_restore")
		end
	end)

	return inst
end
--甜甜圈
local function doughnut()
	local inst = commonfn("doughnut")
	inst.SetFoodValue(TUNING.ARCUEID_FOOD_VALUE_B)
	inst.components.edible.foodtype = "VEGGIE"
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.vigour:DoDelta(inst.arc_vig, eater, "successdish")
			eater.components.arcueidbuff:ActiveArcueidBuff("buff_rest")
		end
	end)

	return inst
end

--热狗
local function hotdog()
	local inst = commonfn("hotdog")
	inst.SetFoodValue(TUNING.ARCUEID_FOOD_VALUE_E)
	inst.components.edible.foodtype = "MEAT"
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.vigour:DoDelta(inst.arc_vig, eater, "successdish")
			eater.components.arcueidbuff:ActiveArcueidBuff("buff_rest", 110)
		end
	end)

	return inst
end
--番茄酱
local function ketchup()
	local inst = commonfn("ketchup")
	inst.SetFoodValue(TUNING.ARCUEID_FOOD_VALUE_C)
	inst.components.edible.foodtype = "VEGGIE"
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.vigour:DoDelta(inst.arc_vig, eater, "successdish")
		end
	end)

	return inst
end
--杂炖鲜汤
local function mixedsoup()
	local inst = commonfn("mixedsoup")
	inst.SetFoodValue(TUNING.ARCUEID_FOOD_VALUE_A)
	inst.components.edible.foodtype = "VEGGIE"
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.vigour:DoDelta(inst.arc_vig, eater, "successdish")
			eater.components.arcueidbuff:ActiveArcueidBuff("buff_halo")
			eater.components.arcueidbuff:ActiveArcueidBuff("buff_recover")
		end
	end)

	return inst
end
--辣椒
local function pepper()
	local inst = commonfn("pepper")
	inst.SetFoodValue(TUNING.ARCUEID_FOOD_VALUE_C)
	inst.components.edible.foodtype = "VEGGIE"
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.vigour:DoDelta(inst.arc_vig, eater, "successdish")
		end
	end)

	return inst
end
--辣椒酱
local function piri()
	local inst = commonfn("piri")
	inst.SetFoodValue(TUNING.ARCUEID_FOOD_VALUE_C)
	inst.components.edible.foodtype = "VEGGIE"
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.vigour:DoDelta(inst.arc_vig, eater, "successdish")
		end
	end)

	return inst
end
--泡芙
local function puff()
	local inst = commonfn("puff")
	inst.SetFoodValue(TUNING.ARCUEID_FOOD_VALUE_D)
	inst.components.edible.foodtype = "VEGGIE"
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.vigour:DoDelta(inst.arc_vig, eater, "successdish")
			eater.components.arcueidbuff:ActiveArcueidBuff("buff_pep")
			-- eater.components.arcueidstate:DoDeltaForErosion_DEEP(30)
		end
	end)

	return inst
end
--三明治
local function sandwich()
	local inst = commonfn("sandwich")
	inst.SetFoodValue(TUNING.ARCUEID_FOOD_VALUE_B)
	inst.components.edible.foodtype = "MEAT"
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			--test
			-- GetWorld():PushEvent("generadog") 
			-- GetSeasonManager():StartPrecip()
			-- eater.components.arcueidstate:DoDeltaForErosion_TEMP(30)
			eater.components.vigour:DoDelta(inst.arc_vig, eater, "successdish")
			eater.components.arcueidbuff:ActiveArcueidBuff("buff_pieInTheSky")
		end
	end)

	return inst
end
--虾仁炒饭
local function shrimpfriedrice()
	local inst = commonfn("shrimpfriedrice")
	inst.SetFoodValue(TUNING.ARCUEID_FOOD_VALUE_C)
	inst.components.edible.foodtype = "MEAT"
	inst.components.edible:SetOnEatenFn(function(inst, eater)
		if eater:HasTag("arcueid") then
			eater.components.vigour:DoDelta(inst.arc_vig, eater, "successdish")
			eater.components.arcueidbuff:ActiveArcueidBuff("buff_halo")
		end
	end)

	return inst
end

return
	Prefab("common/inventory/arcueid_food_omeletterice", omeletterice, assets, prefabs),
	Prefab("common/inventory/arcueid_food_takoyaki", takoyaki, assets, prefabs),
	Prefab("common/inventory/arcueid_food_tofusoup", tofusoup, assets, prefabs),
	Prefab("common/inventory/arcueid_food_berrycake", berrycake, assets, prefabs),
	Prefab("common/inventory/arcueid_food_shrimpfriedrice", shrimpfriedrice, assets, prefabs),
	Prefab("common/inventory/arcueid_food_sandwich", sandwich, assets, prefabs),
	Prefab("common/inventory/arcueid_food_puff", puff, assets, prefabs),
	Prefab("common/inventory/arcueid_food_piri", piri, assets, prefabs),
	Prefab("common/inventory/arcueid_food_pepper", pepper, assets, prefabs),
	Prefab("common/inventory/arcueid_food_mixedsoup", mixedsoup, assets, prefabs),
	Prefab("common/inventory/arcueid_food_ketchup", ketchup, assets, prefabs),
	Prefab("common/inventory/arcueid_food_hotdog", hotdog, assets, prefabs),
	Prefab("common/inventory/arcueid_food_doughnut", doughnut, assets, prefabs),
	Prefab("common/inventory/arcueid_food_creamhoneycut", creamhoneycut, assets, prefabs),
	Prefab("common/inventory/arcueid_food_chocolatecookies", chocolatecookies, assets, prefabs),
	Prefab("common/inventory/arcueid_food_berryeggtart", berryeggtart, assets, prefabs)
