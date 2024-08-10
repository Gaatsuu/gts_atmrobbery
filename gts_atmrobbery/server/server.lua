ESX = exports["es_extended"]:getSharedObject()

local function getNumberOfCops()
    local cops = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer and xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end

    return cops
end

RegisterNetEvent('gts_atmrobbery:tryHack')
AddEventHandler('gts_atmrobbery:tryHack', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer then
        local copsOnline = getNumberOfCops()
        
        if copsOnline >= Config.PoliceCount then
            local hasItem = xPlayer.getInventoryItem(Config.Item).count
            print(hasItem)
            if hasItem >= 1 then
                local coords = GetEntityCoords(GetPlayerPed(src))
                xPlayer.removeInventoryItem(Config.Item, 1)
                TriggerClientEvent('gts_atmrobbery:startHack', src)
            else
                TriggerClientEvent('gts_atmrobbery:missingItem', src)
                
            end
        else
            TriggerClientEvent('gts_atmrobbery:notEnoughCops', src)
        end
    end
end)

RegisterNetEvent('gts_atmrobbery:giveMoney')
AddEventHandler('gts_atmrobbery:giveMoney', function(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer then
        xPlayer.addAccountMoney(Config.Money, amount)
    end
end)