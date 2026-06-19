local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))

-- [ 1. الشات الثابت ومربع الكتابة ]
local ChatDisplay = Instance.new("TextLabel", ScreenGui)
ChatDisplay.Size = UDim2.new(0.3, 0, 0.1, 0); ChatDisplay.Position = UDim2.new(0.01, 0, 0.02, 0)
ChatDisplay.Text = "في انتظار رسالة..."; ChatDisplay.BackgroundColor3 = Color3.new(0,0,0); ChatDisplay.TextColor3 = Color3.new(1,1,0)

local ChatInput = Instance.new("TextBox", ScreenGui)
ChatInput.Size = UDim2.new(0.3, 0, 0.08, 0); ChatInput.Position = UDim2.new(0.69, 0, 0.02, 0)
ChatInput.PlaceholderText = "اكتب رسالتك هنا..."

-- [ 2. واجهة القوائم (C) ]
local MainFrame = Instance.new("Frame", ScreenGui); MainFrame.Size = UDim2.new(0.7, 0, 0.6, 0); MainFrame.Position = UDim2.new(0.15, 0, 0.2, 0); MainFrame.Visible = false
local TargetList = Instance.new("ScrollingFrame", MainFrame); TargetList.Position = UDim2.new(0.05, 0, 0.2, 0); TargetList.Size = UDim2.new(0.4, 0, 0.7, 0)
local SourceList = Instance.new("ScrollingFrame", MainFrame); SourceList.Position = UDim2.new(0.55, 0, 0.2, 0); SourceList.Size = UDim2.new(0.4, 0, 0.7, 0)
local L1 = Instance.new("TextLabel", MainFrame); L1.Text = "المرسل إليه"; L1.Position = UDim2.new(0.05, 0, 0.1, 0); L1.Size = UDim2.new(0.4, 0, 0.1, 0)
local L2 = Instance.new("TextLabel", MainFrame); L2.Text = "المستقبل منه"; L2.Position = UDim2.new(0.55, 0, 0.1, 0); L2.Size = UDim2.new(0.4, 0, 0.1, 0)

-- [ 3. المنطق ]
local SelectedTarget, SelectedSource = "", ""
local function updateLists()
    TargetList:ClearAllChildren(); SourceList:ClearAllChildren()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn1 = Instance.new("TextButton", TargetList); btn1.Text = p.Name; btn1.Size = UDim2.new(1, 0, 0, 30); btn1.Position = UDim2.new(0, 0, 0, (#TargetList:GetChildren()-1) * 30)
            btn1.MouseButton1Click:Connect(function() SelectedTarget = p.Name; btn1.BackgroundColor3 = Color3.new(0,1,0); if SelectedTarget ~= "" and SelectedSource ~= "" then MainFrame.Visible = false end end)
            
            local btn2 = Instance.new("TextButton", SourceList); btn2.Text = p.Name; btn2.Size = UDim2.new(1, 0, 0, 30); btn2.Position = UDim2.new(0, 0, 0, (#SourceList:GetChildren()-1) * 30)
            btn2.MouseButton1Click:Connect(function() SelectedSource = p.Name; btn2.BackgroundColor3 = Color3.new(0,1,0); if SelectedTarget ~= "" and SelectedSource ~= "" then MainFrame.Visible = false end end)
        end
    end
end

ChatInput.FocusLost:Connect(function(enter)
    if enter and SelectedTarget ~= "" then
        LocalPlayer.Character:SetAttribute("RADIO_DATA", SelectedTarget .. "|" .. ChatInput.Text)
        ChatInput.Text = ""
        task.delay(3, function() LocalPlayer.Character:SetAttribute("RADIO_DATA", nil) end)
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local data = p.Character:GetAttribute("RADIO_DATA")
            if data then
                local parts = string.split(data, "|")
                if parts[1] == LocalPlayer.Name and p.Name == SelectedSource then
                    ChatDisplay.Text = p.Name .. ": " .. parts[2]
                end
            end
        end
    end
end)

local ToggleBtn = Instance.new("TextButton", ScreenGui); ToggleBtn.Size = UDim2.new(0, 50, 0, 50); ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0); ToggleBtn.Text = "C"
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible; if MainFrame.Visible then updateLists() end end)
