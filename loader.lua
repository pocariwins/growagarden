local gui = Instance.new("ScreenGui")
gui.Name = "PocariGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 240)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -120)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local mainBorder = Instance.new("UIStroke")
mainBorder.Color = Color3.fromRGB(230, 230, 230)
mainBorder.Thickness = 3
mainBorder.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
titleBar.ClipsDescendants = true
titleBar.Parent = mainFrame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 8)
titleBarCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "ACTIVATION REQUIRED"
title.Font = Enum.Font.FredokaOne
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.BackgroundTransparency = 1
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Text = "×"
closeButton.Font = Enum.Font.GothamSemibold
closeButton.TextSize = 22
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -32, 0, 2)
closeButton.BorderSizePixel = 0
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "ContentFrame"
contentFrame.BackgroundTransparency = 1
contentFrame.Size = UDim2.new(1, -16, 1, -60)
contentFrame.Position = UDim2.new(0, 8, 0, 40)
contentFrame.ScrollBarThickness = 5
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
contentFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
contentFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Parent = contentFrame
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- FIX: This ensures UIListLayout calculates sizes properly
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end)

local padding = Instance.new("UIPadding")
padding.Parent = contentFrame
padding.PaddingLeft = UDim.new(0, 5)
padding.PaddingRight = UDim.new(0, 5)
padding.PaddingTop = UDim.new(0, 5)

local warningTitle = Instance.new("TextLabel")
warningTitle.Name = "WarningTitle"
warningTitle.Text = "Whoops! Stop Right There.."
warningTitle.Font = Enum.Font.FredokaOne
warningTitle.TextSize = 18
warningTitle.TextColor3 = Color3.fromRGB(255, 60, 60)
warningTitle.BackgroundTransparency = 1
warningTitle.Size = UDim2.new(1, 0, 0, 24)
warningTitle.TextXAlignment = Enum.TextXAlignment.Left
warningTitle.LayoutOrder = 1
warningTitle.Parent = contentFrame

local description = Instance.new("TextLabel")
description.Name = "Description"
description.Text = "Before you can have the access for the exploits. I wanted you to understand that the script you are executing are very sensitive towards servers, now keep in mind that it does the job done but it also assures your account safety. Therefore script will conduct several server restarts during the execution of the scripts/exploits and server restarts will only lasts for approximately 1min to 3mins, making sure you are in the safe server. Now, why does the script server restarts, well its because game light-ban their players by disabling the gifting feature for the account (ex. Trade Failed, Data Loss). During the server restart please refrain from doing anything to keep your account totally safe. Please wait 7 seconds before activating. Enjoy and Goodluck ;)"
description.Font = Enum.Font.Gotham
description.TextSize = 14
description.TextColor3 = Color3.fromRGB(220, 220, 220)
description.BackgroundTransparency = 1
description.Size = UDim2.new(1, 0, 0, 0)
description.TextWrapped = true
description.TextXAlignment = Enum.TextXAlignment.Justify
description.AutomaticSize = Enum.AutomaticSize.Y
description.LayoutOrder = 2
description.Parent = contentFrame

local timerText = Instance.new("TextLabel")
timerText.Name = "TimerText"
timerText.Text = "Activation available in: 7 seconds"
timerText.Font = Enum.Font.Gotham
timerText.TextSize = 14
timerText.TextColor3 = Color3.fromRGB(255, 150, 50)
timerText.BackgroundTransparency = 1
timerText.Size = UDim2.new(1, 0, 0, 20)
timerText.TextXAlignment = Enum.TextXAlignment.Center
timerText.LayoutOrder = 3
timerText.Parent = contentFrame

local activateButton = Instance.new("TextButton")
activateButton.Name = "ActivateButton"
activateButton.Text = "ACTIVATE"
activateButton.Font = Enum.Font.FredokaOne
activateButton.TextSize = 18
activateButton.TextColor3 = Color3.fromRGB(150, 150, 150)
activateButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
activateButton.Size = UDim2.new(1, 0, 0, 40)  -- FIX: Changed to full width
activateButton.AutoButtonColor = false
activateButton.Active = false
activateButton.LayoutOrder = 4
activateButton.Parent = contentFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = activateButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(70, 70, 70)
buttonStroke.Thickness = 2
buttonStroke.Parent = activateButton

local userInput = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local dragging
local dragInput
local dragStart
local startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

userInput.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
end)

local pulseTween = tweenService:Create(
    mainBorder,
    TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Color = Color3.fromRGB(255, 255, 255)}
)
pulseTween:Play()

activateButton.MouseEnter:Connect(function()
    if activateButton.Active then
        activateButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end)

activateButton.MouseLeave:Connect(function()
    if activateButton.Active then
        activateButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    else
        activateButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

-- FIX: Added this to ensure UI elements render before countdown starts
task.wait(0.1)

-- Start countdown after GUI is fully created
local function startCountdown()
    local seconds = 7
    for i = seconds, 1, -1 do
        timerText.Text = "Activation available in: " .. i .. " seconds"
        wait(1)
    end
    
    timerText.Text = "Activation available now!"
    timerText.TextColor3 = Color3.fromRGB(0, 200, 0)
    
    activateButton.Active = true
    activateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    activateButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    buttonStroke.Color = Color3.fromRGB(100, 100, 100)
end

startCountdown()
