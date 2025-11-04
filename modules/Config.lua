--[[
    CrypT Hub - Config.lua
    Auteur : Turpez
    Description : Gère la configuration, les sauvegardes et les paramètres du hub.
--]]

local M = {}

function M.init(ctx)
    local HttpService = ctx.Services.HttpService

    -- ✅ Configuration par défaut
    M.Settings = {
        Version = "1.0.0",
        AutofarmSpeed = 300,
        AutofarmRadius = 20000,
        KillauraRange = 1500,
        WebhookURL = "",
        AutoSwing = true,
    }

    -- ✅ Vérifie et crée le dossier si l'exploit supporte les fonctions de fichiers
    if makefolder and not isfolder("CrypT") then
        pcall(function()
            makefolder("CrypT")
        end)
    end

    -- ✅ Sauvegarde de la configuration dans un fichier JSON
    function M.Save()
        if not (writefile and HttpService and isfolder and isfolder("CrypT")) then return end
        local data = HttpService:JSONEncode(M.Settings)
        pcall(function()
            writefile("CrypT/Config.json", data)
        end)
    end

    -- ✅ Chargement de la configuration depuis un fichier
    function M.Load()
        if not (isfile and readfile and isfile("CrypT/Config.json")) then return end
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile("CrypT/Config.json"))
        end)
        if success and type(data) == "table" then
            for k, v in pairs(data) do
                M.Settings[k] = v
            end
        end
    end

    -- ✅ Réinitialisation aux valeurs par défaut
    function M.Reset()
        M.Settings = {
            Version = "1.0.0",
            AutofarmSpeed = 300,
            AutofarmRadius = 20000,
            KillauraRange = 1500,
            WebhookURL = "",
            AutoSwing = true,
        }
        M.Save()
    end

    -- ✅ Fonction d’affichage dans la console
    function M.PrintSettings()
        print("[CrypT Config] ⚙️ Configuration actuelle :")
        for k, v in pairs(M.Settings) do
            print("  • " .. k .. " = " .. tostring(v))
        end
    end

    -- ✅ Chargement automatique à l’initialisation
    M.Load()
    print("[CrypT Config] ✅ Configuration chargée.")

    -- Ajout de Config au contexte global
    ctx.Config = M
end

return M
