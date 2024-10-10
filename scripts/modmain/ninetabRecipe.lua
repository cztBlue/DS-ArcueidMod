--饰品配方（测试）
TUNING.ARCUEID_TRINKETRECIPES =
{
	--调料瓶 vm4
	["trinket_seasoningbottle"] =
	{ nil, "spoiled_food", nil, 
    "goldnugget", "spoiled_food","goldnugget",
	"base_moonrock_nugget", "spoiled_food", "base_moonrock_nugget" },
    --不灭烛 vm6
	["trinket_eternallight"] =
	{ nil, "nightmarefuel", nil, 
    "base_moonglass", "log","base_moonglass",
	"base_moonglass", "goldnugget", "base_moonglass" },
	--休憩之书 vm15
	["trinket_relaxationbook"] =
	{ "base_moonrock_nugget", "greengem", "base_moonrock_nugget", 
    "base_moonempyreality", "papyrus","base_moonempyreality",
	"base_moonrock_nugget", "greengem", "base_moonrock_nugget" },
	--先知之眼 vm21
	["trinket_propheteye"] =
	{ "goldnugget", "goldnugget", "goldnugget", 
    "pigskin", "base_puremoonempyreality","silk",
	nil, "meat", nil },
	--十二面骰子 vm37 + vg120
	["trinket_twelvedice"] =
	{ "cutstone", "cutstone", "cutstone", 
    "goldnugget", "base_puremoonempyreality","goldnugget",
	"base_horrorfuel", "base_polishgem", "base_horrorfuel" },
	--瓶中灵 vg30 + vm6
	["trinket_spiritbottle"] =
	{ "base_moonglass", "livinglog", "base_moonglass", 
    "livinglog", "base_gemblock","livinglog",
	"base_moonglass", "livinglog", "base_moonglass" },
	--赴死者勋 vm25 + vg60
	["trinket_martyrseal"] =
	{ "redgem", "fabric", "redgem", 
    "fabric", "base_puremoonempyreality","fabric",
	"base_gemblock", "fabric", "base_gemblock" },
	--立冬 vm110 + vg480
	["trinket_icecrystal"] =
	{ "ice", "bluegem", "ice", 
    "base_moonglass", "base_puregem","base_moonglass",
	"ice", "dragon_scales", "ice" },
	--翡翠星星 vm42 + vg120
	["trinket_jadestar"] =
	{ "base_horrorfuel", "rope", "base_horrorfuel", 
    "spoiled_food", "base_polishgem","spoiled_food",
	"base_puremoonempyreality", "greengem", "base_puremoonempyreality" },
	--翡翠之刃 vm6 +vg60
	["trinket_jadeblade"] =
	{ nil, "base_gemblock", nil, 
    "base_moonglass", "spoiled_food","base_moonglass",
	nil, "greengem", nil },
	--第一圣典 vm 46 +vg 60
	["trinket_firstcanon"] = 
	{ nil, "base_puremoonempyreality", nil, 
    "base_gemblock", "papyrus","base_gemblock",
	nil, "base_puremoonempyreality", nil },
    --阴影斗篷 vm108 +vg480
	["trinket_shadowcloak"] = 
	{ "base_horrorfuel", "base_horrorfuel", "base_horrorfuel", 
    "fabric", "minotaurhorn","fabric",
	"base_horrorfuel", "base_puregem", "base_horrorfuel" },
}

--炼金配方（测试）
TUNING.ARCUEID_ALCHEMYRECIPES =
{
	--宝石块
	["base_gemblock"] =
	{ "base_gemfragment", "base_moonglass", "base_gemfragment", 
    "base_gemfragment", "goldnugget","base_gemfragment",
	"base_gemfragment", "base_moonglass", "base_gemfragment" },
	--打磨宝石
	["base_polishgem"] =
	{ "base_gemblock", "base_moonglass", "base_gemblock", 
    "base_moonempyreality", "trinket_sacrificeknife","base_moonempyreality",
	"base_gemblock", "base_moonglass", "base_gemblock" },
	--纯粹宝石
	["base_puregem"] = 
	{ "base_polishgem", "base_moonglass", "base_polishgem", 
    "base_puremoonempyreality", "trinket_sacrificeknife","base_puremoonempyreality",
	"base_polishgem", "base_moonglass", "base_polishgem" },
	--精粹月质
	["base_puremoonempyreality"] = 
	{ "base_moonempyreality", "base_moonempyreality", "base_moonempyreality", 
    "base_moonempyreality", "trinket_sacrificeknife","base_moonempyreality",
	"base_moonempyreality", "base_horrorfuel", "base_moonempyreality" },
}

--九格食谱:
TUNING.ARCUEID_FOODRECIPES = 
{
	--浆果蛋糕（浆果，羊奶，蛋，冰）-高
	["arcueid_food_berrycake"] = 
	{nil,"berries",nil,	
	"goatmilk","trinket_seasoningbottle","bird_egg",	
	nil,"ice",nil},

	--蛋包饭（高脚鸟蛋，蛋，花，肉）-中
	["arcueid_food_omeletterice"] = 
	{nil,"bird_egg",nil,	
	"petals","trinket_seasoningbottle","meat",	
	nil,"tallbirdegg",nil},

	--章鱼烧（鸟蛋，死水母，死水母,树枝)-中
	["arcueid_food_takoyaki"] = 
	{nil,"bird_egg",nil,		
	"jellyfish_dead","trinket_seasoningbottle","jellyfish_dead",		
	nil,"twigs",nil},

	--豆腐汤（南瓜，蓝蘑菇，硝石，冰）-低
	["arcueid_food_tofusoup"] = 
	{nil,"pumpkin",nil,		
	"blue_cap","trinket_seasoningbottle","nitre",		
	nil,"ice",nil},

	--虾仁炒饭(虾，帽贝，冰，小肉)-中
	["arcueid_food_shrimpfriedrice"] = 
	{nil,"lobster_dead",nil,		"limpets","trinket_seasoningbottle","cookedsmallmeat",		nil,"ice",nil},
	
	--三明治(玉米，蛋，萝卜，肉干)-中高
	["arcueid_food_sandwich"] = {nil,"corn",nil,		"bird_egg","trinket_seasoningbottle","carrot",		nil,"meat_dried",nil},
	
	--泡芙(红薯,蛋,蛋,花瓣)-中低
	["arcueid_food_puff"] = {nil,"sweet_potato",nil,		"bird_egg","trinket_seasoningbottle","bird_egg",		nil,"petals",nil},
	
	--辣椒酱-配
	["arcueid_food_piri"] = 
	{nil,nil,nil,		
	"arcueid_food_pepper","trinket_seasoningbottle","arcueid_food_pepper",		
	nil,nil,nil},
	
	-- --辣椒
	-- ["arcueid_food_pepper"] = 
	-- {nil,nil,nil,nil,
	-- "trinket_seasoningbottle",
	-- nil,nil,nil,nil},
	
	--杂炖鲜汤(豆腐汤，肉，高鸟蛋，冰)-高
	["arcueid_food_mixedsoup"] = 
	{nil,"arcueid_food_tofusoup",nil,		
	"meat","trinket_seasoningbottle","tallbirdegg",		
	nil,"ice",nil},

	--番茄酱-配
	--["arcueid_food_ketchup"] = 
	-- {nil,nil,nil,nil,
	-- "trinket_seasoningbottle",
	-- nil,nil,nil,nil},
	
	--热狗 (小肉,浆果)（小）E
	["arcueid_food_hotdog"] = 
	{nil,nil,nil,		
	"smallmeat","trinket_seasoningbottle","berries",		
	nil,nil,nil},
	
	--甜甜圈(西瓜，小肉，玉米，咖啡豆)中高
	["arcueid_food_doughnut"] = 
	{nil,"watermelon",nil,		
	"smallmeat","trinket_seasoningbottle","coffeebeans",		
	nil,"corn",nil},
	
	--奶油蜂蜜切饼(蜂蜜，羊奶，蛋，玉米)高
	["arcueid_food_creamhoneycut"] = 
	{nil,"honey",nil,		
	"goatmilk","trinket_seasoningbottle","bird_egg",		
	nil,"corn",nil},
	
	--巧克力曲奇（咖啡豆,蜂蜜,蜂蜜,烤仙人掌）中高
	["arcueid_food_chocolatecookies"] = 
	{nil,"coffeebeans",nil,		
	"honey","trinket_seasoningbottle","honey",		
	nil,"cactus_meat_cooked",nil},
	
	--浆果蛋挞（浆果，蜂蜜，蛋，蛋）中
	["arcueid_food_berryeggtart"] = 
	{nil,"berries",nil,		
	"bird_egg","trinket_seasoningbottle","bird_egg",		
	nil,"honey",nil},
}