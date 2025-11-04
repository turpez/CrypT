--[[
    CrypT Hub - AutoFarm.lua (Optimisé)
    Auteur : Turpez
    Description :
      - Sélectionne la cible (mob) vivante la plus proche dans le rayon défini.
      - Se déplace en continu vers une position optimale autour de la cible (offset horizontal).
      - Vitesse et rayon contrôlés par l'UI (ctx.Options.AutofarmSpeed / AutofarmRadius).
      - N'attaque pas lui-même : laisse Killaura gérer les coups (si activée).
      - Arrête proprement les tweens quand désactivé / cible morte / joueur mort.
--]]

local M = {}

function M.init(ctx)
    local RunService       = ctx.Services.RunService
    local Workspace        = ctx.Services.Workspace
    local TweenService     = game:GetService("TweenService")

    local Options          = ctx.Options
    local Toggles          = ctx.Toggles
    local Utils            = ctx.Utils

    -- Références joueur
    local function getChar()
        local lp = ctx.Globals.LocalPlayer
        return lp and (lp.Character or lp.CharacterAdded:Wait())
    end

    local function getHRP()
        local char = getChar()
        return char and char:FindFirstChild("HumanoidRootPart")
    end

    local function getHumanoid()
        local char = getChar()
        return char and char:FindFirstChildOfClass("Humanoid")
    end

    -- Mobs container
    local Mobs = Workspace:FindFirstChild("Mobs") or Workspace:WaitForChild("Mobs", 10)

    -- Petite sécurité sur Mobs
    if not Mobs then
        warn("[CrypT Autofarm] Impossible de trouver workspace.Mobs")
        return
    end

    ------------------------------------------------------------------------
    -- Helpers
    ------------------------------------------------------------------------
    local function isEntityAlive(model)
        if not model or not model.Parent then return false end
        local root = model:FindFirstChild("HumanoidRootPart")
        local entity = model:FindFirstChild("Entity")
        local health = entity and entity:FindFirstChild("Health")
        if not (root and entity and health) then return false end
        return (health.Value or 0) > 0
    end

    local function withinRadius(origin, pos, radius)
        return (pos - origin).Magnitude <= radius
    end

    local function pickTarget(hrpPos, radius)
        local closest, minDist = nil, radius
        for _, mob in ipairs(Mobs:GetChildren()) do
            if isEntityAlive(mob) then
                local root = mob:FindFirstChild("HumanoidRootPart")
                if root then
                    local d = (root.Position - hrpPos).Magnitude
                    if d < minDist then
                        minDist = d
                        closest = mob
                    end
                end
            end
        end
        return closest
    end

    -- Calcule une position "idéale" autour du mob (offset horizontal adaptatif)
    local function computeApproachPosition(hrp, targetModel)
        local root = targetModel:FindFirstChild("HumanoidRootPart")
        if not root then return nil end

        -- Rayon d'approche basé sur la taille du mob (marge +20)
        local radius = math.max(root.Size.X, root.Size.Z) * 0.5 + 20

        -- Direction horizontale depuis la cible vers nous : on se place en face
        local diff = hrp.Position - root.Position
        local horiz = Vector3.new(diff.X, 0, diff.Z)

        local offset
        if horiz.Magnitude > 0.1 then
            offset = horiz.Unit * radius
        else
            -- si on est pile au même endroit (rare), décale un peu
            offset = Vector3.new(radius, 0, 0)
        end

        -- Aligne verticalement au milieu des 2 rootparts (léger ajustement)
        local yAdj = (hrp.Size.Y - root.Size.Y) * 0.5

        local targetPos = root.Position + offset + Vector3.new(0, yAdj, 0)

        -- Si le mob a une BodyVelocity active, anticipe légèrement son mouvement
        local bv = root:FindFirstChild("BodyVelocity")
        if bv and bv.VectorVelocity.Magnitude > 0 then
            targetPos += bv.VectorVelocity.Unit
        end

        return targetPos
    end

    -- Tween/Move
    local activeTween
    local function stopTween()
        if activeTween then
            activeTween:Cancel()
            activeTween = nil
        end
    end

    local function moveTo(hrp, targetPos, speed)
        stopTween()
        if not hrp or not targetPos then return end
        local dist = (hrp.Position - targetPos).Magnitude
        local time = 0.001
        if speed and speed > 0 then
            time = math.clamp(dist / speed, 0.05, 2.0)
        end
        activeTween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
            CFrame = CFrame.new(targetPos)
        })
        activeTween:Play()
    end

    ------------------------------------------------------------------------
    -- Boucle d'autofarm
    ------------------------------------------------------------------------
    local running = false

    local function loop()
        running = true
        while running and Toggles.Autofarm and Toggles.Autofarm.Value do
            task.wait(0.1)

            local humanoid = getHumanoid()
            if not humanoid or humanoid.Health <= 0 then
                stopTween()
                continue
            end

            local hrp = getHRP()
            if not hrp then
                stopTween()
                continue
            end

            local speed  = Options.AutofarmSpeed and Options.AutofarmSpeed.Value or 300
            local radius = Options.AutofarmRadius and Options.AutofarmRadius.Value or 20000
            if radius == 0 then
                task.wait(0.2)
                continue
            end

            -- Trouver la cible
            local target = pickTarget(hrp.Position, radius)
            if not target then
                -- Pas de cible : on stoppe le tween pour éviter les glissements
                stopTween()
                task.wait(0.2)
                continue
            end

            -- Si la cible meurt en cours de route, on arrête le tween
            if not isEntityAlive(target) then
                stopTween()
                task.wait(0.1)
                continue
            end

            -- Position d’approche
            local targetPos = computeApproachPosition(hrp, target)
            if not targetPos then
                stopTween()
                task.wait(0.1)
                continue
            end

            -- Si on est déjà suffisamment proche, ne tween pas comme un fou
            if (hrp.Position - targetPos).Magnitude > 2 then
                moveTo(hrp, targetPos, speed)
            end

            -- Laisse Killaura gérer les coups si activée :
            -- Si tu veux une micro-anticipation (ex: ping Killaura), tu peux :
            -- if ctx.Modules.Killaura and Toggles.Killaura and Toggles.Killaura.Value then
            --     ctx.Modules.Killaura.nudge(target) -- (optionnel : petit helper côté Killaura)
            -- end
        end
        stopTween()
    end

    -- Gestion du toggle
    if Toggles.Autofarm then
        Toggles.Autofarm:OnChanged(function()
            local enabled = Toggles.Autofarm.Value
            if enabled and not running then
                task.spawn(loop)
            elseif not enabled and running then
                running = false
                stopTween()
            end
        end)
    end

    -- Auto-recovery (si le script est chargé quand le toggle est déjà ON)
    if Toggles.Autofarm and Toggles.Autofarm.Value and not running then
        task.spawn(loop)
    end

    print("[CrypT Autofarm] ✅ Initialisé (optimisé).")
    ctx.Modules.AutoFarm = M
end

return M
