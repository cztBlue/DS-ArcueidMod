-- 早期代码
-- local function IsChainHead(inst, str)
-- 	local result = false
-- 	if inst.prefab == "pigman_farmer" and (str == "你有草吗？" or str == "别碰我农场里的东西") then
-- 		--print("Yes,IsChainHead")
-- 		result = true
-- 	end
-- 	return result
-- end


-- --回嘴内容,false终止对话，防死递归
-- --有空再封装
-- local function MayRetort(inst, toinst, str, retable)
-- 	--print("RetortBegin")
-- 	--print(inst.prefab.." to "..toinst.prefab.."say"..str)
-- 	--arc：
-- 	if inst.prefab == "pigman_farmer" and (str == "你有草吗？" or str == "别碰我农场里的东西" or str == "你能把你的草卖给我吗") then
-- 		--print("arcsay")
-- 		toinst:StartThread(function()
-- 			Sleep(1.5)
-- 			toinst.components.talker:Say("换你妈。(小声bb", 1.5, nil, nil, nil, inst, toinst, true)
-- 		end)
-- 	end
-- 	--arc的动物朋友们：
-- 	if inst.prefab == "arcueid" and str == "换你妈。(小声bb" then
-- 		--print("pigsay")
-- 		toinst:StartThread(function()
-- 			Sleep(1.5)
-- 			toinst.components.talker:Say("我他妈听得见！", 1.5, nil, nil, nil, toinst, inst, false)
-- 		end)
-- 	end
-- end


-- --实现回嘴（用单递归
-- --猪镇的API多了两个参数
-- AddComponentPostInit("talker", function(inst)
-- 	local oldSay = inst.Say
-- 	if GetWorld().prefab == "porkland" then
-- 		function inst:Say(script, time, noanim, kill_loop, mood, inst, toinst, retable)
-- 			oldSay(self, script, time, noanim, kill_loop, mood)

-- 			if IsChainHead(self.inst, script) then
-- 				MayRetort(self.inst, GetPlayer(), script)
-- 				return
-- 			end
-- 			if retable == true then
-- 				MayRetort(toinst, inst, script)
-- 				return
-- 			end
-- 		end
-- 	else
-- 		function inst:Say(script, time, noanim, inst, toinst, retable)
-- 			oldSay(self, script, time, noanim)

-- 			--对话文本准备好了再开放
-- 			if false then
-- 				-- if IsChainHead(self.inst, script) then
-- 				MayRetort(self.inst, GetPlayer(), script)
-- 				return
-- 			end

-- 			if retable == true then
-- 				MayRetort(toinst, inst, script)
-- 				return
-- 			end
-- 		end
-- 	end
-- end)
