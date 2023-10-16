local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local Widget = require "widgets/widget"

local VigourBadge = Class(Badge, function(self, owner)
	Badge._ctor(self, "vigour", owner)

    self.bg = self:AddChild(Image("images/replace_res/vigourbadge/Symbol 2-0.xml", "Symbol 2-0.tex"))
    self.fill = self:AddChild(Image("images/replace_res/vigourbadge/vigour_level-20.xml", "vigour_level-20.tex"))
    self.status = self:AddChild(Image("images/replace_res/vigourbadge/vigourstatus-2.xml", "vigourstatus-2.tex"))
    self.frame = self:AddChild(Image("images/replace_res/vigourbadge/frame_circle-0.xml", "frame_circle-0.tex"))	
	
	self.fill:SetScale(0.95, 0.95, 0.95)
	self.fill:SetPosition(-1.5, -4, 0)

	self.status:SetScale(0.19, 0.19, 0.19)
	self.status:SetPosition(-0.5, -2, 0)

	--表中的位置越靠后,越是显示在上层,故重写underNumber
	self.underNumber = self:AddChild(Widget("undernumber"))

	self.topperanim = self.underNumber:AddChild(UIAnim())
    self.topperanim:GetAnimState():SetBank("wet")
    self.topperanim:GetAnimState():SetBuild("wet_meter_player")
    self.topperanim:SetClickable(false)

	self.vigourarrow = self.underNumber:AddChild(UIAnim())
	self.vigourarrow:GetAnimState():SetBank("sanity_arrow")
	self.vigourarrow:GetAnimState():SetBuild("sanity_arrow")
	self.vigourarrow:GetAnimState():PlayAnimation("neutral")
	self.vigourarrow:SetClickable(false)

    self.num = self:AddChild(Text(NUMBERFONT, 33, "120", {255, 0, 0, 1}))
    self.num:SetHAlign(ANCHOR_MIDDLE)
    self.num:SetPosition(3.5, 1, 0)
    self.num:Hide()

    self.owner = owner
	self.arrowdir = "neutral"
	owner.vigourarrow = self.vigourarrow
   
	self:StartUpdating()
end)

function VigourBadge:SetPercent(percent, maximum_1)
	local pct = percent or 1
		
		if pct <= 0.2 then
			self:StartWarning(1, 145/255, 0.5, 1)
		else
			self:StopWarning()
		end
		
		Badge.SetPercent(self, pct, 360)	
		
        local fillImageNumber = math.floor(math.clamp((1-pct)*21,0,21))
		self.fill:SetTexture("images/replace_res/vigourbadge/vigour_level-"..fillImageNumber..".xml", "vigour_level-"..fillImageNumber..".tex")
        self.fill:SetPosition(-1.5, -24*(1-pct)-1.5, 0)
		self.fill:SetScale(1.05,1.05,1.05)
		--local scalestatus = 1
		self.bg:SetScale(1.13,1.13,1.13)

		if pct > 0.7 then
			self.status:SetTexture("images/replace_res/vigourbadge/vigourstatus-0.xml", "vigourstatus-0.tex")
			self.status:SetScale(1,1,1)
			self.status:SetPosition(0, 0, 0)
		elseif pct>0.5 then
			self.status:SetTexture("images/replace_res/vigourbadge/vigourstatus-1.xml", "vigourstatus-1.tex")
			self.status:SetScale(1,1,1)
			self.status:SetPosition(0, 0, 0)
		elseif pct>0.25 then
			self.status:SetTexture("images/replace_res/vigourbadge/vigourstatus-2.xml", "vigourstatus-2.tex")
			self.status:SetScale(0.8,0.8,0.8)
			self.status:SetPosition(0, 0, 0)

		else
			self.status:SetTexture("images/replace_res/vigourbadge/vigourstatus-3.xml", "vigourstatus-3.tex")
			self.status:SetScale(0.8,0.8,0)
			self.status:SetPosition(0, 0, 0)
		end

		--不能动态加载?
        --self.status:SetScale(scalestatus,scalestatus,0)
		self.num:SetPosition(3.5, 1, 0)
		self.num:SetString(tostring(math.ceil(pct * 360)))
        

        --兼容combinedstatus mod 
		if KnownModIndex:IsModEnabled("workshop-574636989") then
			self.num:Show()
			self.num:SetPosition(2, -40, 0)
			self.num:SetScale(0.75, 0.75, 0.75)
			if self.show_progress then
				if self.show_remaining then
					self.maxnum:SetString(tostring(math.floor(pct * 360)))
				end
			else
		    		self.maxnum:SetString(tostring(360))
			end
		else
			self.num:SetPosition(3.5, 1, 0)
		end

		--vigourbuff动画
		local rate = GetPlayer().components.vigour:GetRate()
	
		local small_down = .02
		local med_down = .1
		local large_down = .3
		local small_up = .01
		local med_up = .1
		local large_up = .2
		local anim = nil
		anim = "neutral"
		if rate > 0  then
			if rate > large_up then
				anim = "arrow_loop_increase_most"
			elseif rate > med_up then
				anim = "arrow_loop_increase_more"
			elseif rate > small_up then
				anim = "arrow_loop_increase"
			end
		elseif rate < 0  then
			if rate < -large_down then
				anim = "arrow_loop_decrease_most"
			elseif rate < -med_down then
				anim = "arrow_loop_decrease_more"
			elseif rate < -small_down then
				anim = "arrow_loop_decrease"
			end
		end
		
		if anim and self.arrowdir ~= anim then
			self.arrowdir = anim
			self.vigourarrow:GetAnimState():PlayAnimation(anim, true)
		end
end


--空接口,兼容用
function VigourBadge:OnUpdate(dt)
   
end

return VigourBadge





