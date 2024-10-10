local Plantable = Class(function(self, inst)
  self.inst = inst
  self.growtime = 120
  self.product = function (a)
    local product_ = {'psionic_holypetal','psionic_thirstyfruit','psionic_gorypetal'}
    return product_[math.random(10000)%3 + 1]
  end
  self.minlevel = 1
end)

-- if target.components.grower and target.components.grower:IsEmpty() and target.components.grower:IsFertile() and target.components.grower.level >= self.minlevel then
--   table.insert(actions, ACTIONS.PLANT)
-- elseif target.components.growable and target.components.growable:GetCurrentStageData().name == "plantable" then
--   table.insert(actions, ACTIONS.PLANTONGROWABLE)
-- end

function Plantable:CollectUseActions(doer, target, actions)
  -- if target.components.grower_psionic and target.components.grower_psionic:IsEmpty() and target.components.grower_psionic:IsFertile() and target.components.grower_psionic.level >= self.minlevel then
  if target.components.grower_psionic and target.components.grower_psionic:IsEmpty() and target.components.grower_psionic.level >= self.minlevel then
    table.insert(actions, ACTIONS.PLANT_PSIONIC)
  end
end

return Plantable
