local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

local maxPlayers = nil
local connectedPlayersCount = nil
local lastCheck = 0
local apiKey = nil
local steamID = nil

Citizen.CreateThread(function()
    Wait(5000)
    SendNUIMessage({
        action = 'setJS', 
        translate = AK4Y.Translate,
        discordURL = AK4Y.DiscordURL,
        instagramURL = AK4Y.InstagramURL,
        youtubeURL = AK4Y.YoutubeURL,
    })
end)

RegisterCommand('openSettings', function()
    if not IsPauseMenuActive() and not IsNuiFocused() then
        SetNuiFocus(true,true)
        SendNUIMessage({ action = 'show' })
        setInto()
    end
end)

local moneyCash 
local moneyBank
local firstname = ""

function setInto()
    if lastCheckControl() then
        lastCheck = GetGameTimer() + AK4Y.ClientWait
        local source = source
        local user_id = vRP.getUserId({source})
        if user_id then
            local name = vRP.getUserIdentity({user_id}).firstname
            local steamid = vRP.getUserIdentifier({user_id})
            moneyCash = vRP.getMoney({user_id})
            moneyBank = vRP.getBankMoney({user_id})
            local job = vRP.getUserGroupByType({user_id, "job"})
            apiKey = SteamApiKey
            steamID = steamid and ("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=" .. apiKey .. "&steamids=" .. steamid) or 'null'
            maxPlayers = GetConvarInt('sv_maxclients', 32)
            connectedPlayersCount = #vRP.getUsers()
            
            SendNUIMessage({
                action = 'setInto', 
                moneyCash = moneyCash,
                moneyBank = moneyBank,
                job = job,
                gender = "",
                firstname = firstname,
                lastname = "",
                maxPlayers = maxPlayers,
                connectedPlayers = connectedPlayersCount,
                apiKey = apiKey,
                steamid = steamID,
            })
        end
    end
end

RegisterNUICallback('openSettings', function(data, cb)
    SetNuiFocus(false, false)
    ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_LANDING_MENU'),0,-1) 
end)

RegisterNUICallback('openMap', function(data, cb)
    SetNuiFocus(false, false)
    ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'),0,-1) 
end)

RegisterNUICallback('exit', function(data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('ak4y-pauseMenu:dropPlayer')
end)

RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)
end)

RegisterKeyMapping('openSettings', 'Open Settings Menu', 'keyboard', 'ESCAPE')

Citizen.CreateThread(function()
    while true do
        Wait(1)
        SetPauseMenuActive(false)
    end
end)

function lastCheckControl()
    return lastCheck <= GetGameTimer()
end