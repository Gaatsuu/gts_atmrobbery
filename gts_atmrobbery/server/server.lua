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

local lastHackAttempt = {}

local COOLDOWN_TIME = Config.Cooldown -- Temps en secondes (30 minutes)

RegisterNetEvent('gts_atmrobbery:tryHack')
AddEventHandler('gts_atmrobbery:tryHack', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local playerId = xPlayer.identifier
    local currentTime = os.time()

    if lastHackAttempt[playerId] and currentTime - lastHackAttempt[playerId] < COOLDOWN_TIME then
        local remainingTime = COOLDOWN_TIME - (currentTime - lastHackAttempt[playerId])
        TriggerClientEvent('esx:showNotification', src, ('Vous devez attendre ~r~%s~s~ avant de pouvoir tenter un autre braquage.'):format(math.ceil(remainingTime / 60) .. ' minutes'))
        return
    end

    if xPlayer then
        local copsOnline = getNumberOfCops()
        
        if copsOnline >= Config.PoliceCount then
            local hasItem = xPlayer.getInventoryItem(Config.Item).count
            print(hasItem)
            if hasItem >= 1 then
                lastHackAttempt[playerId] = currentTime -- Met à jour le dernier temps de tentative
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
