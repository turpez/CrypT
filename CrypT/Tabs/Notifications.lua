local NotifTab = Window:AddTab({
    Name = "Notifications",
    Icon = "bell",
    Description = "Alertes et Webhooks Discord"
})

local WebhookLeft = NotifTab:AddLeftGroupbox("Webhook Discord")

WebhookLeft:AddInput("WebhookURL", {
    Text = "URL du Webhook",
    Placeholder = "https://discord.com/api/webhooks/..."
})

WebhookLeft:AddInput("WebhookPing", {
    Text = "ID à ping (optionnel)",
    Placeholder = "Ex: 987654321098765432"
})

WebhookLeft:AddButton("📡 Envoyer un message test", function()
    local HttpService = game:GetService("HttpService")
    local url = Options.WebhookURL.Value
    local ping = Options.WebhookPing.Value

    if not url or url == "" then
        Library:Notify("⚠️ Aucun webhook configuré.", 4)
        return
    end

    local body = {
        content = ping ~= "" and ("<@" .. ping .. ">") or nil,
        embeds = {{
            title = "✅ Test CrypT",
            description = "Les notifications Discord fonctionnent parfaitement !",
            color = 0x00FFFF,
            footer = { text = "CrypT Notifications" }
        }}
    }

    request({
        Url = url,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode(body)
    })

    Library:Notify("✅ Message de test envoyé avec succès !", 4)
end)

local WebhookRight = NotifTab:AddRightGroupbox("Alertes automatiques")

WebhookRight:AddToggle("AlertDrop", { Text = "Notifier les nouveaux drops", Default = true })
WebhookRight:AddToggle("AlertBoss", { Text = "Notifier l'apparition d'un boss", Default = false })
WebhookRight:AddToggle("AlertDeath", { Text = "Notifier la mort du joueur", Default = false })
WebhookRight:AddToggle("AlertAutoKick", { Text = "Notifier après un Autokick", Default = true })
WebhookRight:AddLabel("Toutes les alertes sont envoyées sur ton webhook configuré.")
