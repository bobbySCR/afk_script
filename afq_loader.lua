-- ═══════════════════════════════════════════════════════════════════════════════
-- AFQ Loader — Free Key System (Linkvertise + GitHub Pages)
-- Distribue CE fichier aux utilisateurs.
-- ═══════════════════════════════════════════════════════════════════════════════

-- ⚠️ CONFIGURE ICI ⚠️
local KEY_LINK = "https://direct-link.net/6037988/KSvJoxt8zJlZ"  -- Lien Linkvertise → redirige vers la page de clé
-- (Le lien Linkvertise redirige vers ta page GitHub Pages qui affiche la clé)

local KEY_FILE = "afq_key.txt"
local HttpService = game:GetService("HttpService")

-- ─── Génération de la clé valide (même algo côté page web) ───────────────────
-- La clé = les 8 premiers chars du hash MD5 de "AFQ-" .. date du jour .. "-SECRET"
-- Change "SECRET" par ton propre mot secret (identique dans la page HTML)
local SECRET = "MonSuperSecret123"

local function GetTodayKey()
    local date = os.date("!%Y-%m-%d") -- UTC pour être synchro partout
    local raw = "AFQ-" .. date .. "-" .. SECRET
    -- Simple hash (pas de MD5 natif en Luau, on fait un hash maison stable)
    local h = 0
    for i = 1, #raw do
        h = (h * 31 + string.byte(raw, i)) % 2147483647
    end
    -- Format: AFQ-XXXXXXXX
    return "AFQ-" .. string.format("%08X", h)
end

-- ─── Check si clé déjà sauvegardée et valide ────────────────────────────────
local savedKey = ""
pcall(function()
    if isfile and isfile(KEY_FILE) then
        savedKey = readfile(KEY_FILE):gsub("%s+", "")
    end
end)

local todayKey = GetTodayKey()

if savedKey == todayKey then
    -- Clé valide, charge directement
    loadstring(readfile("afq_standalone_v3.lua"))()
    return
end

-- ─── Sinon, affiche le prompt avec Fluent ────────────────────────────────────
local Fluent = loadstring(readfile("fluent_lib.lua"))()

local Window = Fluent:CreateWindow({
    Title    = "AFQ Standalone",
    SubTitle = "Key System",
    TabWidth = 160,
    Size     = UDim2.fromOffset(420, 220),
    Acrylic  = false,
    Theme    = "Dark",
})

local Tab = Window:AddTab({ Title = "Clé", Icon = "key" })

Tab:AddParagraph({
    Title = "🔑 Clé requise",
    Content = "1. Clique sur 'Obtenir la clé'\n2. Complète le lien\n3. Copie la clé affichée\n4. Colle-la ci-dessous"
})

Tab:AddButton({
    Title = "🔗  Obtenir la clé",
    Description = "Ouvre le lien dans ton navigateur",
    Callback = function()
        -- Copie le lien dans le presse-papier
        pcall(function() setclipboard(KEY_LINK) end)
        Fluent:Notify({ Title = "Lien copié !", Content = "Colle-le dans ton navigateur", Duration = 5 })
    end
})

Tab:AddInput("KeyInput", {
    Title = "Colle ta clé ici",
    Default = "",
    Placeholder = "AFQ-XXXXXXXX",
    Numeric = false,
    Finished = false,
    Callback = function() end
})

Tab:AddButton({
    Title = "✓  Vérifier",
    Callback = function()
        local entered = (Fluent.Options.KeyInput.Value or ""):gsub("%s+", "")
        if entered == "" then
            Fluent:Notify({ Title = "Erreur", Content = "Entre une clé !", Duration = 3 })
            return
        end

        if entered == todayKey then
            Fluent:Notify({ Title = "✓ Valide !", Content = "Chargement du script...", Duration = 3 })
            -- Sauvegarde pour ne pas redemander pendant 24h
            pcall(function() writefile(KEY_FILE, entered) end)
            task.wait(1)
            Fluent:Destroy()
            task.wait(0.3)
            loadstring(readfile("afq_standalone_v3.lua"))()
        else
            Fluent:Notify({ Title = "✗ Invalide", Content = "Clé incorrecte ou expirée", Duration = 4 })
        end
    end
})
