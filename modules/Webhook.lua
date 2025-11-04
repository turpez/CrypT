--[[
    CrypT Hub - Webhook.lua
    Auteur : Turpez
    Description : Envoi de notifications vers Discord (webhooks) — compatible Synapse / Fluxus / ScriptWare
--]]

local M = {}

function M.init(ctx)
    local HttpService = ctx.Services.HttpService

    -- Avatar/logo identique à l'original
    local AVATAR_URL = "https://raw.githubusercontent.com/turpez/CrypT/refs/heads/main/assets/logo.png"
    local BOT_NAME = "CrypT"

    -- helper: récupère la fonction de requête HTTP disponible
    local function getRequestFunc()
        return (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or request or http_request
    end

    -- send: envoie un message sur un webhook discord
    function M.send(url, body, ping)
        if type(url) ~= "string" then return end
        if type(body) ~= "table" then return end
        if not string.match(url, "^https://discord") then return end

        -- prepare body
        body = body or {}
        body.content = ping and (type(ping) == "string" and ("<@" .. ping .. ">") or ("<@" .. (ctx.Options and (ctx.Options.WebhookPing and ctx.Options.WebhookPing.Value) or "") .. ">")) or body.content
        body.username = BOT_NAME
        body.avatar_url = AVATAR_URL
        body.embeds = body.embeds or {{}}

        -- ensure embed structure
        if type(body.embeds) == "table" and type(body.embeds[1]) == "table" then
            body.embeds[1].timestamp = DateTime.now():ToIsoDate()
            body.embeds[1].footer = body.embeds[1].footer or {}
            body.embeds[1].footer.text = body.embeds[1].footer.text or BOT_NAME
            body.embeds[1].footer.icon_url = body.embeds[1].footer.icon_url or AVATAR_URL
        end

        local req = getRequestFunc()
        if not req then
            warn("[CrypT Webhook] Aucune fonction HTTP disponible pour envoyer le webhook.")
            return
        end

        local ok, err = pcall(function()
            req({
                Url = url,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(body)
            })
        end)

        if not ok then
            warn("[CrypT Webhook] Erreur lors de l'envoi du webhook : " .. tostring(err))
        end
    end

    -- sendTestMessage: envoie un message de test sur le webhook (utilisé par l'UI)
    function M.sendTestMessage(url)
        if not url or url == "" then return end
        local ping = (ctx.Options and ctx.Options.WebhookPing and ctx.Options.WebhookPing.Value) or nil
        M.send(url, {
            embeds = {{
                title = "This is a test message",
                description = "You'll be notified to this webhook",
                color = 0x00ff00
            }}
        }, ping)
    end

    -- Expose dans le contexte global
    ctx.Webhook = M

    print("[CrypT Webhook] ✅ Module Webhook initialisé.")
end

return M
