os.loadAPI("sif-standard/sifhttp.lua")
os.loadAPI("sif-standard/json.lua")
os.loadAPI("sif-standard/pastebin.lua")
--Functions
local function appJson()
    local file = fs.open("sif-standard/app.json", "r")
    result = file.readAll()
    file.close()
    local _, app = json.decode(result)
    return app
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
    print("Checking for sif-standard updates...")
    if checkIfPossibleToUpdate() then
        print("Updating from "..appJson()["version"].." to "..app["version"])
        pastebin.run("tpS2kbsp")
    else
        print("None detected!")
    end
end

--Run

--CheckForUpdate()
CheckForUpdate()