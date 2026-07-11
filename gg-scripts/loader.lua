local url = "https://raw.githubusercontent.com/mahdimirzapor111111-hue/MMSTUDYI/main/gg-scripts/script.lua"

local r = gg.makeRequest(url)

if not r or r.code ~= 200 then
    gg.alert("دانلود ناموفق")
    os.exit()
end

local f, err = load(r.content)
if not f then
    gg.alert(err)
    os.exit()
end

f()
