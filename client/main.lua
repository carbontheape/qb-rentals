local QBCore = exports['qb-core']:GetCoreObject()
local SpawnVehicle = false

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
        QBCore.Functions.TriggerCallback("qb-rentals:server:getPilotLicenseStatus", function(hasLicense)
            if hasLicense  then
                for k=1, #Config.vehicles.land do
                    local veh = QBCore.Shared.Vehicles[Config.vehicles.land[k].model]
                    local name = veh and ('%s %s'):format(veh.brand, veh.name) or Config.vehicles.land[k].model:sub(1,1):upper()..Config.vehicles.land[k].model:sub(2)
                    vehMenu[#vehMenu+1] = {
                        id = k+1,
                        header = name,
                        txt = ("$%s"):format(comma_value(Config.vehicles.land[k].money)),
                        params = {
                            event = "qb-rental:client:spawncar",
                            args = {
                                model = Config.vehicles.land[k].model,
                                money = Config.vehicles.land[k].money,
                            }
                        }
                    }
                end
            else
                QBCore.Functions.Notify(Lang:t("error.no_driver_license"), "error", 4500)
            end
        end 
    elseif menu == "aircraft" then
        QBCore.Functions.TriggerCallback("qb-rentals:server:getPilotLicenseStatus", function(hasLicense)
            if hasLicense  then
                for k=1, #Config.vehicles.air do
                    local veh = QBCore.Shared.Vehicles[Config.vehicles.air[k].model]
                    local name = veh and ('%s'):format(veh.name) or Config.vehicles.air[k].model:sub(1,1):upper()..Config.vehicles.air[k].model:sub(2)
                    vehMenu[#vehMenu+1] = {
                        id = k+1,
                        header = name,
                        txt = ("$%s"):format(comma_value(Config.vehicles.air[k].money)),
                        params = {
                            event = "qb-rental:client:spawncar",
                            args = {
                                model = Config.vehicles.air[k].model,
                                money = Config.vehicles.air[k].money,
                            }
                        }
                    }
                    exports['qb-menu']:openMenu(vehMenu)
                end
            else
                QBCore.Functions.Notify(Lang:t("error.no_pilot_license"), "error", 4500)
            end
        end)
    elseif menu == "boat" then
        for k=1, #Config.vehicles.sea do
            local veh = QBCore.Shared.Vehicles[Config.vehicles.sea[k].model]
            local name = veh and ('%s %s'):format(veh.brand, veh.name) or Config.vehicles.sea[k].model:sub(1,1):upper()..Config.vehicles.sea[k].model:sub(2)
            vehMenu[#vehMenu+1] = {
                id = k+1,
                header = name,
                txt = ("$%s"):format(comma_value(Config.vehicles.sea[k].money)),
                params = {
                    event = "qb-rental:client:spawncar",
                    args = {
                        model = Config.vehicles.sea[k].model,
                        money = Config.vehicles.sea[k].money,
                    }
                }
            }
        end
    end
    exports['qb-menu']:openMenu(vehMenu)
end)

local CreateNPC = function()
    -- Vehicle Rentals
    created_ped = CreatePed(5, Config.vehicleped , Config.vehlocation.x, Config.vehlocation.y, Config.vehlocation.z, Config.vehlocation.w, false, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)

    -- Aircraft Rentals
    created_ped = CreatePed(5, Config.airped , Config.airlocation.x, Config.airlocation.y, Config.airlocation.z, Config.airlocation.w, false, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)

    -- Boat Rentals
    created_ped = CreatePed(5, Config.boatped , Config.boatlocation.x, Config.boatlocation.y, Config.boatlocation.z, Config.boatlocation.w, false, true)
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
        if IsAnyVehicleNearPoint(111.4223, -1081.24, 29.192, 5.0) then
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
                    if Config.fueltype = 'lj-fuel' then
                        exports['LegacyFuel']:SetFuel(vehicle, 100)
                    elseif Config.fueltype = 'LegacyFuel' then
                        exports['LegacyFuel']:SetFuel(vehicle, 100)
                    end
                    SpawnVehicle = true
                end, Config.vehspawn, true)
            elseif menu == "aircraft" then
                QBCore.Functions.SpawnVehicle(model, function(vehicle)
                    SetEntityHeading(vehicle, 331.49)
                    TaskWarpPedIntoVehicle(player, vehicle, -1)
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                    SetVehicleEngineOn(vehicle, true, true)
                    SetVehicleDirtLevel(vehicle, 0.0)
                    if Config.fueltype = 'lj-fuel' then
                        exports['LegacyFuel']:SetFuel(vehicle, 100)
                    elseif Config.fueltype = 'LegacyFuel' then
                        exports['LegacyFuel']:SetFuel(vehicle, 100)
                    end
                    SpawnVehicle = true
                end, vector4(-1673.39, -3158.45, 13.99, 331.49), true)
            elseif menu == "boat" then
                QBCore.Functions.SpawnVehicle(model, function(vehicle)
                    SetEntityHeading(vehicle, 107.79)
                    TaskWarpPedIntoVehicle(player, vehicle, -1)
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                    SetVehicleEngineOn(vehicle, true, true)
                    SetVehicleDirtLevel(vehicle, 0.0)
                    if Config.fueltype = 'lj-fuel' then
                        exports['LegacyFuel']:SetFuel(vehicle, 100)
                    elseif Config.fueltype = 'LegacyFuel' then
                        exports['LegacyFuel']:SetFuel(vehicle, 100)
                    end
                    SpawnVehicle = true
                end, vector4(-794.95, -1506.27, 1.08, 107.79), true)
            end 
            Wait(1000)
            local vehicle = GetVehiclePedIsIn(player, false)
            local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            vehicleLabel = GetLabelText(vehicleLabel)
            local plate = GetVehicleNumberPlateText(vehicle)
            SpawnVehicle = vehicle
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
    for _, info in pairs(Config.blips) do
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