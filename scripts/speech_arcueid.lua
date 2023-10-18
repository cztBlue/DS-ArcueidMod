return 
{
    -- 检查物品的表述
    DESCRIBE={
        --原版对话部分重制
        CUTGRASS = "摸起来软软的。", --草
        GASMASKHAT = "我不做人人啦!哈..哈..哈.. 好无聊。",--防毒面具
        LIVINGJUNGLETREE = "我觉得这种树突然说起话也是完全不奇怪的。", --普普通通的丛林树
        --LIVINGJUNGLETREE = "我觉得可以和它聊聊。", --普普通通的丛林树
        LIVINGTREE = "千万不要把尸体留在这邪恶的树下面。", --完全正常的树
        FLOWER_EVIL = "哈，好丑的花。", --邪恶花
        TWIGS = "弄的好像不是很整齐。", --树枝
        FLINT = "我搞不懂为什么要把它带在身上。", --燧石
        SILK = "bui~bui~", --蜘蛛丝
        DECIDUOUS_ROOT = "白桦树下刻着两个人的名字♪\n他们发誓相爱用尽这一生♪",
        DECIDUOUSTREE = "白桦树下刻着两个人的名字♪\n他们发誓相爱用尽这一生♪",--桦树


        --mod物品
        FLOATBALL = "滑滑的,感觉有磁性。",
        SHARPCLAW = "别惹我,哼。",
        FAILEDDISH = "最好碰都别碰！",
        SUCCESSDISH = "感觉能吃。",
        DRESS_ICE = "卢恩符文-isa,\"冰\",\"动作停止\"。呵，神秘学还是那个女人擅长呢。",
        DRESS_PRINCESS = "啊,这个,我以前很常穿的。",
        ARCUEID_FAKEBEEBOX = "什么嘛,明明里面根本没有蜜蜂的。",

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
        BASE_MOONEMPYREALITY = "赋有轻清的灵质，不能朽坏。",
        BASE_GEMBLOCK = "完美的魔力载体。",

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
        BUILDING_SPATIALANCHOR = "不稳定的时空魔术，锚定和破开空间。",
        BUILDING_MIRACLECOOKPOT = "真正的魔法，就算是我也能在这里做出美味的食物。",
        BUILDING_GUARD = "看起来脾气不太好。",
        BUILDING_INFINITAS = "我先来：\"喂，出来。\"",
        BUILDING_RECYCLEFORM = "逆转术式，分解一些宝石和饰品",
        BUILDING_ROTTENFORM = "微型时间术式，间隙处可以加速时间。",
        BUILDING_GEMGENERATOR = "闪亮亮！",
        BUILDING_IMMORTALLIGHT = "可以驱散周围可恶的暗影。",
        BUILDING_TRAVELLERBOX = "要是把手伸进去会不会从另一边出来？",
        BUILDING_GEMICEBOX = "暂停时间！话说是不是有点大材小用了？",

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
        },
        

        -------------
        MOUND =
		{
			DUG = "真的对不起！",
			GENERIC = "我感觉下面可能会有各种各样的好东西。",
		},
    },
    -- 战斗
    BATTLECRY ={},
    --脱离战斗
    COMBAT_QUIT ={},

    ANNOUNCE_ENTER_DARK = "我感觉喘不过气",--视野变黑--"浓密的暗影压得我喘不过气"
    ANNOUNCE_ENTER_LIGHT = "感觉好多了",
    ANNOUNCE_CHARLIE = "谁在那里！？",
    ANNOUNCE_CHARLIE_ATTACK = "无礼之徒！"
}
