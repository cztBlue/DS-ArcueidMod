require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/avoidlight"
require "behaviours/panic"

local CHASE_DIST = 50
local CHASE_TIME = 30
local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 3
local MAX_FOLLOW_DIST = 8
local TRADE_DIST = 20
local MAX_WANDER_DIST = 200

local ShadowRookBrain = Class(Brain, function(self, inst)
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

function ShadowRookBrain:OnStart()
    local root =
        PriorityNode(
        {
            ChaseAndAttack(self.inst, CHASE_TIME, CHASE_DIST),				
            Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
            IfNode(function() return self.inst.components.follower.leader ~= nil end, "HasLeader",
				FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn )),            
            FaceEntity(self.inst, GetTraderFn, KeepTraderFn),
            Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)            
        },1)    
    self.bt = BT(self.inst, root)        
end

function ShadowRookBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("home", Point(self.inst.Transform:GetWorldPosition()), true)

end

return ShadowRookBrain