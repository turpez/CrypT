-- features/Notifications.lua
local M = {}
M.__index = M

function M:Init(Window, Discord, Library, Options, Toggles)
    self.Discord = Discord
    self.Library = Library
    self.Options = Options
    self.Toggles = Toggles

    -- Onglet
    local NotifTab = Window:AddTab({ Name = "Notifications", Icon = "bell", Description = "Alertes & Webhooks Discord" })

    -- Colonne gauche : Webhook
    local WebhookLeft = NotifTab:AddLeftGroupbox("Webhook Discord")

    WebhookLeft:AddToggle("webhook_enabled", {
        Text = "Activer l'envoi via Webhook",
        Default = false
    })

    WebhookLeft:AddInput("webhook_url", {
        Text = "URL du Webhook",
        Placeholder = "https://discord.com/api/webhooks/..."
    })

    WebhookLeft:AddInput("webhook_ping", {
        Text = "ID à ping (optionnel)",
        Placeholder = "Ex: 987654321098765432"
    })

    WebhookLeft:AddButton("📡 Envoyer un message test", function()
        self.Discord:SendTest(Options.webhook_url.Value, Options.webhook_ping.Value)
    end)

    -- Colonne droite : Alertes automatiques
    local WebhookRight = NotifTab:AddRightGroupbox("Alertes automatiques")

    WebhookRight:AddToggle("alert_drop", {
        Text = "Notifier les nouveaux drops",
        Default = true
    })

    WebhookRight:AddToggle("alert_boss", {
        Text = "Notifier l'apparition d'un boss",
        Default = false
    })

    WebhookRight:AddToggle("alert_death", {
        Text = "Notifier la mort du joueur",
        Default = false
    })

    WebhookRight:AddToggle("alert_kick", {
        Text = "Notifier quand je suis kick",
        Default = true
    })

    WebhookRight:AddLabel("Toutes les alertes partent vers ton webhook configuré.")

    -- Hook global : envoi automatique après kick (si activé)
    local GuiService = game:GetService("GuiService")
    local Players = game:GetService("Players")
    local MarketplaceService = game:GetService("MarketplaceService")

    GuiService.ErrorMessageChanged:Connect(function(msg)
        if not Toggles.webhook_enabled.Value then return end
        if not Toggles.alert_kick.Value then return end
        local url = Options.webhook_url.Value
        if type(url) ~= "string" or url == "" then return end

        local LocalPlayer = Players.LocalPlayer
        local ok, gameInfo = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        local gameName = ok and gameInfo.Name or ("Place "..game.PlaceId)

        self.Discord:Send(url, {
            content = (Options.webhook_ping.Value ~= "" and ("<@"..Options.webhook_ping.Value..">") or nil),
            embeds = {{
                title = "🚫 Vous avez été kick",
                description = (msg ~= "" and ("**Raison :** "..msg) or "Raison inconnue"),
                color = 0xFF0000,
                fields = {
                    { name = "Utilisateur", value = string.format("||[%s](https://www.roblox.com/users/%d)||", LocalPlayer.Name, LocalPlayer.UserId), inline = true },
                    { name = "Jeu", value = string.format("[%s](https://www.roblox.com/games/%d)", gameName, game.PlaceId), inline = true },
                }
            }}
        })
    end)
end

return setmetatable({}, M)
