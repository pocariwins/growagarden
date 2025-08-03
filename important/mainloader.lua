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

-- FIX: Ensure player is properly initialized
if not player then
    player = Players:WaitForChild("LocalPlayer")
end

local rareChancePercentage = 1

-- [Keep all your pet tables and functions here - SAME AS ORIGINAL]

-- ADD MISSING FUNCTION: randomizeAnimation
local function randomizeAnimation(button, options, duration, callback)
    local startTime = os.clock()
    local endTime = startTime + duration
    local originalText = button.Text
    while os.clock() < endTime do
        button.Text = options[math.random(1, #options)]
        task.wait(0.05)
    end
    button.Text = originalText
    if callback then
        callback()
    end
end

-- [Keep all your GUI creation code here - SAME AS ORIGINAL]

-- FIX: Use TweenService directly instead of tweenService
local pulseTween = TweenService:Create(
    mainBorder,
    TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Color = Color3.fromRGB(140, 180, 255)}
)
pulseTween:Play()

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

-- FIX: Proper parenting with safety check
if player then
    local playerGui = player:WaitForChild("PlayerGui")
    gui.Parent = playerGui
else
    warn("Player not found! GUI cannot be parented.")
end
