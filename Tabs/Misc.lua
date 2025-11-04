local MiscTab = Window:AddTab({
    Name = "Divers",
    Icon = "settings",
    Description = "Fonctions secondaires"
})

local Left = MiscTab:AddLeftGroupbox("Client")
Left:AddToggle("AutoRejoin", { Text = "Rejoindre automatiquement après un kick", Default = false })
Left:AddToggle("HideUI", { Text = "Masquer l’interface CrypT (touche P)", Default = false })

local Right = MiscTab:AddRightGroupbox("Logs")
Right:AddButton("Afficher les logs", function()
    Library:Notify("Ouverture des logs CrypT…", 3)
end)
Right:AddLabel("Historique des événements disponible prochainement.")
