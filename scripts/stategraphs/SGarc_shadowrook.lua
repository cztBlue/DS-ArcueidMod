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
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("teleport_pre")
            inst.AnimState:PushAnimation("teleport", false)
        end,

        timeline =
        {
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.attack_grunt) end),
            TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.appear) end),
            TimeEvent(19*FRAMES, function(inst)
                inst.sg:AddStateTag("noattack")
                inst.components.health:SetInvincible(true)
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg.statemem.attack = true
                    inst.sg:GoToState("attack_teleport", inst.sg.statemem.target)
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
        name = "attack_teleport",
        tags = {"attack", "busy", "noattack"},

        onenter = function(inst, target)
            inst.components.health:SetInvincible(true)
            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst.Physics:Teleport(target.Transform:GetWorldPosition())
            end
            inst.AnimState:PlayAnimation("teleport_atk")
            inst.AnimState:PushAnimation("teleport_pst", false)
        end,

        timeline =
        {
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.attack) end),
			TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.appear) end),
            TimeEvent(17*FRAMES, function(inst)
                inst.sg:RemoveStateTag("noattack")
                inst.components.health:SetInvincible(false)
                inst.components.combat:DoAreaAttack(inst, inst.components.combat.hitrange, nil, nil, nil, { "INLIMBO", "notarget", "invisible", "noattack", "flight", "playerghost", "shadow", "shadowchesspiece", "shadowcreature" })
            end),
            TimeEvent(34*FRAMES, function(inst) inst.sg:RemoveStateTag("busy") end),
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

return StateGraph("shadow_rook", states, events, "idle")