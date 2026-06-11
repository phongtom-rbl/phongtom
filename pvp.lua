local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- ==================== GUI CHÍNH ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SeraphBackstabGUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 20, 0, 100)
MainFrame.Size = UDim2.new(0, 240, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 100)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleLabel.BorderSizePixel = 0
TitleLabel.Size = UDim2.new(1, 0, 0, 28)
TitleLabel.Font = Enum.Font.Code
TitleLabel.Text = "Đông Phan"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
TitleLabel.TextSize = 13

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleLabel

-- Máu bản thân
local SelfHealthLabel = Instance.new("TextLabel")
SelfHealthLabel.Parent = MainFrame
SelfHealthLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SelfHealthLabel.BorderSizePixel = 0
SelfHealthLabel.Position = UDim2.new(0, 10, 0, 33)
SelfHealthLabel.Size = UDim2.new(1, -20, 0, 20)
SelfHealthLabel.Font = Enum.Font.Code
SelfHealthLabel.Text = "💚 MAU BAN: --/--"
SelfHealthLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
SelfHealthLabel.TextSize = 11

local SelfHealthCorner = Instance.new("UICorner")
SelfHealthCorner.CornerRadius = UDim.new(0, 4)
SelfHealthCorner.Parent = SelfHealthLabel

-- Máu mục tiêu
local HealthLabel = Instance.new("TextLabel")
HealthLabel.Parent = MainFrame
HealthLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
HealthLabel.BorderSizePixel = 0
HealthLabel.Position = UDim2.new(0, 10, 0, 57)
HealthLabel.Size = UDim2.new(1, -20, 0, 20)
HealthLabel.Font = Enum.Font.Code
HealthLabel.Text = "❤ MAU DICH: --/--"
HealthLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
HealthLabel.TextSize = 11

local HealthCorner = Instance.new("UICorner")
HealthCorner.CornerRadius = UDim.new(0, 4)
HealthCorner.Parent = HealthLabel

-- Tên mục tiêu
local TargetNameLabel = Instance.new("TextLabel")
TargetNameLabel.Parent = MainFrame
TargetNameLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TargetNameLabel.BorderSizePixel = 0
TargetNameLabel.Position = UDim2.new(0, 10, 0, 81)
TargetNameLabel.Size = UDim2.new(1, -20, 0, 20)
TargetNameLabel.Font = Enum.Font.Code
TargetNameLabel.Text = "🎯 MUC TIEU: Khong co"
TargetNameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TargetNameLabel.TextSize = 11

local TargetCorner = Instance.new("UICorner")
TargetCorner.CornerRadius = UDim.new(0, 4)
TargetCorner.Parent = TargetNameLabel

-- Trạng thái
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
StatusLabel.BorderSizePixel = 0
StatusLabel.Position = UDim2.new(0, 10, 0, 105)
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Font = Enum.Font.Code
StatusLabel.Text = "⚡ TRANG THAI: San sang"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
StatusLabel.TextSize = 10

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 4)
StatusCorner.Parent = StatusLabel

-- Hàng nút 1
local LineToggle = Instance.new("TextButton")
LineToggle.Parent = MainFrame
LineToggle.BackgroundColor3 = Color3.fromRGB(10, 60, 10)
LineToggle.BorderSizePixel = 0
LineToggle.Position = UDim2.new(0, 10, 0, 133)
LineToggle.Size = UDim2.new(0, 105, 0, 26)
LineToggle.Font = Enum.Font.Code
LineToggle.Text = "BAT LINE"
LineToggle.TextColor3 = Color3.fromRGB(50, 255, 50)
LineToggle.TextSize = 11

local LineCorner = Instance.new("UICorner")
LineCorner.CornerRadius = UDim.new(0, 5)
LineCorner.Parent = LineToggle

local SwitchTarget = Instance.new("TextButton")
SwitchTarget.Parent = MainFrame
SwitchTarget.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SwitchTarget.BorderSizePixel = 0
SwitchTarget.Position = UDim2.new(0, 125, 0, 133)
SwitchTarget.Size = UDim2.new(0, 105, 0, 26)
SwitchTarget.Font = Enum.Font.Code
SwitchTarget.Text = "DOI LINE"
SwitchTarget.TextColor3 = Color3.fromRGB(0, 200, 255)
SwitchTarget.TextSize = 11

local SwitchCorner = Instance.new("UICorner")
SwitchCorner.CornerRadius = UDim.new(0, 5)
SwitchCorner.Parent = SwitchTarget

-- Hàng nút 2
local AttackToggle = Instance.new("TextButton")
AttackToggle.Parent = MainFrame
AttackToggle.BackgroundColor3 = Color3.fromRGB(60, 10, 10)
AttackToggle.BorderSizePixel = 0
AttackToggle.Position = UDim2.new(0, 10, 0, 165)
AttackToggle.Size = UDim2.new(0, 220, 0, 26)
AttackToggle.Font = Enum.Font.Code
AttackToggle.Text = "BAT DANH"
AttackToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
AttackToggle.TextSize = 11

local AttackCorner = Instance.new("UICorner")
AttackCorner.CornerRadius = UDim.new(0, 5)
AttackCorner.Parent = AttackToggle

-- ==================== BIẾN HỆ THỐNG ====================
local isAttackEnabled = false
local isLineEnabled = false
local targetPlayer = nil
local lastAttackTime = 0
local lastHealTime = 0
local beam = nil
local beamAttachment0 = nil
local beamAttachment1 = nil
local excludedPlayers = {}
local bodyGyro = nil
local bodyVelocity = nil
local HealRemote = nil
local isRetreating = false
local isWaitingForHeal = false

-- Tọa độ an toàn
local SAFE_POSITION = Vector3.new(548.34, 18.59, -242.10)

-- ==================== HÀM LẤY REMOTE HEAL ====================
local function getHealRemote()
    if HealRemote then return HealRemote end
    
    local success, result = pcall(function()
        local remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
        if remotes then
            return remotes:WaitForChild("Heal", 5)
        end
    end)
    
    if success and result then
        HealRemote = result
        return HealRemote
    end
    return nil
end

-- ==================== HÀM TỰ ĐỘNG HEAL ====================
local function autoHeal()
    local char = player.Character
    if not char then return false end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return false end
    
    local healthPercent = (humanoid.Health / humanoid.MaxHealth) * 100
    
    if healthPercent < 80 then
        local remote = getHealRemote()
        if remote then
            pcall(function()
                remote:FireServer()
            end)
            return true
        end
    end
    
    return false
end

-- ==================== HÀM KIỂM TRA MÁU BẢN THÂN ====================
local function getSelfHealthPercent()
    local char = player.Character
    if not char then return 100 end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return 100 end
    
    return (humanoid.Health / humanoid.MaxHealth) * 100
end

-- ==================== HÀM LINE ====================
local function clearBeam()
    if beam then beam:Destroy(); beam = nil end
    if beamAttachment0 then beamAttachment0:Destroy(); beamAttachment0 = nil end
    if beamAttachment1 then beamAttachment1:Destroy(); beamAttachment1 = nil end
end

local function createBeam()
    clearBeam()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    beamAttachment0 = Instance.new("Attachment")
    beamAttachment0.Parent = char.HumanoidRootPart
    
    beamAttachment1 = Instance.new("Attachment")
    
    beam = Instance.new("Beam")
    beam.Attachment0 = beamAttachment0
    beam.Attachment1 = beamAttachment1
    beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 100))
    beam.Transparency = NumberSequence.new(0.3)
    beam.Width0 = 0.25
    beam.Width1 = 0.25
    beam.FaceCamera = true
    beam.Enabled = false
    beam.Parent = workspace
end

local function updateBeam(target)
    if not beam or not beamAttachment1 then return end
    
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        beam.Enabled = false
        return
    end
    
    if beamAttachment0.Parent ~= char.HumanoidRootPart then
        beamAttachment0.Parent = char.HumanoidRootPart
    end
    
    if not target or not target.Character then
        beam.Enabled = false
        return
    end
    
    local targetChar = target.Character
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        beam.Enabled = false
        return
    end
    
    if beamAttachment1.Parent ~= targetRoot then
        beamAttachment1.Parent = targetRoot
    end
    
    local humanoid = targetChar:FindFirstChild("Humanoid")
    if humanoid then
        local hp = humanoid.Health / humanoid.MaxHealth
        if hp > 0.6 then
            beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 100))
        elseif hp > 0.3 then
            beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
        else
            beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
        end
    end
    
    beam.Enabled = true
end

-- ==================== HÀM TÌM MỤC TIÊU ====================
local function findNearestArmedPlayer()
    local nearest = nil
    local shortest = math.huge
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and not excludedPlayers[plr] and plr.Character then
            local hum = plr.Character:FindFirstChild("Humanoid")
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            
            if hum and hum.Health > 0 and root then
                local hasTool = false
                for _, c in pairs(plr.Character:GetChildren()) do
                    if c:IsA("Tool") then hasTool = true; break end
                end
                
                if hasTool then
                    local myChar = player.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        local dist = (myChar.HumanoidRootPart.Position - root.Position).Magnitude
                        if dist < shortest then
                            shortest = dist
                            nearest = plr
                        end
                    end
                end
            end
        end
    end
    
    if not nearest and next(excludedPlayers) then
        excludedPlayers = {}
        return findNearestArmedPlayer()
    end
    
    return nearest
end

-- ==================== HÀM DI CHUYỂN ====================
local function removeBodyMovers()
    if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
    if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
end

local function createBodyMovers()
    local myChar = player.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return false end
    
    local myRoot = myChar.HumanoidRootPart
    
    removeBodyMovers()
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1,1,1) * math.huge
    bodyGyro.P = 100000
    bodyGyro.D = 1000
    bodyGyro.Parent = myRoot
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1,1,1) * math.huge
    bodyVelocity.P = 100000
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = myRoot
    
    return true
end

-- Hàm CFrame về vị trí an toàn
local function retreatToSafePosition()
    local myChar = player.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return false end
    
    local myRoot = myChar.HumanoidRootPart
    local humanoid = myChar:FindFirstChild("Humanoid")
    
    if not bodyGyro or bodyGyro.Parent ~= myRoot then
        if not createBodyMovers() then return false end
    end
    
    if humanoid then
        humanoid.AutoRotate = false
        humanoid.PlatformStand = true
    end
    
    bodyGyro.CFrame = CFrame.new(SAFE_POSITION)
    bodyVelocity.Velocity = (SAFE_POSITION - myRoot.Position) * 30
    
    return true
end

-- Hàm khóa sau lưng mục tiêu
local function lockToTargetBack()
    if not isAttackEnabled or not targetPlayer or not targetPlayer.Character then return false end
    
    local targetChar = targetPlayer.Character
    local myChar = player.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return false end
    
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return false end
    
    local myRoot = myChar.HumanoidRootPart
    local humanoid = myChar:FindFirstChild("Humanoid")
    
    if not bodyGyro or bodyGyro.Parent ~= myRoot then
        if not createBodyMovers() then return false end
    end
    
    if humanoid then
        humanoid.AutoRotate = false
        humanoid.PlatformStand = true
    end
    
    local lookVector = targetRoot.CFrame.LookVector
    local behindPos = targetRoot.Position - (lookVector * 4) + Vector3.new(0, 0, 0)
    
    bodyGyro.CFrame = CFrame.lookAt(behindPos, targetRoot.Position)
    bodyVelocity.Velocity = (behindPos - myRoot.Position) * 30
    
    return true
end

local function unlockCharacter()
    local myChar = player.Character
    if myChar then
        local hum = myChar:FindFirstChild("Humanoid")
        if hum then
            hum.AutoRotate = true
            hum.PlatformStand = false
        end
    end
    removeBodyMovers()
end

-- ==================== HÀM ĐÁNH ====================
local function performAttack()
    local char = player.Character
    if not char then return end
    
    local tool = nil
    for _, c in pairs(char:GetChildren()) do
        if c:IsA("Tool") then tool = c; break end
    end
    
    if not tool then
        local bp = player:FindFirstChild("Backpack")
        if bp then
            for _, c in pairs(bp:GetChildren()) do
                if c:IsA("Tool") then
                    char.Humanoid:EquipTool(c)
                    tool = c
                    break
                end
            end
        end
    end
    
    if tool then
        task.wait(0.03)
        if tool:FindFirstChild("Handle") then
            local cd = tool.Handle:FindFirstChild("ClickDetector")
            if cd then fireclickdetector(cd) end
        end
        tool:Activate()
        for _, r in pairs(tool:GetDescendants()) do
            if r:IsA("RemoteEvent") then r:FireServer() end
        end
    end
end

-- ==================== CẬP NHẬT UI ====================
local function updateUI()
    -- Cập nhật máu bản thân
    local myChar = player.Character
    if myChar then
        local myHum = myChar:FindFirstChild("Humanoid")
        if myHum then
            local myHp = math.floor(myHum.Health)
            local myMhp = math.floor(myHum.MaxHealth)
            local myPct = math.floor((myHum.Health / myHum.MaxHealth) * 100)
            SelfHealthLabel.Text = "💚 MAU BAN: " .. myHp .. "/" .. myMhp .. " (" .. myPct .. "%)"
            
            if myPct >= 90 then
                SelfHealthLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            elseif myPct > 30 then
                SelfHealthLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
            else
                SelfHealthLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
        end
    end
    
    -- Cập nhật trạng thái
    if isRetreating then
        StatusLabel.Text = "⚠ RUT LUI - MAU < 30%!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    elseif isWaitingForHeal then
        local pct = getSelfHealthPercent()
        StatusLabel.Text = "⏳ CHO HOI MAU (" .. math.floor(pct) .. "%/90%)"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    elseif isAttackEnabled then
        StatusLabel.Text = "⚡ DANG CHIEN DAU"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        StatusLabel.Text = "⚡ TRANG THAI: San sang"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
    
    -- Cập nhật mục tiêu
    if not targetPlayer or not targetPlayer.Character then
        TargetNameLabel.Text = "🎯 MUC TIEU: Khong co"
        HealthLabel.Text = "❤ MAU DICH: --/--"
        return
    end
    
    local tc = targetPlayer.Character
    local hum = tc:FindFirstChild("Humanoid")
    
    TargetNameLabel.Text = "🎯 MUC TIEU: " .. targetPlayer.Name
    
    if hum then
        local hp = math.floor(hum.Health)
        local mhp = math.floor(hum.MaxHealth)
        local pct = math.floor(hum.Health / hum.MaxHealth * 100)
        HealthLabel.Text = "❤ MAU DICH: " .. hp .. "/" .. mhp .. " (" .. pct .. "%)"
        if pct > 60 then HealthLabel.TextColor3 = Color3.fromRGB(0,255,100)
        elseif pct > 30 then HealthLabel.TextColor3 = Color3.fromRGB(255,255,0)
        else HealthLabel.TextColor3 = Color3.fromRGB(255,50,50) end
    end
end

-- ==================== SỰ KIỆN NÚT ====================
LineToggle.MouseButton1Click:Connect(function()
    isLineEnabled = not isLineEnabled
    if isLineEnabled then
        LineToggle.Text = "TAT LINE"
        LineToggle.BackgroundColor3 = Color3.fromRGB(60, 10, 10)
        LineToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
        
        if not beam then createBeam() end
        targetPlayer = findNearestArmedPlayer()
        if targetPlayer then updateBeam(targetPlayer) end
    else
        LineToggle.Text = "BAT LINE"
        LineToggle.BackgroundColor3 = Color3.fromRGB(10, 60, 10)
        LineToggle.TextColor3 = Color3.fromRGB(50, 255, 50)
        if beam then beam.Enabled = false end
    end
end)

SwitchTarget.MouseButton1Click:Connect(function()
    if targetPlayer then excludedPlayers[targetPlayer] = true end
    local newTarget = findNearestArmedPlayer()
    if newTarget then
        targetPlayer = newTarget
        if isLineEnabled then updateBeam(targetPlayer) end
    else
        excludedPlayers = {}
        targetPlayer = findNearestArmedPlayer()
        if targetPlayer and isLineEnabled then updateBeam(targetPlayer) end
    end
end)

AttackToggle.MouseButton1Click:Connect(function()
    isAttackEnabled = not isAttackEnabled
    if isAttackEnabled then
        AttackToggle.Text = "TAT DANH"
        AttackToggle.BackgroundColor3 = Color3.fromRGB(10, 60, 10)
        AttackToggle.TextColor3 = Color3.fromRGB(0, 255, 100)
        isRetreating = false
        isWaitingForHeal = false
        
        if not targetPlayer then targetPlayer = findNearestArmedPlayer() end
        if not isLineEnabled then
            isLineEnabled = true
            LineToggle.Text = "TAT LINE"
            LineToggle.BackgroundColor3 = Color3.fromRGB(60, 10, 10)
            LineToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
            if not beam then createBeam() end
        end
        if targetPlayer then updateBeam(targetPlayer) end
    else
        AttackToggle.Text = "BAT DANH"
        AttackToggle.BackgroundColor3 = Color3.fromRGB(60, 10, 10)
        AttackToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
        isRetreating = false
        isWaitingForHeal = false
        unlockCharacter()
    end
end)

-- ==================== LOOP CHÍNH ====================
RunService.RenderStepped:Connect(function()
    local t = tick()
    
    -- Cập nhật line
    if isLineEnabled and beam then
        updateBeam(targetPlayer)
    elseif not isLineEnabled and beam then
        beam.Enabled = false
    end
    
    -- Auto attack + auto heal + rút lui
    if isAttackEnabled then
        -- Luôn tự động heal khi máu dưới 80%
        if t - lastHealTime > 0.5 then
            autoHeal()
            lastHealTime = t
        end
        
        local selfHealth = getSelfHealthPercent()
        
        -- CHỈ RÚT LUI KHI MÁU DƯỚI 30%
        if selfHealth < 30 then
            if not isRetreating then
                isRetreating = true
                isWaitingForHeal = false
            end
            retreatToSafePosition()
            
        -- MÁU TỪ 30% ĐẾN 89%: KHÔNG RÚT LUI, TIẾP TỤC ĐỨNG Ở VỊ TRÍ HIỆN TẠI
        -- Nếu đang rút lui thì vẫn giữ ở vị trí an toàn
        -- Nếu chưa rút lui thì vẫn tiếp tục đánh bình thường
        elseif selfHealth < 90 then
            if isRetreating then
                -- Đã rút lui rồi, giữ ở vị trí an toàn đợi heal
                isWaitingForHeal = true
                retreatToSafePosition()
            else
                -- Chưa rút lui (máu chưa từng dưới 30%), tiếp tục đánh bình thường
                if targetPlayer and targetPlayer.Character then
                    local hum = targetPlayer.Character:FindFirstChild("Humanoid")
                    if hum and hum.Health > 0 then
                        lockToTargetBack()
                        if t - lastAttackTime > 0.3 then
                            performAttack()
                            lastAttackTime = t
                        end
                    else
                        unlockCharacter()
                        excludedPlayers[targetPlayer] = true
                        targetPlayer = findNearestArmedPlayer()
                        if targetPlayer then updateBeam(targetPlayer) end
                    end
                else
                    targetPlayer = findNearestArmedPlayer()
                    if targetPlayer then updateBeam(targetPlayer) end
                end
            end
            
        -- MÁU ĐỦ 90% TRỞ LÊN: Reset trạng thái rút lui, tiếp tục chiến đấu
        else
            if isRetreating or isWaitingForHeal then
                isRetreating = false
                isWaitingForHeal = false
            end
            
            if targetPlayer and targetPlayer.Character then
                local hum = targetPlayer.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    lockToTargetBack()
                    if t - lastAttackTime > 0.3 then
                        performAttack()
                        lastAttackTime = t
                    end
                else
                    unlockCharacter()
                    excludedPlayers[targetPlayer] = true
                    targetPlayer = findNearestArmedPlayer()
                    if targetPlayer then updateBeam(targetPlayer) end
                end
            else
                targetPlayer = findNearestArmedPlayer()
                if targetPlayer then updateBeam(targetPlayer) end
            end
        end
    end
    
    updateUI()
end)

-- ==================== CLEANUP ====================
player.CharacterRemoving:Connect(function()
    unlockCharacter()
    clearBeam()
    isRetreating = false
    isWaitingForHeal = false
end)

player.CharacterAdded:Connect(function()
    unlockCharacter()
    isRetreating = false
    isWaitingForHeal = false
    task.wait(0.5)
    clearBeam()
    if isLineEnabled or isAttackEnabled then
        createBeam()
        if targetPlayer then updateBeam(targetPlayer) end
    end
end)

createBeam()