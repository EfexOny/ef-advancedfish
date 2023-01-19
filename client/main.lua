--TO DO 
-- LOC DE UNDE IEI MOMEALA
-- TERMINAT PESTE ADVANCED
-- ADAUGAT LOG DE VANZARE A PESTILOR

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
    




--=========================EVENTS==============


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


CreateThread(function()
    Wait(1)
    blipadvanced()
    targetadvanced()
end)


RegisterNetEvent("ef-advancedfish:client:pescuitavansat",function()
    impMici()
    pesteavansat()
end)


--=========================FUNCTII==============

function impMici()
    for i=1,15,1 do
        data = Config.PestiMiciSiMedii[i]
        hasItem = QBCore.Functions.HasItem(data) 
        if hasItem then 
                momealaavansat()
                TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[data], "remove")
                TriggerServerEvent("ef-advancedfish:server:remove2",data)
            break
        else
            TriggerEvent("ef-advancedfish:client:notify","Nu ai cu ce sa incarci lanseta","error")
            break
        end
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
        TriggerServerEvent("ef-advancedfish:server:remove")
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
        ClearPedTasksImmediately(ped)
        rewardsfishadvanced()
        ClearPedTasksImmediately(ped)
    else    
        TriggerEvent("ef-advancedfish:client:notify","Nu ai nimic an undita","error")
    end
end

function rewardsfishadvanced()

    local lv1 = QBCore.Functions.HasItem("unditalv1") 
    local lv2 = QBCore.Functions.HasItem("unditalv2")
    local lv3 = QBCore.Functions.HasItem("unditalv3")

    
    if lv1 then 
        if math.random(1,100) <= Config.SanseUnditaLV1 then 
            peste = Config.PestiRari[math.random(#Config.PestiMari)]
            TriggerServerEvent("ef-advancedfish:server:givefish",peste)
        elseif lv2 then 
            if math.random(1,100) <= Config.SanseUnditaLV2 then 
                peste = Config.PestiRari[math.random(#Config.PestiMari)]
            TriggerServerEvent("ef-advancedfish:server:givefish",peste)
            elseif lv3 then 
                if math.random(1,100) <= Config.SanseUnditaLV3 then 
                    peste = Config.PestiRari[math.random(#Config.PestiMari)]
                    TriggerServerEvent("ef-advancedfish:server:givefish",peste)
                else
                    peste = Config.PestiRari[math.random(#Config.PestiMiciSiMedii)]
                    TriggerServerEvent("ef-advancedfish:server:givefish",peste)
                end
            end
        end
    end
end

function cleanup()
    markda = false
    exports['qb-target']:RemoveZone("zonapescuit")
    exports['qb-target']:RemoveZone("zonaPescuit")
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
    radiusBlip = AddBlipForRadius(v.x,v.y,v.z,1100.0)
    SetBlipSprite(radiusBlip,1)
    SetBlipColour(radiusBlip,49)
    SetBlipAlpha(radiusBlip,1)
    end
end


function targetadvanced()
    local CircleZone = CircleZone:Create(Config.LocatiePescuitAdvanced[1], 100.0, {
        name="circle_zone",
        debugPoly=true,
    })
    CircleZone:onPlayerInOut(function(isPointInside)
        if isPointInside then 
            inZone = true
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