--Vars

function run(code)
    local temp = "/__temporary/tmp.lua"
    local response = http.get("http://pastebin.com/raw.php?i="..code).readAll()
    local file = fs.open(temp, "w")
    file.write(response)
    file.close()
    dofile(temp)
    fs.delete(temp)
    fs.delete("/__temporary")
end