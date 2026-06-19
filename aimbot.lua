-- استخدام مجلد اللاعب المباشر لضمان استمرار التشغيل وثباته بعد الموت
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = game:GetService("Workspace").CurrentCamera
local TweenService = game:GetService("TweenService")

-- حذف أي نسخة قديمة منعاً للتداخل
if playerGui:FindFirstChild("DeltaClassicAimbot") then
    playerGui.DeltaClassicAimbot:Destroy()
end

-- إنشاء الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaClassicAimbot"
ScreenGui.ResetOnSpawn = false 
ScreenGui.Parent = playerGui

-- [ الزر الدائري باستخدام Emojis لضمان الظهور الدائم ]
local AimButton = Instance.new("TextButton")
AimButton.Size = UDim2.new(0, 60, 0, 60)
AimButton.Position = UDim2.new(0.1, 0, 0.4, 0)
AimButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AimButton.Text = "🎯" -- أيقونة التصويب
AimButton.TextSize = 30
AimButton.Visible = false
AimButton.Active = true
AimButton.Draggable = true
AimButton.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = AimButton

-- [ لوحة الترحيب ]
local WelcomeFrame = Instance.new("Frame")
WelcomeFrame.Size = UDim2.new(0, 250, 0, 60)
WelcomeFrame.Position = UDim2.new(1, 10, 0.15, 0) 
WelcomeFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
WelcomeFrame.BorderSizePixel = 0
WelcomeFrame.Parent = ScreenGui
Instance.new("UICorner", WelcomeFrame).CornerRadius = UDim.new(0, 10)

local WelcomeLabel = Instance.new("TextLabel")
WelcomeLabel.Size = UDim2.new(1, 0, 1, 0)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Text = "مطور الهاك فريد يرحب بك\nاشد الترحيب"
WelcomeLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
WelcomeLabel.TextSize = 14
WelcomeLabel.Font = Enum.Font.SourceSansBold
WelcomeLabel.Parent = WelcomeFrame

-- الشريط الرئيسي
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 40)
MainFrame.Position = UDim2.new(0.5, -150, 0.8, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0, 220, 0, 30)
TextBox.Position = UDim2.new(0, 5, 0, 5)
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.PlaceholderText = "اكتب a أو una هنا..."
TextBox.Parent = MainFrame

local ExecButton = Instance.new("TextButton")
ExecButton.Size = UDim2.new(0, 65, 0, 30)
ExecButton.Position = UDim2.new(0, 230, 0, 5)
ExecButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ExecButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecButton.Text = "تنفيذ"
ExecButton.Parent = MainFrame

local aimbotActive = false

-- منطق الهاك (Raycasting)
local function isVisible(targetCharacter)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {player.Character, camera}
    local ray = game:GetService("Workspace"):Raycast(camera.CFrame.Position, (targetCharacter.HumanoidRootPart.Position - camera.CFrame.Position), raycastParams)
    return not ray or ray.Instance:IsDescendantOf(targetCharacter)
end

-- التبديل وتغيير الأيقونة
AimButton.MouseButton1Click:Connect(function()
    aimbotActive = not aimbotActive
    AimButton.Text = aimbotActive and "❌" or "🎯"
    AimButton.BackgroundColor3 = aimbotActive and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(40, 40, 40)
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if aimbotActive then
        local closest, dist = nil, math.huge
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                local d = (v.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if d < dist and isVisible(v.Character) then
                    dist = d
                    closest = v
                end
            end
        end
        if closest then
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, closest.Character.HumanoidRootPart.Position)
        end
    end
end)

-- الترحيب
local function showWelcome()
    TweenService:Create(WelcomeFrame, TweenInfo.new(0.5), {Position = UDim2.new(1, -260, 0.15, 0)}):Play()
    task.wait(5)
    TweenService:Create(WelcomeFrame, TweenInfo.new(0.5), {Position = UDim2.new(1, 10, 0.15, 0)}):Play()
end
task.spawn(showWelcome)

ExecButton.MouseButton1Click:Connect(function()
    local input = string.lower(string.gsub(TextBox.Text, " ", ""))
    if input == "a" then AimButton.Visible = true
    elseif input == "una" then AimButton.Visible = false aimbotActive = false AimButton.Text = "🎯" AimButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40) end
    TextBox.Text = ""
end)
