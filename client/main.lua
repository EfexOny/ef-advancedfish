
--=========================VARS==============

inceput = false 
mark = true 

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
        cleanup()
        TriggerEvent('ef-recuperator:client:notify', "Te-ai oprit din pescuit!", 'success')
        targetstop()
    end
end)

RegisterNetEvent("ef-advancedfish:client:fishpoint",function()
    local random = math.random(#Config.LocatiiPescuitNormal)
    local locatii = Config.LocatiiPescuitNormal[locat]

    cleanup()


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

end)

RegisterNetEvent("ef-advancedfish:client:dofish",function()
    undita = QBCore.Functions.HasItem("undita")
    momeala = QBCore.Functions.HasItem("momeala")
    obiect = "momeala"

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






--=========================FUNCTII==============

function pescuit()
    
    ClearPedTasksImmediately(ped)
    ped = GetPlayerPed(-1)
    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["momeala"], "remove")
    TriggerServerEvent("ef-advancedfish:server:remove")
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
    rewardsnormalfish()
    ClearPedTasksImmediately(ped)
end

function rewardsnormalfish()
    if math.random(1,100) <= Config.SansePesteNormal then
        TriggerServerEvent("ef-advancedfish:server:givefishrar")
    else
        TriggerServerEvent("ef-advancedfish:server:givefishnormal")
    end
end

function rewardsfishadvanced()

    local lv1 = QBCore.Functions.HasItem("unditalv1") 
    local lv2 = QBCore.Functions.HasItem("unditalv2")
    local lv3 = QBCore.Functions.HasItem("unditalv3")

    
    if lv1 then 
        if math.random(1,100) <= Config.SanseUnditaLV1 then 
            -- peste mare advaned
        elseif lv2 then 
            if math.random(1,100) <= Config.SanseUnditaLV2 then 
                -- peste mare
            elseif lv3 then 
                if math.random(1,100) <= Config.SanseUnditaLV3 then 
                        -- peste mare 
                else
                    -- peste mic 
                end
            end
        end
    end
end

function cleanup()
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