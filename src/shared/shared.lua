Exios = {}
Exios.Shared = { Functions = { Utils = { } } }

Exios.Shared.Functions.CheckLanguage = function(language)
    if not Shared.Locales[language] then return false end

    return true
end
exports('checkLanguage', Exios.Shared.Functions.CheckLanguage)

Exios.Shared.Functions.GetLocale = function(locale)
    local selectedLocale = Shared.Language and Shared.Language or 'en'
    if not Shared.Locales[selectedLocale] then return end

    return Shared.Locales[selectedLocale][locale]
end
exports('getLocale', Exios.Shared.Functions.GetLocale)