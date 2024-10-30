-- // [VARIABLES] \\ --
Exios = { Functions = { Utils = { } } }

-- // [CALLBACKS] \\ --
lib.callback.register('exios-bonusses:server:cb:getShared', function(src)
    return Shared
end)

-- // [COMMANDS] \\ --
lib.addCommand(Shared.CommandName, {
    help = exports[GetCurrentResourceName()]:getLocale('command_description')
}, function(src, args, raw)
    local isAllowed = Exios.Functions.CheckIfAllowed(src)
    if not isAllowed then 
        TriggerClientEvent('ox_lib:notify', src, { title = exports[GetCurrentResourceName()]:getLocale('error_header_notification'), type = 'error', description = exports[GetCurrentResourceName()]:getLocale('error_header_description') })
        return 
    end

    local itemIndex = Exios.Functions.GetItemIndex()
    if not itemIndex then 
        TriggerClientEvent('ox_lib:notify', src, { title = exports[GetCurrentResourceName()]:getLocale('warning_header_notification'), type = 'warning', description = exports[GetCurrentResourceName()]:getLocale('warning_header_description') })
        return 
    end

    local giveItem = Exios.Functions.GiveBonus(src, itemIndex)
    if not giveItem then 
        TriggerClientEvent('ox_lib:notify', src, { title = exports[GetCurrentResourceName()]:getLocale('warning_header_notification'), type = 'warning', description = exports[GetCurrentResourceName()]:getLocale('warning_header_description') })
        return 
    end

    TriggerClientEvent('ox_lib:notify', src, { title = exports[GetCurrentResourceName()]:getLocale('received_item_header'), type = 'success', description = exports[GetCurrentResourceName()]:getLocale('received_item_description') })
    local updateRows = MySQL.update.await('UPDATE `users` SET `isClaimed` = ? WHERE identifier = ? LIMIT 1', {
        true, ESX.GetPlayerFromId(src).identifier
    })
end)

-- // [FUNCTIONS] \\ --
Exios.Functions.GiveBonus = function(src, itemIndex)
    if not Shared.Items[itemIndex] then return false end
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local itemType = Shared.Items[itemIndex]['item_type']
    local isItemGiven = false
    if itemType ~= 'money' and itemType ~= 'car' and itemType ~= 'item' then return false end

    if itemType == 'money' then 
        xPlayer.addAccountMoney('money', Shared.Items[itemIndex]['item_amount'])
        isItemGiven = true
    elseif itemType == 'car' then 
        print'added vehicle'
        isItemGiven = true
    elseif itemType == 'item' then 
        xPlayer.addInventoryItem(Shared.Items[itemIndex]['item_name'], Shared.Items[itemIndex]['item_amount'])
        isItemGiven = true
    end

    return isItemGiven
end

Exios.Functions.CheckIfAllowed = function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return false end

    local isClaimed = MySQL.scalar.await('SELECT `isClaimed` FROM `users` WHERE `identifier` = ? LIMIT 1', {
        xPlayer.identifier
    })
    if isClaimed then return false end

    return true
end

Exios.Functions.GetItemIndex = function()
    return math.random(1, #Shared.Items)
end