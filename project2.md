## 人物特性 
- 四维：饱食125，精神250，生命150，活力值360 ✓  
- 可以利用利爪攻击，基础伤害60 ✓
- buff：
- 公主病：不能吃生食，非烹制食物效果 * 0.6  
- 衰败的肉体：不能通过食物快速回速率：80/480s（回血栈上限100点），受重伤（单次受到-40点的伤害）会造成速率 -200/480s（共50%受到伤害的流血，流血栈350），爪子消耗活力值3/v,  饥饿速率*1.25 ✓
- 哀戚的魂灵：对中立生物伤害 *0.5，对敌对生物伤害*0.75  ✓
召唤小精灵填充debuff
- 笨拙的心：ARC不能解锁配方，必须在工作站附近制作，任何食物有概率油腻焦湿，烤东西有概率烤糊 ✓
- 月球生物：白天降低数值，夜晚略微回复san值和活力值，攻击，移速和月相，活力值，时间段挂钩：黄昏和傍晚有特殊增幅，越接近满月，增幅越大，活力值低于70%以后，攻击/移速和活力值比较力直接挂钩 ✓
- 暗处的注视：影怪的更强（受到统治者的制裁）
- 太阳灼烧：ARC在正午按一定比例掉血-
- 渴血（轻中重）：需要通过杀死中立生物来缓解，轻-掉san，中-掉san掉血，重-（你崩溃了）心跳声，开始拆家，爆装备。  
- 能力：  
把活力值转化为血量。    ✓
把活力值转化为san。    ✓
把活力值转化为饥饿值。   ✓ 


# 流程：
1. 开局有一堆debuff，顶住debuff活下来，收集精灵消除debuff  
精灵：  
- 红：渴血
- 黄：公主病
- 绿：哀戚的魂灵

2. 维护活力值
- 白天自然消耗  
- 饰品消耗  
- 任何食物维护  
- 杀死影怪回复  
- 晚上自然恢复（自然恢复 > 自然消耗）
- 饰品恢复  

3. 收集饰品
- 收集宝石
- 收集水晶

4. 种田
- 水晶种子种水晶
- 获取魔法材料做药水

5. 抵御自然
- 建筑抵御

# 数值设计：
【建筑】  
[基建类]✓  
具现原理————冰*3 水晶*5 蓝宝石 *1  
第二分解术式————月亮水晶*5 蓝宝石 *2 红宝石*2  
饰品作坊————水晶*2 木板*4 金块*2  
炼金台————活木*4 水晶*3  
映月台————水晶*1 月岩*8  
奇迹煮锅————红宝石*4 月岩*5  
[进阶类]  
空间箱———— 打磨宝石*1 月岩*9  
旅行者的时空箱————  
宝石冰箱————  
宝石发生器————  
永恒魔术灯————  
空间锚定仪————  
魔术守卫————  
Infinitas箱————  
腐败滋生术式————  

【食物】  
[基础食物]
蛋包饭: 回复四维(22,22,22,46)buff:画饼  
豆腐汤: 回复四维(7,7,7,14)buff:无  
浆果蛋糕: 回复四维(40,40,40,90)buff:恢复  
章鱼烧: 回复四维(22,22,22,46)buff:画饼  
虾仁炒饭: 回复四维(22,22,22,46)buff:光环  
三明治: 回复四维(27,27,27,57)buff:画饼  
[进阶食物]  
泡芙: 回复四维(18,18,18,36)buff:振奋  
杂炖鲜汤: 回复四维(40,40,40,90)buff:光环,恢复  
热狗: 回复四维(7,7,7,14)buff:休憩(小)  
甜甜圈: 回复四维(27,27,27,57)buff:休憩  
奶油蜂蜜切饼: 回复四维(40,40,40,90)buff:回复  
巧克力曲奇: 回复四维(27,27,27,57)buff:回复  
浆果蛋挞: 回复四维(22,22,22,46)buff:振奋 

【材料】  
vg->宝石量 vm->月质量  
<蓝/紫宝石> vg 1 （未改动）  
宝石碎片 vg 5  
<月亮水晶> vm 1  
弥散月质 vm 3  
精粹月质 vm 21  
宝石块 vg 30 + vm 2   
打磨宝石 vg 120 + vm 16  
纯粹宝石 vg 480 + vm 108  
纯粹恐惧   

【药水】    
洗涤水  

【饰品】  
[基础饰品]   
不灭烛  
调料瓶  
休憩之书  
瓶中灵  
十二面骰子  
翡翠星星  
[进阶饰品]  
先知之眼  
月光斗篷  
第一圣典  
阴影斗篷  
月亮吊坠  
月亮护腕  
月亮指环  
冰晶  
翡翠之刃  
赴死者勋 

 


# 各种优化/重做
- 打影怪掉水晶 ✓  
- 映月台"概率"把石头转化成月岩，遂石转化为水晶 ✓
- 献祭匕首杀怪奖励水晶(每次击杀1/3概率给予) ✓
- 击杀怪物不再掉落饰品 ✓
- 宝石发生器产生宝石 ✓  
【机制————产出到箱子里 消耗燃料和石头（大理石，岩石，燧石，硝石，金块，冰块） 
有两个燃料条：暗影条，月化条(200%)
骰子(激活)可以让两条数值翻转
用暗影燃料，恐惧填充，后者水晶，月粹
(暗影条+月化条)>60% 开始产出
暗影条>月化条 产出紫宝石
暗影条<月化条 产出稀有宝石（6%）
暗影条50%>+月化条>70% 产出宝石碎片(20%) 宝石块（10%）】
- 所有食物都可以一定程度恢复活力值(1/10饱食度) ✓
- 睡眠可以恢复活力值 ✓
- 杀死暗影生物可以恢复活力值 (20/只) ✓
- 饱食度>100可以按一定速率恢复活力值（buff吃饱了）✓
- 保持理智可以降低侵蚀度 ✓
- 打怪有概率奖励福袋，打开随机掉落一件基础饰品 ✓
- UI完善 ✓
- 火光机制：挂钩侵蚀 ✓
- 覆盖组件隐藏 ✓  
【builder-OK clock-OK container-OK stewer-OK】
- 删除信件 ✓
- 隐藏礼装功能 ✓ 
- 消耗性饰品机制 ✓  
【调料瓶-OK 骰子-OK】
- 添加公主buff/debuff ✓
【公主病-OK 衰败的肉体-OK 哀戚的魂灵-OK 笨拙的心-OK 月球生物-OK 】  
- 种植系统完善  ✓
【处理干净代码-OK grower_psionic-OK plantable_psionic-OK psionic_farm-OK】  
- 添加一些bufficon1 ✓  
- 贴图修正 ✓  
【建筑阴影-✓ 建筑小地图标-✓ 建筑图标对应-✓ 农场贴图-✓ 物品阴影-✓ 公主遮蔽的后发-✓】
- 添加肉体升变仪式原型 corpuselevatiotoolkit ✓
- 长按手感优化 ✓
- 转化能力 ✓
【硬直- ✓ 活力转生命-✓ 活力转理智- ✓饥饿转活力-✓ 】

- 添加基础药水(原型) ✓
【红药水-✓ 蓝药水-✓ 抵抗药水-✓ 暴击药水-✓ 吸血药水-✓ 圣水-✓】  
- bug修复：
哀戚的魂灵-118崩溃 ✓
大肉放在映月台 ✓
- 重做时段数值注入 ✓
- 饰品效果优化
翡翠之刃斩击特效 ✓
翡翠星星点伤 
- BGM试做 ×
- 集成新怪物   
【三基佬-✓ 一个巢穴-✓ 食人花生成机制-✓】
- D25xn(考验)  
- 侵蚀条重做   
- 添加基础药水(配方描述) 
【红药水- 蓝药水- 抵抗药水- 暴击药水- 吸血药水- 圣水-】  
- 翡翠之刃限制
- 恐慌机制
- 肉体升变
- 图鉴UI
【太阳灼烧- 渴血- 】
- 调整具现原理科技等级
- 充能网络
【1.某些设施只有在充能地皮上可以正常运转 - 
2.充能地皮会给相邻的未充能激活，使它变成充能地皮 - 
3.充能设施可以给当前地皮充能，多个充能设施何以组成网络 - 】
- 覆盖组件隐藏2   
【health- perishable-】 




