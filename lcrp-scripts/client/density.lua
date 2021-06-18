local pedDensity = 0.8
local vehicleDensity = 0.2

Citizen.CreateThread(function()
	while true do
		SetVehicleDensityMultiplierThisFrame(vehicleDensity) -- VEHICLE DENSITY
	    SetPedDensityMultiplierThisFrame(pedDensity) -- PEDS DENSITY
	    SetParkedVehicleDensityMultiplierThisFrame(vehicleDensity) -- PARKED VEHICLE DENSITY
		SetScenarioPedDensityMultiplierThisFrame(pedDensity, pedDensity) -- PED MOVING DENSITY
		Citizen.Wait(5000)
	end
end)