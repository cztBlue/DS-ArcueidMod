--影怪1掉落>月亮水晶
AddPrefabPostInit("nightmarebeak", function(inst)
	inst.components.lootdropper.numrandomloot = 1
	inst.components.lootdropper:AddRandomLoot("base_moonglass",
		TUNING.ARCUEID_PROBABILITY.DROP_COMMON_NIGHTMARE_MOONGLASS)
end)
--影怪2掉落>月亮水晶
AddPrefabPostInit("crawlingnightmare", function(inst)
	inst.components.lootdropper.numrandomloot = 1
	inst.components.lootdropper:AddRandomLoot("base_moonglass",
		TUNING.ARCUEID_PROBABILITY.DROP_COMMON_NIGHTMARE_MOONGLASS)
end)
--影怪3掉落>月亮水晶
AddPrefabPostInit("terrorbeak", function(inst)
	inst.components.lootdropper.numrandomloot = 1
	inst.components.lootdropper:AddRandomLoot("base_moonglass",
		TUNING.ARCUEID_PROBABILITY.DROP_COMMON_NIGHTMARE_MOONGLASS)
end)
--影怪4掉落>月亮水晶
AddPrefabPostInit("crawlinghorror", function(inst)
	inst.components.lootdropper.numrandomloot = 1
	inst.components.lootdropper:AddRandomLoot("base_moonglass",
		TUNING.ARCUEID_PROBABILITY.DROP_COMMON_NIGHTMARE_MOONGLASS)
end)

--岩石（硝）>月岩
AddPrefabPostInit("rock1", function(inst)
	inst.components.lootdropper.numrandomloot = 1
	inst.components.lootdropper:AddRandomLoot("base_moonrock_nugget", TUNING.ARCUEID_PROBABILITY.DROP_MOONROCK)
end)
--岩石（金）>月岩
AddPrefabPostInit("rock2", function(inst)
	inst.components.lootdropper.numrandomloot = 1
	inst.components.lootdropper:AddRandomLoot("base_moonrock_nugget", TUNING.ARCUEID_PROBABILITY.DROP_MOONROCK)
end)
--岩石>月岩
AddPrefabPostInit("rock_flintless", function(inst)
	inst.components.lootdropper.numrandomloot = 1
	inst.components.lootdropper:AddRandomLoot("base_moonrock_nugget", TUNING.ARCUEID_PROBABILITY.DROP_MOONROCK)
end)
--黑耀石>月岩
AddPrefabPostInit("rock_obsidian", function(inst)
	inst.components.lootdropper.numrandomloot = 1
	inst.components.lootdropper:AddRandomLoot("base_moonrock_nugget", TUNING.ARCUEID_PROBABILITY.DROP_MOONROCK)
end)

--修改坟墓掉落>不灭烛,调料
AddPrefabPostInit("mound", function(inst)
	--修改的是mound的onfinishcallback方法
	inst.components.workable:SetOnFinishCallback(
		function(inst, worker)
			inst.AnimState:PlayAnimation("dug")
			inst:RemoveComponent("workable")
			inst.components.hole.canbury = true

			if worker then
				if worker.components.sanity then
					worker.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
				end
				if math.random() < .1 then
					local ghost = SpawnPrefab("ghost")
					local pos = Point(inst.Transform:GetWorldPosition())
					pos.x = pos.x - .3
					pos.z = pos.z - .3
					if ghost then
						ghost.Transform:SetPosition(pos.x, pos.y, pos.z)
					end
				elseif worker.components.inventory then
					local item = nil
					if math.random() < .6 then
						local loots =
						{
							nightmarefuel = 2,
							amulet = 2,
							gears = 2,
							redgem = 6,
							bluegem = 6,
							trinket_eternallight = 3,
							trinket_seasoningbottle = 3,
						}
						item = weighted_random_choice(loots)
					else
						item = "trinket_" .. tostring(math.random(NUM_TRINKETS))
					end

					if item then
						inst.components.lootdropper:SpawnLootPrefab(item)
					end
				end
			end
		end)
end)
