

RegisterNetEvent("ef-advancedfish:server:remove",function() 
    local ply = QBCore.Functions.GetPlayer(source)
    
    ply.Functions.RemoveItem("momeala", 1)
end)



RegisterNetEvent("ef-advancedfish:server:add",function(item,numar) 
    local ply = QBCore.Functions.GetPlayer(source)

    ply.Functions.AddItem(item, numar)
end)

RegisterServerEvent("ef-advancedfish:server:remove2",function(itemremove,nr) 
    local ply = QBCore.Functions.GetPlayer(source)
    ply.Functions.RemoveItem(itemremove, nr)
end)

RegisterNetEvent("ef-advancedfish:server:givefishrare",function()
    local ply = QBCore.Functions.GetPlayer(source)
    ply.Functions.AddItem(Config.PestiRari[math.random(#Config.PestiRari)], 1)
end)

RegisterNetEvent("ef-advancedfish:server:givefish",function(peste)
    local ply = QBCore.Functions.GetPlayer(source)
    
    ply.Functions.AddItem(peste, 1)
end)


RegisterNetEvent("ef-advancedfish:server:givefishadvanced",function(cefeldepesti)
    local ply = QBCore.Functions.GetPlayer(source)
    ply.Functions.AddItem(cefeldepesti[math.random(#cefeldepesti)], 1)
end)


-- iteme


QBCore.Functions.CreateUseableItem("unditalv1", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        TriggerClientEvent("consumables:client:fishadv",source,false)
    end
end)

QBCore.Functions.CreateUseableItem("unditalv3", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)


    if Player.Functions.GetItemByName(item.name) then
        TriggerClientEvent("consumables:client:fishadv",source,false)
    end
end)

QBCore.Functions.CreateUseableItem("unditalv2", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        TriggerClientEvent("consumables:client:fishadv",source,false)
    end
end)

for k=1,8,1 do 
    QBCore.Functions.CreateUseableItem(Config.PestiMiciSiMedii[k], function(source, item)
        local src = source
        itemname = item.name
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent("consumables:client:momealaadv",source,false)
        end
    end)
end

RegisterServerEvent("ef-advancedfish:server:payup",function(i,pesti,mare)
    Player = QBCore.Functions.GetPlayer(source)

    local nr = Player.Functions.GetItemByName(pesti).amount
    
    if not mare then

	    Player.Functions.AddMoney('cash', nr*Config.PricePestiMd[i])
        print(pesti)

    else

	    Player.Functions.AddMoney('cash', nr*Config.PricePestiMar[i])
        print(pesti)

    end
end)

RegisterServerEvent("ef-advancedfish:server:amount", function(peste)
    local ply = QBCore.Functions.GetPlayer(source)

    local amount = ply.Functions.GetItemByName(peste).amount
    print(amount,peste)
    ply.Functions.RemoveItem(peste, amount)
end)

