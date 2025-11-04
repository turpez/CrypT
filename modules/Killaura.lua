--[[
    CrypT Hub - Killaura.lua (Optimisé)
    Auteur : Turpez
    Description :
      - Attaque automatique les ennemis à portée.
      - Gère l'utilisation des skills si activé.
      - Swing visuel optionnel (animation).
      - S'appuie sur ctx.AutoFarm pour la sélection des ennemis proches.
--]]

local M = {}

function M.init(ctx)
    local RunService = ctx.Services.RunService
    local Event = ctx.Services.Event
    local Options = ctx.Options
    local Toggles = ctx.Toggles
    local Utils = ctx.Utils
    local Workspace = ctx.Services.Workspace

    local LocalPlayer = ctx.Globals.LocalPlayer

    local function getChar()
        return LocalPlayer and (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
    end

    local function getHRP()
        local char = getChar()
        return char and char:FindFirstChild("HumanoidRootPart")
    end

    local function getHumanoid()
        local char = getChar()
        return char and char:FindFirstChildOfClass("Humanoid")
    end

    local function getEnemiesInRange(center, range)
        local mobsFolder = Workspace:FindFirstChild("Mobs")
        if not mobsFolder then return {} end
        local result = {}
        for _, mob in ipairs(mobsFolder:GetChildren()) do
            if Utils.IsEnemy(mob) then
                local root = mob:FindFirstChild("HumanoidRootPart")
                if root and (root.Position - center).Magnitude <= range then
                    table.insert(result, mob)
                end
            end
        end
        return result
    end

    ------------------------------------------------------------------------
    -- SKILLS & ATTACK SYSTEM
    ------------------------------------------------------------------------

    local lastAttack = 0
    local attackDelay = 0.25

    local function attack(target)
        if not target or not target.Parent then return end
        local root = target:FindFirstChild("HumanoidRootPart")
        if not root then return end
        Event:FireServer("attack", root)
    end

    local function swing()
        if Toggles.KillauraSwing and Toggles.KillauraSwing.Value then
            Event:FireServer("swing")
        end
    end

    local function useSkill(skillName)
        if not skillName or skillName == "" then return end
        Event:FireServer("skill", skillName)
    end

    local function getAvailableSkills()
        local skills = {}
        local character = getChar()
        if not character then return skills end

        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if not backpack then return skills end

        for _, v in ipairs(backpack:GetChildren()) do
            if v:IsA("Tool") and not table.find(skills, v.Name) then
                table.insert(skills, v.Name)
            end
        end
        return skills
    end

    ------------------------------------------------------------------------
    -- Killaura LOOP
    ------------------------------------------------------------------------
    local running = false

    local function loop()
        running = true
        while running and Toggles.Killaura and Toggles.Killaura.Value do
            task.wait(0.05)
            local now = tick()
            if now - lastAttack < attackDelay then
                continue
            end

            local hrp = getHRP()
            local humanoid = getHumanoid()
            if not hrp or not humanoid or humanoid.Health <= 0 then
                continue
            end

            local range = Options.KillauraRange and Options.KillauraRange.Value or 1500
            local enemies = getEnemiesInRange(hrp.Position, range)
            if #enemies == 0 then
                continue
            end

            for _, target in ipairs(enemies) do
                if not Utils.IsEnemy(target) then continue end
                if not target:FindFirstChild("HumanoidRootPart") then continue end
                if (target.HumanoidRootPart.Position - hrp.Position).Magnitude > range then continue end

                -- Swing visuel
                swing()
                -- Attaque principale
                attack(target)

                -- Utilisation des skills
                if Toggles.KillauraSkills and Toggles.KillauraSkills.Value then
                    local available = getAvailableSkills()
                    for _, skill in ipairs(available) do
                        useSkill(skill)
                    end
                end

                lastAttack = now
                break -- On attaque un mob par cycle pour éviter le spam
            end
        end
    end

    if Toggles.Killaura then
        Toggles.Killaura:OnChanged(function()
            local enabled = Toggles.Killaura.Value
            if enabled and not running then
                task.spawn(loop)
            else
                running = false
            end
        end)
    end

    if Toggles.Killaura and Toggles.Killaura.Value and not running then
        task.spawn(loop)
    end

    ------------------------------------------------------------------------
    -- API (optionnel)
    ------------------------------------------------------------------------
    function M.nudge(target)
        -- helper léger pour anticiper une attaque depuis l'autofarm (non obligatoire)
        if target and Toggles.Killaura and Toggles.Killaura.Value then
            swing()
        end
    end

    print("[CrypT Killaura] ✅ Initialisé (optimisé).")
    ctx.Modules.Killaura = M
end

return M
