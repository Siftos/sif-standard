os.loadAPI("sif-standard/date.lua")
--Vars
local filepath = ""

--Local functions
local function createLine(time, content)
    return "["..time.."] "..content
end

--Global Functions
function NewSession(logfolder, session_name)
    local err, date = date.GetDateTime()
    if err ~= nil then
        return err
    end
    date = string.sub(date, 1, 24)

    local path = logfolder.."/"..session_name..".txt"
    if fs.exists(path) then
        fs.move(path, logfolder.."/"..date.."-"..session_name..".txt")
    end
    local logfiles = fs.list(logfolder)
    if #logfiles > 3 then
        fs.delete(logfolder.."/"..logfiles[1])
    end
    filepath = path
end

function Println(content)
    if filepath == "" then
        return "you need to create a new session to log into file"
    end
    local err, time = date.GetTime()
    if err ~= nil then
        return err
    end

    local file = fs.open(filepath, "a")
    file.writeLine(createLine(time, tostring(content)))
    file.close()
    return nil
end