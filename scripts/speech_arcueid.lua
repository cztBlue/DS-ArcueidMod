return
{
    -- 检查物品的表述
    DESCRIBE = {
        --原版对话部分重制
        CUTGRASS = "摸起来软软的。", --草
        GASMASKHAT = "我不做人人啦!哈..哈..哈.. 好无聊。", --防毒面具
        LIVINGJUNGLETREE = "我觉得这种树突然说起话也是完全不奇怪的。", --普普通通的丛林树
        --LIVINGJUNGLETREE = "我觉得可以和它聊聊。", --普普通通的丛林树
        LIVINGTREE = "千万不要把尸体留在这邪恶的树下面。", --完全正常的树
        FLOWER_EVIL = "哈，好丑的花。", --邪恶花
        TWIGS = "弄的好像不是很整齐。", --树枝
        FLINT = "我搞不懂为什么要把它带在身上。", --燧石
        SILK = "bui~bui~", --蜘蛛丝
        DECIDUOUS_ROOT = "白桦树下刻着两个人的名字♪\n他们发誓相爱用尽这一生♪",
        DECIDUOUSTREE = "白桦树下刻着两个人的名字♪\n他们发誓相爱用尽这一生♪", --桦树
        SAND = "呃，这沙子真粘手.", --沙子
        SEWING_KIT = "用它修补破损的东西",--针线包


        --mod物品
        FLOATBALL = "滑滑的,感觉有磁性。",
        SHARPCLAW = "别惹我,哼。",
        FAILEDDISH = "最好碰都别碰！",
        SUCCESSDISH = "感觉能吃。",
        DRESS_ICE = "。。。",
        DRESS_REDMOON = "。。。",
        DRESS_PRINCESS = "啊,这个,我以前很常穿的。",
        ARCUEID_FAKEBEEBOX = "什么嘛,明明里面根本没有蜜蜂的。",
        arcueid_letter_normal = "什么嘛,明明里面根本没有蜜蜂的。",
        ARCUEID_LETTER_NORMAL = "这是给我的吗!?",

        --饰品
        TRINKET_MOONCLOAK = "简直是上个世纪某些邪教徒的标配。",
        TRINKET_ETERNALLIGHT = "像鬼火。",
        TRINKET_SHADOWCLOAK = "感觉很适合某个杀人鬼。",
        TRINKET_MOONAMULET = "感觉这个不能随便乱丢。",
        TRINKET_SEASONINGBOTTLE = "有种令人毛骨悚然的气味...",
        TRINKET_ICECRYSTAL = "好凉凉！",
        TRINKET_JADESTAR = "啊，怎么有点腐臭味。",
        TRINKET_FIRSTCANON = "上面写着：\n\"起初，地是空虚混沌，渊面黑暗；神的灵运行在水面上\"",
        TRINKET_JADEBLADE = "这个可以觉醒替身吧？",
        TRINKET_MARTYRSEAL = "背后刻着：\n\"我于万物之中\"",
        TRINKET_SPIRITBOTTLE = "真相是萤火虫！",
        TRINKET_TWELVEDICE = "这个东西好无聊。",
        TRINKET_PROPHETEYE = "呃，捏起来软软的，有点恶心诶。",
        TRINKET_MOONWRISTBAND = "这不是玩具。",
        TRINKET_MOONRING = "感觉这个很重要。",

        --基础物品
        BASE_MOONGLASS = "蕴含着安静而可怕的力量。",
        BASE_GEMFRAGMENT = "碎开的宝石可塑性更强。",
        BASE_MOONROCK_NUGGET = "有趣的石头。",
        BASE_HORRORFUEL = "令人作呕的残渣。",
        BASE_PUREGEM = "魔术的结晶！",
        BASE_MOONEMPYREALITY = "空灵的呼吸。",
        BASE_GEMBLOCK = "完美的魔力载体。",
        BASE_PUREMOONEMPYREALITY = "赋有轻清的灵质，不能朽坏。",
        BASE_POLISHGEM = "磨得很平整。",

        --食物--
        ARCUEID_FOOD_BERRYCAKE = "闻起来甜甜的,好味。",
        ARCUEID_FOOD_TAKOYAKI = "嗯？这个是怎么做出来的？",
        ARCUEID_FOOD_TOFUSOUP = "啊咧,会不会有点太咸了?",
        ARCUEID_FOOD_OMELETTERICE = "我以前是不是吃过这个？",
        ARCUEID_FOOD_SHRIMPFRIEDRICE = "海的味道。",
        ARCUEID_FOOD_PUFF = "泡芙...",
        ARCUEID_FOOD_PIRI = "辣椒酱多多盐加倍。",
        ARCUEID_FOOD_PEPPER = "这是货真价实的红色恶魔果实。",
        ARCUEID_FOOD_MIXEDSOUP = "平平淡淡。",
        ARCUEID_FOOD_KETCHUP = "切记，番茄酱不能代替盐。",
        ARCUEID_FOOD_HOTDOG = "一顿匆匆忙忙的早餐。",
        ARCUEID_FOOD_DOUGHNUT = "甜吗？",
        ARCUEID_FOOD_CREAMHONEYCUT = "这叫\"布伦史塔德大人的优雅时刻\"。",
        ARCUEID_FOOD_CHOCOLATECOOKIES = "零食，好耶。",
        ARCUEID_FOOD_BERRYEGGTART = "做的有点太小了。",

        --建筑
        BUILDING_MOONCIRLEFORM = "具现能力模拟魔术回路，可以临时掌握一些魔术。",
        BUILDING_SPATIALANCHOR = "不稳定的时空魔术，锚定和爆破空间。",
        BUILDING_MIRACLECOOKPOT = "魔法厨具！",
        BUILDING_GUARD = "看起来脾气不太好。",
        BUILDING_INFINITAS = "我先来：\"喂，出来。\"",
        BUILDING_RECYCLEFORM = "逆转术式，分解一些宝石和饰品",
        BUILDING_ROTTENFORM = "微型时间术式，间隙处可以加速时间。",
        BUILDING_GEMGENERATOR = "闪亮亮！",
        BUILDING_IMMORTALLIGHT = "可以驱散周围可恶的暗影。",
        BUILDING_TRAVELLERBOX = "从这里把手伸进去会不会从另一边出来？",
        BUILDING_GEMICEBOX = "暂停时间！话说是不是有点大材小用了？",
        BUILDING_ALCHEMYDESK = "见习炼金师Brunestud是也。",
        BUILDING_TRINKETWORKSHOP = "一张破桌子。",
        BUILDING_MOONDIAL = "它的作用是集聚月光。",
        BUILDING_ROOMBOX= "能存很多东西。",

        --灵化
        BUILDING_PSIONIC_FARM = "周围散发着一股凉气。",
        PSIONIC_HOLYPETAL = "这个好香！",
        PSIONIC_SOIL = "闻起来有股怪味。",
        PSIONIC_NORSOIL = "脏兮兮的土块。",
        PSIONIC_LIQUID = "看起来好恶心。",
        POTION_HOLYWATER = "坏女人身上特有的香水味。",
        PSIONIC_MOONSEED = "是妙蛙种子。",
        POTION_THIRSTYFRUIT = "哇，好恶心。",
        PSIONIC_GORYPETAL = "看起来不要触碰为好。",

        --消耗品
        ARCUEID_CONSUME_LUCKYBAG = "里面会是什么呢？",

        --食物效果
        FOOD_EFFECT =
        {
            ARCUEID_FOOD_BERRYEGGTART = "回复四维\n(22,22,22,46)\nbuff:振奋",
            ARCUEID_FOOD_CHOCOLATECOOKIES = "回复四维\n(27,27,27,57)\nbuff:回复",
            ARCUEID_FOOD_CREAMHONEYCUT = "回复四维\n(40,40,40,90)\nbuff:回复",
            ARCUEID_FOOD_DOUGHNUT = "回复四维\n(27,27,27,57)\nbuff:休憩",
            ARCUEID_FOOD_HOTDOG = "回复四维\n(7,7,7,14)\nbuff:休憩(小)",
            ARCUEID_FOOD_KETCHUP = "回复四维\n(22,22,22,46)\nbuff:无",
            ARCUEID_FOOD_MIXEDSOUP = "回复四维\n(40,40,40,90)\nbuff:光环,恢复",
            ARCUEID_FOOD_PEPPER = "回复四维\n(22,22,22,46)\nbuff:无",
            ARCUEID_FOOD_PIRI = "回复四维\n(22,22,22,46)\nbuff:无",
            ARCUEID_FOOD_PUFF = "回复四维\n(18,18,18,36)\nbuff:振奋",
            ARCUEID_FOOD_SANDWICH = "回复四维\n(27,27,27,57)\nbuff:画饼",
            ARCUEID_FOOD_SHRIMPFRIEDRICE = "回复四维\n(22,22,22,46)\nbuff:光环",
            ARCUEID_FOOD_TAKOYAKI = "回复四维\n(22,22,22,46)\nbuff:画饼",
            ARCUEID_FOOD_BERRYCAKE = "回复四维\n(40,40,40,90)\nbuff:恢复",
            ARCUEID_FOOD_TOFUSOUP = "回复四维\n(7,7,7,14)\nbuff:无",
            ARCUEID_FOOD_OMELETTERICE = "回复四维\n(22,22,22,46)\nbuff:画饼",
        },

        --饰品效果
        TRINKET_EFFECT =
        {
            TRINKET_SEASONINGBOTTLE = "做饭用",
            TRINKET_ETERNALLIGHT = "缓慢的燃烧体力\n小小火苗将跟随你",
            TRINKET_SHADOWCLOAK = "按shift切换潜行\n用于进入险地",
            TRINKET_MOONCLOAK = "防热防水回活力\n月光庇护你",
            TRINKET_ICECRYSTAL = "礼装身缠冰河\n礼装后按x激发技能",
            TRINKET_JADESTAR = "装备后可以诱惑蜘蛛\n右键消耗活力解毒",
            TRINKET_MARTYRSEAL = "免疫一次致命伤害\n生成一个三秒的\n无敌护盾",
            TRINKET_SPIRITBOTTLE = "触摸后，小精灵\n给你一个祝福",
            TRINKET_PROPHETEYE = "洞察：30%触发暴击\n睿智：让你记性更好",
            TRINKET_RELAXATIONBOOK = "消耗饱食，回复状态。",
            TRINKET_JADEBLADE = "更高的伤害",
            TRINKET_FIRSTCANON = "按x消耗体力\n驱散低级暗影生物",
        },


        -------------
        MOUND =
        {
            DUG = "真的对不起！",
            GENERIC = "我感觉下面可能会有各种各样的好东西。",
        },
    },
    -- 战斗
    BATTLECRY = {},
    --脱离战斗
    COMBAT_QUIT = {},

    ANNOUNCE_ENTER_DARK = "我感觉喘不过气", --视野变黑--"浓密的暗影压得我喘不过气"
    ANNOUNCE_ENTER_LIGHT = "感觉好多了",
    ANNOUNCE_CHARLIE = "谁在那里！？",
    ANNOUNCE_CHARLIE_ATTACK = "无礼之徒！"
}
