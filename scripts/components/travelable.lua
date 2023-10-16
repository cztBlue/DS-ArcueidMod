local default_dist_cost = 32
local max_sanity_cost = 15
local min_hunger_cost = 5
local sanity_cost_ratio = 20/75
local find_dist = (max_sanity_cost / sanity_cost_ratio - min_hunger_cost) * default_dist_cost

local traveltag = 'travelling'
local TravelableTag = 'travelable'

local Travelable = Class(function(self, inst)
    self.inst = inst
	self.destinations = {}
	self.site = nil
	self.totalsites = 0
	self.traveltask = nil
	self.dist_cost = default_dist_cost
	self.inst:AddTag(TravelableTag)
end)

function Travelable:CollectSceneActions(doer, actions, right)
	if right then
		if self.inst:HasTag(TravelableTag) and not self.inst:HasTag("burnt") and not self.inst:HasTag("fire") then
			table.insert(actions, ACTIONS.DESTINATION)
		end
	end
end

local function IsNearDanger(inst)
    local hounded = GetWorld().components.hounded
    if hounded ~= nil and (hounded.warning or hounded.timetoattack <= 0) then
        return true
    end
    local burnable = inst.components.burnable
    if burnable ~= nil and (burnable:IsBurning() or burnable:IsSmoldering()) then
        return true
    end
    if inst:HasTag("spiderwhisperer") then
        return FindEntity(inst, 10,
                function(target)
                    return (target.components.combat ~= nil and target.components.combat.target == inst)
                        or (not (target:HasTag("player") or target:HasTag("spider"))
                            and (target:HasTag("monster") or target:HasTag("pig")))
                end,
                nil, nil, { "monster", "pig", "_combat" }) ~= nil
    end
    return FindEntity(inst, 10,
            function(target)
                return (target.components.combat ~= nil and target.components.combat.target == inst)
                    or (target:HasTag("monster") and not target:HasTag("player"))
            end,
            nil, nil, { "monster", "_combat" }) ~= nil
end

function Travelable:ListDestination(traveller)
	local x, y, z = self.inst.Transform:GetWorldPosition()
	local dests = TheSim:FindEntities(x, y, z, find_dist, TravelableTag)
	local dest = {}
	
	for k,v in pairs(dests) do
		if v ~= self.inst and v.components.travelable then
			table.insert(dest, v)
		end
	end
	
	self.destinations = dest
	self.site = self.site or #dest
	self.totalsites = #dest
end

function Travelable:SelectDestination(traveller)
	if traveller == nil then return	end
	self:ListDestination(traveller)
	local comment = self.inst.components.talker
	local talk = traveller.components.talker
	
	if self.totalsites < 1 then
		if comment then comment:Say("提示：没有可选择的空间锚点。")
		elseif talk then talk:Say("去不了啊。") end
		return
	end
	
	-- Restart travel tasks
	traveller:RemoveTag(traveltag)
	if traveller.untraveltask ~= nil then
		traveller.untraveltask:Cancel()
		traveller.untraveltask = nil
	end
	if self.traveltask ~= nil then
		self.traveltask:Cancel()
		self.traveltask = nil
	end
	if self.traveltask1 ~= nil then
		self.traveltask1:Cancel()
		self.traveltask1 = nil
	end
	if self.traveltask2 ~= nil then
		self.traveltask2:Cancel()
		self.traveltask2 = nil
	end
	if self.traveltask3 ~= nil then
		self.traveltask3:Cancel()
		self.traveltask3 = nil
	end
	if self.traveltask4 ~= nil then
		self.traveltask4:Cancel()
		self.traveltask4 = nil
	end
	if self.traveltask5 ~= nil then
		self.traveltask5:Cancel()
		self.traveltask5 = nil
	end
	
	-- Select next site
	self.site = self.site + 1
	if self.site > self.totalsites then self.site = 1 end
	local destination = self.destinations[self.site]
	if destination == nil then return end
	
	-- If next site is self, try next next site
	if destination == self.inst then
		self.site = self.site + 1
		if self.site > self.totalsites then self.site = 1 end
		destination = self.destinations[self.site]
		if destination == self.inst then
			return
		end
	end
	
	-- Site information
	local desc = destination and destination.components.signable and destination.components.signable:GetText()
	local description = desc and string.format('"%s"', desc) or "提示：未知空间锚点"
	local information = ""
	local cost_vigour = 10
	local cost_sanity = 0
	local xi,yi,zi = self.inst.Transform:GetWorldPosition()
	local xf,yf,zf = destination.Transform:GetWorldPosition()
	local dist = math.sqrt((xi-xf)^2 + (zi-zf)^2)
	
	if destination and destination.components.travelable then
		traveller:AddTag(traveltag)
		traveller.untraveltask = traveller:DoTaskInTime(15, function() traveller:RemoveTag(traveltag) end)
		cost_vigour = cost_vigour + math.ceil(dist / self.dist_cost)
		cost_sanity = cost_vigour * sanity_cost_ratio
		
		if GetSeasonManager():GetSeasonString() == "winter" then
			cost_sanity = cost_sanity * 1.25
		elseif GetSeasonManager():GetSeasonString() == "summer" then
			cost_sanity = cost_sanity * 0.75
		end
		
		information = "前往锚点： "..description.." ("..string.format("%.0f", self.site).."/"..string.format("%.0f", self.totalsites)..")".."\n".."活力消耗："..string.format("%.0f", cost_vigour).."\n"
		if comment then
			comment:Say(string.format(information),3)
		elseif talk then
			talk:Say(string.format(information),3)
		end
		
		self.traveltask = self.inst:DoTaskInTime(8, function()
			local travellers = TheSim:FindEntities(xi, yi, zi, 5, {traveltag,"player"},{"playerghost"})
			
			for k, who in pairs(travellers) do
				if destination == nil or not destination:IsValid() then
					if comment then comment:Say("提示：无法链接该锚点")
					elseif talk then talk:Say("什么嘛，这东西根本用不了一点。") end
				elseif who == nil or (who.components.health and who.components.health:IsDead()) then
					if comment then comment:Say("提示：无法单独传送非灵魂实体") end
				elseif IsNearDanger(who) then
					if talk then talk:Say("真没用。")
					elseif comment then comment:Say("提示：空域混乱，锚点自动断开") end
				elseif who.components.hunger and who.components.hunger.current >= cost_vigour and who.components.sanity and who.components.sanity.current >= cost_sanity then
					if who.components.vigour then
						who.components.hunger:DoDelta(-cost_vigour)
						--who.components.sanity:DoDelta(-cost_sanity)
					end
					if who.Physics ~= nil then
						who.Physics:Teleport(xf-1, 0, zf)
					else
						who.Transform:SetPosition(xf-1, 0, zf)
					end
					
					-- follow
					if who.components.leader and who.components.leader.followers then
						for kf,vf in pairs(who.components.leader.followers) do
							if kf.Physics ~= nil then
								kf.Physics:Teleport(xf+1, 0, zf)
							else
								kf.Transform:SetPosition(xf+1, 0, zf)
							end
						end
					end
					
					local inventory  = who.components.inventory
					if inventory then
						for ki, vi in pairs(inventory.itemslots) do
							if vi.components.leader and vi.components.leader.followers then
								for kif,vif in pairs(vi.components.leader.followers) do
									if kif.Physics ~= nil then
										kif.Physics:Teleport(xf, 0, zf+1)
									else
										kif.Transform:SetPosition(xf, 0, zf+1)
									end
								end
							end
						end
					end
					
					local container = inventory.overflow ~= nil and inventory.overflow.components.container or nil
					if container then
						for kb, vb in pairs(container.slots) do
							if vb.components.leader and vb.components.leader.followers then
								for kbf,vbf in pairs(vb.components.leader.followers) do
									if kbf.Physics ~= nil then
										kbf.Physics:Teleport(xf, 0, zf-1)
									else
										kbf.Transform:SetPosition(xf, 0, zf-1)
									end
								end
							end
						end
					end
					-- /follow
					
					traveller:RemoveTag(traveltag)
					if traveller.untraveltask ~= nil then
						traveller.untraveltask:Cancel()
						traveller.untraveltask = nil
					end
				else
					if talk then talk:Say("什么嘛，这东西根本用不了一点。")
					elseif comment then comment:Say("提示：锚点链接失败") end
				end
			end
		end)
		
		self.traveltask5 = self.inst:DoTaskInTime(3, function() comment:Say("提示：5秒后开始传送")
		end)
		self.traveltask4 = self.inst:DoTaskInTime(4, function() comment:Say("提示：请勿乱动")
		self.inst.SoundEmitter:PlaySound("dontstarve/HUD/craft_down") end)
		self.traveltask3 = self.inst:DoTaskInTime(5, function() comment:Say("提示：3秒后开始传送") 
		self.inst.SoundEmitter:PlaySound("dontstarve/HUD/craft_down") end)
		self.traveltask2 = self.inst:DoTaskInTime(6, function() comment:Say("提示：2秒后开始传送")
		self.inst.SoundEmitter:PlaySound("dontstarve/HUD/craft_down") end)
		self.traveltask1 = self.inst:DoTaskInTime(7, function() comment:Say("提示：1秒后开始传送",1)
		self.inst.SoundEmitter:PlaySound("dontstarve/HUD/craft_down") end)
			
	elseif comment then
		comment:Say("提示：无法传送")
	elseif talk then
		talk:Say("这东西肯定是又坏了。")
	end
end

return Travelable