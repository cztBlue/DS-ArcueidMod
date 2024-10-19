local NORMALACTION = Class(function(self, inst)
    self.inst = inst
end)

--使用这个组件将功能函数写在inst.normalactionfn中
function NORMALACTION:CollectInventoryActions(doer, actions)
    if doer.prefab == "arcueid"
    then
        table.insert(actions, ACTIONS.ARCUEID_NORMAL)
    end
end

return NORMALACTION