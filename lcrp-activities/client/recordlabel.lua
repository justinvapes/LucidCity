Citizen.CreateThread(function()
    local blip = AddBlipForCoord(-436.67, 171.58, 78.86)
    SetBlipSprite(blip, 614)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 27)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Lucid City Radio")
    EndTextCommandSetBlipName(blip)


    local blip = AddBlipForCoord(354.86, 300.80, 104.03)
    SetBlipSprite(blip, 136)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 27)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Galaxy Club")
    EndTextCommandSetBlipName(blip)

    local blip = AddBlipForCoord(-431.98, -23.96, 46.19)
    SetBlipSprite(blip, 136)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 73)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cockatoos Club")
    EndTextCommandSetBlipName(blip)

    
    local blip = AddBlipForCoord(-1388.19, -587.09, 30.21)
    SetBlipSprite(blip, 93)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 27)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Bahamas Mamas")
    EndTextCommandSetBlipName(blip)
    
end)