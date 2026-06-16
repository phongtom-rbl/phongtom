local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local AutoEnabled = false
local TeleportEnabled = false

if not LocalPlayer then
    LocalPlayer = LocalPlayer.LocalPlayerAdded:Wait()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoReviveGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 130)
Frame.Position = UDim2.new(0.5, -110, 0.5, -65)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = Frame

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, -24, 0, 48)
Button.Position = UDim2.new(0, 12, 0, 12)
Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Button.BorderSizePixel = 0
Button.Text = "Auto Cứu: TẮT"
Button.TextColor3 = Color3.fromRGB(255, 100, 100)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 18
Button.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = Button

local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(1, -24, 0, 48)
TeleportButton.Position = UDim2.new(0, 12, 0, 70)
TeleportButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TeleportButton.BorderSizePixel = 0
TeleportButton.Text = "Lấy Cứu: TẮT"
TeleportButton.TextColor3 = Color3.fromRGB(255, 100, 100)
TeleportButton.Font = Enum.Font.SourceSansBold
TeleportButton.TextSize = 18
TeleportButton.Parent = Frame

local TeleportButtonCorner = Instance.new("UICorner")
TeleportButtonCorner.CornerRadius = UDim.new(0, 8)
TeleportButtonCorner.Parent = TeleportButton

LocalPlayer.CharacterAdded:Connect(function()
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end)

local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

local function hasDeadAnim(character)
    for _, v in ipairs(character:GetDescendants()) do
        if string.lower(v.Name) == "deadanim" then
            return true
        end
    end
    return false
end

local function stepTeleport(targetPos)
    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local distance = (targetPos - hrp.Position).Magnitude

    while distance > 5 and (AutoEnabled or TeleportEnabled) do
        local currentChar = LocalPlayer.Character
        if not currentChar then break end
        local currentHRP = currentChar:FindFirstChild("HumanoidRootPart")
        if not currentHRP then break end

        local dir = (targetPos - currentHRP.Position).Unit
        currentHRP.CFrame = currentHRP.CFrame + dir * math.min(15, distance)

        task.wait(0.01)
        distance = (targetPos - currentHRP.Position).Magnitude
    end

    if (AutoEnabled or TeleportEnabled) and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(targetPos)
    end
end

local TELEPORT_TARGET = Vector3.new(791.07, 19.51, -392.51)

task.spawn(function()
    while task.wait(0.1) do
        if AutoEnabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    if hasDeadAnim(plr.Character) then
                        local targetHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                        if targetHRP then
                            stepTeleport(targetHRP.Position + Vector3.new(0, 2, 0))
                            break
                        end
                    end
                end
            end
        end
    end
end)

local PICK_DISTANCE = 3

task.spawn(function()
    while task.wait(0.5) do
        if AutoEnabled then
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")

            if hrp then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not AutoEnabled then
                        break
                    end

                    if obj:IsA("ProximityPrompt") and obj.Enabled then
                        local parent = obj.Parent

                        if parent and parent:IsA("BasePart") then
                            if (parent.Position - hrp.Position).Magnitude <= PICK_DISTANCE then
                                pcall(function()
                                    fireproximityprompt(obj)
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        if TeleportEnabled then
            pcall(function()
                local character = LocalPlayer.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        stepTeleport(TELEPORT_TARGET)
                    end
                end
            end)
        end
    end
end)

Button.MouseButton1Click:Connect(function()
    AutoEnabled = not AutoEnabled

    if AutoEnabled then
        Button.Text = "Auto Cứu: BẬT"
        Button.TextColor3 = Color3.fromRGB(100, 255, 100)
        Button.BackgroundColor3 = Color3.fromRGB(50, 65, 50)
    else
        Button.Text = "Auto Cứu: TẮT"
        Button.TextColor3 = Color3.fromRGB(255, 100, 100)
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end)

TeleportButton.MouseButton1Click:Connect(function()
    TeleportEnabled = not TeleportEnabled

    if TeleportEnabled then
        TeleportButton.Text = "Lấy Cứu: BẬT"
        TeleportButton.TextColor3 = Color3.fromRGB(100, 255, 100)
        TeleportButton.BackgroundColor3 = Color3.fromRGB(50, 65, 50)
    else
        TeleportButton.Text = "Lấy Cứu: TẮT"
        TeleportButton.TextColor3 = Color3.fromRGB(255, 100, 100)
        TeleportButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end)