-- features/Moderation.lua
-- Détection des modérateurs + Autokick + Panic
local M = {}
M.__index = M

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- Extrait minimal d'une liste (tu peux l'étendre)
local mods = {
    12671, 4402987, 7858636, 13444058, 24156180, 35311411, 38559058, 45035796,
    48662268, 50879012, 51696441, 55715138, 57436909, 59341698, 60673083
}

function M:Init(Window, Discord, Library, Options, Toggles)
    self.Discord = Discord
    self.Library = Library
    self.Options = Options
    self.Toggles = Toggles

    local Tab = Window:AddTab("Moderation", "shield")
    local Box = Tab:AddLeftGroupbox("Mods")

    Box:AddToggle('Autokick', { Text = 'Autokick' })
    Box:AddSlider('KickDelay', { Text = 'Kick delay', Default = 30, Min = 0, Max = 60, Rounding = 0, Suffix = 's', Compact = true })
    Box:AddToggle('Autopanic', { Text = 'Autopanic' })
    Box:AddSlider('PanicDelay', { Text = 'Panic delay', Default = 15, Min = 0, Max = 60, Rounding = 0, Suffix = 's', Compact = true })

    local function modCheck(player, leaving)
        if player == Players.LocalPlayer or not table.find(mods, player.UserId) then return end
        self.Library:Notify(string.format("Mod %s %s ta partie à %s", player.Name, (leaving and "quitte" or "rejoint"), os.date("%I:%M:%S %p")), 60)
        if leaving then return end

        StarterGui:SetCore('PromptBlockPlayer', player)

        task.delay(Options.KickDelay.Value, function()
            if Toggles.Autokick.Value then
                Players.LocalPlayer:Kick(string.format("\n\n%s joined at %s\n", player.Name, os.date("%I:%M:%S %p")))
            end
        end)

        task.delay(Options.PanicDelay.Value, function()
            if Toggles.Autopanic.Value then
                if Toggles.Killaura and Toggles.Killaura.Value then Toggles.Killaura:SetValue(false) end
                local RS = game:GetService("ReplicatedStorage")
                local Event = RS:FindFirstChild("Event")
                if Event then pcall(function() Event:FireServer('Checkpoints', { 'TeleportToSpawn' }) end) end
            end
        end)
    end

    for _, p in ipairs(Players:GetPlayers()) do task.spawn(modCheck, p) end
    Players.PlayerAdded:Connect(modCheck)
    Players.PlayerRemoving:Connect(function(p) modCheck(p, true) end)
end

return setmetatable({}, M)
