local require = GLOBAL.require
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local STRINGS = GLOBAL.STRINGS
local ACTIONS = GLOBAL.ACTIONS
local TECH = GLOBAL.TECH
local SpawnPrefab = GLOBAL.SpawnPrefab
local TUNING = GLOBAL.TUNING
EQUIPSLOTS = GLOBAL.EQUIPSLOTS

PrefabFiles = {
	"arcueid",
	"sharpclaw",
	"arcueid_food",
	"arcueid_dress",
	"arcueid_building",
	"arcueid_trinket",
	"arcueid_baseitem",
	"arcueid_efficacy",
	"arcueid_shadowcreature",
	"arcueid_letter",
	"arcueid_acidraindrop",
	"arcueid_potion",
	"psionic_farm",
	"psionic_item",
	"arcueid_consume",
}

Assets = {
	-- 常规人物资源
	Asset("IMAGE", "images/saveslot_portraits/arcueid.tex"),
	Asset("ATLAS", "images/saveslot_portraits/arcueid.xml"),
	Asset("IMAGE", "images/selectscreen_portraits/arcueid.tex"),
	Asset("ATLAS", "images/selectscreen_portraits/arcueid.xml"),
	Asset("IMAGE", "images/selectscreen_portraits/arcueid_silho.tex"),
	Asset("ATLAS", "images/selectscreen_portraits/arcueid_silho.xml"),
	Asset("IMAGE", "bigportraits/arcueid.tex"),
	Asset("ATLAS", "bigportraits/arcueid.xml"),
	Asset("IMAGE", "images/map_icons/arcueid.tex"),
	Asset("ATLAS", "images/map_icons/arcueid.xml"),

	--小地图
	Asset("ATLAS", "images/map_icons/mapicon.xml"),
	Asset("IMAGE", "images/map_icons/mapicon.tex"),
	Asset("ATLAS", "images/map_icons/mooncirleform.xml"),
	Asset("IMAGE", "images/map_icons/mooncirleform.tex"),
	Asset("ATLAS", "images/map_icons/gemicebox.xml"),
	Asset("IMAGE", "images/map_icons/gemicebox.tex"),
	Asset("ATLAS", "images/map_icons/travellerbox.xml"),
	Asset("IMAGE", "images/map_icons/travellerbox.tex"),
	Asset("ATLAS", "images/map_icons/immortallight.xml"),
	Asset("IMAGE", "images/map_icons/immortallight.tex"),
	Asset("ATLAS", "images/map_icons/gemgenerator.xml"),
	Asset("IMAGE", "images/map_icons/gemgenerator.tex"),
	Asset("ATLAS", "images/map_icons/spatialanchor.xml"),
	Asset("IMAGE", "images/map_icons/spatialanchor.tex"),
	Asset("ATLAS", "images/map_icons/miraclecookpot.xml"),
	Asset("IMAGE", "images/map_icons/miraclecookpot.tex"),
	Asset("ATLAS", "images/map_icons/guard.xml"),
	Asset("IMAGE", "images/map_icons/guard.tex"),
	Asset("ATLAS", "images/map_icons/recycleform.xml"),
	Asset("IMAGE", "images/map_icons/recycleform.tex"),
	Asset("ATLAS", "images/map_icons/rottenform.xml"),
	Asset("IMAGE", "images/map_icons/rottenform.tex"),
	Asset("ATLAS", "images/map_icons/alchemydesk.xml"),
	Asset("IMAGE", "images/map_icons/alchemydesk.tex"),
	Asset("ATLAS", "images/map_icons/trinketworkshop.xml"),
	Asset("IMAGE", "images/map_icons/trinketworkshop.tex"),
	Asset("ATLAS", "images/map_icons/building_psionic_farm.xml"),
	Asset("IMAGE", "images/map_icons/building_psionic_farm.tex"),

	--ui
	Asset("ANIM", "anim/vigour.zip"),
	Asset("ATLAS", "images/arcueid_gui/turnarrow_icon.xml"),
	Asset("IMAGE", "images/arcueid_gui/turnarrow_icon.tex"),
	Asset("ATLAS", "images/arcueid_gui/letter_paper.xml"),
	Asset("IMAGE", "images/arcueid_gui/letter_paper.tex"),
	Asset("ATLAS", "images/arcueid_gui/arcueid_close.xml"),
	Asset("IMAGE", "images/arcueid_gui/arcueid_close.tex"),
	Asset("ATLAS", "images/arcueid_gui/erosionbar.xml"),
	Asset("IMAGE", "images/arcueid_gui/erosionbar.tex"),
	Asset("ATLAS", "images/arcueid_gui/num_bg.xml"),
	Asset("IMAGE", "images/arcueid_gui/num_bg.tex"),
	Asset("IMAGE", "images/arcueid_gui/transframe_1.tex"),
	Asset("ATLAS", "images/arcueid_gui/transframe_1.xml"),
	Asset("IMAGE", "images/arcueid_gui/arcueid_ui.tex"),
	Asset("ATLAS", "images/arcueid_gui/arcueid_ui.xml"),
	Asset("IMAGE", "images/trinketslot.tex"),
	Asset("ATLAS", "images/trinketslot.xml"),
	Asset("IMAGE", "images/clear.tex"),
	Asset("ATLAS", "images/clear.xml"),
	Asset("IMAGE", "images/bufficon.tex"),
	Asset("ATLAS", "images/bufficon.xml"),

	--test
	Asset("IMAGE", "images/bloodscreen.tex"),
	Asset("ATLAS", "images/bloodscreen.xml"),

}
GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })


--常量
--写成表的形式会有调用上的bug，不知道为什么
TUNING.ARCUEID_MAXVIGOUR = 360
TUNING.ARCUEID_MAXEROSION = 360

TUNING.ARCUEID_VIGOUR_HUGE = 240
TUNING.ARCUEID_VIGOUR_MIDDLE = 120
TUNING.ARCUEID_VIGOUR_SMALL = 60

TUNING.ARCUEID_DAY_DAMAGEMULTIPLIER = -0.1
TUNING.ARCUEID_DUSK_DAMAGEMULTIPLIER = 0.5
TUNING.ARCUEID_NIGHT_DAMAGEMULTIPLIER = 1
TUNING.ARCUEID_FULLMOON_DAMAGEMULTIPLIER = 2.5

TUNING.ARCUEID_DAY_WALKSPEED = 4
TUNING.ARCUEID_DAY_RUNSPEED = 6
TUNING.ARCUEID_DUSK_WALKSPEED = 5
TUNING.ARCUEID_DUSK_RUNSPEED = 7
TUNING.ARCUEID_NIGHT_WALKSPEED = 6
TUNING.ARCUEID_NIGHT_RUNSPEED = 8
TUNING.ARCUEID_FULLMOON_WALKSPEED = 8
TUNING.ARCUEID_FULLMOON_RUNSPEED = 10
TUNING.ARCUEID_SNEAKYMULTIPLIER = 0.45

TUNING.ARCUEID_NEW_MOONFACTOR = -0.061
TUNING.ARCUEID_QUARTER_MOONFACTOR = 0.031
TUNING.ARCUEID_HALF_MOONFACTOR = 0.122
TUNING.ARCUEID_THREEQUARTER_MOONFACTOR = 0.183
TUNING.ARCUEID_FULL_MOONFACTOR = 1.5

TUNING.GEMGENERATOR_FUEL_MAX = 90
--赴死者勋激发的无敌时间(.03边界修正)
TUNING.MARTYRSEAL_HUGHLIGHT_TIME = 3.0333
TUNING.ICESKILL_COOLDOWN = 10.5

TUNING.ARCUEID_FOOD_VALUE_E = { 7, 7, 7, 14 }
TUNING.ARCUEID_FOOD_VALUE_D = { 18, 18, 18, 36 }
TUNING.ARCUEID_FOOD_VALUE_C = { 22, 22, 22, 46 }
TUNING.ARCUEID_FOOD_VALUE_B = { 27, 27, 27, 57 }
TUNING.ARCUEID_FOOD_VALUE_A = { 40, 40, 40, 90 }

--花环类比.023
TUNING.ARCUEID_VIGOURBUFF_E = .034
--高礼帽类比.05
TUNING.ARCUEID_VIGOURBUFF_D = .068
--贝雷帽类比.11
TUNING.ARCUEID_VIGOURBUFF_C = .14
--影刀类比.33
TUNING.ARCUEID_VIGOURBUFF_B = .45
TUNING.ARCUEID_VIGOURBUFF_A = 1

--花环类比.023
TUNING.ARCUEID_VIGOURBUFF_E = .034
--高礼帽类比.05
TUNING.ARCUEID_VIGOURBUFF_D = .068
--贝雷帽类比.11
TUNING.ARCUEID_VIGOURBUFF_C = .14
--影刀类比.33

-- buff面板用 (每秒)
TUNING.ARCUEID_BUFFTINY = .05
TUNING.ARCUEID_BUFFSMALL = .1
TUNING.ARCUEID_BUFFMIDDLE = .25
TUNING.ARCUEID_BUFFLARGE = .4

--概率控制
TUNING.ARCUEID_PROBABILITY =
{
	--巨鹿掉落>月光斗篷
	DROP_MOONCLOAK = .5,
	--远古犀牛掉落>阴影斗篷
	DROP_SHADOWCLOAK = .5,
	--远古先知>月亮护腕
	DROP_MOONWRISTBAND = .2,
	--翘鼻蛇掉落>月亮吊坠
	DROP_MOONAMULET = .3,
	--虎鲨掉落>月亮指环
	DROP_MOONRING = .5,
	--龙蝇掉落>冰晶·立冬
	DROP_ICECRYSTAL = .4,
	--影怪>水晶
	DROP_COMMON_NIGHTMARE_MOONGLASS = .4,
	--巨砾>月岩
	DROP_MOONROCK = .4,
	--基础影怪致残
	COMMON_NIGHTMARE_DISABILITY = .6,

}

--科技树
TUNING.PROTOTYPER_TREES.MOONMAGIC_ONE =
{
	SCIENCE = 0,
	MAGIC = 0,
	ANCIENT = 0,
	OBSIDIAN = 0,
	WATER = 0,
	HOME = 0,
	CITY = 0,
	LOST = 0,
	MOONMAGIC = 1,
}
--配方科技等级
TECH.MOONMAGIC_ONE = { MOONMAGIC = 1 }
--饰品栏标识
EQUIPSLOTS.TRINKET = "trinket"
--营火火焰半径削减
TUNING.FIRERADIUSRATE = 0.42
--火把火焰半径削减
TUNING.TORCHRADIUSRATE = .65
--暗影骑士数值
TUNING.SHADOW_KNIGHT =
{
	LEVELUP_SCALE = { 1, 1.7, 2.5 },
	SPEED = { 7, 9, 12 },
	HEALTH = { 900, 2700, 8100 },
	DAMAGE = { 40, 90, 150 },
	ATTACK_PERIOD = { 3, 2.5, 2 },
	ATTACK_RANGE = 2.3,   -- levels are procedural
	ATTACK_RANGE_LONG = 4.5, -- levels are procedural
	RETARGET_DIST = 15,
}

--暗影生物
TUNING.SHADOWCREATURE = {
	['crawlinghorror'] = true, -- 大肥只
	['crawlingnightmare'] = true, -- 大肥只遗迹
	['terrorbeak'] = true, -- 大瘦只
	['nightmarebeak'] = true, -- 大瘦只遗迹
	['swimminghorror'] = true, --海上游的
}

TUNING.SHADOW_CHESSPIECE_EPICSCARE_RANGE = 10
TUNING.SHADOW_CHESSPIECE_DESPAWN_TIME = 30

--特征修改
TUNING.SANITY_DAY_GAIN = -0.04166
TUNING.SANITY_NIGHT_LIGHT = 0.0233
TUNING.SANITY_NIGHT_MID = 0.0433
TUNING.SANITY_NIGHT_DARK = -1
TUNING.ARCUEID_HUNGER_RATE = 0.2 --0.15625->0.2

--人物信息
STRINGS.CHARACTER_TITLES.arcueid = "稀世明珠般的公主大人"
STRINGS.CHARACTER_NAMES.arcueid = "Arcueid Brunestud"
--*偶尔自言自语 *容易失控 *喜欢在黑漆漆的地方乱跑
STRINGS.CHARACTER_DESCRIPTIONS.arcueid = "*受到统治者的制裁\n*亲近月亮\n*是个笨蛋"
STRINGS.CHARACTER_QUOTES.arcueid = "\"称我为布伦史塔德就好！\""
STRINGS.CHARACTERS.ARCUEID = require "speech_arcueid"

--小地图插入map_icons
AddMinimapAtlas("images/map_icons/mapicon.xml")
AddMinimapAtlas("images/map_icons/mooncirleform.xml")
AddMinimapAtlas("images/map_icons/arcueid.xml")
AddMinimapAtlas("images/map_icons/rottenform.xml")
AddMinimapAtlas("images/map_icons/recycleform.xml")
AddMinimapAtlas("images/map_icons/guard.xml")
AddMinimapAtlas("images/map_icons/miraclecookpot.xml")
AddMinimapAtlas("images/map_icons/spatialanchor.xml")
AddMinimapAtlas("images/map_icons/gemgenerator.xml")
AddMinimapAtlas("images/map_icons/immortallight.xml")
AddMinimapAtlas("images/map_icons/travellerbox.xml")
AddMinimapAtlas("images/map_icons/gemicebox.xml")
AddMinimapAtlas("images/map_icons/trinketworkshop.xml")
AddMinimapAtlas("images/map_icons/alchemydesk.xml")

modimport("scripts/modmain/name_list.lua")
modimport("scripts/modmain/foodscript.lua")
modimport("scripts/modmain/talkchain.lua")
modimport("scripts/modmain/arcueid_lootdropper.lua")
modimport("scripts/modmain/ninetabRecipe.lua")
AddModCharacter("arcueid")
table.insert(GLOBAL.CHARACTER_GENDERS.FEMALE, "arcueid")

-- DLC检测
GLOBAL.IsROG = false
GLOBAL.IsSW = false
GLOBAL.IsHAM = false
if GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS) then
	GLOBAL.IsROG = true
end
if GLOBAL.IsDLCEnabled(GLOBAL.CAPY_DLC) then
	GLOBAL.IsSW = true
end
if GLOBAL.IsDLCEnabled(GLOBAL.PORKLAND_DLC) then
	GLOBAL.IsHAM = true
end

--调整护符位
local amulets = { "amulet", "blueamulet", "purpleamulet", "orangeamulet", "greenamulet", "yellowamulet", --standard
	"blackamulet", "pinkamulet", "whiteamulet", "endiaamulet", "grayamulet", "broken_frosthammer", }
if GetModConfigData("amuletstype") == 2 then
	for i, v in ipairs(amulets) do
		AddPrefabPostInit(v, function(inst)
			if inst.components.equippable then
				inst.components.equippable.equipslot = EQUIPSLOTS.TRINKET
			end
		end)
	end
end

local vigour = GLOBAL.require "widgets/vigourbadge"
local bloodscreen = GLOBAL.require "widgets/bloodscreen"
local blindscreen = GLOBAL.require "widgets/blindscreen"
local foodrecipes = GLOBAL.require "widgets/arcueid_craftrecipes_food"
local trinketrecipes = GLOBAL.require "widgets/arcueid_craftrecipes_trinket"
local alchemyrecipes = GLOBAL.require "widgets/arcueid_craftrecipes_alchemy"
local letter = GLOBAL.require "widgets/letter_normal"
local erosion = GLOBAL.require "widgets/erosionbadge"
local buffpanel = GLOBAL.require "widgets/buffpanel"
local gempanel = GLOBAL.require "widgets/arcueid_gemgeneratorpanel"

--活力值
AddClassPostConstruct("widgets/statusdisplays", function(self)
	if self.owner and GetPlayer().prefab == "arcueid" then
		self.vigour_hud = self:AddChild(vigour(self.owner))
		local x1, y1, z1 = self.stomach:GetPosition():Get()
		local x2, y2, z2 = self.brain:GetPosition():Get()
		local x3, y3, z3 = self.heart:GetPosition():Get()

		if KnownModIndex:IsModEnabled("workshop-574636989") then
			self.vigour_hud:SetPosition(self.stomach:GetPosition() + GLOBAL.Vector3(-30, y2 - y1 - 10, 0))
		else
			self.vigour_hud:SetPosition(self.brain:GetPosition() + GLOBAL.Vector3(x1 - x3, 0, 0))
		end
		self.owner.components.vigour:DoDelta(0, self.owner, "loadupdate")
		self.vigour_hud:Show()
	end
end)

--冰滤镜/盲滤镜
AddClassPostConstruct("widgets/controls", function(self, owner)
	self.bloodscreen = self:AddChild(bloodscreen(self.owner))
	self.Blindscreen = self:AddChild(blindscreen(self.owner))
	GetPlayer():ListenForEvent("sanitydelta", function()
		self.Blindscreen:OnUpdate()
	end, inst)

	self.bloodscreen:Show()
	self.Blindscreen:Show()
end)

--注入旅行箱组件
AddPrefabPostInit("world", function(inst)
	inst:AddComponent("travellerboxinventory")
end)

--食物配方
AddClassPostConstruct("widgets/controls", function(self)
	local controls = self
	if controls and GetPlayer().prefab == "arcueid" then
		if controls.containerroot then
			controls.foodrecipes = controls.containerroot:AddChild(foodrecipes())
		end
	else
		return
	end
	controls.foodrecipes:Hide()
end)

--饰品配方
AddClassPostConstruct("widgets/controls", function(self)
	local controls = self
	if controls and GetPlayer().prefab == "arcueid" then
		if controls.containerroot then
			controls.trinketrecipes = controls.containerroot:AddChild(trinketrecipes())
		end
	else
		return
	end
	controls.trinketrecipes:Hide()
end)

--炼金台配方
AddClassPostConstruct("widgets/controls", function(self)
	local controls = self
	if controls and GetPlayer().prefab == "arcueid" then
		if controls.containerroot then
			controls.alchemyrecipes = controls.containerroot:AddChild(alchemyrecipes())
		end
	else
		return
	end
	controls.alchemyrecipes:Hide()
end)

--饰品栏
AddClassPostConstruct("screens/playerhud", function(self)
	local oldfn = self.SetMainCharacter
	function self:SetMainCharacter(maincharacter, ...)
		oldfn(self, maincharacter, ...)
		--------------------------------inject
		if GetPlayer().prefab == "arcueid" then
			self.controls.inv:AddEquipSlot("trinket", "images/trinketslot.xml", "trinketslot.tex")
		end
		-------------------------------
	end
end)

--信
AddClassPostConstruct("widgets/controls", function(self)
	local controls = self
	if controls and GetPlayer().prefab == "arcueid" then
		if controls.containerroot then
			controls.letter = controls.containerroot:AddChild(letter())
		end
	else
		return
	end
	controls.letter:Hide()
end)

--侵蚀度
AddClassPostConstruct("widgets/controls", function(self)
	local controls = self
	if controls and GetPlayer().prefab == "arcueid" then
		if controls.containerroot then
			controls.erosion = controls.containerroot:AddChild(erosion())
		end
	else
		return
	end
end)

--buff面板
AddClassPostConstruct("widgets/controls", function(self)
	local controls = self
	if controls and GetPlayer().prefab == "arcueid" then
		if controls.containerroot then
			controls.buffpanel = controls.containerroot:AddChild(buffpanel(GetPlayer()))
		end
	else
		return
	end
end)

--gem面板
AddClassPostConstruct("widgets/controls", function(self)
	local controls = self
	if controls and GetPlayer().prefab == "arcueid" then
		if controls.containerroot then
			controls.gempanel = controls.containerroot:AddChild(gempanel())
		end
	else
		return
	end
end)


--注入条件让Mouse强制时刻监视到Arc
AddComponentPostInit("playeractionpicker", function(PlayerActionPicker)
	function PlayerActionPicker:DoGetMouseActions(force_target)
		--local highlightdude = nil
		local action = nil
		local second_action = nil

		--if true then return end
		local target = TheInput:GetHUDEntityUnderMouse()


		if not target then
			local ents = TheInput:GetAllEntitiesUnderMouse()

			--this should probably eventually turn into a system whereby we calculate actions for ALL of the possible items and then rank them. Until then, just apply a couple of special cases...
			local useitem = self.inst.components.inventory:GetActiveItem()

			--this is fugly
			local ignore_player = true
			if useitem then
				if (useitem.components.equippable and not useitem.components.equippable.isequipped)
					or useitem.components.edible
					or useitem.components.shaver
					or useitem.components.instrument
					or useitem.components.healer
					or useitem.components.sleepingbag
					or useitem.components.poisonhealer
					or (useitem.components.fertilizer and GetPlayer():HasTag("healonfertilize")) then
					ignore_player = false
				end
			end

			if self.inst.components.catcher and self.inst.components.catcher:CanCatch() then
				ignore_player = false
			end

			if self.inst:HasTag("Arcueid") then
				ignore_player = false
			end


			for k, v in pairs(ents) do
				if not ignore_player or not v:HasTag("player") or (v.components.rider and v.components.rider:IsRiding()) and v.Transform then
					target = v
					break
				end
			end
		end

		local target_in_light = target and target:IsValid() and target.Transform and
			TheSim:GetLightAtPoint(target.Transform:GetWorldPosition()) > TUNING.DARK_CUTOFF
		local position = TheInput:GetWorldPosition()

		if ((target and target:IsValid() and target.Transform) and (target:HasTag("player") or target_in_light)) or (not target and TheSim:GetLightAtPoint(position.x, position.y, position.z) > TUNING.DARK_CUTOFF) then
			do
				local acts = self:GetClickActions(target, position)
				if acts and #acts > 0 then
					action = acts[1]
				end
			end

			do
				local acts = self:GetRightClickActions(target, position, action)
				if acts[1] and (not action or acts[1].action ~= action.action) then
					second_action = acts[1]
				end
			end
		end

		return action, second_action
	end
end)

--自定义动作
local ACTIONS = GLOBAL.ACTIONS
local SHARPCLAW_EQUIP = GLOBAL.Action({})
local REMOVE_LI = GLOBAL.Action({})
local EQUIP_LI = GLOBAL.Action({})
local EDIT_ANCHOR = GLOBAL.Action({})
local DESTINATION = GLOBAL.Action({})
local TOUCH_BOTTLE = GLOBAL.Action({})
local READLETTER = GLOBAL.Action({ mount_enabled = true })
local FERTILIZE_PSIONIC = GLOBAL.Action({})
local PLANT_PSIONIC = GLOBAL.Action({})
local ARCUEID_NORMAL = GLOBAL.Action({})

--一般动作，仅用于绑定组件
ARCUEID_NORMAL.id = "ARCUEID_NORMAL"
ARCUEID_NORMAL.str = "使用"
--上爪动画
SHARPCLAW_EQUIP.id = "SHARPCLAW_EQUIP"
SHARPCLAW_EQUIP.str = "伸出"
--礼装
EQUIP_LI.id = "EQUIP_LI"
EQUIP_LI.str = "礼装"
--解除礼装
REMOVE_LI.id = "REMOVE_LI"
REMOVE_LI.str = "解除"
--编辑空间锚定名
EDIT_ANCHOR.id = "EDIT_ANCHOR"
EDIT_ANCHOR.str = "编入站点名"
--传送
DESTINATION.id = "DESTINATION"
DESTINATION.str = "选择锚点"
--接触
TOUCH_BOTTLE.id = "TOUCH_BOTTLE"
TOUCH_BOTTLE.str = "接触"
--读信
READLETTER.id = "READLETTER"
READLETTER.str = "阅读"
--栽种_seed
PLANT_PSIONIC.id = "PLANT_PSIONIC"
PLANT_PSIONIC.str = "布植"


-- 动作触发的函数。传入一个BufferedAction对象。(target,doer)
-- 可以通过它直接调用动作的执行者，目标，具体的动作内容等等，详情请查看bufferedaction.lua文件
SHARPCLAW_EQUIP.fn = function(act)
	local weapon = SpawnPrefab("sharpclaw")
	GetPlayer().components.inventory:Equip(weapon)
	--必须返回一个值，否者bufferaction监测到nil会push failevent
	return true
end

EQUIP_LI.fn = function(act)
	local dress
	local player = GetPlayer()
	if player.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET)
		and player.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_sacrificeknife" then
		local old = player.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET)
		old:DoTaskInTime(0, old.Remove)
		dress = SpawnPrefab("dress_redmoon")
	end

	if player.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET)
		and player.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_icecrystal" then
		dress = SpawnPrefab("dress_ice")
	end
	player.components.inventory:Equip(dress)
	return true
end

REMOVE_LI.fn = function(act)
	GetPlayer().components.inventory:Unequip(EQUIPSLOTS.BODY)
	return true
end

EDIT_ANCHOR.fn = function(act)
	local tar = act.target
	if tar and tar.components.signable then
		tar.components.signable:OnSign()
		return true
	end
end

DESTINATION.fn = function(act)
	local tar = act.target
	if tar and tar.components.travelable and not tar:HasTag("burnt") and not tar:HasTag("fire") then
		tar.components.travelable:SelectDestination(act.doer)
		return true
	end
end

TOUCH_BOTTLE.fn = function(act)
	local player = GetPlayer()
	if player.prefab == "arcueid" then
		player.components.arcueidbuff:ActiveArcueidBuff("buff_bottlelight")
		player.components.vigour:DoDelta(-7)
	end
	return true
end

PLANT_PSIONIC.fn = function(act)
	if act.doer.components.inventory then
		local seed = act.doer.components.inventory:RemoveItem(act.invobject)
		if seed then
			if act.target.components.grower_psionic and act.target.components.grower_psionic:PlantItem(seed) then
				if act.doer:HasTag("plantkin") then
					if act.doer.growplantfn then
						act.doer.growplantfn(act.doer)
					end
				end
				return true
			elseif act.target.components.breeder and act.target.components.breeder:Seed(seed) then
				return true
			else
				act.doer.components.inventory:GiveItem(seed)
			end
		end
	end
end

READLETTER.fn = function(act)
	local targ = act.target or act.invobject
	if targ and targ.components.book and act.doer and act.doer.components.reader then
		return act.doer.components.reader:Read(targ)
	end
	return true
end

--normalactionfn的唯一一个参数是传入被使用物
ARCUEID_NORMAL.fn = function(act)
	local targ = act.target or act.invobject
	if targ and targ.normalactionfn then
		targ.normalactionfn(targ)
	end
	return true
end

AddAction(SHARPCLAW_EQUIP)
AddAction(EQUIP_LI)
AddAction(REMOVE_LI)
AddAction(DESTINATION)
AddAction(EDIT_ANCHOR)
AddAction(TOUCH_BOTTLE)
AddAction(READLETTER)
AddAction(PLANT_PSIONIC)
AddAction(ARCUEID_NORMAL)

--[[通过在组件中定义类的函数来搜集组件动作。
CollectSceneActions，CollectUseActions，CollectPointActions，CollectEquippedActions，CollectInventoryActions这五个函数，
分别对应搜集Scene,Useitem,Point,Equipped和Inventory这五种类型的组件动作。 --]]

--[[你只需要一个动作，一个组件，一个组件动作收集函数，
一个状态图的动作处理器就可以搭建起一个简单的动作触发器，实现通过外部输入来触发函数的目的。--]]

AddStategraphActionHandler("wilson", ActionHandler(SHARPCLAW_EQUIP, "quicktele"))
AddStategraphActionHandler("wilson", ActionHandler(EQUIP_LI, "normalaction"))
AddStategraphActionHandler("wilson", ActionHandler(REMOVE_LI, "normalaction"))
AddStategraphActionHandler("wilson", ActionHandler(DESTINATION, "give"))
AddStategraphActionHandler("wilson", ActionHandler(EDIT_ANCHOR, "normalaction"))
AddStategraphActionHandler("wilson", ActionHandler(TOUCH_BOTTLE, "normalaction"))
AddStategraphActionHandler("wilson", ActionHandler(READLETTER, "readletter"))
AddStategraphActionHandler("wilson", ActionHandler(PLANT_PSIONIC, "give"))
AddStategraphActionHandler("wilson", ActionHandler(ARCUEID_NORMAL, "normalaction"))
-----------自定义动作

--监听键盘事件,shift切换潜行
GLOBAL.TheInput:AddKeyHandler(function(key, down)
	if GetPlayer() then
		local player = GetPlayer()
		if down and key == 304 and player.prefab == "arcueid" and player.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET) ~= nil
			and player.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_shadowcloak" then
			if player.components.arcueidstate.careful == true then
				player.components.arcueidstate.careful = false
			else
				player.components.arcueidstate.careful = true
			end
		end
	end
end)

--监听键盘事件,x释放冰冻技能/驱散暗影
GLOBAL.TheInput:AddKeyHandler(function(key, down)
	local player = GetPlayer()
	if down and key == 120 and player.prefab == "arcueid" then
		--冰冻
		if player.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil
			and player.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab == "dress_ice" then
			if player.components.arcueidstate.iceskill_cooldown <= 0 then
				player.sg:GoToState("iceskill")
			end
		end
		--第一圣典
		if player.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET) ~= nil
			and player.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_firstcanon"
			and player.components.vigour.currentvigour > 100
		then
			local x, y, z = player:GetPosition():Get()
			local ents = TheSim:FindEntities(x, y, z, 27, nil, { "arcueid" })
			for _, item in pairs(ents) do
				if item.prefab == "crawlinghorror"
					or item.prefab == "terrorbeak"
					or item.prefab == "swimminghorror"
					or item.prefab == "crawlingnightmare"
					or item.prefab == "nightmarebeak"
					or item.prefab == "ghost"
				then
					item.AnimState:PlayAnimation("disappear")
					if item.AnimState:GetCurrentAnimationLength() ~= nil then
						item:DoTaskInTime(item.AnimState:GetCurrentAnimationLength(), item.Remove)
					else
						item:Remove()
					end
					player.components.vigour:DoDelta(-30, nil, "firstcanon_skill")
				end
			end
		end
	end
end)

--修改火焰范围
AddComponentPostInit("firefx", function(FireFX)
	if GetPlayer().prefab == "arcueid" then
		local gettime = GetTime
		local clock = GetClock()
		local oldUpdateRadius = FireFX.UpdateRadius
		local oldSetLevel = FireFX.SetLevel
		function FireFX:OnUpdate(dt)
			local time = gettime() * 30
			local flicker = (math.sin(time) + math.sin(time + 2) + math.sin(time + 0.7777)) / 2.0 -- range = [-1 , 1]
			flicker = (1.0 + flicker) / 2.0                                              -- range = 0:1
			local rad = self.current_radius + flicker * .05
			rad = rad * TUNING.FIRERADIUSRATE
			self.inst.Light:SetRadius(rad)

			if self.usedayparamforsound then
				local isday = clock:IsDay()
				if isday ~= self.isday then
					self.isday = isday
					local val = isday and 1 or 2
					self.inst.SoundEmitter:SetParameter("fire", "daytime", val)
				end
			end
		end

		function FireFX:UpdateRadius()
			oldUpdateRadius(self)
			self.inst.Light:SetRadius(self.current_radius * TUNING.FIRERADIUSRATE)
		end

		function FireFX:SetLevel(lev, immediate)
			oldSetLevel(self, lev, immediate)
			if self.levels[self.level] and self.inst.Light then
				self.inst.Light:SetRadius(self.levels[self.level].radius * TUNING.FIRERADIUSRATE)
			end
		end
	end
end)

--修改火把范围
AddPrefabPostInit("torchfire", function(inst)
	inst.Light:SetRadius(2 * TUNING.TORCHRADIUSRATE)
end)

--添加睡眠Add活力值机制
--帐篷
AddPrefabPostInit("tent", function(inst)
	if inst and inst.components.sleepingbag then
		local oldonsleep = inst.components.sleepingbag.onsleep
		local newsleepfn = function(inst, sleeper)
			local res = oldonsleep(inst, sleeper)
			if sleeper and sleeper.prefab == "arcueid" then
				sleeper.components.vigour:DoDelta(TUNING.ARCUEID_VIGOUR_HUGE, sleeper, "sleeprecover")
			end
			return res
		end
		inst.components.sleepingbag.onsleep = newsleepfn
	end
end)

--毛毯
AddPrefabPostInit("bedroll_furry", function(inst)
	if inst and inst.components.sleepingbag then
		local oldonsleep = inst.components.sleepingbag.onsleep
		local newsleepfn = function(inst, sleeper)
			local res = oldonsleep(inst, sleeper)
			if sleeper and sleeper.prefab == "arcueid" then
				sleeper.components.vigour:DoDelta(TUNING.ARCUEID_VIGOUR_MIDDLE, sleeper, "sleeprecover")
			end
			return res
		end
		inst.components.sleepingbag.onsleep = newsleepfn
	end
end)

--草席
AddPrefabPostInit("bedroll_straw", function(inst)
	if inst and inst.components.sleepingbag then
		local oldonsleep = inst.components.sleepingbag.onsleep
		local newsleepfn = function(inst, sleeper)
			local res = oldonsleep(inst, sleeper)
			if sleeper and sleeper.prefab == "arcueid" then
				sleeper.components.vigour:DoDelta(TUNING.ARCUEID_VIGOUR_SMALL, sleeper, "sleeprecover")
			end
			return res
		end
		inst.components.sleepingbag.onsleep = newsleepfn
	end
end)

--木棚
AddPrefabPostInit("siestahut", function(inst)
	if inst and inst.components.sleepingbag then
		local oldonsleep = inst.components.sleepingbag.onsleep
		local newsleepfn = function(inst, sleeper)
			local res = oldonsleep(inst, sleeper)
			if sleeper and sleeper.prefab == "arcueid" then
				sleeper.components.vigour:DoDelta(TUNING.ARCUEID_VIGOUR_HUGE, sleeper, "sleeprecover")
			end
			return res
		end
		inst.components.sleepingbag.onsleep = newsleepfn
	end
end)

-- 侵蚀度影响月相
AddComponentPostInit("clock", function(Clock)
	local rmoonphases = {}
	rmoonphases["new"] = 1
	rmoonphases["quarter"] = 2
	rmoonphases["half"] = 3
	rmoonphases["threequarter"] = 4
	rmoonphases["full"] = 5
	local moonphases = { "new", "quarter", "half", "threequarter", "full", }
	local oldmoon = Clock.GetMoonPhase
	function Clock:GetMoonPhase()
		local oldmoonres = oldmoon(self)
		if GetPlayer() and GetPlayer().prefab == "arcueid" then
			local erosion = GetPlayer().components.arcueidstate.nightmarerosion
			local index = rmoonphases[oldmoonres]
			if erosion >= 180 and erosion < 240 then
				index = (index % 3) + 1
				return moonphases[index]
			elseif erosion >= 240 and erosion < 360 then
				index = (index % 2) + 1
				return moonphases[index]
			elseif erosion == 360 then
				return "new"
			end
		end
		return oldmoonres
	end
end)

-- 修改种植模块
AddComponentPostInit("crop", function(Crop)
	function Crop:Harvest(harvester)
		print('Yes,Harvest')
		if self.matured or self.withered then
			local product = nil
			if self.grower and self.grower:HasTag("fire") or self.inst:HasTag("fire") then
				local temp = SpawnPrefab(self.product_prefab)
				if temp.components.cookable and temp.components.cookable.product then
					product = SpawnPrefab(temp.components.cookable.product)
				else
					product = SpawnPrefab("seeds_cooked")
				end
				temp:Remove()
			else
				product = SpawnPrefab(self.product_prefab)
			end

			if product then
				self.inst:ApplyInheritedMoisture(product)
			end
			harvester.components.inventory:GiveItem(product, nil,
				Vector3(TheSim:GetScreenPos(self.inst.Transform:GetWorldPosition())))
			ProfileStatsAdd("grown_" .. product.prefab)

			self.matured = false
			self.withered = false
			self.inst:RemoveTag("withered")
			self.growthpercent = 0
			self.product_prefab = nil

			--改动了
			if self.grower and self.grower.components.grower then
				self.grower.components.grower:RemoveCrop(self.inst)
				self.grower = nil
			elseif self.grower and self.grower.components.grower_psionic then
				self.grower.components.grower_psionic:RemoveCrop(self.inst)
				self.grower = nil
			else
				self.inst:Remove()
			end


			return true
		end
	end

	function Crop:ForceHarvest(harvester)
		print('Yes,FHarvest')
		if self.matured or self.withered then
			local product = nil
			if self.grower and self.grower:HasTag("fire") or self.inst:HasTag("fire") then
				local temp = SpawnPrefab(self.product_prefab)
				if temp.components.cookable and temp.components.cookable.product then
					product = SpawnPrefab(temp.components.cookable.product)
				else
					product = SpawnPrefab("seeds_cooked")
				end
				temp:Remove()
			else
				product = SpawnPrefab(self.product_prefab)
			end

			if product then
				self.inst:ApplyInheritedMoisture(product)
			end

			local tookProduct = false
			if harvester and harvester.components.inventory then
				harvester.components.inventory:GiveItem(product)
				tookProduct = true
			else
				if self.grower and self.grower:IsValid() then
					product.Transform:SetPosition(self.grower.Transform:GetWorldPosition())
					if product.components.inventoryitem then
						product.components.inventoryitem:OnDropped(true)
					end
					tookProduct = true
				end
			end
			if not tookProduct then
				-- nothing to do with our product. What a waste
				product:Remove()
			end

			self.matured = false
			self.withered = false
			self.inst:RemoveTag("withered")
			self.growthpercent = 0
			self.product_prefab = nil

			--改动了
			if self.grower then
				if self.grower.components.grower then
					self.grower.components.grower:RemoveCrop(self.inst)
				elseif self.grower.components.grower_psionic then
					self.grower.components.grower_psionic:RemoveCrop(self.inst)
				else
					self.inst:Remove()
				end
				self.grower = nil
			else
				self.inst:Remove()
			end

			return true
		else
			-- nothing to give up, but pretend we did
			--改动了
			if self.grower then
				if self.grower.components.grower then
					self.grower.components.grower:RemoveCrop(self.inst)
				elseif self.grower.components.grower_psionic then
					self.grower.components.grower_psionic:RemoveCrop(self.inst)
				else
					self.inst:Remove()
				end
				self.grower = nil
			else
				self.inst:Remove()
			end
		end
	end
end)

local clumdmage = 0
-- 注入饰品和一些需要计算伤害的机制
AddComponentPostInit("combat", function(Combat)
	local old_caldamage = Combat.CalcDamage
	function Combat:CalcDamage(target, weapon, multiplier)
		--olddamage 伤害没有护甲补正
		local olddamage = old_caldamage(self, target, weapon, multiplier)

		local targ = target
		local damage = olddamage

		--减枝优化
		if self.inst.prefab == "arcueid"
			or targ.prefab == "arcueid" then
			--临时，影怪+侵蚀度
			if self.inst.prefab == "arcueid"
				and TUNING.SHADOWCREATURE[targ.prefab]
			then
				if targ.components.health.currenthealth < damage then
					self.inst.components.arcueidstate:DoDeltaForErosion_TEMP(1.5)
				end
			end

			--先知之眼->.35概率暴击
			if self.inst.prefab == "arcueid"
				and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET)
				and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_propheteye"
				and math.random() < .35
			then
				damage = damage * 2
			end

			--翡翠之刃
			if self.inst.prefab == "arcueid"
				and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET)
				and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_jadeblade"
			then
				damage = damage * 1.15
			end

			--第一圣典
			if self.inst.prefab == "arcueid"
				and GetPlayer().components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET)
				and GetPlayer().components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_firstcanon"
				and (TUNING.SHADOWCREATURE[targ.prefab] or targ.prefab == "ghost")
			then
				damage = damage * 1.5
			end

			--身缠冰河的数值
			if targ.prefab == "arcueid"
				and targ.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil
				and targ.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab == "dress_ice"
				and targ.components.vigour.currentvigour > 10 
			then
				targ.components.vigour:DoDelta(-damage * .05, nil, "ice_defense")
				damage = damage * .08
			end

			--赴死者勋
			if targ.prefab == "arcueid"
				and targ.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET) ~= nil
				and targ.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_martyrseal"
				and targ.components.health.currenthealth < damage then
				if targ.components.arcueidstate.martyrseal_cooldown <= 0 then
					targ.components.arcueidstate.martyrseal_highlight = TUNING.MARTYRSEAL_HUGHLIGHT_TIME
					targ.components.vigour:DoDelta(-damage)
					damage = 0
					targ.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET):PushEvent("activeforcefield")
				elseif targ.components.arcueidstate.martyrseal_highlight > 0 then
					damage = 0
				end
			end
		end
		return damage
	end
end)

--战斗机制改动
AddComponentPostInit("combat", function(Combat)
	local oldDoAttack = Combat.DoAttack
	function Combat:DoAttack(target_override, weapon, projectile, stimuli, instancemult)
		if self:CanHitTarget(targ, weapon) then
			if (self.inst.prefab == "crawlinghorror"
					or self.inst.prefab == "terrorbeak"
					or self.inst.prefab == "swimminghorror"
					or self.inst.prefab == "crawlingnightmare"
					or self.inst.prefab == "nightmarebeak")
				and targ.prefab == "arcueid" then
				--影怪.6致残
				if math.random() < .6 then
					targ.components.arcueidbuff:AddArcueidBuff("buff_disability")
				end

				--月亮吊坠抵消真伤	
				if targ.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET)
					and targ.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_moonamulet" then
					targ.components.health:DoDelta(-6, nil, "nightattack")
					targ.components.vigour:DoDelta(-12, nil, "nightattack")
				else
					--被影怪击中固定真实伤害18点
					targ.components.health:DoDelta(-18, nil, "nightattack")
				end
			end
		end

		local oldresatt = oldDoAttack(self, target_override, weapon, projectile, stimuli, instancemult)
		return oldresatt
	end
end)

--实现饱食度恢复活力值特性(1/10)
AddComponentPostInit("eater", function(Eater)
	local oldEat = Eater.Eat
	function Eater:Eat(food)
		local oldres = oldEat(self, food)
		if self.inst and self.inst.prefab == "arcueid" and oldres then
			local hvalue = food.components.edible:GetHunger(self.inst) * (self.hungerabsorption or 1)
			if hvalue > 0 then
				self.inst.components.vigour:DoDelta(hvalue / 10, self.inst, "foodadd")
			end
		end
		return oldres
	end
end)

--战斗机制改动
-- AddComponentPostInit("combat", function(Combat)
-- 	function Combat:DoAttack(target_override, weapon, projectile, stimuli, instancemult)
-- 		local targ = target_override or self.target
-- 		local weapon = weapon or self:GetWeapon()
-- 		if self:CanHitTarget(targ, weapon) then
-- 			--改动了：
-- 			if (self.inst.prefab == "crawlinghorror"
-- 					or self.inst.prefab == "terrorbeak"
-- 					or self.inst.prefab == "swimminghorror"
-- 					or self.inst.prefab == "crawlingnightmare"
-- 					or self.inst.prefab == "nightmarebeak")
-- 				and targ.prefab == "arcueid" then
-- 				--影怪.6致残
-- 				if math.random() < .6 then
-- 					targ.components.arcueidbuff:AddArcueidBuff("buff_disability")
-- 				end

-- 				--月亮吊坠抵消真伤	
-- 				if targ.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET)
-- 					and targ.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_moonamulet" then
-- 					targ.components.health:DoDelta(-6, nil, "nightattack")
-- 					targ.components.vigour:DoDelta(-12, nil, "nightattack")
-- 				else
-- 					--被影怪击中固定真实伤害18点
-- 					targ.components.health:DoDelta(-18, nil, "nightattack")
-- 				end
-- 			end
-- 			--
-- 			self.inst:PushEvent("onattackother",
-- 				{ target = targ, weapon = weapon, projectile = projectile, stimuli = stimuli })

-- 			if weapon and weapon.components.projectile and not projectile then
-- 				local projectile = self.inst.components.inventory:DropItem(weapon, false, nil, nil, true)
-- 				if projectile then
-- 					projectile.components.projectile:Throw(self.inst, targ)
-- 				end
-- 			elseif weapon and weapon.components.complexprojectile and not projectile then
-- 				local projectile = self.inst.components.inventory:DropItem(weapon, false, nil, nil, true)
-- 				if projectile then
-- 					local targetPos = targ:GetPosition()
-- 					projectile.components.complexprojectile:Launch(targetPos)
-- 				end
-- 			elseif weapon and weapon.components.weapon:CanRangedAttack() and not projectile then
-- 				weapon.components.weapon:LaunchProjectile(self.inst, targ)
-- 			else
-- 				local mult = 1
-- 				if stimuli == "electric" or (weapon and weapon.components.weapon and weapon.components.weapon.stimuli == "electric") then
-- 					if not targ:HasTag("electricdamageimmune") and (not targ.components.inventory or (targ.components.inventory and not targ.components.inventory:IsInsulated())) then
-- 						mult = TUNING.ELECTRIC_DAMAGE_MULT
-- 						if targ.components.moisture then
-- 							mult = mult +
-- 								(TUNING.ELECTRIC_WET_DAMAGE_MULT * targ.components.moisture:GetMoisturePercent())
-- 						elseif targ.components.moisturelistener and targ.components.moisturelistener:IsWet() then
-- 							mult = mult + TUNING.ELECTRIC_WET_DAMAGE_MULT
-- 						elseif GetWorld() and GetWorld().components.moisturemanager and GetWorld().components.moisturemanager:IsEntityWet(targ) then
-- 							mult = mult + TUNING.ELECTRIC_WET_DAMAGE_MULT
-- 						end
-- 					end
-- 				end
-- 				local damage = self:CalcDamage(targ, weapon, mult)

-- 				--临时，影怪+侵蚀度
-- 				if targ.prefab == "swimminghorror"
-- 					or targ.prefab == "terrorbeak"
-- 					or targ.prefab == "crawlinghorror"
-- 				then
-- 					if targ.components.health.currenthealth < damage then
-- 						GetPlayer().components.arcueidstate:DoDeltaForErosion_TEMP(1.5)
-- 					end
-- 				end

-- 				--先知之眼->.35概率暴击
-- 				if self.inst.prefab == "arcueid"
-- 					and GetPlayer().components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET)
-- 					and GetPlayer().components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_propheteye"
-- 					and math.random() < .35
-- 				then
-- 					damage = damage * 2
-- 				end

-- 				--翡翠之刃
-- 				if self.inst.prefab == "arcueid"
-- 					and GetPlayer().components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET)
-- 					and GetPlayer().components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_jadeblade"
-- 				then
-- 					damage = damage * 1.15
-- 				end

-- 				--第一圣典
-- 				if self.inst.prefab == "arcueid"
-- 					and GetPlayer().components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET)
-- 					and GetPlayer().components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_firstcanon"
-- 					and (targ.prefab == "crawlinghorror"
-- 						or targ.prefab == "terrorbeak"
-- 						or targ.prefab == "swimminghorror"
-- 						or targ.prefab == "crawlingnightmare"
-- 						or targ.prefab == "nightmarebeak"
-- 						or targ.prefab == "ghost") then
-- 					damage = damage * 1.5
-- 				end

-- 				--身缠冰河的数值
-- 				if targ.prefab == "arcueid"
-- 					and targ.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil
-- 					and targ.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab == "dress_ice"
-- 					and targ.components.vigour.currentvigour > 10 then
-- 					targ.components.vigour:DoDelta(-damage * .05, nil, "ice_defense")
-- 					damage = damage * .08
-- 				end

-- 				if instancemult then damage = damage * instancemult end

-- 				--赴死者勋
-- 				if targ.prefab == "arcueid"
-- 					and targ.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET) ~= nil
-- 					and targ.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_martyrseal"
-- 					and targ.components.health.currenthealth < damage then
-- 					if targ.components.arcueidstate.martyrseal_cooldown <= 0 then
-- 						targ.components.arcueidstate.martyrseal_highlight = TUNING.MARTYRSEAL_HUGHLIGHT_TIME
-- 						targ.components.vigour:DoDelta(-damage)
-- 						damage = 0
-- 						targ.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET):PushEvent("activeforcefield")
-- 					elseif targ.components.arcueidstate.martyrseal_highlight > 0 then
-- 						print(targ.components.arcueidstate.martyrseal_highlight)
-- 						damage = 0
-- 					end
-- 				end

-- 				if targ.components.combat then targ.components.combat:GetAttacked(self.inst, damage, weapon, stimuli) end

-- 				if METRICS_ENABLED and self.inst:HasTag("player") then
-- 					ProfileStatsAdd("hitson_" .. targ.prefab, math.floor(damage))
-- 					FightStat_Attack(targ, weapon, projectile, damage)

-- 					if self.inst.prefab == "crawlinghorror" then
-- 						target_override.components.health:DoDelta(-20, nil, "nightattack")
-- 					end
-- 				end
-- 				if METRICS_ENABLED and self.inst.components.follower
-- 					and self.inst.components.follower.leader == GetPlayer() then
-- 					FightStat_AttackByFollower(targ, weapon, projectile, damage)
-- 				end

-- 				if weapon then
-- 					weapon.components.weapon:OnAttack(self.inst, targ, projectile)
-- 				end
-- 				if self.areahitrange then
-- 					self:DoAreaAttack(targ, self.areahitrange, weapon, nil, stimuli)
-- 				end
-- 				self.lastdoattacktime = GetTime()
-- 			end
-- 		else
-- 			self.inst:PushEvent("onmissother", { target = targ, weapon = weapon })
-- 			if self.areahitrange then
-- 				local epicentre = projectile or self.inst
-- 				self:DoAreaAttack(epicentre, self.areahitrange, weapon, nil, stimuli)
-- 			end
-- 		end
-- 	end
-- end)
