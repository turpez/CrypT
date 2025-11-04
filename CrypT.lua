-- CrypT — Swordburst 2 (loader modulaire)
if getgenv().CrypT then return end
getgenv().CrypT = true

-- Sécurité : attendre le chargement complet
if not game:IsLoaded() then game.Loaded:Wait() end

-- Jeu ciblé : Swordburst 2
if game.GameId ~= 212154879 then return end

-- Helpers pour charger des fichiers locaux
local ROOT = "CrypT_Swordburst2"
local function rf(p) return ROOT.."/"..p end
local function require_local(path)
    if isfile(rf(path)) then
        return loadstring(readfile(rf(path)))()
    else
        error("Fichier introuvable: "..rf(path))
    end
end

-- Charger le cœur (Librairie + fenêtre + objets partagés)
local Core = require_local("core/LibraryLoader.lua")
local Library = Core.Library
local Window = Core.Window
local Options = Library.Options
local Toggles = Library.Toggles

-- Charger Discord utils (webhooks)
local Discord = require_local("core/Discord.lua")
Discord:Bind(Library, Options, Toggles)

-- Onglet Notifications (UI + logique + hooks sur kick)
local Notifications = require_local("features/Notifications.lua")
Notifications:Init(Window, Discord, Library, Options, Toggles)

-- Modération / Autokick / Panic (et envoi Webhook après kick)
local Moderation = require_local("features/Moderation.lua")
Moderation:Init(Window, Discord, Library, Options, Toggles)

-- Tu peux charger d’autres features ici :
-- require_local("features/Autofarm.lua") -- exemple

Library:Notify("CrypT pack modulaire chargé ✅", 4)
