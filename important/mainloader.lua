repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
if not player then
    repeat task.wait() until Players.LocalPlayer
    player = Players.LocalPlayer
end

local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "PocariGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 99999
gui.Enabled = true
gui.Parent = playerGui

local rareChancePercentage = 0.1
local rareMutationChancePercentage = 0.1

local espEnabled = false
local truePetMap = {}
local trackedEggs = {}
local toolTracker = {}

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

local function setupMutationESP()
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

closeButton.Parent = titleBar
titleLabel.Parent = titleBar
titleBar.Parent = mainWindow
watermark.Parent = mainWindow
contentFrame.Parent = mainWindow
mainWindow.Parent = gui

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

local tabNames = {
    "Egg Randomizer",
    "Pet Mutation Finder", 
    "Pet Age Loader",
    "Infinite Loader"
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
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
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
        
        local isRandomizing = false
        local isToggling = false
        
        randomizeBtn.MouseButton1Click:Connect(function()
            if isRandomizing then return end
            isRandomizing = true
            randomizeBtn.Active = false
            toggleBtn.Active = false
            autoBtn.Active = false
            
            statusLabel.Text = "Starting randomization..."
            randomizeBtn.Text = "Randomizing..."
            
            local count = randomizeNearbyEggs()
            randomizeBtn.Text = "Randomized "..count.." Pets!"
            statusLabel.Text = "Randomized "..count.." pets!"
            
            task.wait(1.5)
            randomizeBtn.Text = "Randomize Pets"
            statusLabel.Text = "Ready to randomize!"
            
            randomizeBtn.Active = true
            toggleBtn.Active = true
            autoBtn.Active = true
            isRandomizing = false
        end)
        
        toggleBtn.MouseButton1Click:Connect(function()
            if isToggling then return end
            isToggling = true
            toggleBtn.Active = false
            
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
            task.wait(0.5)
            
            toggleBtn.Active = true
            isToggling = false
        end)
        
        local autoRunning = false
        local isAutoProcessing = false
        
        autoBtn.MouseButton1Click:Connect(function()
            if isAutoProcessing then return end
            isAutoProcessing = true
            
            autoRunning = not autoRunning
            autoBtn.Text = autoRunning and "Auto Randomize: ON" or "Auto Randomize: OFF"
            statusLabel.Text = autoRunning and "Auto-randomize started!" or "Auto-randomize stopped"
            
            if autoRunning then
                randomizeBtn.Active = false
                toggleBtn.Active = false
                autoBtn.Active = false
                
                task.spawn(function()
                    while autoRunning do
                        statusLabel.Text = "Auto-randomizing..."
                        randomizeBtn.Text = "Randomizing..."
                        
                        local count = randomizeNearbyEggs()
                        randomizeBtn.Text = "Randomized "..count.." Pets!"
                        statusLabel.Text = "Randomized "..count.." pets!"
                        
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
                        
                        task.wait(1.5)
                        
                        if foundRare then
                            randomizeBtn.Text = "Randomize Pets"
                            statusLabel.Text = "Found rare pet! Stopped."
                        else
                            randomizeBtn.Text = "Randomize Pets"
                            statusLabel.Text = "Ready to randomize!"
                        end
                        
                        task.wait(1)
                    end
                    
                    randomizeBtn.Active = true
                    toggleBtn.Active = true
                    autoBtn.Active = true
                    isAutoProcessing = false
                end)
            else
                isAutoProcessing = false
            end
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
            rerollBtn.Text = "Rerolling..."
            rerollBtn.Active = false
            
            local finalMutation = selectMutation()
            
            if mutationEspEnabled then
                task.spawn(function()
                    animateMutationESP(3, finalMutation)
                end)
            else
                currentMutation = finalMutation
            end
            
            task.wait(3.5)
            rerollBtn.Text = "Reroll Mutation"
            rerollBtn.Active = true
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
            local character = player.Character
            if not character then return nil end
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
        
        local isSettingAge = false
        
        setAgeBtn.MouseButton1Click:Connect(function()
            if isSettingAge then return end
            isSettingAge = true
            setAgeBtn.Active = false
            
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
            
            setAgeBtn.Active = true
            isSettingAge = false
        end)
        
        RunService.Heartbeat:Connect(updatePetInfo)
        
    elseif tabName == "Infinite Loader" then
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Text = "Infinite Loader"
        titleLabel.Size = UDim2.new(1, 0, 0, 30)
        titleLabel.Font = Enum.Font.FredokaOne
        titleLabel.TextSize = 22
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.BackgroundTransparency = 1
        titleLabel.LayoutOrder = 1
        titleLabel.Parent = scrollFrame
        
        local toolInfo = Instance.new("TextLabel")
        toolInfo.Name = "ToolInfo"
        toolInfo.Text = "Equipped Tool: [None]"
        toolInfo.Size = UDim2.new(1, 0, 0, 40)
        toolInfo.Font = Enum.Font.FredokaOne
        toolInfo.TextSize = 14
        toolInfo.TextColor3 = Color3.fromRGB(200, 220, 255)
        toolInfo.BackgroundTransparency = 1
        toolInfo.TextWrapped = true
        toolInfo.LayoutOrder = 2
        toolInfo.Parent = scrollFrame
        
        local validityLabel = Instance.new("TextLabel")
        validityLabel.Name = "ValidityLabel"
        validityLabel.Text = "Status: No tool equipped"
        validityLabel.Size = UDim2.new(1, 0, 0, 20)
        validityLabel.Font = Enum.Font.FredokaOne
        validityLabel.TextSize = 12
        validityLabel.TextColor3 = Color3.fromRGB(255, 180, 180)
        validityLabel.BackgroundTransparency = 1
        validityLabel.LayoutOrder = 3
        validityLabel.Parent = scrollFrame
        
        local loadingFrame = Instance.new("Frame")
        loadingFrame.Name = "LoadingFrame"
        loadingFrame.Size = UDim2.new(1, 0, 0, 30)
        loadingFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        loadingFrame.BorderSizePixel = 0
        loadingFrame.Visible = false
        loadingFrame.LayoutOrder = 4
        loadingFrame.Parent = scrollFrame
        
        local loadingCorner = Instance.new("UICorner")
        loadingCorner.CornerRadius = UDim.new(0, 6)
        loadingCorner.Parent = loadingFrame
        
        local loadingBar = Instance.new("Frame")
        loadingBar.Name = "LoadingBar"
        loadingBar.Size = UDim2.new(0, 0, 1, 0)
        loadingBar.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
        loadingBar.BorderSizePixel = 0
        loadingBar.Parent = loadingFrame
        
        local loadingBarCorner = Instance.new("UICorner")
        loadingBarCorner.CornerRadius = UDim.new(0, 6)
        loadingBarCorner.Parent = loadingBar
        
        local loadingText = Instance.new("TextLabel")
        loadingText.Name = "LoadingText"
        loadingText.Text = "Initializing..."
        loadingText.Size = UDim2.new(1, 0, 1, 0)
        loadingText.BackgroundTransparency = 1
        loadingText.Font = Enum.Font.FredokaOne
        loadingText.TextSize = 12
        loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
        loadingText.Parent = loadingFrame
        
        local trackerInfo = Instance.new("TextLabel")
        trackerInfo.Name = "TrackerInfo"
        trackerInfo.Text = "Visual: 0 | Real: 0 | Bonus: 0"
        trackerInfo.Size = UDim2.new(1, 0, 0, 20)
        trackerInfo.Font = Enum.Font.FredokaOne
        trackerInfo.TextSize = 12
        trackerInfo.TextColor3 = Color3.fromRGB(180, 255, 180)
        trackerInfo.BackgroundTransparency = 1
        trackerInfo.LayoutOrder = 5
        trackerInfo.Parent = scrollFrame
        
        local trackedItemsList = Instance.new("TextLabel")
        trackedItemsList.Name = "TrackedItemsList"
        trackedItemsList.Text = "Tracked Items: None"
        trackedItemsList.Size = UDim2.new(1, 0, 0, 40)
        trackedItemsList.Font = Enum.Font.Gotham
        trackedItemsList.TextSize = 10
        trackedItemsList.TextColor3 = Color3.fromRGB(160, 200, 255)
        trackedItemsList.BackgroundTransparency = 1
        trackedItemsList.TextWrapped = true
        trackedItemsList.TextYAlignment = Enum.TextYAlignment.Top
        trackedItemsList.LayoutOrder = 5.5
        trackedItemsList.Parent = scrollFrame
        
        local loadBtn = Instance.new("TextButton")
        loadBtn.Name = "LoadInfiniteButton"
        loadBtn.Text = "Load Infinite"
        loadBtn.Size = UDim2.new(1, 0, 0, 40)
        loadBtn.Font = Enum.Font.FredokaOne
        loadBtn.TextSize = 18
        loadBtn.TextColor3 = Color3.new(1, 1, 1)
        loadBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
        loadBtn.LayoutOrder = 6
        loadBtn.Active = false
        loadBtn.Parent = scrollFrame
        
        local loadCorner = Instance.new("UICorner")
        loadCorner.CornerRadius = UDim.new(0, 6)
        loadCorner.Parent = loadBtn
        
        local infoLabel = Instance.new("TextLabel")
        infoLabel.Text = "Supported formats:\n• Name Chest [x#]\n• Name Egg x#\n• Name Seed [x#]\n• Name Seed Pack [X#]\n• Name Crate x#\n• Name Sprinkler x#\n\nGlobal persistent tracking!\n+1 every 0.3s when active.\nTracks ALL tools automatically."
        infoLabel.Size = UDim2.new(1, 0, 0, 100)
        infoLabel.Font = Enum.Font.Gotham
        infoLabel.TextSize = 11
        infoLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
        infoLabel.TextWrapped = true
        infoLabel.BackgroundTransparency = 1
        infoLabel.TextYAlignment = Enum.TextYAlignment.Top
        infoLabel.LayoutOrder = 7
        infoLabel.Parent = scrollFrame
        
        local isLoading = false
        local incrementConnection = nil
        local updateConnection = nil
        
        -- Function to update tracked items display
        local function updateTrackedItemsDisplay()
            local trackedItems = {}
            for baseName, tracker in pairs(visualTracker) do
                if tracker.isActive then
                    table.insert(trackedItems, baseName .. " (+" .. tracker.currentVisualBonus .. ")")
                end
            end
            
            if #trackedItems > 0 then
                trackedItemsList.Text = "Tracked Items: " .. table.concat(trackedItems, ", ")
            else
                trackedItemsList.Text = "Tracked Items: None"
            end
        end
        
        local function updateToolInfo()
            local tool = getEquippedTool()
            if tool then
                local realValue = extractToolValue(tool.Name)
                local baseName = getToolBaseName(tool.Name)
                local tracker = visualTracker[baseName]
                
                toolInfo.Text = "Equipped Tool: " .. getToolBaseName(tool.Name)
                
                if tracker and tracker.isActive then
                    local visualValue = getVisualValue(tool.Name, realValue)
                    trackerInfo.Text = "Visual: " .. visualValue .. 
                                     " | Real: " .. realValue .. 
                                     " | Bonus: +" .. tracker.currentVisualBonus
                    trackerInfo.Visible = true
                else
                    trackerInfo.Text = "Visual: " .. realValue .. 
                                     " | Real: " .. realValue .. 
                                     " | Bonus: +0"
                    trackerInfo.Visible = true
                end
                
                if isValidToolFormat(tool.Name) then
                    validityLabel.Text = "Status: Valid format - Ready to load"
                    validityLabel.TextColor3 = Color3.fromRGB(180, 255, 180)
                    loadBtn.Active = not isLoading
                    loadBtn.BackgroundColor3 = isLoading and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(100, 180, 255)
                else
                    validityLabel.Text = "Status: Invalid format - Not supported"
                    validityLabel.TextColor3 = Color3.fromRGB(255, 180, 180)
                    loadBtn.Active = false
                    loadBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                end
            else
                toolInfo.Text = "Equipped Tool: [None]"
                validityLabel.Text = "Status: No tool equipped"
                validityLabel.TextColor3 = Color3.fromRGB(255, 180, 180)
                trackerInfo.Visible = false
                loadBtn.Active = false
                loadBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            end
            
            updateTrackedItemsDisplay()
        end
        
        loadBtn.MouseButton1Click:Connect(function()
            if isLoading then
                -- Stop loading
                isLoading = false
                
                -- Stop increment connection
                if incrementConnection then
                    incrementConnection:Disconnect()
                    incrementConnection = nil
                end
                
                -- Stop global tracking
                stopGlobalTracking()
                
                -- Clear all tracked items
                for baseName, tracker in pairs(visualTracker) do
                    tracker.isActive = false
                end
                
                loadBtn.Text = "Load Infinite"
                loadBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
                validityLabel.Text = "Status: Stopped - All tracking disabled"
            else
                -- Start loading
                local tool = getEquippedTool()
                if tool and isValidToolFormat(tool.Name) then
                    validityLabel.Text = "Status: Starting initialization..."
                    loadBtn.Active = false
                    
                    task.spawn(function()
                        -- Initialize tracking for current tool
                        local baseName = getToolBaseName(tool.Name)
                        local initialValue = extractToolValue(tool.Name)
                        
                        -- Add to visual tracker with initial bonus
                        addToVisualTracker(tool.Name, initialValue, 0)
                        
                        -- Start global tracking system
                        startGlobalTracking()
                        
                        isLoading = true
                        loadBtn.Text = "Stop Loading"
                        loadBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
                        loadBtn.Active = true
                        validityLabel.Text = "Status: Active - Global tracking enabled"
                        
                        -- Start increment loop (adds +1 every 0.3 seconds to tracked items)
                        incrementConnection = task.spawn(function()
                            while isLoading do
                                -- Increment bonus for all active tracked items
                                for baseName, tracker in pairs(visualTracker) do
                                    if tracker.isActive then
                                        updateVisualBonus(tracker.toolName, 1)
                                    end
                                end
                                
                                task.wait(0.3) -- Wait 0.3 seconds before next increment
                            end
                        end)
                    end)
                end
            end
        end)
        
        -- Auto-detect and track new valid tools
        local function autoTrackNewTools()
            local character = player.Character
            if not character then return end
            
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and isValidToolFormat(tool.Name) then
                        local baseName = getToolBaseName(tool.Name)
                        if not visualTracker[baseName] then
                            local initialValue = extractToolValue(tool.Name)
                            addToVisualTracker(tool.Name, initialValue, 0)
                        end
                    end
                end
            end
        end
        
        -- Run tool info updates and auto-tracking
        RunService.Heartbeat:Connect(function()
            updateToolInfo()
            if isLoading then
                autoTrackNewTools()
            end
        end)
    
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

closeButton.MouseButton1Click:Connect(function()
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
    TweenService:Create(mainWindow, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    TweenService:Create(titleBar, tweenInfo, {BackgroundTransparency = 1}):Play()
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

local function initializeAfterSetup()
    if mainBorder then
        local pulseTween = TweenService:Create(
            mainBorder,
            TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Color = Color3.fromRGB(140, 180, 255)}
        )
        pulseTween:Play()
    end

    task.spawn(function()
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
            firstTabStatusLabel.Text = #eggs == 0 and "No eggs found nearby" or "Found "..#eggs.." eggs nearby"
        end
    end)
end

task.spawn(initializeAfterSetup)
