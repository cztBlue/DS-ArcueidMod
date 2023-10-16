local EditScreen 	= require "widgets/editscreen"
local SignableTag = "signable"

local function gettext(inst, viewer)
    local text = inst and inst.components.signable and inst.components.signable:GetText()
    if not text then
    	text = "未写入锚点"
    end
    return text
end

local function OnBuilt(inst, data)
	if inst and inst.components.signable then
    	inst.components.signable:OnSign()
	end
end

local Signable = Class(function(self, inst)
	self.inst = inst
	self.text = nil
	self.signed = false
	
	self.inst.components.inspectable.description = gettext
    self.inst:ListenForEvent("onbuilt", OnBuilt)
    
    self.inst:AddTag(SignableTag)
end)

function Signable:CollectSceneActions(doer, actions, right)
	if not self.signed and not right then
		 table.insert(actions, ACTIONS.EDIT)
	end
end

function Signable:OnSave()
    local data = {}
    data.text = self.text
    return data
end

function Signable:OnLoad(data)
    self.text = data.text
    if self.text then
    	self.signed = true
    end
end

function Signable:GetText()
    return self.text
end

function Signable:SetText(text)
    self.text = text
end

function Signable:OnSign()
	if not self.signed then
		TheFrontEnd:PushScreen(EditScreen(self.inst))
	elseif self.inst and self.inst.components and self.inst.components.talker then
		self.inst.components.talker:Say(self.text)
	end
end

return Signable