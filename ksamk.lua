local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [ 1. إنشاء واجهة الكتابة (التي نكتب فيها) ]
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local ChatFrame = Instance.new("Frame", ScreenGui)
ChatFrame.Size = UDim2.new(0.6, 0, 0.2, 0)
ChatFrame.Position = UDim2.new(0.2, 0, 0.7, 0)
ChatFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ChatFrame.Visible = false -- تبدأ مخفية (تظهر بـ C)

local ChatInput = Instance.new("TextBox", ChatFrame)
ChatInput.Size = UDim2.new(0.8, 0, 0.5, 0)
ChatInput.Position = UDim2.new(0.1, 0, 0.1, 0)
ChatInput.PlaceholderText = "اكتب رسالتك هنا..."

local SendBtn = Instance.new("TextButton", ChatFrame)
SendBtn.Size = UDim2.new(0.4, 0, 0.3, 0)
SendBtn.Position = UDim2.new(0.3, 0, 0.65, 0)
SendBtn.Text = "إرسال"

-- [ 2. واجهة الشات (التي تقرأ منها) ]
local ChatBox = Instance.new("TextLabel", ScreenGui)
ChatBox.Size = UDim2.new(0, 250, 0, 50)
ChatBox.Position = UDim2.new(0.01, 0, 0.05, 0)
ChatBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ChatBox.BackgroundTransparency = 0.5
ChatBox.TextColor3 = Color3.new(1, 1, 1)
ChatBox.Text = "في انتظار رسائل..."

-- [ 3. نظام الراديو (الخلفية) ]
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local myRadio = Instance.new("StringValue", char)
myRadio.Name = "RADIO_TAG"

SendBtn.MouseButton1Click:Connect(function()
    myRadio.Value = ChatInput.Text
    ChatInput.Text = ""
    ChatFrame.Visible = false
    task.delay(4, function() myRadio.Value = "" end)
end)

-- [ 4. مراقبة اللاعبين (لاستقبال الرسائل) ]
local function monitorPlayer(player)
    player.CharacterAdded:Connect(function(c)
        local tag = c:WaitForChild("RADIO_TAG", 10)
        tag.Changed:Connect(function()
            if tag.Value ~= "" then
                ChatBox.Text = player.Name .. ": " .. tag.Value
            end
        end)
    end)
end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then monitorPlayer(p) end
end
Players.PlayerAdded:Connect(monitorPlayer)

-- [ 5. زر التفعيل (C) ]
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleBtn.Text = "C"
ToggleBtn.MouseButton1Click:Connect(function()
    ChatFrame.Visible = not ChatFrame.Visible
end)
