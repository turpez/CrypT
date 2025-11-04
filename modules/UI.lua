--[[
    CrypT Hub - UI.lua
    Auteur : Turpez
    Description : Interface utilisateur principale du hub CrypT (tabs, toggles, sliders, webhooks, etc.)
--]]

local M = {}

function M.init(ctx)
    local UIRepo = "https://raw.githubusercontent.com/Neuublue/Obsidian/main/"
    local Library = loadstring(game:HttpGet(UIRepo .. "Library.lua"))()
    local SaveManager = loadstring(game:HttpGet(UIRepo .. "SaveManager.lua"))()
    local ThemeManager = loadstring(game:HttpGet(UIRepo .. "ThemeManager.lua"))()

    ctx.Library = Library
    ctx.SaveManager = SaveManager
    ctx.ThemeManager = ThemeManager

    local Window = Library:CreateWindow({
        Title = "CrypT",
        Footer = "Swordburst 2 | CrypT Hub",
        Center = true,
        AutoShow = true,
        Size = UDim2.fromOffset(700, 500)
    })

    ctx.Window = Window

    -- Tabs
    local Main = Window:AddTab("Main", "user")
    local Misc = Window:AddTab("Misc", "list")
    local Settings = Window:AddTab("Settings", "settings")

    ------------------------------------------------------------------------
    -- 🗡️ Autofarm Tab
    ------------------------------------------------------------------------
    local Farming = Main:AddLeftTabbox()
    local Autofarm = Farming:AddTab("Autofarm")

    Autofarm:AddToggle("Autofarm", { Text = "Autofarm activé" })
    Autofarm:AddSlider("AutofarmSpeed", { Text = "Vitesse", Default = ctx.Config.Settings.AutofarmSpeed, Min = 0, Max = 300, Rounding = 0 })
    Autofarm:AddSlider("AutofarmRadius", { Text = "Rayon", Default = ctx.Config.Settings.AutofarmRadius, Min = 0, Max = 20000, Rounding = 0 })

    ------------------------------------------------------------------------
    -- ⚔️ Combat Tab
    ------------------------------------------------------------------------
    local Combat = Farming:AddTab("Combat")

    Combat:AddToggle("Killaura", { Text = "Killaura activée" })
    Combat:AddSlider("KillauraRange", { Text = "Portée", Default = ctx.Config.Settings.KillauraRange, Min = 0, Max = 2000 })
    Combat:AddToggle("KillauraSkills", { Text = "Activer les Skills" })
    Combat:AddToggle("KillauraSwing", { Text = "Animations d'attaque" })

    ------------------------------------------------------------------------
    -- 🧰 Autres Fonctions
    ------------------------------------------------------------------------
    local MiscBox = Main:AddRightTabbox()
    local MiscTab = MiscBox:AddTab("Divers")

    MiscTab:AddToggle("AutoSwing", { Text = "Auto Swing" })
    MiscTab:AddButton("Réinitialiser configuration", function()
        ctx.Config.Reset()
        Library:Notify("Configuration réinitialisée avec succès !")
    end)

    ------------------------------------------------------------------------
    -- 🌐 Webhook
    ------------------------------------------------------------------------
    local WebhookTab = MiscBox:AddTab("Webhook")

    WebhookTab:AddInput("WebhookURL", { Text = "Lien du Webhook Discord", Default = ctx.Config.Settings.WebhookURL, Placeholder = "https://discord.com/api/webhooks/..." })
    WebhookTab:AddInput("WebhookPing", { Text = "Ping utilisateur (ID Discord)" })
    WebhookTab:AddButton("Envoyer un message de test", function()
        local url = ctx.Options.WebhookURL and ctx.Options.WebhookURL.Value or ""
        if url == "" then
            Library:Notify("⚠️ Aucun webhook configuré.")
            return
        end
        ctx.Webhook.sendTestMessage(url)
        Library:Notify("✅ Message de test envoyé.")
    end)

    ------------------------------------------------------------------------
    -- ⚙️ Paramètres / Thèmes
    ------------------------------------------------------------------------
    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)

    SaveManager:IgnoreThemeSettings()
    SaveManager:SetFolder("CrypT")
    ThemeManager:SetFolder("CrypT")

    SaveManager:BuildConfigSection(Settings)
    ThemeManager:ApplyToTab(Settings)

    ------------------------------------------------------------------------
    -- 🔄 Sauvegarde automatique des sliders et inputs
    ------------------------------------------------------------------------
    task.spawn(function()
        while task.wait(10) do
            ctx.Config.Settings.AutofarmSpeed = ctx.Options.AutofarmSpeed and ctx.Options.AutofarmSpeed.Value or ctx.Config.Settings.AutofarmSpeed
            ctx.Config.Settings.AutofarmRadius = ctx.Options.AutofarmRadius and ctx.Options.AutofarmRadius.Value or ctx.Config.Settings.AutofarmRadius
            ctx.Config.Settings.KillauraRange = ctx.Options.KillauraRange and ctx.Options.KillauraRange.Value or ctx.Config.Settings.KillauraRange
            ctx.Config.Settings.WebhookURL = ctx.Options.WebhookURL and ctx.Options.WebhookURL.Value or ctx.Config.Settings.WebhookURL
            ctx.Config.Save()
        end
    end)

    ------------------------------------------------------------------------
    -- 💬 Message console
    ------------------------------------------------------------------------
    print("[CrypT UI] ✅ Interface utilisateur initialisée avec succès.")

    ------------------------------------------------------------------------
    -- 🔗 Liaison globale
    ------------------------------------------------------------------------
    ctx.Options = Library.Options
    ctx.Toggles = Library.Toggles
end

return M
