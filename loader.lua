local gui = Instance.new("ScreenGui")
gui.Name = "PocariGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main frame optimized for landscape (width 80% of screen, height 70% of screen)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0.8, 0, 0.7, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.ClipsDescendants = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local mainBorder = Instance.new("UIStroke")
mainBorder.Color = Color3.fromRGB(230, 230, 230)
mainBorder.Thickness = 3
mainBorder.Parent = mainFrame

-- Title bar with increased height for better touch
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
titleBar.ClipsDescendants = true

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 8)
titleBarCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "ACTIVATION REQUIRED"
title.Font = Enum.Font.FredokaOne
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.BackgroundTransparency = 1
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Larger close button for mobile
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Text = "×"
closeButton.Font = Enum.Font.GothamSemibold
closeButton.TextSize = 28
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0.5, -20)
closeButton.AnchorPoint = Vector2.new(0, 0.5)
closeButton.BorderSizePixel = 0

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Content area with increased padding
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "ContentFrame"
contentFrame.BackgroundTransparency = 1
contentFrame.Size = UDim2.new(1, -20, 1, -65)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.ScrollBarThickness = 8
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
contentFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"

local layout = Instance.new("UIListLayout")
layout.Parent = contentFrame
layout.Padding = UDim.new(0, 15)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local padding = Instance.new("UIPadding")
padding.Parent = contentFrame
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)
padding.PaddingTop = UDim.new(0, 8)

-- Adjusted text elements
local warningTitle = Instance.new("TextLabel")
warningTitle.Name = "WarningTitle"
warningTitle.Text = "Whoops! Stop Right There.."
warningTitle.Font = Enum.Font.FredokaOne
warningTitle.TextSize = 22
warningTitle.TextColor3 = Color3.fromRGB(255, 60, 60)
warningTitle.BackgroundTransparency = 1
warningTitle.Size = UDim2.new(1, 0, 0, 30)
warningTitle.TextXAlignment = Enum.TextXAlignment.Left
warningTitle.LayoutOrder = 1

local description = Instance.new("TextLabel")
description.Name = "Description"
description.Text = "Before you can have the access for the exploits. I wanted you to understand that the script you are executing are very sensitive towards servers, now keep in mind that it does the job done but it also assures your account safety. Therefore script will conduct several server restarts during the execution of the scripts/exploits and server restarts will only lasts for approximately 1min to 3mins, making sure you are in the safe server. Now, why does the script server restarts, well its because game light-ban their players by disabling the gifting feature for the account (ex. Trade Failed, Data Loss). During the server restart please refrain from doing anything to keep your account totally safe. If you agree please proceed to tick the check box below this message and press Activate button. Enjoy and Goodluck ;)"
description.Font = Enum.Font.Gotham
description.TextSize = 16  -- Increased for readability
description.TextColor3 = Color3.fromRGB(220, 220, 220)
description.BackgroundTransparency = 1
description.Size = UDim2.new(1, 0, 0, 0)
description.TextWrapped = true
description.TextXAlignment = Enum.TextXAlignment.Left
description.AutomaticSize = Enum.AutomaticSize.Y
description.LayoutOrder = 2

-- Larger checkbox for touch
local checkFrame = Instance.new("Frame")
checkFrame.Name = "CheckFrame"
checkFrame.BackgroundTransparency = 1
checkFrame.Size = UDim2.new(1, 0, 0, 35)
checkFrame.LayoutOrder = 3

local checkbox = Instance.new("TextButton")
checkbox.Name = "CheckBox"
checkbox.Text = ""
checkbox.Size = UDim2.new(0, 35, 0, 35)  -- Increased size
checkbox.Position = UDim2.new(0, 0, 0, 0)
checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
checkbox.AutoButtonColor = false

local checkmark = Instance.new("TextLabel")
checkmark.Name = "Checkmark"
checkmark.Text = "✓"
checkmark.Font = Enum.Font.SourceSansBold
checkmark.TextSize = 30  -- Larger checkmark
checkmark.TextColor3 = Color3.fromRGB(0, 200, 0)
checkmark.BackgroundTransparency = 1
checkmark.Size = UDim2.new(1, 0, 1, 0)
checkmark.Visible = false

local checkText = Instance.new("TextLabel")
checkText.Name = "CheckText"
checkText.Text = "I understood completely, I wish to continue."
checkText.Font = Enum.Font.Gotham
checkText.TextSize = 16  -- Increased size
checkText.TextColor3 = Color3.fromRGB(200, 200, 200)
checkText.BackgroundTransparency = 1
checkText.Size = UDim2.new(1, -40, 1, 0)  -- Adjusted spacing
checkText.Position = UDim2.new(0, 40, 0, 0)
checkText.TextXAlignment = Enum.TextXAlignment.Left

-- Larger activate button
local activateButton = Instance.new("TextButton")
activateButton.Name = "ActivateButton"
activateButton.Text = "ACTIVATE"
activateButton.Font = Enum.Font.FredokaOne
activateButton.TextSize = 20  -- Larger text
activateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
activateButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
activateButton.Size = UDim2.new(1, -40, 0, 50)  -- Wider and taller
activateButton.AutoButtonColor = false
activateButton.LayoutOrder = 4
activateButton.Position = UDim2.new(0.5, 0, 0, 0)
activateButton.AnchorPoint = Vector2.new(0.5, 0)

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)  -- Slightly larger corner
buttonCorner.Parent = activateButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(100, 100, 100)
buttonStroke.Thickness = 2
buttonStroke.Parent = activateButton

-- Input handling
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

checkbox.MouseButton1Click:Connect(function()
    checkmark.Visible = not checkmark.Visible
end)

activateButton.MouseEnter:Connect(function()
    activateButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
end)

activateButton.MouseLeave:Connect(function()
    activateButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end)

-- Parenting
checkmark.Parent = checkbox
checkbox.Parent = checkFrame
checkText.Parent = checkFrame
checkFrame.Parent = contentFrame
activateButton.Parent = contentFrame
description.Parent = contentFrame
warningTitle.Parent = contentFrame
contentFrame.Parent = mainFrame
closeButton.Parent = titleBar
title.Parent = titleBar
titleBar.Parent = mainFrame
mainFrame.Parent = gui
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
