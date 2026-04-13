-- [[ VORTEX GOD MODE - FIX FULL LOOT + RETURN SMOOTH ]]

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
local frame = Instance.new("Frame", sg)

local btnKill = Instance.new("TextButton", frame)
local btnFram = Instance.new("TextButton", frame)
local btnLoot = Instance.new("TextButton", frame)
local btnReturn = Instance.new("TextButton", frame)
local nameBox = Instance.new("TextBox", frame)

-- UI
frame.Size = UDim2.new(0, 110, 0, 220)
frame.Position = UDim2.new(0.5, -55, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local function style(btn)
    btn.Size = UDim2.new(0.9,0,0.16,0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn)
end

btnKill.Position = UDim2.new(0.05,0,0.05,0)
btnFram.Position = UDim2.new(0.05,0,0.23,0)
btnLoot.Position = UDim2.new(0.05,0,0.41,0)
btnReturn.Position = UDim2.new(0.05,0,0.59,0)

style(btnKill)
style(btnFram)
style(btnLoot)
style(btnReturn)

nameBox.Size = UDim2.new(0.9,0,0.16,0)
nameBox.Position = UDim2.new(0.05,0,0.77,0)
style(nameBox)

btnKill.Text = "KILL: OFF"
btnFram.Text = "FRAM: OFF"
btnLoot.Text = "LOOT: OFF"
btnReturn.Text = "RETURN: OFF"

-- SERVICES
local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local RequestHit = RS:WaitForChild("CombatSystem"):WaitForChild("Remotes"):WaitForChild("RequestHit")

-- STATE
_G.Kill = false
_G.Fram = false
_G.Loot = false
_G.Return = false
_G.TargetName = ""

local savedCFrame = nil
local returnTimer = 0
local returning = false -- 🆕 chống chồng

-- TOOL
local lastToolName

nameBox.FocusLost:Connect(function()
    _G.TargetName = string.lower(nameBox.Text)
end)

btnKill.MouseButton1Click:Connect(function()
    _G.Kill = not _G.Kill
    btnKill.Text = _G.Kill and "KILL: ON" or "KILL: OFF"
end)

btnFram.MouseButton1Click:Connect(function()
    _G.Fram = not _G.Fram
    btnFram.Text = _G.Fram and "FRAM: ON" or "FRAM: OFF"
end)

btnLoot.MouseButton1Click:Connect(function()
    _G.Loot = not _G.Loot
    btnLoot.Text = _G.Loot and "LOOT: ON" or "LOOT: OFF"
end)

btnReturn.MouseButton1Click:Connect(function()
    _G.Return = not _G.Return
    btnReturn.Text = _G.Return and "RETURN: ON" or "RETURN: OFF"

    if _G.Return then
        local char = LP.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            savedCFrame = char.HumanoidRootPart.CFrame
        end
    end
end)

-- AUTO EQUIP
local function autoEquipTool()
    local char = LP.Character
    if not char then return end

    local backpack = LP:FindFirstChild("Backpack")

    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        lastToolName = tool.Name
        return
    end

    if lastToolName and backpack then
        local t = backpack:FindFirstChild(lastToolName)
        if t then t.Parent = char end
    end
end

-- 🔒 FIX FRAM
local function lockTarget(target)
    local char = LP.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    hum.PlatformStand = true
    hum.AutoRotate = false

    hrp.Velocity = Vector3.zero
    hrp.AssemblyLinearVelocity = Vector3.zero

    hrp.CFrame =
        target.CFrame * CFrame.new(0,8,0)
        * CFrame.Angles(math.rad(-90),0,0)
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

-- LOOT
local lootCD = 0
local function autoLoot(dt)
    if not _G.Loot then return end

    local char = LP.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    lootCD += dt
    if lootCD < 0.1 then return end -- 🔥 nhanh hơn
    lootCD = 0

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Enabled then
            local p = v.Parent
            if p and p:IsA("BasePart") then
                if (hrp.Position - p.Position).Magnitude <= 20 then
                    fireproximityprompt(v)
                end
            end
        end
    end
end

-- 🔁 RETURN FIX
local function doReturn()
    if returning then return end
    returning = true

    local char = LP.Character
    if not char then returning = false return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then returning = false return end

    local old = hrp.CFrame
    local oldFram = _G.Fram

    _G.Fram = false
    resetChar()

    -- ⚡ về vị trí
    hrp.CFrame = savedCFrame

    -- 🔥 đứng + loot liên tục
    local t = 0
    while t < 3 do
        t += 0.2

        if _G.Loot then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") and v.Enabled then
                    local p = v.Parent
                    if p and p:IsA("BasePart") then
                        if (hrp.Position - p.Position).Magnitude <= 20 then
                            fireproximityprompt(v)
                        end
                    end
                end
            end
        end

        task.wait(0.2)
    end

    -- ⚡ quay lại
    hrp.CFrame = old

    task.wait(0.50)

    _G.Fram = oldFram
    returning = false
end

local function autoReturn(dt)
    if not _G.Return or not savedCFrame then return end

    returnTimer += dt
    if returnTimer < 10 then return end
    returnTimer = 0

    task.spawn(doReturn) -- 🔥 không block loop
end

-- FIND NPC
local function getTarget()
    local char = LP.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local folder = workspace:FindFirstChild("NPCs")
    if not hrp or not folder then return end

    local nearest, dist = nil, 200

    for _,v in pairs(folder:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            if string.find(string.lower(v.Name), _G.TargetName) then
                local d = (hrp.Position - v.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = v
                end
            end
        end
    end

    return nearest
end

-- LOOP
task.spawn(function()
    while true do
        local dt = task.wait(0.08)

        pcall(function()
            autoEquipTool()
            autoLoot(dt)
            autoReturn(dt)

            local target = getTarget()

            if target then
                if _G.Fram then
                    lockTarget(target.HumanoidRootPart)
                else
                    resetChar()
                end

                if (_G.Kill or _G.Fram) then
                    for i = 1, 15 do
                        RequestHit:FireServer(target)
                    end
                end
            end
        end)
    end
end)