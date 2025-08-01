local gui = Instance.new("ScreenGui")
gui.Name = "PocariGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main GUI creation function
local function createWindow(title, hasMinimize)
    local window = Instance.new("Frame")
    window.Name = "MainFrame"
    window.Size = UDim2.new(0, 320, 0, 240)
    window.Position = UDim2.new(0.5, -160, 0.5, -120)
    window.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    window.ClipsDescendants = true

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = window

    local mainBorder = Instance.new("UIStroke")
    mainBorder.Name = "MainBorder"
    mainBorder.Color = Color3.fromRGB(100, 150, 255)
    mainBorder.Thickness = 2
    mainBorder.Parent = window

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    titleBar.ClipsDescendants = true

    local titleBarCorner = Instance.new("UICorner")
    titleBarCorner.CornerRadius = UDim.new(0, 8)
    titleBarCorner.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.FredokaOne
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 12, 0, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

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

    -- Only add minimize button if requested
    local minimizeButton
    if hasMinimize then
        minimizeButton = Instance.new("TextButton")
        minimizeButton.Name = "MinimizeButton"
        minimizeButton.Text = "-"
        minimizeButton.Font = Enum.Font.GothamSemibold
        minimizeButton.TextSize = 22
        minimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
        minimizeButton.Size = UDim2.new(0, 28, 0, 28)
        minimizeButton.Position = UDim2.new(1, -64, 0, 2)
        minimizeButton.BorderSizePixel = 0

        local minCorner = Instance.new("UICorner")
        minCorner.CornerRadius = UDim.new(0, 6)
        minCorner.Parent = minimizeButton
        minimizeButton.Parent = titleBar
    end

    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.BackgroundTransparency = 1
    contentFrame.Size = UDim2.new(1, -16, 1, -60)
    contentFrame.Position = UDim2.new(0, 8, 0, 40)

    local watermark = Instance.new("TextLabel")
    watermark.Name = "Watermark"
    watermark.Text = "created by pocari ;)"
    watermark.Font = Enum.Font.FredokaOne
    watermark.TextSize = 12
    watermark.TextColor3 = Color3.fromRGB(150, 150, 180)
    watermark.BackgroundTransparency = 1
    watermark.Size = UDim2.new(1, 0, 0, 16)
    watermark.Position = UDim2.new(0, 0, 1, -16)
    watermark.TextYAlignment = Enum.TextYAlignment.Top
    
    -- Add elements to hierarchy
    closeButton.Parent = titleBar
    titleLabel.Parent = titleBar
    titleBar.Parent = window
    watermark.Parent = window
    contentFrame.Parent = window
    
    return window, contentFrame, minimizeButton, closeButton, titleBar, mainBorder
end

-- Create main window
local mainWindow, mainContent, minimizeButton, closeButton, titleBar, mainBorder = createWindow("POCARI'S EXPLOITS", true)
mainWindow.Parent = gui

-- Create tab content container
local tabContainer = Instance.new("ScrollingFrame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, 0, 1, 0)
tabContainer.BackgroundTransparency = 1
tabContainer.ScrollBarThickness = 6
tabContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
tabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
tabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = tabContainer

-- Store tab functions
local tabFunctions = {}

-- Create feature tabs
for i = 1, 8 do
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "Feature_" .. i
    tabButton.Size = UDim2.new(1, 0, 0, 30)
    tabButton.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
    tabButton.Text = "Feature " .. i
    tabButton.Font = Enum.Font.GothamSemibold
    tabButton.TextSize = 14
    tabButton.TextColor3 = Color3.fromRGB(220, 220, 255)
    tabButton.BorderSizePixel = 0
    tabButton.AutoButtonColor = true
    tabButton.LayoutOrder = i
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = tabButton
    
    -- Store tab function
    tabFunctions[i] = function()
        -- Create new window for this tab
        local tabWindow, tabContentFrame = createWindow(tabButton.Text, false)
        tabWindow.Parent = gui
        
        -- Create back button
        local backButton = Instance.new("TextButton")
        backButton.Text = "← Back"
        backButton.Font = Enum.Font.GothamSemibold
        backButton.TextSize = 14
        backButton.TextColor3 = Color3.fromRGB(220, 220, 255)
        backButton.BackgroundColor3 = Color3.fromRGB(65, 70, 90)
        backButton.Size = UDim2.new(0, 80, 0, 28)
        backButton.Position = UDim2.new(0, 8, 0, 40)
        backButton.BorderSizePixel = 0
        
        local backCorner = Instance.new("UICorner")
        backCorner.CornerRadius = UDim.new(0, 4)
        backCorner.Parent = backButton
        
        -- Create content for tab
        local contentLabel = Instance.new("TextLabel")
        contentLabel.Text = "Content for Feature " .. i
        contentLabel.Size = UDim2.new(1, -16, 1, -100)
        contentLabel.Position = UDim2.new(0, 8, 0, 80)
        contentLabel.Font = Enum.Font.Gotham
        contentLabel.TextSize = 16
        contentLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
        contentLabel.BackgroundTransparency = 1
        contentLabel.TextWrapped = true
        
        -- Add elements to tab window
        backButton.Parent = tabWindow
        contentLabel.Parent = tabContentFrame
        
        -- Back button functionality
        backButton.MouseButton1Click:Connect(function()
            tabWindow:Destroy()
        end)
        
        -- Close button functionality for tab window
        local tabCloseButton = tabWindow.TitleBar.CloseButton
        tabCloseButton.MouseButton1Click:Connect(function()
            tabWindow:Destroy()
        end)
    end
    
    -- Connect tab button
    tabButton.MouseButton1Click:Connect(tabFunctions[i])
    tabButton.Parent = tabContainer
end

-- Add tab container to main content
tabContainer.Parent = mainContent

-- Services
local userInput = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

-- Dragging functionality
local dragStart
local startPos
local isDragging = false

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainWindow.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X,
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        startPos = mainWindow.Position
        
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
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDrag(input)
    end
end)

-- Minimize functionality
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
    
    if minimized then
        tweenService:Create(mainWindow, tweenInfo, {Size = UDim2.new(mainWindow.Size.X.Scale, mainWindow.Size.X.Offset, 0, 32)}):Play()
        tweenService:Create(mainContent, tweenInfo, {BackgroundTransparency = 1, Size = UDim2.new(1, -16, 0, 0)}):Play()
        minimizeButton.Text = "+"
    else
        tweenService:Create(mainWindow, tweenInfo, {Size = UDim2.new(0, 320, 0, 240)}):Play()
        tweenService:Create(mainContent, tweenInfo, {BackgroundTransparency = 1, Size = UDim2.new(1, -16, 1, -60)}):Play()
        minimizeButton.Text = "-"
    end
end)

-- Close functionality
closeButton.MouseButton1Click:Connect(function()
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
    tweenService:Create(mainWindow, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    tweenService:Create(titleBar, tweenInfo, {BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    gui:Destroy()
end)

-- Button hover effects
minimizeButton.MouseEnter:Connect(function()
    minimizeButton.BackgroundColor3 = Color3.fromRGB(120, 200, 255)
end)

minimizeButton.MouseLeave:Connect(function()
    minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
end)

closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 80, 100)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
end)

-- Border pulse effect
local pulseTween = tweenService:Create(
    mainBorder,
    TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Color = Color3.fromRGB(140, 180, 255)}
)
pulseTween:Play()

-- Parent to PlayerGui
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
