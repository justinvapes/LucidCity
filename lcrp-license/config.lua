Config                 = {}
Config.MaxErrors       = 5
Config.SpeedMultiplier = 2.236936

DrivingSchool = {
  coords = {x = 225.87, y = 374.97, z = 106.11},
}

Config.Prices = {
  dmv         = 200,
  drive       = 500,
  drive_bike  = 500,
  drive_truck = 500
}

Config.VehicleModels = {
  drive       = 'futo',
  drive_bike  = 'faggio',
  drive_truck = 'pounder'
}

Config.SpeedLimits = {
  residence = 50,
  town      = 60,
  freeway   = 80
}

Config.Zones = {

  DMVSchool = {
    Pos   = {x = 225.87, y = 374.97, z = 106.11},
    Size  = {x = 0.7, y = 1.0, z = 0.3},
    Color = {r = 204, g = 204, b = 204},
    Type  = 20
  },

  VehicleSpawnPoint = {
    Pos   = {x = 248.19, y = 380.72, z = 105.60},
    Size  = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 204, g = 204, b = 0},
    Type  = -1
  },

}

Config.CheckPoints = {
  {
    Pos = {x = 215.11, y = 367.16, z = 105.75},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      setCurrentZoneType('town')
      
      DrawMissionText('Drive to the next point, speed limit: ' .. Config.SpeedLimits['town'] .. ' mph/h', 5000)
    end
  },

  {
    Pos = {x = 234.41, y = 347.50, z = 105.03},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Watch traffic light, and turn on your lights!', 5000)
    end
  },

  {
    Pos = {x = 213.13, y = 218.73, z = 105.08},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Good job, now turn left', 5000)
    end
  },

  {
    Pos = {x = 341.46, y = 139.41, z = 102.62},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Drive to the next point', 5000)
    end
  },

  {
    Pos = {x = 489.58, y = 86.19, z = 95.98},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Drive to the next point', 5000)
    end
  },

  {
    Pos = {x = 673.67, y = 21.89, z = 83.82},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Now turn left', 5000)
    end
  },

  {
    Pos = {x = 781.29, y = 136.25, z = 79.59},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Drive to the next point', 5000)
    end
  },

  {
    Pos = {x = 1017.40, y = 475.84, z = 95.78},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Stop at a stop sign and then turn right', 5000)
    end
  },

  {
    Pos = {x = 1078.54, y = 435.43, z = 91.04},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Drive to the next point', 5000)
    end
  },

  {
    Pos = {x = 1127.59, y = 390.18, z = 90.93},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Turn left', 5000)
    end
  },

  {
    Pos = {x = 1244.98, y = 510.87, z = 80.64},
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('freeway')

      DrawMissionText('It\'s time to drive on the highway! Speed Limit: ' .. Config.SpeedLimits['freeway'] .. ' mph/h', 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = 1551.62, y = 909.56, z = 77.13},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Drive to the next point, speed limit:', 5000)
    end
  },

  {
    Pos = {x = 1617.57, y = 1101.62, z = 81.35},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Stop for passing vehicles and then turn around', 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      FreezeEntityPosition(vehicle, true)
      Citizen.Wait(3000)
      FreezeEntityPosition(vehicle, false)
    end
  },

  {
    Pos = {x = 1601.03, y = 1069.85, z = 80.34},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Good job, drive to the next point', 5000)
    end
  },

  {
    Pos = {x = 1364.68, y = 667.05, z = 79.52},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Drive to the next point', 5000)
    end
  },

  {
    Pos = {x = 1241.14, y = 556.74, z = 80.41},
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('town')

      DrawMissionText('Entered town, pay attention to your speed! Speed Limit: ' .. Config.SpeedLimits['town'] .. ' mph/h', 5000)
    end
  },

  {
    Pos = {x = 1099.64, y = 440.63, z = 90.91},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Stop for traffic light and then turn right', 5000)
    end
  },

  {
    Pos = {x = 1037.91, y = 480.50, z = 94.73},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Stop at a stop sign and then drive forward', 5000)
    end
  },

  {
    Pos = {x = 918.86, y = 529.69, z = 119.39},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Turn left', 5000)
    end
  },

  {
    Pos = {x = 576.38, y = 263.75, z = 102.58},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Stop for traffic light and then turn right', 5000)
    end
  },

  {
    Pos = {x = 438.20, y = 293.30, z = 102.45},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Drive to the next point', 5000)
    end
  },

  {
    Pos = {x = 276.54, y = 337.96, z = 104.97},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Drive to the next point', 5000)
    end
  },

  {
    Pos = {x = 216.24, y = 370.97, z = 105.81},
    Action = function(playerPed, vehicle, setCurrentZoneType)

      scCore.Functions.DeleteVehicle(vehicle)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

}
