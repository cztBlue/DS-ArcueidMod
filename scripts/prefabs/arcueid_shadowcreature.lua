local assets =
{
    Asset("ANIM", "anim/creature_shadow_knight.zip"),
    Asset("ANIM", "anim/shadow_knight.zip"),
    Asset("ANIM", "anim/creature_shadow_knight_upg_build.zip"),
}

local prefabs =
{
    "nightmarefuel",
}

local function retargetfn(inst)
    local notags = {"FX", "NOCLICK","INLIMBO"}
    local yestags = {"player"}
    local entity = FindEntity(inst, TUNING.SHADOWCREATURE_TARGET_DIST, function(guy) 
		return guy.components.sanity:IsCrazy() and inst.components.combat:CanTarget(guy)
    end, yestags, notags)
    return entity
end

local function onkilledbyother(inst, attacker)
	if attacker and attacker.components.sanity then
		attacker.components.sanity:DoDelta(inst.sanityreward or TUNING.SANITY_SMALL)
	end
end

SetSharedLootTable( 'shadow_creature',
{
    {'nightmarefuel',  1.0},
    {'nightmarefuel',  0.5},
})

local function CalcSanityAura(inst, observer)
	if inst.components.combat.target then
		return -TUNING.SANITYAURA_LARGE
	end	
	return 0
end

local function canbeattackedfn(inst, attacker)
	return inst.components.combat.target ~= nil or
		(attacker and attacker.components.sanity and attacker.components.sanity:IsCrazy())
end

local function OnAttacked(inst, data)
    --attacker.components.health.DoDelta(-50,nil,"nightattack")
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("shadowcreature") and not dude.components.health:IsDead() end, 1)
end

-- World Hop causes shadow creatures to be disconnected with the sanitymonsterspawner component.
-- Let's delete them in those cases.
local function CheckSanityCreatureSpawnerLink(inst)
    if GetPlayer() and GetPlayer().components.sanitymonsterspawner and
    not table.contains(GetPlayer().components.sanitymonsterspawner.monsters or {}, inst) then
        inst:Remove()
    end
end




-----------------------------------------

local function commonfn(name)
    local sounds = 
    {
        attack = "dontstarve/sanity/creature".."1".."/attack",
        attack_grunt = "dontstarve/sanity/creature".."1".."/attack_grunt",
        death = "dontstarve/sanity/creature".."1".."/die",
        idle = "dontstarve/sanity/creature".."1".."/idle",
        taunt = "dontstarve/sanity/creature".."1".."/taunt",
        appear = "dontstarve/sanity/creature".."1".."/appear",
        disappear = "dontstarve/sanity/creature".."1".."/dissappear",
    }

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local physics = inst.entity:AddPhysics()
    local sound = inst.entity:AddSoundEmitter()
    inst.Transform:SetFourFaced()
    inst:AddTag("shadowcreature")

    MakeCharacterPhysics(inst, 10, 1.5)
    inst.Physics:ClearCollisionMask()
    inst.Physics:SetCollisionGroup(COLLISION.SANITY)
    inst.Physics:CollidesWith(COLLISION.SANITY)
    inst.Physics:CollidesWith(COLLISION.GROUND)

    inst.Transform:SetFourFaced()
    anim:SetBank(name)
    anim:SetBuild(name)
    anim:PlayAnimation("idle_loop")
    anim:SetMultColour(1, 1, 1, 0.5)

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }

    inst.sounds = sounds
    local brain = require "brains/shadowcreaturebrain"
    inst:SetStateGraph("SGarcueid_shadowcreature")
    inst:SetBrain(brain)

    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("shadow")
    inst:AddTag("windspeedimmune")
    inst:AddTag("notraptrigger")

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura
    inst.sanityreward = TUNING.SANITY_MED

    inst:AddComponent("transparentonsanity")
    inst.components.transparentonsanity:ForceUpdate()
    
    inst:AddComponent("combat")
    inst:AddComponent("health")
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat.onkilledbyother = onkilledbyother
    inst.components.combat.canbeattackedfn = canbeattackedfn

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('shadow_creature')
    
    inst:ListenForEvent("attacked", OnAttacked)

    -- inst:DoTaskInTime(0, CheckSanityCreatureSpawnerLink)

    return inst
end

--bankh和build命名模式是creature+原名
local function knightfn()
    local inst = commonfn("shadow_knight")
    inst.components.locomotor.walkspeed = TUNING.SHADOW_KNIGHT.SPEED[1]
    inst.components.health:SetMaxHealth(TUNING.SHADOW_KNIGHT.HEALTH[1])
    inst.components.combat:SetDefaultDamage(TUNING.SHADOW_KNIGHT.DAMAGE[1])
    inst.components.combat:SetAttackPeriod(TUNING.SHADOW_KNIGHT.ATTACK_PERIOD[1])
    inst.components.combat:SetRange(TUNING.SHADOW_KNIGHT.ATTACK_RANGE, TUNING.SHADOW_KNIGHT.ATTACK_RANGE_LONG)
    return inst
end

return Prefab("arcueid_shadow_knight", knightfn,assets, prefabs)
