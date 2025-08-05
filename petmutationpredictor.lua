local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Loading Screen GUI
local loadingScreen = Instance.new("ScreenGui")
loadingScreen.Name = "LoadingScreen"
loadingScreen.IgnoreGuiInset = true
loadingScreen.ResetOnSpawn = false

local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
background.ZIndex = 10
background.Parent = loadingScreen

local progressBarOuter = Instance.new("Frame")
progressBarOuter.Size = UDim2.new(0.7, 0, 0.05, 0)
progressBarOuter.Position = UDim2.new(0.15, 0, 0.5, 0)
progressBarOuter.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
progressBarOuter.BorderSizePixel = 0
progressBarOuter.ZIndex = 11
progressBarOuter.Parent = background

local progressBarInner = Instance.new("Frame")
progressBarInner.Size = UDim2.new(0, 0, 1, 0)
progressBarInner.BackgroundColor3 = Color3.new(0.2, 0.6, 1)
progressBarInner.BorderSizePixel = 0
progressBarInner.ZIndex = 12
progressBarInner.Parent = progressBarOuter

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0.1, 0)
loadingText.Position = UDim2.new(0, 0, 0.4, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading Mutation Roller..."
loadingText.TextColor3 = Color3.new(1, 1, 1)
loadingText.TextSize = 24
loadingText.ZIndex = 11
loadingText.Font = Enum.Font.GothamBold
loadingText.Parent = background

loadingScreen.Parent = playerGui

-- Animate loading bar for 60 seconds
local tweenInfo = TweenInfo.new(60, Enum.EasingStyle.Linear)
local tween = TweenService:Create(progressBarInner, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
tween:Play()
task.wait(60)
loadingScreen:Destroy()

-- Main GUI
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "MutationRollerGUI"
mainGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.4, 0, 0.6, 0)
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = mainGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.15, 0)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.4)
title.Text = "MUTATION ROLLER SETUP"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local instructions = Instance.new("TextLabel")
instructions.Size = UDim2.new(0.9, 0, 0.4, 0)
instructions.Position = UDim2.new(0.05, 0, 0.2, 0)
instructions.BackgroundTransparency = 1
instructions.Text = "REQUIRED CHANGES:\n\n1. Set your desired mutation in the code\n   (Current: \"Rainbow\")\n\n2. Add your Discord webhook URL\n   (Current: \"YOUR_WEBHOOK_URL_HERE\")\n\n"
instructions.TextColor3 = Color3.new(1, 1, 1)
instructions.TextSize = 18
instructions.TextXAlignment = Enum.TextXAlignment.Left
instructions.Font = Enum.Font.Gotham
instructions.Parent = mainFrame

local warning = Instance.new("TextLabel")
warning.Size = UDim2.new(0.9, 0, 0.15, 0)
warning.Position = UDim2.new(0.05, 0, 0.6, 0)
warning.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
warning.Text = "WARNING: Mutation names are CASE SENSITIVE!\nMake sure to use exact spelling and capitalization."
warning.TextColor3 = Color3.new(1, 1, 1)
warning.TextSize = 16
warning.Font = Enum.Font.GothamBold
warning.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.4, 0, 0.15, 0)
closeButton.Position = UDim2.new(0.3, 0, 0.8, 0)
closeButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.5)
closeButton.Text = "START SCRIPT"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.Gotham
closeButton.Parent = mainFrame

-- Highlight the important parts in the instructions
local mutationHighlight = Instance.new("TextLabel")
mutationHighlight.Size = UDim2.new(0.45, 0, 0.07, 0)
mutationHighlight.Position = UDim2.new(0.25, 0, 0.32, 0)
mutationHighlight.BackgroundColor3 = Color3.new(0.3, 0.2, 0)
mutationHighlight.BorderSizePixel = 0
mutationHighlight.ZIndex = -1
mutationHighlight.Text = ""
mutationHighlight.Parent = instructions

local webhookHighlight = Instance.new("TextLabel")
webhookHighlight.Size = UDim2.new(0.5, 0, 0.07, 0)
webhookHighlight.Position = UDim2.new(0.25, 0, 0.45, 0)
webhookHighlight.BackgroundColor3 = Color3.new(0.3, 0.2, 0)
webhookHighlight.BorderSizePixel = 0
webhookHighlight.ZIndex = -1
webhookHighlight.Text = ""
webhookHighlight.Parent = instructions

mainGui.Parent = playerGui

-- Handle button click
closeButton.MouseButton1Click:Connect(function()
    mainGui:Destroy()
    
    -- Original script with modifications
    local replicated_storage = game:GetService("ReplicatedStorage")
    local teleport_service = game:GetService("TeleportService")
    local players = game:GetService("Players")
    local workspace = game:GetService("Workspace")
    local http_service = game:GetService("HttpService")

    -- THIS IS WHAT YOU CHANGE (Highlighted in GUI)
    local mutation_wanted = "Rainbow" -- Replace with the desired mutation (found in line 31)
    local webhook_url = "YOUR_WEBHOOK_URL_HERE" -- Here is your webhook, if you wish to add one.
    --

    local localplayer = players.LocalPlayer
    local cam = workspace.CurrentCamera
    local remote = replicated_storage.GameEvents.PetMutationMachineService_RE

    local function wait_for_load()
        while not localplayer:GetAttribute("Finished_Loading") do task.wait() end
        while not localplayer:GetAttribute("DataFullyLoaded") do task.wait() end
        while not localplayer:GetAttribute("Setup_Finished") do task.wait() end
        replicated_storage.GameEvents.Finish_Loading:FireServer()
        replicated_storage.GameEvents.LoadScreenEvent:FireServer(localplayer)
        while not localplayer:GetAttribute("Loading_Screen_Finished") do task.wait() end
        task.wait(1)
    end

    if not localplayer:GetAttribute("Loading_Screen_Finished") then
        wait_for_load()
    end

    local all_mutations = {
        "Shiny", "Inverted", "Frozen", "Windy", "Mega", "Tiny", "Golden",
        "Ironskin", "Rainbow", "Shocked", "Radiant", "Ascended"
    }

    local function send_hook(mutation)
        if not webhook_url or webhook_url == "YOUR_WEBHOOK_URL_HERE" then return end

        local data = {
            username = "toes hub",
            avatar_url = "https://cdn.discordapp.com/attachments/1390989755327578163/1402302319269253251/74f64afff9748d2c64d01b021ffcf288.jpg",
            embeds = {{
                title = "**🧬 Mutation Rolled 🧬**",
                description = string.format("🎲 **Mutation:** `%s`", mutation),
                type = "rich",
                color = 0x9b59b6,
                footer = {
                    text = "Auto Reroll",
                    icon_url = "https://cdn.discordapp.com/attachments/1390989755327578163/1402302319269253251/74f64afff9748d2c64d01b021ffcf288.jpg"
                },
            }}
        }
        
        local payload = {
            Url = webhook_url,
            Body = http_service:JSONEncode(data),
            Method = "POST",
            Headers = {["content-type"] = "application/json"}
        }
        
        pcall(function()
            local req = http_request or request or HttpPost or (syn and syn.request)
            if req then req(payload) end
        end)
    end

    local function check_pet(pet)
        if pet:IsA("Model") and pet.Parent == cam then
            local start = tick()
            local time_limit = 0.2
            local found_mutation = nil

            while tick() - start < time_limit do
                for _, name in ipairs(all_mutations) do
                    if pet:GetAttribute(name) == true then
                        found_mutation = name
                        break
                    end
                end
                if found_mutation then break end
                task.wait()
            end
            
            if found_mutation == mutation_wanted then
                send_hook(found_mutation)
                return true 
            else
                teleport_service:Teleport(game.PlaceId, localplayer)
                return false
            end
        end
        return false
    end

    local conn
    conn = cam.DescendantAdded:Connect(function(child)
        if check_pet(child) then
            conn:Disconnect()
        end
    end)

    remote:FireServer("ClaimMutatedPet")
end)
