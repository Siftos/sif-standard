os.loadAPI("sif-standard/sifhttp.lua")
os.loadAPI("sif-standard/json.lua")
os.loadAPI("sif-standard/pastebin.lua")
--Vars
local sif_standard_version = "v1.2.5"
--Functions
local function getReleases()
    local url = "https://api.github.com/repos/Siftos/sif-standard/releases/latest"
    err = sifhttp.checkValidity(url)
    if err ~= nil then
       return err, nil
    end
    local response = http.get(url)
    if response == nil then
        return "didn't return any response", nil
    end
    if response.getResponseCode() ~= 200 then
        return repsonse.getResponseCode(), nil
    end
    local err, response_table = json.decode(response.readLine())
    return err, response_table
end

local function checkIfPossibleToUpdate()
    local url = "https://raw.github.com/Siftos/sif-standard/latest-release/app.json"
    local response = http.get(url).readAll()
    local app = json.decode(response)
    if app["version"] ~= sif_standard_version and app["updating_possible"] == true then
        return true
    end
    return false
end

local function CheckForUpdate()
    local err, array = getReleases()
    if err ~= nil then
        print(err)
    end
    if array["name"] ~= sif_standard_version and checkIfPossibleToUpdate() then
        print("Updating from "..sif_standard_version.." to "..array["name"])
        pastebin.run("tpS2kbsp")
    end
end

--Run

CheckForUpdate()