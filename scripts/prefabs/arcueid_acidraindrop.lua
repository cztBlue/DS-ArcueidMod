local assets =
{
	Asset( "ANIM", "anim/arcueid_acidraindrop.zip" ),
}

local function OnSleep(inst)
    inst:Remove()
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    anim:SetBuild( "arcueid_acidraindrop" )
    anim:SetBank( "arcueid_acidraindrop" )
	anim:PlayAnimation( "anim" ) 
	
	inst.persists = false

	inst:AddTag( "FX" )
    inst.OnEntitySleep = OnSleep  
	inst:ListenForEvent( "animover", function(inst) inst:Remove() end )

    return inst
end

return Prefab( "common/fx/arcueid_acidraindrop", fn, assets ) 
 
