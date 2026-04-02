-- ╔══════════════════════════════════════╗
-- ║       AUTO FARM GUI - by Script      ║
-- ║  Face Target + Auto Attack NPC       ║
-- ╚══════════════════════════════════════╝

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ══════════════════════════════
--         CONFIG
-- ══════════════════════════════
local CONFIG = {
    TargetName    = "npc2",         -- tên NPC (không phân biệt hoa thường)
    AttackRange   = 10,             -- khoảng cách tự đánh
    FaceSpeed     = 0.15,           -- tốc độ quay mặt (0~1)
    AttackKey     = Enum.KeyCode.F, -- phím đánh thủ công (không dùng khi auto)
    AutoClickRate = 0.4,            -- giây giữa mỗi lần click đánh
}

-- ══════════════════════════════
--         STATE
-- ══════════════════════════════
local State = {
    faceEnabled   = false,
    attackEnabled = false,
    dragging      = false,
    dragStart     = nil,
    frameStart    = nil,
    lastAttack    = 0,
}

-- ══════════════════════════════
--         HELPER
-- ══════════════════════════════
local function getTarget()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower() == CONFIG.TargetName:lower() then
            local hrp = obj:FindFirstChild("HumanoidRootPart")
                     or obj:FindFirstChild("HRPart")
                     or obj.PrimaryPart
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                return obj, hrp
            end
        end
    end
    return nil, nil
end

local function getCharParts()
    local char = LocalPlayer.Character
    if not char then return nil, nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hrp, hum
end

-- Quay nhân vật mặt về target
local function faceTarget(hrp, targetHRP)
    local dir = (targetHRP.Position - hrp.Position) * Vector3.new(1, 0, 1)
    if dir.Magnitude < 0.1 then return end
    local goal = CFrame.new(hrp.Position, hrp.Position + dir.Unit)
    hrp.CFrame = hrp.CFrame:Lerp(goal, CONFIG.FaceSpeed)
end

-- Click chuột trái (tấn công)
local function simulateAttack()
    -- Roblox executor: dùng mouse1click hoặc fireproximityprompt
    -- Dùng mouse1press/mouse1release để giả lập click đánh
    if Mouse then
        -- Di chuột về phía NPC trên màn hình rồi click
        local _, target_hrp = getTarget()
        if target_hrp then
            local cam = workspace.CurrentCamera
            local screenPos, onScreen = cam:WorldToScreenPoint(target_hrp.Position)
            if onScreen then
                -- Dùng movemouse + mouse1click nếu executor hỗ trợ
                if mousemoveabs then
                    mousemoveabs(screenPos.X, screenPos.Y)
                end
            end
        end
        if mouse1click then
            mouse1click()
        elseif Mouse then
            -- fallback: fireproximityprompt hoặc tool:Activate
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool.Activated then
                tool.Activated:Fire()
            end
        end
    end
end

-- ══════════════════════════════════════════
--              GUI BUILD
-- ══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name        = "AutoFarmGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Dùng CoreGui để không bị reset khi chết
local ok, err = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ok then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ─── MAIN FRAME ───
local MainFrame = Instance.new("Frame")
MainFrame.Name            = "MainFrame"
MainFrame.Size            = UDim2.new(0, 260, 0, 220)
MainFrame.Position        = UDim2.new(0.5, -130, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent          = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

-- Stroke viền
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(80, 180, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- Gradient nền
local BgGrad = Instance.new("UIGradient")
BgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(18, 18, 28)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(10, 10, 16)),
})
BgGrad.Rotation = 135
BgGrad.Parent = MainFrame

-- ─── TOP BAR (drag handle) ───
local TopBar = Instance.new("Frame")
TopBar.Name              = "TopBar"
TopBar.Size              = UDim2.new(1, 0, 0, 40)
TopBar.Position          = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3  = Color3.fromRGB(25, 25, 38)
TopBar.BorderSizePixel   = 0
TopBar.Parent            = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 16)
TopCorner.Parent = TopBar

-- Fix bottom corners of topbar
local TopFix = Instance.new("Frame")
TopFix.Size             = UDim2.new(1, 0, 0.5, 0)
TopFix.Position         = UDim2.new(0, 0, 0.5, 0)
TopFix.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
TopFix.BorderSizePixel  = 0
TopFix.Parent           = TopBar

-- Icon + Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size              = UDim2.new(1, -50, 1, 0)
TitleLabel.Position          = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text              = "⚔  AUTO FARM"
TitleLabel.TextColor3        = Color3.fromRGB(80, 190, 255)
TitleLabel.TextSize          = 15
TitleLabel.Font              = Enum.Font.GothamBold
TitleLabel.TextXAlignment    = Enum.TextXAlignment.Left
TitleLabel.Parent            = TopBar

-- Minimize button
local MinBtn = Instance.new("TextButton")
MinBtn.Size              = UDim2.new(0, 28, 0, 28)
MinBtn.Position          = UDim2.new(1, -36, 0.5, -14)
MinBtn.BackgroundColor3  = Color3.fromRGB(255, 80, 80)
MinBtn.Text              = "−"
MinBtn.TextColor3        = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize          = 18
MinBtn.Font              = Enum.Font.GothamBold
MinBtn.BorderSizePixel   = 0
MinBtn.Parent            = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinBtn

-- ─── CONTENT AREA ───
local Content = Instance.new("Frame")
Content.Name              = "Content"
Content.Size              = UDim2.new(1, 0, 1, -44)
Content.Position          = UDim2.new(0, 0, 0, 44)
Content.BackgroundTransparency = 1
Content.Parent            = MainFrame

local ContentList = Instance.new("UIListLayout")
ContentList.Padding        = UDim.new(0, 10)
ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentList.VerticalAlignment   = Enum.VerticalAlignment.Top
ContentList.Parent         = Content

local ContentPad = Instance.new("UIPadding")
ContentPad.PaddingTop    = UDim.new(0, 12)
ContentPad.PaddingBottom = UDim.new(0, 12)
ContentPad.Parent        = Content

-- ─── TOGGLE BUILDER ───
local function makeToggle(parent, labelText, desc, color, callback)
    local Row = Instance.new("Frame")
    Row.Size              = UDim2.new(1, -20, 0, 56)
    Row.BackgroundColor3  = Color3.fromRGB(22, 22, 34)
    Row.BorderSizePixel   = 0
    Row.Parent            = parent

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 12)
    RowCorner.Parent = Row

    local RowStroke = Instance.new("UIStroke")
    RowStroke.Color = Color3.fromRGB(50, 50, 70)
    RowStroke.Thickness = 1
    RowStroke.Parent = Row

    -- Label chính
    local Lbl = Instance.new("TextLabel")
    Lbl.Size             = UDim2.new(1, -70, 0, 22)
    Lbl.Position         = UDim2.new(0, 12, 0, 8)
    Lbl.BackgroundTransparency = 1
    Lbl.Text             = labelText
    Lbl.TextColor3       = Color3.fromRGB(220, 220, 240)
    Lbl.TextSize         = 13
    Lbl.Font             = Enum.Font.GothamBold
    Lbl.TextXAlignment   = Enum.TextXAlignment.Left
    Lbl.Parent           = Row

    -- Mô tả nhỏ
    local Desc = Instance.new("TextLabel")
    Desc.Size            = UDim2.new(1, -70, 0, 16)
    Desc.Position        = UDim2.new(0, 12, 0, 30)
    Desc.BackgroundTransparency = 1
    Desc.Text            = desc
    Desc.TextColor3      = Color3.fromRGB(120, 120, 150)
    Desc.TextSize        = 10
    Desc.Font            = Enum.Font.Gotham
    Desc.TextXAlignment  = Enum.TextXAlignment.Left
    Desc.Parent          = Row

    -- Toggle switch nền
    local ToggleBg = Instance.new("Frame")
    ToggleBg.Size            = UDim2.new(0, 44, 0, 24)
    ToggleBg.Position        = UDim2.new(1, -56, 0.5, -12)
    ToggleBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ToggleBg.BorderSizePixel = 0
    ToggleBg.Parent          = Row

    local TBCorner = Instance.new("UICorner")
    TBCorner.CornerRadius = UDim.new(1, 0)
    TBCorner.Parent = ToggleBg

    -- Nút tròn
    local Knob = Instance.new("Frame")
    Knob.Size            = UDim2.new(0, 18, 0, 18)
    Knob.Position        = UDim2.new(0, 3, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
    Knob.BorderSizePixel = 0
    Knob.Parent          = ToggleBg

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local enabled = false

    local function setToggle(val)
        enabled = val
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
        if enabled then
            TweenService:Create(ToggleBg, tweenInfo, {BackgroundColor3 = color}):Play()
            TweenService:Create(Knob,     tweenInfo, {
                Position        = UDim2.new(0, 23, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            }):Play()
        else
            TweenService:Create(ToggleBg, tweenInfo, {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
            TweenService:Create(Knob,     tweenInfo, {
                Position        = UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(160, 160, 180),
            }):Play()
        end
        callback(enabled)
    end

    -- Click vùng Row để toggle
    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Size              = UDim2.new(1, 0, 1, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text              = ""
    ClickBtn.Parent            = Row
    ClickBtn.ZIndex            = 5

    ClickBtn.MouseButton1Click:Connect(function()
        setToggle(not enabled)
    end)

    return Row, function() return enabled end
end

-- ─── STATUS LABEL ───
local function makeStatus(parent)
    local Lbl = Instance.new("TextLabel")
    Lbl.Size             = UDim2.new(1, -20, 0, 22)
    Lbl.BackgroundTransparency = 1
    Lbl.Text             = "● Không tìm thấy mục tiêu"
    Lbl.TextColor3       = Color3.fromRGB(100, 100, 130)
    Lbl.TextSize         = 11
    Lbl.Font             = Enum.Font.Gotham
    Lbl.TextXAlignment   = Enum.TextXAlignment.Center
    Lbl.Parent           = parent
    return Lbl
end

-- Tạo các toggle
local _, getFace = makeToggle(Content,
    "🎯  Face Target",
    "Quay mặt về "..CONFIG.TargetName.." (không phân biệt hoa/thường)",
    Color3.fromRGB(0, 180, 255),
    function(v) State.faceEnabled = v end
)

local _, getAttack = makeToggle(Content,
    "⚔  Auto Attack",
    "Tự động đánh khi trong tầm "..CONFIG.AttackRange.." studs",
    Color3.fromRGB(255, 80, 80),
    function(v) State.attackEnabled = v end
)

local StatusLbl = makeStatus(Content)

-- ══════════════════════════════
--         DRAG LOGIC
-- ══════════════════════════════
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        State.dragging  = true
        State.dragStart = input.Position
        State.frameStart = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if State.dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement or
        input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - State.dragStart
        MainFrame.Position = UDim2.new(
            State.frameStart.X.Scale,
            State.frameStart.X.Offset + delta.X,
            State.frameStart.Y.Scale,
            State.frameStart.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        State.dragging = false
    end
end)

-- ══════════════════════════════
--         MINIMIZE
-- ══════════════════════════════
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart)
    if minimized then
        TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 260, 0, 40)}):Play()
        MinBtn.Text = "+"
    else
        TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 260, 0, 220)}):Play()
        MinBtn.Text = "−"
    end
end)

-- ══════════════════════════════
--        MAIN LOOP
-- ══════════════════════════════
RunService.Heartbeat:Connect(function(dt)
    local charHRP, charHum = getCharParts()
    if not charHRP or not charHum or charHum.Health <= 0 then
        StatusLbl.Text      = "● Nhân vật chưa sẵn sàng"
        StatusLbl.TextColor3 = Color3.fromRGB(255, 160, 60)
        return
    end

    local targetModel, targetHRP = getTarget()

    if not targetModel or not targetHRP then
        StatusLbl.Text       = "● Không tìm thấy: "..CONFIG.TargetName
        StatusLbl.TextColor3 = Color3.fromRGB(180, 80, 80)
        return
    end

    local dist = (charHRP.Position - targetHRP.Position).Magnitude

    StatusLbl.Text = string.format("● %s  |  %.1f studs", targetModel.Name, dist)
    StatusLbl.TextColor3 = dist <= CONFIG.AttackRange
        and Color3.fromRGB(80, 255, 150)
        or  Color3.fromRGB(80, 190, 255)

    -- FACE TARGET
    if State.faceEnabled then
        faceTarget(charHRP, targetHRP)
    end

    -- AUTO ATTACK (chỉ khi trong tầm)
    if State.attackEnabled and dist <= CONFIG.AttackRange then
        local now = tick()
        if now - State.lastAttack >= CONFIG.AutoClickRate then
            State.lastAttack = now
            simulateAttack()

            -- Backup: dùng Tool nếu có
            local char = LocalPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    -- Gửi sự kiện activate tool (đánh)
                    local remoteEvent = tool:FindFirstChild("RemoteEvent")
                        or tool:FindFirstChildOfClass("RemoteEvent")
                    if remoteEvent then
                        remoteEvent:FireServer()
                    end
                    -- LocalScript event activate
                    local activated = tool:FindFirstChild("Activated")
                    if not activated then
                        -- Dùng CFrame để ép nhân vật đứng gần target
                        -- (đã face rồi, chỉ cần activate)
                        pcall(function() tool:Activate() end)
                    end
                end
            end
        end
    end
end)

-- ══════════════════════════════
--   THÔNG BÁO LOAD THÀNH CÔNG
-- ══════════════════════════════
print("╔══════════════════════════════╗")
print("║  AutoFarm GUI loaded OK!     ║")
print("║  Target: "..CONFIG.TargetName.."               ║")
print("║  Range : "..CONFIG.AttackRange.." studs             ║")
print("╚══════════════════════════════╝")
