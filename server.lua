--[[ Gets the ESX library ]]--
ESX = nil 
TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)


function canPlayerCarry(playerId, itemName, itemCount)

    local canCarry = false
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if (xPlayer.canCarryItem) then
        canCarry = xPlayer.canCarryItem(itemName, itemCount)
    else
        local item = xPlayer.getInventoryItem(itemName)
        canCarry = (item.limit == -1) or ((item.count + itemCount) <= item.limit)
    end

    return canCarry
end

RegisterNetEvent('esx_spendormachines:Cashier')
AddEventHandler('esx_spendormachines:Cashier', function(price, item, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)


    if canPlayerCarry(source, item, amount) then
        xPlayer.removeMoney(price)
    
        xPlayer.addInventoryItem(item, amount)
        TriggerClientEvent('okokNotify:Alert', source, "EXITO", 'Has comprado <span style="color:green">'.. ESX.GetItemLabel(item) ..'</span> x'.. amount ..' por <span style="color:green">$' .. price .. '</span> Gracias por su compra', 3000, 'success')

    else
        TriggerClientEvent('okokNotify:Alert', source, "", 'No tienes fuerza para llevar mas <span style="color:green">'.. ESX.GetItemLabel(item) ..'</span>', 3000, 'warning')

    end
    -- pNotify('Ha comprado productos por <span style="color: green">$' .. price .. '</span>', 'success', 3000)



end)

ESX.RegisterServerCallback('esx_spendormachines:CheckMoney', function(source, cb, price)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local money

        money = xPlayer.getMoney()

    if money >= price then
        cb(true)
    end
    cb(false)
end)



print('developed by ΞMΛNUΞL#5620 in INDEX | DEV https://discord.gg/S5hqvjZ65Z')