local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("ANIM", "anim/player_basic.zip"),
    Asset("ANIM", "anim/player_idles_shiver.zip"),
    Asset("ANIM", "anim/player_actions.zip"),
    Asset("ANIM", "anim/player_actions_axe.zip"),
    Asset("ANIM", "anim/player_actions_pickaxe.zip"),
    Asset("ANIM", "anim/player_actions_shovel.zip"),
    Asset("ANIM", "anim/player_actions_blowdart.zip"),
    Asset("ANIM", "anim/player_actions_eat.zip"),
    Asset("ANIM", "anim/player_actions_item.zip"),
    Asset("ANIM", "anim/player_actions_uniqueitem.zip"),
    Asset("ANIM", "anim/player_actions_bugnet.zip"),
    Asset("ANIM", "anim/player_actions_fishing.zip"),
    Asset("ANIM", "anim/player_actions_boomerang.zip"),
    Asset("ANIM", "anim/player_bush_hat.zip"),
    Asset("ANIM", "anim/player_attacks.zip"),
    Asset("ANIM", "anim/player_idles.zip"),
    Asset("ANIM", "anim/player_rebirth.zip"),
    Asset("ANIM", "anim/player_jump.zip"),
    Asset("ANIM", "anim/player_amulet_resurrect.zip"),
    Asset("ANIM", "anim/player_teleport.zip"),
    Asset("ANIM", "anim/wilson_fx.zip"),
    Asset("ANIM", "anim/player_one_man_band.zip"),
    Asset("ANIM", "anim/shadow_hands.zip"),
    Asset("SOUND", "sound/sfx.fsb"),
    Asset("SOUND", "sound/wilson.fsb"),
    Asset("ANIM", "anim/beard.zip"),

    --潜行动作移植了联机版的tiptoe
    Asset("ANIM", "anim/arcueid_action_tiptoe.zip"),
    Asset("ANIM", "anim/arcueid.zip"),
    --魔术科技图标
    Asset("ATLAS", "images/arcueid_moshuTAB.xml"),
}

local prefabs = {}
local start_inv = {}

--伤害和速度与活力,时间，月相挂钩
local staticmoon = ""
local function updatepower(inst)
    local timestr
    local Isbelow70per
    local Isbelow35per
    local moon = GetClock():GetMoonPhase()
    if staticmoon == nil or staticmoon == "" then
        staticmoon = GetClock():GetMoonPhase()
    elseif moon ~= staticmoon then
        GetWorld():PushEvent("moonphaseschange")
        staticmoon = moon
    end

    if GetClock():IsDay() then
        timestr = "DAY"
        inst.components.vigour.moonfactor = 0
        inst.components.health.invincible = false
    elseif GetClock():IsNight() then
        timestr = "NIGHT"
        inst.components.vigour.moonfactor = TUNING["ARCUEID_" .. string.upper(moon) .. "_MOONFACTOR"]
    elseif GetClock():IsDusk() then
        inst.components.vigour.moonfactor = TUNING["ARCUEID_" .. string.upper(moon) .. "_MOONFACTOR"]
        timestr = "DUSK"
    end

    if inst.components.vigour.currentvigour > 252 then
        Isbelow70per = false
        Isbelow35per = false
    elseif inst.components.vigour.currentvigour > 126 and inst.components.vigour.currentvigour < 256 then
        Isbelow70per = true
        Isbelow35per = false
    elseif inst.components.vigour.currentvigour < 126 then
        Isbelow70per = true
        Isbelow35per = true
    end

    -- if  IsSW or IsHAM then
    --满月相
    if moon == "full" and (timestr == "dusk" or timestr == "night") then
        inst.components.health.invincible = true
        inst.components.combat:AddDamageModifier("fullmoon_damage", TUNING.ARCUEID_FULLMOON_DAMAGEMULTIPLIER)
        inst.components.locomotor.walkspeed = TUNING.ARCUEID_FULLMOON_WALKSPEED
        inst.components.locomotor.runspeed = TUNING.ARCUEID_FULLMOON_RUNSPEED
        return
        --inst.components.talker:Say("啊,感觉今晚会比较有力气。")
    end

    if Isbelow70per == false and Isbelow35per == false then
        inst.components.combat.attack_damage_modifiers = {}
        inst.components.combat:AddDamageModifier(string.lower(timestr) .. "_damage",
            TUNING["ARCUEID_" .. timestr .. "_DAMAGEMULTIPLIER"])
        inst.components.locomotor.walkspeed = TUNING["ARCUEID_" .. timestr .. "_WALKSPEED"]
        inst.components.locomotor.runspeed = TUNING["ARCUEID_" .. timestr .. "_RUNSPEED"]
    elseif Isbelow70per == true and Isbelow35per == false then
        inst.components.combat.attack_damage_modifiers = {}
        inst.components.combat:AddDamageModifier(string.lower(timestr) .. "_damage",
            TUNING["ARCUEID_" .. timestr .. "_DAMAGEMULTIPLIER"] * (inst.components.vigour.currentvigour / 252))
        inst.components.locomotor.walkspeed = TUNING["ARCUEID_" .. timestr .. "_WALKSPEED"] *
            (inst.components.vigour.currentvigour / 252)
        inst.components.locomotor.runspeed = TUNING["ARCUEID_" .. timestr .. "_RUNSPEED"] *
            (inst.components.vigour.currentvigour / 252)
    elseif Isbelow70per == true and Isbelow35per == true then
        inst.components.combat.attack_damage_modifiers = {}
        inst.components.combat:AddDamageModifier(string.lower(timestr) .. "_damage",
            TUNING["ARCUEID_" .. timestr .. "_DAMAGEMULTIPLIER"] * (inst.components.vigour.currentvigour / 252))
        inst.components.locomotor.walkspeed = TUNING["ARCUEID_" .. timestr .. "_WALKSPEED"] * 0.35
        inst.components.locomotor.runspeed = TUNING["ARCUEID_" .. timestr .. "_RUNSPEED"] * 0.35
    end

    --侵蚀削弱
    local esrosionper = inst.components.arcueidstate:GetErosionPercent()
    if esrosionper > .2 then
        local factor = ((esrosionper - 0.2) / 0.8) * (0.45)
        inst.components.combat:AddDamageModifier("erosionweaken", -factor)
        inst.components.locomotor.walkspeed = inst.components.locomotor.walkspeed * (1 - factor)
        inst.components.locomotor.runspeed = inst.components.locomotor.runspeed * (1 - factor)
    end

    if inst.components.arcueidstate.careful == true then
        inst.components.locomotor.walkspeed = inst.components.locomotor.walkspeed * TUNING.ARCUEID_SNEAKYMULTIPLIER
        inst.components.locomotor.runspeed = inst.components.locomotor.runspeed * TUNING.ARCUEID_SNEAKYMULTIPLIER
    end

    if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET) ~= nil
        and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_relaxationbook" then
        inst.components.locomotor.walkspeed = 0.7 * inst.components.locomotor.walkspeed
        inst.components.locomotor.runspeed = 0.7 * inst.components.locomotor.runspeed
        inst.components.combat:AddDamageModifier("relaxationbook_damage", -0.5)
    end
end

--Arc的专属特殊配方
local function arcueid_recipes()
    local atlas_base_moonglass = "images/inventoryimages/base_moonglass.xml"
    local atlas_base_gemfragment = "images/inventoryimages/base_gemfragment.xml"
    local atlas_base_moonrock_nugget = "images/inventoryimages/base_moonrock_nugget.xml"
    local atlas_base_horrorfuel = "images/inventoryimages/base_horrorfuel.xml"
    local atlas_base_puregem = "images/inventoryimages/base_puregem.xml"
    local atlas_base_moonempyreality = "images/inventoryimages/base_moonempyreality.xml"
    local atlas_base_gemblock = "images/inventoryimages/base_gemblock.xml"
    local atlas_base_puremoonempyreality = "images/inventoryimages/base_puremoonempyreality.xml"
    local atlas_base_polishgem = "images/inventoryimages/base_polishgem.xml"
    local atlas_psionic_soil = "images/inventoryimages/psionic_soil.xml"
    local atlas_psionic_norsoil = "images/inventoryimages/psionic_norsoil.xml"
    local atlas_psionic_liquid = "images/inventoryimages/psionic_liquid.xml"
    local atlas_psionic_holypetal = "images/inventoryimages/psionic_holypetal.xml"

    ---------------------【基建】-------------------
    --具现原理
    local building_mooncirleform = Recipe("building_mooncirleform", {
            Ingredient("base_moonglass", 5, atlas_base_moonglass),
            Ingredient("ice", 3),
            Ingredient("bluegem", 1) },
        RECIPETABS.MOONMAGIC, TECH.MAGIC_THREE, nil, "building_mooncirleform_placer", 2)
    building_mooncirleform.atlas = "images/map_icons/mooncirleform.xml"
    building_mooncirleform.image = "mooncirleform.tex"
    --第二分解术式
    local building_recycleform = Recipe("building_recycleform", {
            Ingredient("base_moonglass", 5, atlas_base_moonglass),
            Ingredient("redgem", 2),
            Ingredient("bluegem", 2),
        },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_recycleform_placer", 2)
    building_recycleform.atlas = "images/map_icons/recycleform.xml"
    building_recycleform.image = "recycleform.tex"
    --饰品作坊
    local building_trinketworkshop = Recipe("building_trinketworkshop", {
            Ingredient("base_moonglass", 2, atlas_base_moonglass),
            Ingredient("boards", 4),
            Ingredient("goldnugget", 2),
        },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_trinketworkshop_placer", 2)
    building_trinketworkshop.atlas = "images/map_icons/trinketworkshop.xml"
    building_trinketworkshop.image = "trinketworkshop.tex"
    --炼金台
    local building_alchemydesk = Recipe("building_alchemydesk", {
            Ingredient("base_moonglass", 3, atlas_base_moonglass),
            Ingredient("livinglog", 4),
        },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_alchemydesk_placer", 2)
    building_alchemydesk.atlas = "images/map_icons/alchemydesk.xml"
    building_alchemydesk.image = "alchemydesk.tex"
    --奇迹煮锅
    local building_miraclecookpot = Recipe("building_miraclecookpot", {
            Ingredient("redgem", 4),
            Ingredient("base_moonrock_nugget", 5, atlas_base_moonrock_nugget),
        },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_miraclecookpot_placer", 2)
    building_miraclecookpot.atlas = "images/map_icons/miraclecookpot.xml"
    building_miraclecookpot.image = "miraclecookpot.tex"
    --映月台
    local building_moondial = Recipe("building_moondial", {
            Ingredient("base_moonglass", 1, atlas_base_moonglass),
            Ingredient("base_moonrock_nugget", 8, atlas_base_moonrock_nugget),
        },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_moondial_placer", 2)
    building_moondial.atlas = "images/map_icons/mapicon.xml"
    building_moondial.image = "moondial.tex"

    ---------------------【进阶】-------------------
    -----空间箱
    local building_roombox = Recipe("building_roombox", {
            Ingredient("base_polishgem", 1, atlas_base_polishgem),
            Ingredient("base_moonrock_nugget", 9), },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_gemicebox_placer", 2)
    building_roombox.atlas = "images/map_icons/mapicon.xml"
    building_roombox.image = "roombox.tex"
    --宝石冰箱
    local building_gemicebox = Recipe("building_gemicebox", {
            Ingredient("base_polishgem", 2, atlas_base_polishgem),
            Ingredient("bluegem", 8), },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_gemicebox_placer", 2)
    building_gemicebox.atlas = "images/map_icons/gemicebox.xml"
    building_gemicebox.image = "gemicebox.tex"
    --旅行者时空箱
    local building_travellerbox = Recipe("building_travellerbox", {
            Ingredient("base_moonempyreality", 4, atlas_base_moonempyreality),
            Ingredient("boards", 2),
            Ingredient("orangegem", 2), },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_travellerbox_placer", 2)
    building_travellerbox.atlas = "images/map_icons/travellerbox.xml"
    building_travellerbox.image = "travellerbox.tex"
    --永恒魔术灯
    local building_immortallight = Recipe("building_immortallight", {
            Ingredient("base_puregem", 2, atlas_base_puregem),
            Ingredient("base_moonrock_nugget", 10, atlas_base_moonrock_nugget),
            Ingredient("base_gemblock", 2, atlas_base_gemblock), },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_immortallight_placer", 2)
    building_immortallight.atlas = "images/map_icons/immortallight.xml"
    building_immortallight.image = "immortallight.tex"
    --宝石发生器
    local building_gemgenerator = Recipe("building_gemgenerator", {
            Ingredient("livinglog", 10),
            Ingredient("base_gemblock", 1, atlas_base_gemblock),
            Ingredient("base_horrorfuel", 2, atlas_base_horrorfuel), },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_gemgenerator_placer", 2)
    building_gemgenerator.atlas = "images/map_icons/gemgenerator.xml"
    building_gemgenerator.image = "gemgenerator.tex"
    --空间锚定仪
    local building_spatialanchor = Recipe("building_spatialanchor", {
            Ingredient("base_polishgem", 1, atlas_base_polishgem),
            Ingredient("orangegem", 1),
            Ingredient("base_moonrock_nugget", 10, atlas_base_moonrock_nugget),
        },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_spatialanchor_placer", 2)
    building_spatialanchor.atlas = "images/map_icons/spatialanchor.xml"
    building_spatialanchor.image = "spatialanchor.tex"

    --魔术炮塔
    local building_guard = Recipe("building_guard", {
            Ingredient("base_puregem", 1, atlas_base_puregem),
            Ingredient("base_moonrock_nugget", 20, atlas_base_moonrock_nugget),
        },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_guard_placer", 2)
    building_guard.atlas = "images/map_icons/guard.xml"
    building_guard.image = "guard.tex"
    --Infinitas箱
    local building_infinitas = Recipe("building_infinitas", {
            Ingredient("base_moonglass", 5, atlas_base_moonglass),
            Ingredient("base_gemblock", 1, atlas_base_gemblock),
        },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_infinitas_placer", 2)
    building_infinitas.atlas = "images/map_icons/mapicon.xml"
    building_infinitas.image = "infinitas.tex"
    --腐败滋生术式
    local building_rottenform = Recipe("building_rottenform", {
            Ingredient("base_gemblock", 1, atlas_base_gemblock),
            Ingredient("base_horrorfuel", 5, atlas_base_horrorfuel),
        },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_rottenform_placer", 2)
    building_rottenform.atlas = "images/map_icons/rottenform.xml"
    building_rottenform.image = "rottenform.tex"

    ---------------------【灵化】-------------------
    --灵液
    local psionic_liquid = Recipe("psionic_liquid", {
            Ingredient("meat", 1),
            Ingredient("nightmarefuel", 2),
        },
        RECIPETABS.MOONMAGIC, TECH.NONE, nil)
    psionic_liquid.atlas = "images/inventoryimages/psionic_liquid.xml"
    psionic_liquid.image = "psionic_liquid.tex"

    --灵化农场
    local psionic_farm = Recipe("building_psionic_farm", {
            Ingredient("cutstone", 4),
            Ingredient("psionic_soil", 3, atlas_psionic_soil),
        },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_psionic_farm_placer", 2)
    psionic_farm.atlas = "images/map_icons/building_psionic_farm.xml"
    psionic_farm.image = "building_psionic_farm.tex"

    --灵化土壤
    local psionic_farm = Recipe("psionic_soil", {
            Ingredient("psionic_liquid", 1, atlas_psionic_liquid),
            Ingredient("psionic_norsoil", 1, atlas_psionic_norsoil),
        },
        RECIPETABS.MOONMAGIC, TECH.NONE)
    psionic_farm.atlas = "images/inventoryimages/psionic_soil.xml"
    psionic_farm.image = "psionic_soil.tex"

    --灵化种子
    local psionic_moonseed = Recipe("psionic_moonseed", {
            Ingredient("seeds", 1),
            Ingredient("psionic_liquid", 1, atlas_psionic_liquid),
        },
        RECIPETABS.MOONMAGIC, TECH.NONE)
    psionic_moonseed.atlas = "images/inventoryimages/psionic_moonseed.xml"
    psionic_moonseed.image = "psionic_moonseed.tex"

    --洗涤水
    local potion_holywater = Recipe("potion_holywater", {
            Ingredient("base_moonglass", 1, atlas_base_moonglass),
            Ingredient("psionic_holypetal", 1, atlas_psionic_holypetal),
        },
        RECIPETABS.MOONMAGIC, TECH.NONE)
    potion_holywater.atlas = "images/inventoryimages/potion_holywater.xml"
    potion_holywater.image = "potion_holywater.tex"

    ----------------------【底部饰品】-------------------
    --献祭小刀
    local trinket_sacrificeknife = Recipe("trinket_sacrificeknife", {
            Ingredient("petals", 5),
            Ingredient("goldnugget", 2),
            Ingredient("twigs", 2),
        },
        RECIPETABS.MOONMAGIC, TECH.NONE, nil)
    trinket_sacrificeknife.atlas = "images/inventoryimages/sacrificeknife.xml"
    trinket_sacrificeknife.image = "sacrificeknife.tex"
end

local fn = function(inst)
    -- choose which sounds this character will play
    inst.soundsname = "willow"

    --栏目表
    RECIPETABS.MOONMAGIC =
    {
        str = 'MOONMAGIC',
        sort = 12,
        priority = 4,
        icon = "arcueid_moshuTAB.tex",
        icon_atlas = "images/arcueid_moshuTAB.xml",
        crafting_station = true,
        modname = "月之魔术"
    }

    --添加人物专属配方
    arcueid_recipes()

    -- 本人de地图图标
    inst.MiniMapEntity:SetIcon("arcueid.tex")

    -- 三维数值	
    inst.components.health:SetMaxHealth(150)
    inst.components.hunger:SetMax(125)
    inst.components.sanity:SetMax(250)

    -- 默认伤害
    inst.components.combat.damagemultiplier = TUNING.ARCUEID_DAY_DAMAGEMULTIPLIER

    -- 饥饿速率
    inst.components.hunger.hungerrate = TUNING.ARCUEID_HUNGER_RATE

    -- 行走速度(初始)
    inst.components.locomotor.walkspeed = 4
    inst.components.locomotor.runspeed = 6

    --制作倍率（改回1倍）
    inst.components.builder.ingredientmod = 1

    --添加活力值组件
    inst:AddComponent("vigour")
    inst.components.vigour:SetMaxVigour(TUNING.ARCUEID_MAXVIGOUR)

    --测试动作组件
    inst:AddComponent("arcueid_equip")

    --储存一些即时状态
    inst:AddComponent("arcueidstate")

    --人物标签
    inst:AddTag("arcueid")

    --添加buff
    inst:AddComponent("arcueidbuff")

    --影潮世界
    GetWorld():AddComponent("darkwave")

    updatepower(inst)
    inst:ListenForEvent("vigour_change", function() updatepower(inst) end, GetWorld())
    -- 击杀奖励
    inst:ListenForEvent("killed", function(inst, data)
        if inst.prefab == "arcueid"
            and data.victim
            and data.victim:HasTag("monster")
        then
            local dice1 = math.random(99999999)
            local dice2 = math.random(99999999)
            --献祭小刀奖励
            if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET)
            and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_sacrificeknife" 
            then
                if dice1 % 100 + 1 <= 33 then
                    inst.components.inventory:GiveItem(SpawnPrefab("base_moonglass"))
                end

                if dice2 % 100 + 1 <= 5 then
                    inst.components.inventory:GiveItem(SpawnPrefab("arcueid_consume_luckybag"))
                end
            end
            --一般击杀奖励
            if TUNING.SHADOWCREATURE[data.victim.prefab] then
                inst.components.vigour:DoDelta(20,inst,"KILLSHADOW")
            end
        end
    end, inst)

    local adjust = 0
    local curtrinket

    --借sanitydelta更新一些状态
    inst:ListenForEvent("sanitydelta", function()
        --酸雨扣血临时先写在这里
        if inst.components.arcueidstate:GetErosionPercent() >= .5 then
            if inst.components.moisture:GetMoistureRate() > 0 then
                inst.components.health:DoDelta(-0.2 * 0.03)
            end
        end


        inst.components.health:DoDelta(0)
        curtrinket = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET)
        --简陋的冷却系统
        if curtrinket ~= nil
            and curtrinket.prefab == "trinket_icecrystal" then
            curtrinket.components.finiteuses:SetUses(100 -
                math.floor((inst.components.arcueidstate.iceskill_cooldown / TUNING.ICESKILL_COOLDOWN) *
                    100 + 1))
        end

        --dress_ice会掉出来发光，治个标先
        adjust = adjust + 0.2
        if adjust > 1 then
            local x, y, z = inst:GetPosition():Get()
            local ents = TheSim:FindEntities(x, y, z, 5, nil, { "player", "arcueid" })
            for _, item in pairs(ents) do
                if item.prefab == "dress_ice" or item.prefab == "sharpclaw" then
                    if not item.components.equippable.isequipped then
                        item:Remove()
                    end
                end
            end
            adjust = 0
        end
    end, inst)

    --空手上爪
    inst:ListenForEvent("newcombattarget", function(inst, data)
        local weapon = inst.components.combat:GetWeapon()
        if not weapon
            and not (inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil
                and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab == "dress_ice") then
            weapon = SpawnPrefab("sharpclaw")
            inst.components.inventory:Equip(weapon)
        end
    end)
end

return MakePlayerCharacter("arcueid", prefabs, assets, fn, start_inv)
