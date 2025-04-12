require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/avoidlight"
require "behaviours/panic"

local CHASE_DIST = 50
local CHASE_TIME = 30
local RUN_AWAY_DIST = 10
local STOP_RUN_AWAY_DIST = 14
local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 3
local MAX_FOLLOW_DIST = 8
local TRADE_DIST = 20
local MAX_WANDER_DIST = 200

local ShadowKnightBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GetTraderFn(inst)
    if inst.components.trader then
        return FindEntity(inst, TRADE_DIST, function(target) return inst.components.trader:IsTryingToTradeWithMe(target) end, {"player"})
    end
end

local function KeepTraderFn(inst, target)
    if inst.components.trader then
        return inst.components.trader:IsTryingToTradeWithMe(target)
    end
end

local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

function ShadowKnightBrain:OnStart()
    local root =
        PriorityNode(
        {
            WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
                ChaseAndAttack(self.inst, CHASE_TIME, CHASE_DIST)),				
			WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge",
				RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST)),	
            Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
            IfNode(function() return self.inst.components.follower.leader ~= nil end, "HasLeader",
				FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn )),            
            FaceEntity(self.inst, GetTraderFn, KeepTraderFn),
            Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)            
        },1)    
    self.bt = BT(self.inst, root)        
end

function ShadowKnightBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("home", Point(self.inst.Transform:GetWorldPosition()), true)

end

return ShadowKnightBrain