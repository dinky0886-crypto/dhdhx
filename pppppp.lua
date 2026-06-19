local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui", PlayerGui)

-- [ 1. الشات الثابت (فوق يسار) ]
local ChatDisplay = Instance.new("TextLabel", ScreenGui)
ChatDisplay.Size = UDim2.new(0.3, 0, 0.1, 0)
ChatDisplay.Position = UDim2.new(0.01, 0, 0.02, 0)
ChatDisplay.Text = "استقبال الرسائل..."
ChatDisplay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ChatDisplay.TextColor3 = Color3.new(1, 1, 0)

-- [ 2. مربع الكتابة (فوق يمين - ثابت) ]
local ChatInput = Instance.new("TextBox", ScreenGui)
ChatInput.Size = UDim2.new(0.3, 0, 0.08, 0)
ChatInput.Position = UDim2.new(0.69, 0, 0.02, 0)
ChatInput.PlaceholderText = "اكتب هنا ثم اضغط Enter..."

-- [ 3. واجهة القوائم (تظهر بـ C) ]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0.7, 0, 0.6, 0)
MainFrame.Position = UDim2.new(0.15, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Visible = false

-- العناوين التوضيحية (الآن عادت)
local LabelTarget = Instance.new("TextLabel", MainFrame)
LabelTarget.Text = "المرسل إليه"; LabelTarget.Position = UDim2.new(0.05, 0, 0.05, 0); LabelTarget.Size = UDim2.new(0.4, 0, 0.1, 0)
local LabelSource = Instance.new("TextLabel", MainFrame)
LabelSource.Text = "المستقبل منه"; LabelSource.Position = UDim2.new(0.55, 0, 0.05, 0); LabelSource.Size = UDim2.new(0.4, 0, 0.1, 0)

local TargetList = Instance.new("ScrollingFrame", MainFrame)
TargetList.Position = UDim2.new(0.05, 0, 0.2, 0); TargetList.Size = UDim2.new(0.4, 0, 0.7, 0)
local SourceList = Instance.new("ScrollingFrame", MainFrame)
SourceList.Position = UDim2.new(0.55, 0, 0.2, 0); SourceList.Size = UDim2.new(0.4, 0, 0.7, 0)

-- [ 4. المنطق ]
local SelectedTarget, SelectedSource = "", ""
local RadioFolder = Workspace:FindFirstChild("RADIO_SYSTEM") or Instance.new("Folder", Workspace)
RadioFolder.Name = "RADIO_SYSTEM"

local function checkSelection()
    if SelectedTarget ~= "" and SelectedSource ~= "" then MainFrame.Visible = false end
end

local function updateLists()
    TargetList:ClearAllChildren(); SourceList:ClearAllChildren()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn1 = Instance.new("TextButton", TargetList)
            btn1.Text = p.Name; btn1.Size = UDim2.new(1, 0, 0, 30); btn1.Position = UDim2.new(0, 0, 0, (#TargetList:GetChildren()-1) * 30)
            btn1.MouseButton1Click:Connect(function() SelectedTarget = p.Name; btn1.BackgroundColor3 = Color3.new(0,1,0); checkSelection() end)
            
            local btn2 = Instance.new("TextButton", SourceList)
            btn2.Text = p.Name; btn2.Size = UDim2.new(1, 0, 0, 30); btn2.Position = UDim2.new(0, 0, 0, (#SourceList:GetChildren()-1) * 30)
            btn2.MouseButton1Click:Connect(function() SelectedSource = p.Name; btn2.BackgroundColor3 = Color3.new(0,1,0); checkSelection() end)
        end
    end
end

ChatInput.FocusLost:Connect(function(enter)
    if enter and SelectedTarget ~= "" then
        local tag = RadioFolder:FindFirstChild(LocalPlayer.Name) or Instance.new("StringValue", RadioFolder)
        tag.Name = LocalPlayer.Name
        tag.Value = SelectedTarget .. "|" .. ChatInput.Text
        ChatInput.Text = ""
    end
end)

RadioFolder.ChildAdded:Connect(function(child)
    child.Changed:Connect(function()
        local data = string.split(child.Value, "|")
        if data[1] == LocalPlayer.Name and child.Name == SelectedSource then
            ChatDisplay.Text = child.Name .. ": " .. data[2]
        end
    end)
end)

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50); ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0); ToggleBtn.Text = "C"
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible; if MainFrame.Visible then updateLists() end end)
