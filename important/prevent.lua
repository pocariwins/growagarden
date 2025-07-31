local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

local function restartPlayer()
    local jobId = "a82cab16-aac9-43e5-9042-2c47de56f603"
    local placeId = game.PlaceId

    TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
end

local method3Running = false

local function startMethod3()
    if method3Running then return end
    method3Running = true

    local CoreGui = game:GetService("CoreGui")

    local function detectMenuState()
        local menuOpen = GuiService:GetGuiInset().Y > 0

        if menuOpen then
            restartPlayer()
        end
    end

    spawn(function()
        while method3Running do
            detectMenuState()
            wait(0.1)
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
