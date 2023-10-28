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

local start_inv = {
}

--监视时间改变伤害
--满月无敌+高速+活力buff
--伤害和速度与活力,时间，月相挂钩
local function updatepower(inst)
    local timestr
    local Isbelow70per
    local Isbelow35per
    local moon = GetClock():GetMoonPhase()



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
        inst.components.combat:AddDamageModifier(string.lower(timestr) .. "_damage",
            TUNING["ARCUEID_" .. timestr .. "_DAMAGEMULTIPLIER"])
        inst.components.locomotor.walkspeed = TUNING["ARCUEID_" .. timestr .. "_WALKSPEED"]
        inst.components.locomotor.runspeed = TUNING["ARCUEID_" .. timestr .. "_RUNSPEED"]
        return
    elseif Isbelow70per == true and Isbelow35per == false then
        inst.components.combat:AddDamageModifier(string.lower(timestr) .. "_damage",
            TUNING["ARCUEID_" .. timestr .. "_DAMAGEMULTIPLIER"] * (inst.components.vigour.currentvigour / 252))
        inst.components.locomotor.walkspeed = TUNING["ARCUEID_" .. timestr .. "_WALKSPEED"] *
            (inst.components.vigour.currentvigour / 252)
        inst.components.locomotor.runspeed = TUNING["ARCUEID_" .. timestr .. "_RUNSPEED"] *
            (inst.components.vigour.currentvigour / 252)
        return
    elseif Isbelow70per == true and Isbelow35per == true then
        inst.components.combat:AddDamageModifier(string.lower(timestr) .. "_damage",
            TUNING["ARCUEID_" .. timestr .. "_DAMAGEMULTIPLIER"] * (inst.components.vigour.currentvigour / 252))
        inst.components.locomotor.walkspeed = TUNING["ARCUEID_" .. timestr .. "_WALKSPEED"] * 0.35
        inst.components.locomotor.runspeed = TUNING["ARCUEID_" .. timestr .. "_RUNSPEED"] * 0.35
        return
    end

    if inst.components.arcueidstate.careful == true then
        inst.components.locomotor.walkspeed = inst.components.locomotor.walkspeed * TUNING.ARCUEID_SNEAKYMULTIPLIER
        inst.components.locomotor.runspeed = inst.components.locomotor.runspeed * TUNING.ARCUEID_SNEAKYMULTIPLIER
    end

    if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET) and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.TRINKET).prefab == "trinket_relaxationbook" then
        inst.components.locomotor.walkspeed = 0.6 * inst.components.locomotor.walkspeed
        inst.components.locomotor.runspeed = 0.6 * inst.components.locomotor.runspeed
        inst.components.combat:AddDamageModifier("relaxationbook_damage", 0.5)
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

    --宝石块
    local base_gemblock = Recipe("base_gemblock", {
            Ingredient("base_gemfragment", 6, atlas_base_gemfragment),
            Ingredient("base_moonglass", 3, atlas_base_moonglass),
            Ingredient("thulecite", 1),
        },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil)
    base_gemblock.atlas = "images/inventoryimages/gemblock.xml"
    base_gemblock.image = "gemblock.tex"

    --纯粹宝石
    local base_puregem = Recipe("base_puregem", {
            Ingredient("base_gemblock", 4, atlas_base_gemblock),
            Ingredient("base_moonempyreality", 3, atlas_base_moonempyreality), },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil)
    base_puregem.atlas = "images/inventoryimages/puregem.xml"
    base_puregem.image = "puregem.tex"

    --具现原理
    local building_mooncirleform = Recipe("building_mooncirleform", {
            Ingredient("base_moonglass", 8, atlas_base_moonglass),
            Ingredient("ice", 5), Ingredient("bluegem", 5) },
        RECIPETABS.MOONMAGIC, TECH.MAGIC_THREE, nil, "building_mooncirleform_placer", 2)
    building_mooncirleform.atlas = "images/map_icons/mooncirleform.xml"
    building_mooncirleform.image = "mooncirleform.tex"
    --第二分解术式
    local building_recycleform = Recipe("building_recycleform", {
            Ingredient("base_moonglass", 5, atlas_base_moonglass), Ingredient("redgem", 5),
            Ingredient("thulecite", 5) },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_recycleform_placer", 2)
    building_recycleform.atlas = "images/map_icons/recycleform.xml"
    building_recycleform.image = "recycleform.tex"
    --宝石冰箱
    local building_gemicebox = Recipe("building_gemicebox", {
            Ingredient("base_gemblock", 2, atlas_base_gemblock),
            Ingredient("bluegem", 7), },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_gemicebox_placer", 2)
    building_gemicebox.atlas = "images/map_icons/gemicebox.xml"
    building_gemicebox.image = "gemicebox.tex"
    --旅行者时空箱
    local building_travellerbox = Recipe("building_travellerbox", {
            Ingredient("base_moonempyreality", 4, atlas_base_moonempyreality), Ingredient("boards", 2),
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
            Ingredient("base_puregem", 1, atlas_base_puregem),
            Ingredient("base_horrorfuel", 7, atlas_base_horrorfuel), },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_gemgenerator_placer", 2)
    building_gemgenerator.atlas = "images/map_icons/gemgenerator.xml"
    building_gemgenerator.image = "gemgenerator.tex"
    --空间锚定仪
    local building_spatialanchor = Recipe("building_spatialanchor", {
            Ingredient("base_puregem", 1, atlas_base_puregem),
            Ingredient("orangegem", 1),
            Ingredient("base_gemblock", 2, atlas_base_gemblock),
        },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_spatialanchor_placer", 2)
    building_spatialanchor.atlas = "images/map_icons/spatialanchor.xml"
    building_spatialanchor.image = "spatialanchor.tex"
    --奇迹煮锅
    local building_miraclecookpot = Recipe("building_miraclecookpot", {
            Ingredient("base_gemblock", 4, atlas_base_gemblock),
            Ingredient("base_moonrock_nugget", 5, atlas_base_moonrock_nugget),
            Ingredient("redgem", 5),
        },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_miraclecookpot_placer", 2)
    building_miraclecookpot.atlas = "images/map_icons/miraclecookpot.xml"
    building_miraclecookpot.image = "miraclecookpot.tex"
    --魔术炮塔
    local building_guard = Recipe("building_guard", {
            Ingredient("base_puregem", 4, atlas_base_puregem),
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
    building_infinitas.atlas = "images/map_icons/infinitas.xml"
    building_infinitas.image = "infinitas.tex"
    --腐败滋生术式
    local building_rottenform = Recipe("building_rottenform", { 
        Ingredient("base_gemblock", 1, atlas_base_gemblock), 
        Ingredient("base_horrorfuel", 5, atlas_base_horrorfuel), 
    },
        RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil, "building_rottenform_placer", 2)
    building_rottenform.atlas = "images/map_icons/rottenform.xml"
    building_rottenform.image = "rottenform.tex"

    ---------------------饰品----------------------

    -- --休憩之书
    -- local trinket_relaxationbook = Recipe("trinket_relaxationbook",
    --     { Ingredient("base_moonglass", 10, atlas_base_moonglass) },
    --     RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil)
    -- trinket_relaxationbook.atlas = "images/inventoryimages/relaxationbook.xml"
    -- trinket_relaxationbook.image = "relaxationbook.tex"
    -- --先知之眼
    -- local trinket_propheteye = Recipe("trinket_propheteye", { Ingredient("base_moonglass", 36, atlas_base_moonglass) },
    --     RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil)
    -- trinket_propheteye.atlas = "images/inventoryimages/propheteye.xml"
    -- trinket_propheteye.image = "propheteye.tex"
    -- --十二面骰子
    -- local trinket_twelvedice = Recipe("trinket_twelvedice", { Ingredient("base_moonglass", 16, atlas_base_moonglass) },
    --     RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil)
    -- trinket_twelvedice.atlas = "images/inventoryimages/twelvedice.xml"
    -- trinket_twelvedice.image = "twelvedice.tex"
    -- --瓶中灵
    -- local trinket_spiritbottle = Recipe("trinket_spiritbottle",
    --     { Ingredient("base_moonglass", 14, atlas_base_moonglass) },
    --     RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil)
    -- trinket_spiritbottle.atlas = "images/inventoryimages/spiritbottle.xml"
    -- trinket_spiritbottle.image = "spiritbottle.tex"
    -- --赴死者勋
    -- local trinket_martyrseal = Recipe("trinket_martyrseal",
    --     { Ingredient("base_moonglass", 40, atlas_base_moonglass) },
    --     RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil)
    -- trinket_martyrseal.atlas = "images/inventoryimages/martyrseal.xml"
    -- trinket_martyrseal.image = "martyrseal.tex"
    -- --翡翠之刃
    -- local trinket_jadeblade = Recipe("trinket_jadeblade", { Ingredient("base_moonglass", 34, atlas_base_moonglass) },
    --     RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil)
    -- trinket_jadeblade.atlas = "images/inventoryimages/jadeblade.xml"
    -- trinket_jadeblade.image = "jadeblade.tex"
    -- --第一圣典
    -- local trinket_firstcanon = Recipe("trinket_relaxationbook",
    --     { Ingredient("base_moonglass", 26, atlas_base_moonglass) },
    --     RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil)
    -- trinket_firstcanon.atlas = "images/inventoryimages/firstcanon.xml"
    -- trinket_firstcanon.image = "firstcanon.tex"
    -- --翡翠星星
    -- local trinket_jadestar = Recipe("trinket_jadestar", { Ingredient("base_moonglass", 17, atlas_base_moonglass) },
    --     RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil)
    -- trinket_jadestar.atlas = "images/inventoryimages/jadestar.xml"
    -- trinket_jadestar.image = "jadestar.tex"
    -- --立冬
    -- local trinket_icecrystal = Recipe("trinket_icecrystal", { Ingredient("base_moonglass", 50, atlas_base_moonglass) },
    --     RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil)
    -- trinket_icecrystal.atlas = "images/inventoryimages/icecrystal.xml"
    -- trinket_icecrystal.image = "icecrystal.tex"
    -- --调料瓶
    -- local trinket_seasoningbottle = Recipe("trinket_seasoningbottle",
    --     { Ingredient("base_moonglass", 10, atlas_base_moonglass) },
    --     RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil)
    -- trinket_seasoningbottle.atlas = "images/inventoryimages/seasoningbottle.xml"
    -- trinket_seasoningbottle.image = "seasoningbottle.tex"
    -- --阴影斗篷
    -- local trinket_shadowcloak = Recipe("trinket_shadowcloak", { Ingredient("base_moonglass", 50, atlas_base_moonglass) },
    --     RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil)
    -- trinket_shadowcloak.atlas = "images/inventoryimages/shadowcloak.xml"
    -- trinket_shadowcloak.image = "shadowcloak.tex"
    -- --不灭烛
    -- local trinket_eternallight = Recipe("trinket_eternallight", { Ingredient("base_moonglass", 8, atlas_base_moonglass) },
    --     RECIPETABS.MOONMAGIC, TECH.MOONMAGIC_ONE, nil)
    -- trinket_eternallight.atlas = "images/inventoryimages/eternallight.xml"
    -- trinket_eternallight.image = "eternallight.tex"
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

    --制作倍率(*比一般人笨)
    inst.components.builder.ingredientmod = 1.5

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

    updatepower(inst)
    -- inst:ListenForEvent("arrive", function() updatepower(inst) end, GetWorld())  --Sadly only SW and HAM having this
    inst:ListenForEvent("vigour_change", function() updatepower(inst) end, GetWorld())

    local adjust = 0
    --借助频繁的sanitydelta更新一些状态
    inst:ListenForEvent("sanitydelta", function()
        inst.components.vigour:OnUpdate()
        inst.components.arcueidstate:OnUpdate()
        inst.components.arcueidstate:OnCarefulStateUpdate()
        inst.components.health:DoDelta(0)

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

    -- debug
    -- inst:ListenForEvent( "dusktime", function()
    --  end , GetWorld())

    -- inst:ListenForEvent( "vigour_change", function()
    --     print(GetPlayer().components.vigour.currentvigour)
    --  end , GetWorld())
end

return MakePlayerCharacter("arcueid", prefabs, assets, fn, start_inv)
