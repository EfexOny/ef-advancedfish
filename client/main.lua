--TO DO 
-- LOC DE UNDE IEI MOMEALA [FACUT]
-- TERMINAT PESTE ADVANCED [100%/100%]
-- ADAUGAT LOG DE VANZARE A PESTILOR [FACUT]

--=========================VARS==============

inceput = false 
markda = true 
inZone = false
GataDePescuit = false


--=========================INCEPUT-SHIT==============


RegisterNetEvent('ef-advancedfish:client:notify')
AddEventHandler('ef-advancedfish:client:notify', function(msg, type)
    QBCore.Functions.Notify(msg,type)
end)

function SetupBoss()
	BossHash = Config.pedhash[math.random(#Config.pedhash)]
	loc = Config.PedLocation[math.random(#Config.PedLocation)]
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
	SetupBoss()
    SellBoss()
end

CreateThread(function()
    CreatePeds()
end)


CreateThread(function()
        if not inceput then
            exports['qb-target']:AddTargetModel(Config.pedhash,  {
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
        elseif inceput then
            TriggerEvent("ef-recuperator:client:removetarget")
            exports['qb-target']:AddTargetModel(Config.pedhash, {
                options = {
                    { 
                        type = "client", 
                        event = "ef-advancedfish:client:normalfish",
                        icon = "fas fa-id-card",
                        label = ("Stop working"),
                    },
                    
                },
                distance = 3.0 
            })
        end
        exports['qb-target']:AddTargetModel(Config.pedhash,  {
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
            -- sell target
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
                exports['qb-target']:RemoveTargetModel(Config.pedhash, {
                    ("Stop working")
                })
    
                exports['qb-target']:RemoveTargetModel(Config.pedhash, {
                    ("Start doing the work")
                })
        
            end
        end)

    exports['qb-target']:AddCircleZone("zonamomeala", Config.LocatieMomeala[1],6.0, {
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
                label = "Harvest momeala",
            },
        },
        distance = 2.5
    })

--=========================EVENTS==============

RegisterNetEvent("ef-advancedfish:client:buy",function()
    exports['qb-menu']:openMenu({
        {
            header = 'Rods',
            icon = 'fas fa-code',
            isMenuHeader = true,
        },
        {
            header = Config.Rods[1].name,
            txt = Config.Rods[1].price,
            icon = 'fas fa-code-merge',
            params = {
                isServer = true,
                event = 'ef-advancedfish:server:buyrod',
                args = {
                    items = Config.Rods[1].name,
                    price = Config.Rods[1].price
                }
            }
        },
        {
            header = Config.Rods[2].name,
            txt = Config.Rods[2].price,
            icon = 'fas fa-code-merge',
            params = {
                isServer = true,
                event = 'ef-advancedfish:server:buyrod',
                args = {
                    items = Config.Rods[2].name,
                    price = Config.Rods[2].price
                }
            }
        },
        {
            header = Config.Rods[3].name,
            txt = Config.Rods[3].price,
            icon = 'fas fa-code-merge',
            params = {
                isServer = true,
                event = 'ef-advancedfish:server:buyrod',
                args = {
                    items = Config.Rods[3].name,
                    price = Config.Rods[3].price
                }
            }
        },
        {
            header = Config.Rods[4].name,
            txt = Config.Rods[4].price,
            icon = 'fas fa-code-merge',
            params = {
                isServer = true,
                event = 'ef-advancedfish:server:buyrod',
                args = {
                    items = Config.Rods[4].name,
                    price = Config.Rods[4].price
                }
            }
        },
    })
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
        TriggerEvent("ef-advancedfish:client:notify","You don't have anything to sell","error")
    end
end)

RegisterNetEvent("ef-advancedfish:client:takemomeala",function()
    ped = GetPlayerPed(-1)

    ClearPedTasks(ped)

    QBCore.Functions.Progressbar("search_register", ("Luam rame"), 20000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@",
		anim = "weed_spraybottle_crouch_idle_02_inspector",
		flags = 49,
}, {}, {}, function() 
    amount = math.random(1,10)
    local bait = math.random(1,#Config.Bait)
    TriggerServerEvent("ef-advancedfish:server:add",Config.Bait[bait].name,amount)
    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[Config.Bait[bait].name], "add")
    TriggerEvent("ef-advancedfish:client:notify","You have found bait!","succes")
    ClearPedTasks(ped)
    end)
end)

RegisterNetEvent("ef-advancedfish:client:normalfish",function()
    if not inceput then 
        inceput = true
        TriggerEvent('ef-recuperator:client:notify', "You started fishing.", 'success')
        TriggerEvent("ef-advancedfish:client:fishpoint")
        targetstart()
    else
        inceput = false 
        markda = false
        cleanup()
        TriggerEvent('ef-recuperator:client:notify', "Yout stopped from fishing.", 'success')
        targetstop()
    end
end)

RegisterNetEvent("ef-advancedfish:client:fishpoint",function()
    local random = math.random(#Config.LocatiiPescuitNormal)
    local locatii = Config.LocatiiPescuitNormal[random]
    cleanup()

    markda = true

    exports['qb-target']:AddCircleZone("zonapescuit", Config.LocatiiPescuitNormal[random],3.0, {
        name = "zonapescuit",
        heading = 0,
        useZ = true,
        debugPoly = true,
    }, {
        options = {
            {
                type = "client",
                event = "ef-advancedfish:client:dofish",
                icon = "fas fa-fish",
                label = "Fish",
            },
        },
        distance = 2.5
    })

    ped = GetPlayerPed(-1)
    pos = GetEntityCoords(ped)


    while (math.abs(locatii.x - pos.x) > 1 or math.abs(locatii.y - pos.y) > 1 or math.abs(locatii.z - pos.z) > 1) and markda do
        Wait(1)
        DrawMarker(23, locatii.x,locatii.y,locatii.z,0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, false, 2, nil, nil, false)
end


end)

RegisterNetEvent("ef-advancedfish:client:dofish",function()
    undita = QBCore.Functions.HasItem(Config.Rods[1].name)
    momeala = QBCore.Functions.HasItem("momeala")
    obiect = "momeala"
    markda = true

    if undita and momeala then 
        TriggerEvent("ef-advancedfish:client:notify",'Fishing',"success")
        pescuit()
        TriggerEvent("ef-advancedfish:client:fishpoint")
    elseif not undita then
        TriggerEvent("ef-advancedfish:client:notify","Don't have a rod","error")
    else
        TriggerEvent("ef-advancedfish:client:notify","Don't have bait","error")
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
            TriggerEvent("ef-advancedfish:client:notify","Nu ai nimic an undita","error")
        end
    else
        TriggerEvent("ef-advancedfish:client:notify","Not here","error")
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
                TriggerEvent("ef-advancedfish:client:notify","Ai lanseta ancarcata","error")
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

function pescuit()
    ClearPedTasksImmediately(ped)
    ped = GetPlayerPed(-1)

    TaskStartScenarioInPlace(ped,"WORLD_HUMAN_STAND_FISHING",10000,true)
    QBCore.Functions.Progressbar("search_register", ("Pescuim"), 10000, false, true, {
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
    rewardsnormalfish()
    ClearPedTasksImmediately(ped)

end

function rewardsnormalfish()
    for k,v in pairs (Config.Rods) do 
        if QBCore.Functions.HasItem(Config.Rods[k].name) then
            if Config.Rods[k].type == "small" then
                if math.random(1,100) <= Config.Rods[k].chance then 
                    TriggerServerEvent("ef-advancedfish:server:add",aleger("small"),1)
                else
                    TriggerEvent("ef-advancedfish:client:notify","Nu ai prins nimic","error")
                end
            end
        end
    end
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
        TriggerEvent("ef-advancedfish:client:notify","Nu ai nimic an undita","error")
    end
end


function cleanup()
    markda = false
    exports['qb-target']:RemoveZone("zonapescuit")
    exports['qb-target']:RemoveZone("zonaPescuit")
    exports['qb-target']:RemoveZone("zonamomeala")

end


function targetstart()
        exports['qb-target']:RemoveTargetModel(Config.pedhash, {
            ("Start doing the work")
    })
    exports['qb-target']:AddTargetModel(Config.pedhash, {
        options = {
            { 
                type = "client", 
                event = "ef-advancedfish:client:normalfish",
                icon = "fas fa-id-card",
                label = ("Stop working"),
            },
            
        },
        distance = 3.0 
    })
end

function blipadvanced()
    local blips = {

        {title="fish", colour=1, id=225, x = Config.LocatiePescuitAdvanced[1].x, y = Config.LocatiePescuitAdvanced[1].y, z = Config.LocatiePescuitAdvanced[1].z},
    }

    for k,v in pairs(blips) do
        zoneblip = AddBlipForRadius(v.x,v.y,v.z, 900.0)
                          SetBlipSprite(zoneblip,1)
                          SetBlipColour(zoneblip,49)
                          SetBlipAlpha(zoneblip,75)
    end
end


function targetadvanced()
    local CircleZone = CircleZone:Create(Config.LocatiePescuitAdvanced[1], 100.0, {
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

