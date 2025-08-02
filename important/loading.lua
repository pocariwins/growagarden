local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

for _, guiName in ipairs({"CustomPanelGui", "IntroLoadingGui"}) do
    if playerGui:FindFirstChild(guiName) then
        playerGui[guiName]:Destroy()
    end
end

local LoadingGui = Instance.new("ScreenGui", playerGui)
LoadingGui.Name = "IntroLoadingGui"
LoadingGui.DisplayOrder = 999
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local LoadingFrame = Instance.new("Frame", LoadingGui)
LoadingFrame.Size = UDim2.new(0, 500, 0, 220)
LoadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
LoadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 28)
LoadingFrame.BorderSizePixel = 0

local UICorner1 = Instance.new("UICorner", LoadingFrame)
UICorner1.CornerRadius = UDim.new(0, 16)

local LoadingTitle = Instance.new("TextLabel", LoadingFrame)
LoadingTitle.Size = UDim2.new(1, -40, 0.3, 0)
LoadingTitle.Position = UDim2.new(0, 20, 0.1, 0)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Text = "INITIALIZING GROW A GARDEN..."
LoadingTitle.Font = Enum.Font.FredokaOne
LoadingTitle.TextColor3 = Color3.fromRGB(102, 204, 153)
LoadingTitle.TextScaled = true
LoadingTitle.TextSize = 32

local TimeLabel = Instance.new("TextLabel", LoadingFrame)
TimeLabel.Size = UDim2.new(1, -40, 0.2, 0)
TimeLabel.Position = UDim2.new(0, 20, 0.4, 0)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "ESTIMATED TIME: 7:30"
TimeLabel.Font = Enum.Font.GothamSemiBold
TimeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
TimeLabel.TextSize = 20

local LoadingBarBackground = Instance.new("Frame", LoadingFrame)
LoadingBarBackground.Size = UDim2.new(0.85, 0, 0.12, 0)
LoadingBarBackground.Position = UDim2.new(0.075, 0, 0.7, 0)
LoadingBarBackground.BackgroundColor3 = Color3.fromRGB(35, 42, 50)
LoadingBarBackground.BorderSizePixel = 0

local UICorner2 = Instance.new("UICorner", LoadingBarBackground)
UICorner2.CornerRadius = UDim.new(1, 0)

local LoadingBar = Instance.new("Frame", LoadingBarBackground)
LoadingBar.Size = UDim2.new(0, 0, 1, 0)
LoadingBar.BackgroundColor3 = Color3.fromRGB(102, 204, 153)
LoadingBar.BorderSizePixel = 0

local UICorner3 = Instance.new("UICorner", LoadingBar)
UICorner3.CornerRadius = UDim.new(1, 0)

local startTime = os.time()
local totalSeconds = 450  -- 7 minutes * 60 + 30 seconds = 450 seconds

coroutine.wrap(function()
    while true do
        local elapsed = os.time() - startTime
        if elapsed >= totalSeconds then break end
        
        -- Update progress bar
        local progress = elapsed / totalSeconds
        LoadingBar.Size = UDim2.new(progress, 0, 1, 0)
        
        -- Update time remaining
        local remaining = totalSeconds - elapsed
        local minutes = math.floor(remaining / 60)
        local seconds = math.floor(remaining % 60)
        TimeLabel.Text = string.format("TIME REMAINING: %d:%02d", minutes, seconds)
        
        task.wait(0.1)
    end
    
    LoadingBar.Size = UDim2.new(1, 0, 1, 0)
    TimeLabel.Text = "COMPLETE! LAUNCHING..."
    
    for i = 1, 10 do
        LoadingFrame.BackgroundTransparency = i / 10
        LoadingTitle.TextTransparency = i / 10
        TimeLabel.TextTransparency = i / 10
        LoadingBar.BackgroundTransparency = i / 10
        task.wait(0.05)
    end
    
    LoadingGui:Destroy()
    createMainGui()
end)()

function createMainGui()
    local ScreenGui = Instance.new("ScreenGui", playerGui)
    ScreenGui.Name = "CustomPanelGui"
    ScreenGui.DisplayOrder = 999
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local PanelFrame = Instance.new("Frame", ScreenGui)
    PanelFrame.Size = UDim2.new(0, 400, 0, 320)
    PanelFrame.Position = UDim2.new(0.5, -200, 0.5, -160)
    PanelFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    PanelFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 28)
    PanelFrame.Active = true
    PanelFrame.Draggable = true
    PanelFrame.BorderSizePixel = 0

    local PanelCorner = Instance.new("UICorner", PanelFrame)
    PanelCorner.CornerRadius = UDim.new(0, 14)

    local Title = Instance.new("TextLabel", PanelFrame)
    Title.Size = UDim2.new(1, -40, 0, 50)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "GROW A GARDEN FREEZE TRADE"
    Title.Font = Enum.Font.FredokaOne
    Title.TextColor3 = Color3.fromRGB(102, 204, 153)
    Title.TextScaled = true
    Title.TextSize = 24

    local TextBox = Instance.new("TextBox", PanelFrame)
    TextBox.Size = UDim2.new(0.9, 0, 0, 50)
    TextBox.Position = UDim2.new(0.05, 0, 0.2, 0)
    TextBox.BackgroundColor3 = Color3.fromRGB(35, 42, 50)
    TextBox.PlaceholderText = "Enter username..."
    TextBox.Text = ""
    TextBox.Font = Enum.Font.GothamSemiBold
    TextBox.TextSize = 24
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.ClearTextOnFocus = false
    TextBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
    TextBox.TextWrapped = false

    local TextBoxCorner = Instance.new("UICorner", TextBox)
    TextBoxCorner.CornerRadius = UDim.new(0, 10)

    local FreezeTrade = Instance.new("TextButton", PanelFrame)
    FreezeTrade.Size = UDim2.new(0.9, 0, 0, 50)
    FreezeTrade.Position = UDim2.new(0.05, 0, 0.4, 0)
    FreezeTrade.BackgroundColor3 = Color3.fromRGB(102, 204, 153)
    FreezeTrade.Text = "FREEZE TRADE"
    FreezeTrade.Font = Enum.Font.FredokaOne
    FreezeTrade.TextColor3 = Color3.fromRGB(18, 22, 28)
    FreezeTrade.TextSize = 22

    local FreezeCorner = Instance.new("UICorner", FreezeTrade)
    FreezeCorner.CornerRadius = UDim.new(0, 10)

    local AutoAccept = Instance.new("TextButton", PanelFrame)
    AutoAccept.Size = UDim2.new(0.9, 0, 0, 50)
    AutoAccept.Position = UDim2.new(0.05, 0, 0.6, 0)
    AutoAccept.BackgroundColor3 = Color3.fromRGB(70, 140, 220)
    AutoAccept.Text = "AUTO ACCEPT"
    AutoAccept.Font = Enum.Font.FredokaOne
    AutoAccept.TextColor3 = Color3.fromRGB(255, 255, 255)
    AutoAccept.TextSize = 22

    local AutoCorner = Instance.new("UICorner", AutoAccept)
    AutoCorner.CornerRadius = UDim.new(0, 10)

    local CreditsLabel = Instance.new("TextLabel", PanelFrame)
    CreditsLabel.Size = UDim2.new(1, 0, 0, 24)
    CreditsLabel.Position = UDim2.new(0, 0, 0.92, 0)
    CreditsLabel.BackgroundTransparency = 1
    CreditsLabel.Text = "By Zyrooo Scripts"
    CreditsLabel.Font = Enum.Font.GothamSemiBold
    CreditsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    CreditsLabel.TextSize = 14
end
