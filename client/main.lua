local QBCore = exports['qb-core']:GetCoreObject()
local SpawnVehicle = false

-- Config Options 

local blips = {
    {title= Lang:t("info.land_veh"), colour= 50, id= 56, x= 111.0112, y= -1088.67, z= 29.302},
    {title= Lang:t("info.air_veh"), colour= 32, id= 578, x= -1673.39, y= -3158.45, z= 13.99},
    {title= Lang:t("info.sea_veh"), colour= 42, id= 410, x= -753.55, y= -1512.24, z= 5.02}, 

}

local vehicles = {
    land = {
        [1] = {
            model = 'futo',
            money = 600,
        },
        [2] = {
            model = 'bison',
            money = 800,
        },
        [3] = {
            model = 'sanchez',
            money = 750,
        },
    },
    air = {
        [1] = {
            model = 'seasparrow',
            money = 7500,
        },
        [2] = {
            model = 'frogger2',
            money = 9500,
        },
        [3] = {
            model = 'swift',
            money = 11000,
        },
    },
    sea = {
        [1] = {
            model = 'seashark3',
            money = 5000,
        },
        [2] = {
            model = 'dinghy3',
            money = 7500,
        },
        [3] = {
            model = 'longfin',
            money = 11000,
        },
    }
}
-- Vehicle Rentals
local comma_value = function(n) -- credit http://richard.warburton.it
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

RegisterNetEvent('qb-rental:client:openMenu', function(data)
    menu = data.MenuType
    local vehMenu = {
        [1] = {
            header = "Rental Vehicles",
            isMenuHeader = true,
        },
        [2] = {
            id = 1,
            header = "Return Vehicle ",
            txt = Lang:t("task.return_veh"),
            params = {
                event = "qb-rental:client:return",
            }
        }
    }
    
    if menu == "vehicle" then
        for k=1, #vehicles.land do
            local veh = QBCore.Shared.Vehicles[vehicles.land[k].model]
            local name = veh and ('%s %s'):format(veh.brand, veh.name) or vehicles.land[k].model:sub(1,1):upper()..vehicles.land[k].model:sub(2)
            vehMenu[#vehMenu+1] = {
                id = k+1,
                header = name,
                txt = ("$%s"):format(comma_value(vehicles.land[k].money)),
                params = {
                    event = "qb-rental:client:spawncar",
                    args = {
                        model = vehicles.land[k].model,
                        money = vehicles.land[k].money,
                    }
                }
            }
        end
    elseif menu == "aircraft" then
        for k=1, #vehicles.air do
            local veh = QBCore.Shared.Vehicles[vehicles.air[k].model]
            local name = veh and ('%s %s'):format(veh.brand, veh.name) or vehicles.air[k].model:sub(1,1):upper()..vehicles.air[k].model:sub(2)
            vehMenu[#vehMenu+1] = {
                id = k+1,
                header = name,
                txt = ("$%s"):format(comma_value(vehicles.air[k].money)),
                params = {
                    event = "qb-rental:client:spawncar",
                    args = {
                        model = vehicles.air[k].model,
                        money = vehicles.air[k].money,
                    }
                }
            }
        end
    elseif menu == "boat" then
        for k=1, #vehicles.sea do
            local veh = QBCore.Shared.Vehicles[vehicles.sea[k].model]
            local name = veh and ('%s %s'):format(veh.brand, veh.name) or vehicles.sea[k].model:sub(1,1):upper()..vehicles.sea[k].model:sub(2)
            vehMenu[#vehMenu+1] = {
                id = k+1,
                header = name,
                txt = ("$%s"):format(comma_value(vehicles.sea[k].money)),
                params = {
                    event = "qb-rental:client:spawncar",
                    args = {
                        model = vehicles.sea[k].model,
                        money = vehicles.sea[k].money,
                    }
                }
            }
        end
    end
    exports['qb-menu']:openMenu(vehMenu)
end)

local CreateNPC = function()
    -- Vehicle Rentals
    created_ped = CreatePed(5, `a_m_y_business_03` , 109.9739, -1088.61, 28.302, 345.64, false, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)

    -- Aircraft Rentals
    created_ped = CreatePed(5, `s_m_y_airworker` , -1686.57, -3149.22, 12.99, 240.88, false, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)

    -- Boat Rentals
    created_ped = CreatePed(5, `mp_m_boatstaff_01` , -753.5, -1512.27, 4.02, 25.61, false, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
end

local SpawnNPC = function()
    CreateThread(function()
        -- Vehicle Rentals
        RequestModel(`a_m_y_business_03`)
        while not HasModelLoaded(`a_m_y_business_03`) do
            Wait(1)
        end
        -- Aircraft Rentals
        RequestModel(`s_m_y_airworker`)
        while not HasModelLoaded(`s_m_y_airworker`) do
            Wait(1)
        end
        -- Aircraft Rentals
        RequestModel(`mp_m_boatstaff_01`)
        while not HasModelLoaded(`mp_m_boatstaff_01`) do
            Wait(1)
        end
        CreateNPC() 
    end)
end

CreateThread(function()
    SpawnNPC()
end)

RegisterNetEvent('qb-rental:client:spawncar', function(data)
    local player = PlayerPedId()
    local money = data.money
    local model = data.model
    local label = Lang:t("error.not_enough_space", {vehicle = menu:sub(1,1):upper()..menu:sub(2)})
    if menu == "vehicle" then
        if IsAnyVehicleNearPoint(111.4223, -1081.24, 29.192, 2.0) then
            QBCore.Functions.Notify(label, "error", 4500)
            return
        end
    elseif menu == "aircraft" then
        if IsAnyVehicleNearPoint(-1673.4, -3158.47, 13.99, 15.0) then 
            QBCore.Functions.Notify(label, "error", 4500)
            return
        end 
    elseif menu == "boat" then
        if IsAnyVehicleNearPoint(-794.95, -1506.27, 1.08, 10.0) then 
            QBCore.Functions.Notify(label, "error", 4500)
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
            TriggerServerEvent('qb-rental:server:rentalpapers', plate, vehicleLabel)
        else
            QBCore.Functions.Notify(Lang:t("error.not_enough_money"), "error", 4500)
        end
    end, money)
end)

RegisterNetEvent('qb-rental:client:return', function()
    if SpawnVehicle then
        local Player = QBCore.Functions.GetPlayerData()
        QBCore.Functions.Notify(Lang:t("task.veh_returned"), 'success')
        TriggerServerEvent('qb-rental:server:removepapers')
        local car = GetVehiclePedIsIn(PlayerPedId(),true)
        NetworkFadeOutEntity(car, true,false)
        Citizen.Wait(2000)
        QBCore.Functions.DeleteVehicle(car)
    else 
        QBCore.Functions.Notify(Lang:t("error.no_vehicle"), "error")
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