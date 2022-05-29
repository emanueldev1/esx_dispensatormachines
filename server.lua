--[[ Gets the ESX library ]]--
ESX = nil 
TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

RegisterNetEvent('esx_spendormachines:Cashier')
AddEventHandler('esx_spendormachines:Cashier', function(price, item, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    print(item)
    print(amount)

        xPlayer.removeMoney(price)
    
        xPlayer.addInventoryItem(item, amount)
    
    -- pNotify('Ha comprado productos por <span style="color: green">$' .. price .. '</span>', 'success', 3000)

    TriggerClientEvent('okokNotify:Alert', source, "EXITO", 'Has comprado '.. ESX.GetItemLabel(item) ..' x'.. amount ..' por <span style="color:green">$' .. price .. '</span> Gracias por su compra', 3000, 'success')


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