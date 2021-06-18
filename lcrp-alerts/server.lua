scCore = nil
TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)

RegisterNetEvent('lcrp-alerts:server:AddPoliceAlert')
AddEventHandler('lcrp-alerts:server:AddPoliceAlert', function(data, forBoth)
    forBoth = forBoth ~= nil and forBoth or false
    TriggerClientEvent('lcrp-alerts:client:AddPoliceAlert', -1, data, forBoth)
end)