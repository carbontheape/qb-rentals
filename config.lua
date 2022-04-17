Config = {}

-- Vehicle Rentals 
Config.vehicleped = `a_m_y_business_03`
Config.vehlocation = { x = 109.9739, y = -1088.61, z = 28.302, w = 345.64 },
Config.vehspawn = vector4(-1673.39, -3158.45, 13.99, 331.49)

-- Aircraft Rentals
Config.airped = `s_m_y_airworker`
Config.vehlocation = { x = -1686.57, y = -3149.22, z = 12.99, w = 240.88 }

-- Boat Rentals
Config.boatped = `mp_m_boatstaff_01`
Config.boatlocation = { x = -753.5, y = -1512.27, z = 4.02, w = 25.61 }

Config.blips = {
    {title= Lang:t("info.land_veh"), colour= 50, id= 56, x= 111.0112, y= -1088.67, z= 29.302},
    {title= Lang:t("info.air_veh"), colour= 32, id= 578, x= -1673.39, y= -3158.45, z= 13.99},
    {title= Lang:t("info.sea_veh"), colour= 42, id= 410, x= -753.55, y= -1512.24, z= 5.02}, 
}

Config.fueltype = 'lj-fuel',

Config.vehicles = {
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