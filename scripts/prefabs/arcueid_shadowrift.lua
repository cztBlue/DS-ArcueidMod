local rift_assets =
{
    Asset("ANIM", "anim/shadowrift_portal.zip"),
}

function CreateParticleFx(inst,ox)
    inst:AddChild(ox)
    return ox
end

local function rift_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()

    MakeObstaclePhysics(inst, .5)
    inst.Physics:SetCylinder(.5, 6)

    inst.MiniMapEntity:SetIcon("shadow_rift.tex")

    inst.AnimState:SetBank("shadowrift_portal")
    inst.AnimState:SetBuild("shadowrift_portal")
    inst.AnimState:PlayAnimation("stage_1_pre")
    inst.AnimState:PushAnimation("stage_1_loop", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetLightOverride(0.5)

    inst:AddComponent("inspectable")
    inst:AddComponent("rotationupdater")

    inst._fx1 = CreateParticleFx(inst,SpawnPrefab("arcueid_shadow_rift_fx"))
    local ball = SpawnPrefab("eye_charge")
    ball.persists = true
    ball.AnimState:PlayAnimation("idle",true)
    inst._fx2 = CreateParticleFx(inst,ball)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(1200)

    inst._fx2:AddComponent("combat")
    inst._fx2.components.combat:SetOnHit(function () end)
    inst._fx2.components.combat:SetRange(20)
	inst._fx2.components.combat:SetDefaultDamage(1)
	inst._fx2.components.combat:SetAttackPeriod(2)

    inst._fx2:AddComponent("inventory")
	inst:DoTaskInTime(0, function(inst)
		if inst._fx2.components.inventory and not inst._fx2.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
			local weapon = CreateEntity()
			weapon.entity:AddTransform()
			weapon:AddComponent("weapon")
			weapon.components.weapon:SetDamage(1)
			weapon.components.weapon:SetRange(8, 10)
			weapon.components.weapon:SetProjectile("eye_charge")
			weapon:AddComponent("inventoryitem")
			weapon.persists = false
			weapon.components.inventoryitem:SetOnDroppedFn(function(inst) inst:Remove() end)
			weapon:AddComponent("equippable")

			inst._fx2.components.inventory:Equip(weapon)
		end
	end)

    inst.diff = 0
    inst.store = 4

    inst:DoPeriodicTask(0.5, function(inst)
        local dist = inst:GetDistanceSqToInst(GetPlayer())
        inst.diff = inst.diff + 1
        -- print(dist)

        -- 亮炮
        if dist and dist < 330 then
            inst._fx2.AnimState:SetMultColour(1, 1, 1, 1)
        else
            inst._fx2.AnimState:SetMultColour(0,0,0,0)
        end

        -- 刷怪
        if dist and dist < 240 and inst.store > 0 then
            -- local sp = SpawnPrefab("nightmarebeak")
            -- sp.Transform:SetPosition(inst.Transform:GetWorldPosition())
            -- sp.components.combat:SetTarget(GetPlayer())
            -- inst.store = inst.store - 1
        end

        -- 打炮
        if inst.diff % 3 == 0 then
            if dist and dist < 280 then
                inst._fx2.components.combat:SetTarget(GetPlayer())
                inst._fx2.components.combat:DoAttack()
            end
        end

        if inst.diff % 15 == 0 and inst.store < 4 then
            inst.store = inst.store + 1
        end

        if inst.diff > 15 then
            inst.diff = 0
        end
        
    end)

    return inst
end

local function rift_fx_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("shadowrift_portal")
    inst.AnimState:SetBuild("shadowrift_portal")
    inst.AnimState:PlayAnimation("particle_1_pre")
    inst.AnimState:PushAnimation("particle_1_loop", true)
    inst.AnimState:SetLightOverride(1)
    return inst
end

return
    Prefab("arcueid_shadow_rift", rift_fn, rift_assets, {}),
    Prefab("arcueid_shadow_rift_fx", rift_fx_fn, rift_assets, {})
