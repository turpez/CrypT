local FarmTab = Window:AddTab({
    Name = "Farm",
    Icon = "tractor",
    Description = "Automatisation des récoltes"
})

local Left = FarmTab:AddLeftGroupbox("Autofarm")
Left:AddToggle("AutoFarm", { Text = "Activer l’Autofarm", Default = false })
Left:AddSlider("FarmRange", { Text = "Rayon de détection", Min = 10, Max = 100, Default = 50, Rounding = 0 })

local Right = FarmTab:AddRightGroupbox("Drops")
Right:AddToggle("AutoCollect", { Text = "Ramasser automatiquement les drops", Default = true })
Right:AddLabel("Les items seront collectés instantanément dans ton inventaire.")
