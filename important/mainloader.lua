local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Updated pet table with rare pets only in their specific eggs
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
    ["Oasis Egg"] = { "Meerkat", "Sand Snake", "Axolotl", "Fennec Fox" },
    ["Paradise Egg"] = { "Ostrich", "Peacock", "Capybara", "Mimic Octopus" },
    ["Dinosaur Egg"] = { "Raptor", "Triceratops", "Stegosaurus", "T-Rex" },
    ["Primal Egg"] = { "Parasaurolophus", "Iguanodon", "Pachycephalosaurus", "Spinosaurus" },
    ["Zen Egg"] = { "Kitsune" } -- Added Zen Egg
}

-- ESP is off by default
local espEnabled = false
local truePetMap = {}

-- List of rare pets with pulsing effect
local rarePets = {
    "kitsune", "t-rex", "spinosaurus", "dragonfly", "butterfly", 
    "disco bee", "queen bee", "red fox", "raccoon", "fennec fox", 
    "mimic octopus", "polar bear"
}

local function glitchLabelEffect(label)
    coroutine.wrap(function()
        local original = label.TextColor3
        for i = 1, 2 do
            label.TextColor3 = Color3.new(1, 0, 0)
            wait(0.07)
            label.TextColor3 = original
            wait(0.07)
        end
    end)()
end

local function applyRainbowEffect(label)
    coroutine.wrap(function()
        local hue = 0
        while label and label.Parent do
            label.TextColor3 = Color3.fromHSV(hue, 1, 1)
            hue = (hue + 0.01) % 1
            wait(0.03)
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
    label.Text = eggModel.Name .. " | " .. petName
    label.TextScaled = true
    label.Font = Enum.Font.FredokaOne
    label.Parent = billboard
    
    -- Apply rainbow effect for rare pets
    local isRare = false
    for _, rarePet in ipairs(rarePets) do
        if string.lower(petName) == string.lower(rarePet) then
            isRare = true
            break
        end
    end
    
    if isRare then
        applyRainbowEffect(label)
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
    elseif not hatchReady then
        label.Text = eggModel.Name .. " | " .. petName .. " (Not Ready)"
        label.TextColor3 = Color3.fromRGB(160, 160, 160)
        label.TextStrokeTransparency = 0.5
    else
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0
    end

    if not isRare then
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
    
    -- Special highlight for rare pets
    if isRare then
        highlight.FillColor = Color3.fromRGB(255, 50, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    end
end

local function removeEggESP(eggModel)
    local label = eggModel:FindFirstChild("PetBillboard", true)
    if label then label:Destroy() end
    local highlight = eggModel:FindFirstChild("ESPHighlight")
    if highlight then highlight:Destroy() end
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
                    local pets = petTable[obj.Name]
                    local chosen = pets[math.random(1, #pets)]
                    
                    -- 0.05% chance for rare pets in their specific eggs
                    if math.random() <= 0.0005 then
                        -- Get only rare pets that belong to this egg type
                        local possibleRares = {}
                        for _, rare in ipairs(rarePets) do
                            for _, pet in ipairs(pets) do
                                if string.lower(pet) == string.lower(rare) then
                                    table.insert(possibleRares, rare)
                                    break
                                end
                            end
                        end
                        
                        if #possibleRares > 0 then
                            chosen = possibleRares[math.random(1, #possibleRares)]
                        end
                    end
                    
                    truePetMap[obj] = chosen
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
        local pets = petTable[egg.Name]
        local chosen = pets[math.random(1, #pets)]
        
        -- 0.05% chance for rare pets in their specific eggs
        if math.random() <= 0.0005 then
            -- Get only rare pets that belong to this egg type
            local possibleRares = {}
            for _, rare in ipairs(rarePets) do
                for _, pet in ipairs(pets) do
                    if string.lower(pet) == string.lower(rare) then
                        table.insert(possibleRares, rare)
                        break
                    end
                end
            end
            
            if #possibleRares > 0 then
                chosen = possibleRares[math.random(1, #possibleRares)]
            end
        end
        
        truePetMap[egg] = chosen
        applyEggESP(egg, chosen)
    end
    print("Randomized", #eggs, "eggs.")
end

local function flashEffect(button)
    local originalColor = button.BackgroundColor3
    for i = 1, 3 do
        button.BackgroundColor3 = Color3.new(1, 1, 1)
        wait(0.05)
        button.BackgroundColor3 = originalColor
        wait(0.05)
    end
end

local function countdownAndRandomize(button)
    for i = 10, 1, -1 do
        button.Text = "Randomize in: " .. i
        wait(1)
    end
    flashEffect(button)
    randomizeNearbyEggs()
    button.Text = "Randomize Pets"
end

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "PetHatchGui"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 260)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(105, 80, 60)
frame.BorderSizePixel = 0
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Pet Randomizer"
title.Font = Enum.Font.FredokaOne
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 255)

local drag = Instance.new("TextButton", title)
drag.Size = UDim2.new(1, 0, 1, 0)
drag.Text = ""
drag.BackgroundTransparency = 1

local dragging, offset
drag.MouseButton1Down:Connect(function()
    dragging = true
    offset = Vector2.new(mouse.X - frame.Position.X.Offset, mouse.Y - frame.Position.Y.Offset)
end)
UserInputService.InputEnded:Connect(function()
    dragging = false
end)
RunService.RenderStepped:Connect(function()
    if dragging then
        frame.Position = UDim2.new(0, mouse.X - offset.X, 0, mouse.Y - offset.Y)
    end
end)

local randomizeBtn = Instance.new("TextButton", frame)
randomizeBtn.Size = UDim2.new(1, -20, 0, 50)
randomizeBtn.Position = UDim2.new(0, 10, 0, 40)
randomizeBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
randomizeBtn.Text = "Randomize Pets"
randomizeBtn.TextSize = 20
randomizeBtn.Font = Enum.Font.FredokaOne
randomizeBtn.TextColor3 = Color3.new(1, 1, 1)
randomizeBtn.MouseButton1Click:Connect(function()
    countdownAndRandomize(randomizeBtn)
end)

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -20, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 100)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.Text = "ESP: OFF"  -- Default to OFF
toggleBtn.TextSize = 18
toggleBtn.Font = Enum.Font.FredokaOne
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
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
end)

-- Initialize without applying ESP (since it's off by default)
for _, egg in pairs(getPlayerGardenEggs(60)) do
    -- Only set the pet mapping, don't apply ESP
    if not truePetMap[egg] then
        local pets = petTable[egg.Name]
        local chosen = pets[math.random(1, #pets)]
        
        -- 0.05% chance for rare pets in their specific eggs
        if math.random() <= 0.0005 then
            -- Get only rare pets that belong to this egg type
            local possibleRares = {}
            for _, rare in ipairs(rarePets) do
                for _, pet in ipairs(pets) do
                    if string.lower(pet) == string.lower(rare) then
                        table.insert(possibleRares, rare)
                        break
                    end
                end
            end
            
            if #possibleRares > 0 then
                chosen = possibleRares[math.random(1, #possibleRares)]
            end
        end
        
        truePetMap[egg] = chosen
    end
end

local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(1, -20, 0, 30)
autoBtn.Position = UDim2.new(0, 10, 0, 145)
autoBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 60)
autoBtn.Text = "Auto Randomize: OFF"
autoBtn.TextSize = 16
autoBtn.Font = Enum.Font.FredokaOne
autoBtn.TextColor3 = Color3.new(1, 1, 1)

local autoRunning = false
local bestPets = {
    ["Raccoon"] = true, ["Dragonfly"] = true, ["Queen Bee"] = true,
    ["Disco Bee"] = true, ["Fennec Fox"] = true, ["Fox"] = true,
    ["Mimic Octopus"] = true
}

autoBtn.MouseButton1Click:Connect(function()
    autoRunning = not autoRunning
    autoBtn.Text = autoRunning and "Auto Randomize: ON" or "Auto Randomize: OFF"
    coroutine.wrap(function()
        while autoRunning do
            countdownAndRandomize(randomizeBtn)
            for _, petName in pairs(truePetMap) do
                if bestPets[petName] then
                    autoRunning = false
                    autoBtn.Text = "Auto Randomize: OFF"
                    return
                end
            end
            wait(1)
        end
    end)()
end)

local loadPetBtn = Instance.new("TextButton", frame)
loadPetBtn.Size = UDim2.new(1, -20, 0, 30)
loadPetBtn.Position = UDim2.new(0, 10, 1, -75)
loadPetBtn.BackgroundColor3 = Color3.fromRGB(100, 90, 200)
loadPetBtn.Text = "Pet Mutation Esp Script"
loadPetBtn.TextSize = 16
loadPetBtn.Font = Enum.Font.FredokaOne
loadPetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

loadPetBtn.MouseButton1Click:Connect(function()

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local mutations = {
    "Shiny", "Inverted", "Frozen", "Windy", "Golden", "Mega", "Tiny",
    "Tranquil", "IronSkin", "Radiant", "Rainbow", "Shocked", "Ascended"
}
local currentMutation = mutations[math.random(#mutations)]
local espVisible = true

local gui = Instance.new("ScreenGui")
gui.Name = "PetMutationFinder"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 185)
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BorderColor3 = Color3.fromRGB(80, 80, 90)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(100, 100, 110)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "Pet Mutation Finder"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local function createButton(text, yPos, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, 0, yPos)
	btn.BackgroundColor3 = color
	btn.Text = text
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 16
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.AutoButtonColor = false

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1.2

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color:Lerp(Color3.new(1,1,1), 0.2)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
	end)

	btn.Parent = frame
	return btn
end

local reroll = createButton("Reroll Mutation", 45, Color3.fromRGB(140, 200, 255))
local toggle = createButton("Toggle Mutation Esp", 90, Color3.fromRGB(180, 255, 180))

local function findMachine()
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name:lower():find("mutation") then
			return obj
		end
	end
end

local machine = findMachine()
if not machine or not machine:FindFirstChildWhichIsA("BasePart") then
	warn("Pet Mutation Machine not found.")
	return
end

local basePart = machine:FindFirstChildWhichIsA("BasePart")

local espGui = Instance.new("BillboardGui", basePart)
espGui.Name = "MutationESP"
espGui.Adornee = basePart
espGui.Size = UDim2.new(0, 200, 0, 40)
espGui.StudsOffset = Vector3.new(0, 3, 0)
espGui.AlwaysOnTop = true

local espLabel = Instance.new("TextLabel", espGui)
espLabel.Size = UDim2.new(1, 0, 1, 0)
espLabel.BackgroundTransparency = 1
espLabel.Font = Enum.Font.GothamBold
espLabel.TextSize = 24
espLabel.TextStrokeTransparency = 0.3
espLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
espLabel.Text = currentMutation

local hue = 0
RunService.RenderStepped:Connect(function()
	if espVisible then
		hue = (hue + 0.01) % 1
		espLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
	end
end)

local function animateMutationReroll()
	reroll.Text = "Rerolling..."
	local duration = 2
	local interval = 0.1
	for i = 1, math.floor(duration / interval) do
		espLabel.Text = mutations[math.random(#mutations)]
		wait(interval)
	end
	currentMutation = mutations[math.random(#mutations)]
	espLabel.Text = currentMutation
	reroll.Text = "Reroll Mutation"
end

toggle.MouseButton1Click:Connect(function()
	espVisible = not espVisible
	espGui.Enabled = espVisible
end)

reroll.MouseButton1Click:Connect(animateMutationReroll)
end)

local loadAgeBtn = Instance.new("TextButton", frame)
loadAgeBtn.Size = UDim2.new(1, -20, 0, 30)
loadAgeBtn.Position = UDim2.new(0, 10, 1, -35)
loadAgeBtn.BackgroundColor3 = Color3.fromRGB(100, 90, 200)
loadAgeBtn.Text = "Load Pet Age 50 Script"
loadAgeBtn.TextSize = 16
loadAgeBtn.Font = Enum.Font.FredokaOne
loadAgeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

loadAgeBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/munkizzzz/x/refs/heads/main/Egg_RandomizerV2.lua"))()
end)
