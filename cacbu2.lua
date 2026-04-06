-- [[ VORTEX GOD MODE - AUTO FRAM NPC (NHẬP TÊN + RANGE) ]]
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
local frame = Instance.new("Frame", sg)
local btnKill = Instance.new("TextButton", frame)
local btnFram = Instance.new("TextButton", frame)
local nameBox = Instance.new("TextBox", frame)

-- UI
frame.Size = UDim2.new(0, 110, 0, 140)
frame.Position = UDim2.new(0.5, -55, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

btnKill.Size = UDim2.new(0.9, 0, 0.25, 0)
btnKill.Position = UDim2.new(0.05, 0, 0.05, 0)

btnFram.Size = UDim2.new(0.9, 0, 0.25, 0)
btnFram.Position = UDim2.new(0.05, 0, 0.35, 0)

nameBox.Size = UDim2.new(0.9, 0, 0.25, 0)
nameBox.Position = UDim2.new(0.05, 0, 0.7, 0)

btnKill.Text = "KILL: OFF"
btnKill.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

btnFram.Text = "FRAM: OFF"
btnFram.BackgroundColor3 = Color3.fromRGB(80, 0, 150)

nameBox.PlaceholderText = "Nhập tên NPC..."
nameBox.Text = ""
nameBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
nameBox.TextColor3 = Color3.new(1,1,1)
nameBox.Font = Enum.Font.GothamBold
nameBox.TextSize = 12

for _,v in pairs({btnKill,btnFram,nameBox}) do
    v.TextColor3 = Color3.new(1,1,1)
    v.Font = Enum.Font.GothamBold
    v.TextSize = 12
    Instance.new("UICorner", v)
end

-- LOGIC
local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local RequestHit = RS:WaitForChild("CombatSystem"):WaitForChild("Remotes"):WaitForChild("RequestHit")

_G.Kill = false
_G.Fram = false
_G.TargetName = ""

-- 🔥 LƯU TOOL CUỐI
local lastToolName = nil

nameBox.FocusLost:Connect(function()
    _G.TargetName = string.lower(nameBox.Text)
end)

btnKill.MouseButton1Click:Connect(function()
    _G.Kill = not _G.Kill
    btnKill.Text = _G.Kill and "KILL: ON" or "KILL: OFF"
    btnKill.BackgroundColor3 = _G.Kill and Color3.fromRGB(255,0,100) or Color3.fromRGB(150,0,0)
end)

btnFram.MouseButton1Click:Connect(function()
    _G.Fram = not _G.Fram
    btnFram.Text = _G.Fram and "FRAM: ON" or "FRAM: OFF"
    btnFram.BackgroundColor3 = _G.Fram and Color3.fromRGB(0,150,0) or Color3.fromRGB(80,0,150)
end)

-- 🔄 AUTO CẦM LẠI ITEM CHUẨN
local function autoEquipTool()
    local char = LP.Character
    if not char then return end

    local backpack = LP:FindFirstChild("Backpack")
    if not backpack then return end

    -- 📌 nếu đang cầm → lưu lại
    local currentTool = char:FindFirstChildOfClass("Tool")
    if currentTool then
        lastToolName = currentTool.Name
        return
    end

    -- ❗ bị rớt → lấy lại đúng tool
    if lastToolName then
        local tool = backpack:FindFirstChild(lastToolName)
        if tool then
            tool.Parent = char
            return
        end
    end

    -- 🔁 fallback
    local anyTool = backpack:FindFirstChildOfClass("Tool")
    if anyTool then
        anyTool.Parent = char
    end
end

-- 🔍 Tìm NPC
local function getTargetNPC()
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local folder = workspace:FindFirstChild("NPCs")
    if not folder then return end

    local nearest = nil
    local minDist = 200

    for _, v in pairs(folder:GetChildren()) do
        if v:FindFirstChild("Humanoid")
        and v.Humanoid.Health > 0
        and v:FindFirstChild("HumanoidRootPart") then
            
            local name = string.lower(v.Name)
            
            if _G.TargetName ~= "" and string.find(name, _G.TargetName) then
                local dist = (hrp.Position - v.HumanoidRootPart.Position).Magnitude
                
                if dist <= minDist then
                    minDist = dist
                    nearest = v
                end
            end
        end
    end

    return nearest
end

-- 🔥 CFrame FIX
local function lockToTarget(target)
    local char = LP.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    local pos = target.Position + Vector3.new(0, 8, 0)
    local fixed = CFrame.new(pos) * CFrame.Angles(math.rad(-90), 0, 0)

    hum.PlatformStand = true
    hum.AutoRotate = false

    hrp.Velocity = Vector3.zero
    hrp.RotVelocity = Vector3.zero
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    hrp.CFrame = fixed
end

local function resetChar()
    local char = LP.Character
    if not char then return end
    
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.PlatformStand = false
        hum.AutoRotate = true
    end
end

-- LOOP
task.spawn(function()
    while true do
        task.wait(0.08)
        
        pcall(function()
            autoEquipTool() -- 🔥 AUTO CẦM LẠI
            
            local target = getTargetNPC()
            
            if target and _G.Fram then
                lockToTarget(target.HumanoidRootPart)
            else
                resetChar()
            end

            if target and (_G.Kill or _G.Fram) then
                local hits = _G.Kill and 30 or 15
                
                task.wait(0.01)
                
                for i = 1, hits do
                    if not (_G.Kill or _G.Fram) then break end
                    
                    LP.Character.HumanoidRootPart.CFrame =
                        CFrame.new(target.HumanoidRootPart.Position + Vector3.new(0,8,0))
                        * CFrame.Angles(math.rad(-90),0,0)

                    RequestHit:FireServer(target)
                end
            end
        end)
    end
end)