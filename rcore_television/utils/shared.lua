-- this is for translation
function _T(str, ...)
    local text = Locales[str]
    return string.format(text, ...)
end