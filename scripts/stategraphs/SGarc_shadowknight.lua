require("stategraphs/commonstates")

local events = 
{
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
    CommonHandlers.OnAttack(),
	CommonHandlers.OnFreeze(),
	CommonHandlers.OnLocomote(false, true),
	EventHandler("doattack", function(inst, data)
		if inst.components.health 
		and not inst.components.health:IsDead() 
		and     (inst.sg:HasStateTag("hit") 
		or not inst.sg:HasStateTag("busy")) 
		then	  	inst.sg:GoToState("attack_pre")
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
        name = "attack_pre",
        tags = {"attack", "busy"},

        onenter = function(inst)
            inst.Transform:SetFourFaced()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.components.combat:StartAttack()
        end,

        timeline =
        {
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.attack_grunt) end),
            TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.attack) end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg.statemem.attack = true
                    inst.sg:GoToState(
                        inst.components.combat.target ~= nil and
                        inst:GetDistanceSqToInst(inst.components.combat.target) > inst.components.combat:CalcAttackRangeSq() * .8 and
                        "attack_long" or
                        "attack_short"
                    )
                end
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.attack then
                inst.Transform:SetFourFaced()
            end
        end,
    },
	
	State
	{
        name = "attack_short",
        tags = {"attack", "busy"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("atk")
        end,

        timeline =
        {
            TimeEvent(3*FRAMES, function(inst) inst.components.combat:DoAttack() end),
            TimeEvent(13*FRAMES, function(inst) inst.sg:RemoveStateTag("busy") end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

        onexit = function(inst)
            inst.Transform:SetFourFaced()
        end,
    },
		
    State
	{
        name = "attack_long",
        tags = {"attack", "busy"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("atk_plus")
        end,

        timeline =
        {
            TimeEvent(5*FRAMES, function(inst) inst.components.combat:DoAttack() end),
            TimeEvent(17*FRAMES, function(inst) inst.sg:RemoveStateTag("busy") end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

        onexit = function(inst)
            inst.Transform:SetFourFaced()
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

return StateGraph("shadow_knight", states, events, "idle")