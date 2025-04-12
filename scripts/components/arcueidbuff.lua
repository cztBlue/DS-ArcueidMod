-- 写一个buff的流程：向allbuffinfo添加buff信息->添加一个图标
local ArcueidBuff = Class(function(self, inst)
    self.inst = inst
    self.interval = 1
    self.staticvar = {}
    --不按规则起名字找不到对应资源
    self.islastbuffactive =
    {
        ['lbuff_recover'] = false,
        ['lbuff_pep'] = false,
        ['lbuff_dehunger'] = false,
        ['lbuff_echou'] = false,
        ['lbuff_fillfull'] = false,
        ['lbuff_bleed'] = false,
    }
    --记录buff的剩余时长，也用于检测身上有那些buff
    self.buff_modifiers_add_timer = { ['buff_bottlelight'] = 0 }
    self.buff_modifiers_add = {
        --持续性buff
        --【月球生物】
        ['lbuff_seleniclife'] = function(self, willclose)
            if (willclose ~= nil) and willclose == true then
                if self.staticvar['lbuff_seleniclife'] then
                end
                return
            end

            -- 这个逻辑写在arcueid的update里面
            -- 我改累了以后挑个时间再般过来，现在只把数值打在UI上
            local d = self.inst.components.arcueidstate.displaymultiplier["damage"]
            local s = self.inst.components.arcueidstate.displaymultiplier["walkspeed"]
            if d and s then
                self.allbuffinfo['INTRODUCTION']['lbuff_seleniclife'] = "【月球生物】：增幅与时段/活力有关; 攻击加成：*" .. d .. "; 移速加成:" ..
                    s
            end
        end,

        --【笨拙的心】
        ['lbuff_awkheart'] = function(self, willclose)
            if (willclose ~= nil) and willclose == true then
                if self.staticvar['lbuff_awkheart'] then
                    if self.staticvar['lbuff_awkheart']['unlockfn'] then
                        self.inst.components.builder.UnlockRecipe = self.staticvar['lbuff_awkheart']['unlockfn']
                    end
                end
                return
            end

            if self.staticvar['lbuff_awkheart'] == nil then
                self.staticvar['lbuff_awkheart'] = {}
                self.staticvar['lbuff_awkheart']['unlockfn'] = self.inst.components.builder.UnlockRecipe
            end

            -- 做饭的逻辑是写在锅上的，这部分逻辑在modmain
            -- 这里不好动态修改，先搁置...

            -- 解锁逻辑
            self.inst.components.builder.UnlockRecipe = function(self_, recname)
                local recipe = GetRecipe(recname)
                --改动了：解锁逻辑
                if self_.inst.prefab == "arcueid" then
                    --先知之眼导入正常解锁逻辑
                    if (self_.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET))
                        and (self_.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_propheteye") then
                        if self_:CanLearnRecipe(recipe) then
                            if self_.inst.components.sanity then
                                self_.inst.components.sanity:DoDelta(TUNING.SANITY_MED)
                            end
                            self_:AddRecipe(recname)
                            self_.inst:PushEvent("unlockrecipe", { recipe = recname })
                        end
                    else
                        if self_.inst.components.arcueidstate.recipeunlock[recname] == nil then
                            self_.inst.components.arcueidstate.recipeunlock[recname] = 1
                        elseif self_.inst.components.arcueidstate.recipeunlock[recname] >= 1
                            and self_.inst.components.arcueidstate.recipeunlock[recname] < 9 then
                            self_.inst.components.arcueidstate.recipeunlock[recname] = self.inst.components.arcueidstate
                                .recipeunlock[recname] + 1
                        elseif self_.inst.components.arcueidstate.recipeunlock[recname] >= 9 then
                            if self_:CanLearnRecipe(recipe) then
                                if self_.inst.components.sanity then
                                    self_.inst.components.sanity:DoDelta(TUNING.SANITY_MED)
                                end
                                self_:AddRecipe(recname)
                                self_.inst:PushEvent("unlockrecipe", { recipe = recname })
                            end
                        end
                    end
                else
                    if self_:CanLearnRecipe(recipe) then
                        if self_.inst.components.sanity then
                            self_.inst.components.sanity:DoDelta(TUNING.SANITY_MED)
                        end
                        self_:AddRecipe(recname)
                        self_.inst:PushEvent("unlockrecipe", { recipe = recname })
                    end
                end
            end
        end,

        --【哀戚的魂灵】
        ['lbuff_forsasoul'] = function(self, willclose)
            if (willclose ~= nil) and willclose == true then
                if self.staticvar['lbuff_forsasoul'] then
                    if self.staticvar['lbuff_forsasoul']['doattackfn'] then
                        self.inst.components.combat.DoAttack = self.staticvar['lbuff_forsasoul']['doattackfn']
                    end
                end
                self.inst.components.arcueidstate.damagerate_mul["LIVESOUL"] = 1
                self.inst.components.arcueidstate.damagerate_mul["MONSTERSOUL"] = 1 
                return
            end

            if self.staticvar['lbuff_forsasoul'] == nil then
                self.staticvar['lbuff_forsasoul'] = {}
                self.staticvar['lbuff_forsasoul']['doattackfn'] = self.inst.components.combat.DoAttack
            end

            local oldattack = self.staticvar['lbuff_forsasoul']['doattackfn']
            self.inst.components.combat.DoAttack = function(self_, target_override, weapon, projectile, stimuli,
                                                            instancemult)

                if target_override and target_override:HasTag("monster") then
                    self.inst.components.arcueidstate.damagerate_mul["LIVESOUL"] = 1
                    self.inst.components.arcueidstate.damagerate_mul["MONSTERSOUL"] = 0.8 
                else
                    self.inst.components.arcueidstate.damagerate_mul["LIVESOUL"] = 0.5
                    self.inst.components.arcueidstate.damagerate_mul["MONSTERSOUL"] = 1 
                end

                return oldattack(self_, target_override, weapon, projectile, stimuli, instancemult)
            end
        end,

        --流血
        ['lbuff_bleed'] = function(self, willclose)
            if (willclose ~= nil) and willclose == true then
                return
            end
            -- 逻辑写在arcueidstate
            self.allbuffinfo['INTRODUCTION']['lbuff_bleed'] = "【流血】：出血速率:0.417/s" ..
                ",余出血量:" .. self.inst.components.arcueidstate.bleedhealth
        end,

        --【衰败的肉体】：不能通过食物快速回速率：80/480s（回血栈上限100点），
        --受重伤（单次受到-40点的伤害）会造成速率 -120/480s（共50%受到伤害的流血），
        --爪子消耗活力值3/v,  饥饿速率*1.25
        ['lbuff_blightedbody'] = function(self, willclose)
            -- 退出buff逻辑
            if (willclose ~= nil) and willclose == true then
                self.inst.components.eater:SetCanEatTestFn(nil)
                self.inst.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE
                if self.staticvar['lbuff_blightedbody'] then
                    if self.staticvar['lbuff_blightedbody']['eatfn'] then
                        self.inst.components.eater.Eat = self.staticvar['lbuff_blightedbody']['eatfn']
                    end
                    if self.staticvar['lbuff_blightedbody']['eatfn'] then
                        self.inst.components.health.DoDelta = self.staticvar['lbuff_blightedbody']['healthfn']
                    end
                end
                return
            end

            if self.staticvar['lbuff_blightedbody'] == nil then
                self.staticvar['lbuff_blightedbody'] = {}
                self.staticvar['lbuff_blightedbody']['eatfn'] = self.inst.components.eater.Eat
                self.staticvar['lbuff_blightedbody']['healthfn'] = self.inst.components.health.DoDelta
            end

            --消耗活力
            -- ...这个逻辑写在sharpclaw

            -- 饥饿速率
            self.inst.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE * 1.25

            -- 重伤流血
            local oldHealth = self.staticvar['lbuff_blightedbody']['healthfn']
            self.inst.components.health.DoDelta = function(_self, amount, overtime, cause, ignore_invincible,
                                                           skipredirect)
                if _self.inst.prefab == "arcueid" then
                    if amount <= -40 then
                        inst.components.arcueidstate:AddBleedHealth(-amount / 2)
                    end
                end
                return oldHealth(_self, amount, overtime, cause, ignore_invincible, skipredirect)
            end

            -- 限制回血
            local oldEat = self.staticvar['lbuff_blightedbody']['eatfn']
            self.inst.components.eater.Eat = function(_self, food)
                if _self.inst.prefab == "arcueid" then
                    if food.components.edible and food.components.edible.healthvalue then
                        _self.inst.components.arcueidstate:AddFoodHealth(food.components.edible.healthvalue)
                        food.components.edible.healthvalue = 0
                    end
                end
                return oldEat(_self, food)
            end
        end,

        --公主病：不能吃生食，非烹制食物效果 * 0.6
        ['lbuff_prinsynd'] = function(self, willclose)
            -- 退出buff逻辑
            -- 退出公主病本应该去掉食物*.6的buff，要不然退出才会生效，这个工作以后再做
            if (willclose ~= nil) and willclose == true then
                self.inst.components.eater:SetCanEatTestFn(nil)
                return
            end

            if (willclose ~= nil) and willclose == true then
                return
            end

            self.inst.components.eater:SetCanEatTestFn(
                function(eater_, food)
                    if eater_ and eater_.prefab == "arcueid" then
                        -- 生食
                        if food and food.components.cookable ~= nil then
                            return false
                        else
                            -- 效果减半

                            if (food:HasTag("preparedfood") == false or
                                    food.components.edible.foodstate ~= "PREPARED") and
                                food.foodbesetvalue == nil then
                                food.foodbesetvalue = true
                                food.components.edible.healthvalue = food.components.edible.healthvalue * 0.6
                                food.components.edible.hungervalue = food.components.edible.hungervalue * 0.6
                                food.components.edible.sanityvalue = food.components.edible.sanityvalue * 0.6
                            end

                            return true
                        end
                    end
                end
            )
        end,

        --恶臭，被视为怪物,自动被蜘蛛跟随
        ['lbuff_echou'] = function(self, willclose)
            if (willclose ~= nil) and willclose == true then
                return
            end

            if self.islastbuffactive['lbuff_echou'] == true and not self.inst:HasTag("monster") then
                self.inst:AddTag("monster")
                if self.inst and self.inst.components.leader then
                    self.inst.components.leader:RemoveFollowersByTag("pig")
                    local x, y, z = self.inst.Transform:GetWorldPosition()
                    local ents = TheSim:FindEntities(x, y, z, TUNING.SPIDERHAT_RANGE, { "spider" })
                    for k, v in pairs(ents) do
                        if (not v.components.health or not v.components.health:IsDead()) and v.components.follower and not v.components.follower.leader and not self.inst.components.leader:IsFollower(v) and self.inst.components.leader.numfollowers < 10 then
                            self.inst.components.leader:AddFollower(v)
                        end
                    end
                end
            elseif self.islastbuffactive['lbuff_echou'] == false and self.inst:HasTag("monster") then
                self.inst:RemoveTag("monster")
                self.inst.components.leader:RemoveFollowersByTag("pig")
                self.inst.components.leader:RemoveFollowersByTag("spider")
            end
        end,
        --回血
        ['lbuff_recover'] = function(self, willclose)
            if (willclose ~= nil) and willclose == true then
                return
            end
            self.inst.components.health:DoDelta(TUNING.ARCUEID_BUFFSMALL)
        end,
        --回san
        ['lbuff_pep'] = function(self, willclose)
            if (willclose ~= nil) and willclose == true then
                return
            end
            self.inst.components.sanity:DoDelta(TUNING.ARCUEID_BUFFSMALL)
        end,
        --去饱食度
        ['lbuff_dehunger'] = function(self, willclose)
            if (willclose ~= nil) and willclose == true then
                return
            end
            self.inst.components.hunger:DoDelta(-TUNING.ARCUEID_BUFFMIDDLE)
        end,
        --吃饱了
        ['lbuff_fillfull'] = function(self, willclose)
            if (willclose ~= nil) and willclose == true then
                return
            end
            self.inst.components.vigour:DoDelta(TUNING.ARCUEID_BUFFTINY)
        end,
        --清醒
        ['lbuff_awakening'] = function(self, willclose)
            if (willclose ~= nil) and willclose == true then
                return
            end
            self.inst.components.arcueidstate:DoDeltaForErosion_TEMP(-TUNING.ARCUEID_BUFFTINY)
        end,
        --生命回归 1:2
        ['lbuff_vigoursacrifice1'] = function(self, willclose)
            if (willclose ~= nil) and willclose == true then
                self.inst.components.vigour.vigourtr = 0
                inst.DynamicShadow:Enable(true)
                inst.AnimState:OverrideSymbol("face", "arcueid", "face")
                inst.AnimState:OverrideSymbol("foot", "arcueid", "foot")
                inst.shadow1:Hide()
                inst.sg:GoToState("idle")
                return
            end

            if inst.sg.currentstate.name ~= "sg_locked" then
                inst.DynamicShadow:Enable(false)
                inst.AnimState:OverrideSymbol("face", "arcueid_action_normal", "face")
                inst.AnimState:OverrideSymbol("foot", "arcueid_action_normal", "foot")
                inst.shadow1:Show()
                inst.sg:GoToState("sg_locked") -- no move
            end
            self.inst.components.vigour.vigourtr = -1
            self.inst.components.health:DoDelta(2)
        end,
        --理智回归 1:3
        ['lbuff_vigoursacrifice2'] = function(self, willclose)
            if (willclose ~= nil) and willclose == true then
                self.inst.components.vigour.vigourtr = 0
                inst.DynamicShadow:Enable(true)
                inst.AnimState:OverrideSymbol("face", "arcueid", "face")
                inst.AnimState:OverrideSymbol("foot", "arcueid", "foot")
                inst.shadow1:Hide()
                inst.sg:GoToState("idle")
                return
            end

            if inst.sg.currentstate.name ~= "sg_locked" then
                inst.DynamicShadow:Enable(false)
                inst.AnimState:OverrideSymbol("face", "arcueid_action_normal", "face")
                inst.AnimState:OverrideSymbol("foot", "arcueid_action_normal", "foot")
                inst.shadow1:Show()
                inst.sg:GoToState("sg_locked") -- no move
            end
            self.inst.components.vigour.vigourtr = -1
            self.inst.components.sanity:DoDelta(3)
        end,
        --回归体力 1:0.1
        ['lbuff_vigoursacrifice3'] = function(self, willclose)
            if (willclose ~= nil) and willclose == true then
                self.inst.components.vigour.vigourtr = 0
                inst.DynamicShadow:Enable(true)
                inst.AnimState:OverrideSymbol("face", "arcueid", "face")
                inst.AnimState:OverrideSymbol("foot", "arcueid", "foot")
                inst.shadow1:Hide()
                inst.sg:GoToState("idle")
                return
            end

            if inst.sg.currentstate.name ~= "sg_locked" then
                inst.DynamicShadow:Enable(false)
                inst.AnimState:OverrideSymbol("face", "arcueid_action_normal", "face")
                inst.AnimState:OverrideSymbol("foot", "arcueid_action_normal", "foot")
                inst.shadow1:Show()
                inst.sg:GoToState("sg_locked") -- no move
            end
            self.inst.components.vigour.vigourtr = 0.3
            self.inst.components.hunger:DoDelta(-3)
        end,


        --时限性buff
        --恢复->回血
        ['buff_recover'] = function(self)
            self.inst.components.health:DoDelta(TUNING.ARCUEID_BUFFMIDDLE)
        end,
        --画饼->回饱食度
        ['buff_pieInTheSky'] = function(self)
            self.inst.components.hunger:DoDelta(TUNING.ARCUEID_BUFFMIDDLE)
        end,
        --振奋->回san
        ['buff_pep'] = function(self)
            self.inst.components.sanity:DoDelta(TUNING.ARCUEID_BUFFMIDDLE)
        end,
        --光环->发光(60s)
        ['buff_halo'] = function(self)
            --发光(125, 249, 255)电蓝色
            local light = self.inst.entity:AddLight()
            light:SetIntensity(.4)
            light:SetFalloff(2)
            light:SetRadius(6)
            light:SetColour(125 / 255, 249 / 255, 255 / 255)
            light:Enable(true)
            if self.buff_modifiers_add_timer['buff_halo'] == 0 then
                self.inst:DoTaskInTime(0, function()
                    light:Enable(false)
                end)
            end
        end,
        --小小精灵
        ['buff_bottlelight'] = function(self)
            --深橙色（255,140,0）
            local light = self.inst.entity:AddLight()
            light:SetIntensity(self.buff_modifiers_add_timer['buff_bottlelight'] * .25 / 100 + .1)
            light:SetFalloff(2)
            light:SetRadius(self.buff_modifiers_add_timer['buff_bottlelight'] * 4.1 / 100)
            light:SetColour(255 / 255, 140 / 255, 0 / 255)
            light:Enable(true)
            if self.buff_modifiers_add_timer['buff_bottlelight'] == 0 then
                self.inst:DoTaskInTime(0, function()
                    light:Enable(false)
                end)
            end
        end,
        --休憩->回复活力
        ['buff_rest'] = function(self)
            self.inst.components.vigour:DoDelta(TUNING.ARCUEID_BUFFLARGE)
        end,
        --舒适->同时回复三维
        ['buff_restore'] = function(self)
            self.inst.components.health:DoDelta(TUNING.ARCUEID_BUFFMIDDLE)
            self.inst.components.hunger:DoDelta(TUNING.ARCUEID_BUFFMIDDLE)
            self.inst.components.sanity:DoDelta(TUNING.ARCUEID_BUFFMIDDLE)
        end,
        --夜视->全屏不黑(60s)
        ['buff_nightVision'] = function(self)
            if GetClock() and GetWorld() and GetWorld().components.colourcubemanager then
                GetClock():SetNightVision(true)
                GetWorld().components.colourcubemanager:SetOverrideColourCube(
                    "images/colour_cubes/mole_vision_on_cc.tex", 2)
                if self.buff_modifiers_add_timer['buff_nightVision'] <= 5 then
                    if GetClock() then
                        GetClock():SetNightVision(false)
                    end
                    if GetWorld() and GetWorld().components.colourcubemanager then
                        GetWorld().components.colourcubemanager:SetOverrideColourCube(nil, .5)
                    end
                end
            end
        end,
        --残疾->临时扣血量上限(max=>-90)
        ['buff_disability'] = function(self)
            if self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil
                and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab == "trinket_moonwristband"
            then
                return
            end
            if self.buff_modifiers_add_timer['buff_disability'] > 90 then
                self.inst.components.health.buffpenalty = 90
            else
                self.inst.components.health.buffpenalty = self.buff_modifiers_add_timer['buff_disability']
            end
        end,
        --敌视->被当成怪物
        ['buff_hatred'] = function(self)
            if self.buff_modifiers_add_timer['buff_hatred'] >= 2 and not self.inst:HasTag("monster") then
                self.inst:AddTag("monster")
            elseif self.buff_modifiers_add_timer['buff_hatred'] < 2 and self.inst:HasTag("monster") then
                self.inst:RemoveTag("monster")
            end
        end,
        --盲视->血滤镜（锁高度？）(50s)
        ['buff_blindness'] = function(self)
            if self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil
                and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab == "trinket_moonwristband" then
                self.buff_modifiers_add_timer['buff_blindness'] = 0
            end
        end,
        --抵抗
        ['buff_resistance'] = function(self)
            --退出buff逻辑
            if self.buff_modifiers_add_timer['buff_resistance'] == 0 then
                self.inst:DoTaskInTime(0, function()
                    self.inst.components.arcueidstate.resistance_mul["POTION_RESILIENCE"] = 1
                end)
                return
            end

            --buff逻辑
            self.inst.components.arcueidstate.resistance_mul["POTION_RESILIENCE"] = 0.7
        end,
        --暴击
        ['buff_critical'] = function(self)
            --退出buff逻辑
            if self.buff_modifiers_add_timer['buff_critical'] == 0 then
                self.inst:DoTaskInTime(0, function()
                    self.inst.components.arcueidstate.critical_add["POTION_CRITICAL"] = 0
                end)
                return
            end

            --buff逻辑
            self.inst.components.arcueidstate.critical_add["POTION_CRITICAL"] = 0.4
        end,
        --汲血
        ['buff_bloodthirst'] = function(self)
            --退出buff逻辑
            if self.buff_modifiers_add_timer['buff_bloodthirst'] == 0 then
                self.inst:DoTaskInTime(0, function()
                    self.inst.components.arcueidstate.bloodthirst_add["POTION_BLOODTHIRST"] = 0
                end)
                return
            end

            --buff逻辑
            self.inst.components.arcueidstate.bloodthirst_add["POTION_BLOODTHIRST"] = 0.08
        end,
    }

    self.allbuffinfo = {
        -- buff类型
        ['TYPE'] = {
            ['lbuff_recover'] = "last",
            ['lbuff_pep'] = "last",
            ['lbuff_dehunger'] = "last",
            ['lbuff_echou'] = "last",
            ['lbuff_fillfull'] = "last",
            ['lbuff_prinsynd'] = "last",
            ['lbuff_blightedbody'] = "last",
            ['lbuff_bleed'] = "last",
            ['lbuff_forsasoul'] = "last",
            ['lbuff_awkheart'] = "last",
            ['lbuff_seleniclife'] = "last",
            ['lbuff_vigoursacrifice1'] = "last",
            ['lbuff_vigoursacrifice2'] = "last",
            ['lbuff_vigoursacrifice3'] = "last",

            ['buff_recover'] = "timer",
            ['buff_pieInTheSky'] = "timer",
            ['buff_pep'] = "timer",
            ['buff_halo'] = "timer",
            ['buff_bottlelight'] = "timer",
            ['buff_rest'] = "timer",
            ['buff_restore'] = "timer",
            ['buff_nightVision'] = "timer",

            ['buff_disability'] = "timer",
            ['buff_hatred'] = "timer",
            ['buff_blindness'] = "timer",
            ['buff_resistance'] = "timer",
            ['buff_critical'] = "timer",
            ['buff_bloodthirst'] = "timer",
        },

        -- buff介绍
        ['INTRODUCTION'] = {
            --持续性buff
            ['lbuff_recover'] = "【恢复】：持续恢复生命",
            ['lbuff_pep'] = "【振奋】：持续恢复精神值",
            ['lbuff_dehunger'] = "【饥饿】：持续消耗饥饿值",
            ['lbuff_echou'] = "【恶臭】：被标记为怪物",
            ['lbuff_fillfull'] = "【吃饱了】：持续恢复活力值",
            ['lbuff_awakening'] = "【清醒】：降低轻度侵蚀",
            ['lbuff_prinsynd'] = "【公主病】：抗拒生食，非烹制食物效果 * 0.6",
            ['lbuff_blightedbody'] = "【衰败的肉体】：回血抑制(回复栈上限100);受重伤(>40/次)造成流血;徒手攻击消耗3;饥饿速率*1.25",
            ['lbuff_bleed'] = "【流血】：出血速率--,预出血量--",
            ['lbuff_forsasoul'] = "【哀戚的魂灵】：中立生物伤害系数：0.5,敌对生物伤害系数：0.8",
            ['lbuff_awkheart'] = "【笨拙的心】：很难解锁配方；不佩戴调料瓶做食物概率会糊",
            ['lbuff_seleniclife'] = "【月球生物】：增幅与时段/月相有关",
            ['lbuff_vigoursacrifice1'] = "【生命回归】：消耗活力值回复生命",
            ['lbuff_vigoursacrifice2'] = "【理智回归】：消耗活力值回复理智",
            ['lbuff_vigoursacrifice3'] = "【回归体力】：消耗饥饿值回复活力",

            --buff
            ['buff_recover'] = "【恢复】：持续恢复生命",
            ['buff_pieInTheSky'] = "【画饼】：持续恢复饥饿值",
            ['buff_pep'] = "【振奋】：持续恢复精神值",
            ['buff_halo'] = "【光环】：照亮周围",
            ['buff_bottlelight'] = "【小小精灵】：生成一个照明小精灵",
            ['buff_rest'] = "【休憩】：恢复活力值",
            ['buff_restore'] = "【舒适】：小幅度恢复三维",
            ['buff_nightVision'] = "【夜视】：提供视野",
            ['buff_resistance'] = "【抵抗】：获得0.7的抗性系数",
            ['buff_critical'] = "【集中】：获得40%的暴击（伤害*2）概率",
            ['buff_bloodthirst'] = "【汲血】：每次攻击获得8%的吸血效果",
            --debuff
            ['buff_disability'] = "【残疾】：临时扣除血量上限",
            ['buff_hatred'] = "【敌视】：被标记为怪物",
            ['buff_blindness'] = "【盲视】：视野遮蔽",
        },

        -- buff默认持续时间，持续性buff不用填
        ['BUFF_DEFAULT_TIME'] = {
            --buff
            ['buff_recover'] = 300,
            ['buff_pieInTheSky'] = 350,
            ['buff_pep'] = 300,
            ['buff_halo'] = 200,
            ['buff_bottlelight'] = 100,
            ['buff_rest'] = 300,
            ['buff_restore'] = 220,
            ['buff_nightVision'] = 400,
            ['buff_resistance'] = 240,
            ['buff_critical'] = 240,
            ['buff_bloodthirst'] = 240,
            --debuff
            ['buff_disability'] = 13,
            ['buff_hatred'] = 200,
            ['buff_blindness'] = 20,
        },

        --图标资源是否存在，没有可以不填
        ['iconexistlist'] =
        {
            ["buff_bleed"] = true,
            ["buff_dehunger"] = true,
            ["buff_halo"] = true,
            ["buff_pep"] = true,
            ["buff_restore"] = true,
            ["buff_blightedbody"] = true,
            ["buff_awakening"] = true,
            ["buff_seleniclife"] = true,
            ["buff_awkheart"] = true,
            ["buff_prinsynd"] = true,
            ["buff_forsasoul"] = true,

            ["lbuff_bleed"] = true,
            ["lbuff_dehunger"] = true,
            ["lbuff_halo"] = true,
            ["lbuff_pep"] = true,
            ["lbuff_restore"] = true,
            ["lbuff_blightedbody"] = true,
            ["lbuff_awakening"] = true,
            ["lbuff_seleniclife"] = true,
            ["lbuff_awkheart"] = true,
            ["lbuff_prinsynd"] = true,
            ["lbuff_forsasoul"] = true,
            ["lbuff_fillfull"] = true,
            ["lbuff_vigoursacrifice1"] = true,
            ["lbuff_vigoursacrifice2"] = true,
            ["lbuff_vigoursacrifice3"] = true,
        },

        -- buff激活的效果(不用填)
        ['BUFF_MODIFIERS_ADD'] = self.buff_modifiers_add,

        -- 持续性buff是否被激活(不用填)
        ['ISLASTBUFFACTIVE'] = self.islastbuffactive,

    }
end)

--ARC对之身BUFF状态的自检逻辑
function ArcueidBuff:BuffSelfTest()
    --【吃饱了】逻辑
    if self.inst.components.hunger.current >= 100 then
        self:SetArcueidLastBuff('lbuff_fillfull', true)
    else
        self:SetArcueidLastBuff('lbuff_fillfull', false)
    end

    --【清醒】逻辑
    if self.inst.components.sanity:GetPercent() >= .9 then
        self:SetArcueidLastBuff('lbuff_awakening', true)
    else
        self:SetArcueidLastBuff('lbuff_awakening', false)
    end

    --【流血】逻辑
    if self.inst.components.arcueidstate.bleedhealth
        and (self.inst.components.arcueidstate.bleedhealth > 0) then
        self:SetArcueidLastBuff('lbuff_bleed', true)
    else
        self:SetArcueidLastBuff('lbuff_bleed', false)
    end

    --【月球生物】逻辑
    self:SetArcueidLastBuff('lbuff_seleniclife', true)

    --【公主病】逻辑
    if (self.inst.components.arcueidstate.ldebuffstate['lbuff_prinsynd'] == nil)
        or (self.inst.components.arcueidstate.ldebuffstate['lbuff_prinsynd'] and
            self.inst.components.arcueidstate.ldebuffstate['lbuff_prinsynd'] == true)
    then
        self:SetArcueidLastBuff('lbuff_prinsynd', true)
    else
        self:SetArcueidLastBuff('lbuff_prinsynd', false)
    end

    --【衰败的肉体】逻辑
    if (self.inst.components.arcueidstate.ldebuffstate['lbuff_blightedbody'] == nil)
        or (self.inst.components.arcueidstate.ldebuffstate['lbuff_blightedbody'] and
            self.inst.components.arcueidstate.ldebuffstate['lbuff_blightedbody'] == true)
    then
        self:SetArcueidLastBuff('lbuff_blightedbody', true)
    else
        self:SetArcueidLastBuff('lbuff_blightedbody', false)
    end

    --【哀戚的魂灵】逻辑
    if (self.inst.components.arcueidstate.ldebuffstate['lbuff_forsasoul'] == nil)
        or (self.inst.components.arcueidstate.ldebuffstate['lbuff_forsasoul'] and
            self.inst.components.arcueidstate.ldebuffstate['lbuff_forsasoul'] == true)
    then
        self:SetArcueidLastBuff('lbuff_forsasoul', true)
    else
        self:SetArcueidLastBuff('lbuff_forsasoul', false)
    end

    --【笨拙的心】逻辑
    if (self.inst.components.arcueidstate.ldebuffstate['lbuff_awkheart'] == nil)
        or (self.inst.components.arcueidstate.ldebuffstate['lbuff_awkheart'] and
            self.inst.components.arcueidstate.ldebuffstate['lbuff_awkheart'] == true)
    then
        self:SetArcueidLastBuff('lbuff_awkheart', true)
    else
        self:SetArcueidLastBuff('lbuff_awkheart', false)
    end

    -- 【生命回归】
    if (self.inst.components.arcueidstate.abilityon == true)
        and self.inst.components.arcueidstate.abilityselected == 1 then
        self:SetArcueidLastBuff('lbuff_vigoursacrifice1', true)
    else
        self:SetArcueidLastBuff('lbuff_vigoursacrifice1', false)
    end

    -- 【理智回归】
    if (self.inst.components.arcueidstate.abilityon == true)
        and self.inst.components.arcueidstate.abilityselected == 2 then
        self:SetArcueidLastBuff('lbuff_vigoursacrifice2', true)
    else
        self:SetArcueidLastBuff('lbuff_vigoursacrifice2', false)
    end

    -- 【体力回归】
    if (self.inst.components.arcueidstate.abilityon == true)
        and self.inst.components.arcueidstate.abilityselected == 3 then
        self:SetArcueidLastBuff('lbuff_vigoursacrifice3', true)
    else
        self:SetArcueidLastBuff('lbuff_vigoursacrifice3', false)
    end
end

--给arc设置一个持续性buff,control传入true or false控制开关
function ArcueidBuff:SetArcueidLastBuff(key, control)
    if self.allbuffinfo["TYPE"][key] ~= "last" then
        return
    end

    if key then
        -- 触发激活退出逻辑
        if (control ~= nil) and (control == false) then
            if (self.islastbuffactive[key] == true) then
                self.buff_modifiers_add[key](self, true)
            end
            self.islastbuffactive[key] = false
            return
        end

        self.islastbuffactive[key] = true
    end
end

--给arc设置一个buff 时长为timer名为key的buff
function ArcueidBuff:ActiveArcueidBuff(key, timer)
    if key then
        self.buff_modifiers_add_timer[key] = timer or self.allbuffinfo['BUFF_DEFAULT_TIME'][key]
    end
end

--给arc增量一个buff 时长为timer名为key的buff时间
function ArcueidBuff:AddArcueidBuff(key, timer)
    if key and self.buff_modifiers_add_timer[key] == nil then
        self.buff_modifiers_add_timer[key] = 0
    end

    if key then
        self.buff_modifiers_add_timer[key] = self.buff_modifiers_add_timer[key] +
            (timer or self.allbuffinfo['BUFF_DEFAULT_TIME'][key])
    end
end

-- 让buff生效一次
function ArcueidBuff:TaskBufffn()
    --持续性buff逻辑
    for key, value in pairs(self.islastbuffactive) do
        if self.islastbuffactive[key] == true then
            self.buff_modifiers_add_timer[key] = 100000
        else
            self.buff_modifiers_add_timer[key] = 0
        end
    end

    for k, v in pairs(self.buff_modifiers_add_timer) do
        if self.buff_modifiers_add_timer[k] and self.buff_modifiers_add_timer[k] > 0 then
            self.buff_modifiers_add_timer[k] = self.buff_modifiers_add_timer[k] - self.interval
            
            if self.buff_modifiers_add[k] ~= nil then self.buff_modifiers_add[k](self) end
        end
    end
end

-- 周期让buff生效
function ArcueidBuff:Starbuff()
    self.taskbuff = self.inst:DoPeriodicTask(self.interval, function()
        self:TaskBufffn()
        self:BuffSelfTest()
    end)
end

function ArcueidBuff:OnSave()
    local data = {}
    data.buff_modifiers_add_timer = self.buff_modifiers_add_timer
    return data
end

function ArcueidBuff:OnLoad(data)
    self.buff_modifiers_add_timer = data.buff_modifiers_add_timer
    self:Starbuff()
end

return ArcueidBuff
