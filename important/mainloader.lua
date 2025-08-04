-- Wait for game to load with compatibility
local waitFunc = task and task.wait or wait
local spawnFunc = task and task.spawn or spawn

repeat waitFunc() until game:IsLoaded()

-- Service declarations with error handling
local success, Players = pcall(function() return game:GetService("Players") end)
if not success then error("Failed to get Players service") end

local success, Workspace = pcall(function() return game:GetService("Workspace") end)
if not success then error("Failed to get Workspace service") end

local success, TweenService = pcall(function() return game:GetService("TweenService") end)
if not success then error("Failed to get TweenService") end

local success, UserInputService = pcall(function() return game:GetService("UserInputService") end)
if not success then error("Failed to get UserInputService") end

local success, RunService = pcall(function() return game:GetService("RunService") end)
if not success then error("Failed to get RunService") end

-- Player setup with retry logic
local player = Players.LocalPlayer
if not player then
    repeat waitFunc() until Players.LocalPlayer
    player = Players.LocalPlayer
end

local playerGui = player:WaitForChild("PlayerGui")

-- Create main GUI with error handling
local gui = Instance.new("ScreenGui")
gui.Name = "PocariGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 99999
gui.Enabled = true
gui.Parent = playerGui

-- Configuration
local rareChancePercentage = 0.1
local rareMutationChancePercentage = 0.1

-- State variables
local espEnabled = false
local truePetMap = {}
local trackedEggs = {}
local toolTracker = {}

-- Pet data
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
    ["Zen Egg"] = { "Shiba Inu", "Nihonzaru", "Tanuki", "Tanchozuru", "Kappa", "Kitsune" },
    ["Gourmet Egg"] = { "Hot Dog", "Pizza Rat", "Burger Pup", "French Fry Ferret" }
}

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
    ["Polar Bear"] = "Legendary Egg",
    ["French Fry Ferret"] = "Gourmet Egg"
}

local mutations = {
    "Shiny", "Inverted", "Frozen", "Windy", "Golden", "Mega", "Tiny",
    "Tranquil", "IronSkin", "Radiant", "Rainbow", "Shocked", "Ascended"
}
local currentMutation = mutations[math.random(#mutations)]
local mutationEspEnabled = false
local mutationEspGui, mutationEspLabel
local mutationHue = 0

-- Utility functions with enhanced error handling
local function safeCall(func, ...)
    if type(func) ~= "function" then return nil end
    local success, result = pcall(func, ...)
    if not success then
        warn("Error in function call: " .. tostring(result))
        return nil
    end
    return result
end

local function getEquippedTool()
    if not player or not player.Character then return nil end
    local character = player.Character
    for _, child in pairs(character:GetChildren()) do
        if child and child:IsA("Tool") then
            return child
        end
    end
    return nil
end

local function isValidToolFormat(toolName)
    if not toolName or type(toolName) ~= "string" then return false end
    local patterns = {
        "^.+ Chest %[x%d+%]$",
        "^.+ Egg x%d+$",
        "^.+ Seed %[x%d+%]$",
        "^.+ Seed Pack %[X%d+%]$",
        "^.+ Crate x%d+$",
        "^.+ Sprinkler x%d+$"
    }
    
    for _, pattern in ipairs(patterns) do
        if string.match(toolName, pattern) then
            return true
        end
    end
    return false
end

local function extractToolValue(toolName)
    if not toolName or type(toolName) ~= "string" then return 0 end
    local num = string.match(toolName, "%[x(%d+)%]")
    if num then
        return tonumber(num) or 0
    else
        num = string.match(toolName, " x(%d+)$")
        if num then
            return tonumber(num) or 0
        end
    end
    return 0
end

local function setToolValue(toolName, value)
    if not toolName or not value or type(toolName) ~= "string" then return toolName or "" end
    local newName = toolName
    
    if string.match(toolName, "%[x%d+%]") then
        newName = string.gsub(toolName, "%[x%d+%]", "[x" .. value .. "]")
    else
        if string.match(toolName, " x%d+$") then
            newName = string.gsub(toolName, " x%d+$", " x" .. value)
        end
    end
    
    return newName
end

local function getToolBaseName(toolName)
    if not toolName or type(toolName) ~= "string" then return "" end
    local baseName = toolName
    baseName = string.gsub(baseName, " %[x%d+%]$", "")
    baseName = string.gsub(baseName, " x%d+$", "")
    return baseName
end

-- Visual tracking system
local visualTracker = {}
local globalTrackingEnabled = false
local globalTrackingConnection = nil

local function addToVisualTracker(toolName, initialValue, visualBonus)
    if not toolName then return end
    local baseName = getToolBaseName(toolName)
    visualTracker[baseName] = {
        initialValue = initialValue or 0,
        currentVisualBonus = visualBonus or 0,
        lastRealValue = initialValue or 0,
        isActive = true,
        toolName = toolName
    }
end

local function getVisualValue(toolName, realValue)
    if not toolName then return realValue or 0 end
    local baseName = getToolBaseName(toolName)
    local tracker = visualTracker[baseName]
    
    if not tracker or not tracker.isActive then
        return realValue or 0
    end
    
    -- Check if real value decreased (tool was used)
    if (realValue or 0) < tracker.lastRealValue then
        tracker.lastRealValue = realValue or 0
    elseif (realValue or 0) > tracker.lastRealValue then
        tracker.lastRealValue = realValue or 0
    end
    
    return (realValue or 0) + tracker.currentVisualBonus
end

local function updateVisualBonus(toolName, additionalBonus)
    if not toolName then return end
    local baseName = getToolBaseName(toolName)
    local tracker = visualTracker[baseName]
    
    if tracker and tracker.isActive then
        tracker.currentVisualBonus = tracker.currentVisualBonus + (additionalBonus or 0)
    end
end

local function startGlobalTracking()
    if globalTrackingConnection then return end
    
    globalTrackingEnabled = true
    globalTrackingConnection = RunService.Heartbeat:Connect(function()
        if not globalTrackingEnabled then return end
        
        -- Check equipped tool
        local equippedTool = getEquippedTool()
        if equippedTool and equippedTool.Name and isValidToolFormat(equippedTool.Name) then
            local baseName = getToolBaseName(equippedTool.Name)
            local tracker = visualTracker[baseName]
            
            if tracker and tracker.isActive then
                local currentRealValue = extractToolValue(equippedTool.Name)
                local visualValue = getVisualValue(equippedTool.Name, currentRealValue)
                
                safeCall(function()
                    equippedTool.Name = setToolValue(equippedTool.Name, visualValue)
                end)
            end
        end
        
        -- Check backpack tools
        if player and player:FindFirstChild("Backpack") then
            local backpack = player.Backpack
            for _, tool in pairs(backpack:GetChildren()) do
                if tool and tool:IsA("Tool") and tool.Name and isValidToolFormat(tool.Name) then
                    local baseName = getToolBaseName(tool.Name)
                    local tracker = visualTracker[baseName]
                    
                    if tracker and tracker.isActive then
                        local currentRealValue = extractToolValue(tool.Name)
                        local visualValue = getVisualValue(tool.Name, currentRealValue)
                        
                        safeCall(function()
                            tool.Name = setToolValue(tool.Name, visualValue)
                        end)
                    end
                end
            end
        end
    end)
end

local function stopGlobalTracking()
    globalTrackingEnabled = false
    if globalTrackingConnection then
        globalTrackingConnection:Disconnect()
        globalTrackingConnection = nil
    end
end

-- Effects with enhanced safety
local function rainbowEffect(label)
    if not label or not label.Parent then return end
    spawnFunc(function()
        local hue = 0
        while waitFunc(0.03) and label and label.Parent and label:IsDescendantOf(game) do
            hue = (hue + 0.01) % 1
            safeCall(function()
                if label and label.Parent then
                    label.TextColor3 = Color3.fromHSV(hue, 1, 1)
                end
            end)
        end
    end)
end

local function glitchLabelEffect(label)
    if not label or not label.Parent then return end
    spawnFunc(function()
        local original = label.TextColor3
        for i = 1, 2 do
            safeCall(function()
                if label and label.Parent then
                    label.TextColor3 = Color3.new(1, 0, 0)
                end
            end)
            waitFunc(0.07)
            safeCall(function()
                if label and label.Parent then
                    label.TextColor3 = original
                end
            end)
            waitFunc(0.07)
        end
    end)
end

-- Egg system with better error handling
local function getHatchState(eggModel)
    if not eggModel then return false end
    local hatchReady = true
    local hatchTime = eggModel:FindFirstChild("HatchTime")
    local readyFlag = eggModel:FindFirstChild("ReadyToHatch")
    if hatchTime and hatchTime:IsA("NumberValue") and hatchTime.Value > 0 then
        hatchReady = false
    elseif readyFlag and readyFlag:IsA("BoolValue") and not readyFlag.Value then
        hatchReady = false
    end
    return hatchReady
end

local function selectPetForEgg(eggName)
    local pets = petTable[eggName]
    if not pets then return "Unknown" end
    if math.random(1, 100) <= rareChancePercentage then
        for petName, requiredEgg in pairs(rarePets) do
            if requiredEgg == eggName then
                return petName
            end
        end
    end
    return pets[math.random(1, #pets)]
end

local function applyEggESP(eggModel, petName)
    if not eggModel or not petName then return end
    if trackedEggs[eggModel] then return end
    
    local existingLabel = eggModel:FindFirstChild("PetBillboard", true)
    if existingLabel then existingLabel:Destroy() end
    local existingHighlight = eggModel:FindFirstChild("ESPHighlight")
    if existingHighlight then existingHighlight:Destroy() end
    if not espEnabled then return end

    local basePart = eggModel:FindFirstChildWhichIsA("BasePart")
    if not basePart then return end

    local hatchReady = getHatchState(eggModel)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PetBillboard"
    billboard.Size = UDim2.new(0, 270, 0, 25)
    billboard.StudsOffset = Vector3.new(0, 4.5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 500
    billboard.Parent = basePart

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "["..eggModel.Name.."] "..petName
    if not hatchReady then
        label.Text = "["..eggModel.Name.."] "..petName.." (Not Ready)"
        label.TextColor3 = Color3.fromRGB(160, 160, 160)
        label.TextStrokeTransparency = 0.5
    else
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0
    end
    label.TextScaled = false
    label.TextSize = 18
    label.TextWrapped = false
    label.TextTruncate = Enum.TextTruncate.AtEnd
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
    if not eggModel or not trackedEggs[eggModel] then return end
    for _, obj in ipairs(trackedEggs[eggModel]) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    trackedEggs[eggModel] = nil
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

local function getPlayerGardenEggs(radius)
    local eggs = {}
    if not player or not player.Character then return eggs end
    local char = player.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return eggs end

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj and obj:IsA("Model") and obj.Name and petTable[obj.Name] then
            safeCall(function()
                local success, modelCFrame = pcall(function() 
                    return obj:GetModelCFrame() 
                end)
                if success and modelCFrame then
                    local dist = (modelCFrame.Position - root.Position).Magnitude
                    if dist <= (radius or 60) then
                        if not truePetMap[obj] then
                            truePetMap[obj] = selectPetForEgg(obj.Name)
                        end
                        table.insert(eggs, obj)
                    end
                end
            end)
        end
    end
    return eggs
end

local function randomizeNearbyEggs()
    local eggs = getPlayerGardenEggs(60)
    for _, egg in ipairs(eggs) do
        local finalPet = selectPetForEgg(egg.Name)
        truePetMap[egg] = finalPet
        if espEnabled then
            if not trackedEggs[egg] then
                applyEggESP(egg, finalPet)
            end
        end
    end
    return #eggs
end

-- Mutation system
local function selectMutation()
    local rareMutations = {"Rainbow", "Mega", "Ascended"}
    local normalMutations = {"Shiny", "Inverted", "Frozen", "Windy", "Golden", "Tiny", "Tranquil", "IronSkin", "Radiant", "Shocked"}
    
    if math.random(1, 100) <= rareMutationChancePercentage then
        return rareMutations[math.random(1, #rareMutations)]
    else
        return normalMutations[math.random(1, #normalMutations)]
    end
end

local function findMutationMachine()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj and obj:IsA("Model") and obj.Name and string.find(string.lower(obj.Name), "mutation") then
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
        if mutationEspEnabled and mutationEspLabel and mutationEspLabel.Parent then
            mutationHue = (mutationHue + 0.01) % 1
            safeCall(function()
                if mutationEspLabel and mutationEspLabel.Parent then
                    mutationEspLabel.TextColor3 = Color3.fromHSV(mutationHue, 1, 1)
                end
            end)
        end
    end)
end

-- Create main GUI elements
local mainWindow = Instance.new("Frame")
mainWindow.Name = "MainFrame"
mainWindow.Size = UDim2.new(0, 320, 0, 240)
mainWindow.Position = UDim2.new(0.5, -160, 0.5, -120)
mainWindow.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainWindow.ClipsDescendants = true
mainWindow.Visible = true
mainWindow.Parent = gui

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
titleBar.Parent = mainWindow

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
titleLabel.Parent = titleBar

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
closeButton.Parent = titleBar

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
minimizeButton.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeButton

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.BackgroundTransparency = 1
contentFrame.Size = UDim2.new(1, -16, 1, -60)
contentFrame.Position = UDim2.new(0, 8, 0, 40)
contentFrame.ClipsDescendants = true
contentFrame.Parent = mainWindow

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
watermark.Parent = mainWindow

-- Create simple main menu instead of complex tabs
local menuContainer = Instance.new("Frame")
menuContainer.Name = "MenuContainer"
menuContainer.Size = UDim2.new(1, 0, 1, 0)
menuContainer.BackgroundTransparency = 1
menuContainer.Parent = contentFrame

local menuLayout = Instance.new("UIListLayout")
menuLayout.Padding = UDim.new(0, 8)
menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.Parent = menuContainer

local menuPadding = Instance.new("UIPadding")
menuPadding.PaddingAll = UDim.new(0, 8)
menuPadding.Parent = menuContainer

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Text = "Ready to use!"
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Font = Enum.Font.FredokaOne
statusLabel.TextSize = 14
statusLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
statusLabel.BackgroundTransparency = 1
statusLabel.LayoutOrder = 1
statusLabel.Parent = menuContainer

-- Randomize Button
local randomizeBtn = Instance.new("TextButton")
randomizeBtn.Name = "RandomizeButton"
randomizeBtn.Text = "Randomize Pets"
randomizeBtn.Size = UDim2.new(1, 0, 0, 40)
randomizeBtn.Font = Enum.Font.FredokaOne
randomizeBtn.TextSize = 18
randomizeBtn.TextColor3 = Color3.new(1, 1, 1)
randomizeBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
randomizeBtn.LayoutOrder = 2
randomizeBtn.Parent = menuContainer

local randomizeCorner = Instance.new("UICorner")
randomizeCorner.CornerRadius = UDim.new(0, 6)
randomizeCorner.Parent = randomizeBtn

-- ESP Toggle Button
local espToggleBtn = Instance.new("TextButton")
espToggleBtn.Name = "ESPToggle"
espToggleBtn.Text = "ESP: OFF"
espToggleBtn.Size = UDim2.new(1, 0, 0, 30)
espToggleBtn.Font = Enum.Font.FredokaOne
espToggleBtn.TextSize = 16
espToggleBtn.TextColor3 = Color3.new(1, 1, 1)
espToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
espToggleBtn.LayoutOrder = 3
espToggleBtn.Parent = menuContainer

local espToggleCorner = Instance.new("UICorner")
espToggleCorner.CornerRadius = UDim.new(0, 6)
espToggleCorner.Parent = espToggleBtn

-- Button functionality
local isRandomizing = false

randomizeBtn.MouseButton1Click:Connect(function()
    if isRandomizing then return end
    isRandomizing = true
    randomizeBtn.Active = false
    
    statusLabel.Text = "Randomizing pets..."
    randomizeBtn.Text = "Randomizing..."
    
    local count = randomizeNearbyEggs()
    randomizeBtn.Text = "Randomized "..count.." Pets!"
    statusLabel.Text = "Randomized "..count.." pets!"
    
    waitFunc(1.5)
    randomizeBtn.Text = "Randomize Pets"
    statusLabel.Text = "Ready to use!"
    
    randomizeBtn.Active = true
    isRandomizing = false
end)

espToggleBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggleBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    
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

-- Window dragging functionality with better error handling
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
                if connection then
                    connection:Disconnect()
                end
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging and dragStart then
        local delta = input.Position - dragStart
        mainWindow.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Window minimize functionality
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
    if minimized then
        TweenService:Create(mainWindow, tweenInfo, {Size = UDim2.new(0, 320, 0, 32)}):Play()
        TweenService:Create(contentFrame, tweenInfo, {Size = UDim2.new(1, -16, 0, 0)}):Play()
        TweenService:Create(watermark, tweenInfo, {TextTransparency = 1}):Play()
        minimizeButton.Text = "+"
    else
        TweenService:Create(mainWindow, tweenInfo, {Size = UDim2.new(0, 320, 0, 240)}):Play()
        TweenService:Create(contentFrame, tweenInfo, {Size = UDim2.new(1, -16, 1, -60)}):Play()
        TweenService:Create(watermark, tweenInfo, {TextTransparency = 0}):Play()
        minimizeButton.Text = "-"
    end
end)

-- Window close functionality
closeButton.MouseButton1Click:Connect(function()
    -- Clean up connections
    if globalTrackingConnection then
        globalTrackingConnection:Disconnect()
    end
    
    -- Clean up ESP
    removeAllESP()
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
    TweenService:Create(mainWindow, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    TweenService:Create(titleBar, tweenInfo, {BackgroundTransparency = 1}):Play()
    waitFunc(0.3)
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

-- Initialize after setup with enhanced error handling
local function initializeAfterSetup()
    if mainBorder then
        safeCall(function()
            local pulseTween = TweenService:Create(
                mainBorder,
                TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {Color = Color3.fromRGB(140, 180, 255)}
            )
            pulseTween:Play()
        end)
    end

    spawnFunc(function()
        waitFunc(2)
        local eggs = getPlayerGardenEggs(60)
        for _, egg in pairs(eggs) do
            if not truePetMap[egg] then
                truePetMap[egg] = selectPetForEgg(egg.Name)
            end
        end
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = #eggs == 0 and "No eggs found nearby" or "Found "..#eggs.." eggs nearby"
        end
    end)
end

-- Start initialization
spawnFunc(initializeAfterSetup)

print("Pocari's GUI loaded successfully!")
