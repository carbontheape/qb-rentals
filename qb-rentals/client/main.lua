local QBCore = exports['qb-core']:GetCoreObject()
local SpawnVehicle = false

-- Config Options 

local blips = {
    {title= "Vehicle Rentals", colour= 50, id= 56, x= 111.0112, y= -1088.67, z= 29.302},
    {title= "Aircraft Rentals", colour= 32, id= 578, x= -1673.39, y= -3158.45, z= 13.99},
    {title= "Boat Rentals", colour= 42, id= 410, x= -753.55, y= -1512.24, z= 5.02}, 

}

-- Vehicle Rentals

RegisterNetEvent('qb-rental:openMenu', function(data)
    menu = data.MenuType
    print(menu)
    if menu == "vehicle" then
        exports['qb-menu']:openMenu({
            {
                header = "Rental Vehicles",
                isMenuHeader = true,
            },
            {
                id = 1,
                header = "Return Vehicle ",
                txt = "Return your rented vehicle.",
                params = {
                    event = "qb-rental:return",
                }
            },
            {
                id = 2,
                header = "Futo",
                txt = "$600.00",
                params = {
                    event = "qb-rental:spawncar",
                    args = {
                        model = 'futo',
                        money = 600,
                    }
                }
            },
            {
                id = 3,
                header = "Bison ",
                txt = "$800.00",
                params = {
                    event = "qb-rental:spawncar",
                    args = {
                        model = 'bison',
                        money = 800,
                    }
                }
            },
            {
                id = 4,
                header = "Sanchez",
                txt = "$750.00",
                params = {
                    event = "qb-rental:spawncar",
                    args = {
                        model = 'sanchez',
                        money = 750,
                    }
                }
            },
        })
    elseif menu == "aircraft" then
        exports['qb-menu']:openMenu({
            {
                header = "Rental Aircrafts",
                isMenuHeader = true,
            },
            {
                id = 1,
                header = "Return Vehicle ",
                txt = "Return your rented vehicle.",
                params = {
                    event = "qb-rental:return",
                }
            },
            {
                id = 2,
                header = "Sea Sparrow",
                txt = "$7,500.00",
                params = {
                    event = "qb-rental:spawncar",
                    args = {
                        model = 'seasparrow',
                        money = 7500,
                    }
                }
            },
            {
                id = 3,
                header = "Frogger ",
                txt = "$9,500.00",
                params = {
                    event = "qb-rental:spawncar",
                    args = {
                        model = 'frogger2',
                        money = 9500,
                    }
                }
            },
            {
                id = 4,
                header = "Swift",
                txt = "$11,000.00",
                params = {
                    event = "qb-rental:spawncar",
                    args = {
                        model = 'swift',
                        money = 11000,
                    }
                }
            },
        })
    elseif menu == "boat" then
        exports['qb-menu']:openMenu({
            {
                header = "Boat Rentals",
                isMenuHeader = true,
            },
            {
                id = 1,
                header = "Return Boat ",
                txt = "Return your rented boat.",
                params = {
                    event = "qb-rental:return",
                }
            },
            {
                id = 2,
                header = "Sea Shark",
                txt = "$5,000.00",
                params = {
                    event = "qb-rental:spawncar",
                    args = {
                        model = 'seashark3',
                        money = 5000,
                    }
                }
            },
            {
                id = 3,
                header = "4 Seater Dinghy",
                txt = "$7,500.00",
                params = {
                    event = "qb-rental:spawncar",
                    args = {
                        model = 'dinghy3',
                        money = 7500,
                    }
                }
            },
            {
                id = 4,
                header = "Longfin",
                txt = "$11,000.00",
                params = {
                    event = "qb-rental:spawncar",
                    args = {
                        model = 'longfin',
                        money = 11000,
                    }
                }
            },
        })
    end
end)

CreateThread(function()
    SpawnNPC()
end)


SpawnNPC = function()
    CreateThread(function()
        -- Vehicle Rentals
        RequestModel(GetHashKey('a_m_y_business_03'))
        while not HasModelLoaded(GetHashKey('a_m_y_business_03')) do
            Wait(1)
        end
        -- Aircraft Rentals
        RequestModel(GetHashKey('s_m_y_airworker'))
        while not HasModelLoaded(GetHashKey('s_m_y_airworker')) do
            Wait(1)
        end
        -- Aircraft Rentals
        RequestModel(GetHashKey('mp_m_boatstaff_01'))
        while not HasModelLoaded(GetHashKey('mp_m_boatstaff_01')) do
            Wait(1)
        end
        CreateNPC() 
    end)
end


CreateNPC = function()
    -- Vehicle Rentals
    created_ped = CreatePed(5, GetHashKey('a_m_y_business_03') , 109.9739, -1088.61, 28.302, 345.64, false, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)

    -- Aircraft Rentals
    created_ped = CreatePed(5, GetHashKey('s_m_y_airworker') , -1686.57, -3149.22, 12.99, 240.88, false, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)

    -- Boat Rentals
    created_ped = CreatePed(5, GetHashKey('mp_m_boatstaff_01') , -753.5, -1512.27, 4.02, 25.61, false, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
end

RegisterNetEvent('qb-rental:spawncar')
AddEventHandler('qb-rental:spawncar', function(data)
    local player = PlayerPedId()
    local money = data.money
    local model = data.model

    if menu == "vehicle" then
        if IsAnyVehicleNearPoint(111.4223, -1081.24, 29.192, 2.0) then
            QBCore.Functions.Notify("Vehicle is in the way!", "error", 4500)
            return
        end
    elseif menu == "aircraft" then
        if IsAnyVehicleNearPoint(-1673.4, -3158.47, 13.99, 15.0) then 
            QBCore.Functions.Notify("Aircraft is in the way!", "error", 4500)
            return
        end 
    elseif menu == "boat" then
        if IsAnyVehicleNearPoint(-794.95, -1506.27, 1.08, 10.0) then 
            QBCore.Functions.Notify("Boat is in the way!", "error", 4500)
            return
        end  
    end

    QBCore.Functions.TriggerCallback("qb-rental:server:CashCheck",function(money)
        if money then
            if menu == "vehicle" then
                QBCore.Functions.SpawnVehicle(model, function(vehicle)
                    SetEntityHeading(vehicle, 340.0)
                    TaskWarpPedIntoVehicle(player, vehicle, -1)
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                    SetVehicleEngineOn(vehicle, true, true)
                    SetVehicleDirtLevel(vehicle, 0.0)
                    exports['lj-fuel']:SetFuel(vehicle, 100)
                    SpawnVehicle = true
                end, vector4(111.4223, -1081.24, 29.192,340.0), true)
            elseif menu == "aircraft" then
                QBCore.Functions.SpawnVehicle(model, function(vehicle)
                    SetEntityHeading(vehicle, 331.49)
                    TaskWarpPedIntoVehicle(player, vehicle, -1)
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                    SetVehicleEngineOn(vehicle, true, true)
                    SetVehicleDirtLevel(vehicle, 0.0)
                    exports['lj-fuel']:SetFuel(vehicle, 100)
                    SpawnVehicle = true
                end, vector4(-1673.39, -3158.45, 13.99, 331.49), true)
            elseif menu == "boat" then
                QBCore.Functions.SpawnVehicle(model, function(vehicle)
                    SetEntityHeading(vehicle, 107.79)
                    TaskWarpPedIntoVehicle(player, vehicle, -1)
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                    SetVehicleEngineOn(vehicle, true, true)
                    SetVehicleDirtLevel(vehicle, 0.0)
                    exports['lj-fuel']:SetFuel(vehicle, 100)
                    SpawnVehicle = true
                end, vector4(-794.95, -1506.27, 1.08, 107.79), true)
            end 
            Wait(1000)
            local vehicle = GetVehiclePedIsIn(player, false)
            local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            vehicleLabel = GetLabelText(vehicleLabel)
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent('qb-rental:rentalpapers', plate, vehicleLabel)
        else
            QBCore.Functions.Notify("Not enough cash", "error", 4500)
        end
    end, money)
end)

RegisterNetEvent('qb-rental:return')
AddEventHandler('qb-rental:return', function()
    if SpawnVehicle then
        local Player = QBCore.Functions.GetPlayerData()
        QBCore.Functions.Notify('Returned vehicle!', 'success')
        TriggerServerEvent('qb-rental:removepapers')
        local car = GetVehiclePedIsIn(PlayerPedId(),true)
        NetworkFadeOutEntity(car, true,false)
        Citizen.Wait(2000)
        QBCore.Functions.DeleteVehicle(car)
    else 
        QBCore.Functions.Notify("No vehicle to return", "error")
    end
    SpawnVehicle = false
end)

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
    info.blip = AddBlipForCoord(info.x, info.y, info.z)
    SetBlipSprite(info.blip, info.id)
    SetBlipDisplay(info.blip, 4)
    SetBlipScale(info.blip, 0.65)
    SetBlipColour(info.blip, info.colour)
    SetBlipAsShortRange(info.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(info.title)
    EndTextCommandSetBlipName(info.blip)
    end
end)