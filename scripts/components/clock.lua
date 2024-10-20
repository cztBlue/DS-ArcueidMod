local NIGHT_COLOR = Point(0/255,   0/255,   0/255)
local FULLMOON_COLOR = Point(84/255,  122/255, 156/255)

local LERP_BACK_LIGHTINING_TIME = 1

local Clock = Class(function(self, inst)

	self.daysegs = TUNING.DAY_SEGS_DEFAULT
	self.nightsegs = TUNING.NIGHT_SEGS_DEFAULT
	self.dusksegs = TUNING.DUSK_SEGS_DEFAULT
	
    self.inst = inst
    self.task = nil
    self.numcycles = 0
    self.departure_day = 0
    self.lmax = 1

    self.dayColour =         Point(255/255, 230/255, 158/255) -- This isn't being used any longer: now use GetDayColour to do special casing for Spring
    self.duskColour =        Point(150/255, 150/255, 150/255) -- This isn't being used any longer: now use GetDuskColour to do special casing for Spring
    self.nightColour =       NIGHT_COLOR
    self.fullMoonColour =    FULLMOON_COLOR
    self.caveColour =        Point(0/255,   0/255,   0/255)
    self.dayNightVisionColour =         Point(200/255,  200/255, 200/255)
    self.duskNightVisionColour =        Point(120/255,  120/255, 120/255)
    self.nightNightVisionColour =       Point(200/255,  200/255, 200/255)
    self.fullMoonNightVisionColour =    Point(200/255,  200/255, 200/255)
    self.caveNightVisionColour =        Point(200/255,  200/255, 200/255)

    self.currentColour = self.dayColour
    self.lerpToColour = self.dayColour
    self.lerpFromColour = self.dayColour
    
    if GetWorld():IsCave() then
        self.currentColour = self.caveColour
        self.lerpToColour = self.caveColour
        self.lerpFromColour = self.caveColour
    end

    self.lerptimeleft = 0
    self.totallerptime = 0
    self.override_timeLeftInEra = nil
    
	self.inst:StartUpdatingComponent(self)	

    self.previous_phase = "night"
    self.nightvision = false
    self.lightningdisabled = false 

    self:StartDay()

    self.bloodmoon_active = false

--[[
    self.onupdateAmibentColorfn = function(inst,data)
        self:updateAmibentColor(data.instant) 
    end
]]
--    self.inst:ListenForEvent("onchangecanopyzone", function(data) self:updateAmibentColor(data.instant) end )

    self.inst:ListenForEvent("exitinterior", function(data) self:onExitInterior(data) end )
    self.inst:ListenForEvent("enterinterior", function(data) self:onEnterInterior(data) end )
    
end)

function Clock:onEnterInterior(data)
    self:updateAmibentColor(true) 
    --print("CLOCK: ENTERING INTERIOR")
end


function Clock:onExitInterior(data)
    self:updateAmibentColor(true) 
    --print("CLOCK: EXITING INTERIOR")
end


function Clock:GetTotalTime()
	return (self.numcycles + self:GetNormTime()) * TUNING.TOTAL_DAY_TIME
end


local function GetFullMoonColour()
    if TheCamera.interior then
        return NIGHT_COLOR
    elseif GetPlayer() and false and GetPlayer():HasTag("under_leaf_canopy")then
        return NIGHT_COLOR
    else
        return FULLMOON_COLOR
    end
end

local function GetDuskColour()
    if TheCamera.interior then
        return NIGHT_COLOR
    else
        return Point(150/255, 150/255, 150/255)
    end
    --[[ elseif GetPlayer() and false and GetPlayer():HasTag("under_leaf_canopy") then
        return Point(40/255, 40/255, 40/255)
    else        
        if GetSeasonManager() and GetSeasonManager():IsSpring() then
            return Point(100/255, 100/255, 100/255)--Point(171/255, 146/255, 147/255)
        else
            return Point(100/255, 100/255, 100/255)--Point(100/255, 100/255, 100/255)
        end
    end ]]
end

local function GetDayColour()
    if TheCamera.interior then
        return NIGHT_COLOR
    else
        return Point(255/255, 230/255, 158/255)
    end
    --[[ elseif GetPlayer() and false and GetPlayer():HasTag("under_leaf_canopy") then
        if GetSeasonManager() and GetSeasonManager():IsSpring() then
            return Point(100/255, 100/255, 100/255)--Point(171/255, 146/255, 147/255)
        else
            return Point(100/255, 100/255, 100/255)--Point(100/255, 100/255, 100/255)
        end
    else 
        local sm = GetSeasonManager()
        if sm and sm:IsSpring() then
            return Point(255/255, 230/255, 158/255)--Point(255/255, 244/255, 213/255)
        elseif sm and sm:IsMildSeason() then
            return Point(255/255, 230/255, 158/255)--Point(255/255, 255/255, 255/255)
        elseif sm and sm:IsWetSeason() then
            return Point(255/255, 230/255, 158/255)--Point(191/255, 191/255, 191/255)
        elseif sm and sm:IsGreenSeason() then
            return Point(255/255, 230/255, 158/255)--Point(210/255, 210/255, 210/255)
        elseif sm and sm:IsDrySeason() then
            return Point(255/255, 230/255, 158/255)--Point(255/255, 225/255, 225/255)
        else
            return Point(255/255, 230/255, 158/255)--Point(255/255, 230/255, 158/255)
        end
    end ]]
end

function Clock:GetTimeLeftInEra()
	return self.timeLeftInEra
end

function Clock:GetDebugString()
    return string.format("%d %s: %2.2f ", self.numcycles+1, self.phase, self:GetTimeLeftInEra())
end

function Clock:OnSave()
	local departure_day = 0
	if GetPlayer() and GetPlayer().components.age then
		departure_day = GetPlayer().components.age:GetAge()
	end

	return
	{
		numcycles = self.numcycles,
		phase = self.phase,
		normeratime = self:GetNormEraTime(),
		normdaytime = self:GetNormTime(), -- Used in the game logic
		nightvision = self.nightvision,
		lightningdisabled = self.lightningdisabled,
		departure_day = departure_day,
        currentColourR = self.currentColour.x,
        currentColourG = self.currentColour.y,
        currentColourB = self.currentColour.z,
        bloodmoon_active = self.bloodmoon_active,
	}
end

function Clock:OnLoad(data)
	self.numcycles = data.numcycles or 0
    
    if data.departure_day ~= nil then
        self:SetDepartureDay(data.departure_day)
    end

    if data.currentColourR then
        self.currentColour = Point(data.currentColourR,data.currentColourG,data.currentColourB)
        local p = GetSeasonManager() and GetSeasonManager():GetWeatherLightPercent() or 1
        TheSim:SetAmbientColour( p*self.currentColour.x, p*self.currentColour.y, p*self.currentColour.z )
    end

    if data.phase  == "night" then
        self:StartNight(true)
    elseif data.phase  == "dusk" then
        self:StartDusk(true)
    else 
        self:StartDay(true)
    end

    if data.nightvision then
        self:StartNightVision(true)
    end
    if data.lightningdisabled ~= nil then 
        self.lightningdisabled = data.lightningdisabled
    end 

	local normeratime = data.normeratime or 0
	self:SetNormEraTime(normeratime)

    self.bloodmoon_active = data.bloodmoon_active

    self.inst:DoTaskInTime(0,function() self:updateAmibentColor(true) end)
end


function Clock:Reset()
    self.numcycles = 0
    self:StartDay()
end


local moonphases = 
{
    "new",
    "quarter",
    "half",
    "threequarter",
    "full",
}

function Clock:SetBloodMoon(active)
    self.bloodmoon_active = active
end

function Clock:GetBloodMoon()
    return self.bloodmoon_active
end

function Clock:GetMoonPhase()
    if self.bloodmoon_active then
        return "full"
    end

    local phaselength = 2
    local n = #moonphases-1
    
    local idx = math.floor(self.numcycles/phaselength) % (2*n)
    
    if idx >= n then
        idx = n*2 - idx
    end
    
    return moonphases[idx+1]
end

function Clock:SetSegsMidEra(day, dusk, night, override_phase, override_totalEraTime, post_override)
    assert(day + dusk + night == 16, "invalid number of time segs")

    local norm_time = self:GetNormTime() 

    self.daysegs = day
    self.dusksegs = dusk
    self.nightsegs = night
    
    
    if self.phase == "day" then
        self.totalEraTime = self.daysegs*TUNING.SEG_TIME
    elseif self.phase == "dusk" then
        self.totalEraTime = self.dusksegs*TUNING.SEG_TIME
    else
        self.totalEraTime = self.nightsegs*TUNING.SEG_TIME
    end
    
    self:SetNormEraTime(norm_time, override_phase, override_totalEraTime)
    self.inst:PushEvent("daysegschanged")
end

function Clock:SetNormEraTime(percent, override_phase, override_totalEraTime)

    if override_phase then
        self.phase = override_phase
        self.previous_phase = override_phase
    end

    if self.phase == "day" then
        self.totalEraTime = self:GetDayTime()
    elseif self.phase == "dusk" then
        self.totalEraTime = self:GetDuskTime()
    else
        self.totalEraTime = self:GetNightTime()
    end

    local temptotal = self.totalEraTime

    -- Used mostly for the aporkalypse
    -- This alows us to set segs in the middle of an era without funky behaviour
    if override_totalEraTime then 
        local fullday = self:GetDayTime() + self:GetDuskTime() + self:GetNightTime()
        local mult = fullday / temptotal

        percent = percent * mult
    end

    self.timeLeftInEra = (1-percent)*temptotal
end

function Clock:GetTimeInEra()
    return self.totalEraTime - self.timeLeftInEra 
end

function Clock:GetNormEraTime()
    local ret = self.totalEraTime > 0 and (1 - self.timeLeftInEra / self.totalEraTime) or 1
    return ret
end

function Clock:GetNormTime()
    if self.phase == "day" then
		return (self.daysegs / 16)*self:GetNormEraTime()
    elseif self.phase == "dusk" then
		return (self.daysegs / 16) + (self.dusksegs / 16)*self:GetNormEraTime()
    else
		return (self.daysegs / 16) + (self.dusksegs / 16) + (self.nightsegs / 16)*self:GetNormEraTime()
    end
end

function Clock:GetNormTimeForPhase(phase)
    if phase == "day" then
        return (self.daysegs / 16)*self:GetNormEraTime()
    elseif phase == "dusk" then
        return (self.daysegs / 16) + (self.dusksegs / 16)*self:GetNormEraTime()
    else
        return (self.daysegs / 16) + (self.dusksegs / 16) + (self.nightsegs / 16)*self:GetNormEraTime()
    end 
end

function Clock:GetPhaseByCurrentNormEraTime(norm_era_time)
    if norm_era_time < (self.daysegs / 16) then
        return "day"
    elseif norm_era_time < (self.daysegs / 16) + (self.dusksegs / 16) then
        return "dusk"
    else
        return "night"
    end
end


function Clock:GetPhaseByNormEraTime(norm_era_time, daysegs, dusksegs, nightsegs)
    if norm_era_time < (daysegs / 16) then
        return "day"
    elseif norm_era_time < (daysegs / 16) + (dusksegs / 16) then
        return "dusk"
    else
        return "night"
    end
end

function Clock:SetNormTime(percent)
    local norm_day_time = self:GetDayTime()/TUNING.TOTAL_DAY_TIME
    local norm_dusk_time = (self:GetDuskTime()/TUNING.TOTAL_DAY_TIME)
    local norm_night_time = (self:GetNightTime()/TUNING.TOTAL_DAY_TIME)

    if percent < norm_day_time then
        self:StartDay(true)
        self:SetNormEraTime(percent/norm_day_time)
	elseif percent < norm_dusk_time + norm_day_time then
		self:StartDusk(true)
		percent = percent - norm_day_time
		self:SetNormEraTime(percent/norm_dusk_time)
	else
		self:StartNight(true)
		percent = percent - norm_dusk_time - norm_day_time
		self:SetNormEraTime(percent/norm_night_time)
    end
end

function Clock:CurrentPhaseIsAlways()
    if self.phase == "day" then
        return self:GetDaySegs() == 16
    elseif self.phase == "dusk" then
        return self:GetDuskSegs() == 16
    else
        return self:GetNightSegs() == 16
    end
end

function Clock:SetNightVision(on)
    if on then
        self.nightvision = true
        self:StartNightVision()
    else
        self.nightvision = false
        if self.phase == "day" then
            self:StartDay(true, true)
        elseif self.phase == "dusk" then
            self:StartDusk(true, true)
        else
            self:StartNight(true, true)
        end
    end
end

function Clock:IsNightVision()
    return self.nightvision
end

function Clock:IsDay()
    return self.phase == "day"
end

function Clock:IsNight()
    return self.phase == "night"
end

function Clock:IsDusk()
    return self.phase == "dusk"
end

function Clock:GetPhase()
	return self.phase
end

function Clock:GetNextPhase()
    if self:CurrentPhaseIsAlways() then
        if self.phase == "day" then
            return "day"
        elseif self.phase == "dusk" then
            return "dusk"
        end

        return "night"
     end

	if self.phase == "day" then
		return "dusk"
	elseif self.phase == "dusk" then
		return "night"
	else
		return "day"
	end
end

function Clock:GetPrevPhase()
    if self:CurrentPhaseIsAlways() then
        if self.phase == "day" then
            return "day"
        elseif self.phase == "dusk" then
            return "dusk"
        end
        
        return "night"
    end

	if self.phase == "day" then
		return "night"
	elseif self.phase == "dusk" then
		return "day"
	else
		return "dusk"
	end
end

function Clock:MakeNextDay()
	local time_left = TUNING.TOTAL_DAY_TIME * (1 - self:GetNormTime())
	LongUpdate(time_left + TUNING.SEG_TIME*.5)
	
	--self.numcycles = self.numcycles +1
    --self.inst:PushEvent("daycomplete", {day= self.numcycles})
    --self:StartDay()
end

function Clock:MakeNextDusk()
    if self:IsDay() then
        LongUpdate(self.timeLeftInEra + TUNING.SEG_TIME*.5)
    end
end

function Clock:NextPhase()
    if self:CurrentPhaseIsAlways() then
        self.numcycles = self.numcycles +1
        self.inst:PushEvent("daycomplete", {day= self.numcycles})

        if self.phase == "day" then
            self:StartDay()
        elseif self.phase == "dusk" then
            self:StartDusk()
        else
            self:StartNight()
        end

        return
    end

    if self.phase == "day" then
        self:StartDusk()
    elseif self.phase == "dusk" then
        self:StartNight()
    else
        self.numcycles = self.numcycles +1
        self.inst:PushEvent("daycomplete", {day= self.numcycles})
        self:StartDay()
    end
end

function Clock:GetDaySegs()
	return self.daysegs
end

function Clock:GetNightSegs()
	return self.nightsegs
end

function Clock:GetDuskSegs()
	return self.dusksegs
end

function Clock:SetSegs(day, dusk, night)
	assert(day + dusk + night == 16, "invalid number of time segs")

	local norm_time = self:GetNormEraTime()
	
	self.daysegs = day
	self.dusksegs = dusk
	self.nightsegs = night
	
	if self.phase == "day" then
		self.totalEraTime = self.daysegs*TUNING.SEG_TIME
	elseif self.phase == "dusk" then
		self.totalEraTime = self.dusksegs*TUNING.SEG_TIME
	else
		self.totalEraTime = self.nightsegs*TUNING.SEG_TIME
	end
	
	self:SetNormEraTime(norm_time)
	self.inst:PushEvent("daysegschanged")
end

function Clock:SetLightningFlashEnabled(enabled)
    self.lightningdisabled = not enabled 
end 

function Clock:DoLightningLighting(maxlight)
    if not self.lightningdisabled then 
        self.lightning = true
        self.lightningtime = 0
        self.lmax = maxlight or 1
    end 
end

function Clock:LongUpdate(dt)
	self:OnUpdate(dt)

	--fix the colour
	self.lerptimeleft = 0
    
	if self:IsDay() then
		self.currentColour = self:IsNightVision() and self.dayNightVisionColour or GetDayColour()
	elseif self:IsDusk() then
        self.currentColour = self:IsNightVision() and self.duskNightVisionColour or GetDuskColour()
	else
        if self:GetMoonPhase() == "full" then
            self.currentColour = self:IsNightVision() and self.fullMoonNightVisionColour or GetFullMoonColour()
        else
		  self.currentColour = self:IsNightVision() and self.nightNightVisionColour or self.nightColour
        end
	end
	
    if GetWorld():IsCave() then
        self.currentColour = self:IsNightVision() and self.caveNightVisionColour or self.caveColour
    end
    
	local p = GetSeasonManager() and GetSeasonManager():GetWeatherLightPercent() or 1
	TheSim:SetAmbientColour( p*self.currentColour.x, p*self.currentColour.y, p*self.currentColour.z )
end
local sum = 0
function Clock:OnUpdate(dt)
    --改动了
    -- self.daysegs = 0
	-- self.nightsegs = 0
	-- self.dusksegs = 16

    

    -- print(self.totalEraTime)
    -- print(self.timeLeftInEra)
    -- print(self.numcycles)
    -- print("---------------")
    -- sum = sum + dt
    -- if sum > 5 then
    --     self:SetSegs(0,0,16)
    --     sum = -1000000
    -- end
    

	self.timeLeftInEra = self.timeLeftInEra - dt
	
	if self.override_timeLeftInEra ~= nil then
    	self.timeLeftInEra = self.override_timeLeftInEra
	end
    
    if self.timeLeftInEra <= 0 then
        local time_left_over = -self.timeLeftInEra
        self:NextPhase()
        
        if time_left_over > 0 then
			self:OnUpdate(time_left_over)
			return
        end
        
    end
    
    if self.lerptimeleft > 0 then
        local percent = 1 - (self.lerptimeleft / self.totallerptime)
        local r = percent*self.lerpToColour.x + (1 - percent)*self.lerpFromColour.x
        local g = percent*self.lerpToColour.y + (1 - percent)*self.lerpFromColour.y
        local b = percent*self.lerpToColour.z + (1 - percent)*self.lerpFromColour.z
        self.currentColour = Point(r,g,b)

        if GetWorld():IsCave() then
            self.currentColour = self:IsNightVision() and self.caveNightVisionColour or self.caveColour
        end

        self.lerptimeleft = self.lerptimeleft - dt

    elseif self.lightning_dirty then
        if self.totallerptime == LERP_BACK_LIGHTINING_TIME then
            -- Hack: The "self:LerpAmbientColour(flash, col, LERP_BACK_LIGHTINING_TIME)" never reaches the value it should.
            self.currentColour = self.lerpToColour
        end

        self.lightning_dirty = false
    end

    if self.lightning then
        
        self.lightningtime = self.lightningtime + dt

        local set = SCREEN_FLASH_SCALING[Profile:GetScreenFlash() or 1]
        
        local function calcflash(x)
            return x > 0.8 and (x - 0.25*set)
                or ((x-1)*(1-set) + 1)            
        end

        local col = nil

        if self:IsNight() then
            if self:GetMoonPhase() == "full" and not GetWorld():IsCave() then
                col = self:IsNightVision() and self.fullMoonNightVisionColour or self.fullMoonColour
            else
                col = self:IsNightVision() and self.nightNightVisionColour or self.nightColour
            end
        elseif self:IsDusk() then
            col = self:IsNightVision() and self.duskNightVisionColour or GetDuskColour()
        else
            col = self:IsNightVision() and self.dayNightVisionColour or GetDayColour()
        end

        local flash = deepcopy( col )
        flash.x = calcflash(flash.x)
        flash.y = calcflash(flash.y)
        flash.z = calcflash(flash.z)

        if self.lightningtime < (1/30)*1 then 
            TheSim:SetAmbientColour(flash.x,flash.y,flash.z)
        else          
            self:LerpAmbientColour(flash, col, LERP_BACK_LIGHTINING_TIME)
            self.lightning = false
            self.lightning_dirty = true
            self.last_lightning_time = GetTime()
        end

    else
        -- if GetWorld():IsCave() then            
        --     return
        -- end

        -- If night just started, lerp instead of instant color change
        if self:IsNight() and (self.totalEraTime - self.timeLeftInEra) <= 8 and self.last_lightning_time and (GetTime() - self.last_lightning_time) <= dt then
            if self:GetMoonPhase() ~= "full" and not GetWorld():IsCave() then
                if not self:IsNightVision() then 
                    self:LerpAmbientColour(GetDuskColour(), self.nightColour, 4)
                end
            end
        else
            local p = GetSeasonManager() and GetSeasonManager():GetWeatherLightPercent() or 1
            TheSim:SetAmbientColour( p*self.currentColour.x, p*self.currentColour.y, p*self.currentColour.z )
        end
    end


	self.inst:PushEvent("clocktick", {phase = self.phase, normalizedtime=self:GetNormTime(), dt = dt})
	
end

function Clock:LerpAmbientColour(src, dest, time)
	self.lerptimeleft = time
	self.totallerptime = time

    if GetWorld():IsCave() then
        dest = self:IsNightVision() and self.caveNightVisionColour or self.caveColour
    end

    if time == 0 then
		self.currentColour = dest
    else
		self.lerpFromColour = src
		self.lerpToColour = dest
	end

    local p = GetSeasonManager() and GetSeasonManager():GetWeatherLightPercent() or 1
    if not self.currentColour then
		self.currentColour = src
    end
    TheSim:SetAmbientColour( p*self.currentColour.x, p*self.currentColour.y, p*self.currentColour.z )
end

function Clock:updateAmibentColor(instant)

   if self.phase == "day" then
        if not self:IsNightVision() then         
            self:LerpAmbientColour(self.currentColour, GetDayColour(), instant and 0 or 4) 
        else
            self:LerpAmbientColour(self.currentColour, self.dayNightVisionColour, instant and 0 or 4) 
        end
    elseif self.phase == "dusk" then        
        if not self:IsNightVision() then 
            self:LerpAmbientColour(self.currentColour, GetDuskColour(), instant and 0 or 6) 
        else
            self:LerpAmbientColour(self.currentColour, self.duskNightVisionColour, instant and 0 or 6) 
        end
    else
        if self:GetMoonPhase() == "full" and not GetWorld():IsCave() then
            if not self:IsNightVision() then 
                self:LerpAmbientColour(self.currentColour, GetFullMoonColour(), instant and 0 or 8) 
            else
                self:LerpAmbientColour(self.currentColour, self.fullMoonNightVisionColour, instant and 0 or 8) 
            end
        else
            if not self:IsNightVision() then 
                self:LerpAmbientColour(self.currentColour, self.nightColour, instant and 0 or 8) 
            else
                self:LerpAmbientColour(self.currentColour, self.nightNightVisionColour, instant and 0 or 8) 
            end
        end        
    end

end

function Clock:__tostring()
    return string.format("%s cycle:%d (%2.2f) %2.2f", self.phase, self.numcycles, self.timeLeftInEra, self:GetNormTime())
end

function Clock:ToMetricsString()
	-- the metrics value must be an int so we have to convert
	
	-- phase day- 1 , dusk- 2, night -3
	local timeofday = 1
	if self.phase == "dusk" then
		timeofday = 2
	elseif self.phase == "night" then
		timeofday = 3
	end
	
	-- numcycles 000-999
	-- time 000 normtime*100
	local time = math.floor(self:GetNormTime()*100)
	
    return string.format("%d%03d%03d", timeofday, self.numcycles, time)
end

function Clock:GetDayTime()
	return self.daysegs*TUNING.SEG_TIME
end

function Clock:GetNightTime()
	return self.nightsegs*TUNING.SEG_TIME
end

function Clock:GetDuskTime()
	return self.dusksegs*TUNING.SEG_TIME
end

function Clock:StartNightVision(instant)   
    self.inst:PushEvent("nightvision")
    
    local colour = nil
    if GetWorld():IsCave() then
        colour = self.caveNightVisionColour
    elseif self.phase == "day" then
        colour = self.dayNightVisionColour
    elseif self.phase == "dusk" then
        colour = self.duskNightVisionColour
    else
        colour = self.nightNightVisionColour
    end
    self:LerpAmbientColour(self.currentColour, colour or self.nightNightVisionColour, instant and 0 or 4)
end

function Clock:StartDay(instant, fromnightvision)

    if not fromnightvision then
        self.timeLeftInEra = self:GetDayTime()
        self.totalEraTime = self.timeLeftInEra
        
        
        self.phase = "day"
        self.inst:PushEvent("daytime", {day=self.numcycles})
        if self.daytime == 0 then
        	self:NextPhase()    	
        	return
        end
    end
    
    if self.phase ~= self.previous_phase or fromnightvision then
        self.previous_phase = self.phase
        if not self:IsNightVision() then 
            self:LerpAmbientColour(self.currentColour, GetDayColour(), instant and 0 or 4) 
        else
            self:LerpAmbientColour(self.currentColour, self.dayNightVisionColour, instant and 0 or 4) 
        end
	end
end

function Clock:GetEraPercent()
    local perc = self.timeLeftInEra/self.totalEraTime --this is the percent left
    return 1.0 - perc --We want to return the percent completed
end 

function Clock:StartDusk(instant, fromnightvision)
    if not fromnightvision then
        self.timeLeftInEra = self:GetDuskTime()    
        self.totalEraTime = self.timeLeftInEra
        
        self.phase = "dusk"
        if self.dusktime == 0 then
        	self:NextPhase()
        	return
        end
    end

    if self.phase ~= self.previous_phase or fromnightvision then
        self.previous_phase = self.phase
    	if not self:IsNightVision() then 
            self:LerpAmbientColour(self.currentColour, GetDuskColour(), instant and 0 or 6) 
        else
            self:LerpAmbientColour(self.currentColour, self.duskNightVisionColour, instant and 0 or 6) 
        end

        local new = not fromnightvision
    	self.inst:PushEvent("dusktime", {day=self.numcycles, newdusk=new})
	end
end

function Clock:StartNight(instant, fromnightvision)
    if not fromnightvision then
        self.timeLeftInEra = self:GetNightTime()
        self.totalEraTime = self.timeLeftInEra
    
        self.phase = "night"
        self.inst:PushEvent("nighttime", {day=self.numcycles})
        if self.nighttime == 0 then
        	self:NextPhase()
        	return
        end
    end
    
    if self.phase ~= self.previous_phase or fromnightvision then
        self.previous_phase = self.phase
        
        if self:GetMoonPhase() == "full" and not GetWorld():IsCave() then
            if not self:IsNightVision() then 
                self:LerpAmbientColour(self.currentColour, GetFullMoonColour(), instant and 0 or 8) 
            else
                self:LerpAmbientColour(self.currentColour, self.fullMoonNightVisionColour, instant and 0 or 8) 
            end
            self.inst:PushEvent("fullmoon")
        else
            if not self:IsNightVision() then 
                self:LerpAmbientColour(self.currentColour, self.nightColour, instant and 0 or 8) 
            else
                self:LerpAmbientColour(self.currentColour, self.nightNightVisionColour, instant and 0 or 8) 
            end
        end
	end
end

function Clock:LerpFactor()
	if self.totallerptime == 0 then
		return 1
	else
		return math.min( 1.0, 1.0 - self.lerptimeleft / self.totallerptime )
	end
end

function Clock:GetNumCycles()
    return self.numcycles
end

function Clock:SetDepartureDay(day)
    self.departure_day = day
end

function Clock:GetDepartureDay(day)
    return self.departure_day or 0
end

return Clock