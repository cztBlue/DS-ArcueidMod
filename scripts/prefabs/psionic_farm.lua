--building
require "prefabutil"
require "tuning"

local assets =
{
	Asset("ANIM", "anim/building_psionic_farm.zip"),
	Asset("ANIM", "anim/psionic_farm_decor.zip"),
}

local prefabs =
{}

local back = -1
local left = 1.5
local right = -1.5
local rock_front = 1
local decor_farm =
{
	-- left side
	{
		psionic_farm_decor_crystal1 = {
			{ right + 3.0,  0, rock_front + 0.2 },
			{ right + 3.05, 0, rock_front - 1.5 },
		}
	},

	{ psionic_farm_decor_crystal3 = { { right + 3.07, 0, rock_front - 1.0 }, } },
	{ psionic_farm_decor_crystal2 = { { right + 3.06, 0, rock_front - 0.4 }, } },

	-- right side
	{ psionic_farm_decor_crystal1 = { { left - 3.05, 0, rock_front - 1.0 }, } },
	{ psionic_farm_decor_crystal3 = { { left - 3.07, 0, rock_front - 1.5 }, } },
	{ psionic_farm_decor_crystal2 = { { left - 3.06, 0, rock_front - 0.4 }, } },

	-- front row
	{
		psionic_farm_decor_crystal1 = {
			{ right + 1.1, 0, rock_front + 0.21 },
			{ right + 2.4, 0, rock_front + 0.25 },
		}
	},

	{ psionic_farm_decor_crystal3 = { { right + 0.5, 0, rock_front + 0.195 }, } },

	{
		psionic_farm_decor_crystal2 = {
			{ right + 0.0, 0, rock_front - 0.0 },
			{ right + 1.8, 0, rock_front + 0.22 },
		}
	},

	-- back row
	{
		psionic_farm_decor_crystal1 = {

			{ left - 1.3, 0, back - 0.19 },
		}
	},

	{
		psionic_farm_decor_crystal3 = {
			{ left - 0.5, 0, back - 0.21 },
			{ left - 2.5, 0, back - 0.22 },
		}
	},

	{
		psionic_farm_decor_crystal2 = {
			{ left + 0.0, 0, back - 0.15 },
			{ left - 3.0, 0, back - 0.20 },
			{ left - 1.9, 0, back - 0.205 },
		}
	},
}

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
	inst.components.workable:SetOnFinishCallback(function(inst, worker)
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
		inst:Remove()
	end)
	inst.components.workable:SetOnWorkCallback(function(inst, worker) end)

	inst:ListenForEvent("onbuilt", function(inst) end)

	--雪覆盖特性
	MakeSnowCovered(inst, .01)

	inst.OnLoad = function(inst, data) end
	inst.OnSave = function(inst, data) end

	return inst
end

local function makeprefab_dec(name, buildname, animname)
	local function makefn(animname)
		local function fn()
			local inst = CreateEntity()
			local trans = inst.entity:AddTransform()
			local anim = inst.entity:AddAnimState()
			inst:AddTag("DECOR")

			anim:SetBank(buildname)
			anim:SetBuild(buildname)
			anim:PlayAnimation(animname)

			return inst
		end
		return fn
	end

	local function ass(buildname)
		return {
			Asset("ANIM", "anim/" .. buildname .. ".zip"),
		}
	end

	return Prefab("psionic_farm_decor_" .. name, makefn(animname),ass(buildname))
end

local function psionic_farm()
	local inst = commonfn("psionic_farm")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)

	inst:AddComponent("grower_psionic")
	inst.components.grower_psionic.level = 3
	inst.components.grower_psionic.onplantfn = function() inst.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds") end
	inst.components.grower_psionic.croppoints = { Vector3(0, 0, 0) }
	inst.components.grower_psionic.growrate = TUNING.FARM3_GROW_BONUS
	inst.components.grower_psionic.max_cycles_left = 30
	inst.components.grower_psionic.cycles_left = inst.components.grower_psionic.max_cycles_left
	inst.components.grower_psionic.setfertility = function(inst, fert_percent) end

	--添加装饰物
	inst.decor = {}
	for k, item_info in pairs(decor_farm) do
		for item_name, item_offsets in pairs(item_info) do
			for l, offset in pairs(item_offsets) do
				local item_inst = SpawnPrefab(item_name)
				item_inst.entity:SetParent(inst.entity)
				item_inst.Transform:SetPosition(offset[1], offset[2], offset[3])
				table.insert(inst.decor, item_inst)
			end
		end
	end
	inst.highlightchildren = inst.decor


	inst.OnSave = function(inst, data) end

	inst.OnLoad = function(inst, data) end

	return inst
end


local function placerdecor()
	return function(inst)
		inst.AnimState:SetLayer(LAYER_BACKGROUND)
		inst.AnimState:SetSortOrder(3)

		inst.components.placer.fixedcameraoffset = 90

		--Show decor on top of the ground placer
		for i, item_info in ipairs(decor_farm) do
			for item_name, item_offsets in pairs(item_info) do
				for j, offset in ipairs(item_offsets) do
					local item_inst = SpawnPrefab(item_name)
					item_inst:AddTag("NOCLICK") --not all decor pieces come with NOCLICK by default
					item_inst:AddTag("placer")
					item_inst:AddTag("NOBLOCK")
					item_inst.entity:SetCanSleep(false)
					item_inst.entity:SetParent(inst.entity)
					item_inst.Transform:SetPosition(unpack(offset))
					item_inst.AnimState:SetLightOverride(1)
					inst.components.placer:LinkEntity(item_inst)
				end
			end
		end
	end
end

return
--装饰物
	makeprefab_dec("crystal1", "psionic_farm_decor", "c1"),
	makeprefab_dec("crystal2", "psionic_farm_decor", "c2"),
	makeprefab_dec("crystal3", "psionic_farm_decor", "c3"),
	makeprefab_dec("rock1", "psionic_farm_decor", "rock1"),
	makeprefab_dec("rock2", "psionic_farm_decor", "rock2"),
	makeprefab_dec("rock3", "psionic_farm_decor", "rock3"),
	--建筑实体
	Prefab("common/objects/building_psionic_farm", psionic_farm, assets, prefabs),
	MakePlacer("common/building_psionic_farm_placer", "building_psionic_farm", "building_psionic_farm", "idle", true, nil,
		nil, nil, nil, nil, placerdecor())
