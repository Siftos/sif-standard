os.loadAPI("sif-standard/sifhttp.lua")
--functions

local function makeTableFromResponse(response)
    local result = {}
    for line in response.readLine do
        local colon_detected = false
        local code = ""
        local content = ""
        for i = 1, #line do
            if colon_detected then
                content = content..string.sub(line,i,i)
            end
            if string.sub(line, i, i) == ":" then
                colon_detected = true
            end
            if not colon_detected then
                code = code..string.sub(line,i,i)
            end
        end
        result[code] = string.sub(content,2)
    end
    return result
end

local function Get()
    local url = "http://worldtimeapi.org/api/ip.txt"
    err = sifhttp.checkValidity(url)
    if err ~= nil then
        return err, nil
    end
    local response = http.get("http://worldtimeapi.org/api/ip.txt")
    if response.getResponseCode() ~= 200 then
        return response.getResponseCode(), nil
    end
    local table = makeTableFromResponse(response)
    response.close()
    return nil, table
end

function GetDateTime()
    local err, table = Get()
    if err ~= nil then
        return err, nil
    end
    return nil, table["datetime"]
end

function GetDate()
    local err, datetime = GetDateTime()
    if err ~= nil then
        return err, nil
    end
    local end_range = 0
    for i = 1, #datetime do
        if string.sub(datetime, i, i) == "T" then
            end_range = i - 1
            break
        end 
    end
    return nil, string.sub(datetime, 1, end_range)
end

function GetTime()
    local err, datetime = GetDateTime()
    if err ~= nil then
        return err, nil
    end
    local start_range = 0
    for i = 1, #datetime do
        if string.sub(datetime, i, i) == "T" then
            start_range = i + 1
            break
        end
    end
    return nil, string.sub(datetime, start_range, start_range + 7)
end