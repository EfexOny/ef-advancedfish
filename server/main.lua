

RegisterNetEvent("ef-advancedfish:server:remove",function() 
    local ply = QBCore.Functions.GetPlayer(source)
    
    ply.Functions.RemoveItem("momeala", 1)
end)



RegisterNetEvent("ef-advancedfish:server:add",function(item,numar) 
    local ply = QBCore.Functions.GetPlayer(source)

    ply.Functions.AddItem(item, numar)
end)

RegisterServerEvent("ef-advancedfish:server:remove2", function(itemremove,nr) 
    local ply = QBCore.Functions.GetPlayer(source)
    ply.Functions.RemoveItem(itemremove, nr)
end)


RegisterNetEvent("ef-advancedfish:server:givefish",function(peste)
    local ply = QBCore.Functions.GetPlayer(source)
    
    ply.Functions.AddItem(peste, 1)
end)



RegisterNetEvent("ef-advancedfish:server:givefishadvanced",function(cefeldepesti)
    local ply = QBCore.Functions.GetPlayer(source)
    ply.Functions.AddItem(cefeldepesti[math.random(#cefeldepesti)], 1)
end)


--iteme



RegisterServerEvent("ef-advancedfish:server:amount", function(peste)
    local ply = QBCore.Functions.GetPlayer(source)

    local amount = ply.Functions.GetItemByName(peste).amount
    print(amount,peste)
    ply.Functions.RemoveItem(peste, amount)
end)

---------------------------REFACTORED-------------------

RegisterNetEvent("ef-advancedfish:server:sell",function(price,name)
    local Player = QBCore.Functions.GetPlayer(source)
    local many = Player.Functions.GetItemByName(name).amount

    Player.Functions.RemoveItem(name, many)
    Player.Functions.AddMoney("cash", price*many)
end)


RegisterNetEvent("ef-advancedfish:server:buyrod",function(args)

    local ply = QBCore.Functions.GetPlayer(source)
    

    if ply.Functions.RemoveMoney("cash", args.price) then
        ply.Functions.AddItem(args.items,1)
    end
end)


for key,value in pairs(Config.Fish) do 
    QBCore.Functions.AddItems({
        [Config.Fish[key].name] = {
            name = Config.Fish[key].name,
            label = Config.Fish[key].name,
            weight = Config.Fish[key].weight,
            type = 'item',
            image = Config.Fish[key].image,
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = Config.Fish[key].type 
        }
    })
end

for key,value in pairs(Config.Rods) do 
    QBCore.Functions.AddItems({
        [Config.Rods[key].name] = {
            name = Config.Rods[key].name,
            label = Config.Rods[key].name,
            weight = 500,
            type = 'item',
            image = Config.Rods[key].image,
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = "rod"
        }
    })
end

for key,value in pairs(Config.Bait) do 
    QBCore.Functions.AddItems({
        [Config.Bait[key].name] = {
            name = Config.Bait[key].name,
            label = Config.Bait[key].name,
            weight = 100,
            type = 'item',
            image = Config.Bait[key].image,
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = "Bait"
        }
    })
end

for key,value in pairs(Config.Rods) do 
    if value.type == "big" then 
        QBCore.Functions.CreateUseableItem(Config.Rods[key].name, function(source, item)
            local src = source
            local Player = QBCore.Functions.GetPlayer(src)
            if Player.Functions.GetItemByName(item.name) then
                TriggerClientEvent("consumables:client:fishadv",source,false)
            end
        end)
end

for key,value in pairs(Config.Rods) do 
    if value.type == "small" then
        QBCore.Functions.CreateUseableItem(Config.Rods[key].name, function(source, item)
            local src = source
            local Player = QBCore.Functions.GetPlayer(src)
            if Player.Functions.GetItemByName(item.name) then
                TriggerClientEvent("consumables:client:normalfish",source,false)
            end
        end)
    end    
end

for key,value in pairs(Config.Fish) do
        if Config.Fish[key].type == "small" then 
            QBCore.Functions.CreateUseableItem(Config.Fish[key].name, function(source, item)
                local src = source
                itemname = item.name
                local Player = QBCore.Functions.GetPlayer(src)
                if Player.Functions.RemoveItem(item.name, 1, item.slot) then
                    TriggerClientEvent("consumables:client:momealaadv",source,false)
                end
        end)
        end
    end
end 

