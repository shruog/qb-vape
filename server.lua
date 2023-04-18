local QBCore = exports['qb-core']:GetCoreObject()
local Debug = exports['qb-vape']:Debug()

-- event to sync particle smoke with all players
RegisterNetEvent("sh-vape:server_effect_smoke", function(entity)
    TriggerClientEvent("sh-vape:client_effect_smoke", -1, entity)
end)

QBCore.Functions.CreateUseableItem("vape", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    local citizenId = Player.PlayerData.citizenid
   -- local vapeInSlot = Player.PlayerData.items[item.slot]

    if not Player.Functions.GetItemByName('vape') then
        return
    end
    
    TriggerClientEvent('QBCore:Notify', source, Lang:t("info.used_vape"), "success")
    TriggerClientEvent("sh-vape:startUseVape", source)
end)

