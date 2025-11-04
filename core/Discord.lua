-- core/Discord.lua
-- Envoi de webhooks + bouton de test réutilisable
local Discord = {}
Discord.__index = Discord

function Discord:Bind(Library, Options, Toggles)
    self.Library = Library
    self.Options = Options
    self.Toggles = Toggles
end

local function http_request()
    return (syn and syn.request) or (fluxus and fluxus.request) or request or http_request
end

local HttpService = game:GetService("HttpService")

function Discord:_isValid(url)
    return type(url) == "string" and url:match("^https://discord")
end

function Discord:Send(url, body)
    if not self:_isValid(url) then return end
    local req = http_request()
    body = body or {}
    -- Normalisation footer / timestamp
    body.embeds = body.embeds or {{}}
    body.embeds[1].timestamp = DateTime.now():ToIsoDate()
    body.embeds[1].footer = body.embeds[1].footer or {
        text = 'CrypT',
        icon_url = 'https://raw.githubusercontent.com/turpez/CrypT/refs/heads/main/assets/CrypT.png'
    }
    body.username = body.username or "CrypT"
    body.avatar_url = body.avatar_url or 'https://raw.githubusercontent.com/turpez/CrypT/refs/heads/main/assets/CrypT.png'

    req({
        Url = url,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode(body)
    })
end

function Discord:SendTest(url, ping)
    if not self:_isValid(url) then
        self.Library:Notify("⚠️ Aucun webhook configuré.", 4)
        return
    end
    self:Send(url, {
        content = (ping and ping ~= "") and ("<@"..ping..">") or nil,
        embeds = {{
            title = "✅ Test CrypT",
            description = "Les notifications Discord fonctionnent parfaitement !",
            color = 0x00FFFF,
            footer = { text = "CrypT Notifications" }
        }}
    })
    self.Library:Notify("✅ Message de test envoyé !", 4)
end

return setmetatable({}, Discord)
