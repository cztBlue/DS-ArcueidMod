require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/building_mooncirleform.zip"),
	Asset("ANIM", "anim/building_gemicebox.zip"),
	Asset("ANIM", "anim/building_travellerbox.zip"),
	Asset("ANIM", "anim/travellerbox_inv.zip"),
	Asset("ANIM", "anim/building_immortallight.zip"),
	Asset("ANIM", "anim/building_gemgenerator.zip"),
	Asset("ANIM", "anim/building_spatialanchor.zip"),
	Asset("ANIM", "anim/building_miraclecookpot.zip"),
	Asset("ANIM", "anim/building_guard.zip"),
	Asset("ANIM", "anim/building_Infinitas.zip"),
	Asset("ANIM", "anim/building_recycleform.zip"),
	Asset("ANIM", "anim/building_rottenform.zip"),
	Asset("ANIM", "anim/building_trinketworkshop.zip"),
	Asset("ANIM", "anim/building_alchemydesk.zip"),


	Asset("ANIM", "anim/ui_chest_3x3.zip"),
	Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
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

-- 九格配方合法检查
local function CanMakeAndResult(inst, Recipe)
	for k1, v1 in pairs(Recipe) do
		for k2 = 1, 9 do
			if inst.components.container.slots[k2] then
				if Recipe[k1][k2] ~= inst.components.container.slots[k2].prefab then
					break
				end
				if k2 == 9 then
					return true, k1
				end
			end

			if inst.components.container.slots[k2] == nil then
				if Recipe[k1][k2] ~= nil then
					break
				end
				if k2 == 9 then
					return true, k1
				end
			end
		end
	end
	return false
end

local function commonfn(str)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local minimap = inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()

	--地图图标
	minimap:SetPriority(5)
	minimap:SetIcon(str .. ".tex")

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


-----------------------------prefabs-----------------

--具现原理
local function CreateMoonCircleForm(techtree)
	--靠近动画
	local function OnTurnOn(inst)
		inst.components.prototyper.on = true                                    -- prototyper doesn't set this until after this function is called!!
		inst.SoundEmitter:PlaySound("dontstarve/common/ancienttable_LP", "idlesound") --远古祭坛激活的声音
		inst.AnimState:PlayAnimation("proximity_pre")
		inst.AnimState:PushAnimation("proximity_loop", true)
	end
	--远离动画
	local function OnTurnOff(inst)
		inst.components.prototyper.on = false -- prototyper doesn't set this until after this function is called
		inst.SoundEmitter:KillSound("idlesound")
		inst.AnimState:PushAnimation("proximity_pst")
		inst.AnimState:PushAnimation("idle", true)
	end

	local function mooncirleform(Sim)
		local inst = commonfn("mooncirleform")
		inst.entity:AddSoundEmitter()

		--碰撞箱
		MakeObstaclePhysics(inst, .1)

		inst:AddTag("prototyper")
		inst:AddComponent("prototyper")
		inst.components.prototyper.onturnon = OnTurnOn
		inst.components.prototyper.onturnoff = OnTurnOff
		inst.components.prototyper.trees = techtree
		inst.components.prototyper.onactivate = function()
			inst.AnimState:PlayAnimation("use")
			inst.AnimState:PushAnimation("idle")
			inst.AnimState:PushAnimation("proximity_loop", true)
			-- inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_" .. soundprefix .. "_run", "sound")
		end

		return inst
	end

	return Prefab("common/objects/building_mooncirleform", mooncirleform, assets, prefabs)
end


--宝石冰箱
local prefabs_gemicebox =
{
	"collapse_small",
}
local slotpos_gemicebox = {}
for y = 2, 0, -1 do
	for x = 0, 2 do
		table.insert(slotpos_gemicebox, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
	end
end
local function gemicebox(Sim)
	local inst = commonfn("gemicebox")

	inst:AddComponent("lootdropper")

	--碰撞箱
	MakeObstaclePhysics(inst, .02)

	--功能标签
	inst:AddTag("superfridge")

	--容器特性
	inst:AddComponent("container")
	inst.components.container:SetNumSlots(#slotpos_gemicebox)
	inst.components.container.widgetslotpos = slotpos_gemicebox
	inst.components.container.widgetanimbank = "ui_chest_3x3"
	inst.components.container.widgetanimbuild = "ui_chest_3x3"
	inst.components.container.widgetpos = Vector3(0, 200, 0)
	inst.components.container.side_align_tip = 160
	inst.components.container.itemtestfn = function(inst, item, slot)
		return (item.components.edible and item.components.perishable) or
			item.prefab == "spoiled_food" or
			item.prefab == "rottenegg" or
			item.prefab == "heatrock" or
			item:HasTag("frozen") or
			item:HasTag("icebox_valid")
	end


	-----状态动画-----
	inst.AnimState:PlayAnimation("closed")

	inst.components.container.onopenfn = function(inst)
		inst.AnimState:PlayAnimation("open")
		inst.SoundEmitter:PlaySound("dontstarve/common/craftable/icebox_open")
	end

	inst.components.container.onclosefn = function(inst)
		inst.AnimState:PlayAnimation("close")
		inst.SoundEmitter:PlaySound("dontstarve/common/craftable/icebox_close")
	end
	--后注入覆盖
	--onhammered
	inst.components.workable:SetOnFinishCallback(function(inst, worker)
		inst.components.lootdropper:DropLoot()
		inst.components.container:DropEverything()
		SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
		inst:Remove()
	end)

	--onhit
	inst.components.workable:SetOnWorkCallback(function(inst, worker)
		inst.AnimState:PlayAnimation("hit")
		inst.components.container:DropEverything()
		inst.AnimState:PushAnimation("closed", false)
		inst.components.container:Close()
	end)

	return inst
end

--旅行者时空箱
--local content_travellerbox = {}
local slotpos_travellerbox = {}
for y = 2, 0, -1 do
	for x = 0, 2 do
		table.insert(slotpos_travellerbox, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
	end
end
local function travellerbox(Sim)
	local inst = commonfn("travellerbox")

	--碰撞箱
	MakeObstaclePhysics(inst, .02)

	--容器特性
	inst:AddComponent("container")
	inst.components.container:SetNumSlots(#slotpos_travellerbox)
	inst.components.container.widgetslotpos = slotpos_travellerbox
	inst.components.container.widgetanimbank = "ui_chest_3x3"
	inst.components.container.widgetanimbuild = "ui_chest_3x3"
	inst.components.container.widgetpos = Vector3(0, 200, 0)
	inst.components.container.side_align_tip = 160

	--可燃
	--MakeSmallBurnable(inst, nil, nil, true)

	--用官方写好的根箱组件，改个名字作区别
	inst:AddComponent("travellerboxinventory")

	-----状态动画-----
	inst.AnimState:PlayAnimation("closed")

	inst:ListenForEvent("onopen", function()
		if GetWorld().components.travellerboxinventory then
			GetWorld().components.travellerboxinventory:empty(inst)
		end
	end)

	inst:ListenForEvent("onclose", function()
		if GetWorld().components.travellerboxinventory then
			GetWorld().components.travellerboxinventory:fill(inst)
		end
	end)

	inst.components.container.itemtestfn = function(inst, item, slot)
		return not item:HasTag("irreplaceable") and not item.components.leader
	end

	inst.components.container.onopenfn = function(inst)
		--inst.components.container.slots = content_travellerbox
		inst.AnimState:PlayAnimation("open")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/cork_chest/open")
	end

	inst.components.container.onclosefn = function(inst)
		--content_travellerbox = inst.components.container.slots
		inst.AnimState:PlayAnimation("close")
		inst.AnimState:PlayAnimation("closed")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/cork_chest/close")
	end
	--后注入覆盖
	--onhammered
	inst.components.workable:SetOnFinishCallback(function(inst, worker)
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
		inst:Remove()
	end)

	--onhit
	inst.components.workable:SetOnWorkCallback(function(inst, worker)
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("closed", false)
		inst.components.container:Close()
	end)

	inst:AddComponent("pickupable")
	inst.components.pickupable:SetOnPickupFn(function(inst, guy, data)
		if guy.components and guy.components.inventory then
			inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
			guy.components.inventory:GiveItem(SpawnPrefab("travellerbox_inv"))
		end

		inst:Remove()

		return true
	end)
	inst.components.pickupable.canpickupfn = function(inst)
		return true
	end

	--坑：OnSave的data不能储存复杂的预制体表（如果这样做，游戏保存时必崩溃），只能存一些简单的数据
	--shit,突然发现有根箱这个东西，白写了
	-- inst.OnSave = function(inst, data)
	-- 	if inst:HasTag("burnt") or inst:HasTag("fire") then
	-- 		data.burnt = true
	-- 	end

	-- 	if inst.honeyWasLoaded then
	-- 		data.honeyWasLoaded = inst.honeyWasLoaded
	-- 	end
	-- 	--保存时同步所有箱子内容
	-- 	inst.components.container.slots = content_travellerbox
	-- end

	-- --onload
	-- inst.OnLoad = function(inst, data)
	-- 	content_travellerbox = inst.components.container.slots
	-- end

	return inst
end

local function travellerbox_inv()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("travellerbox_inv")
	inst.AnimState:SetBuild("travellerbox_inv")
	inst.AnimState:PlayAnimation("idle")

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("travellerbox.tex")

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "travellerbox"
	inst.components.inventoryitem.atlasname = "images/map_icons/travellerbox.xml"
	--------------以上资源

	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = function(inst, pt, deployer)
		local chest = SpawnPrefab("building_travellerbox")
		if chest then
			pt = Vector3(pt.x, 0, pt.z)
			chest.Physics:SetCollides(false)
			chest.Physics:Teleport(pt.x, pt.y, pt.z)
			chest.Physics:SetCollides(true)
			chest.SoundEmitter:PlaySound("dontstarve/common/craftable/chest")
			chest.AnimState:PushAnimation("closed", true)
			inst:Remove()
		end
	end
	inst.components.deployable.placer = "building_travellerbox_placer"
	inst.components.deployable.test = function(inst, pt)
		local ground = GetWorld()
		local tile = GROUND.GRASS
		if ground and ground.Map then
			tile = ground.Map:GetTileAtPoint(pt:Get())
		end
		local onWater = ground.Map:IsWater(tile)
		return not onWater
	end

	return inst
end

--永恒魔术灯
local function immortallight(Sim)
	local inst = commonfn("immortallight")

	--碰撞箱
	MakeObstaclePhysics(inst, .1)

	--发光(64,224,208)绿宝石
	local light = inst.entity:AddLight()
	light:SetIntensity(.4)
	light:SetFalloff(2)
	light:SetRadius(8.5)
	light:SetColour(64 / 255, 224 / 255, 208 / 255)
	light:Enable(true)

	--onhammered
	inst.components.workable:SetOnFinishCallback(function(inst, worker)
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
		inst:Remove()
	end)

	--onhit
	inst.components.workable:SetOnWorkCallback(function(inst, worker)
		inst.AnimState:PlayAnimation("leave")
	end)

	inst.OnSave = function(inst, data)
	end

	inst.OnLoad = function(inst, data)
	end

	return inst
end

--宝石发生器
local gemtable = { "bluegem", "redgem", "purplegem", "orangegem", "yellowgem", "greengem" }
local gemtype = 0
--blue,purple,red,orange,yellow,green,(opalpreciousgem?还没做)
local function gemgenerator(Sim)
	local inst = commonfn("gemgenerator")

	--碰撞箱
	MakeObstaclePhysics(inst, .1)

	inst:AddComponent("fueled")
	inst.components.fueled.maxfuel = TUNING.GEMGENERATOR_FUEL_MAX
	inst.components.fueled.accepting = true
	inst.components.fueled:SetSections(4)
	inst.components.fueled.ontakefuelfn = function(inst)
		inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/machine_fuel")
		inst.components.fueled:StartConsuming()
	end

	inst.components.fueled:SetUpdateFn(function(inst, dt)
		-- TODO: summer season rate adjustment?
		inst.components.fueled.rate = 1
	end)

	inst.components.fueled:SetSectionCallback(function(new, old, inst)
		--OFF
		if new == 0 and old > 0 then
			inst.AnimState:PlayAnimation("proximity_pst")
			inst.AnimState:PushAnimation("idle", true)
			inst.SoundEmitter:KillSound("loop")
			if inst.fueltask ~= nil then
				inst.fueltask:Cancel()
				inst.fueltask = nil
			end
			--ON
		elseif new > 0 and old == 0 then
			inst.AnimState:PlayAnimation("proximity_pre")
			inst.AnimState:PushAnimation("proximity_loop", true)
			if not inst.SoundEmitter:PlayingSound("loop") then
				inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/icemachine_lp", "loop")
			end
			if inst.fueltask == nil then
				--inst.fueltask = inst:DoPeriodicTask(TUNING.ICEMAKER_SPAWN_TIME, function(inst)
				inst.fueltask = inst:DoPeriodicTask(10, function(inst)
					math.randomseed(os.time())
					inst.AnimState:PlayAnimation("use")
					inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/icemachine_start")
					inst.components.fueled:StopConsuming() -- temp pause fuel so we don't run out in the animation.
					--inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength(), function(inst)
					inst:DoTaskInTime(1.3, function(inst)
						local random = math.random()
						if random < 0.8 then
							if random < 0.8 * 2.5 / 6 then
								gemtype = 1
							elseif random < 0.8 * 5 / 6 and random > 0.8 * 2.5 / 6 then
								gemtype = 2
							elseif random < 0.8 and random > 0.8 * 5 / 6 then
								gemtype = 3
							end
						else
							if random < 0.8 + 0.2 / 3 then
								gemtype = 4
							elseif random < 0.8 + 0.2 * 2 / 3 and random > 0.8 + 0.2 / 3 then
								gemtype = 5
							elseif random < 1 and random > 0.8 + 0.2 * 2 / 3 then
								gemtype = 6
							end
						end
						local gem = SpawnPrefab(gemtable[gemtype])
						local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(0, 2, 0)
						gem.Transform:SetPosition(pt:Get())
						local down = TheCamera:GetDownVec()
						local angle = math.atan2(down.z, down.x) + (math.random() * 60) * DEGREES
						local sp = 3 + math.random()
						gem.Physics:SetVel(sp * math.cos(angle), math.random() * 2 + 8, sp * math.sin(angle))
						gem.components.inventoryitem:OnStartFalling()

						--Machine should only ever be on after spawning an gem
						inst.components.fueled:StartConsuming()
						inst.AnimState:PlayAnimation("proximity_loop", true)
					end)
				end)
			end
		end
	end)

	inst.components.fueled:InitializeFuelLevel(TUNING.GEMGENERATOR_FUEL_MAX / 2)
	inst.components.fueled:StartConsuming()

	--后注入覆盖
	--onhammered
	inst.components.workable:SetOnFinishCallback(function(inst, worker)
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
		inst:Remove()
	end)

	--onhit
	inst.components.workable:SetOnWorkCallback(function(inst, worker)
		inst.AnimState:PlayAnimation("hit")
	end)

	inst:ListenForEvent("onbuilt", function(inst)
		inst.AnimState:PlayAnimation("place")
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/icemaker_place")
	end)

	inst.OnSave = function(inst, data)
	end

	--onload
	inst.OnLoad = function(inst, data)
	end

	return inst
end

--空间锚定仪
local function spatialanchor(Sim)
	local inst = commonfn("spatialanchor")
	inst.AnimState:PlayAnimation("idle_on_loop", true)

	--碰撞箱
	MakeObstaclePhysics(inst, .1)

	inst:AddComponent("signable")
	inst:AddComponent("travelable")
	inst:AddComponent("talker")
	inst.components.travelable.dist_cost = 32

	--后注入覆盖
	--onhammered
	inst.components.workable:SetOnFinishCallback(function(inst, worker)
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
		inst:Remove()
	end)

	--onhit
	inst.components.workable:SetOnWorkCallback(function(inst, worker)
		inst.AnimState:PlayAnimation("hit_on")
	end)

	inst.OnSave = function(inst, data)
	end

	--onload
	inst.OnLoad = function(inst, data)
	end

	return inst
end

--奇迹煮锅
local function ShowProduct(inst)
	if not inst:HasTag("burnt") then
		local product = string.gsub(inst.components.stewer.product, "arcueid_food_", "");
		print(product)
		inst.AnimState:OverrideSymbol("swap_cooked", "arcueid_food", product)
	end
end

local slotpos_miraclecookpot = {}
for y = 2, 0, -1 do
	for x = 0, 2 do
		table.insert(slotpos_miraclecookpot, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
	end
end
local function miraclecookpot(Sim)
	local inst = commonfn("miraclecookpot")
	inst.AnimState:PlayAnimation("cook_pot", true)
	inst.entity:AddLight()

	--碰撞箱
	MakeObstaclePhysics(inst, .5)

	inst.Light:Enable(false)
	inst.Light:SetRadius(.6)
	inst.Light:SetFalloff(1)
	inst.Light:SetIntensity(.5)
	inst.Light:SetColour(235 / 255, 62 / 255, 12 / 255)

	local widgetbuttoninfo = {
		text = STRINGS.ACTIONS.COOK.GENERIC,
		position = Vector3(0, -165, 0),
		fn = function(inst)
			inst.components.stewer:StartCooking()
		end,

		validfn = function(inst)
			return inst.components.stewer:CanCook()
		end,
	}

	inst:AddComponent("stewer")
	inst.components.stewer.onstartcooking = function(inst)
		if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("cooking_loop", true)
			--play a looping sound
			inst.SoundEmitter:KillSound("snd")
			inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
			inst.Light:Enable(true)
		end
	end
	inst.components.stewer.oncontinuecooking = function(inst)
		if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("cooking_loop", true)
			--play a looping sound
			inst.Light:Enable(true)

			inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
		end
	end
	inst.components.stewer.oncontinuedone = function(inst)
		if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("idle_full")
			ShowProduct(inst)
		end
	end
	inst.components.stewer.ondonecooking = function(inst)
		if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("cooking_pst")
			inst.AnimState:PushAnimation("idle_full")
			ShowProduct(inst)
			inst.SoundEmitter:KillSound("snd")
			inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish", "snd")
			inst.Light:Enable(false)
			--play a one-off sound
		end
	end
	inst.components.stewer.onharvest = function(inst)
		if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("idle_empty")
		end
	end
	inst.components.stewer.onspoil = function(inst)
		if not inst:HasTag("burnt") then
			inst.components.stewer.product = inst.components.stewer.spoiledproduct
			ShowProduct(inst)
		end
	end

	inst:AddComponent("container")
	inst.components.container:SetNumSlots(#slotpos_miraclecookpot)
	inst.components.container.widgetslotpos = slotpos_miraclecookpot
	inst.components.container.widgetanimbank = "ui_chest_3x3"
	inst.components.container.widgetanimbuild = "ui_chest_3x3"
	inst.components.container.widgetpos = Vector3(0, 200, 0)
	inst.components.container.side_align_tip = 100
	inst.components.container.widgetbuttoninfo = widgetbuttoninfo
	inst.components.container.acceptsstacks = false
	inst.components.container.type = "cooker"
	inst.components.container.onopenfn = function(inst)
		GetPlayer():PushEvent("OpenCraftRecipesFood")
	end
	inst.components.container.onclosefn = function(inst)
		GetPlayer():PushEvent("CloseCraftRecipesFood")
	end

	--后注入覆盖
	--onhammered
	inst.components.workable:SetOnFinishCallback(function(inst, worker)
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_pot")
		inst:Remove()
	end)

	--onhit
	inst.components.workable:SetOnWorkCallback(function(inst, worker)
		inst.AnimState:PlayAnimation("hit_empty")
	end)

	inst.OnSave = function(inst, data)
	end

	--onload
	inst.OnLoad = function(inst, data)
	end

	return inst
end

--魔术守卫
local function guard(Sim)
	local inst = commonfn("guard")
	inst.AnimState:PlayAnimation("proximity_loop", true)
	inst.Transform:SetFourFaced()

	--碰撞箱
	MakeObstaclePhysics(inst, .7)

	--特征标签
	inst:AddTag("eyeturret")
	inst:AddTag("companion")

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(2000)
	inst.components.health:StartRegen(20, 1)

	inst:AddComponent("combat")
	inst.components.combat:SetRange(20)
	inst.components.combat:SetDefaultDamage(100)
	inst.components.combat:SetAttackPeriod(2)
	inst.components.combat:SetRetargetFunction(1, function(inst)
		local newtarget = FindEntity(inst, 20, function(guy)
			return guy.components.combat and
				inst.components.combat:CanTarget(guy) and
				(guy.components.combat.target == GetPlayer() or GetPlayer().components.combat.target == guy)
		end, nil, { "eyeturret" })
		-- print("YesTarget")
		-- if newtarget then
		-- 	print(newtarget.prefab)
		-- end
		return newtarget
	end)
	inst.components.combat:SetKeepTargetFunction(function(inst, target)
		if target and target:IsValid() and
			(target.components.health and not target.components.health:IsDead()) then
			local distsq = target:GetDistanceSqToInst(inst)
			return distsq < 20 * 20
		else
			return false
		end
	end)

	inst:AddComponent("lighttweener")
	local light = inst.entity:AddLight()
	inst.components.lighttweener:StartTween(light, 0, .65, .7, { 251 / 255, 234 / 255, 234 / 255 }, 0,
		function(inst, light) if light then light:Enable(false) end end)

	inst.dotweenin = function(inst, l)
		inst.components.lighttweener:StartTween(nil, 0, .65, .7, nil, 0.15,
			function(i, light) if light then light:Enable(false) end end)
	end

	MakeLargeFreezableCharacter(inst)

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:ListenForEvent("attacked", function(inst, data)
		local attacker = data and data.attacker
		if attacker == GetPlayer() then
			return
		end
		inst.components.combat:SetTarget(attacker)
		inst.components.combat:ShareTarget(attacker, 15, function(dude) return dude:HasTag("eyeturret") end, 10)
	end)

	--这个实现有点生草
	inst:AddComponent("inventory")
	inst:DoTaskInTime(1, function(inst)
		if inst.components.inventory and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
			local weapon = CreateEntity()
			weapon.entity:AddTransform()
			weapon:AddComponent("weapon")
			weapon.components.weapon:SetDamage(inst.components.combat.defaultdamage)
			weapon.components.weapon:SetRange(inst.components.combat.attackrange, inst.components.combat.attackrange + 4)
			weapon.components.weapon:SetProjectile("eye_charge")
			weapon:AddComponent("inventoryitem")
			weapon.persists = false
			weapon.components.inventoryitem:SetOnDroppedFn(function(inst) inst:Remove() end)
			weapon:AddComponent("equippable")

			inst.components.inventory:Equip(weapon)
		end
	end)


	inst:DoPeriodicTask(1, function()
		local pos = Vector3(inst.Transform:GetWorldPosition())
		local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 20)
		for k, v in pairs(ents) do
			local pt1 = v:GetPosition()
			--攻击条件
			if v.components.combat and v.components.health and not v.components.health:IsDead()
				and (v.components.combat.target == inst or
					v:HasTag("monster") or v.components.combat.target == GetPlayer()
					or GetPlayer().components.combat.target == v)
				and v ~= GetPlayer() then
				inst.components.combat:SetTarget(v)
				inst.components.combat:DoAttack()
			end
		end
	end)


	--后注入覆盖
	--onhammered
	inst.components.workable:SetOnFinishCallback(function(inst, worker)
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
		inst:Remove()
	end)

	--onhit
	inst.components.workable:SetOnWorkCallback(function(inst, worker)
		inst.AnimState:PlayAnimation("hit_proximity")
	end)

	inst.OnSave = function(inst, data)
	end

	--onload
	inst.OnLoad = function(inst, data)
	end

	return inst
end

--Infinitas箱
local slotpos_infinitas_3x4 = {}
for y = 2.5, -0.5, -1 do
	for x = 0, 2 do
		table.insert(slotpos_infinitas_3x4, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
	end
end
local function infinitas(Sim)
	local inst = commonfn("infinitas")
	inst.AnimState:PlayAnimation("closed")

	--按键功能
	local widgetbuttoninfo = {
		text = "丢弃",
		position = Vector3(0, -140, 0),
		fn = function(inst)
			for k = 1, 9 do
				local item = inst.components.container:GetItemInSlot(k)
				if item ~= nil then
					item:Remove()
				end
			end
		end,
	}

	--碰撞箱
	MakeObstaclePhysics(inst, .1)

	inst:AddComponent("container")
	inst.components.container:SetNumSlots(#slotpos_infinitas_3x4)
	inst.components.container.widgetslotpos = slotpos_infinitas_3x4
	inst.components.container.widgetanimbank = "ui_chester_shadow_3x4"
	inst.components.container.widgetanimbuild = "ui_chester_shadow_3x4"
	inst.components.container.widgetpos = Vector3(0, 220, 0)
	inst.components.container.widgetpos_controller = Vector3(0, 220, 0)
	inst.components.container.side_align_tip = 160
	inst.components.container.widgetbuttoninfo = widgetbuttoninfo

	--后注入覆盖
	--onhammered
	inst.components.workable:SetOnFinishCallback(function(inst, worker)
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
		inst:Remove()
	end)

	--onhit
	inst.components.workable:SetOnWorkCallback(function(inst, worker)
		inst.AnimState:PlayAnimation("hit")
	end)

	inst.OnSave = function(inst, data)
	end

	--onload
	inst.OnLoad = function(inst, data)
	end

	return inst
end

--第二分解术式
local recycletable = {
	--紫宝石5->1碎片，50%纯粹恐惧
	["purplegem"] = { 5, { "base_gemfragment", 1 }, { "base_horrorfuel", .5 }, },
	["redgem"] = { 15, { "base_gemfragment", 1 }, },
	["orangegem"] = { 3, { "base_gemfragment", 3 }, { "base_moonempyreality" }, 1 },
	["yellowgem"] = { 3, { "base_gemfragment", 3 }, { "base_moonempyreality" }, 1 },
	["greengem"] = { 2, { "base_gemfragment", 3 }, { "base_moonempyreality" }, 1 },
	--月亮
	["base_moonrock_nugget"] = { 10, { "rocks", 10 }, { "base_moonempyreality", 1 }, },
	["base_moonglass"] = { 3, { "base_gemfragment", 3 }, { "base_moonempyreality", 1 }, },
	--分解饰品
	["trinket_relaxationbook"] = { 1, { "base_moonglass", 8 }, },
	["trinket_moonamulet"] = { 1, { "base_moonglass", 25 }, },
	["trinket_moonwristband"] = { 1, { "base_moonglass", 25 }, },
	["trinket_moonring"] = { 1, { "base_moonglass", 25 }, },
	["trinket_mooncloak"] = { 1, { "base_moonglass", 25 }, },
	["trinket_firstcanon"] = { 1, { "base_moonglass", 13 }, },
	["trinket_jadestar"] = { 1, { "base_moonglass", 17 }, },
	["trinket_jadeblade"] = { 1, { "base_moonglass", 17 }, },
	["trinket_shadowcloak"] = { 1, { "base_moonglass", 25 }, },
	["trinket_martyrseal"] = { 1, { "base_moonglass", 20 }, },
	["trinket_spiritbottle"] = { 1, { "base_moonglass", 7 }, },
	["trinket_twelvedice"] = { 1, { "base_moonglass", 8 }, },
	["trinket_propheteye"] = { 1, { "base_moonglass", 18 }, },
	["trinket_icecrystal"] = { 1, { "base_moonglass", 30 }, },
	["trinket_seasoningbottle"] = { 1, { "base_moonglass", 2 }, },
	["trinket_eternallight"] = { 1, { "base_moonglass", 4 }, },
}
local function recycleform(Sim)
	local inst = commonfn("recycleform")

	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)

	local function heapup(inst, replacement)
		if replacement[2] ~= nil then
			if replacement[2][2] >= 1 then
				for i = 1, replacement[2][2], 1 do
					local item2 = inst.components.container:GetItemInSlot(2)
					if item2 and item2.prefab == replacement[2][1] and (item2.components.stackable and not item2.components.stackable:IsFull()) then
						item2.components.stackable:SetStackSize(item2.components.stackable.stacksize + 1)
					else
						inst.components.container:GiveItem(SpawnPrefab(replacement[2][1]), 2)
					end
				end
			elseif replacement[2][2] < 1 and math.random() < replacement[2][2] then
				local item2 = inst.components.container:GetItemInSlot(2)
				if item2 and item2.prefab == replacement[2][1] and (item2.components.stackable and not item2.components.stackable:IsFull()) then
					item2.components.stackable:SetStackSize(item2.components.stackable.stacksize + 1)
				else
					inst.components.container:GiveItem(SpawnPrefab(replacement[2][1]), 2)
				end
			end
		end

		if replacement[3] ~= nil then
			if replacement[3][2] >= 1 then
				for i = 1, replacement[3][2], 1 do
					local item2 = inst.components.container:GetItemInSlot(3)
					if item2 and item2.prefab == replacement[3][1] and (item2.components.stackable and not item2.components.stackable:IsFull()) then
						item2.components.stackable:SetStackSize(item2.components.stackable.stacksize + 1)
					else
						inst.components.container:GiveItem(SpawnPrefab(replacement[3][1]), 3)
					end
				end
			elseif replacement[3][2] < 1 and math.random() < replacement[3][2] then
				local item2 = inst.components.container:GetItemInSlot(3)
				if item2 and item2.prefab == replacement[3][1] and (item2.components.stackable and not item2.components.stackable:IsFull()) then
					item2.components.stackable:SetStackSize(item2.components.stackable.stacksize + 1)
				else
					inst.components.container:GiveItem(SpawnPrefab(replacement[3][1]), 3)
				end
			end
		end
	end

	--碰撞箱
	--MakeObstaclePhysics(inst, 0)

	local widgetbuttoninfo = {
		text = "分解",
		position = Vector3(0, -140, 0),
		fn = function(inst)
			local item = inst.components.container:GetItemInSlot(1)
			if item then
				if recycletable[item.prefab] ~= nil then
					local replacement = recycletable[item.prefab]
					-- replacement foramt such as {5(consume once),{xx,1},{aa,2}}

					if replacement and item.components.stackable and item.components.stackable.stacksize > replacement[1] then
						inst.components.container:ConsumeByName(item.prefab, replacement[1])
						heapup(inst, replacement)
					end

					if item.components.stackable == nil then --分解饰品
						inst.components.container:ConsumeByName(item.prefab, replacement[1])
						heapup(inst, replacement)
					end
				else
					GetPlayer().components.talker:Say("放的东西不对。")
				end
			end
		end
	}

	local slotpos = { Vector3(-80, 0, 0), Vector3(80, 80, 0), Vector3(80, -80, 0) }

	inst:AddComponent("container")
	inst.components.container:SetNumSlots(#slotpos)
	inst.components.container.widgetslotpos = slotpos
	inst.components.container.widgetanimbank = "ui_chest_3x3"
	inst.components.container.widgetanimbuild = "ui_chest_3x3"
	inst.components.container.widgetpos = Vector3(0, 200, 0)
	inst.components.container.side_align_tip = 100
	inst.components.container.widgetbuttoninfo = widgetbuttoninfo
	inst.components.container.itemtestfn = function(inst, item, slot)
		if slot == 1 and recycletable[item.prefab] ~= nil then
			return true
		end
		if slot == 2 then
			return true
		end
		if slot == 3 then
			return true
		end
	end

	inst.components.container.onopenfn = function(inst) end
	inst.components.container.onclosefn = function(inst) end

	--后注入覆盖
	--onhammered
	inst.components.workable:SetOnFinishCallback(function(inst, worker)
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
		inst:Remove()
	end)

	--onhit
	inst.components.workable:SetOnWorkCallback(function(inst, worker)
		inst.AnimState:PlayAnimation("idle")
	end)

	inst.OnSave = function(inst, data)
	end

	--onload
	inst.OnLoad = function(inst, data)
	end

	return inst
end

--腐败滋生术式 x20
local slotpos_rottenform = {}
for y = 2, 0, -1 do
	for x = 0, 2 do
		table.insert(slotpos_rottenform, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
	end
end
local function rottenform(Sim)
	local inst = commonfn("rottenform")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)

	--碰撞箱
	--MakeObstaclePhysics(inst, 0)

	inst:AddTag("superrotten")

	--容器特性
	inst:AddComponent("container")
	inst.components.container:SetNumSlots(#slotpos_gemicebox)
	inst.components.container.widgetslotpos = slotpos_gemicebox
	inst.components.container.widgetanimbank = "ui_chest_3x3"
	inst.components.container.widgetanimbuild = "ui_chest_3x3"
	inst.components.container.widgetpos = Vector3(0, 200, 0)
	inst.components.container.side_align_tip = 160
	inst.components.container.itemtestfn = function(inst, item, slot)
		return (item.components.perishable) or
			item.prefab == "spoiled_food" or
			item.prefab == "rottenegg" or
			item.prefab == "heatrock" or
			item:HasTag("frozen") or
			item:HasTag("icebox_valid")
	end

	--后注入覆盖


	--onhammered
	inst.components.workable:SetOnFinishCallback(function(inst, worker)
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
		inst:Remove()
	end)

	--onhit
	inst.components.workable:SetOnWorkCallback(function(inst, worker)
		inst.AnimState:PlayAnimation("idle")
	end)

	inst.OnSave = function(inst, data)
	end

	--onload
	inst.OnLoad = function(inst, data)
	end

	return inst
end

--饰品作坊
local function trinketworkshop(Sim)
	local inst = commonfn("trinketworkshop")
	MakeObstaclePhysics(inst, 1)

	local widgetbuttoninfo = {
		text = "制作",
		position = Vector3(0, -165, 0),
		fn = function(inst)
			local opener = inst.components.container.opener or GetPlayer()
			--这里可优化
			local res,currecipe = CanMakeAndResult(inst, TUNING.ARCUEID_TRINKETRECIPES)
			for i = 1, 9 do
				local curitem = inst.components.container:GetItemInSlot(i)
				if not curitem:HasTag("maketool") then
					if curitem.components.stackable and curitem.components.stackable.stacksize > 1 then
						curitem.components.stackable:SetStackSize(curitem.components.stackable.stacksize - 1)
					else
						curitem:Remove()
					end
				end
			end
			opener.components.inventory:GiveItem(SpawnPrefab(currecipe))
		end,
		validfn = function(inst)
			local res= CanMakeAndResult(inst, TUNING.ARCUEID_TRINKETRECIPES)
			return res
		end
	}

	--容器特性
	inst:AddComponent("container")
	inst.components.container:SetNumSlots(#slotpos_miraclecookpot)
	inst.components.container.widgetslotpos = slotpos_miraclecookpot
	inst.components.container.widgetanimbank = "ui_chest_3x3"
	inst.components.container.widgetanimbuild = "ui_chest_3x3"
	inst.components.container.widgetpos = Vector3(0, 200, 0)
	inst.components.container.side_align_tip = 100
	inst.components.container.widgetbuttoninfo = widgetbuttoninfo
	inst.components.container.acceptsstacks = false
	--inst.components.container.type = "cooker"
	inst.components.container.onopenfn = function(inst)
		GetPlayer():PushEvent("OpenCraftRecipesTrinket")
	end
	inst.components.container.onclosefn = function(inst)
		GetPlayer():PushEvent("CloseCraftRecipesTrinket")
	end

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

--炼金台
local function alchemydesk(Sim)
	local inst = commonfn("alchemydesk")
	MakeObstaclePhysics(inst, .8)

	local widgetbuttoninfo = {
		text = "制作",
		position = Vector3(0, -165, 0),
		fn = function(inst)
			local opener = inst.components.container.opener or GetPlayer()
			--这里可优化
			local res,currecipe = CanMakeAndResult(inst, TUNING.ARCUEID_ALCHEMYRECIPES)
			for i = 1, 9 do
				local curitem = inst.components.container:GetItemInSlot(i)
				if not curitem:HasTag("maketool") then
					if curitem.components.stackable and curitem.components.stackable.stacksize > 1 then
						curitem.components.stackable:SetStackSize(curitem.components.stackable.stacksize - 1)
					else
						curitem:Remove()
					end
				end
			end
			opener.components.inventory:GiveItem(SpawnPrefab(currecipe))
		end,
		validfn = function(inst)
			local res= CanMakeAndResult(inst, TUNING.ARCUEID_ALCHEMYRECIPES)
			return res
		end
	}

	--容器特性
	inst:AddComponent("container")
	inst.components.container:SetNumSlots(#slotpos_miraclecookpot)
	inst.components.container.widgetslotpos = slotpos_miraclecookpot
	inst.components.container.widgetanimbank = "ui_chest_3x3"
	inst.components.container.widgetanimbuild = "ui_chest_3x3"
	inst.components.container.widgetpos = Vector3(0, 200, 0)
	inst.components.container.side_align_tip = 100
	inst.components.container.widgetbuttoninfo = widgetbuttoninfo
	inst.components.container.acceptsstacks = true
	--inst.components.container.type = "cooker"
	inst.components.container.onopenfn = function(inst)
		GetPlayer():PushEvent("OpenCraftRecipesAlchemy")
	end
	inst.components.container.onclosefn = function(inst)
		GetPlayer():PushEvent("CloseCraftRecipesAlchemy")
	end

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
	CreateMoonCircleForm(TUNING.PROTOTYPER_TREES.MOONMAGIC_ONE),                      --第一具现原理
	Prefab("common/objects/building_gemicebox", gemicebox, assets, prefabs_gemicebox), --魔术宝石冰箱
	Prefab("common/objects/building_travellerbox", travellerbox, assets, prefabs),    --旅行者时空箱
	Prefab("common/objects/travellerbox_inv", travellerbox_inv, assets, prefabs),     --旅行者时空箱_物品
	Prefab("common/objects/building_immortallight", immortallight, assets, prefabs),  --永恒魔术灯
	Prefab("common/objects/building_gemgenerator", gemgenerator, assets, prefabs),    --宝石发生器
	Prefab("common/objects/building_spatialanchor", spatialanchor, assets, prefabs),  --空间锚定仪
	Prefab("common/objects/building_miraclecookpot", miraclecookpot, assets, prefabs), --奇迹煮锅
	Prefab("common/objects/building_guard", guard, assets, prefabs),                  --魔术炮塔
	Prefab("common/objects/building_infinitas", infinitas, assets, prefabs),          --Infinitas箱
	Prefab("common/objects/building_recycleform", recycleform, assets, prefabs),      --第二分解术式
	Prefab("common/objects/building_rottenform", rottenform, assets, prefabs),        --腐败滋生术式
	Prefab("common/objects/building_trinketworkshop", trinketworkshop, assets, prefabs), --饰品作坊
	Prefab("common/objects/building_alchemydesk", alchemydesk, assets, prefabs),      --炼金台
	MakePlacer("common/building_mooncirleform_placer", "building_mooncirleform", "building_mooncirleform", "idle"),
	MakePlacer("common/building_gemicebox_placer", "building_gemicebox", "building_gemicebox", "closed"),
	MakePlacer("common/building_travellerbox_placer", "building_travellerbox", "building_travellerbox", "closed"),
	MakePlacer("common/building_immortallight_placer", "building_immortallight", "building_immortallight", "idle"),
	MakePlacer("common/building_gemgenerator_placer", "building_gemgenerator", "building_gemgenerator", "idle"),
	MakePlacer("common/building_spatialanchor_placer", "building_spatialanchor", "building_spatialanchor", "idle1"),
	MakePlacer("common/building_miraclecookpot_placer", "building_miraclecookpot", "building_miraclecookpot", "cook_pot"),
	MakePlacer("common/building_guard_placer", "building_guard", "building_guard", "idle_on_loop"),
	MakePlacer("common/building_infinitas_placer", "building_infinitas", "building_infinitas", "closed"),
	MakePlacer("common/building_rottenform_placer", "building_rottenform", "building_rottenform", "idle"),
	MakePlacer("common/building_recycleform_placer", "building_recycleform", "building_recycleform", "idle"),
	MakePlacer("common/building_trinketworkshop_placer", "building_trinketworkshop", "building_trinketworkshop", "idle"),
	MakePlacer("common/building_alchemydesk_placer", "building_alchemydesk", "building_alchemydesk", "idle")
