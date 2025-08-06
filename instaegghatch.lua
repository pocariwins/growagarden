local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

local function loadWait()
    while not LocalPlayer:GetAttribute("Finished_Loading") do task.wait() end
    while not LocalPlayer:GetAttribute("DataFullyLoaded") do task.wait() end
    while not LocalPlayer:GetAttribute("Setup_Finished") do task.wait() end
    ReplicatedStorage.GameEvents.Finish_Loading:FireServer()
    ReplicatedStorage.GameEvents.LoadScreenEvent:FireServer(LocalPlayer)
    while not LocalPlayer:GetAttribute("Loading_Screen_Finished") do task.wait() end
    task.wait(1)
end

if LocalPlayer:GetAttribute("Loading_Screen_Finished") then
    ReplicatedStorage.GameEvents.Finish_Loading:FireServer()
    ReplicatedStorage.GameEvents.LoadScreenEvent:FireServer(LocalPlayer)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/FischMain"))()
else
    loadWait()
end

local queue = (queueonteleport or queue_on_teleport or syn and syn.queue_on_teleport)
if queue then
    queue([[
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/FischMain"))()
    ]])
end

CoreGui:WaitForChild("RobloxPromptGui", 10)
CoreGui.RobloxPromptGui:WaitForChild("promptOverlay", 10).ChildAdded:Connect(function(child)
    if child.Name == "ErrorPrompt" then
        task.wait(2)
        TeleportService:Teleport(PlaceId, LocalPlayer)
    end
end)

while true do
    local startTime = tick()
    while tick() - startTime < 55 do task.wait(1) end
    TeleportService:Teleport(PlaceId, LocalPlayer)
end
