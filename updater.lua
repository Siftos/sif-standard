os.loadAPI("sif-standard/sifhttp.lua")
os.loadAPI("sif-standard/json.lua")
os.loadAPI("sif-standard/pastebin.lua")
--Functions
local function appJson()
    local file = fs.open("sif-standard/app.json", "r")
    result = file.readAll()
    file.close()
    return json.decode(result)
end

local function getLatestRelease()
    local url = "https://raw.github.com/Siftos/sif-standard/latest-release/app.json"
    local response = http.get(url).readAll()
    local _, app = json.decode(response)
    return app
end

local function checkIfPossibleToUpdate()
    local app = getLatestRelease()
    if app["version"] ~= appJson()["version"] and app["updating_possible"] == true then
        return true
    end
    return false
end

local function CheckForUpdate()
    if err ~= nil then
        print(err)
    end
    local app = getLatestRelease()
    if checkIfPossibleToUpdate() then
        print("Updating from "..appJson()["version"].." to "..app["version"])
        pastebin.run("tpS2kbsp")
    end
end

--Run

CheckForUpdate()