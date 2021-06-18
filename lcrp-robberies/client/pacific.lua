RegisterNetEvent('lcrp-robberies:UseBankcardB')
AddEventHandler('lcrp-robberies:UseBankcardB', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local pacificEletronicLocker = vector3(261.86, 223.15, 106.28)
    local dist = GetDistanceBetweenCoords(pos, pacificEletronicLocker,true)
    if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    if closestBank ~= nil and closestBank == 'pacific' then
        local bank = Config.Banks[closestBank]
        if dist < 1.5 and not bank.isOpened then
            
            TriggerServerEvent("lcrp-robberies:server:CanStartRobbery", "security_card_02", closestBank)
        end
    end 
end)