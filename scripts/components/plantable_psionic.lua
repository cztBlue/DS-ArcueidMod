-- 种子组件，灵化种子专用

local Plantable = Class(function(self, inst)
  self.inst = inst
  self.growtime = 2500
  self.product = function()
    local product_ = { 'psionic_holypetal', 'psionic_thirstyfruit', 'psionic_gorypetal' }
    return product_[math.random(10000) % 3 + 1]
  end
  self.minlevel = 1
end)

function Plantable:CollectUseActions(doer, target, actions)
  if target.components.grower_psionic and target.components.grower_psionic:IsEmpty() and target.components.grower_psionic.level >= self.minlevel then
    table.insert(actions, ACTIONS.PLANT_PSIONIC)
  end
end

return Plantable
