local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local CamBtn = Instance.new("TextButton")
local LootBtn = Instance.new("TextButton")
local BossFpsBtn = Instance.new("TextButton")
local SpeedInput = Instance.new("TextBox")
local SpeedLabel = Instance.new("TextLabel")
local HpLabel = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.Position = UDim2.new(0.5,-100,0.5,-150)
MainFrame.Size = UDim2.new(0,200,0,320)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,12)
MainCorner.Parent = MainFrame

Title.Size = UDim2.new(1,0,0,40)
Title.Text = "PHỒNG TÔM HUB"
Title.TextColor3 = Color3.fromRGB(0,255,180)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

ToggleBtn.Size = UDim2.new(0,160,0,35)
ToggleBtn.Position = UDim2.new(0,20,0,50)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
ToggleBtn.Text = "Farm OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.Parent = MainFrame

local c1 = Instance.new("UICorner")
c1.CornerRadius = UDim.new(0,8)
c1.Parent = ToggleBtn

CamBtn.Size = UDim2.new(0,160,0,35)
CamBtn.Position = UDim2.new(0,20,0,90)
CamBtn.BackgroundColor3 = Color3.fromRGB(50,100,200)
CamBtn.Text = "Cam OFF"
CamBtn.TextColor3 = Color3.fromRGB(255,255,255)
CamBtn.Parent = MainFrame

local c2 = Instance.new("UICorner")
c2.CornerRadius = UDim.new(0,8)
c2.Parent = CamBtn

LootBtn.Size = UDim2.new(0,160,0,35)
LootBtn.Position = UDim2.new(0,20,0,130)
LootBtn.BackgroundColor3 = Color3.fromRGB(200,150,40)
LootBtn.Text = "Loot OFF"
LootBtn.TextColor3 = Color3.fromRGB(255,255,255)
LootBtn.Parent = MainFrame

local c3 = Instance.new("UICorner")
c3.CornerRadius = UDim.new(0,8)
c3.Parent = LootBtn

BossFpsBtn.Size = UDim2.new(0,160,0,35)
BossFpsBtn.Position = UDim2.new(0,20,0,170)
BossFpsBtn.BackgroundColor3 = Color3.fromRGB(100,50,150)
BossFpsBtn.Text = "BOSS FPS: OFF"
BossFpsBtn.TextColor3 = Color3.fromRGB(255,255,255)
BossFpsBtn.Parent = MainFrame

local c4 = Instance.new("UICorner")
c4.CornerRadius = UDim.new(0,8)
c4.Parent = BossFpsBtn

SpeedLabel.Size = UDim2.new(0,100,0,20)
SpeedLabel.Position = UDim2.new(0,20,0,215)
SpeedLabel.Text = "Speed:"
SpeedLabel.TextColor3 = Color3.fromRGB(200,200,200)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Parent = MainFrame

SpeedInput.Size = UDim2.new(0,50,0,25)
SpeedInput.Position = UDim2.new(0,130,0,210)
SpeedInput.Text = "5"
SpeedInput.Parent = MainFrame

local c5 = Instance.new("UICorner")
c5.CornerRadius = UDim.new(0,6)
c5.Parent = SpeedInput

HpLabel.Size = UDim2.new(1,0,0,25)
HpLabel.Position = UDim2.new(0,0,0,245)
HpLabel.BackgroundTransparency = 1
HpLabel.TextColor3 = Color3.fromRGB(255,80,80)
HpLabel.Text = "NPC2 HP: ..."
HpLabel.Parent = MainFrame

-- CONFIG
local running = false
local camEnabled = false
local autoLoot = false
local bossFps = false

local centerPos = Vector3.new(-2791,238,-1756)
local radius = 20
local angle = 0

local camera = workspace.CurrentCamera
local camHeight = 35

local randomTimer = 0
local nextTeleport = math.random(3,11)  -- ĐÃ ĐỔI THÀNH 3-11s
local teleporting = false
local teleportTimer = 0
local teleportDuration = 0.70

local attackCooldown = 0
local attackDelay = 0.1

local healCooldown = 0
local healDelay = 1
local healThreshold = 80

local lootCooldown = 0
local lootDelay = 1
local lootDistance = 20

-- FPS
local function applyBossFps()
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 9e9
end

-- FIND NPC
function getTargetNPC()
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and string.find(string.lower(v.Name),"npc2") then
			local hrp = v:FindFirstChild("HumanoidRootPart")
			local hum = v:FindFirstChildOfClass("Humanoid")
			if hrp and hum and hum.Health > 0 then
				return v
			end
		end
	end
end

-- FIND BANDAGE
function findBandage()
	local player = Players.LocalPlayer
	for _,tool in pairs(player.Backpack:GetChildren()) do
		if tool:IsA("Tool") and string.find(string.lower(tool.Name),"băng gạc") then
			return tool
		end
	end
end

-- AUTO LOOT
function autoLootLogic(dt, hrp)
	if not autoLoot then return end
	lootCooldown += dt
	if lootCooldown < lootDelay then return end
	lootCooldown = 0

	for _,obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("ProximityPrompt") and obj.Enabled then
			local parent = obj.Parent
			if parent and parent:IsA("BasePart") then
				local dist = (parent.Position - hrp.Position).Magnitude
				if dist <= lootDistance then
					fireproximityprompt(obj)
				end
			end
		end
	end
end

-- BUTTONS
ToggleBtn.MouseButton1Click:Connect(function()
	running = not running
	ToggleBtn.Text = running and "Farm ON" or "Farm OFF"
end)

CamBtn.MouseButton1Click:Connect(function()
	camEnabled = not camEnabled
	if camEnabled then
		CamBtn.Text = "Cam ON"
		camera.CameraType = Enum.CameraType.Scriptable
		local camPos = centerPos + Vector3.new(0, camHeight, 0)
		camera.CFrame = CFrame.new(camPos, centerPos)
	else
		CamBtn.Text = "Cam OFF"
		camera.CameraType = Enum.CameraType.Custom
	end
end)

LootBtn.MouseButton1Click:Connect(function()
	autoLoot = not autoLoot
	LootBtn.Text = autoLoot and "Loot ON" or "Loot OFF"
end)

BossFpsBtn.MouseButton1Click:Connect(function()
	bossFps = not bossFps
	if bossFps then
		BossFpsBtn.Text = "BOSS FPS ON"
		applyBossFps()
	else
		BossFpsBtn.Text = "BOSS FPS OFF"
	end
end)

-- LOOP
RunService.Heartbeat:Connect(function(dt)

	local player = Players.LocalPlayer
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end

	local target = getTargetNPC()

	if target then
		local th = target:FindFirstChildOfClass("Humanoid")
		if th then
			HpLabel.Text = "NPC2 HP: "..math.floor(th.Health).." / "..math.floor(th.MaxHealth)
		end
	end

	healCooldown += dt
	if hum.Health < healThreshold and healCooldown >= healDelay then
		local bandage = findBandage()
		if bandage then
			healCooldown = 0
			local oldTool = char:FindFirstChildOfClass("Tool")
			hum:EquipTool(bandage)
			task.delay(0.5, function()
				if oldTool then
					hum:EquipTool(oldTool)
				end
			end)
		end
	end

	autoLootLogic(dt, hrp)

	if running then

		randomTimer += dt

		local speed = tonumber(SpeedInput.Text) or 5
		angle += speed * dt

		local offset = Vector3.new(
			math.cos(angle) * radius,
			0,
			math.sin(angle) * radius
		)

		local newPos = centerPos + offset

		if not teleporting then
			hrp.CFrame = CFrame.lookAt(newPos, target and target.HumanoidRootPart.Position or centerPos)

			if randomTimer >= nextTeleport and target then
				teleporting = true
				randomTimer = 0
				teleportTimer = 0
				nextTeleport = math.random(3,11)  -- ĐÃ ĐỔI THÀNH 3-11s
			end
		end

		if teleporting and target then
			teleportTimer += dt

			local pos = target.HumanoidRootPart.Position + Vector3.new(0,7,0)
			hrp.CFrame = CFrame.lookAt(pos, target.HumanoidRootPart.Position)

			if teleportTimer >= teleportDuration then
				teleporting = false
			end
		end

		attackCooldown += dt
		if attackCooldown >= attackDelay then
			attackCooldown = 0
			local tool = char:FindFirstChildOfClass("Tool")
			if tool then tool:Activate() end
		end
	end
end)
