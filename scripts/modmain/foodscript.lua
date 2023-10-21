---食物相关
AddIngredientValues({"nitre"}, { -- 硝石入锅
    inedible = 1 
})
AddIngredientValues({"ash"}, { -- 灰入锅
    inedible = 1
})
AddIngredientValues({"petals"}, { -- 花入锅
    inedible = 1
})
AddIngredientValues({"trinket_seasoningbottle"}, { -- 调料瓶入锅
    inedible = 1
})
AddIngredientValues({"arcueid_food_pepper"}, { -- 辣椒入锅
    inedible = 1
})
AddIngredientValues({"arcueid_food_tofusoup"}, { -- 豆腐汤入锅
    inedible = 1
})

---九格食谱:
TUNING.ARCUEID_FOODRECIPES = 
{
	--浆果蛋糕（浆果，羊奶，蛋，冰）-高
	["arcueid_food_berrycake"] = {nil,"berries",nil,	"goatmilk","trinket_seasoningbottle","bird_egg",	nil,"ice",nil},
	--蛋包饭（高脚鸟蛋，蛋，花，肉）-中
	["arcueid_food_omeletterice"] = {nil,"bird_egg",nil,	"petals","trinket_seasoningbottle","meat",	nil,"tallbirdegg",nil},
	--章鱼烧（鸟蛋，死水母，死水母,树枝)-中
	["arcueid_food_takoyaki"] = {nil,"bird_egg",nil,		"jellyfish_dead","trinket_seasoningbottle","jellyfish_dead",		nil,"twigs",nil},
	--豆腐汤（南瓜，蓝蘑菇，硝石，冰）-低
	["arcueid_food_tofusoup"] = {nil,"pumpkin",nil,		"blue_cap","trinket_seasoningbottle","nitre",		nil,"ice",nil},
	--虾仁炒饭(虾，帽贝，冰，小肉)-中
	["arcueid_food_shrimpfriedrice"] = {nil,"lobster_dead",nil,		"limpets","trinket_seasoningbottle","cookedsmallmeat",		nil,"ice",nil},
	--三明治(玉米，蛋，萝卜，肉干)-中高
	["arcueid_food_sandwich"] = {nil,"corn",nil,		"bird_egg","trinket_seasoningbottle","carrot",		nil,"meat_dried",nil},
	--泡芙(红薯,蛋,蛋,花瓣)-中低
	["arcueid_food_puff"] = {nil,"sweet_potato",nil,		"bird_egg","trinket_seasoningbottle","bird_egg",		nil,"petals",nil},
	--辣椒酱-配
	["arcueid_food_piri"] = {nil,nil,nil,		"arcueid_food_pepper","trinket_seasoningbottle","arcueid_food_pepper",		nil,nil,nil},
	-- --辣椒
	-- ["arcueid_food_pepper"] = {nil,nil,nil,nil,"trinket_seasoningbottle",nil,nil,nil,nil},
	--杂炖鲜汤(豆腐汤，肉，高鸟蛋，冰)-高
	["arcueid_food_mixedsoup"] = {nil,"arcueid_food_tofusoup",nil,		"meat","trinket_seasoningbottle","tallbirdegg",		nil,"ice",nil},
	--番茄酱-配
	--["arcueid_food_ketchup"] = {nil,nil,nil,nil,"trinket_seasoningbottle",nil,nil,nil,nil},
	--热狗 (小肉,浆果)（小）E
	["arcueid_food_hotdog"] = {nil,nil,nil,		"smallmeat","trinket_seasoningbottle","berries",		nil,nil,nil},
	--甜甜圈(西瓜，小肉，玉米，咖啡豆)中高
	["arcueid_food_doughnut"] = {nil,"watermelon",nil,		"smallmeat","trinket_seasoningbottle","coffeebeans",		nil,"corn",nil},
	--奶油蜂蜜切饼(蜂蜜，羊奶，蛋，玉米)高
	["arcueid_food_creamhoneycut"] = {nil,"honey",nil,		"goatmilk","trinket_seasoningbottle","bird_egg",		nil,"corn",nil},
	--巧克力曲奇（咖啡豆,蜂蜜,蜂蜜,烤仙人掌）中高
	["arcueid_food_chocolatecookies"] = {nil,"coffeebeans",nil,		"honey","trinket_seasoningbottle","honey",		nil,"cactus_meat_cooked",nil},
	--浆果蛋挞（浆果，蜂蜜，蛋，蛋）中
	["arcueid_food_berryeggtart"] = {nil,"berries",nil,		"bird_egg","trinket_seasoningbottle","bird_egg",		nil,"honey",nil},
}


--烧烤食物可能失败,.3产生一个烤糊的食物
ACTIONS.COOK.fn = function(act)
	if act.target.components.cooker then
		local ingredient = act.doer.components.inventory:RemoveItem(act.invobject)

		if ingredient.components.health and ingredient.components.combat then
			act.doer:PushEvent("killed", { victim = ingredient })
		end

		local product = act.target.components.cooker:CookItem(ingredient, act.doer)
		if product then
			if math.random() < .3 and GetPlayer().prefab == "arcueid" then
				local oldfood = product
				product = SpawnPrefab("wetgoop")
				if GetPlayer().components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET) ~= nil
					and GetPlayer().components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_seasoningbottle" then
					product = oldfood
				end
			end

			act.doer.components.inventory:GiveItem(product, nil,
				Vector3(TheSim:GetScreenPos(act.target.Transform:GetWorldPosition())))
			return true
		end
	elseif act.target.components.melter then
		act.target.components.melter:StartCooking()
		return true
	elseif act.target.components.stewer then
		act.target.components.stewer:StartCooking()
		return true
	end
end



--重构了命名方法完成食物附魔显示，堆叠问题暂时解决不了，废弃
-- function EntityScript:GetDisplayName()
--     --local name = self.name
--     if GetPlayer().components.vision and not GetPlayer().components.vision.focused and not GetPlayer().components.vision:testsight(self) then
--         if not self.nearsightedname then
-- 			nearsightednames = nearsightednames or reduce(STRINGS.NAMES, testvisionfn)
--             self.nearsightedname = GetRandomItem(nearsightednames)
--         end
--         return self.nearsightedname
--     end

-- 	local name = (self.displaynamefn ~= nil and self:displaynamefn()) or (self.nameoverride and STRINGS.NAMES[string.upper(self.nameoverride)]) or self.name

-- 	--功能代码------
-- 	if self:HasTag("特性的") then
-- 		if self:HasTag("美味的") then
-- 			name = ConstructAdjectivedName(self, name, "美味的")
-- 		end
-- 		if self:HasTag("恶臭的") then
-- 			name = ConstructAdjectivedName(self, name, "恶臭的")
-- 		end
-- 		if self:HasTag("美味的") then
-- 			name = ConstructAdjectivedName(self, name, "美味的")
-- 		end
-- 		if self:HasTag("烤糊的") then
-- 			name = ConstructAdjectivedName(self, name, "烤糊的")
-- 		end

-- 	end
-- 	---------------

--     local wet =  self:GetIsWet()
--     local flooded = self.components.floodable and self.components.floodable.flooded
--     if flooded then
--         return ConstructAdjectivedName(self, name, STRINGS.FLOODEDITEM)
--     end
--     local withered = self.components.pickable and self.components.pickable:IsWithered()
--     if not withered then
--         withered = self.components.crop and self.components.crop:IsWithered()
--     end
--     local smoldering = self.components.burnable and self.components.burnable:IsSmoldering()
--     if smoldering then
--         return ConstructAdjectivedName(self, name, STRINGS.SMOLDERINGITEM)
--     elseif withered then
--         return ConstructAdjectivedName(self, name, STRINGS.WITHEREDITEM)
--     elseif (wet or self.always_wet) and not self.no_wet_prefix then
--         if self.wet_prefix then
--             return ConstructAdjectivedName(self, name, self.wet_prefix)
--         elseif self.components.edible and GetPlayer() and GetPlayer().components.eater and GetPlayer().components.eater:CanEat(self) then
--             return ConstructAdjectivedName(self, name, STRINGS.WET_PREFIX.FOOD)
--         elseif self.components.equippable and (self.components.equippable.equipslot == EQUIPSLOTS.HEAD or self.components.equippable.equipslot == EQUIPSLOTS.BODY) then
--             return ConstructAdjectivedName(self, name, STRINGS.WET_PREFIX.CLOTHING)
--         elseif self.components.equippable and self.components.equippable.equipslot == EQUIPSLOTS.HANDS then
--             return ConstructAdjectivedName(self, name, STRINGS.WET_PREFIX.TOOL)
--         elseif self.components.fuel then
--             return ConstructAdjectivedName(self, name, STRINGS.WET_PREFIX.FUEL)
--         else
--             return ConstructAdjectivedName(self, name, STRINGS.WET_PREFIX.GENERIC)
--         end
--     elseif self.components.mystery and self:HasTag("mystery") then
--         return ConstructAdjectivedName(self, name, STRINGS.MYSTERIOUS)
--     else
--         return name
--     end
-- end

-- honeyham =
-- 	{
-- 		test = function(cooker, names, tags)  return names.honey and tags.meat and tags.meat > 1.5 and not tags.inedible end,
-- 		priority = 2,
-- 		foodtype = "MEAT",
-- 		health = TUNING.HEALING_MEDLARGE,
-- 		hunger = TUNING.CALORIES_HUGE,
-- 		perishtime = TUNING.PERISH_SLOW,
-- 		sanity = TUNING.SANITY_TINY,
-- 		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
-- 		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
-- 		cooktime = 2,
-- 		tags = {"honeyed"}
-- 	}

