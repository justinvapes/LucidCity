RegisterNetEvent('lcrp-robberies:UseBankcardA')
AddEventHandler('lcrp-robberies:UseBankcardA', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local dist = GetDistanceBetweenCoords(pos, Config.Banks["paleto"]["coords"]["x"], Config.Banks["paleto"]["coords"]["y"],Config.Banks["paleto"]["coords"]["z"])
    if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    if closestBank ~= nil and closestBank == 'paleto' then
        local bank = Config.Banks[closestBank]
        if dist < 1.5 and not bank.isOpened then
            TriggerServerEvent("lcrp-robberies:server:CanStartRobbery", "security_card_01", closestBank)
        end
    end 
end)