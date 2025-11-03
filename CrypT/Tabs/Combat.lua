local CombatTab = Window:AddTab({
    Name = "Combat",
    Icon = "sword",
    Description = "Outils offensifs"
})

local Left = CombatTab:AddLeftGroupbox("Killaura")
Left:AddToggle("AutoHit", { Text = "Activer la Killaura", Default = false })
Left:AddSlider("AttackSpeed", { Text = "Vitesse d’attaque", Default = 1, Min = 0.5, Max = 5, Rounding = 1 })

local Right = CombatTab:AddRightGroupbox("Dégâts")
Right:AddToggle("ShowDamage", { Text = "Afficher les dégâts à l’écran", Default = true })
Right:AddSlider("DamageOpacity", { Text = "Transparence du texte", Default = 0.8, Min = 0.1, Max = 1, Rounding = 1 })
