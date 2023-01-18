

RegisterNetEvent("ef-advancedfish:server:remove",function() 
    local ply = QBCore.Functions.GetPlayer(source)
    ply.Functions.RemoveItem("momeala", 1)
end)

RegisterServerEvent("ef-advancedfish:server:removetest",function(itemremove) 
    local ply = QBCore.Functions.GetPlayer(source)
    ply.Functions.RemoveItem(item, 1)
end)

RegisterNetEvent("ef-advancedfish:server:givefishrare",function()
    local ply = QBCore.Functions.GetPlayer(source)
    ply.Functions.AddItem(Config.PestiRari[math.random(#Config.PestiRari)], 1)
end)

RegisterNetEvent("ef-advancedfish:server:givefishnormal",function(cefeldepesti)
    local ply = QBCore.Functions.GetPlayer(source)
    ply.Functions.AddItem(Config.PestiMiciSiMedii[math.random(#Config.PestiMiciSiMedii)], 1)
end)


RegisterNetEvent("ef-advancedfish:server:givefishadvanced",function(cefeldepesti)
    local ply = QBCore.Functions.GetPlayer(source)
    ply.Functions.AddItem(cefeldepesti[math.random(#cefeldepesti)], 1)
end)

RegisterServerEvent("ef-advancedfish:server:blipadvanced",function()
    AddBlipForRadius(Config.LocatiePescuitAdvanced[1].x,Config.LocatiePescuitAdvanced[1].y,Config.LocatiePescuitAdvanced[1].z,100)
    SetBlipColour(blip, 1)
    SetBlipAlpha(blip, 128)
end)