local Arcequip = Class(function(self, inst)
    self.inst = inst
end)

function Arcequip:CollectSceneActions(doer, actions, right)
    local weapon = doer.components.combat:GetWeapon()
    if doer:HasTag("arcueid") and right and (not weapon) then
        if not(doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil
		and doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab == "dress_ice") then
            table.insert(actions, ACTIONS.SHARPCLAW_EQUIP)
        end
    end
end

return Arcequip