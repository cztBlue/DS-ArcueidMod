local texture = "fx/torchfire.tex"
local shader = "shaders/particle.ksh"
local colour_envelope_name = "firecolourenvelope"
local scale_envelope_name = "firescaleenvelope"

local testfire = resolvefilepath("images/testfire.tex")

local assets =
{
	Asset("IMAGE", texture),
	Asset("IMAGE", testfire),
	Asset("SHADER", shader),
	Asset("ANIM", "anim/ef_darkscar.zip"),
	Asset("ANIM", "anim/ef_icecircle.zip"),
	Asset("ANIM", "anim/ef_blade.zip"),
}

local max_scale = 3

local function IntColour(r, g, b, a)
	return { r / 255.0, g / 255.0, b / 255.0, a / 255.0 }
end

local init = false
local function InitEnvelope()
	if EnvelopeManager and not init then
		init = true
		EnvelopeManager:AddColourEnvelope(
			colour_envelope_name,
			{
				-- { 0,	IntColour( 175, 238, 238, 128 ) },
				-- { 0.49,	IntColour( 60, 111, 187, 128 ) },
				-- { 0.5,	IntColour( 0, 255, 255, 128 ) },
				-- { 0.51,	IntColour( 56, 30, 255, 128 ) },
				-- { 0.75,	IntColour( 56, 30, 255, 128 ) },
				-- { 1,	IntColour( 28, 7, 255, 0 ) },
				{ 0,    IntColour(33, 74, 248, 128) },
				{ 0.49, IntColour(33, 74, 248, 128) },
				{ 0.5,  IntColour(33, 74, 248, 128) },
				{ 0.51, IntColour(33, 74, 248, 128) },
				{ 0.75, IntColour(33, 74, 248, 128) },
				{ 1,    IntColour(33, 74, 248, 0) },
			})

		EnvelopeManager:AddVector2Envelope(
			scale_envelope_name,
			{
				{ 0, { max_scale * 0.5, max_scale } },
				{ 1, { max_scale * 0.5 * 0.5, max_scale * 0.5 } },
			})
	end
end

local max_lifetime = 0.9
--local ground_height = 0.1


----------------fx_prefab func----------------
local function eternalfire(Sim)
	local inst = CreateEntity()
	inst:AddTag("FX")
	local trans = inst.entity:AddTransform()
	local emitter = inst.entity:AddParticleEmitter()

	InitEnvelope()

	emitter:SetRenderResources(testfire, shader)
	emitter:SetMaxNumParticles(20)
	emitter:SetMaxLifetime(max_lifetime)
	emitter:SetColourEnvelope(colour_envelope_name)
	emitter:SetScaleEnvelope(scale_envelope_name);
	emitter:SetBlendMode(BLENDMODE.Additive)
	emitter:EnableBloomPass(true)
	emitter:SetUVFrameSize(1.0, 1.0)

	inst.entity:AddLight()
	inst.Light:Enable(true)
	inst.Light:SetIntensity(.6)
	inst.Light:SetColour(175 / 255, 238 / 255, 238 / 255)
	inst.Light:SetFalloff(0.7)
	inst.Light:SetRadius(4)

	inst.persists = false

	-----------------------------------------------------
	local tick_time = TheSim:GetTickTime()

	local desired_particles_per_second = 64
	local particles_per_tick = desired_particles_per_second * tick_time

	local emitter = inst.ParticleEmitter

	local num_particles_to_emit = 1

	local sphere_emitter = CreateSphereEmitter(0.05)

	local emit_fn = function()
		local vx, vy, vz = 0.01 * UnitRand(), 0, 0.01 * UnitRand()
		local lifetime = max_lifetime * (0.9 + UnitRand() * 0.1)
		local px, py, pz
		--vz = .1
		local sm = GetSeasonManager()
		if sm:IsHurricaneStorm() then
			local windspeed = sm:GetHurricaneWindSpeed()
			local windangle = GetWorld().components.worldwind:GetWindAngle() * DEGREES
			local dir = Vector3(windspeed * math.cos(windangle), 0.0, -windspeed * math.sin(windangle))
			vx = vx + dir.x * .17
			vz = vz + dir.z * .17
		end

		px, py, pz = sphere_emitter()
		px = px - 0.1
		py = py + 0.25 -- the 0.2 is to offset the flame particles upwards a bit so they can be used on a torch

		local uv_offset = math.random(0, 1.5) * 0.25

		emitter:AddParticleUV(
			lifetime, -- lifetime
			px, py, pz, -- position
			vx, vy, vz, -- velocity
			uv_offset, 0 -- uv offset
		)
	end

	local updateFunc = function()
		while num_particles_to_emit > 1 do
			emit_fn(emitter)
			num_particles_to_emit = num_particles_to_emit - 1
		end

		num_particles_to_emit = num_particles_to_emit + particles_per_tick
	end

	EmitterManager:AddEmitter(inst, nil, updateFunc)

	return inst
end

----------------normal_prefab func------------
--暗影撕裂特效
local function ef_darkscar(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

	--日常动画
	anim:SetBank("ef_darkscar")
	anim:SetBuild("ef_darkscar")
	anim:PlayAnimation("darkscar")
	inst:DoTaskInTime(.4, inst.Remove)

	return inst
end

--冰魔法阵特效
local function ef_icecircle(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

	--日常动画
	anim:SetBank("ef_icecircle")
	anim:SetBuild("ef_icecircle")
	anim:PlayAnimation("icecircle")
	inst:DoTaskInTime(.85, inst.Remove)

	return inst
end

local function FindPoint(st_point,angle,dist)

end

--斩击效果
local function ef_blade(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	-- klei坑爹的引擎必须要渲染出来才能调角度，在调好角度之前先隐藏
	anim:SetMultColour(0, 0, 0, 0)

	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD)
	inst.AnimState:SetSortOrder(2)
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
	MakeCharacterPhysics(inst, 0, 0)

	inst.Physics:ClearCollisionMask()
	inst.Physics:SetCollisionCallback(function(inst, other) end)

	inst:AddComponent("weapon")
    inst.components.weapon.projectilelaunchsymbol = "swap_object"
    inst.components.weapon:SetDamage(100)
    inst.components.weapon:SetRange(12, 14)

	inst:AddComponent("projectile")
	inst.components.projectile:SetSpeed(45)
    inst.components.projectile:SetOnHitFn(function(self, attacker, target, weapon) self:Remove() end)
    inst:ListenForEvent("onthrown", function (inst, data) end)

	-- 旋向鼠标
	inst:DoTaskInTime(0, function(inst)
		local x, y, z = TheInput:GetWorldPosition()
		inst.Transform:SetRotation(inst:GetAngleToPoint(x, y, z))
		inst.AnimState:SetMultColour(1, 1, 1, 1)
	end)

	-- inst.Transform:SetScale(1, 1, 1) --冲击方向x，宽度y，斜向z
	local screen_width, screen_height = Sim:GetScreenSize() -- 鼠标在右镜像prefab使阴影正常
	local mouse_x, mouse_y = TheInput:GetScreenPosition():Get()
	if mouse_x * 2 > screen_width then
		inst.AnimState:SetScale(1, -1, 1)
	end

	--日常动画
	anim:SetBank("ef_blade")
	anim:SetBuild("ef_blade")
	anim:PlayAnimation("blade", false)
	inst:DoTaskInTime(1.5, inst.Remove)

	return inst
end

return Prefab("common/fx/eternalfire", eternalfire, assets),
	Prefab("ef_darkscar", ef_darkscar, assets),
	Prefab("ef_blade", ef_blade, assets),
	Prefab("ef_icecircle", ef_icecircle, assets)
