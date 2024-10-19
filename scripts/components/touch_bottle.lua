local Touch_Bottle = Class(function(self, inst)
    self.inst = inst
end)

function Touch_Bottle:CollectInventoryActions(doer, actions)
    if doer.components.arcueidbuff ~= nil
        and ((doer.components.arcueidbuff.buff_modifiers_add_timer['buff_bottlelight'] ~= nil
                and doer.components.arcueidbuff.buff_modifiers_add_timer['buff_bottlelight'] == 0)
            or doer.components.arcueidbuff.buff_modifiers_add_timer['buff_bottlelight'] == nil)
    then
        table.insert(actions, ACTIONS.TOUCH_BOTTLE)
    end
end

return Touch_Bottle
