local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- [ 1. إنشاء واجهة الراديو للهاتف ]
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
local ChatFrame = Instance.new("Frame", ScreenGui)
ChatFrame.Size = UDim2.new(0.8, 0, 0.25, 0)
ChatFrame.Position = UDim2.new(0.1, 0, 0.6, 0)
ChatFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ChatFrame.Visible = false

local ChatInput = Instance.new("TextBox", ChatFrame)
ChatInput.Size = UDim2.new(0.9, 0, 0.4, 0)
ChatInput.Position = UDim2.new(0.05, 0, 0.1, 0)
ChatInput.PlaceholderText = "اكتب رسالة الراديو..."

local SendBtn = Instance.new("TextButton", ChatFrame)
SendBtn.Size = UDim2.new(0.4, 0, 0.3, 0)
SendBtn.Position = UDim2.new(0.3, 0, 0.6, 0)
SendBtn.Text = "إرسال"

-- [ 2. واجهة الشات (فوق يسار) ]
local ChatBox = Instance.new("TextLabel", ScreenGui)
ChatBox.Size = UDim2.new(0, 200, 0, 50)
ChatBox.Position = UDim2.new(0.01, 0, 0.05, 0)
ChatBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ChatBox.BackgroundTransparency = 0.5
ChatBox.TextColor3 = Color3.new(1, 1, 1)
ChatBox.Text = "في انتظار الاتصال..."

-- [ 3. زر التبديل العائم (C) ]
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleBtn.Text = "C"

ToggleBtn.MouseButton1Click:Connect(function()
    ChatFrame.Visible = not ChatFrame.Visible
end)

-- [ 4. منطق الإرسال (إنشاء البارت) ]
local function sendRadioMessage(msg)
    local p = Instance.new("Part", workspace)
    p.Name = "RADIO_" .. player.Name .. "_" .. msg
    p.Size = Vector3.new(1, 1, 1)
    p.Transparency = 1
    p.Anchored = true
    p.Position = char.HumanoidRootPart.Position + Vector3.new(0, -3, 0)
    task.delay(5, function() p:Destroy() end)
end

SendBtn.MouseButton1Click:Connect(function()
    if ChatInput.Text ~= "" then
        sendRadioMessage(ChatInput.Text)
        ChatInput.Text = ""
        ChatFrame.Visible = false
    end
end)

-- [ 5. منطق الاستقبال (الرادار) ]
RunService.Heartbeat:Connect(function()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Part") and string.sub(obj.Name, 1, 6) == "RADIO_" then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (root.Position - obj.Position).Magnitude
                if dist < 50 then -- نطاق 50 متر
                    local parts = string.split(obj.Name, "_")
                    local sender = parts[2]
                    local msg = parts[3]
                    if sender ~= player.Name then
                        ChatBox.Text = sender .. ": " .. msg
                    end
                end
            end
        end
    end
end)
