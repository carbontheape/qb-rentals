local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("rentalpapers", function(source, item, plate)
    TriggerEvent("vehiclekeys:client:SetOwner", plate)
    print("Gave Keys")
end)

RegisterServerEvent('qb-rental:rentalpapers')
AddEventHandler('qb-rental:rentalpapers', function(plate, model)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = {}
    info.citizenid = Player.PlayerData.citizenid
    info.firstname = Player.PlayerData.charinfo.firstname
    info.lastname = Player.PlayerData.charinfo.lastname
    info.plate = plate
    info.model = model
    TriggerClientEvent('inventory:client:ItemBox', src,  QBCore.Shared.Items["rentalpapers"], 'add')
    Player.Functions.AddItem('rentalpapers', 1, false, info)
end)


RegisterServerEvent('qb-rental:removepapers')
AddEventHandler('qb-rental:removepapers', function(plate, model)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('inventory:client:ItemBox', src,  QBCore.Shared.Items["rentalpapers"], 'remove')
    Player.Functions.RemoveItem('rentalpapers', 1, false, info)
end)

QBCore.Functions.CreateCallback('qb-rental:server:CashCheck',function(source, cb, money)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.money.cash >= money then
        cb(true)
        Player.Functions.RemoveMoney('cash', money)
    else
        cb(false)
    end
end)
