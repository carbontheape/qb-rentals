# qb-rentals
This is a vehicle rental script for Cars, Aircrafts and Boats. This script is made for the qbcore framework and utilizes qb-target and qb-menu.

# Dependencies 
- [qb-target](https://github.com/BerkieBb/qb-target)
- [qb-menu](https://github.com/qbcore-framework/qb-menu)

# Installation
- Find this in qb-target/init.lua
- Put this in "Config.TargetModels" (more reliable to always keep target models in config)
```lua
  -- QB Rental
  ["VehicleRental"] = {
      models = {
          `a_m_y_business_03`,
      },
      options = {
          {
              type = "client",
              event = "qb-rental:client:openMenu",
              icon = "fas fa-car",
              label = "Rent Vehicle",
              MenuType = "vehicle"
          },
      },
      distance = 3.0
  },
  ["AircraftRental"] = {
      models = {
          `s_m_y_airworker`,
      },
      options = {
          {
              type = "client",
              event = "qb-rental:client:openMenu",
              icon = "fas fa-plane",
              label = "Rent Aircraft",
              MenuType = "aircraft"
          },
      },
      distance = 3.0
  },
  ["Boatrental"] = {
      models = {
          `mp_m_boatstaff_01`,
      },
      options = {
          {
              type = "client",
              event = "qb-rental:client:openMenu",
              icon = "fas fa-ship",
              label = "Rent Boat",
              MenuType = "boat"
          },
      },
      distance = 3.0
  },
  ```
 
# Rental Papers Item
 
 ```lua
  ["rentalpapers"]				 = {["name"] = "rentalpapers", 					["label"] = "Rental Papers", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "rentalpapers.png", 		["unique"] = true, 		["useable"] = false, 	["shouldClose"] = false, 	["combinable"] = nil, 	["description"] = "Yea, this is my car i can prove it!"},
  ```
  # Rental Papers Item Description - qb-inventory/html/js/app.js (Line 577)
  
 ```lua
   } else if (itemData.name == "stickynote") {
            $(".item-info-title").html('<p>' + itemData.label + '</p>')
            $(".item-info-description").html('<p>' + itemData.info.label + '</p>');
        } else if (itemData.name == "rentalpapers") {
            $(".item-info-title").html('<p>' + itemData.label + '</p>')
            $(".item-info-description").html('<p><strong>Name: </strong><span>'+ itemData.info.firstname + '</span></p><p><strong>Last Name: </strong><span>'+ itemData.info.lastname+ '</span></p><p><strong>Plate: </strong><span>'+ itemData.info.plate + '<p><strong>Model: </strong><span>'+ itemData.info.model +'</span></p>');
```
# Change Logs
- 1.0 - Initial Release

# Credits - [itsHyper](https://github.com/itsHyper) & elfishii 
