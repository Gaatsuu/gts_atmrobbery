ESX = exports["es_extended"]:getSharedObject()

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

Citizen.CreateThread(function()
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local atmProps = {
    `prop_atm_01`,
    `prop_atm_02`,
    `prop_atm_03`,
    `prop_fleeca_atm`
}

exports.ox_target:addModel(atmProps, {
    {
        name = 'atm_menu',
        icon = 'fas fa-credit-card',
        label = 'Hack ATM',
        onSelect = function()
            local playerPed = PlayerPedId()
            local playerPos = GetEntityCoords(playerPed)
            TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_STAND_MOBILE', 0, true)
            TriggerServerEvent('gts_atmrobbery:tryHack', ped, gender, playerPos, within, npc)
            DispatchCall(playerPos)
            Wait(10000)
            ClearPedTasks(playerPed)
        end,
        canInteract = function(entity, distance, coords, name)
            return true
        end
    }
})

RegisterNetEvent('gts_atmrobbery:startHack')
AddEventHandler('gts_atmrobbery:startHack', function()
    ESX.ShowNotification("La police a été informée du piratage de l'ATM. Vous avez moins de 3 minutes pour pirater l'ATM.")
    Wait(3000)
    TriggerEvent("datacrack:start", 4.5, function(output)
        if output == true then
            TriggerEvent('gts_atmrobbery:hackSuccess')
        else
            TriggerEvent('gts_atmrobbery:hackFailed')
        end
    end)
end)

RegisterNetEvent('gts_atmrobbery:hackSuccess')
AddEventHandler('gts_atmrobbery:hackSuccess', function()
    ESX.ShowNotification('Le piratage a réussi !')
    local amount = math.random(Config.minReward, Config.maxReward)
    TriggerServerEvent('gts_atmrobbery:giveMoney', amount)
end)

RegisterNetEvent('gts_atmrobbery:hackFailed')
AddEventHandler('gts_atmrobbery:hackFailed', function()
    ESX.ShowNotification("Vous avez échoué à pirater l'ATM")
end)

RegisterNetEvent('gts_atmrobbery:notEnoughCops')
AddEventHandler('gts_atmrobbery:notEnoughCops', function()
    ESX.ShowNotification("Il n'y a pas assez de policiers en ligne pour pirater cet ATM.")
end)

RegisterNetEvent('gts_atmrobbery:missingItem')
AddEventHandler('gts_atmrobbery:missingItem', function()
    ESX.ShowNotification("Vous n'avez pas l'objet nécessaire pour pirater cet ATM.")
end)
