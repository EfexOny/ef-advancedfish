
--=========================VARS==============

inceput = false 
markda = true 
inZone = false
inZone1 = false
GataDePescuit = false


--=========================INCEPUT-SHIT==============


RegisterNetEvent('ef-advancedfish:client:notify')
AddEventHandler('ef-advancedfish:client:notify', function(msg, type)
    QBCore.Functions.Notify(msg,type)
end)


function SellBoss()
	BossHash = Config.pedhashseller[math.random(#Config.pedhashseller)]
	loc = Config.SellLocation[math.random(#Config.SellLocation)]
	QBCore.Functions.LoadModel(BossHash)
    Boss = CreatePed(0, BossHash, loc.x, loc.y, loc.z-1.0, loc.w, false, false)
    SetPedFleeAttributes(Boss, 0, 0)
    SetPedDiesWhenInjured(Boss, false)
    TaskStartScenarioInPlace(Boss, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
    SetPedKeepTask(Boss, true)
    SetBlockingOfNonTemporaryEvents(Boss, true)
    SetEntityInvincible(Boss, true)
    FreezeEntityPosition(Boss, true)
end

function DeleteBoss()
    local player = PlayerPedId()
	if DoesEntityExist(Boss) then
        ClearPedTasks(Boss) 
		ClearPedTasksImmediately(Boss)
        ClearPedSecondaryTask(Boss)
        FreezeEntityPosition(Boss, false)
        SetEntityInvincible(Boss, false)
        SetBlockingOfNonTemporaryEvents(Boss, false)
        TaskReactAndFleePed(Boss, player)
		SetPedAsNoLongerNeeded(Boss)
		Wait(8000)
		DeletePed(Boss)
        SetupBoss()
	end
end

function CreatePeds()
	-- SetupBoss()
    SellBoss()
end

CreateThread(function()
    CreatePeds()
end)


CreateThread(function()
        exports['qb-target']:AddTargetModel(Config.pedhashseller,  {
            options = {
                { 
                    type = "client", 
                    event = "ef-advancedfish:client:sellallfish",
                    icon = "fas fa-percent",
                    label = ("Sell your fish!"),
                },
                {
                    type = "client",
                    event = "ef-advancedfish:client:buy",
                    icon= "fab fa-jira",
                    label = ("Buy rods"),
                },
                
            },
            distance = 3.0 
        })
end)

    AddEventHandler('onResourceStop', function(r)
        if r == GetCurrentResourceName()
        then
            cleanup()
            end
        end)

    exports['qb-target']:AddCircleZone("zonamomeala", Config.BaitLocation[1],6.0, {
        name = "zonamomeala",
        heading = 0,
        useZ = true,
        debugPoly = false,
    }, {
        options = {
            {
                type = "client",
                event = "ef-advancedfish:client:takemomeala",
                icon = "fas fa-frog",
                label = "Harvest bait",
            },
        },
        distance = 2.5
    })

--=========================EVENTS==============

RegisterNetEvent("ef-advancedfish:client:buy",function()
    if type(Config.Rods) ~= 'table' then
        print('Error: Config.Rods is not a table!')
        return
    end
    
    
    local menuItems = {
        {
            header = 'Rods',
            icon = 'fas fa-code',
            isMenuHeader = true,
        }
    }
    
    
    for k,v in pairs(Config.Rods) do 
        table.insert(menuItems, {
            header = v.name,
            txt = v.price, 
            icon = 'fas fa-code-merge',
            params = {
                isServer = true,
                event = 'ef-advancedfish:server:buyrod',
                args = {
                    items = v.name,
                    price = v.price
                }
            }
        })
    end
    
    
    exports['qb-menu']:openMenu(menuItems)
end)




RegisterNetEvent("ef-advancedfish:client:sellallfish",function()
    local sold = false
    for k,v in pairs(Config.Fish) do
        if  QBCore.Functions.HasItem(Config.Fish[k].name) then
            local price = Config.Fish[k].price
            local name = Config.Fish[k].name
            TriggerServerEvent("ef-advancedfish:server:sell",price,name)
            sold = true
    end
end
    if not sold then 
        TriggerEvent("ef-advancedfish:client:notify",Config.Text[1].EN,"error")
    end
end)

RegisterNetEvent("ef-advancedfish:client:takemomeala",function()
    ped = GetPlayerPed(-1)

    ClearPedTasks(ped)

    QBCore.Functions.Progressbar("search_register", ("Taking bait"), 20000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@",
		anim = "weed_spraybottle_crouch_idle_02_inspector",
		flags = 49,
}, {}, {}, function() 
    amount = math.random(1,Config.MaxBait)
    local bait = math.random(1,#Config.Bait)
    TriggerServerEvent("ef-advancedfish:server:add",Config.Bait[bait].name,amount)
    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[Config.Bait[bait].name], "add")
    TriggerEvent("ef-advancedfish:client:notify","You have found bait!","succes")
    ClearPedTasks(ped)
    end)
end)

RegisterNetEvent("consumables:client:normalfish",function(itemName)
    undita = false
    momeala = false

    for k,v in pairs (Config.Rods) do
        if Config.Rods[k].type == "small" then
            if QBCore.Functions.HasItem(Config.Rods[k].name) then
                undita = true
            end
        end 
    end

    for k,v in pairs(Config.Bait) do
        if QBCore.Functions.HasItem(Config.Bait[k].name) then
            momeala = true
        end
    end
    
    print(inZone1)
    
    print(momeala)
    print(undita)

    if inZone1 then 
        if undita then 
           if momeala then 
                ClearPedTasksImmediately(ped)
                ped = GetPlayerPed(-1)
            
                TaskStartScenarioInPlace(ped,"WORLD_HUMAN_STAND_FISHING",10000,true)
                QBCore.Functions.Progressbar("search_register", ("Fishing"), 10000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                }, {}, {}, function() 
                end)
                Wait(10000)
                ClearPedTasksImmediately(ped)
                TriggerServerEvent("ef-advancedfish:server:remove")
                TriggerServerEvent("ef-advancedfish:server:add",aleger("small"))
                ClearPedTasksImmediately(ped)
            else
            TriggerEvent("ef-advancedfish:client:notify","error",Config.Text[2].EN)
            end
        else
            TriggerEvent("ef-advancedfish:client:notify","error",Config.Text[3].EN)
        end
    else
        TriggerEvent("ef-advancedfish:client:notify","error",Config.Text[4].EN)
    end
end)

CreateThread(function()
    Wait(0)
    blipadvanced()
    targetadvanced()
end)

RegisterNetEvent("ef-advancedfish:client:pescuitavansat",function()
    pesteavansat()
end)

RegisterNetEvent("consumables:client:fishadv")
AddEventHandler("consumables:client:fishadv", function(itemName)
    ped = GetPlayerPed(-1)
    if inZone then
        if GataDePescuit then 
            ClearPedTasksImmediately(ped)
            TaskStartScenarioInPlace(ped,"WORLD_HUMAN_STAND_FISHING",10000,true)
            QBCore.Functions.Progressbar("search_register", ("Pescuim *avansat*"), 10000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
            }, {}, {}, function() 
            end)
            Wait(10000)
            rewards()
            GataDePescuit = false
            ClearPedTasksImmediately(ped)
        else
            TriggerEvent("ef-advancedfish:client:notify",Config.Text[5].EN,"error")
        end
    else
        TriggerEvent("ef-advancedfish:client:notify",Config.Text[4].EN,"error")
    end
end)

RegisterNetEvent("consumables:client:momealaadv")
AddEventHandler("consumables:client:momealaadv", function(itemname)
    impMici()
end)


--=========================FUNCTII==============

function rewards()

    for k,v in pairs (Config.Rods) do 
        if QBCore.Functions.HasItem(Config.Rods[k].name) then
            if Config.Rods[k].type == "big" then
                if math.random(1,100) <= Config.Rods[k].chance then 
                    TriggerServerEvent("ef-advancedfish:server:add",aleger("rare"),1)
                else
                    TriggerServerEvent("ef-advancedfish:server:add",aleger("medium"),1)
                end
            end
        end
    end
end

function aleger(typer)
    local fish = {}
    local i = 1  
    for k, v in pairs(Config.Fish) do
        if Config.Fish[k].type == typer then
            fish[i] = Config.Fish[k].name 
            i = i + 1
        end
    end

    if #fish > 0 then
        return fish[math.random(1, #fish)]
    else
        return nil  
    end
end

function impMici()
        if  GataDePescuit == false then 
                    momealaavansat()
            elseif GataDePescuit == true then 
                TriggerEvent("ef-advancedfish:client:notify",Config.Text[7].EN,"error")
    end
end

function momealaavansat()
    ClearPedTasksImmediately(ped)
    ped = GetPlayerPed(-1)

    TaskStartScenarioInPlace(ped,"WORLD_FISH_IDLE",10000,true)
    QBCore.Functions.Progressbar("search_register", ("Bagam pestele sa prinzi al mare rechin"), 10000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
    }, {}, {}, function() 
    end)
    Wait(10000)
    ClearPedTasksImmediately(ped)
    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[data], "remove")
    -- TriggerServerEvent("ef-advancedfish:server:remove2",data)
    ClearPedTasksImmediately(ped)
    GataDePescuit = true
end

function pesteavansat()
    ClearPedTasksImmediately(ped)
    ped = GetPlayerPed(-1)
   
    if GataDePescuit then 
        TaskStartScenarioInPlace(ped,"WORLD_HUMAN_STAND_FISHING",10000,true)
        QBCore.Functions.Progressbar("search_register", ("Pescuim *avansat*"), 10000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
        }, {}, {}, function() 
        end)
        Wait(10000)
        rewardsfishadvanced()
        GataDePescuit = false
        ClearPedTasksImmediately(ped)
    else    
        TriggerEvent("ef-advancedfish:client:notify",Config.Text[6].EN,"error")
    end
end


function cleanup()
    markda = false
    exports['qb-target']:RemoveZone("zonamomeala")

end


function blipadvanced()
    local blips = {

        {title="fish", colour=1, id=225, x = Config.AdvancedFishLocation[1].x, y = Config.AdvancedFishLocation[1].y, z = Config.AdvancedFishLocation[1].z},
    }

    for k,v in pairs(blips) do
        zoneblip = AddBlipForRadius(v.x,v.y,v.z, 900.0)
                          SetBlipSprite(zoneblip,1)
                          SetBlipColour(zoneblip,49)
                          SetBlipAlpha(zoneblip,75)
    end
end




function targetadvanced()
    local CircleZone = CircleZone:Create(Config.AdvancedFishLocation[1], 100.0, {
        name="circle_zone",
        debugPoly=false,
    })
    CircleZone:onPlayerInOut(function(isPointInside)
        if isPointInside then 
            inZone = true
        else
            inZone = false
        end
    end)

    local CircleZone1 = CircleZone:Create(Config.FishNormalLocation[1], 11.0, {
        name="circle_normal",
        debugPoly=false,
    })
    
    CircleZone1:onPlayerInOut(function(isPointInside)
        if isPointInside then 
            inZone1 = true
        else
            inZone1 = false
        end
    end)
end





function targetstop()
    exports['qb-target']:RemoveTargetModel(Config.pedhash, {
        ("Stop working")
    })
    exports['qb-target']:AddTargetModel(Config.pedhash, {
        options = {
            { 
                type = "client", 
                event = "ef-advancedfish:client:normalfish",
                icon = "fas fa-id-card",
                label = ("Start doing the work"),
            },
            
        },
        distance = 3.0 
    })
end

