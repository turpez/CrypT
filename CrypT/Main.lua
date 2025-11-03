-- 🔥 CrypT Hub - Version Modulaire Pro
if not isfolder("CrypT") then makefolder("CrypT") end
if not isfolder("CrypT/Tabs") then makefolder("CrypT/Tabs") end
if not isfolder("CrypT/Libs") then makefolder("CrypT/Libs") end
if not isfolder("CrypT/Assets") then makefolder("CrypT/Assets") end

-- 📦 Chargement de la librairie Obsidian
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Neuublue/Obsidian/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Neuublue/Obsidian/main/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet("https://raw.githubusercontent.com/Neuublue/Obsidian/main/SaveManager.lua"))()

-- 🪟 Fenêtre principale
local Window = Library:CreateWindow({
    Title = "CrypT Hub",
    Center = true,
    AutoShow = true
})

-- 🖼️ Chargement des assets visuels (logo, banner, etc.)
local AssetsFolder = "CrypT/Assets/"
if not isfolder(AssetsFolder) then makefolder(AssetsFolder) end

local function addImageIfExists(title, fileName, size, pos)
    local path = AssetsFolder .. fileName
    if isfile(path) then
        Window:AddImage({
            Title = title,
            Image = getcustomasset(path),
            Size = size,
            Position = pos
        })
    end
end

addImageIfExists("CrypT Banner", "banner.png", UDim2.new(1, -20, 0, 100), UDim2.new(0, 10, 0, 10))
addImageIfExists("CrypT Logo", "logo.png", UDim2.new(0, 64, 0, 64), UDim2.new(0, 10, 0, 120))

-- ⚙️ Fonction de chargement dynamique des onglets
local function loadTab(tabName)
    local path = "CrypT/Tabs/" .. tabName .. ".lua"
    if not isfile(path) then return end

    local source = readfile(path)
    local func, err = loadstring(source)
    if not func then return end

    setfenv(func, getfenv()) -- partage l’environnement global (Library, Window, etc.)
    pcall(func)
end

-- 🧩 Liste des onglets à charger
local tabs = { "Notifications", "Farm", "Combat", "Misc", "Settings" }

for _, t in ipairs(tabs) do
    loadTab(t)
end

-- 🎨 Configuration du ThemeManager & SaveManager
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
ThemeManager:SetFolder("CrypT")
SaveManager:SetFolder("CrypT")

SaveManager:BuildConfigSection(Window)
ThemeManager:ApplyToTab(Window)

Library:Notify("✅ CrypT chargé avec succès", 4)
