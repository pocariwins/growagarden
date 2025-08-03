local gui = Instance.new("ScreenGui")
gui.Name = "PocariGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 10
gui.Enabled = true

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Create tweenService variable at the top level
local tweenService = TweenService

local petTable = {
    ["Common Egg"] = { "Dog", "Bunny", "Golden Lab" },
    ["Uncommon Egg"] = { "Chicken", "Black Bunny", "Cat", "Deer" },
    ["Rare Egg"] = { "Pig", "Monkey", "Rooster", "Orange Tabby", "Spotted Deer" },
    ["Legendary Egg"] = { "Cow", "Sea Otter", "Turtle", "Silver Monkey", "Polar Bear" },
    ["Mythical Egg"] = { "Grey Mouse", "Brown Mouse", "Squirrel", "Red Giant Ant", "Red Fox" },
    ["Bug Egg"] = { "Snail", "Caterpillar", "Giant Ant", "Praying Mantis", "Dragonfly" },
    ["Night Egg"] = { "Frog", "Hedgehog", "Mole", "Echo Frog", "Night Owl", "Raccoon" },
    ["Bee Egg"] = { "Bee", "Honey Bee", "Bear Bee", "Petal Bee", "Queen Bee" },
    ["Anti Bee Egg"] = { "Wasp", "Moth", "Tarantula Hawk", "Butterfly", "Disco Bee" },
    ["Oasis Egg"] = { "Meerkat", "Sand Snake", "Axolotl", "Hyacinth Macaw", "Fennec Fox" },
    ["Paradise Egg"] = { "Ostrich", "Peacock", "Capybara", "Scarlet Macaw", "Mimic Octopus" },
    ["Dinosaur Egg"] = { "Raptor", "Triceratops", "Stegosaurus", "Pterodactyl", "Brontosaurus", "T-Rex" },
    ["Primal Egg"] = { "Parasaurolophus", "Iguanodon", "Pachycephalosaurus", "Dilophosaurus", "Ankylosaurus", "Spinosaurus" },
    ["Zen Egg"] = { "Shiba Inu", "Nihonzaru", "Tanuki", "Tanchozuru", "Kappa", "Kitsune" }
}

local espEnabled = false
local truePetMap = {}
local trackedEggs = {} -- Track eggs with ESP applied

local rarePets = {
    ["Kitsune"] = "Zen Egg",
    ["T-Rex"] = "Dinosaur Egg",
    ["Spinosaurus"] = "Primal Egg",
    ["Dragonfly"] = "Bug Egg",
    ["Butterfly"] = "Anti Bee Egg",
    ["Disco Bee"] = "Anti Bee Egg",
    ["Queen Bee"] = "Bee Egg",
    ["Red Fox"] = "Mythical Egg",
    ["Raccoon"] = "Night Egg",
    ["Fennec Fox"] = "Oasis Egg",
    ["Mimic Octopus"] = "Paradise Egg",
    ["Polar Bear"] = "Legendary Egg"
}

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
    if trackedEggs[eggModel] then return end -- Skip if already tracked
    
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

    if rarePets[petName] then
        rainbowEffect(label)
    end
    
    if hatchReady and not rarePets[petName] then
        glitchLabelEffect(label)
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.FillColor = Color3.fromRGB(255, 200, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.7
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = eggModel
    highlight.Parent = eggModel
    
    trackedEggs[eggModel] = {billboard, highlight}
end

local function removeEggESP(eggModel)
    if trackedEggs[eggModel] then
        for _, obj in ipairs(trackedEggs[eggModel]) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        trackedEggs[eggModel] = nil
    end
end

local function removeAllESP()
    for eggModel, espObjects in pairs(trackedEggs) do
        for _, obj in ipairs(espObjects) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
    end
    trackedEggs = {}
end

local function selectPetForEgg(eggName)
    local pets = petTable[eggName]
    if not pets then return "Unknown" end
    
    if math.random(1, 1000) == 1 then
        for petName, requiredEgg in pairs(rarePets) do
            if requiredEgg == eggName then
                return petName
            end
        end
    end
    
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

-- Create main GUI container
local mainWindow = Instance.new("Frame")
mainWindow.Name = "MainFrame"
mainWindow.Size = UDim2.new(0, 320, 0, 240)
mainWindow.Position = UDim2.new(0.5, -160, 0.5, -120)
mainWindow.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainWindow.ClipsDescendants = true
mainWindow.Visible = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainWindow

local mainBorder = Instance.new("UIStroke")
mainBorder.Name = "MainBorder"
mainBorder.Color = Color3.fromRGB(100, 150, 255)
mainBorder.Thickness = 2
mainBorder.Parent = mainWindow

-- Title bar
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

-- Close button
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

-- Minimize button
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

-- Content frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.BackgroundTransparency = 1
contentFrame.Size = UDim2.new(1, -16, 1, -60)
contentFrame.Position = UDim2.new(0, 8, 0, 40)
contentFrame.ClipsDescendants = true

-- Watermark
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

-- Assemble title bar
closeButton.Parent = titleBar
titleLabel.Parent = titleBar
titleBar.Parent = mainWindow
watermark.Parent = mainWindow
contentFrame.Parent = mainWindow
mainWindow.Parent = gui

-- Tab container
local tabContainer = Instance.new("ScrollingFrame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, 0, 1, 0)
tabContainer.BackgroundTransparency = 1
tabContainer.ScrollBarThickness = 6
tabContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
tabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
tabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabContainer.ScrollBarImageTransparency = 0.5
tabContainer.Visible = true

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = tabContainer

local tabContents = {}
local firstTabStatusLabel = nil

local mutations = {
    "Shiny", "Inverted", "Frozen", "Windy", "Golden", "Mega", "Tiny",
    "Tranquil", "IronSkin", "Radiant", "Rainbow", "Shocked", "Ascended"
}
local currentMutation = mutations[math.random(#mutations)]
local mutationEspEnabled = false
local mutationEspGui, mutationEspLabel
local mutationHue = 0

local function findMutationMachine()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find("mutation") then
            return obj
        end
    end
    return nil
end

local function setupMutationESP()
    local machine = findMutationMachine()
    if not machine then return end
    
    local basePart = machine:FindFirstChildWhichIsA("BasePart")
    if not basePart then return end
    
    if mutationEspGui then mutationEspGui:Destroy() end
    
    mutationEspGui = Instance.new("BillboardGui")
    mutationEspGui.Name = "MutationESP"
    mutationEspGui.Adornee = basePart
    mutationEspGui.Size = UDim2.new(0, 200, 0, 40)
    mutationEspGui.StudsOffset = Vector3.new(0, 3, 0)
    mutationEspGui.AlwaysOnTop = true
    mutationEspGui.Enabled = mutationEspEnabled
    mutationEspGui.Parent = basePart
    
    mutationEspLabel = Instance.new("TextLabel")
    mutationEspLabel.Size = UDim2.new(1, 0, 1, 0)
    mutationEspLabel.BackgroundTransparency = 1
    mutationEspLabel.Font = Enum.Font.FredokaOne
    mutationEspLabel.TextSize = 24
    mutationEspLabel.TextStrokeTransparency = 0.3
    mutationEspLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    mutationEspLabel.Text = currentMutation
    mutationEspLabel.Parent = mutationEspGui
    
    RunService.RenderStepped:Connect(function()
        if mutationEspEnabled then
            mutationHue = (mutationHue + 0.01) % 1
            mutationEspLabel.TextColor3 = Color3.fromHSV(mutationHue, 1, 1)
        end
    end)
end

local tabNames = {
    "Egg Randomizer",
    "Pet Mutation Finder",
    "Pet Age Loader",
    "Infinite Kitsune" -- Replaced Early Access with Kitsune Chest
}

for i, tabName in ipairs(tabNames) do
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
    tabButton.Text = tabName
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = tabButton
    
    local tabContentFrame = Instance.new("Frame")
    tabContentFrame.Name = "TabContent_" .. i
    tabContentFrame.BackgroundTransparency = 1
    tabContentFrame.Size = UDim2.new(1, 0, 1, 0)
    tabContentFrame.Visible = false
    
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
    
    if tabName == "Egg Randomizer" then
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Text = "Pet Randomizer"
        titleLabel.Size = UDim2.new(1, 0, 0, 30)
        titleLabel.Font = Enum.Font.FredokaOne
        titleLabel.TextSize = 22
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.BackgroundTransparency = 1
        titleLabel.LayoutOrder = 1
        titleLabel.Parent = scrollFrame
        
        local randomizeBtn = Instance.new("TextButton")
        randomizeBtn.Name = "RandomizeButton"
        randomizeBtn.Text = "Randomize Pets"
        randomizeBtn.Size = UDim2.new(1, 0, 0, 50)
        randomizeBtn.Font = Enum.Font.FredokaOne
        randomizeBtn.TextSize = 20
        randomizeBtn.TextColor3 = Color3.new(1, 1, 1)
        randomizeBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
        randomizeBtn.LayoutOrder = 2
        
        local randomizeCorner = Instance.new("UICorner")
        randomizeCorner.CornerRadius = UDim.new(0, 6)
        randomizeCorner.Parent = randomizeBtn
        
        randomizeBtn.Parent = scrollFrame
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Name = "ESPToggle"
        toggleBtn.Text = "ESP: OFF"
        toggleBtn.Size = UDim2.new(1, 0, 0, 40)
        toggleBtn.Font = Enum.Font.FredokaOne
        toggleBtn.TextSize = 18
        toggleBtn.TextColor3 = Color3.new(1, 1, 1)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
        toggleBtn.LayoutOrder = 3
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 6)
        toggleCorner.Parent = toggleBtn
        
        toggleBtn.Parent = scrollFrame
        
        local autoBtn = Instance.new("TextButton")
        autoBtn.Name = "AutoRandomize"
        autoBtn.Text = "Auto Randomize: OFF"
        autoBtn.Size = UDim2.new(1, 0, 0, 30)
        autoBtn.Font = Enum.Font.FredokaOne
        autoBtn.TextSize = 16
        autoBtn.TextColor3 = Color3.new(1, 1, 1)
        autoBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 60)
        autoBtn.LayoutOrder = 4
        
        local autoCorner = Instance.new("UICorner")
        autoCorner.CornerRadius = UDim.new(0, 6)
        autoCorner.Parent = autoBtn
        
        autoBtn.Parent = scrollFrame
        
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
        
        firstTabStatusLabel = statusLabel
        
        randomizeBtn.MouseButton1Click:Connect(function()
            statusLabel.Text = "Starting randomization..."
            coroutine.wrap(function()
                countdownAndRandomize(randomizeBtn, statusLabel)
            end)()
        end)
        
        toggleBtn.MouseButton1Click:Connect(function()
            espEnabled = not espEnabled
            toggleBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
            if espEnabled then
                local eggs = getPlayerGardenEggs(60)
                for _, egg in pairs(eggs) do
                    applyEggESP(egg, truePetMap[egg])
                end
            else
                removeAllESP()
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
                    
                    local foundRare = false
                    for _, petName in pairs(truePetMap) do
                        if rarePets[petName] then
                            foundRare = true
                            statusLabel.Text = "Found rare pet: " .. petName
                            autoRunning = false
                            autoBtn.Text = "Auto Randomize: OFF"
                            break
                        end
                    end
                    
                    task.wait(1)
                end
            end)()
        end)
    elseif tabName == "Pet Mutation Finder" then
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Text = "Pet Mutation Finder"
        titleLabel.Size = UDim2.new(1, 0, 0, 30)
        titleLabel.Font = Enum.Font.FredokaOne
        titleLabel.TextSize = 22
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.BackgroundTransparency = 1
        titleLabel.LayoutOrder = 1
        titleLabel.Parent = scrollFrame
        
        local rerollBtn = Instance.new("TextButton")
        rerollBtn.Name = "RerollButton"
        rerollBtn.Text = "Reroll Mutation"
        rerollBtn.Size = UDim2.new(1, 0, 0, 40)
        rerollBtn.Font = Enum.Font.FredokaOne
        rerollBtn.TextSize = 18
        rerollBtn.TextColor3 = Color3.new(1, 1, 1)
        rerollBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
        rerollBtn.LayoutOrder = 2
        
        local rerollCorner = Instance.new("UICorner")
        rerollCorner.CornerRadius = UDim.new(0, 6)
        rerollCorner.Parent = rerollBtn
        rerollBtn.Parent = scrollFrame
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Name = "MutationToggle"
        toggleBtn.Text = "ESP: OFF"
        toggleBtn.Size = UDim2.new(1, 0, 0, 40)
        toggleBtn.Font = Enum.Font.FredokaOne
        toggleBtn.TextSize = 18
        toggleBtn.TextColor3 = Color3.new(1, 1, 1)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
        toggleBtn.LayoutOrder = 3
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 6)
        toggleCorner.Parent = toggleBtn
        toggleBtn.Parent = scrollFrame
        
        rerollBtn.MouseButton1Click:Connect(function()
            currentMutation = mutations[math.random(#mutations)]
            if mutationEspEnabled and mutationEspLabel then
                mutationEspLabel.Text = currentMutation
            end
        end)
        
        toggleBtn.MouseButton1Click:Connect(function()
            mutationEspEnabled = not mutationEspEnabled
            toggleBtn.Text = mutationEspEnabled and "ESP: ON" or "ESP: OFF"
            if mutationEspEnabled then
                setupMutationESP()
            elseif mutationEspGui then
                mutationEspGui:Destroy()
            end
        end)
    elseif tabName == "Pet Age Loader" then
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Text = "Pet Age Loader"
        titleLabel.Size = UDim2.new(1, 0, 0, 30)
        titleLabel.Font = Enum.Font.FredokaOne
        titleLabel.TextSize = 22
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.BackgroundTransparency = 1
        titleLabel.LayoutOrder = 1
        titleLabel.Parent = scrollFrame
        
        local customAgeBtn = Instance.new("TextButton")
        customAgeBtn.Name = "CustomAgeButton"
        customAgeBtn.Text = "Custom Age: OFF"
        customAgeBtn.Size = UDim2.new(1, 0, 0, 30)
        customAgeBtn.Font = Enum.Font.FredokaOne
        customAgeBtn.TextSize = 16
        customAgeBtn.TextColor3 = Color3.new(1, 1, 1)
        customAgeBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 60)
        customAgeBtn.LayoutOrder = 2
        
        local customCorner = Instance.new("UICorner")
        customCorner.CornerRadius = UDim.new(0, 6)
        customCorner.Parent = customAgeBtn
        customAgeBtn.Parent = scrollFrame
        
        local ageInput = Instance.new("TextBox")
        ageInput.Name = "AgeInput"
        ageInput.PlaceholderText = "Enter age (1-100)"
        ageInput.Size = UDim2.new(1, 0, 0, 30)
        ageInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        ageInput.TextColor3 = Color3.new(1, 1, 1)
        ageInput.Text = ""
        ageInput.Font = Enum.Font.Gotham
        ageInput.TextSize = 14
        ageInput.Visible = false
        ageInput.LayoutOrder = 3
        ageInput.Parent = scrollFrame
        
        local ageInputCorner = Instance.new("UICorner")
        ageInputCorner.CornerRadius = UDim.new(0, 6)
        ageInputCorner.Parent = ageInput
        
        local setAgeBtn = Instance.new("TextButton")
        setAgeBtn.Name = "SetAgeButton"
        setAgeBtn.Text = "Set Pet Age"
        setAgeBtn.Size = UDim2.new(1, 0, 0, 40)
        setAgeBtn.Font = Enum.Font.FredokaOne
        setAgeBtn.TextSize = 18
        setAgeBtn.TextColor3 = Color3.new(1, 1, 1)
        setAgeBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
        setAgeBtn.LayoutOrder = 4
        setAgeBtn.Parent = scrollFrame
        
        local setAgeCorner = Instance.new("UICorner")
        setAgeCorner.CornerRadius = UDim.new(0, 6)
        setAgeCorner.Parent = setAgeBtn
        
        local petInfo = Instance.new("TextLabel")
        petInfo.Name = "PetInfo"
        petInfo.Text = "Equipped Pet: [None]"
        petInfo.Size = UDim2.new(1, 0, 0, 20)
        petInfo.Font = Enum.Font.FredokaOne
        petInfo.TextSize = 14
        petInfo.TextColor3 = Color3.fromRGB(200, 220, 255)
        petInfo.BackgroundTransparency = 1
        petInfo.LayoutOrder = 5
        petInfo.Parent = scrollFrame
        
        local customAgeEnabled = false
        local targetAge = 50
        
        customAgeBtn.MouseButton1Click:Connect(function()
            customAgeEnabled = not customAgeEnabled
            customAgeBtn.Text = customAgeEnabled and "Custom Age: ON" or "Custom Age: OFF"
            ageInput.Visible = customAgeEnabled
        end)
        
        ageInput.FocusLost:Connect(function()
            local num = tonumber(ageInput.Text)
            if num and num >= 1 and num <= 100 then
                targetAge = math.floor(num)
                ageInput.Text = tostring(targetAge)
            else
                ageInput.Text = ""
            end
        end)
        
        local function getEquippedPetTool()
            local character = player.Character or player.CharacterAdded:Wait()
            for _, child in pairs(character:GetChildren()) do
                if child:IsA("Tool") and child.Name:find("Age") then
                    return child
                end
            end
            return nil
        end
        
        local function updatePetInfo()
            local pet = getEquippedPetTool()
            if pet then
                petInfo.Text = "Equipped Pet: " .. pet.Name
            else
                petInfo.Text = "Equipped Pet: [None]"
            end
        end
        
        setAgeBtn.MouseButton1Click:Connect(function()
            local tool = getEquippedPetTool()
            if tool then
                local newName = tool.Name:gsub("%[Age%s%d+%]", "[Age "..targetAge.."]")
                tool.Name = newName
                petInfo.Text = "Equipped Pet: " .. tool.Name
                setAgeBtn.Text = "Age Set!"
                task.wait(1.5)
                setAgeBtn.Text = "Set Pet Age"
            else
                setAgeBtn.Text = "No Pet Equipped!"
                task.wait(1.5)
                setAgeBtn.Text = "Set Pet Age"
            end
        end)
        
        game:GetService("RunService").Heartbeat:Connect(updatePetInfo)
    elseif tabName == "Infinite Kitsune" then
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Text = "Infinite Kitsune Chest"
        titleLabel.Size = UDim2.new(1, 0, 0, 30)
        titleLabel.Font = Enum.Font.FredokaOne
        titleLabel.TextSize = 22
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.BackgroundTransparency = 1
        titleLabel.LayoutOrder = 1
        titleLabel.Parent = scrollFrame
        
        local infoLabel = Instance.new("TextLabel")
        infoLabel.Text = "Spawn infinite Kitsune chests in your garden!"
        infoLabel.Size = UDim2.new(1, 0, 0, 60)
        infoLabel.Font = Enum.Font.FredokaOne
        infoLabel.TextSize = 16
        infoLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
        infoLabel.TextWrapped = true
        infoLabel.BackgroundTransparency = 1
        infoLabel.LayoutOrder = 2
        infoLabel.Parent = scrollFrame
        
        local spawnBtn = Instance.new("TextButton")
        spawnBtn.Name = "SpawnButton"
        spawnBtn.Text = "Spawn Kitsune Chest"
        spawnBtn.Size = UDim2.new(1, 0, 0, 50)
        spawnBtn.Font = Enum.Font.FredokaOne
        spawnBtn.TextSize = 20
        spawnBtn.TextColor3 = Color3.new(1, 1, 1)
        spawnBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
        spawnBtn.LayoutOrder = 3
        spawnBtn.Parent = scrollFrame
        
        local spawnCorner = Instance.new("UICorner")
        spawnCorner.CornerRadius = UDim.new(0, 6)
        spawnCorner.Parent = spawnBtn
        
        spawnBtn.MouseButton1Click:Connect(function()
            local character = player.Character
            if not character then return end
            
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then return end
            
            -- Create a chest model
            local chest = Instance.new("Model")
            chest.Name = "KitsuneChest"
            
            local mainPart = Instance.new("Part")
            mainPart.Name = "ChestBase"
            mainPart.Size = Vector3.new(5, 3, 5)
            mainPart.Position = humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector * 8
            mainPart.Anchored = true
            mainPart.CanCollide = true
            mainPart.Color = Color3.fromRGB(255, 165, 0) -- Orange color
            mainPart.Parent = chest
            
            local topPart = Instance.new("Part")
            topPart.Name = "ChestLid"
            topPart.Size = Vector3.new(4.9, 0.5, 4.9)
            topPart.Position = mainPart.Position + Vector3.new(0, 1.75, 0)
            topPart.Anchored = true
            topPart.CanCollide = true
            topPart.Color = Color3.fromRGB(200, 120, 0) -- Darker orange
            topPart.Parent = chest
            
            local clickDetector = Instance.new("ClickDetector")
            clickDetector.Parent = mainPart
            
            chest.Parent = workspace
            
            spawnBtn.Text = "Chest Spawned!"
            task.wait(1.5)
            spawnBtn.Text = "Spawn Kitsune Chest"
        end)
    end
    
    scrollFrame.Parent = tabContentFrame
    backButton.Parent = tabContentFrame
    
    tabContents[i] = tabContentFrame
    
    tabButton.MouseButton1Click:Connect(function()
        for _, content in ipairs(tabContents) do
            content.Visible = false
        end
        
        tabContentFrame.Visible = true
        tabContentFrame.Parent = contentFrame
        
        tabContainer.Visible = false
        tabContainer.Parent = nil
        
        titleLabel.Text = tabName:upper()
    end)
    
    backButton.MouseButton1Click:Connect(function()
        for _, content in ipairs(tabContents) do
            content.Visible = false
            content.Parent = nil
        end
        
        tabContainer.Visible = true
        tabContainer.Parent = contentFrame
        
        titleLabel.Text = "POCARI'S EXPLOITS"
    end)
    
    tabButton.Parent = tabContainer
end

tabContainer.Parent = contentFrame

-- Improved drag functionality
local dragStart
local startPos
local isDragging = false

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

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
        local delta = input.Position - dragStart
        mainWindow.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
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

-- Pulse animation for border
local pulseTween = tweenService:Create(
    mainBorder,
    TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Color = Color3.fromRGB(140, 180, 255)}
)
pulseTween:Play()

-- Initialization coroutine
coroutine.wrap(function()
    task.wait(2)
    local eggs = getPlayerGardenEggs(60)
    for _, egg in pairs(eggs) do
        if not truePetMap[egg] then
            truePetMap[egg] = selectPetForEgg(egg.Name)
        end
        if espEnabled then
            applyEggESP(egg, truePetMap[egg])
        end
    end
    
    if firstTabStatusLabel then
        if #eggs == 0 then
            firstTabStatusLabel.Text = "No eggs found nearby"
        else
            firstTabStatusLabel.Text = "Found "..#eggs.." eggs nearby"
        end
    end
end)()

-- Parent GUI to player's PlayerGui
local playerGui = player:WaitForChild("PlayerGui")
gui.Parent = playerGui
