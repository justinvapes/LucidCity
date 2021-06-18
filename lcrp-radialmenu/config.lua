scCore = nil

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

Config = {}

Config.TrunkClasses = {
    [0]  = { allowed = true, x = 0.0, y = -1.5, z = 0.0 }, --Coupes  
    [1]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Sedans  
    [2]  = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --SUVs  
    [3]  = { allowed = true, x = 0.0, y = -1.5, z = 0.0 }, --Coupes  
    [4]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Muscle  
    [5]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Sports Classics  
    [6]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Sports  
    [7]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Super  
    [8]  = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Motorcycles  
    [9]  = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Off-road  
    [10] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Industrial  
    [11] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Utility  
    [12] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Vans  
    [13] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Cycles  
    [14] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Boats  
    [15] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Helicopters  
    [16] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Planes  
    [17] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Service  
    [18] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Emergency  
    [19] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Military  
    [20] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Commercial  
    [21] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Trains  
}

Config.offsets = {

	[1] = { ["name"] = "vic", ["yoffset"] = 0.0, ["zoffset"] = -0.5 },

	[2] = { ["name"] = "taxi", ["yoffset"] = 0.0, ["zoffset"] = -0.5 },

    [3] = { ["name"] = "buccaneer", ["yoffset"] = 0.5, ["zoffset"] = 0.0 },

    [4] = { ["name"] = "peyote", ["yoffset"] = 0.35, ["zoffset"] = -0.15 },

    [5] = { ["name"] = "regina", ["yoffset"] = 0.2, ["zoffset"] = -0.35 },

    [6] = { ["name"] = "pigalle", ["yoffset"] = 0.2, ["zoffset"] = -0.15 },

    [7] = { ["name"] = "glendale", ["yoffset"] = 0.0, ["zoffset"] = -0.35 },

}

local PlayerJob = {}
local isJudge = false
local isPolice = false
local isMedic = false
local isDoctor = false
local isNews = false
local isInstructorMode = false
local myJob = "unemployed"
local isHandcuffed = false
local isHandcuffedAndWalking = false
local hasOxygenTankOn = false
local gangNum = 0
local cuffStates = {}

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    PlayerJob = scCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    local OldlayerJob = PlayerJob.name
    PlayerJob = JobInfo
end)
 
rootMenuConfig =  {
    {
        id = "general",
        displayName = "General interactions",
        icon = "#globe-europe",
        enableMenu = function()
        isPlayerDead = exports["hospital"]:isPlayerDead()
            return not isPlayerDead
        end,
        subMenus = {"general:flipvehicle",  "general:keysgive",  --[["general:emotes",--]] "general:giveNumber", "general:giveBank", "general:getInTrunk", "general:cornerselling"  }
    },
    {
        id = "player",
        displayName = "Player interactions",
        icon = "#users",
        enableMenu = function()
        isPlayerDead = exports["hospital"]:isPlayerDead()
            return not isPlayerDead
        end,
        subMenus = {"player:handcuff",  "player:putInVehicle",  "player:playerOutVehicle", "player:rob", "player:escort"  }
    },
    {
        id = "animations",
        displayName = "Walking Styles",
        icon = "#walking",
        enableMenu = function()
        isPlayerDead = exports["hospital"]:isPlayerDead()
            return not isPlayerDead
        end,
        subMenus = { "animations:brave", "animations:hurry", "animations:business", "animations:tipsy", "animations:injured","animations:tough", "animations:default", "animations:hobo", "animations:money", "animations:swagger", "animations:shady", "animations:maneater", "animations:chichi", "animations:sassy", "animations:sad", "animations:posh", "animations:alien" }
    },
    {
        id = "expressions",
        displayName = "Expressions",
        icon = "#expressions",
        enableMenu = function()
        isPlayerDead = exports["hospital"]:isPlayerDead()
            return not isPlayerDead
        end,
        subMenus = { "expressions:normal", "expressions:drunk", "expressions:angry", "expressions:dumb", "expressions:electrocuted", "expressions:grumpy", "expressions:happy", "expressions:injured", "expressions:joyful", "expressions:mouthbreather", "expressions:oneeye", "expressions:shocked", "expressions:sleeping", "expressions:smug", "expressions:speculative", "expressions:stressed", "expressions:sulking", "expressions:weird", "expressions:weird2"}
    },
    {
        id = "pet",
        displayName = "Pet Interactions",
        icon = "#paw",
        enableMenu = function()
        isPlayerDead = exports["hospital"]:isPlayerDead()
            return not isPlayerDead
        end,
        subMenus = {"pet:call","pet:dismiss","pet:feed","pet:follow","pet:unfollow","pet:getInCar","pet:reset","pet:sit","pet:lay","pet:bark","pet:paw","pet:taunt","pet:defend"}
    },

    -- JOBS
    {
        id = "police-action",
        displayName = "Police Actions",
        icon = "#police-action",
        enableMenu = function()
           local ped = PlayerPedId()
           
           isPlayerDead = exports["hospital"]:isPlayerDead()
            if PlayerJob.name == "police" and not isPlayerDead then
                return true
            end
        end,
        subMenus = {"police:emergencybutton", "police:lockpick", "police:checkvehstatus", "police:checkstatus", "police:searchplayer", "police:jailplayer", "police:openmdt", "police:impound", "police:revive", "police:SpawnSpikeStrip"}
    },
    {
        id = "fib-action",
        displayName = "FIB Actions",
        icon = "#fib-action",
        enableMenu = function()
           local ped = PlayerPedId()
           
           isPlayerDead = exports["hospital"]:isPlayerDead()
            if PlayerJob.name == "fib" and not isPlayerDead then
                return true
            end
        end,
        subMenus = {"police:emergencybutton", "police:checkvehstatus", "police:checkstatus", "police:searchplayer", "police:jailplayer", "police:openmdt", "police:impound", "police:revive", "police:lockpick"}
    },
    {
        id = "statepolice-action",
        displayName = "State PD Actions",
        icon = "#statepolice-action",
        enableMenu = function()
           local ped = PlayerPedId()
           
           isPlayerDead = exports["hospital"]:isPlayerDead()
            if PlayerJob.name == "statepolice" and not isPlayerDead then
                return true
            end
        end,
        subMenus = {"police:emergencybutton", "police:checkvehstatus", "police:checkstatus", "police:searchplayer", "police:jailplayer", "police:openmdt", "police:impound", "police:revive", "police:lockpick"}
    },
     {
         id = "mechanic",
         displayName = "Mechanic",
        icon = "#mechanic",
         enableMenu = function()
        local ped = PlayerPedId()
           
           isPlayerDead = exports["hospital"]:isPlayerDead()
             if string.match(PlayerJob.name, "mechanic") and not isPlayerDead then
                 return true
             end
         end,
         subMenus = {"mechanic:repairvehicle", "mechanic:repairengine", "mechanic:cleanvehicle", "mechanic:togglenpc", "mechanic:towvehicle", "mechanic:impound", "mechanic:clean" }
     },
    {
        id = "taxi",
        displayName = "Taxi",
        icon = "#taxi",
        enableMenu = function()
        local ped = PlayerPedId()
           
           isPlayerDead = exports["hospital"]:isPlayerDead()
            if PlayerJob.name == "taxi" and not isPlayerDead then
                return true
            end
        end,
        subMenus = {"taxi:togglemeter", "taxi:togglemouse", "taxi:togglenpc" }
    },
    {
        id = "medic",
        displayName = "EMS",
        icon = "#medic",
        enableMenu = function()
        local ped = PlayerPedId()
           
           isPlayerDead = exports["hospital"]:isPlayerDead()
            if PlayerJob.name == "ambulance" and not isPlayerDead then
                return true
            end
        end,
        subMenus = {"ems:statuscheck", "ems:treatwounds", "ems:emergencybutton", "ems:escort", "ems:wheelchair", "ems:delwheelchair" }
    },
    {
        id = "doctor",
        displayName = "Doctor",
        icon = "#medic",
        enableMenu = function()
        local ped = PlayerPedId()
           
           isPlayerDead = exports["hospital"]:isPlayerDead()
            if PlayerJob.name == "doctor" and not isPlayerDead then
                return true
            end
        end,
        subMenus = {"ems:statuscheck", "ems:treatwounds", "ems:emergencybutton", "ems:escort", "ems:wheelchair", "ems:delwheelchair" }
    },
}

newSubMenus = {
    ['pet:call'] = {
        title = "Call pet",
        icon = "#dog",
        functionName = "lcrp-pets:client:callPet"
    },
    ['pet:dismiss'] = {
        title = "Dismiss pet",
        icon = "#hand-paper",
        functionName = "lcrp-pets:client:dismissPet"
    },  
    ['pet:feed'] = {
        title = "Feed pet",
        icon = "#bone",
        functionName = "lcrp-pets:client:feedPet"
    }, 
    ['pet:follow'] = {
        title = "Come!",
        icon = "#thumbs-up",
        functionName = "lcrp-pets:client:petFollow"
    },
    ['pet:unfollow'] = {
        title = "Stay!",
        icon = "#thumbs-down",
        functionName = "lcrp-pets:client:petUnfollow"
    },
    ['pet:getInCar'] = {
        title = "Command enter car",
        icon = "#car",
        functionName = "lcrp-pets:client:enterCarPet"
    },
    ['pet:defend'] = {
        title = "Toggle defense mode",
        icon = "#user-shield",
        functionName = "lcrp-pets:client:toggleDefendMode"
    },
    ['pet:reset'] = {
        title = "Cancel command",
        icon = "#ban",
        functionName = "lcrp-pets:client:resetPet"
    }, 
    ['pet:sit'] = {
        title = "Order sit",
        icon = "#hand-point-down",
        functionName = "lcrp-pets:client:sitPet"
    }, 
    ['pet:lay'] = {
        title = "Order lay down",
        icon = "#hand-holding",
        functionName = "lcrp-pets:client:layPet"
    },
    ['pet:bark'] = {
        title = "Order bark",
        icon = "#bark",
        functionName = "lcrp-pets:client:barkPet"
    },
    ['pet:paw'] = {
        title = "Order paw",
        icon = "#paw",
        functionName = "lcrp-pets:client:pawPet"
    },
    ['pet:taunt'] = {
        title = "Order taunt",
        icon = "#animation-shady",
        functionName = "lcrp-pets:client:tauntPet"
    },
    ['general:emotes'] = {
        title = "Emotes",
        icon = "#general-emotes",
        functionName = "dp:RecieveMenu"
    },    
    ['general:keysgive'] = {
        title = "Give Key",
        icon = "#general-keys-give",
        functionName = "vehiclekeys:client:GiveKeys"
    },

    ['general:flipvehicle'] = {
        title = "Flip Vehicle",
        icon = "#general-flip-vehicle",
        functionName = "lcrp-vehicles:client:flipVehicle"
    },
    ['general:flipvehicle'] = {
        title = "Flip Vehicle",
        icon = "#general-flip-vehicle",
        functionName = "lcrp-vehicles:client:flipVehicle"
    },
    ['general:giveNumber'] = {
        title = "Give Number",
        icon = "#general-number-give",
        functionName = "lcrp-phone:client:giveNumber"
    },
    ['general:giveBank'] = {
        title = "Give Bank Number",
        icon = "#general-bank-number-give",
        functionName = "lcrp-phone:client:giveBankAccount"
    },
    ['general:getInTrunk'] = {
        title = "Get In Trunk",
        icon = "#general-car",
        functionName = "lcrp-trunk:client:GetIn"
    },
    ['general:cornerselling'] = {
        title = "Sell Drugs",
        icon = "#general-drugs",
        functionName = "lcrp-interact:client:sellingDrugs"
    },

    ['player:handcuff'] = {
        title = "Handcuff",
        icon = "#player-cuff",
        functionName = "police:client:CuffPlayerSoft"
    },
    ['player:putInVehicle'] = {
        title = "Put in vehicle",
        icon = "#player-put-in-vehicle",
        functionName = "police:client:PutPlayerInVehicle"
    },
    ['player:playerOutVehicle'] = {
        title = "Out of vehicle",
        icon = "#player-put-in-vehicle",
        functionName = "police:client:SetPlayerOutVehicle"
    },
    ['player:rob'] = {
        title = "Rob player",
        icon = "#player-rob",
        functionName = "police:client:RobPlayer"
    },
    ['player:escort'] = {
        title = "Escort",
        icon = "#player-escort",
        functionName = "police:client:EscortPlayer"
    },
    ['police:SpawnSpikeStrip'] = {
        title = "Spike Strip",
        icon = "#police:SpawnSpikeStrip",
        functionName = "police:client:SpawnSpikeStrip"
    },
    ['police:emergencybutton'] = {
        title = "Emergency Button",
        icon = "#police:emergency",
        functionName = "police:client:SendPoliceEmergencyAlert"
    },
    ['police:checkvehstatus'] = {
        title = "Check Tune",
        icon = "#police:veh-status",
        functionName = "lcrp-tunerchip:server:TuneStatus"
    },
    ['police:checkstatus'] = {
        title = "Evidence Check",
        icon = "#police:evidence-status",
        functionName = "police:client:CheckStatus"
    },
    ['police:searchplayer'] = {
        title = "Search player",
        icon = "#police:search",
        functionName = "police:client:SearchPlayer"
    },
    ['police:jailplayer'] = {
        title = "Jail player",
        icon = "#police:jail",
        functionName = "police:client:JailPlayer"
    },
    ['police:lockpick'] = {
        title = "Lockpick",
        icon = "#police:lockpick",
        functionName = "lockpicks:UseLockpick",
        functionParameters = true
    },
    ['police:openmdt'] = {
        title = "MDT",
        icon = "#judge-licenses-grant-business",
        functionName = "lcrp-radialmenu:client:openMDT"
    },
    ['police:impound'] = {
        title = "Impound",
        icon = "#police:impound",
        functionName = "police:client:ImpoundVehicle",
        functionParameters = false
    },
    ['police:revive'] = {
        title = "Revive",
        icon = "#police:revive",
        functionName = "lcrp-radialmenu:client:PoliceRevive",
        functionParameters = true
    },

    ['mechanic:repairvehicle'] = {
        title = "Repair Vehicle",
        icon = "#mechanic:repair-vehicle",
        functionName = "vehiclefailure:client:RepairVehicleMechanic"
    },
    ['mechanic:repairengine'] = {
        title = "Repair Engine",
        icon = "#mechanic:repair-engine",
        functionName = "vehiclefailure:client:RepairVehicle"
    },
    ['mechanic:togglenpc'] = {
        title = "Start Tow job",
        icon = "#mechanic:tow-job",
        functionName = "jobs:client:ToggleNpc"
    },
    ['mechanic:towvehicle'] = {
        title = "Tow Vehicle",
        icon = "#mechanic:tow-vehicle",
        functionName = "lcrp-tow:client:TowVehicle"
    },
    ['mechanic:impound'] = {
        title = "Impound Vehicle",
        icon = "#mechanic:impound",
        functionName = "lcrp-tow:client:Impound"
    },
    ['mechanic:clean'] = {
        title = "Clean Vehicle",
        icon = "#mechanic:clean",
        functionName = "vehiclefailure:client:CleanVehicle"
    },

    ['taxi:togglemeter'] = {
        title = "Open Meter",
        icon = "#taxi:meter",
        functionName = "lcrp-taxi:client:toggleMeter"
    },
    ['taxi:togglemouse'] = {
        title = "Toggle Meter",
        icon = "#taxi:toggle-meter",
        functionName = "lcrp-taxi:client:enableMeter"
    },
    ['taxi:togglenpc'] = {
        title = "Start Job",
        icon = "#taxi:npc-job",
        functionName = "lcrp-taxi:client:DoTaxiNpc"
    },

    ['ems:statuscheck'] = {
        title = "Check Wounds",
        icon = "#medic:check-wounds",
        functionName = "hospital:client:CheckStatus"
    },
    ['ems:treatwounds'] = {
        title = "Treat wounds",
        icon = "#medic-revive",
        functionName = "hospital:client:TreatWounds"
    },
    ['ems:emergencybutton'] = {
        title = "Emergency button",
        icon = "#medic:emergency",
        functionName = "police:client:SendPoliceEmergencyAlert"
    },
    ['ems:escort'] = {
        title = "Escort",
        icon = "#player-escort",
        functionName = "police:client:EscortPlayer"
    },
    ['ems:wheelchair'] = {
        title = "Spawn Wheelchair",
        icon = "#medic-wheelchair",
        functionName = "lcrp-scripts:Client:spawnWheelChair"
    },
    ['ems:delwheelchair'] = {
        title = "Delete Wheelchair",
        icon = "#medic-wheelchair",
        functionName = "lcrp-scripts:Client:removeWheelChair"
    },

    ['animations:brave'] = {
        title = "Brave",
        icon = "#animation-brave",
        functionName = "AnimSet:Brave"
    },
    ['animations:hurry'] = {
        title = "Hurry",
        icon = "#animation-hurry",
        functionName = "AnimSet:Hurry"
    },
    ['animations:business'] = {
        title = "Business",
        icon = "#animation-business",
        functionName = "AnimSet:Business"
    },
    ['animations:tipsy'] = {
        title = "Tipsy",
        icon = "#animation-tipsy",
        functionName = "AnimSet:Tipsy"
    },
    ['animations:injured'] = {
        title = "Injured",
        icon = "#animation-injured",
        functionName = "AnimSet:Injured"
    },
    ['animations:tough'] = {
        title = "Tough",
        icon = "#animation-tough",
        functionName = "AnimSet:ToughGuy"
    },
    ['animations:sassy'] = {
        title = "Sassy",
        icon = "#animation-sassy",
        functionName = "AnimSet:Sassy"
    },
    ['animations:sad'] = {
        title = "Sad",
        icon = "#animation-sad",
        functionName = "AnimSet:Sad"
    },
    ['animations:posh'] = {
        title = "Posh",
        icon = "#animation-posh",
        functionName = "AnimSet:Posh"
    },
    ['animations:alien'] = {
        title = "Alien",
        icon = "#animation-alien",
        functionName = "AnimSet:Alien"
    },
    ['animations:nonchalant'] =
    {
        title = "Nonchalant",
        icon = "#animation-nonchalant",
        functionName = "AnimSet:NonChalant"
    },
    ['animations:hobo'] = {
        title = "Hobo",
        icon = "#animation-hobo",
        functionName = "AnimSet:Hobo"
    },
    ['animations:money'] = {
        title = "Money",
        icon = "#animation-money",
        functionName = "AnimSet:Money"
    },
    ['animations:swagger'] = {
        title = "Swagger",
        icon = "#animation-swagger",
        functionName = "AnimSet:Swagger"
    },
    ['animations:shady'] = {
        title = "Shady",
        icon = "#animation-shady",
        functionName = "AnimSet:Shady"
    },
    ['animations:maneater'] = {
        title = "Man Eater",
        icon = "#animation-maneater",
        functionName = "AnimSet:ManEater"
    },
    ['animations:chichi'] = {
        title = "ChiChi",
        icon = "#animation-chichi",
        functionName = "AnimSet:ChiChi"
    },
    ['animations:default'] = {
        title = "Default",
        icon = "#animation-default",
        functionName = "AnimSet:default"
    },
    ['news:setCamera'] = {
        title = "Camera",
        icon = "#news-job-news-camera",
        functionName = "camera:setCamera"
    },
    ['news:setMicrophone'] = {
        title = "Microphone",
        icon = "#news-job-news-microphone",
        functionName = "camera:setMic"
    },
    ['news:setBoom'] = {
        title = "Microphone Boom",
        icon = "#news-job-news-boom",
        functionName = "camera:setBoom"
    },
    ['weed:currentStatusServer'] = {
        title = "Request Status",
        icon = "#weed-cultivation-request-status",
        functionName = "weed:currentStatusServer"
    },   
    ['weed:weedCrate'] = {
        title = "Remove A Crate",
        icon = "#weed-cultivation-remove-a-crate",
        functionName = "weed:weedCrate"
    },
    ['cocaine:currentStatusServer'] = {
        title = "Request Status",
        icon = "#meth-manufacturing-request-status",
        functionName = "cocaine:currentStatusServer"
    },
    ['cocaine:methCrate'] = {
        title = "Remove A Crate",
        icon = "#meth-manufacturing-remove-a-crate",
        functionName = "cocaine:methCrate"
    },
    ["expressions:angry"] = {
        title="Angry",
        icon="#expressions-angry",
        functionName = "expressions",
        functionParameters =  { "mood_angry_1" }
    },
    ["expressions:drunk"] = {
        title="Drunk",
        icon="#expressions-drunk",
        functionName = "expressions",
        functionParameters =  { "mood_drunk_1" }
    },
    ["expressions:dumb"] = {
        title="Dumb",
        icon="#expressions-dumb",
        functionName = "expressions",
        functionParameters =  { "pose_injured_1" }
    },
    ["expressions:electrocuted"] = {
        title="Electrocuted",
        icon="#expressions-electrocuted",
        functionName = "expressions",
        functionParameters =  { "electrocuted_1" }
    },
    ["expressions:grumpy"] = {
        title="Grumpy",
        icon="#expressions-grumpy",
        functionName = "expressions", 
        functionParameters =  { "mood_drivefast_1" }
    },
    ["expressions:happy"] = {
        title="Happy",
        icon="#expressions-happy",
        functionName = "expressions",
        functionParameters =  { "mood_happy_1" }
    },
    ["expressions:injured"] = {
        title="Injured",
        icon="#expressions-injured",
        functionName = "expressions",
        functionParameters =  { "mood_injured_1" }
    },
    ["expressions:joyful"] = {
        title="Joyful",
        icon="#expressions-joyful",
        functionName = "expressions",
        functionParameters =  { "mood_dancing_low_1" }
    },
    ["expressions:mouthbreather"] = {
        title="Mouthbreather",
        icon="#expressions-mouthbreather",
        functionName = "expressions",
        functionParameters = { "smoking_hold_1" }
    },
    ["expressions:normal"]  = {
        title="Normal",
        icon="#expressions-normal",
        functionName = "expressions:clear"
    },
    ["expressions:oneeye"]  = {
        title="One Eye",
        icon="#expressions-oneeye",
        functionName = "expressions",
        functionParameters = { "pose_aiming_1" }
    },
    ["expressions:shocked"]  = {
        title="Shocked",
        icon="#expressions-shocked",
        functionName = "expressions",
        functionParameters = { "shocked_1" }
    },
    ["expressions:sleeping"]  = {
        title="Sleeping",
        icon="#expressions-sleeping",
        functionName = "expressions",
        functionParameters = { "dead_1" }
    },
    ["expressions:smug"]  = {
        title="Smug",
        icon="#expressions-smug",
        functionName = "expressions",
        functionParameters = { "mood_smug_1" }
    },
    ["expressions:speculative"]  = {
        title="Speculative",
        icon="#expressions-speculative",
        functionName = "expressions",
        functionParameters = { "mood_aiming_1" }
    },
    ["expressions:stressed"]  = {
        title="Stressed",
        icon="#expressions-stressed",
        functionName = "expressions",
        functionParameters = { "mood_stressed_1" }
    },
    ["expressions:sulking"]  = {
        title="Sulking",
        icon="#expressions-sulking",
        functionName = "expressions",
        functionParameters = { "mood_sulk_1" },
    },
    ["expressions:weird"]  = {
        title="Weird",
        icon="#expressions-weird",
        functionName = "expressions",
        functionParameters = { "effort_2" }
    },
    ["expressions:weird2"]  = {
        title="Weird 2",
        icon="#expressions-weird2",
        functionName = "expressions",
        functionParameters = { "effort_3" }
    }
}

RegisterNetEvent("menu:setCuffState")
AddEventHandler("menu:setCuffState", function(pTargetId, pState)
    cuffStates[pTargetId] = pState
end)


RegisterNetEvent("isJudge")
AddEventHandler("isJudge", function()
    isJudge = true
end)

RegisterNetEvent("isJudgeOff")
AddEventHandler("isJudgeOff", function()
    isJudge = false
end)

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
    if not isDead then
        isDead = true
    else
        isDead = false
    end
end)

RegisterNetEvent("drivingInstructor:instructorToggle")
AddEventHandler("drivingInstructor:instructorToggle", function(mode)
    if myJob == "driving instructor" then
        isInstructorMode = mode
    end
end)

RegisterNetEvent("police:currentHandCuffedState")
AddEventHandler("police:currentHandCuffedState", function(pIsHandcuffed, pIsHandcuffedAndWalking)
    isHandcuffedAndWalking = pIsHandcuffedAndWalking
    isHandcuffed = pIsHandcuffed
end)

RegisterNetEvent("menu:hasOxygenTank")
AddEventHandler("menu:hasOxygenTank", function(pHasOxygenTank)
    hasOxygenTankOn = pHasOxygenTank
end)

RegisterNetEvent('enablegangmember')
AddEventHandler('enablegangmember', function(pGangNum)
    gangNum = pGangNum
end)

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local closestPed = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        for index,value in ipairs(players) do
            local target = GetPlayerPed(value)
            if(target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
                if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                    closestPlayer = value
                    closestPed = target
                    closestDistance = distance
                end
            end
        end
        return closestPlayer, closestDistance, closestPed
    end
end