-- crypt/init.lua
local root = "crypt/"                 -- dossier racine où se trouvent tous les fichiers
local linoria_root = root .. "LinoriaLib/"

local function safe_isfile(p) return type(isfile)=="function" and isfile(p) end
local function safe_read(p)
    if type(readfile)=="function" and safe_isfile(p) then return readfile(p) end
    error("readfile/isfile missing or file not found: "..tostring(p))
end

local function load_module_from_string(content, path)
    local fn, err = loadstring(content)
    if not fn then error(("Compile error %s : %s"):format(path, err)) end
    local ok, res = pcall(fn)
    if not ok then error(("Runtime error %s : %s"):format(path, res)) end
    return res
end

local function load_module(path)
    local content = safe_read(path)
    return load_module_from_string(content, path)
end

-- 1) load Linoria Library
local libPath = linoria_root .. "Library.lua"
if not safe_isfile(libPath) then error("Missing Library.lua in LinoriaLib/") end
local Library = load_module(libPath)
if type(Library) ~= "table" then error("Library.lua must return a table (Library)") end

-- 2) try load addons (SaveManager + ThemeManager) silently
local SaveManager, ThemeManager
pcall(function() SaveManager = load_module(linoria_root .. "addons/SaveManager.lua") end)
pcall(function() ThemeManager = load_module(linoria_root .. "addons/ThemeManager.lua") end)

-- 3) optional other modules
local Drawing
pcall(function() Drawing = load_module(root .. "FakeDrawingLibrary.lua") end)

-- 4) expose globals pour compatibilité existante
getgenv().Library = Library
if SaveManager then getgenv().SaveManager = SaveManager end
if ThemeManager then getgenv().ThemeManager = ThemeManager end
if Drawing then getgenv().Drawing = Drawing end

-- 5) execute le main script Swordburst2.lua
local mainPath = root .. "Swordburst2.lua"
if not safe_isfile(mainPath) then error("Missing main file: " .. mainPath) end

local mainContent = safe_read(mainPath)
local mainFn, mainErr = loadstring(mainContent)
if not mainFn then error("Failed to compile Swordburst2.lua: " .. tostring(mainErr)) end
local ok, res = pcall(mainFn)
if not ok then error("Swordburst2.lua crashed: " .. tostring(res)) end

print("[init.lua] LinoriaLib loaded, addons loaded (si présents), Swordburst2 lancé.")
