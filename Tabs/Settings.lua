local SettingsTab = Window:AddTab({
    Name = "Paramètres",
    Icon = "sliders",
    Description = "Thèmes et sauvegardes"
})

local Left = SettingsTab:AddLeftGroupbox("Thèmes")
ThemeManager:ApplyToTab(SettingsTab)

local Right = SettingsTab:AddRightGroupbox("Sauvegarde")
SaveManager:BuildConfigSection(SettingsTab)
