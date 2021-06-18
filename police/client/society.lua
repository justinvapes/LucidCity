scCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if scCore == nil then
            TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

PlayerData = {}
PlayerJob = {}
societyMenu = false
ownableBiz = nil

RegisterNetEvent("scCore:Client:OnPlayerLoaded")
AddEventHandler("scCore:Client:OnPlayerLoaded", function()
    PlayerData =  scCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    if PlayerJob.onduty then
        TriggerServerEvent('police:server:empOnDuty', PlayerData)
    end
    scCore.TriggerServerCallback('police:server:FetchOwnableBiz', function(result)
        if result ~= nil then
            ownableBiz = result
        end
    end)
end)

RegisterNetEvent("police:client:empOnDuty")
AddEventHandler("police:client:empOnDuty", function(data)
    TriggerServerEvent('police:server:empOnDuty', data)
end)



RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    PlayerData =  scCore.Functions.GetPlayerData()
    name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname
    citizenid = PlayerData.citizenid
    grade = PlayerData.job.grade
    if PlayerJob.onduty then
        TriggerServerEvent('police:server:empOnDuty', PlayerData)
    end
end)

RegisterNetEvent("police:server:OpenSocietyMenu")
AddEventHandler("police:server:OpenSocietyMenu", function(job)
    local src = source
    if PlayerJob.name == job then
        MenuSociety(job)
        Menu.hidden = not Menu.hidden
    end
    societyMenu = true
end)

RegisterNetEvent("police:client:BusinessTransaction")
AddEventHandler("police:client:BusinessTransaction", function(job, amount)
    TriggerServerEvent('police:server:BusinessTransaction', job, amount)
end)

Citizen.CreateThread(function()
    while true do
        if societyMenu then
            Menu.renderGUI()
        end
        Citizen.Wait(1)
    end
end)

function delPlateMenu(plate)
    ClearMenu()
    Menu.addButton("Delete plate "..plate[1].."-"..plate[2].."?", nil, nil)
    Menu.addButton("Yes", "delPlate", {true,plate[1]})
    Menu.addButton("Back", "MenuSociety", "airlines")
end
function delPlate(res)
    if res[1] then
        scCore.Notification("Plate removed!","success")
        TriggerServerEvent("police:server:deletePlate", res[2])
    end
    closeMenuFull()
    societyMenu = false
end

function MenuSociety(job)
    ped = GetPlayerPed(-1);
    ClearMenu()

    if job == "police" or job == "ambulance" or job == "statepolice" or job == "fib" then
        Menu.addButton("Society Fund", "societyFund", job)
        Menu.addButton("Workers", "workersList", job)
        Menu.addButton("On Duty", "onDutyEmp", job)
        Menu.addButton("Hire closest person", "hirePlayer", job)
        Menu.addButton("Close Menu", "closeMenuFull", nil) 
    else
        Menu.addButton("Society Fund", "societyFund", job)
        if job == "airlines" then
            Menu.addButton("Planes on Duty", "planesOnDuty", job)
        elseif job == "burgershot" then
            Menu.addButton('Item prices',"changePrices", job)
        elseif job == "arcadebar" then
            Menu.addButton('Ticket prices',"changePrices", job)
            Menu.addButton('Ticket time',"changeTime", job)
        elseif string.match(job, "gym") then
            Menu.addButton('Subscription prices',"changePrices", job)
        elseif job == "logistics" then
            Menu.addButton("Packages Stock", "packStock", job)
        end
        Menu.addButton("Workers", "workersList", job)
        Menu.addButton("Salaries", "salaries", job)
        Menu.addButton("On Duty", "onDutyEmp", job)
        Menu.addButton("Hire closest person", "hirePlayer", job)
        Menu.addButton("Close Menu", "closeMenuFull", nil) 
    end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function salaries(job)
    ClearMenu()
    scCore.TriggerServerCallback('police:server:GetSalariesByJob', function(salaries)
        for i = #salaries, 1, -1 do
            args = {name = salaries[i].name, index = i, salary = salaries[i].payment, job = job}
            Menu.addButton(salaries[i].name..": $"..salaries[i].payment, "updateSalary", args)
        end
        Menu.addButton("Close Menu", "closeMenuFull", nil)
    end, job)
end

function onDutyEmp(job)
    ClearMenu()
    scCore.TriggerServerCallback('police:server:getEmployeeStatus', function(emps, utcNow)
        local hasContent = false
        for k, v in pairs(emps) do
            hasContent = true
            Menu.addButton(emps[k].name.." | "..emps[k].grade, "onDutyEmpInfo", { emp = emps[k], utcNow = utcNow, job = job })
        end
        if not hasContent then
            Menu.addButton("No active employes", "closeMenuFull", nil)
        end
        Menu.addButton("Close Menu", "closeMenuFull", nil)
    end, job)
end


function onDutyEmpInfo(args)
    ClearMenu()
    local emp = args.emp
    local utcNow = args.utcNow
    if scCore.Shared.JobsWithRecords[emp.job] and emp.jobRecords ~= nil then
        Menu.addButton(emp.name .. " | " .. emp.grade, nil, nil)
        Menu.addButton("Routes Completed: " .. emp.jobRecords.routesCompleted, nil, nil)

        local timeOnDuty = scCore.Shared.TimePassedSinceTime(utcNow, emp.jobRecords.onDutyAt)
        Menu.addButton("On Duty For: " .. timeOnDuty, nil, nil)

        local timeSinceLastJob = scCore.Shared.TimePassedSinceTime(utcNow, emp.jobRecords.lastJobCompletedAt)
        Menu.addButton("Last Job: " .. timeSinceLastJob .. " ago", nil, nil)
    end
    Menu.addButton("Back", "onDutyEmp", args.job)
end

function updateSalary(args)
    amount = scCore.KeyboardInput("Enter new salary for "..args.name, "", 10)
    if amount ~= nil then
        if tonumber(amount) ~= nil then
            if tonumber(amount) > 1 then 
                TriggerServerEvent('police:server:UpdateSalary', args.job, args.index, math.ceil(tonumber(amount)))
            else
                scCore.Notification("Value needs to be greater than 0", "error")
            end
        else
            scCore.Notification("Introduce a valid number", "error")
        end
    else
        scCore.Notification("Invalid input", "error")
    end
    closeMenuFull()
end

function planesOnDuty(job)
    scCore.TriggerServerCallback("police:server:getPlanesOnDuty",function(results)
        ClearMenu()
        if #results == 0 then
            Menu.addButton("No Planes Flying at the moment!",nil,nil)
        else
            for k,v in pairs(results) do
                local data = json.decode(results[k].data)
                Menu.addButton("["..results[k].plate.."-"..data.plane.."] ".."taken by "..data.identifier, "delPlateMenu", {results[k].plate,data.plane})
            end
        end
        Menu.addButton("Back", "MenuSociety", job)
    end)
end

function packStock(job)
    scCore.TriggerServerCallback("police:server:getPackStock",function(stock)
        ClearMenu()
        Menu.addButton("Current Stock: " .. stock, "MenuSociety", job)  
        Menu.addButton("Back", "MenuSociety", job)
    end)
end

function changePrices(job)
    scCore.TriggerServerCallback("police:server:getItemPrices",function(results)
        ClearMenu()
        results = json.decode(results.prices)
        for k,v in pairs(results) do
            local name = ""
            if job == 'burgershot' then
                name = scCore.Shared.Items[v.name].label
            else
                name = v.name
            end
            Menu.addButton(name.." "..v.price.."$", "updatePrice", {name = v.name, job = job})
        end
        Menu.addButton("Back", "MenuSociety", job) 
    end, job)
end

function changeTime(job)
    scCore.TriggerServerCallback("police:server:getItemPrices",function(results)
        ClearMenu()
        results = json.decode(results.prices)
        for k,v in pairs(results) do
            Menu.addButton(v.name.." - "..v.time.."minutes", "updateTime", {name = v.name, job = job})
        end
        Menu.addButton("Back", "MenuSociety", job) 
    end, job)
end

function updateTime(info)
    local newTime = scCore.KeyboardInput("Set new time for "..info.name.." ticket", "", 10)
    newTime = tonumber(newTime)
    if newTime ~= nil then
        TriggerServerEvent('police:server:updateItemInfo', newTime, info, 'Time')
        scCore.Notification('Time Changed','success')
        MenuSociety(info.job)
    else
        scCore.Notification('Numbers only!','error')
    end
end

function updatePrice(info)
    local newPrice
    if info.job == 'burgershot' then
        newPrice = scCore.KeyboardInput("Set new price for "..scCore.Shared.Items[info.name].label, "", 3)
    else
        newPrice = scCore.KeyboardInput("Set new price for "..info.name.." ticket", "", 10)
    end
    newPrice = tonumber(newPrice)
    if newPrice ~= nil then
        TriggerServerEvent('police:server:updateItemInfo', newPrice, info, 'Price')
        scCore.Notification('Price Changed','success')
        MenuSociety(info.job)
    else
        scCore.Notification('Numbers only!','error')
    end
end

function workersList(job)
    scCore.TriggerServerCallback("police:server:workersList", function(workers)
        ClearMenu()
        if workers == nil then
            scCore.Notification("You have no employees", "error")
            closeMenuFull()
            societyMenu = false
        else  
            workers = sortByGrade(workers, 1)
            empPerPage = 12
            if #workers <= 12 then
                empPerPage = #workers
            else
                Menu.addButton("Next Page", "workersListNextPage", {workers = workers, page = 1, job = job})
            end
            
            for k=1,empPerPage do
                local charinfo = json.decode(workers[k].charinfo)
                local jobInfo = json.decode(workers[k].job)
                local jobRecords = workers[k].jobRecords
                local grade = jobInfo.grade
                if grade == nil then grade = 0 end
                local names = ""
                if charinfo ~= nil then
                    names = charinfo.firstname .. " " .. charinfo.lastname .. " | Grade: ".. grade
                end
                local charArgs = { workers[k].citizenid, job, grade, jobRecords }
                Menu.addButton("["..k.."] "..names, "workerOptions", charArgs)
            end
            --[[ for k, v in pairs(workers) do
                 
            end ]]
            Menu.addButton("Back", "MenuSociety", job)
        end
    end, job)
end

function workersListNextPage(data)
    ClearMenu()
    resultsPerPage = 12
    toShow = 1 + resultsPerPage * data.page
    if toShow + resultsPerPage < #data.workers then
        Menu.addButton("Next Page", "workersListNextPage", {workers = data.workers, page = data.page + 1, job = data.job })
    else
        resultsPerPage = #data.workers - toShow
    end    
    for k=toShow,toShow+resultsPerPage do
        if data.workers[k] == nil then break end
        local charinfo = json.decode(data.workers[k].charinfo)
        local jobInfo = json.decode(data.workers[k].job)
        local jobRecords = data.workers[k].jobRecords
        local grade = jobInfo.grade
        if grade == nil then grade = 0 end
        local names = ""
        if charinfo ~= nil then
            names = charinfo.firstname .. " " .. charinfo.lastname .. " | Grade: ".. grade
        end
        local charArgs = { data.workers[k].citizenid, data.job, grade, jobRecords }
        Menu.addButton("["..k.."] "..names, "workerOptions", charArgs)
    end
    if data.page == 0 then
        Menu.addButton("Back", "MenuSociety", data.job)
    else
        Menu.addButton("Previous Page", "workersListNextPage", {workers = data.workers, page = data.page - 1, job = data.job })
    end
end

function sortByGrade(mytable, type)
    if type == 1 then
        table.sort(mytable, function(a,b)
            a = json.decode(a.job)
            b = json.decode(b.job)
            agrade = json.encode(a.grade)
            bgrade = json.encode(b.grade)
            if agrade == nil or agrade == 'null' then
                agrade = 0
            end
            if bgrade == nil or bgrade == 'null' then
                bgrade = 0
            end
            return tonumber(agrade) > tonumber(bgrade) 
        end)
        return mytable
    else
        table.sort(mytable, function(a,b)
            a = json.decode(a.grade)
            b = json.decode(b.grade)
            agrade = json.encode(a)
            bgrade = json.encode(b)
            if agrade == nil or agrade == 'null' then
                agrade = 0
            end
            if bgrade == nil or bgrade == 'null' then
                bgrade = 0
            end
            return tonumber(agrade) > tonumber(bgrade) 
        end)
        return mytable
    end
end

function workerOptions(charArgs)
    ped = GetPlayerPed(-1);
    ClearMenu()
    if PlayerData ~= nil then
        if (scCore.Shared.JobsWithRecords[charArgs[2]]) then
            if charArgs[4] ~= nil then
                Menu.addButton("Routes Completed: " .. charArgs[4].routesCompleted, nil, nil)
            else
                Menu.addButton("Routes Completed: unknown", nil, nil)
            end
        end
        if PlayerData.citizenid == charArgs[1] then
            Menu.addButton("Back", "workersList", charArgs[2])
        else
            Menu.addButton("Fire", "firePlayer", charArgs) 
            Menu.addButton("Promote/Demote", "roleMenu", charArgs) 
            Menu.addButton("Back", "workersList", charArgs[2]) 
        end
    end
end

function firePlayer(charArgs)
    ClearMenu()
    closeMenuFull()
    societyMenu = false
    TriggerServerEvent("police:server:FirePlayer", charArgs[1], charArgs[2])
end


function hirePlayer(job)
    ClearMenu()
    closeMenuFull()
    societyMenu = false
    local closestPlayer, closestDistance = GetClosestPlayer()
    local playerId = GetPlayerServerId(closestPlayer)
    TriggerServerEvent("police:server:HirePlayer", job, playerId, closestDistance)
end

function GetClosestPlayer()
    local closestPlayers = scCore.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

function roleMenu(charArgs)
    ClearMenu()
    local jobData = scCore.Shared.Jobs[charArgs[2]].roles
    for i = #jobData, 1, -1 do
        local charArgs = {charArgs[1], charArgs[2], i}
        Menu.addButton(jobData[i].name, "changeRole", charArgs) 
    end
    Menu.addButton("Back", "workerOptions", charArgs) 
end

function changeRole(charArgs)
    ClearMenu()
    closeMenuFull()
    societyMenu = false
    TriggerServerEvent("police:server:changeRole", charArgs[1], charArgs[2], charArgs[3])
end

function societyFund(job)
    ClearMenu()

    scCore.TriggerServerCallback("police:server:FetchSocietyFund", function(result)
        if result ~= nil then
            if result.money ~= nil then
                Menu.addButton(firstToUpper(job).. " | $" ..result.money, "menuTitle", result.money)
                Menu.addButton("Withdraw", "withdrawFund", job) 
                Menu.addButton("Deposit", "depositFund", job) 
                Menu.addButton("Close Menu", "closeMenuFull", nil)
            end 
        else
            Menu.addButton(firstToUpper(job).. " | $" ..0, "menuTitle", 0)
            Menu.addButton("Withdraw", "withdrawFund", job) 
            Menu.addButton("Deposit", "depositFund", job) 
            Menu.addButton("Close Menu", "closeMenuFull", nil)
        end
    end, job)
end

function withdrawFund(job)
    ClearMenu()
    closeMenuFull()
    societyMenu = false
    amount = scCore.KeyboardInput("Enter amount to withdraw", "", 10)
    amount = tonumber(amount)

    if amount > 0 then
        TriggerServerEvent("police:server:WithdrawSocietyFunds", job, amount)
    end
end

function depositFund(job)
    ClearMenu()
    closeMenuFull()
    societyMenu = false
    amount = scCore.KeyboardInput("Enter amount to deposit", "", 10)
    amount = tonumber(amount)

    if amount and amount > 0 then
        TriggerServerEvent("police:server:DepositSocietyFunds", job, amount)
    end
end

function menuTitle(label)
    print(label)
end

RegisterNetEvent("scCore:Client:UpdateOwnableBiz")
AddEventHandler("scCore:Client:UpdateOwnableBiz", function(result)
    ownableBiz = result
end)

local allBlips = {}

Citizen.CreateThread(function()
    local blips = false
    while true do
        inRange = false
        if ownableBiz ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            for k, v in pairs(ownableBiz) do
                    if (GetDistanceBetweenCoords(pos, v.position.x, v.position.y, v.position.z, true) < 5) then
                        inRange = true
                        if (GetDistanceBetweenCoords(pos, v.position.x, v.position.y, v.position.z, true) < 1.5) then
                                DrawText3D(v.position.x, v.position.y, v.position.z, "~g~[E]~w~ - Buy ".. v.name.. " for $"..v.price)
                            if IsControlJustReleased(0, Keys["E"]) then
                                biznu = ownableBiz[k]
                                scCore.TriggerServerCallback('police:server:buyCompany', function(result)
                                    if result ~= nil then
                                        if result then
                                            RemoveBlip(allBlips[biznu.name])
                                            allBlips[biznu.name] = nil
                                            TriggerServerEvent('police:server:CreateCompany', biznu)
                                            scCore.TriggerServerCallback("police:server:FetchSocietyFund", function(result)
                                            end, biznu.name)
                                        end
                                    end
                                end, v.price, v.name)
                                
                            end
                        elseif (GetDistanceBetweenCoords(pos, v.position.x, v.position.y, v.position.z, true) < 2.5) then
                            DrawText3D(v.x, v.y, v.z, "Buy ".. v.name.. " for $"..v.price)
                        end
                    end 
                    if not blips then
                        allBlips[v.name] = AddBlipForCoord(v.position.x, v.position.y, v.position.z)
                        SetBlipColour(allBlips[v.name], 0)
                        SetBlipSprite(allBlips[v.name], 106)
                        SetBlipScale(allBlips[v.name], 0.5)
                        SetBlipColour(allBlips[v.name], 51)
                        SetBlipDisplay(allBlips[v.name], 4)
                        SetBlipAsShortRange(allBlips[v.name], true)
                    

                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentSubstringPlayerName("Buy business: "..v.name)
                        EndTextCommandSetBlipName(allBlips[v.name])
                    end
            end
            blips = true
        end
        if not inRange then
            Citizen.Wait(3000)
        end
        Citizen.Wait(1)
    end
end)
