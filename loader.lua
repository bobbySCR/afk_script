-- AFQ Standalone — Loader
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/bobbySCR/afk_script/main/loader.lua"))()

local FILES = {
    { url = "https://gist.githubusercontent.com/bobbySCR/f7af83a472aa0238f624358e47cbbb40/raw/fluent_lib.lua", name = "fluent_lib.lua" },
    { url = "https://gist.githubusercontent.com/bobbySCR/2eeed443b89731fb443ef9b60112420c/raw/afq_standalone_v3.lua", name = "afq_standalone_v3.lua" },
}

for _, f in ipairs(FILES) do
    if not isfile(f.name) then
        local ok, content = pcall(function() return game:HttpGet(f.url) end)
        if ok and content and #content > 100 then
            writefile(f.name, content)
        else
            warn("[AFQ] Erreur téléchargement : " .. f.name)
            return
        end
    end
end

loadstring(readfile("afq_standalone_v3.lua"))()
