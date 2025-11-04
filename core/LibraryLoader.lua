-- core/LibraryLoader.lua
-- Charge la lib Obsidian et crée la fenêtre + expose Library/Window

local UIRepo = 'https://raw.githubusercontent.com/Neuublue/Obsidian/main/'
local Library = loadstring(game:HttpGet(UIRepo .. 'Library.lua'))()

local lastUpdated = (function()
    local ok, dt = pcall(function()
        -- Valeur informative (facultative)
        return DateTime.now():FormatLocalTime('L LT', 'fr-fr')
    end)
    return ok and dt or 'unknown'
end)()

local Window = Library:CreateWindow({
    Title = 'CrypT',
    Footer = 'Swordburst 2 | CrypT Hub | Updated ' .. lastUpdated,
    Center = true,
    AutoShow = true,
    ToggleKeybind = Enum.KeyCode.End,
    NotifySide = 'Left',
    ShowCustomCursor = false,
    CornerRadius = 0,
    Icon = 98255933738244,
    Resizable = true,
    MobileButtonsSide = 'Right',
    Size = UDim2.fromOffset(700, 500)
})

-- Thèmes & Sauvegardes (utilise les addons Obsidian)
local ThemeManager = loadstring(game:HttpGet(UIRepo .. 'addons/ThemeManager.lua'))()
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder('CrypT/Swordburst 2')

local SaveManager = loadstring(game:HttpGet(UIRepo .. 'addons/SaveManager.lua'))()
SaveManager:SetLibrary(Library)
SaveManager:SetFolder('CrypT/Swordburst 2')
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Window:AddTab('Settings', 'settings'))
SaveManager:LoadAutoloadConfig()

return {
    Library = Library,
    Window = Window
}
