require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/shadow_bishop.zip"),
	Asset("ANIM", "anim/shadow_bishop_fx.zip"),
	Asset("ANIM", "anim/shadow_bishop_upg_build.zip"),
	Asset("ANIM", "anim/shadow_knight.zip"),
	Asset("ANIM", "anim/shadow_knight_upg_build.zip"),
	Asset("ANIM", "anim/shadow_rook.zip"),
	Asset("ANIM", "anim/shadow_rook_upg_build.zip"),
}

local prefabs =
{
	"nightmarefuel",
	"base_shadowheart",
	"armor_sanity",
	"nightsword",
}

local sounds1 = 
{
	attack = "dontstarve/sanity/creature1/attack",
	attack_grunt = "dontstarve/sanity/creature1/attack_grunt",
	death = "dontstarve/sanity/creature1/die",
	idle = "dontstarve/sanity/creature1/idle",
	taunt = "dontstarve/sanity/creature1/taunt",
	appear = "dontstarve/sanity/creature1/appear",
	disappear = "dontstarve/sanity/creature1/dissappear",
}

local sounds2 = 
{
	attack = "dontstarve/sanity/creature2/attack",
	attack_grunt = "dontstarve/sanity/creature2/attack_grunt",
	death = "dontstarve/sanity/creature2/die",
	idle = "dontstarve/sanity/creature2/idle",
	taunt = "dontstarve/sanity/creature2/taunt",
	appear = "dontstarve/sanity/creature2/appear",
	disappear = "dontstarve/sanity/creature2/dissappear",
}

local function NormalRetarget(inst)
	local range = 15
	return FindEntity(inst, range, function(guy)
			return inst.components.combat:CanTarget(guy)
		end, nil, {"shadowchesspiece"}, {"character", "animal", "monster"})
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
        return dude:HasTag("shadowchesspiece")
               and not dude.components.health:IsDead()
    end, 10)
end

local function LeveUp(inst)	
	if inst.prefab == "arcueid_shadow_knight" or inst.prefab == "arcueid_shadow_knight_2" or inst.prefab == "arcueid_shadow_rook" or inst.prefab == "arcueid_shadow_rook_2" or inst.prefab == "arcueid_shadow_bishop" or inst.prefab == "arcueid_shadow_bishop_2" then
		inst.sg:GoToState("transform")
	end
	inst:DoTaskInTime(55*FRAMES,function()
		if inst.prefab == "arcueid_shadow_knight" then
			inst.Transform:SetScale(1.7, 1.7, 1.7)
			inst.components.health:SetMaxHealth(900)
			inst.AnimState:OverrideSymbol("arm",       "shadow_knight_upg_build", "arm1")
			inst.AnimState:OverrideSymbol("ear",       "shadow_knight_upg_build", "ear1")
			inst.AnimState:OverrideSymbol("face",      "shadow_knight_upg_build", "face1")
			inst.AnimState:OverrideSymbol("head",      "shadow_knight_upg_build", "head1")
			inst.AnimState:OverrideSymbol("leg_low",   "shadow_knight_upg_build", "leg_low1")
			inst.AnimState:OverrideSymbol("neck",      "shadow_knight_upg_build", "neck1")
			inst.AnimState:OverrideSymbol("spring",    "shadow_knight_upg_build", "spring1")
		elseif inst.prefab == "arcueid_shadow_knight_2" then
			inst.Transform:SetScale(2.5, 2.5, 2.5)
			inst.components.health:SetMaxHealth(2500)
			inst.AnimState:OverrideSymbol("arm","shadow_knight_upg_build", "arm2")
			inst.AnimState:OverrideSymbol("ear",       "shadow_knight_upg_build", "ear2")
			inst.AnimState:OverrideSymbol("face",      "shadow_knight_upg_build", "face2")
			inst.AnimState:OverrideSymbol("head",      "shadow_knight_upg_build", "head2")
			inst.AnimState:OverrideSymbol("leg_low",   "shadow_knight_upg_build", "leg_low2")
			inst.AnimState:OverrideSymbol("neck",      "shadow_knight_upg_build", "neck2")
			inst.AnimState:OverrideSymbol("spring",    "shadow_knight_upg_build", "spring2")
		elseif inst.prefab == "arcueid_shadow_rook" then
			inst.Transform:SetScale(1.2, 1.2, 1.2)
			inst.components.health:SetMaxHealth(1700)
			inst.AnimState:OverrideSymbol("base",           "shadow_rook_upg_build", "base1")
            inst.AnimState:OverrideSymbol("big_horn",       "shadow_rook_upg_build", "big_horn1")
            inst.AnimState:OverrideSymbol("bottom_head",    "shadow_rook_upg_build", "bottom_head1")
            inst.AnimState:OverrideSymbol("small_horn_lft", "shadow_rook_upg_build", "small_horn_lft1")
            inst.AnimState:OverrideSymbol("small_horn_rgt", "shadow_rook_upg_build", "small_horn_rgt1")
            inst.AnimState:OverrideSymbol("top_head",       "shadow_rook_upg_build", "top_head1")
		elseif inst.prefab == "arcueid_shadow_rook_2" then
			inst.Transform:SetScale(1.6, 1.6, 1.6)
			inst.components.health:SetMaxHealth(3000)
			inst.AnimState:OverrideSymbol("base",           "shadow_rook_upg_build", "base2")
            inst.AnimState:OverrideSymbol("big_horn",       "shadow_rook_upg_build", "big_horn2")
            inst.AnimState:OverrideSymbol("bottom_head",    "shadow_rook_upg_build", "bottom_head2")
            inst.AnimState:OverrideSymbol("small_horn_lft", "shadow_rook_upg_build", "small_horn_lft2")
            inst.AnimState:OverrideSymbol("small_horn_rgt", "shadow_rook_upg_build", "small_horn_rgt2")
            inst.AnimState:OverrideSymbol("top_head",       "shadow_rook_upg_build", "top_head2")
		elseif inst.prefab == "arcueid_shadow_bishop" then
			inst.Transform:SetScale(1.6, 1.6, 1.6)
			inst.components.health:SetMaxHealth(800)
			inst.AnimState:OverrideSymbol("body_mid",           "shadow_bishop_upg_build", "body_mid1")
            inst.AnimState:OverrideSymbol("body_upper",         "shadow_bishop_upg_build", "body_upper1")
            inst.AnimState:OverrideSymbol("head",               "shadow_bishop_upg_build", "head1")
            inst.AnimState:OverrideSymbol("sharp_feather_a",    "shadow_bishop_upg_build", "sharp_feather_a1")
            inst.AnimState:OverrideSymbol("sharp_feather_b",    "shadow_bishop_upg_build", "sharp_feather_b1")
            inst.AnimState:OverrideSymbol("wing",               "shadow_bishop_upg_build", "wing1")
		elseif inst.prefab == "arcueid_shadow_bishop_2" then
			inst.Transform:SetScale(2.2, 2.2, 2.2)
			inst.components.health:SetMaxHealth(2100)
			inst.AnimState:OverrideSymbol("body_mid",           "shadow_bishop_upg_build", "body_mid2")
            inst.AnimState:OverrideSymbol("body_upper",         "shadow_bishop_upg_build", "body_upper2")
            inst.AnimState:OverrideSymbol("head",               "shadow_bishop_upg_build", "head2")
            inst.AnimState:OverrideSymbol("sharp_feather_a",    "shadow_bishop_upg_build", "sharp_feather_a2")
            inst.AnimState:OverrideSymbol("sharp_feather_b",    "shadow_bishop_upg_build", "sharp_feather_b2")
            inst.AnimState:OverrideSymbol("wing",               "shadow_bishop_upg_build", "wing2")	
		end
	end)	
	inst:DoTaskInTime(95*FRAMES,function()
		if inst.prefab == "arcueid_shadow_knight" then
			SpawnPrefab("arcueid_shadow_knight_2").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst:Remove()
		elseif inst.prefab == "arcueid_shadow_knight_2" then
			SpawnPrefab("arcueid_shadow_knight_3").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst:Remove()
		elseif inst.prefab == "arcueid_shadow_rook" then
			SpawnPrefab("arcueid_shadow_rook_2").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst:Remove()
		elseif inst.prefab == "arcueid_shadow_rook_2" then
			SpawnPrefab("arcueid_shadow_rook_3").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst:Remove()
		elseif inst.prefab == "arcueid_shadow_bishop" then
			SpawnPrefab("arcueid_shadow_bishop_2").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst:Remove()	
		elseif inst.prefab == "arcueid_shadow_bishop_2" then
			SpawnPrefab("arcueid_shadow_bishop_3").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst:Remove()	
		end
	end)	
end

local function OnSave(inst, data)
    if inst.level then
        data.level = inst.level
    end
end

local function OnLoad(inst, data)
    if data and data.level then
		inst.level = data.level
		if inst.level > 1 then
			LeveUp(inst)
		end
    end
end

local function OnDeath(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
    if inst.prefab == "arcueid_shadow_knight" then
		local ents = TheSim:FindEntities(x,y,z,20, {"shadowchesspiece"}, {"FX", "NOCLICK", "DECOR","INLIMBO"})
		for k,v in pairs(ents) do
			if not v.components.health:IsDead() and (v.prefab == "arcueid_shadow_rook" or v.prefab == "arcueid_shadow_bishop" ) then
				local levelup = math.random()
				if levelup > 0.8 then
					LeveUp(v)
				end
			end
		end
	elseif inst.prefab == "arcueid_shadow_rook" then
		local ents = TheSim:FindEntities(x,y,z,20, {"shadowchesspiece"}, {"FX", "NOCLICK", "DECOR","INLIMBO"})
		for k,v in pairs(ents) do
			if not v.components.health:IsDead() and (v.prefab == "arcueid_shadow_knight" or v.prefab == "arcueid_shadow_bishop" ) then
				local levelup = math.random()
				if levelup > 0.8 then
					LeveUp(v)
				end
			end
		end
	elseif inst.prefab == "arcueid_shadow_bishop" then
		local ents = TheSim:FindEntities(x,y,z,20, {"shadowchesspiece"}, {"FX", "NOCLICK", "DECOR","INLIMBO"})
		for k,v in pairs(ents) do
			if not v.components.health:IsDead() and (v.prefab == "shadow_knight" or v.prefab == "shadow_rook" ) then
				local levelup = math.random()
				if levelup > 0.8 then
					LeveUp(v)
				end
			end
		end	
	elseif inst.prefab == "arcueid_shadow_knight_2" then
		local ents = TheSim:FindEntities(x,y,z,20, {"shadowchesspiece"}, {"FX", "NOCLICK", "DECOR","INLIMBO"})
		for k,v in pairs(ents) do
			if not v.components.health:IsDead() and (v.prefab == "arcueid_shadow_rook_2" or v.prefab == "arcueid_shadow_bishop_2" ) then
				local levelup = math.random()
				if levelup > 0.8 then
					LeveUp(v)
				end
			end
		end
	elseif inst.prefab == "arcueid_shadow_rook_2" then
		local ents = TheSim:FindEntities(x,y,z,20, {"shadowchesspiece"}, {"FX", "NOCLICK", "DECOR","INLIMBO"})
		for k,v in pairs(ents) do
			if not v.components.health:IsDead() and (v.prefab == "arcueid_shadow_knight_2" or v.prefab == "arcueid_shadow_bishop_2" ) then
				local levelup = math.random()
				if levelup > 0.8 then
					LeveUp(v)
				end
			end
		end
	elseif inst.prefab == "arcueid_shadow_bishop_2" then
		local ents = TheSim:FindEntities(x,y,z,20, {"shadowchesspiece"}, {"FX", "NOCLICK", "DECOR","INLIMBO"})
		for k,v in pairs(ents) do
			if not v.components.health:IsDead() and (v.prefab == "arcueid_shadow_knight_2" or v.prefab == "arcueid_shadow_rook_2" ) then
				local levelup = math.random()
				if levelup > 0.8 then
					LeveUp(v)
				end
			end
		end		
	end	
end

local function create_common(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddPhysics()
    inst.entity:AddSoundEmitter()
	RemovePhysicsColliders(inst)
	inst.Physics:SetCollisionGroup(COLLISION.SANITY)
	inst.Physics:CollidesWith(COLLISION.SANITY)
	inst.Physics:CollidesWith(2)
	inst.AnimState:PlayAnimation("idle_loop")
	inst.AnimState:SetMultColour(1,1,1,.5)
    inst.AnimState:SetFinalOffset(1)	
	inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("notraptrigger")
    inst:AddTag("shadowchesspiece")
	inst:AddComponent("inspectable")	
	inst:AddComponent("locomotor")	
	inst:AddComponent("health")	
	inst:AddComponent("combat")	
	inst.components.combat:SetRetargetFunction(1, NormalRetarget)
	inst.components.combat.notags = {"shadowchesspiece"}	
	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"nightmarefuel","nightmarefuel"})	
	inst:AddComponent("follower")	
	inst:AddComponent("knownlocations")			
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("death", OnDeath)	
	
	inst:DoPeriodicTask(5,function(inst) 
		if inst:GetTimeAlive() > 100 then
			inst.SoundEmitter:PlaySound("dontstarve/sanity/creature1/attack")
			SpawnPrefab("statue_transition").Transform:SetPosition(inst:GetPosition():Get())
			SpawnPrefab("statue_transition_2").Transform:SetPosition(inst:GetPosition():Get())
			inst:Remove()
		end
	end)
	
	--inst.OnSave = OnSave
    --inst.OnLoad = OnLoad
	--inst.OnEntityWake = OnEntityWake
    --inst.OnEntitySleep = OnEntitySleep  //follow player		
	return inst
end

local function create_shadowknight(Sim)
    local inst = create_common(Sim)
	inst.AnimState:SetBank("shadow_knight")
    inst.AnimState:SetBuild("shadow_knight")
	inst.Transform:SetFourFaced()
	inst.Transform:SetScale(1, 1, 1)
	--local minimap = inst.entity:AddMiniMapEntity()
	--minimap:SetIcon("shadow_knight.tex")		
	MakeCharacterPhysics(inst, 10, .25)	
    inst.components.locomotor.walkspeed = 5
    inst.components.locomotor.runspeed = 5
	inst.components.health:SetMaxHealth(400)	
    inst.components.combat:SetDefaultDamage(30)
    inst.components.combat:SetAttackPeriod(3)
	inst.components.combat:SetRange(2.3,3)
	inst.sounds = sounds2
	local brain = require "brains/arc_shadowknightbrain"
    inst:SetBrain(brain)	
	inst:SetStateGraph("SGarc_shadowknight")
    return inst
end

local function create_shadowknight_2(Sim)
    local inst = create_shadowknight(Sim)
	inst.Transform:SetScale(1.7, 1.7, 1.7)
	--local minimap = inst.entity:AddMiniMapEntity()
	--minimap:SetIcon("shadow_knight_2.tex")
	inst.AnimState:OverrideSymbol("arm",       "shadow_knight_upg_build", "arm1")
	inst.AnimState:OverrideSymbol("ear",       "shadow_knight_upg_build", "ear1")
	inst.AnimState:OverrideSymbol("face",      "shadow_knight_upg_build", "face1")
	inst.AnimState:OverrideSymbol("head",      "shadow_knight_upg_build", "head1")
	inst.AnimState:OverrideSymbol("leg_low",   "shadow_knight_upg_build", "leg_low1")
	inst.AnimState:OverrideSymbol("neck",      "shadow_knight_upg_build", "neck1")
	inst.AnimState:OverrideSymbol("spring",    "shadow_knight_upg_build", "spring1")	
    inst.components.locomotor.walkspeed = 7 / 1.7
	inst.components.locomotor.runspeed = 7 / 1.7	
	inst.components.lootdropper:SetLoot({"nightmarefuel","nightmarefuel","nightmarefuel","nightmarefuel"})	
	inst.components.health:SetMaxHealth(1000)	
    inst.components.combat:SetDefaultDamage(70)
    inst.components.combat:SetAttackPeriod(2.5)
	inst.components.combat:SetRange(4,5)
	inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED
    return inst
end

local function create_shadowknight_3(Sim)
    local inst = create_shadowknight(Sim)
	inst.Transform:SetScale(2.5, 2.5, 2.5)
	--local minimap = inst.entity:AddMiniMapEntity()
	--minimap:SetIcon("shadow_knight_3.tex")
	inst.AnimState:OverrideSymbol("arm","shadow_knight_upg_build", "arm2")
	inst.AnimState:OverrideSymbol("ear",       "shadow_knight_upg_build", "ear2")
	inst.AnimState:OverrideSymbol("face",      "shadow_knight_upg_build", "face2")
	inst.AnimState:OverrideSymbol("head",      "shadow_knight_upg_build", "head2")
	inst.AnimState:OverrideSymbol("leg_low",   "shadow_knight_upg_build", "leg_low2")
	inst.AnimState:OverrideSymbol("neck",      "shadow_knight_upg_build", "neck2")
	inst.AnimState:OverrideSymbol("spring",    "shadow_knight_upg_build", "spring2")
	inst:AddTag("epic")
    inst.components.locomotor.walkspeed = 8 / 1.7
	inst.components.locomotor.runspeed = 8 / 1.7	
	inst.components.lootdropper:SetLoot({"nightmarefuel","nightmarefuel","nightmarefuel","nightmarefuel","nightmarefuel","nightmarefuel","armor_sanity","nightsword","base_shadowheart"})	
	inst.components.health:SetMaxHealth(2500)	
    inst.components.combat:SetDefaultDamage(100)
    inst.components.combat:SetAttackPeriod(2.5)
	inst.components.combat:SetRange(5,7)
	inst.components.sanityaura.aura = -TUNING.SANITYAURA_LARGE
    return inst
end

local function create_rook(Sim)
    local inst = create_common(Sim)
	inst.AnimState:SetBank("shadow_rook")
    inst.AnimState:SetBuild("shadow_rook")
	inst.Transform:SetFourFaced()
	inst.Transform:SetScale(1, 1, 1)
	--local minimap = inst.entity:AddMiniMapEntity()
	--minimap:SetIcon("shadow_rook.tex")		
	MakeCharacterPhysics(inst, 10, 1.6)	
    inst.components.locomotor.walkspeed = 5
    inst.components.locomotor.runspeed = 5
	inst.components.health:SetMaxHealth(600)	
    inst.components.combat:SetDefaultDamage(45)
    inst.components.combat:SetAttackPeriod(6)
	inst.components.combat:SetRange(15,3)
	inst.sounds = sounds1
	local brain = require "brains/arc_shadowrookbrain"
    inst:SetBrain(brain)	
	inst:SetStateGraph("SGarc_shadowrook")	
    return inst
end

local function create_rook_2(Sim)
    local inst = create_rook(Sim)
	inst.Transform:SetScale(1.2, 1.2, 1.2)
	--local minimap = inst.entity:AddMiniMapEntity()
	--minimap:SetIcon("shadow_rook_2.tex")
	inst.AnimState:OverrideSymbol("base",           "shadow_rook_upg_build", "base1")
	inst.AnimState:OverrideSymbol("big_horn",       "shadow_rook_upg_build", "big_horn1")
	inst.AnimState:OverrideSymbol("bottom_head",    "shadow_rook_upg_build", "bottom_head1")
	inst.AnimState:OverrideSymbol("small_horn_lft", "shadow_rook_upg_build", "small_horn_lft1")
	inst.AnimState:OverrideSymbol("small_horn_rgt", "shadow_rook_upg_build", "small_horn_rgt1")
	inst.AnimState:OverrideSymbol("top_head",       "shadow_rook_upg_build", "top_head1")
    inst.components.locomotor.walkspeed = 5 / 1.2
	inst.components.locomotor.runspeed = 5 / 1.2
	inst.components.lootdropper:SetLoot({"nightmarefuel","nightmarefuel","nightmarefuel","nightmarefuel"})	
	inst.components.health:SetMaxHealth(1700)	
    inst.components.combat:SetDefaultDamage(80)
    inst.components.combat:SetAttackPeriod(5.5)
	inst.components.combat:SetRange(17,5)
	inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED
    return inst
end

local function create_rook_3(Sim)
    local inst = create_rook(Sim)
	inst.Transform:SetScale(1.6, 1.6, 1.6)
	--local minimap = inst.entity:AddMiniMapEntity()
	--minimap:SetIcon("shadow_rook_3.tex")
	inst.AnimState:OverrideSymbol("base",           "shadow_rook_upg_build", "base2")
	inst.AnimState:OverrideSymbol("big_horn",       "shadow_rook_upg_build", "big_horn2")
	inst.AnimState:OverrideSymbol("bottom_head",    "shadow_rook_upg_build", "bottom_head2")
	inst.AnimState:OverrideSymbol("small_horn_lft", "shadow_rook_upg_build", "small_horn_lft2")
	inst.AnimState:OverrideSymbol("small_horn_rgt", "shadow_rook_upg_build", "small_horn_rgt2")
	inst.AnimState:OverrideSymbol("top_head",       "shadow_rook_upg_build", "top_head2")
	inst:AddTag("epic")
    inst.components.locomotor.walkspeed = 5 / 1.6
	inst.components.locomotor.runspeed = 5 / 1.6
	inst.components.lootdropper:SetLoot({"nightmarefuel","nightmarefuel","nightmarefuel","nightmarefuel","nightmarefuel","nightmarefuel","armor_sanity","nightsword","base_shadowheart"})
	inst.components.health:SetMaxHealth(3000)	
    inst.components.combat:SetDefaultDamage(120)
    inst.components.combat:SetAttackPeriod(5)
	inst.components.combat:SetRange(19,7)
	inst.components.sanityaura.aura = -TUNING.SANITYAURA_LARGE
    return inst
end

local function create_bishop(Sim)
    local inst = create_common(Sim)
	inst.AnimState:SetBank("shadow_bishop")
    inst.AnimState:SetBuild("shadow_bishop")
	inst.Transform:SetFourFaced()
	inst.Transform:SetScale(1, 1, 1)
	--local minimap = inst.entity:AddMiniMapEntity()
	--minimap:SetIcon("shadow_bishop.tex")		
	MakeCharacterPhysics(inst, 10, .3)	
    inst.components.locomotor.walkspeed = 3
    inst.components.locomotor.runspeed = 3
	inst.components.health:SetMaxHealth(350)	
    inst.components.combat:SetDefaultDamage(20)
    inst.components.combat:SetAttackPeriod(10)
	inst.components.combat:SetRange(11,1.75)
	inst.sounds = sounds1
	local brain = require "brains/arc_shadowbishopbrain"
    inst:SetBrain(brain)	
	inst:SetStateGraph("SGarc_shadowbishop")	
    return inst
end

local function create_bishop_2(Sim)
    local inst = create_bishop(Sim)
	inst.Transform:SetScale(1.6, 1.6, 1.6)
	--local minimap = inst.entity:AddMiniMapEntity()
	--minimap:SetIcon("shadow_bishop_2.tex")
	inst.AnimState:OverrideSymbol("base",           "shadow_rook_upg_build", "base1")
	inst.AnimState:OverrideSymbol("big_horn",       "shadow_rook_upg_build", "big_horn1")
	inst.AnimState:OverrideSymbol("bottom_head",    "shadow_rook_upg_build", "bottom_head1")
	inst.AnimState:OverrideSymbol("small_horn_lft", "shadow_rook_upg_build", "small_horn_lft1")
	inst.AnimState:OverrideSymbol("small_horn_rgt", "shadow_rook_upg_build", "small_horn_rgt1")
	inst.AnimState:OverrideSymbol("top_head",       "shadow_rook_upg_build", "top_head1")
    inst.components.locomotor.walkspeed = 3 / 1.6
	inst.components.locomotor.runspeed = 3 / 1.6
	inst.components.lootdropper:SetLoot({"nightmarefuel","nightmarefuel","nightmarefuel","nightmarefuel"})	
	inst.components.health:SetMaxHealth(800)	
    inst.components.combat:SetDefaultDamage(30)
    inst.components.combat:SetAttackPeriod(12)
	inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED
    return inst
end

local function create_bishop_3(Sim)
    local inst = create_bishop(Sim)
	inst.Transform:SetScale(2.2, 2.2, 2.2)
	--local minimap = inst.entity:AddMiniMapEntity()
    --minimap:SetIcon("shadow_bishop_3.tex")
	inst.AnimState:OverrideSymbol("body_mid",           "shadow_bishop_upg_build", "body_mid2")
	inst.AnimState:OverrideSymbol("body_upper",         "shadow_bishop_upg_build", "body_upper2")
	inst.AnimState:OverrideSymbol("head",               "shadow_bishop_upg_build", "head2")
	inst.AnimState:OverrideSymbol("sharp_feather_a",    "shadow_bishop_upg_build", "sharp_feather_a2")
	inst.AnimState:OverrideSymbol("sharp_feather_b",    "shadow_bishop_upg_build", "sharp_feather_b2")
	inst.AnimState:OverrideSymbol("wing",               "shadow_bishop_upg_build", "wing2")
    inst.components.locomotor.walkspeed = 3 / 2.2
	inst.components.locomotor.runspeed = 3 / 2.2
	inst.components.lootdropper:SetLoot({"nightmarefuel","nightmarefuel","nightmarefuel","nightmarefuel","nightmarefuel","nightmarefuel","armor_sanity","nightsword","base_shadowheart"})
	inst.components.health:SetMaxHealth(2100)	
    inst.components.combat:SetDefaultDamage(48)
    inst.components.combat:SetAttackPeriod(14)
	inst.components.sanityaura.aura = -TUNING.SANITYAURA_LARGE
    return inst
end	

local function bishopfxfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst:AddTag("FX")
    inst.AnimState:SetBank("shadow_bishop_fx")
    inst.AnimState:SetBuild("shadow_bishop_fx")
    inst.AnimState:PlayAnimation("feather_loop")
    inst.AnimState:SetFinalOffset(1)
    inst.persists = false
    inst:ListenForEvent("animover", inst.Remove)
    return inst
end

STRINGS.NAMES.SHADOW_KNIGHT = "暗影骑士"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOW_KNIGHT = "那是一个骑士!"
STRINGS.NAMES.SHADOW_KNIGHT_2 = "发疯的暗影骑士"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOW_KNIGHT_2 = "他变强了，但是看起来更悲伤了."
STRINGS.NAMES.SHADOW_KNIGHT_3 = "狂躁的暗影骑士"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOW_KNIGHT_3 = "那张假笑的脸看起来好讨厌."

STRINGS.NAMES.SHADOW_ROOK = "暗影战车"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOW_ROOK = "一个又大又黑的阴影."
STRINGS.NAMES.SHADOW_ROOK_2 = "发疯的暗影战车"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOW_ROOK_2 = "对我来说这玩意太大了!"
STRINGS.NAMES.SHADOW_ROOK_3 = "狂躁的暗影战车"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOW_ROOK_3 = "卧槽，山一样大的影子"

STRINGS.NAMES.SHADOW_BISHOP = "暗影主教"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOW_BISHOP = "那是一棵矮树的影子么?"
STRINGS.NAMES.SHADOW_BISHOP_2 = "发疯的暗影主教"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOW_BISHOP_2 = "最好离他远点."
STRINGS.NAMES.SHADOW_BISHOP_3 = "狂躁的暗影主教"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOW_BISHOP_3 = "我绝对不想靠近这玩意！."

return Prefab( "common/arcueid_shadow_knight", create_shadowknight, assets, prefabs),
       Prefab( "common/arcueid_shadow_knight_2", create_shadowknight_2, assets, prefabs),
	   Prefab( "common/arcueid_shadow_knight_3", create_shadowknight_3, assets, prefabs),
	   Prefab( "common/arcueid_shadow_rook", create_rook, assets, prefabs),
	   Prefab( "common/arcueid_shadow_rook_2", create_rook_2, assets, prefabs),
	   Prefab( "common/arcueid_shadow_rook_3", create_rook_3, assets, prefabs),
	   Prefab( "common/arcueid_shadow_bishop", create_bishop, assets, prefabs),
       Prefab( "common/arcueid_shadow_bishop_2", create_bishop_2, assets, prefabs),
	   Prefab( "common/arcueid_shadow_bishop_3", create_bishop_3, assets, prefabs),
	   Prefab( "common/arcueid_shadow_bishop_fx", bishopfxfn, assets, prefabs)