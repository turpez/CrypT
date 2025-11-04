--[[
    CrypT Hub - Utils.lua
    Auteur : Turpez
    Description : Contient les fonctions utilitaires communes (HTTP, maths, sécurité, etc.)
--]]

local M = {}

function M.init(ctx)
    local HttpService = ctx.Services.HttpService

    -- ✅ Détection de l’exécuteur
    function M.GetExecutor()
        if identifyexecutor then
            local success, name = pcall(identifyexecutor)
            if success and name then return name end
        end
        return "Unknown"
    end

    -- ✅ Envoi de requêtes HTTP universel (compatible Synapse / Fluxus / ScriptWare)
    function M.HttpRequest(tbl)
        local req = (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or request
        if not req then
            warn("[CrypT Utils] ⚠️ Aucune fonction de requête HTTP disponible.")
            return
        end
        local success, result = pcall(function()
            return req(tbl)
        end)
        if not success then
            warn("[CrypT Utils] ❌ Erreur lors de l’envoi de la requête : " .. tostring(result))
        end
        return result
    end

    -- ✅ Conversion de vecteurs
    function M.Vector3ToString(v)
        return string.format("(%.2f, %.2f, %.2f)", v.X, v.Y, v.Z)
    end

    -- ✅ Calcul de la distance entre deux positions
    function M.Distance(a, b)
        return (a - b).Magnitude
    end

    -- ✅ Fonction de tween (pour des mouvements fluides dans le monde)
    function M.TweenToPosition(hrp, targetPosition, speed)
        if not hrp or not targetPosition then return end
        local TweenService = game:GetService("TweenService")
        local distance = (hrp.Position - targetPosition).Magnitude
        local tweenTime = distance / (speed or 300)
        local tween = TweenService:Create(hrp, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), { CFrame = CFrame.new(targetPosition) })
        tween:Play()
        return tween
    end

    -- ✅ Fonction d’attente intelligente
    function M.WaitFor(cond, timeout)
        local start = tick()
        repeat
            task.wait()
        until cond() or (timeout and tick() - start > timeout)
        return cond()
    end

    -- ✅ Fonction d’impression colorée
    function M.PrintColored(title, msg)
        rconsoleprint("[CrypT] ")
        rconsoleprint("@@LIGHT_BLUE@@")
        rconsoleprint(title .. ": ")
        rconsoleprint("@@WHITE@@")
        print(msg)
    end

    -- ✅ Détection du personnage local
    function M.GetCharacter()
        local lp = ctx.Globals.LocalPlayer
        if not lp then return nil end
        return lp.Character or lp.CharacterAdded:Wait()
    end

    -- ✅ Obtient le HumanoidRootPart du joueur local
    function M.GetRoot()
        local char = M.GetCharacter()
        if char then
            return char:FindFirstChild("HumanoidRootPart")
        end
        return nil
    end

    -- ✅ Vérifie si un modèle est un ennemi
    function M.IsEnemy(model)
        if not model or not model:IsA("Model") then return false end
        if model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
            if model.Humanoid.Health > 0 and model:FindFirstChildOfClass("Humanoid") then
                return true
            end
        end
        return false
    end

    -- ✅ Formate les nombres
    function M.FormatNumber(num)
        local formatted = tostring(num)
        local k
        while true do
            formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", '%1,%2')
            if k == 0 then break end
        end
        return formatted
    end

    -- ✅ Génère un ID unique
    function M.GenerateUUID()
        return HttpService:GenerateGUID(false)
    end

    -- ✅ Ajoute les utilitaires au contexte global
    ctx.Utils = M
    print("[CrypT Utils] ✅ Utilitaires chargés. Exécuteur :", M.GetExecutor())
end

return M
