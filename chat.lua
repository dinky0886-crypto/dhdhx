local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- [ 1. إنشاء الواجهة بنظام الـ Scale للهاتف ]
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
ScreenGui.Name = "MobileRadioGui"

local ChatFrame = Instance.new("Frame", ScreenGui)
ChatFrame.Size = UDim2.new(0.8, 0, 0.25, 0) -- حجم نسبي للشاشة
ChatFrame.Position = UDim2.new(0.1, 0, 0.6, 0)
ChatFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ChatFrame.Visible = false

local ChatInput = Instance.new("TextBox", ChatFrame)
ChatInput.Size = UDim2.new(0.9, 0, 0.5, 0)
ChatInput.Position = UDim2.new(0.05, 0, 0.1, 0)
ChatInput.PlaceholderText = "اكتب رسالتك..."
ChatInput.TextSize = 16 -- حجم خط مناسب للهاتف

local SendButton = Instance.new("TextButton", ChatFrame)
SendButton.Size = UDim2.new(0.4, 0, 0.3, 0)
SendButton.Position = UDim2.new(0.3, 0, 0.65, 0)
SendButton.Text = "إرسال"
SendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)

-- [ 2. منطق الراديو والرسائل ]
local myTransmitter = Instance.new("Part", character)
myTransmitter.Name = "RadioTransmitter"
myTransmitter.Transparency = 1 -- غير مرئي
myTransmitter.Anchored = true
myTransmitter.CanCollide = false

local function sendSentence(sentence)
    for i = 1, #sentence do
        myTransmitter.Transparency = string.byte(string.sub(sentence, i, i)) / 1000
        task.wait(0.2)
    end
    myTransmitter.Transparency = 0
end

-- [ 3. التحكم باللمس (زر C) ]
-- بما أن الموبايل لا يحتوي على زر C، نضع زر دائري صغير عائم
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleBtn.Text = "C"

ToggleBtn.MouseButton1Click:Connect(function()
    ChatFrame.Visible = not ChatFrame.Visible
end)

SendButton.MouseButton1Click:Connect(function()
    local text = ChatInput.Text
    if text == "unc" then
        ChatFrame.Visible = false
    elseif text ~= "" then
        sendSentence(text)
        ChatInput.Text = ""
    end
end)
