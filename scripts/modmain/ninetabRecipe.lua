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
	"yellowgem", "base_puremoonempyreality", "yellowgem" },
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