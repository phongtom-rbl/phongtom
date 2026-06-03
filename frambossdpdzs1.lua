-- [[ CẤU HÌNH TOẠ ĐỘ GỐC VÀ BIẾN MẶC ĐỊNH ]]
local TARGET_POS = Vector3.new(-2789.7085, 238.5443, -1758.7052)
local HEIGHT_OFFSET = 3
local CAM_HEIGHT = 40
local RADIUS = 15
local SPEED = 2
local NPC_NAME = "npc2"

local AUTO_PICK = false
local PICK_DISTANCE = 25

local AUTO_HEAL = true
local HEAL_THRESHOLD = 0.80
local HEAL_COOLDOWN = 2.5
local lastHeal = 0

-- KEEP COUNT
local killCount = 0
local npcWasDead = false

local FARM_POS = Vector3.new(TARGET_POS.X, TARGET_POS.Y + HEIGHT_OFFSET, TARGET_POS.Z)

-- [[ DỊCH VỤ ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local localPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- [[ GUI ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "CircleFarmV7_UltimateFixed"

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 365)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 8)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "Đông Phan"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

local function makeBtn(text, y, on)
	local b = Instance.new("TextButton")
	b.Parent = MainFrame
	b.BackgroundColor3 = on and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(230, 50, 50)
	b.Position = UDim2.new(0.1, 0, 0, y)
	b.Size = UDim2.new(0.8, 0, 0, 32)
	b.Font = Enum.Font.GothamBold
	b.Text = text
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.TextSize = 12
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	return b
end

local ToggleBtn = makeBtn("Farm: OFF",      40,  false)
local CamBtn    = makeBtn("Cam 40m: OFF",   82,  false)
local PickBtn   = makeBtn("Auto Pick: OFF", 124, false)
local HealBtn   = makeBtn("Auto Heal: ON",  166, true)

local lastRadiusValue = RADIUS

local function CreateInputBox(text, default, posY)
	local Label = Instance.new("TextLabel")
	Label.Parent = MainFrame
	Label.BackgroundTransparency = 1
	Label.Position = UDim2.new(0.1, 0, 0, posY)
	Label.Size = UDim2.new(0.45, 0, 0, 30)
	Label.Font = Enum.Font.Gotham
	Label.TextColor3 = Color3.fromRGB(200, 200, 200)
	Label.TextSize = 12
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Text = text

	local TextBox = Instance.new("TextBox")
	TextBox.Parent = MainFrame
	TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	TextBox.Position = UDim2.new(0.55, 0, 0, posY)
	TextBox.Size = UDim2.new(0.35, 0, 0, 30)
	TextBox.Font = Enum.Font.GothamBold
	TextBox.Text = tostring(default)
	TextBox.TextColor3 = Color3.fromRGB(0, 180, 255)
	TextBox.TextSize = 13
	TextBox.ClearTextOnFocus = false
	Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)

	return function()
		local num = tonumber(TextBox.Text)
		if num and num >= 0 then return num end
		return default
	end
end

local GetSpeed  = CreateInputBox("Tốc độ (Speed):",   SPEED,  215)
local GetRadius = CreateInputBox("Bán kính (Radius):", RADIUS, 253)

-- [[ THANH MÁU NPC ]]
local HealthFrame = Instance.new("Frame")
HealthFrame.Parent = ScreenGui
HealthFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
HealthFrame.Position = UDim2.new(0.05, 0, 0.22, 0)
HealthFrame.Size = UDim2.new(0, 220, 0, 80)
HealthFrame.Visible = false
Instance.new("UICorner", HealthFrame).CornerRadius = UDim.new(0, 10)

local NPCNameLabel = Instance.new("TextLabel")
NPCNameLabel.Parent = HealthFrame
NPCNameLabel.BackgroundTransparency = 1
NPCNameLabel.Position = UDim2.new(0.08, 0, 0, 8)
NPCNameLabel.Size = UDim2.new(0.84, 0, 0, 18)
NPCNameLabel.Font = Enum.Font.GothamBold
NPCNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
NPCNameLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
NPCNameLabel.TextSize = 12
NPCNameLabel.TextXAlignment = Enum.TextXAlignment.Left

local HealthBarBg = Instance.new("Frame")
HealthBarBg.Parent = HealthFrame
HealthBarBg.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
HealthBarBg.Position = UDim2.new(0.08, 0, 0, 32)
HealthBarBg.Size = UDim2.new(0.84, 0, 0, 12)
Instance.new("UICorner", HealthBarBg).CornerRadius = UDim.new(1, 0)

local HealthBarFill = Instance.new("Frame")
HealthBarFill.Parent = HealthBarBg
HealthBarFill.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
HealthBarFill.Size = UDim2.new(1, 0, 1, 0)
Instance.new("UICorner", HealthBarFill).CornerRadius = UDim.new(1, 0)

local HealthText = Instance.new("TextLabel")
HealthText.Parent = HealthBarBg
HealthText.BackgroundTransparency = 1
HealthText.Size = UDim2.new(1, 0, 1, 0)
HealthText.Font = Enum.Font.GothamBold
HealthText.TextColor3 = Color3.fromRGB(255, 255, 255)
HealthText.TextSize = 9
HealthText.Text = "0 / 0"

local KillLabel = Instance.new("TextLabel")
KillLabel.Parent = HealthFrame
KillLabel.BackgroundTransparency = 1
KillLabel.Position = UDim2.new(0.08, 0, 0, 52)
KillLabel.Size = UDim2.new(0.84, 0, 0, 20)
KillLabel.Font = Enum.Font.GothamBold
KillLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
KillLabel.TextSize = 12
KillLabel.TextXAlignment = Enum.TextXAlignment.Left
KillLabel.Text = "💀 Đã giết: 0 lần"

-- [[ LOGIC ]]
local isFarming = false
local isCamLocked = false
local angle = 0
local farmConnection = nil
local camConnection = nil
local nextTeleportTime = 0 

local cachedNPC = nil
local lastCacheCheck = 0

-- Bộ nhớ lưu đồ họa cũ để khôi phục
local originalMaterials = {}
local lagKillerThread = nil

-- HÀM XỬ LÝ ĐỒ HỌA THEO THỜI GIAN THỰC (FIX TRUYỆT ĐỂ LỖI KHÔNG ĐỔI ĐỒ HỌA)
local function CleanGraphics()
	-- 1. Tắt toàn bộ hiệu ứng ánh sáng nâng cao
	Lighting.GlobalShadows = false
	for _, effect in ipairs(Lighting:GetChildren()) do
		if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") or effect:IsA("Clouds") then
			effect.Enabled = false
		end
	end
	
	-- 2. Quét dọn liên tục map để chuyển về chất liệu siêu nhẹ
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") and not obj:IsA("MeshPart") then
			if not originalMaterials[obj] then
				originalMaterials[obj] = obj.Material
			end
			obj.Material = Enum.Material.SmoothPlastic
		elseif obj:IsA("Decal") or obj:IsA("Texture") then
			obj.Transparency = 1
		elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
			obj.Enabled = false
		end
	end
	
	-- 3. Ép cấu hình hạ mức Render 3D của Client để chống đơ máy hoàn toàn
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end

local function RestoreGraphics()
	Lighting.GlobalShadows = true
	for _, effect in ipairs(Lighting:GetChildren()) do
		if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") or effect:IsA("Clouds") then
			effect.Enabled = true
		end
	end
	for obj, mat in pairs(originalMaterials) do
		if obj and obj.Parent then
			obj.Material = mat
		end
	end
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("Decal") or obj:IsA("Texture") then
			obj.Transparency = 0
		elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
			obj.Enabled = true
		end
	end
	table.clear(originalMaterials)
	settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
end

local function startLagKillerLoop()
	lagKillerThread = task.spawn(function()
		while isFarming do
			CleanGraphics()
			task.wait(5) -- Quét dọn dẹp map định kỳ mỗi 5 giây để xóa hiệu ứng của quái mới sinh
		end
	end)
end

local function findTargetNPC()
	local now = tick()
	if now - lastCacheCheck < 0.5 and cachedNPC and cachedNPC.Parent then
		return cachedNPC
	end
	lastCacheCheck = now

	local lowerTargetName = string.lower(NPC_NAME)
	for _, obj in ipairs(Workspace:GetChildren()) do
		if obj:IsA("Model") and string.find(string.lower(obj.Name), lowerTargetName) then
			if obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChildOfClass("Humanoid") then
				cachedNPC = obj
				return obj
			end
		end
	end
	
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("Model") and string.find(string.lower(obj.Name), lowerTargetName) then
			if obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChildOfClass("Humanoid") then
				cachedNPC = obj
				return obj
			end
		end
	end
	
	cachedNPC = nil
	return nil
end

local function autoAttack()
	while isFarming do
		local char = localPlayer.Character
		if char then
			local equippedTool = char:FindFirstChildOfClass("Tool")
			if not equippedTool then
				local tool = localPlayer.Backpack:FindFirstChildOfClass("Tool")
				if tool then tool.Parent = char end
			else
				equippedTool:Activate()
			end
		end
		task.wait(0.15)
	end
end

local function startFarmLoop()
	nextTeleportTime = tick() + 5
	lastRadiusValue = GetRadius()
	
	startLagKillerLoop() -- Kích hoạt luồng dọn dẹp đồ họa liên tục

	farmConnection = RunService.Heartbeat:Connect(function(deltaTime)
		if not isFarming then return end

		local character = localPlayer.Character
		local rootPart = character and character:FindFirstChild("HumanoidRootPart")
		if not rootPart then return end

		local currentSpeed = GetSpeed()
		local currentRadius = GetRadius()

		if currentRadius ~= lastRadiusValue then
			lastRadiusValue = currentRadius
			nextTeleportTime = tick() + 5
		end

		-- LOGIC TELEPORT 5 GIÂY
		if tick() >= nextTeleportTime then
			angle = math.random() * (2 * math.pi)
			nextTeleportTime = tick() + 5
		else
			angle = angle + (currentSpeed * deltaTime)
		end

		local offsetX = math.cos(angle) * currentRadius
		local offsetZ = math.sin(angle) * currentRadius
		local newPos = Vector3.new(FARM_POS.X + offsetX, FARM_POS.Y, FARM_POS.Z + offsetZ)

		local npcModel = findTargetNPC()
		local lookAtTarget = TARGET_POS

		if npcModel and npcModel.Parent then
			local humanoid = npcModel:FindFirstChildOfClass("Humanoid")
			local npcRoot = npcModel:FindFirstChild("HumanoidRootPart")
			if npcRoot then lookAtTarget = npcRoot.Position end

			if humanoid and humanoid.MaxHealth > 0 then
				HealthFrame.Visible = true
				NPCNameLabel.Text = "🎯 Mục tiêu: " .. npcModel.Name
				HealthText.Text = math.round(humanoid.Health) .. " / " .. math.round(humanoid.MaxHealth)
				HealthBarFill.Size = UDim2.new(
					math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1), 0, 1, 0
				)

				if humanoid.Health <= 0 then
					if not npcWasDead then
						npcWasDead = true
						killCount = killCount + 1
						KillLabel.Text = "💀 Đã giết: " .. killCount .. " lần"
					end
				else
					npcWasDead = false
				end
			else
				HealthFrame.Visible = false
			end
		else
			HealthFrame.Visible = false
			if not npcWasDead then
				npcWasDead = true
				killCount = killCount + 1
				KillLabel.Text = "💀 Đã giết: " .. killCount .. " lần"
			end
		end

		rootPart.CFrame = CFrame.new(newPos, Vector3.new(lookAtTarget.X, newPos.Y, lookAtTarget.Z))
	end)

	task.spawn(autoAttack)
end

local function stopFarmLoop()
	if farmConnection then
		farmConnection:Disconnect()
		farmConnection = nil
	end
	isFarming = false
	cachedNPC = nil
	HealthFrame.Visible = false
	
	if lagKillerThread then
		lagKillerThread = nil
	end
	RestoreGraphics() -- Khôi phục lại đồ họa mượt đẹp ban đầu
end

-- AUTO PICK
local function startPickLoop()
	task.spawn(function()
		while AUTO_PICK do
			local char = localPlayer.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hrp then
				for _, p in ipairs(Workspace:GetDescendants()) do
					if not AUTO_PICK then break end
					if p:IsA("ProximityPrompt") and p.Enabled then
						local parent = p.Parent
						if parent and parent:IsA("Part") and (parent.Position - hrp.Position).Magnitude <= PICK_DISTANCE then
							pcall(function() fireproximityprompt(p) end)
						end
					end
				end
			end
			task.wait(2.0)
		end
	end)
end

-- AUTO HEAL
RunService.Heartbeat:Connect(function()
	if not AUTO_HEAL then return end
	if tick() - lastHeal < HEAL_COOLDOWN then return end

	local char = localPlayer.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	if humanoid.Health / humanoid.MaxHealth < HEAL_THRESHOLD then
		lastHeal = tick()
		pcall(function()
			local remotes = ReplicatedStorage:FindFirstChild("Remotes")
			local healRemote = remotes and remotes:FindFirstChild("Heal")
			if healRemote then
				healRemote:FireServer()
			end
		end)
	end
end)

-- CAMERA
local function updateCamera()
	if isCamLocked then
		Camera.CameraType = Enum.CameraType.Scriptable
		Camera.CFrame = CFrame.new(
			Vector3.new(TARGET_POS.X, TARGET_POS.Y + CAM_HEIGHT, TARGET_POS.Z),
			TARGET_POS
		)
	else
		Camera.CameraType = Enum.CameraType.Custom
	end
end

-- [[ SỰ KIỆN BUTTON ]]
ToggleBtn.MouseButton1Click:Connect(function()
	isFarming = not isFarming
	if isFarming then
		ToggleBtn.Text = "Farm: ON"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		startFarmLoop()
	else
		ToggleBtn.Text = "Farm: OFF"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
		stopFarmLoop()
	end
end)

CamBtn.MouseButton1Click:Connect(function()
	isCamLocked = not isCamLocked
	if isCamLocked then
		CamBtn.Text = "Cam 40m: ON"
		CamBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		camConnection = RunService.RenderStepped:Connect(updateCamera)
	else
		CamBtn.Text = "Cam 40m: OFF"
		CamBtn.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
		if camConnection then
			camConnection:Disconnect()
			camConnection = nil
		end
		Camera.CameraType = Enum.CameraType.Custom
	end
end)

PickBtn.MouseButton1Click:Connect(function()
	AUTO_PICK = not AUTO_PICK
	if AUTO_PICK then
		PickBtn.Text = "Auto Pick: ON"
		PickBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		startPickLoop()
	else
		PickBtn.Text = "Auto Pick: OFF"
		PickBtn.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
	end
end)

HealBtn.MouseButton1Click:Connect(function()
	AUTO_HEAL = not AUTO_HEAL
	if AUTO_HEAL then
		HealBtn.Text = "Auto Heal: ON"
		HealBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	else
		HealBtn.Text = "Auto Heal: OFF"
		HealBtn.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
	end
end)
giữ nguyên script và chức năng khác chỉ cho script này thêm chức năng anti check và gắn logic anti check đó vô script này làm hoàn chỉnh gửi full cho t