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

