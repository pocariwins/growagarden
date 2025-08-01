local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Name = "PocarisExploits"
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.BorderSizePixel = 0
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0.42, 0, 0.48, 0)
main.Name = "MainFrame"
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.03, 0)
corner.Parent = main

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

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0.03, 0)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Font = Enum.Font.FredokaOne
title.Text = "Pocari's Exploits"
title.TextColor3 = Color3.fromRGB(220, 220, 255)
title.TextSize = 18
title.BackgroundTransparency = 1
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0.02, 0, 0, 0)
title.Parent = titleBar

local close = Instance.new("TextButton")
close.Font = Enum.Font.FredokaOne
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 150, 150)
close.TextSize = 18
close.BackgroundTransparency = 1
close.Size = UDim2.new(0.1, 0, 1, 0)
close.Position = UDim2.new(0.9, 0, 0, 0)
close.Name = "CloseButton"
close.Parent = titleBar

local minimize = Instance.new("TextButton")
minimize.Font = Enum.Font.FredokaOne
minimize.Text = "_"
minimize.TextColor3 = Color3.fromRGB(150, 200, 255)
minimize.TextSize = 18
minimize.BackgroundTransparency = 1
minimize.Size = UDim2.new(0.1, 0, 1, 0)
minimize.Position = UDim2.new(0.8, 0, 0, 0)
minimize.Name = "MinButton"
minimize.Parent = titleBar

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
content.ScrollingDirection = Enum.ScrollingDirection.Y

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0.02, 0)
contentCorner.Parent = content

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = content

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 10)
padding.Parent = content

for i = 1, 12 do
    local item = Instance.new("TextLabel")
    item.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    item.BorderSizePixel = 0
    item.Size = UDim2.new(0.95, 0, 0.15, 0)
    item.Font = Enum.Font.GothamSemibold
    item.Text = "Premium Item " .. i
    item.TextColor3 = Color3.fromRGB(220, 220, 255)
    item.TextSize = 16
    item.Parent = content
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0.02, 0)
    itemCorner.Parent = item
end

local watermark = Instance.new("TextLabel")
watermark.Font = Enum.Font.FredokaOne
watermark.Text = "created by pocari ;)"
watermark.TextColor3 = Color3.fromRGB(100, 100, 150)
watermark.TextSize = 12
watermark.BackgroundTransparency = 1
watermark.Size = UDim2.new(1, 0, 0.05, 0)
watermark.Position = UDim2.new(0, 0, 0.95, 0)
watermark.Parent = main

local resize = Instance.new("UISizeConstraint")
resize.MinSize = Vector2.new(280, 320)
resize.Parent = main

local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

local minimized = false
local tweenService = game:GetService("TweenService")

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    if minimized then
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
        tweenService:Create(content, tweenInfo, {Size = UDim2.new(0.96, 0, 0, 0)}):Play()
        tweenService:Create(watermark, tweenInfo, {Position = UDim2.new(0, 0, 0.08, 0)}):Play()
        tweenService:Create(main, tweenInfo, {Size = UDim2.new(0.42, 0, 0.08, 0)}):Play()
    else
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
        tweenService:Create(content, tweenInfo, {Size = UDim2.new(0.96, 0, 0.8, 0)}):Play()
        tweenService:Create(watermark, tweenInfo, {Position = UDim2.new(0, 0, 0.95, 0)}):Play()
        tweenService:Create(main, tweenInfo, {Size = UDim2.new(0.42, 0, 0.48, 0)}):Play()
    end
end)

close.MouseButton1Click:Connect(function()
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
    local closeTween = tweenService:Create(main, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
    closeTween:Play()
    closeTween.Completed:Wait()
    gui:Destroy()
end)

local function updateMobile()
    if game:GetService("UserInputService").TouchEnabled then
        main.Size = UDim2.new(0.85, 0, 0.8, 0)
    end
end

updateMobile()
