require("stategraphs/commonstates")

local events = 
{
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
    CommonHandlers.OnAttack(),
	CommonHandlers.OnFreeze(),
	CommonHandlers.OnLocomote(false, true),
	EventHandler("doattack", function(inst, data)
		if inst.components.health and not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
			inst.sg:GoToState("attack", data.target)
		end
	end),
}

local SWARM_PERIOD = .5
local SWARM_START_DELAY = .25

local function DoSwarmAttack(inst)
    inst.components.combat:DoAreaAttack(inst, inst.components.combat.hitrange, nil, nil, nil, { "INLIMBO", "notarget", "invisible", "noattack", "flight", "playerghost", "shadow", "shadowchesspiece", "shadowcreature", "shadowminion" })
end

local function DoSwarmFX(inst)
    local fx = SpawnPrefab("shadow_bishop_fx")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx.Transform:SetScale(inst.Transform:GetScale())
    fx.AnimState:SetMultColour(inst.AnimState:GetMultColour())
end

local states =
{
    State
	{
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, pushanim)    
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_loop", true)
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	State
	{
        name = "attack",
        tags = {"attack", "busy"},

        onenter = function(inst, target)
            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst.sg.statemem.targetpos = target:GetPosition()
            end
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk_side_pre")
        end,

        onupdate = function(inst)
            if inst.sg.statemem.target ~= nil then
                if inst.sg.statemem.target:IsValid() then
                    inst.sg.statemem.targetpos = inst.sg.statemem.target:GetPosition()
                else
                    inst.sg.statemem.target = nil
                end
            end
        end,

        timeline =
        {
            TimeEvent(8*FRAMES, function(inst)
                inst.sg:AddStateTag("noattack")
                inst.components.health:SetInvincible(true)
                DoSwarmFX(inst)
                inst.SoundEmitter:PlaySound(inst.sounds.attack)
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg.statemem.attack = true
                    inst.sg:GoToState("attack_loop", { target = inst.sg.statemem.target, targetpos = inst.sg.statemem.targetpos })
                end
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.attack then
                inst.components.health:SetInvincible(false)
            end
        end,
    },

    State
	{
        name = "attack_loop",
        tags = {"attack", "busy", "noattack"},

        onenter = function(inst, data)
            inst.components.health:SetInvincible(true)
            if data.targetpos ~= nil then
                inst.Physics:Teleport(data.targetpos:Get())
				inst.SoundEmitter:PlaySound(inst.sounds.disappear)
                if data.target ~= nil and data.target:IsValid() then
                    local scale = inst.Transform:GetScale()
                    inst.sg.statemem.speed = 2 / scale
                    inst.sg.statemem.target = data.target
                    if inst:IsNear(data.target, .5) then
                        inst.Physics:Stop()
                    else
                        inst:ForceFacePoint(data.target.Transform:GetWorldPosition())
                        inst.Physics:SetMotorVel(inst.sg.statemem.speed, 0, 0)
                    end
                end
            end
            inst.AnimState:PlayAnimation("atk_side_loop_pre")
            inst.sg.statemem.task = inst:DoPeriodicTask(SWARM_PERIOD, DoSwarmAttack, SWARM_START_DELAY)
            inst.sg.statemem.fxtask = inst:DoPeriodicTask(1.2, DoSwarmFX, .5)
            inst.sg:SetTimeout(130 * FRAMES)
        end,

        onupdate = function(inst)
            if inst.sg.statemem.target ~= nil then
                if not inst.sg.statemem.target:IsValid() then
                    inst.sg.statemem.target = nil
                elseif inst:IsNear(inst.sg.statemem.target, .5) then
                    inst.Physics:Stop()
                else
                    inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
                    inst.Physics:SetMotorVel(inst.sg.statemem.speed, 0, 0)
                end
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if
                 inst.AnimState:AnimDone() 
                or inst.AnimState:IsCurrentAnimation("atk_side_loop_pre") then
                    inst.AnimState:PlayAnimation("atk_side_loop", true)
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg.statemem.attack = true
            inst.sg:GoToState("attack_loop_pst", inst.sg.statemem.target)
        end,

        onexit = function(inst)
            inst.sg.statemem.task:Cancel()
            inst.sg.statemem.fxtask:Cancel()
            if not inst.sg.statemem.attack then
                inst.components.health:SetInvincible(false)
            end
        end,
    },

    State
	{
        name = "attack_loop_pst",
        tags = {"attack", "busy", "noattack"},

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk_side_loop_pst")
			inst.SoundEmitter:PlaySound(inst.sounds.appear)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    local pos = inst.sg.statemem.target ~= nil and inst.sg.statemem.target:IsValid() and inst.sg.statemem.target:GetPosition() or inst:GetPosition()
                    local bestoffset = nil
                    local minplayerdistsq = math.huge
                    for i = 1, 4 do
                        local offset = FindWalkableOffset(pos, math.random() * 2 * PI, 8 + math.random() * 2, 4, false, true)
                    end
                    if bestoffset ~= nil then
                        inst.Physics:Teleport(pos.x + bestoffset.x, 0, pos.z + bestoffset.z)
                    end
                    inst.sg.statemem.attack = true
                    inst.sg:GoToState("attack_pst")
                end
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.attack then
                inst.components.health:SetInvincible(false)
            end
        end,
    },

    State
	{
        name = "attack_pst",
        tags = {"attack", "busy", "noattack"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("atk_side_pst")
        end,

        timeline =
        {
            TimeEvent(21*FRAMES, function(inst)
                inst.sg:RemoveStateTag("noattack")
                inst.sg:RemoveStateTag("busy")
                inst.components.health:SetInvincible(false)
            end),
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

        onexit = function(inst)
            inst.components.health:SetInvincible(false)
        end,
    },
	
	State
	{
        name = "death",
        tags = {"busy"},
        onenter = function(inst)
            inst.SoundEmitter:PlaySound(inst.sounds.death)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)            
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,
    },
	
    State
	{
        name = "dissapear",
        tags = {"busy"},
        onenter = function(inst)
            inst.SoundEmitter:PlaySound(inst.sounds.death)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)                  
        end,
    },
   
    State
	{
        name = "hit",
        tags = {"busy"},
        
        onenter = function(inst)     
            inst.AnimState:PlayAnimation("hit")    
            inst.Physics:Stop()            
        end,
		
		timeline =
        {
            TimeEvent(3*FRAMES, function(inst) inst.sg:RemoveStateTag("busy") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },                     
    },
	
	State
	{
        name = "taunt",
        tags = {"taunt", "busy"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
        end,

        timeline =
        {
            TimeEvent(3.5*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.taunt) end),
            TimeEvent(44*FRAMES, function(inst) inst.sg:RemoveStateTag("busy") end),
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	State
	{
        name = "transform",
        tags = {"transform", "busy"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("transform")
			inst.components.health:SetInvincible(true)
        end,

        timeline =
        {
            --TimeEvent(44*FRAMES, function(inst)  inst.sg:RemoveStateTag("busy")  end),
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
		
		onexit = function(inst)
            inst.components.health:SetInvincible(false)
        end,
    },
}

CommonStates.AddWalkStates(states)
CommonStates.AddRunStates(states)

return StateGraph("shadow_bishop", states, events, "idle")