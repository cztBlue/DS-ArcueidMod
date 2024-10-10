local LiZhuang = Class(function(self, inst)
    self.inst = inst
end)

function LiZhuang:CollectInventoryActions(doer, actions)
    if doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil and
        (doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab == "dress_ice"
        or doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab == "dress_redmoon"
    ) then
        table.insert(actions, ACTIONS.REMOVE_LI)
    else
        table.insert(actions, ACTIONS.EQUIP_LI)
    end
end

return LiZhuang
