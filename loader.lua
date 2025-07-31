local gui = Instance.new("ScreenGui")
gui.Name = "PocariGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 360)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.ClipsDescendants = true

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

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 8)
titleBarCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "SECURITY NOTICE"
title.Font = Enum.Font.FredokaOne
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.BackgroundTransparency = 1
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left

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

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.BackgroundTransparency = 1
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 40)

local header = Instance.new("TextLabel")
header.Name = "Header"
header.Text = "Whoops! Stop Right There..."
header.Font = Enum.Font.FredokaOne
header.TextSize = 22
header.TextColor3 = Color3.fromRGB(255, 100, 100)
header.TextWrapped = true
header.BackgroundTransparency = 1
header.Size = UDim2.new(1, 0, 0, 40)
header.Position = UDim2.new(0, 0, 0, 10)
header.TextXAlignment = Enum.TextXAlignment.Center

local warningText = Instance.new("TextLabel")
warningText.Name = "WarningText"
warningText.Text = "Before you can access the script, you must understand that these exploits are server sensitive it may usually do a server restart. Why? It is to prevent your account for soft-bans (ex. Trade Failed, Data Loss, Contact Mods, etc). During the server restart (when your Screen Freezes, Blurred, etc. ) don't do anything just wait it out and it will only take 1min ~ 3mins. If you understand and wish to proceed please press the Activate button below."
warningText.Font = Enum.Font.GothamSemibold
warningText.TextSize = 14
warningText.TextColor3 = Color3.fromRGB(200, 200, 200)
warningText.TextWrapped = true
warningText.TextXAlignment = Enum.TextXAlignment.Left
warningText.TextYAlignment = Enum.TextYAlignment.Top
warningText.BackgroundTransparency = 1
warningText.Size = UDim2.new(1, 0, 0, 180)
warningText.Position = UDim2.new(0, 0, 0, 60)

local activateButton = Instance.new("TextButton")
activateButton.Name = "ActivateButton"
activateButton.Text = "ACTIVATE"
activateButton.Font = Enum.Font.GothamBold
activateButton.TextSize = 18
activateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
activateButton.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
activateButton.Size = UDim2.new(0, 140, 0, 40)
activateButton.Position = UDim2.new(0.5, -70, 1, -60)
activateButton.AutoButtonColor = false

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = activateButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(180, 240, 180)
buttonStroke.Thickness = 2
buttonStroke.Parent = activateButton

local watermark = Instance.new("TextLabel")
watermark.Name = "Watermark"
watermark.Text = "made by pocari"
watermark.Font = Enum.Font.GothamSemibold
watermark.TextSize = 10
watermark.TextColor3 = Color3.fromRGB(150, 150, 150)
watermark.BackgroundTransparency = 1
watermark.Size = UDim2.new(1, 0, 0, 16)
watermark.Position = UDim2.new(0, 0, 1, -16)
watermark.TextYAlignment = Enum.TextYAlignment.Top

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

activateButton.Active = false
activateButton.TextTransparency = 0.5
activateButton.BackgroundTransparency = 0.5
buttonStroke.Transparency = 0.5

local countdown = 7
local countdownText = activateButton:Clone()
countdownText.Name = "CountdownText"
countdownText.Text = tostring(countdown)
countdownText.TextTransparency = 0
countdownText.BackgroundTransparency = 1
countdownText.TextColor3 = Color3.fromRGB(255, 255, 255)
countdownText.Size = UDim2.new(1, 0, 1, 0)
countdownText.Position = UDim2.new(0, 0, 0, 0)
countdownText.UIStroke:Destroy()
countdownText.Parent = activateButton

delay(7, function()
    while countdown > 0 do
        countdown = countdown - 1
        countdownText.Text = tostring(countdown)
        wait(1)
    end
    countdownText:Destroy()
    activateButton.Active = true
    activateButton.TextTransparency = 0
    activateButton.BackgroundTransparency = 0
    buttonStroke.Transparency = 0
end)

activateButton.MouseEnter:Connect(function()
    if activateButton.Active then
        activateButton.BackgroundColor3 = Color3.fromRGB(80, 200, 100)
    end
end)

activateButton.MouseLeave:Connect(function()
    if activateButton.Active then
        activateButton.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
    end
end)

watermark.Parent = mainFrame
header.Parent = contentFrame
warningText.Parent = contentFrame
activateButton.Parent = contentFrame
contentFrame.Parent = mainFrame
closeButton.Parent = titleBar
title.Parent = titleBar
titleBar.Parent = mainFrame
mainFrame.Parent = gui
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
