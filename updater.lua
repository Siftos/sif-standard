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

local function CheckForUpdate()
    local err, array = getReleases()
    if err ~= nil then
        print(err)
    end
    if array["name"] ~= sif_standard_version then
        print("Updating from "..sif_standard_version.." to "..array["name"])
        pastebin.run("tpS2kbsp")
    end
end

--Run

CheckForUpdate()