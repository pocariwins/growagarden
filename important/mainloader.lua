local gui = Instance.new("ScreenGui")
gui.Name = "PocariGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 10  -- Ensure it appears on top

-- Egg Randomizer variables and functions
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local petTable = {
    ["Common Egg"] = { "Dog", "Bunny", "Golden Lab" },
    ["Uncommon Egg"] = { "Chicken", "Black Bunny", "Cat", "Deer" },
    ["Rare Egg"] = { "Pig", "Monkey", "Rooster", "Orange Tabby", "Spotted Deer" },
    ["Legendary Egg"] = { "Cow", "Polar Bear", "Sea Otter", "Turtle", "Silver Monkey" },
    ["Mythical Egg"] = { "Grey Mouse", "Brown Mouse", "Squirrel", "Red Giant Ant" },
    ["Bug Egg"] = { "Snail", "Caterpillar", "Giant Ant", "Praying Mantis" },
    ["Night Egg"] = { "Frog", "Hedgehog", "Mole", "Echo Frog", "Night Owl" },
    ["Bee Egg"] = { "Bee", "Honey Bee", "Bear Bee", "Petal Bee" },
    ["Anti Bee Egg"] = { "Wasp", "Moth", "Tarantula Hawk" },
    ["Oasis Egg"] = { "Meerkat", "Sand Snake", "Axolotl" },
    ["Paradise Egg"] = { "Ostrich", "Peacock", "Capybara" },
    ["Dinosaur Egg"] = { "Raptor", "Triceratops", "Stegosaurus" },
    ["Primal Egg"] = { "Parasaurolophus", "Iguanodon", "Pachycephalosaurus" },
}

-- ESP OFF BY DEFAULT
local espEnabled = false
local truePetMap = {}
local rarePets = {
    "Kitsune", "T-Rex", "Spinosaurus", "Dragonfly", 
    "Butterfly", "Disco Bee", "Queen Bee", "Red Fox", 
    "Raccoon", "Fennec Fox", "Mimic Octopus", "Polar Bear"
}

-- ADDED: Function for rainbow effect
local function rainbowEffect(label)
    if not label or not label:IsDescendantOf(game) then return end
    
    coroutine.wrap(function()
        local hue = 0
        while task.wait(0.03) and label and label:IsDescendantOf(game) do
            hue = (hue + 0.01) % 1
            label.TextColor3 = Color3.fromHSV(hue, 1, 1)
        end
    end)()
end

local function glitchLabelEffect(label)
    coroutine.wrap(function()
        local original = label.TextColor3
        for i = 1, 2 do
            label.TextColor3 = Color3.new(1, 0, 0)
            task.wait(0.07)
            label.TextColor3 = original
            task.wait(0.07)
        end
    end)()
end

local function applyEggESP(eggModel, petName)
    local existingLabel = eggModel:FindFirstChild("PetBillboard", true)
    if existingLabel then existingLabel:Destroy() end
    local existingHighlight = eggModel:FindFirstChild("ESPHighlight")
    if existingHighlight then existingHighlight:Destroy() end
    if not espEnabled then return end

    local basePart = eggModel:FindFirstChildWhichIsA("BasePart")
    if not basePart then return end

    local hatchReady = true
    local hatchTime = eggModel:FindFirstChild("HatchTime")
    local readyFlag = eggModel:FindFirstChild("ReadyToHatch")

    if hatchTime and hatchTime:IsA("NumberValue") and hatchTime.Value > 0 then
        hatchReady = false
    elseif readyFlag and readyFlag:IsA("BoolValue") and not readyFlag.Value then
        hatchReady = false
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PetBillboard"
    billboard.Size = UDim2.new(0, 270, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 4.5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 500
    billboard.Parent = basePart

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    -- CHANGED: Format to [Egg Name] Pet Name
    label.Text = "[" .. eggModel.Name .. "] " .. petName
    if not hatchReady then
        label.Text = "[" .. eggModel.Name .. "] " .. petName .. " (Not Ready)"
        label.TextColor3 = Color3.fromRGB(160, 160, 160)
        label.TextStrokeTransparency = 0.5
    else
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0
    end
    label.TextScaled = true
    label.Font = Enum.Font.FredokaOne
    label.Parent = billboard

    -- Apply rainbow effect for rare pets
    for _, rarePet in ipairs(rarePets) do
        if petName == rarePet then
            rainbowEffect(label)
            break
        end
    end
    
    -- Apply glitch effect for non-rare pets
    if hatchReady then
        local isRare = false
        for _, rarePet in ipairs(rarePets) do
            if petName == rarePet then
                isRare = true
                break
            end
        end
        if not isRare then
            glitchLabelEffect(label)
        end
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.FillColor = Color3.fromRGB(255, 200, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.7
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = eggModel
    highlight.Parent = eggModel
end

local function removeEggESP(eggModel)
    local label = eggModel:FindFirstChild("PetBillboard", true)
    if label then label:Destroy() end
    local highlight = eggModel:FindFirstChild("ESPHighlight")
    if highlight then highlight:Destroy() end
end

-- Function to select pets with rare chance
local function selectPetForEgg(eggName)
    local pets = petTable[eggName]
    if not pets then return "Unknown" end
    
    -- CHANGED: 50% chance for rare pet (for testing)
    if math.random(1, 2) == 1 then
        return rarePets[math.random(1, #rarePets)]
    end
    
    -- Normal selection
    return pets[math.random(1, #pets)]
end

local function getPlayerGardenEggs(radius)
    local eggs = {}
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return eggs end

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and petTable[obj.Name] then
            local dist = (obj:GetModelCFrame().Position - root.Position).Magnitude
            if dist <= (radius or 60) then
                if not truePetMap[obj] then
                    truePetMap[obj] = selectPetForEgg(obj.Name)
                end
                table.insert(eggs, obj)
            end
        end
    end
    return eggs
end

local function randomizeNearbyEggs()
    local eggs = getPlayerGardenEggs(60)
    for _, egg in ipairs(eggs) do
        truePetMap[egg] = selectPetForEgg(egg.Name)
        applyEggESP(egg, truePetMap[egg])
    end
    return #eggs
end

local function flashEffect(button)
    local originalColor = button.BackgroundColor3
    for i = 1, 3 do
        button.BackgroundColor3 = Color3.new(1, 1, 1)
        task.wait(0.05)
        button.BackgroundColor3 = originalColor
        task.wait(0.05)
    end
end

local function countdownAndRandomize(button, statusLabel)
    for i = 10, 1, -1 do
        button.Text = "Randomize in: " .. i
        if statusLabel then
            statusLabel.Text = "Randomizing in " .. i .. " seconds"
        end
        task.wait(1)
    end
    flashEffect(button)
    local count = randomizeNearbyEggs()
    button.Text = "Randomized "..count.." Pets!"
    if statusLabel then
        statusLabel.Text = "Randomized "..count.." pets!"
    end
    task.wait(1.5)
    button.Text = "Randomize Pets"
    if statusLabel then
        statusLabel.Text = "Ready to randomize!"
    end
end

-- Create main window
local mainWindow = Instance.new("Frame")
mainWindow.Name = "MainFrame"
mainWindow.Size = UDim2.new(0, 320, 0, 240)
mainWindow.Position = UDim2.new(0.5, -160, 0.5, -120)
mainWindow.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainWindow.ClipsDescendants = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainWindow

local mainBorder = Instance.new("UIStroke")
mainBorder.Name = "MainBorder"
mainBorder.Color = Color3.fromRGB(100, 150, 255)
mainBorder.Thickness = 2
mainBorder.Parent = mainWindow

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
titleLabel.Text = "POCARI'S EXPLOITS"
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
minimizeButton.Parent = titleBar

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.BackgroundTransparency = 1
contentFrame.Size = UDim2.new(1, -16, 1, -60)
contentFrame.Position = UDim2.new(0, 8, 0, 40)
contentFrame.ClipsDescendants = true

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
titleBar.Parent = mainWindow
watermark.Parent = mainWindow
contentFrame.Parent = mainWindow
mainWindow.Parent = gui

-- Create tab container
local tabContainer = Instance.new("ScrollingFrame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, 0, 1, 0)
tabContainer.BackgroundTransparency = 1
tabContainer.ScrollBarThickness = 6
tabContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
tabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
tabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabContainer.ScrollBarImageTransparency = 0.5

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = tabContainer

-- Create feature tabs
local tabContents = {}
local firstTabStatusLabel = nil

for i = 1, 8 do
    -- Create tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "Feature_" .. i
    tabButton.Size = UDim2.new(1, 0, 0, 30)
    tabButton.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
    tabButton.Font = Enum.Font.GothamSemibold
    tabButton.TextSize = 14
    tabButton.TextColor3 = Color3.fromRGB(220, 220, 255)
    tabButton.BorderSizePixel = 0
    tabButton.AutoButtonColor = true
    tabButton.LayoutOrder = i
    
    -- Set first tab to Egg Randomizer
    if i == 1 then
        tabButton.Text = "Egg Randomizer"
    else
        tabButton.Text = "Feature " .. i
    end
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = tabButton
    
    -- Create content frame for this tab
    local tabContentFrame = Instance.new("Frame")
    tabContentFrame.Name = "TabContent_" .. i
    tabContentFrame.BackgroundTransparency = 1
    tabContentFrame.Size = UDim2.new(1, 0, 1, 0)
    tabContentFrame.Visible = false
    
    -- Create back button for tab content
    local backButton = Instance.new("TextButton")
    backButton.Text = "← Back"
    backButton.Font = Enum.Font.GothamSemibold
    backButton.TextSize = 14
    backButton.TextColor3 = Color3.fromRGB(220, 220, 255)
    backButton.BackgroundColor3 = Color3.fromRGB(65, 70, 90)
    backButton.Size = UDim2.new(0, 80, 0, 28)
    backButton.Position = UDim2.new(0, 8, 0, 8)
    backButton.BorderSizePixel = 0
    
    local backCorner = Instance.new("UICorner")
    backCorner.CornerRadius = UDim.new(0, 4)
    backCorner.Parent = backButton
    
    -- Create scrollable content container
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, 0, 1, -40)
    scrollFrame.Position = UDim2.new(0, 0, 0, 40)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    
    local scrollLayout = Instance.new("UIListLayout")
    scrollLayout.Padding = UDim.new(0, 8)
    scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    scrollLayout.Parent = scrollFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.Parent = scrollFrame
    
    -- Create content for tab
    if i == 1 then -- Egg Randomizer content
        -- Title
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Text = "Pet Randomizer"
        titleLabel.Size = UDim2.new(1, 0, 0, 30)
        titleLabel.Font = Enum.Font.FredokaOne
        titleLabel.TextSize = 22
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.BackgroundTransparency = 1
        titleLabel.LayoutOrder = 1
        titleLabel.Parent = scrollFrame
        
        -- Randomize Button
        local randomizeBtn = Instance.new("TextButton")
        randomizeBtn.Name = "RandomizeButton"
        randomizeBtn.Text = "Randomize Pets"
        randomizeBtn.Size = UDim2.new(1, 0, 0, 50)
        randomizeBtn.Font = Enum.Font.FredokaOne
        randomizeBtn.TextSize = 20
        randomizeBtn.TextColor3 = Color3.new(1, 1, 1)
        randomizeBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255) -- Blue like minimize button
        randomizeBtn.LayoutOrder = 2
        
        local randomizeCorner = Instance.new("UICorner")
        randomizeCorner.CornerRadius = UDim.new(0, 6)
        randomizeCorner.Parent = randomizeBtn
        
        randomizeBtn.Parent = scrollFrame
        
        -- ESP Toggle Button (OFF BY DEFAULT)
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Name = "ESPToggle"
        toggleBtn.Text = "ESP: OFF"
        toggleBtn.Size = UDim2.new(1, 0, 0, 40)
        toggleBtn.Font = Enum.Font.FredokaOne
        toggleBtn.TextSize = 18
        toggleBtn.TextColor3 = Color3.new(1, 1, 1)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 65) -- Tab button color
        toggleBtn.LayoutOrder = 3
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 6)
        toggleCorner.Parent = toggleBtn
        
        toggleBtn.Parent = scrollFrame
        
        -- Auto Randomize Button
        local autoBtn = Instance.new("TextButton")
        autoBtn.Name = "AutoRandomize"
        autoBtn.Text = "Auto Randomize: OFF"
        autoBtn.Size = UDim2.new(1, 0, 0, 30)
        autoBtn.Font = Enum.Font.FredokaOne
        autoBtn.TextSize = 16
        autoBtn.TextColor3 = Color3.new(1, 1, 1)
        autoBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 60) -- Green
        autoBtn.LayoutOrder = 4
        
        local autoCorner = Instance.new("UICorner")
        autoCorner.CornerRadius = UDim.new(0, 6)
        autoCorner.Parent = autoBtn
        
        autoBtn.Parent = scrollFrame
        
        -- Status label
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Name = "StatusLabel"
        statusLabel.Text = "Ready to randomize!"
        statusLabel.Size = UDim2.new(1, 0, 0, 20)
        statusLabel.Font = Enum.Font.FredokaOne
        statusLabel.TextSize = 14
        statusLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
        statusLabel.BackgroundTransparency = 1
        statusLabel.LayoutOrder = 5
        statusLabel.Parent = scrollFrame
        
        firstTabStatusLabel = statusLabel  -- Store for later access
        
        -- Button functionality
        randomizeBtn.MouseButton1Click:Connect(function()
            statusLabel.Text = "Starting randomization..."
            coroutine.wrap(function()
                countdownAndRandomize(randomizeBtn, statusLabel)
            end)()
        end)
        
        toggleBtn.MouseButton1Click:Connect(function()
            espEnabled = not espEnabled
            toggleBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
            for _, egg in pairs(getPlayerGardenEggs(60)) do
                if espEnabled then
                    applyEggESP(egg, truePetMap[egg])
                else
                    removeEggESP(egg)
                end
            end
            statusLabel.Text = "ESP " .. (espEnabled and "enabled" or "disabled")
        end)
        
        local autoRunning = false
        autoBtn.MouseButton1Click:Connect(function()
            autoRunning = not autoRunning
            autoBtn.Text = autoRunning and "Auto Randomize: ON" or "Auto Randomize: OFF"
            statusLabel.Text = autoRunning and "Auto-randomize started!" or "Auto-randomize stopped"
            
            coroutine.wrap(function()
                while autoRunning do
                    statusLabel.Text = "Auto-randomizing..."
                    countdownAndRandomize(randomizeBtn, statusLabel)
                    
                    -- Check for rare pets
                    local foundRare = false
                    for _, petName in pairs(truePetMap) do
                        for _, rarePet in ipairs(rarePets) do
                            if petName == rarePet then
                                statusLabel.Text = "Found rare pet: " .. rarePet
                                autoRunning = false
                                autoBtn.Text = "Auto Randomize: OFF"
                                return
                            end
                        end
                    end
                    
                    task.wait(1)
                end
            end)()
        end)
    else
        -- Default content for other tabs
        local contentLabel = Instance.new("TextLabel")
        contentLabel.Text = "Content for Feature " .. i
        contentLabel.Size = UDim2.new(1, 0, 0, 300)  -- Make it tall to show scrolling
        contentLabel.Font = Enum.Font.Gotham
        contentLabel.TextSize = 16
        contentLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
        contentLabel.BackgroundTransparency = 1
        contentLabel.TextWrapped = true
        contentLabel.LayoutOrder = 1
        contentLabel.Parent = scrollFrame
    end
    
    -- Add scroll frame to content
    scrollFrame.Parent = tabContentFrame
    backButton.Parent = tabContentFrame
    
    -- Store tab content
    tabContents[i] = tabContentFrame
    
    -- Tab button functionality
    tabButton.MouseButton1Click:Connect(function()
        -- Hide all tab contents
        for _, content in ipairs(tabContents) do
            content.Visible = false
        end
        
        -- Show this tab's content
        tabContentFrame.Visible = true
        tabContentFrame.Parent = contentFrame
        
        -- Hide tab container
        tabContainer.Visible = false
        tabContainer.Parent = nil
        
        -- Update title
        if i == 1 then
            titleLabel.Text = "EGG RANDOMIZER"
        else
            titleLabel.Text = "FEATURE " .. i
        end
    end)
    
    -- Back button functionality
    backButton.MouseButton1Click:Connect(function()
        -- Hide all tab contents
        for _, content in ipairs(tabContents) do
            content.Visible = false
            content.Parent = nil
        end
        
        -- Show tab container
        tabContainer.Visible = true
        tabContainer.Parent = contentFrame
        
        -- Reset title
        titleLabel.Text = "POCARI'S EXPLOITS"
    end)
    
    tabButton.Parent = tabContainer
end

-- Add tab container to content frame
tabContainer.Parent = contentFrame

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

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if isDragging then
            updateDrag(input)
        end
    end
end)

-- Minimize functionality
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
    
    if minimized then
        tweenService:Create(mainWindow, tweenInfo, {Size = UDim2.new(0, 320, 0, 32)}):Play()
        tweenService:Create(contentFrame, tweenInfo, {Size = UDim2.new(1, -16, 0, 0)}):Play()
        tweenService:Create(watermark, tweenInfo, {TextTransparency = 1}):Play()
        minimizeButton.Text = "+"
    else
        tweenService:Create(mainWindow, tweenInfo, {Size = UDim2.new(0, 320, 0, 240)}):Play()
        tweenService:Create(contentFrame, tweenInfo, {Size = UDim2.new(1, -16, 1, -60)}):Play()
        tweenService:Create(watermark, tweenInfo, {TextTransparency = 0}):Play()
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

-- Initialize ESP (but espEnabled is false by default)
coroutine.wrap(function()
    task.wait(2) -- Wait for game to load
    local eggs = getPlayerGardenEggs(60)
    for _, egg in pairs(eggs) do
        if not truePetMap[egg] then
            truePetMap[egg] = selectPetForEgg(egg.Name)
        end
        -- Only apply ESP if enabled (which it isn't by default)
        if espEnabled then
            applyEggESP(egg, truePetMap[egg])
        end
    end
    
    -- Update status label
    if firstTabStatusLabel then
        if #eggs == 0 then
            firstTabStatusLabel.Text = "No eggs found nearby"
        else
            firstTabStatusLabel.Text = "Found "..#eggs.." eggs nearby"
        end
    end
end)()

-- Parent to PlayerGui
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
