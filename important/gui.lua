local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Name = "PremiumGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.BorderSizePixel = 0
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0.7, 0, 0.8, 0)
main.Name = "MainFrame"
main.Parent = gui

local aspect = Instance.new("UIAspectRatioConstraint")
aspect.AspectRatio = 4/3
aspect.DominantAxis = Enum.DominantAxis.Height
aspect.Parent = main

local titleBar = Instance.new("Frame")
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.BorderSizePixel = 0
titleBar.Size = UDim2.new(1, 0, 0.08, 0)
titleBar.Name = "TitleBar"
titleBar.Parent = main

local title = Instance.new("TextLabel")
title.Font = Enum.Font.FredokaOne
title.Text = "PREMIUM UI"
title.TextColor3 = Color3.fromRGB(220, 220, 255)
title.TextSize = 22
title.BackgroundTransparency = 1
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0.02, 0, 0, 0)
title.Parent = titleBar

local close = Instance.new("TextButton")
close.Font = Enum.Font.FredokaOne
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 150, 150)
close.TextSize = 20
close.BackgroundTransparency = 1
close.Size = UDim2.new(0.1, 0, 1, 0)
close.Position = UDim2.new(0.9, 0, 0, 0)
close.Name = "CloseButton"
close.Parent = titleBar

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local minimize = Instance.new("TextButton")
minimize.Font = Enum.Font.FredokaOne
minimize.Text = "_"
minimize.TextColor3 = Color3.fromRGB(150, 200, 255)
minimize.TextSize = 20
minimize.BackgroundTransparency = 1
minimize.Size = UDim2.new(0.1, 0, 1, 0)
minimize.Position = UDim2.new(0.8, 0, 0, 0)
minimize.Name = "MinButton"
minimize.Parent = titleBar

local contentVisible = true
minimize.MouseButton1Click:Connect(function()
    contentVisible = not contentVisible
    content.Visible = contentVisible
    watermark.Visible = contentVisible
end)

local content = Instance.new("ScrollingFrame")
content.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
content.BorderSizePixel = 0
content.Position = UDim2.new(0.02, 0, 0.1, 0)
content.Size = UDim2.new(0.96, 0, 0.8, 0)
content.BottomImage = "rbxassetid://5234388158"
content.MidImage = "rbxassetid://5234388158"
content.TopImage = "rbxassetid://5234388158"
content.ScrollBarThickness = 6
content.ScrollBarImageColor3 = Color3.fromRGB(65, 150, 200)
content.VerticalScrollBarInset = Enum.ScrollBarInset.Always
content.CanvasSize = UDim2.new(0, 0, 2, 0)
content.Name = "Content"
content.Parent = main
content.ElasticBehavior = Enum.ElasticBehavior.Never

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = content

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 10)
padding.Parent = content

for i = 1, 15 do
    local item = Instance.new("TextLabel")
    item.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    item.BorderSizePixel = 0
    item.Size = UDim2.new(0.95, 0, 0.15, 0)
    item.Font = Enum.Font.GothamSemibold
    item.Text = "Premium Item " .. i
    item.TextColor3 = Color3.fromRGB(220, 220, 255)
    item.TextSize = 18
    item.Parent = content
end

local watermark = Instance.new("TextLabel")
watermark.Font = Enum.Font.FredokaOne
watermark.Text = "created by pocari ;)"
watermark.TextColor3 = Color3.fromRGB(100, 100, 150)
watermark.TextSize = 14
watermark.BackgroundTransparency = 1
watermark.Size = UDim2.new(1, 0, 0.05, 0)
watermark.Position = UDim2.new(0, 0, 0.95, 0)
watermark.Parent = main

local resize = Instance.new("UISizeConstraint")
resize.MinSize = Vector2.new(300, 400)
resize.Parent = main

local function updateMobile()
    if game:GetService("UserInputService").TouchEnabled then
        main.Size = UDim2.new(0.9, 0, 0.9, 0)
    end
end

updateMobile()
