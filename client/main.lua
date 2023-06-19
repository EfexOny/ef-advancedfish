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

RegisterNetEvent("ef-advancedfish:client:sellallfish",function()
    local amvandut = false
    local mare = false
    for i=1,8,1 do 

        Wait(20)
        pesti = Config.PestiMiciSiMedii[i]

        if QBCore.Functions.HasItem(pesti) then 
            TriggerServerEvent("ef-advancedfish:server:payup",i,pesti,mare,special)
            TriggerServerEvent("ef-advancedfish:server:amount",pesti)
            amvandut = true
            
     end
    end

    special = true
    for i=1,1,1 do 

        Wait(20)
        pesti = Config.PestiRari[i]

        if QBCore.Functions.HasItem(pesti) then 
            TriggerServerEvent("ef-advancedfish:server:payup",i,pesti,mare,special)
            TriggerServerEvent("ef-advancedfish:server:amount",pesti)
            amvandut = true
            
     end
    end 

    mare = true
    for i=1,5,1 do 

        Wait(20)
        pesti = Config.PestiMari[i]

        if QBCore.Functions.HasItem(pesti) then 
            TriggerServerEvent("ef-advancedfish:server:payup",i,pesti,mare,special)
            TriggerServerEvent("ef-advancedfish:server:amount",pesti)
            amvandut = true
            
     end
    end 

   
    


    if not amvandut then 
        TriggerEvent("ef-advancedfish:client:notify","Nu ai varule ce sa vinzi","error")
        
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
    StopAnimTask(ped, "mp_suicide", "pill", 1.0)
    amount = math.random(1,10)
    TriggerServerEvent("ef-advancedfish:server:add","momeala",amount)
    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["momeala"], "add")
    TriggerEvent("ef-advancedfish:client:notify","Ai gasit momeala","succes")
    ClearPedTasks(ped)
    end)
end)

RegisterNetEvent("ef-advancedfish:client:normalfish",function()
    if not inceput then 
        inceput = true
        TriggerEvent('ef-recuperator:client:notify', "Ai inceput sa pescuiesti!", 'success')
        TriggerEvent("ef-advancedfish:client:fishpoint")
        targetstart()
    else
        inceput = false 
        markda = false
        cleanup()
        TriggerEvent('ef-recuperator:client:notify', "Te-ai oprit din pescuit!", 'success')
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

    ped= GetPlayerPed(-1)
    pos = GetEntityCoords(ped)


    while (math.abs(locatii.x - pos.x) > 1 or math.abs(locatii.y - pos.y) > 1 or math.abs(locatii.z - pos.z) > 1) and markda do
        Wait(1)
        DrawMarker(23, locatii.x,locatii.y,locatii.z,0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, false, 2, nil, nil, false)
end


end)

RegisterNetEvent("ef-advancedfish:client:dofish",function()
    undita = QBCore.Functions.HasItem("undita")
    momeala = QBCore.Functions.HasItem("momeala")
    obiect = "momeala"
    markda = true

    if undita and momeala then 
        TriggerEvent("ef-advancedfish:client:notify",'Te-ai pus pe pescuit!',"success")
        pescuit()
        TriggerEvent("ef-advancedfish:client:fishpoint")
    elseif not undita then
        TriggerEvent("ef-advancedfish:client:notify",'Nu ai cu sa pescuiesti!',"error")
    else
        TriggerEvent("ef-advancedfish:client:notify",'N-am cum sa bag undita fara momeala, du-te anschilopatule sa iei momeala!',"error")
    end
end)

RegisterCommand("testpesti",function()
    impMici()
end)

RegisterCommand("momeala",function()
    GataDePescuit = true
end)


RegisterCommand("testpesti2",function()
    pesteavansat()
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
        rewardsfishadvanced()
        GataDePescuit = false
        ClearPedTasksImmediately(ped)
    elseif inZone == false then 
        TriggerEvent("ef-advancedfish:client:notify","Nu aici se pescueisti boss","error")
    else
        TriggerEvent("ef-advancedfish:client:notify","Nu ai nimic an undita","error")
    end
end)

RegisterNetEvent("consumables:client:momealaadv")
AddEventHandler("consumables:client:momealaadv", function(itemname)
    impMici()
end)


--=========================FUNCTII==============

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
    TriggerServerEvent("ef-advancedfish:server:remove2",data)
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
    if math.random(1,100) <= Config.SansePesteNormal then
        peste = Config.PestiRari[math.random(#Config.PestiRari)]
        TriggerServerEvent("ef-advancedfish:server:givefish",peste)
    elseif math.random(1,100) <= Config.SansePesti then
        TriggerEvent("ef-advancedfish:client:notify","Nu ai prins nimic","error")
    else
        peste = Config.PestiMiciSiMedii[math.random(#Config.PestiMiciSiMedii)]
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[peste], "add")
        TriggerServerEvent("ef-advancedfish:server:givefish",peste)
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

function rewardsfishadvanced()

    local lv1 = QBCore.Functions.HasItem("unditalv1") 
    local lv2 = QBCore.Functions.HasItem("unditalv2")
    local lv3 = QBCore.Functions.HasItem("unditalv3")

    
    if lv3 then 
        sansalv3()
    elseif lv2 then
        sansalv2()
    else
        sansalv1()
    end
end

function sansalv3() 
        if math.random(1,100) <= Config.SanseUnditaLV3 then 
            peste4 = Config.PestiMari[math.random(#Config.PestiMari)]
            TriggerServerEvent("ef-advancedfish:server:givefish",peste4)
    end
end

function sansalv2() 
    if math.random(1,100) <= Config.SanseUnditaLV2 then 
        peste3 = Config.PestiMari[math.random(#Config.PestiMari)]
        TriggerServerEvent("ef-advancedfish:server:givefish",peste3)
end
end

function sansalv1() 
    if math.random(1,100) <= Config.SanseUnditaLV1 then 
        peste1 = Config.PestiRari[math.random(#Config.PestiRari)]
        TriggerServerEvent("ef-advancedfish:server:givefish",peste1)
    else
        peste2 = Config.PestiMari[math.random(#Config.PestiMari)]
        TriggerServerEvent("ef-advancedfish:server:givefish",peste2)

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