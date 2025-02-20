local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

local connectedPlayersCount = 0
local maxPlayers = GetConvarInt('sv_maxclients', 32)

RegisterServerEvent('ak4y-pauseMenu:dropPlayer')
AddEventHandler('ak4y-pauseMenu:dropPlayer', function()
    local user_id = vRP.getUserId({source})
    if user_id then
        vRP.kick({source, "You disconnected from the server."})
    end
end)

RegisterServerEvent('ak4y-pauseMenu:getDetails')
AddEventHandler('ak4y-pauseMenu:getDetails', function()
    local user_id = vRP.getUserId({source})
    if user_id then
        local name = GetPlayerName(source)
        local steamid = vRP.getUserIdentifier({user_id})
        local cashMoney = vRP.getMoney({user_id})
        local bankMoney = vRP.getBankMoney({user_id})
        
        local callback = {
            apiKey = SteamApiKey,
            steamid = steamid,
            maxPlayers = maxPlayers,
            connectedPlayers = connectedPlayersCount,
            cashMoney = cashMoney,
            bankMoney = bankMoney,
            name = name,
        }
        
        TriggerClientEvent('ak4y-pauseMenu:receiveDetails', source, callback)
    end
end)

Citizen.CreateThread(function()
    while true do
        connectedPlayersCount = #vRP.getUsers()
        Wait(AK4Y.ServerWait)
    end
end)
