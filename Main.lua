--[[
    CrypT Hub Loader - Main.lua
    Auteur : Turpez
    Description : Charge automatiquement tous les modules depuis GitHub.
--]]

if getgenv().CrypT then return end
getgenv().CrypT = true

local BASE_URL = "https://raw.githubusercontent.com/turpez/CrypT/refs/heads/main/modules/"

-- Fonction utilitaire pour charger les modules depuis GitHub
local function fetchModule(name)
    local url = BASE_URL .. name .. ".lua"
    local ok, res = pcall(game.HttpGet, game, url)
    if not ok then
        warn("❌ Impossible de récupérer le module " .. name .. " : " .. tostring(res))
        return nil
    end

    local fn, err = loadstring(res)
    if not fn then
        warn("❌ Erreur lors du chargement du module " .. name .. " : " .. tostring(err))
        return nil
    end

    local success, mod = pcall(fn)
    if not success then
        warn("❌ Erreur lors de l’exécution du module " .. name .. " : " .. tostring(mod))
        return nil
    end

    return mod
end

-- Initialisation des services Roblox
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() and Players.LocalPlayer
local Event = ReplicatedStorage:WaitForChild("Event")
local Function = ReplicatedStorage:WaitForChild("Function")

-- Contexte partagé
local ctx = {
    Services = {
        ReplicatedStorage = ReplicatedStorage,
        Players = Players,
        Event = Event,
        Function = Function,
        MarketplaceService = game:GetService("MarketplaceService"),
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        HttpService = game:GetService("HttpService"),
        Workspace = game:GetService("Workspace"),
    },
    Globals = {
        LocalPlayer = LocalPlayer,
    },
    Modules = {},
}

-- Ordre de chargement des modules
local moduleOrder = {
    "Config",
    "Utils",
    "Webhook",
    "UI",
    "AutoFarm",
    "Killaura"
}

print("[CrypT] 🚀 Chargement des modules...")

for _, name in ipairs(moduleOrder) do
    local mod = fetchModule(name)
    if mod then
        if type(mod) == "table" and type(mod.init) == "function" then
            local ok, err = pcall(function()
                mod.init(ctx)
            end)
            if not ok then
                warn("⚠️ Erreur d’initialisation du module " .. name .. " : " .. tostring(err))
            end
        end
        ctx.Modules[name] = mod
        print("[CrypT] ✅ Module chargé :", name)
    else
        warn("[CrypT] ⚠️ Module non chargé :", name)
    end
end

-- Exposition globale
getgenv().CrypT_ctx = ctx

print("[CrypT] 🎯 Tous les modules ont été chargés avec succès !")
print("[CrypT] 🧩 Modules disponibles :", table.concat((function()
    local t = {}
    for k, _ in pairs(ctx.Modules) do
        table.insert(t, k)
    end
    return t
end)(), ", "))

