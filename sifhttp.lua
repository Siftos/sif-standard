--Vars

--Functions
function checkValidity(url)
    local success, message = http.checkURL(url)
    if not success then
        return message
    end
    return nil
end